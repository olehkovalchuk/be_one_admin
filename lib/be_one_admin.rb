require "be_one_admin/engine"
require "be_one_admin/configuration"
require "be_one_admin/railtie"

module BeOneAdmin
  def self.table_name_prefix
    "#{BeOneAdmin.config.table_prefix}_"
  end
  class << self

    def configure
      @config = Configuration.new
      yield config
    end

    def config
      @config || Configuration.new(table_prefix: "admin",route: "admin", class_name: "Admin")
    end

    def modules
      modules = {}
      BeOneAdmin.constants.each do |k| 
        _module = "BeOneAdmin::#{k}".constantize; 
        if _module.is_a?(Module);  
          _module.constants.each do |c| 
            if "#{c}" =~ /Controller/ 
              modules["#{k}"] ||= ["access"]
              modules["#{k}::#{c}".sub("Controller",'')] = "#{BeOneAdmin.config.klass}::#{k}::#{c}".constantize.instance_methods(false).concat([:index,:show,:new,:edit,:update,:destroy,:create]).uniq
            end
          end
        end
      end
      modules
    end


    def menu
      modules = {}
      BeOneAdmin.constants.each do |k| 
        _module = "BeOneAdmin::#{k}".constantize; 
        if _module.is_a?(Module);  
          _module.constants.each do |c| 
            if "#{c}" =~ /Controller/ 
              modules["#{k}"] ||= []
              modules["#{k}"] << "#{c}".sub("Controller",'')
            end
          end
        end
      end
      modules
    end

  end
end

Object.const_set(BeOneAdmin.config.class_name.classify, BeOneAdmin)





