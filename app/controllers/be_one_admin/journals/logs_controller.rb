module BeOneAdmin
  module Journals
    class LogsController < ApplicationController
      work_with model: "::BeOneAdmin::Log" do 
        actions only: :show
        uncreatable
        set_js_controller "LogsController"
      end


    end
  end
end