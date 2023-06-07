module BeOneAdmin
  module Settings
    class EmailsController < ApplicationController
      work_with model: "::BeOneAdmin::Email"
    end
  end
end