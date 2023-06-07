module BeOneAdmin
  module Settings
    class MenusController < ApplicationController
      work_with model: "::BeOneAdmin::Menu" 

      def index
        respond_to do |format|
          format.json do
            process_and_respond!(operation: BeOneAdmin::MenuOperation::Tree.new) do |operation, result|
              render_as_json( { success: true, menu: result } )
            end
          end
          format.html do; render; end
        end
      end

      def move
        process_and_respond!(operation: BeOneAdmin::MenuOperation::Move.new( up: params[:up].present?, id: params[:id] ) ) do |operation, result|
          render_as_json( { success: true } )
        end
      end

    end
  end
end
