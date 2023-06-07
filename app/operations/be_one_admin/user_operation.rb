module BeOneAdmin
  module UserOperation
    class Base
      include Operation::Base
      crudify except: [:create], with: [:habtm, :habtm_update, :history] do
        model_name User
      end
    end

    class Create < Base
      def perform
        unless form.has_root_resource_scope
          @model = BeOneAdmin::User.new(
            email: form.email,
            first_name: form.first_name,
            last_name: form.last_name,
            title: form.title,
            permissions: {"Geo"=>["access", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Chat"=>["access", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Shop"=>["access", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Order"=>["access", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Content"=>["access", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Service"=>["access", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Customer"=>["access", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Delivery"=>["access", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Journals"=>["access", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Security"=>["access", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Settings"=>["access", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Statistic"=>["access", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Geo::Ports"=>["index", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Geo::Regions"=>["index", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Order::Carts"=>["template", "_prepare_form_data", "_setup_filter_variables", "index", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Order::Items"=>["permitted_attributes", "_prepare_form_data", "_setup_filter_variables", "update", "index", "show", "new", "edit", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Order::Notes"=>["index", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Order::Parts"=>["_prepare_form_data", "index", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Shop::Depots"=>["index", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Shop::Prices"=>["permitted_attributes", "_prepare_form_data", "_setup_filter_variables", "update", "index", "show", "new", "edit", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Content::Faqs"=>["_prepare_form_data", "index", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Geo::SeaLines"=>["index", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Chat::Contacts"=>["index", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Chat::Messages"=>["create", "_prepare_form_data", "index", "show", "new", "edit", "update", "destroy", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Content::Pages"=>["index", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Content::Posts"=>["index", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Delivery::Cars"=>["_prepare_form_data", "index", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Geo::Countries"=>["index", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Journals::Logs"=>["index", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Order::Returns"=>["create", "_prepare_form_data", "permitted_attributes", "index", "show", "new", "edit", "update", "destroy", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Shop::Features"=>["index", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Shop::Managers"=>["_prepare_form_data", "index", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Shop::Products"=>["update", "show_prices", "export", "upload", "permitted_attributes", "_prepare_form_data", "upload_product", "_setup_filter_variables", "remove_attach", "index", "show", "new", "edit", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "history"], "Chat::Feedbacks"=>["index", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Customer::Users"=>["_prepare_form_data", "index", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Delivery::Steps"=>["_prepare_form_data", "index", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Settings::Menus"=>["index", "move", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Settings::Roles"=>["index", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Settings::Users"=>["index", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Customer::Points"=>["_prepare_form_data", "_setup_filter_variables", "index", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Delivery::Routes"=>["create", "_prepare_form_data", "index", "show", "new", "edit", "update", "destroy", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Order::NoteItems"=>["index", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Order::OrderLogs"=>["_setup_filter_variables", "index", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Order::Templates"=>["order", "index", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Settings::Emails"=>["index", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Shop::Categories"=>["index", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Shop::PriceLists"=>["index", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Chat::Subscribers"=>["index", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Content::SeoPages"=>["generate_missing", "_prepare_form_data", "_setup_filter_variables", "index", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Delivery::Drivers"=>["_prepare_form_data", "index", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Delivery::Packages"=>["index", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Journals::Versions"=>["_setup_filter_variables", "index", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Security::Accesses"=>["index", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Service::SafeDeals"=>["index", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Service::UsageFees"=>["index", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Settings::Settings"=>["index", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Chat::Conversations"=>["create", "_prepare_form_data", "index", "show", "new", "edit", "update", "destroy", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Chat::Notifications"=>["_setup_filter_variables", "index", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Customer::Companies"=>["_prepare_form_data", "index", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Service::Promotions"=>["index", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Statistic::Diagrams"=>["index", "permitted_attributes", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Customer::Favourites"=>["index", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Delivery::Conditions"=>["index", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Delivery::StepFields"=>["_prepare_form_data", "index", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Delivery::Warehouses"=>["_prepare_form_data", "index", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Order::TemplateItems"=>["index", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Shop::ProductBonuses"=>["_prepare_form_data", "index", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Settings::Permissions"=>["index", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Shop::Characteristics"=>["_prepare_form_data", "index", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Shop::ProductFeatures"=>["_prepare_form_data", "index", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Delivery::PaymentTypes"=>["index", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Service::Verifications"=>["index", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Content::EmailTemplates"=>["index", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Delivery::WarehouseLogs"=>["synchronize", "create", "_prepare_form_data", "index", "show", "new", "edit", "update", "destroy", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Delivery::WarehouseProducts"=>["_prepare_form_data", "create", "index", "show", "new", "edit", "update", "destroy", "habtm", "hasone", "update_habtm", "many", "export", "history"]},
            has_child_resource_scope: form.has_child_resource_scope,
            has_root_resource_scope: false,
            is_system_owner: false,
            accessable_type: "Shop::Manager",
            accessable_id: form.manager_id,
            active: form.active,
            blocked: form.blocked,
            blocked_until: form.blocked_until
          )
          @model.assign_attributes(path: @model.accessable.depot.path)
        else
          @model = BeOneAdmin::User.new(
            email: form.email,
            first_name: form.first_name,
            last_name: form.last_name,
            title: form.title,
            permissions: {"Geo"=>["access", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Chat"=>["access", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Shop"=>["access", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Order"=>["access", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Content"=>["access", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Service"=>["access", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Customer"=>["access", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Delivery"=>["access", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Journals"=>["access", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Security"=>["access", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Settings"=>["access", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Statistic"=>["access", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Geo::Ports"=>["index", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Geo::Regions"=>["index", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Order::Carts"=>["template", "_prepare_form_data", "_setup_filter_variables", "index", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Order::Items"=>["permitted_attributes", "_prepare_form_data", "_setup_filter_variables", "update", "index", "show", "new", "edit", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Order::Notes"=>["index", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Order::Parts"=>["_prepare_form_data", "index", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Shop::Depots"=>["index", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Shop::Prices"=>["permitted_attributes", "_prepare_form_data", "_setup_filter_variables", "update", "index", "show", "new", "edit", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Content::Faqs"=>["_prepare_form_data", "index", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Geo::SeaLines"=>["index", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Chat::Contacts"=>["index", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Chat::Messages"=>["create", "_prepare_form_data", "index", "show", "new", "edit", "update", "destroy", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Content::Pages"=>["index", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Content::Posts"=>["index", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Delivery::Cars"=>["_prepare_form_data", "index", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Geo::Countries"=>["index", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Journals::Logs"=>["index", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Order::Returns"=>["create", "_prepare_form_data", "permitted_attributes", "index", "show", "new", "edit", "update", "destroy", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Shop::Features"=>["index", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Shop::Managers"=>["_prepare_form_data", "index", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Shop::Products"=>["update", "show_prices", "export", "upload", "permitted_attributes", "_prepare_form_data", "upload_product", "_setup_filter_variables", "remove_attach", "index", "show", "new", "edit", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "history"], "Chat::Feedbacks"=>["index", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Customer::Users"=>["_prepare_form_data", "index", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Delivery::Steps"=>["_prepare_form_data", "index", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Settings::Menus"=>["index", "move", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Settings::Roles"=>["index", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Settings::Users"=>["index", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Customer::Points"=>["_prepare_form_data", "_setup_filter_variables", "index", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Delivery::Routes"=>["create", "_prepare_form_data", "index", "show", "new", "edit", "update", "destroy", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Order::NoteItems"=>["index", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Order::OrderLogs"=>["_setup_filter_variables", "index", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Order::Templates"=>["order", "index", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Settings::Emails"=>["index", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Shop::Categories"=>["index", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Shop::PriceLists"=>["index", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Chat::Subscribers"=>["index", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Content::SeoPages"=>["generate_missing", "_prepare_form_data", "_setup_filter_variables", "index", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Delivery::Drivers"=>["_prepare_form_data", "index", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Delivery::Packages"=>["index", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Journals::Versions"=>["_setup_filter_variables", "index", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Security::Accesses"=>["index", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Service::SafeDeals"=>["index", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Service::UsageFees"=>["index", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Settings::Settings"=>["index", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Chat::Conversations"=>["create", "_prepare_form_data", "index", "show", "new", "edit", "update", "destroy", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Chat::Notifications"=>["_setup_filter_variables", "index", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Customer::Companies"=>["_prepare_form_data", "index", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Service::Promotions"=>["index", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Statistic::Diagrams"=>["index", "permitted_attributes", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Customer::Favourites"=>["index", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Delivery::Conditions"=>["index", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Delivery::StepFields"=>["_prepare_form_data", "index", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Delivery::Warehouses"=>["_prepare_form_data", "index", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Order::TemplateItems"=>["index", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Shop::ProductBonuses"=>["_prepare_form_data", "index", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Settings::Permissions"=>["index", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Shop::Characteristics"=>["_prepare_form_data", "index", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Shop::ProductFeatures"=>["_prepare_form_data", "index", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Delivery::PaymentTypes"=>["index", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Service::Verifications"=>["index", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Content::EmailTemplates"=>["index", "show", "new", "edit", "update", "destroy", "create", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Delivery::WarehouseLogs"=>["synchronize", "create", "_prepare_form_data", "index", "show", "new", "edit", "update", "destroy", "habtm", "hasone", "update_habtm", "many", "export", "history"], "Delivery::WarehouseProducts"=>["_prepare_form_data", "create", "index", "show", "new", "edit", "update", "destroy", "habtm", "hasone", "update_habtm", "many", "export", "history"]},
            has_child_resource_scope: form.has_child_resource_scope,
            has_root_resource_scope: true,
            path: "1",
            is_system_owner: form.is_system_owner,
            active: form.active,
            blocked: form.blocked,
            blocked_until: form.blocked_until
          )
        end
        @model.update(password: "admin")
        @model
      end
    end
    class Authentificate < Base
      def perform
        BeOneAdmin::User.authenticate_with_token(form.token, form.ip, form.user_agent)
      end
    end
    class SignIn < Base
      def perform
        if @model = BeOneAdmin::User.where(email: form.email).take
          if @model.blocked
            add_error!(:blocked,{blocked_until: @model.blocked_until})
          elsif !@model.active
            add_error!(:deactivated)
          elsif @model.authenticate(form.password)
            @model.update!(wrong_password_attempts: 0)
            token = @model.signin(form.ip, form.user_agent, form.referer)
            @model.increment!(:signins_count, 1)
            return token
          else
            @model.increment!(:wrong_password_attempts)
            attempts_left = (Rails.application.secrets[:max_password_attempts] || 15 ) - @model.wrong_password_attempts
            if attempts_left > 0
              add_error!(:wrong_credentials,{attempts_left: attempts_left})
            else
              blocked_until = Time.zone.now + (Rails.application.secrets[:block_time] || 5.minutes )
              @model.update!(blocked: true, blocked_until: blocked_until)
              add_error!(:blocked,{blocked_until: @model.blocked_until})
            end
          end
        else
          add_error!(:unknown_user)
        end
      end
    end

    # class SignUp < Base
    #   def perform
    #     with_transaction do
    #       if @model = BeOneAdmin::User.where(email: form.email).take
    #         add_error!(:existed_user)
    #       end
    #       @model = BeOneAdmin::User.create!(email: form.email, username: form.username, password: form.password)
    #       token = @model.signin(form.ip, form.user_agent, form.referer)
    #       @model.increment!(:signins_count, 1)
    #       ::BeOneAdmin::UserMailer.registration(@model,form.password).deliver_later
    #       if form.subscribe
    #         BeOneAdmin::Subscriber.create!(email: form.email)
    #       end
    #       return token
    #     end
    #   end
    # end

    class Restore < Base
      def perform
        if @model = BeOneAdmin::User.where(email: form.email).take
          if @model.blocked
            add_error!(:blocked,{blocked_until: @model.blocked_until})
          elsif !@model.active
            add_error!(:deactivated)
          elsif @model.reset_password_expire_at && @model.reset_password_expire_at > DateTime.now
            add_error!(:already_delivered)
          elsif @model.update_attributes( reset_password_token: ::BeOneCore::Password.salt, reset_password_expire_at: Time.now + ConfigFile.fetch('admin_settings', 'reset_password_expire')  )
            ::BeOneAdmin::UserMailer.remind_password(@model).send(Rails.env.development? ? :deliver_now : :deliver_later )
            return true
          else
            add_error!(:invalid_user)
          end
        else
          add_error!(:unregistered)
        end
      end
    end

    class ResetPassword < Base
      def perform
        if @model = BeOneAdmin::User.where(reset_password_token: form.code).take
          password = ::BeOneCore::Password.random
          @model.update_attributes!( password: password, reset_password_token:nil, reset_password_expire_at:nil, blocked: false, blocked_until: nil )
          ::BeOneAdmin::UserMailer.change_password(@model, password).send(Rails.env.development? ? :deliver_now : :deliver_later )
          return true
        else
          add_error!(:wrong_or_expired_code)
        end
        return false
      end
    end

    class Logout < Base
      def perform
        form.user.signout(form.token, form.ip, form.user_agent)
      end
    end
  end
end
