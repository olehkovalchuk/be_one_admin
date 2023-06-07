module BeOneAdmin
  class ApplicationController < ApplicationController

    protect_from_forgery with: :exception
    around_action :set_locale, if: :current_admin
    around_action :set_globals
    before_action :require_login
    after_action :set_csrf_cookie_for_ng
    helper_method :current_admin
    before_action :set_paper_trail_whodunnit



    include BeOneAdmin::ApplicationHelper 

    def not_found
      render layout: 'be_one_admin/404', inline: "",  status: :not_found
    end

    protected

    def set_locale
      cookies[:locale] = current_admin.locale unless I18n.available_locales.include?(cookies[:locale].to_s.to_sym)
      I18n.with_locale(cookies[:locale]) do
        yield
      end
    end

    def require_login
      if current_admin
        RequestStore.store[:resource_scope] = get_resource_scope
      else
        if request.xhr?
          render_as_json( { success: false, message: I18n.t('admin.session_expired'), status: 401 } )
        else
          redirect_to admin_login_path
        end
      end
    end

    def current_admin
      return @current_admin if @current_admin
      RequestStore.store[:journal_parametrizer] = ::BeOneAdmin::Logger
      RequestStore.store[:request_id] = request.env['action_dispatch.request_id']
      RequestStore.store[:request] = request
      RequestStore.store[:user_token] = cookies[:admin_uniq_token]
      @current_admin = BeOneAdmin::UserOperation::Authentificate.new(token: session[:admin_token], ip: request.remote_ip, user_agent: request.user_agent).process if session[:admin_token]
    end

    def set_user_token
      cookies[:admin_uniq_token] = get_new_token unless "#{cookies[:admin_uniq_token]}".first(4) == Time.zone.now.strftime('%d%m')
    end

    def get_new_token
      [Time.zone.now.strftime('%d%m'), 6.times.map{ rand(9) }.join].join
    end

    def set_csrf_cookie_for_ng
      cookies['XSRF-TOKEN'] = form_authenticity_token if protect_against_forgery?
    end

    def verified_request?
      super || valid_authenticity_token?(session, request.headers['X-XSRF-TOKEN']) || valid_authenticity_token?(session, request.headers['X-XCRF-TOKEN'.downcase])
    end

    def set_globals
      ::Journal.safe_action(params.to_unsafe_h.merge(has_parent: false, args: params.to_unsafe_h.except('controller', 'action'))) do
        set_user_token
        set_app_config
        RequestStore.store[:request_id] = request.env['action_dispatch.request_id']
        RequestStore.store[:request] = request
        RequestStore.store[:user_token] = cookies[:admin_uniq_token]
        if session[:admin_token]
          RequestStore.store[:current_admin] = current_admin
          session.delete(:admin_token) unless !!RequestStore.store[:current_admin]
          raise Exception, "Method is unpermited" if RequestStore.store[:current_admin] && !user_can?(params[:action])
        end
        yield
      end
    end

    def get_resource_scope
      if current_admin.has_root_resource_scope
        {}
      else
        {
          with_children: current_admin.has_child_resource_scope,
          conditions: {
            path: current_admin.path
          }
        }
      end
    end

    def set_app_config
      @app_config = {
        path: BeOneAdmin.config.route
      }
    end

    def user_for_paper_trail
      current_admin.try(:email) || 'Unathorized'
    end

    def info_for_paper_trail
      { ip: request.remote_ip, user_agent: request.user_agent }
    end

  end
end

