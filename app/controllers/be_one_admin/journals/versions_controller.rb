module BeOneAdmin
  module Journals
    class VersionsController < ApplicationController
      work_with model: "::Version" do 
        actions only: :show
        uncreatable
      end

      def _setup_filter_variables
        @available_klasses = ActiveRecord::Base.descendants.map do |klass|
          klass.included_modules.include?(PaperTrail::Model::InstanceMethods) ? klass.name : nil
        end.compact
      end

    end
  end
end