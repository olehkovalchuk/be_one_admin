module BeOneAdmin
  module Settings
    class RolesController < ApplicationController
      work_with model: "::BeOneAdmin::Role" do 
        set_habtm_relations :permissions, :users
      end
    end
  end
end