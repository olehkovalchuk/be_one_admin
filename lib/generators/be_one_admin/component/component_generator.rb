module BeOneAdmin
  class ComponentGenerator < Rails::Generators::Base
    source_root File.expand_path("../templates", __FILE__)
    argument :model, type: :string
    argument :namespace, type: :string, default: nil
    def init
      copy_file "_form.html.haml", file_name('views',"#{model.pluralize.underscore}/_form.html.haml")
      template "controller.rb.erb", file_name('controllers',"#{model.pluralize.underscore}_controller.rb")
      template "serializer.rb.erb", file_name('serializers',"#{model.singularize.underscore}_serializer.rb")
    end

    private 
    def file_name( type, file_name = nil )
      path = ['app',type.pluralize,BeOneAdmin.config.class_name.underscore]
      path << namespace if namespace
      path << file_name
      path.join("/")
    end
  end
end