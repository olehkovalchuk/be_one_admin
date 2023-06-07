require_relative 'controller'

module BeOneAdmin
  class Railtie < Rails::Railtie

    initializer "be_one_admin.action_controller" do
      ActiveSupport.on_load(:action_controller) do
        puts "Extending #{self} with BeOneAdmin::Controller"
        include BeOneAdmin::Controller 
      end
    end

  end
end
require 'active_record'

ActiveRecord::Base.class_eval do
  def self.descendants
    ObjectSpace.each_object(Class).select { |klass| klass < self }
  end
end
