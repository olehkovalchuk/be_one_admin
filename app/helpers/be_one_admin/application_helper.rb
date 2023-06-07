module BeOneAdmin
  module ApplicationHelper
    def title_tag
      t("admin.app_title_admin")
    end
    def login_desc
      t("admin.desc")
    end

    def user_can?(_action)
      _action = _action.to_s

      return true if Rails.env.development? || (["be_one_admin/sessions","be_one_admin/notifications","be_one_admin/access","be_one_admin/main","main"].include?(params[:controller]) || ["welcome","login", "not_found"].include?(_action))

      ctrl =  params[:controller].split("/")[1..-1]

      ctrl = case ctrl.size
      when 1
        ctrl[0].camelize
      when 2
        "#{ctrl[0].camelize}::#{ctrl[1].camelize}"
      when 3
        "#{ctrl[0].camelize}::#{ctrl[1].camelize}::#{ctrl[2].camelize}"
      end

      return current_admin.permissions.key?(ctrl) && current_admin.permissions[ctrl].include?( _action )
    end

    def render_menu(admin)
      menu_keys = admin.permissions.inject([]){|arr,(k,v)|  if v.include?("index"); arr.push(k) ;end; arr }
      
      tree_hash = BeOneAdmin::Menu.where(controller: menu_keys).each_with_object({}) do |menu, tree|
        (tree[menu.parent_id.to_i.to_s] ||= []) << menu.id
      end

      parents_list = tree_hash.except('0').keys.map(&:to_i).concat(tree_hash['0'] || [])

      content_tag(:ul, class: 'nav', "data-no-turbolink" => true, ng_init: 'leftSidebar.setCurrentLink()') do
        concat content_tag(:li, I18n.t('admin.navigation'), class: 'nav-header')
        concat(
          Hash[BeOneAdmin::Menu.includes(:children).where(id: parents_list).order('position ASC').all.map do |parent|
           [parent, parent.children.select { |c| tree_hash[parent.id.to_s]&.include?(c.id) }.sort_by(&:position)]
          end].each_pair.inject('') do |html, (parent, childrens)|
            html += render_menu_item(parent, childrens)
          end.html_safe
        )
        concat(
          content_tag(:li) do
            content_tag(
              :a, href: :'javascript:;', class: 'sidebar-minify-btn',
              data: { no_turbolink: true, click: 'sidebar-minify' }
            ) { content_tag(:i, nil, class: 'fa fa-angle-double-left') }
          end
        )
      end.html_safe
    end

    def render_menu_item(parent, childrens)
      return '' unless childrens.any?
      get_route = ->(controller){
        controller = "#{controller.pluralize.underscore.tr('/', '_').downcase}"
        if BeOneAdmin::Engine.routes.named_routes.instance_variable_get("@url_helpers").to_a.include?(:"#{controller}_url") 
          send("#{controller}_path") 
        else 
          Rails.application.routes.url_helpers.send("#{BeOneAdmin.config.route}_#{controller}_path")
        end
        
      }
      module_name = parent.controller.underscore
      content_tag(:li, class: 'has-sub', ng_class: "{ 'active': activeModule == '#{module_name}' }") do
        concat(
          if 1 == childrens.size
            begin

              link_path = get_route.(childrens[0].controller)
              content_tag(:a, href: link_path, ng_class: "{ 'active': activeLink == '#{link_path}' }" ) do
                concat content_tag(:i, nil, class: "fa #{childrens[0].icon.presence || 'fa-align-left'}")
                concat content_tag(:span, childrens[0].title)
              end
            rescue StandardError => e
              raise e
              next
            end
          else
            content_tag(:a, href: :'javascript:;', data: { no_turbolink: true }) do
              concat content_tag(:b, nil, class: 'caret pull-right')
              concat content_tag(:i, nil, class: "fa #{parent.icon.presence || 'fa-align-left'}")
              concat content_tag(:span, parent.title)
            end
          end

        )


        concat(
          content_tag(:ul, class: 'sub-menu') do
            childrens.each_with_object('') do |children, html|
              begin
                link_path = get_route.(children.controller)
                html << content_tag(:li, ng_class: "{ 'active': activeLink == '#{link_path}' }") do
                  content_tag(:a, children.title, href: link_path)
                end
              rescue StandardError
                next
              end
            end.html_safe
          end
        ) unless 1 == childrens.size
      end
    end

    def render_breadcrumbs( links = [] )
      content_tag(:ol, class: 'breadcrumb pull-right' ) do
        [[t("admin.main_dashboard"),admin_root_path]].concat(links).map.with_index(0) do |link,idx|
          content_tag(:li,class:"breadcrumb-item #{links.count == idx ? 'active' : ''}") do
            content_tag(:a, link[0], href: link[1] )
          end
        end.join('<span>→</span>').html_safe
      end
    end

    def module_header
      content_for?(:module_header) ||  I18n.t("admin.default_module_header")
    end

  end
end
