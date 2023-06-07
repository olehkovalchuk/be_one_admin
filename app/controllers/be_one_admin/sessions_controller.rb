module BeOneAdmin
  class SessionsController < ::BeOneAdmin::ApplicationController
    layout "be_one_admin/login"
    skip_before_action :require_login, only: [:login,:forgot,:restore,:sign_in]

    def login
      if current_admin
        redirect_to :admin_root
      else
        render layout: "be_one_admin/login"
      end
    end

    def sign_in
      process_and_respond!(operation: BeOneAdmin::UserOperation::SignIn.new( request_merge( login_params ) ) ) do |operation, result|
        session[:admin_token] = result
        redirect_to :admin_root  
      end
    end
    def logout
      process_and_respond!(operation: BeOneAdmin::UserOperation::Logout.new( request_merge(  user: current_admin ) ) ) do |operation, result|
        redirect_to :admin_root
      end
    end

    def forgot
      if current_admin
        redirect_to :admin_root
      else
        render layout: "be_one_admin/login"
      end
    end

    def restore
      process_and_respond!(operation: BeOneAdmin::UserOperation::Restore.new( request_merge( restore_params ) ) ) do |operation, result|
        render_as_json( {success: true, message: I18n.t("admin.instructions_was_sended_to_email") } )
      end
    end
    def remind
      process_and_respond!(operation: BeOneAdmin::UserOperation::ResetPassword.new( request_merge(  code: params[:code] ) ) ) do |operation, result|
        flash[:message] = I18n.t("admin.new_password_sended")
        redirect_to :admin_root
      end
    end

    private
    def request_merge _params
      _params.merge(
        token: session[:admin_token], 
        ip: request.remote_ip, 
        referer: request.referer, 
        user_agent: request.user_agent
      )
    end
    def login_params
      params.require(:login).permit(:email,:password)
    end
    def restore_params
      params.require(:login).permit(:email)
    end

  end
end



