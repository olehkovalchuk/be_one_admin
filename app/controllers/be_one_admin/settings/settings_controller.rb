module BeOneAdmin
  module Settings
    class SettingsController < ApplicationController
      work_with model: "::Setting"
    end
  end
end