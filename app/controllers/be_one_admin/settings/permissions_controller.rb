module BeOneAdmin
  module Settings
    class PermissionsController < ApplicationController
      work_with model: "::BeOneAdmin::Permission" do 
        set_js_controller "SettingsPermissionsController"
        set_habtm_relations :roles, :users
        # set_has_many_relations :role_users
      end


      private

      def _prepare_form_data
        {
          modules: BeOneAdmin.modules.keys.map{|k| {id: k,title: k} },
          modulesActions: BeOneAdmin.modules
        }
      end
    end
  end
end
