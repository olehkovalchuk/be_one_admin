module BeOneAdmin
  class Configuration
    attr_accessor :table_prefix, :route, :class_name, :tiny_mce_key, :app_name, :has_tree

    def initialize(attrs = {})
      attrs.each_pair do |k,v|
        self.send("#{k}=",v)
      end
    end

    def klass
      @class_name.classify.constantize
    end
  end
end