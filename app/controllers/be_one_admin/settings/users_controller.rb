module BeOneAdmin
  module Settings
    class UsersController < ApplicationController
      work_with model: "::BeOneAdmin::User" do 
        set_habtm_relations :individual_permissions, :roles
        has_image :avatar
        actions with: :history
        set_js_controller "User"
      end
      
      def _prepare_form_data
        depots = if current_admin.accessable
          current_admin.accessable.depot.self_and_descendants
        else
          ::Shop::Depot.all
        end
        {
          is_system_owner: current_admin.is_system_owner,
          depots: depots.map{|depot| 
            { 
              id: depot.id, 
              title: depot.title,
              managers: depot.managers.select{|manager| !manager.admin}.map{|manager| {id: manager.id, title: "#{manager.first_name} #{manager.last_name}"}}
            } 
          }
        }
      end
    end
  end
end
