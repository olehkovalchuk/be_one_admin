module BeOneAdmin
  module Controller
    extend ActiveSupport::Concern

    class_methods do

      def work_with(model:)
        self.model = model.constantize
        self.send(:include, CrudActions)
        yield if block_given?
      end

      private

      def set_js_controller( ctrl )
        self.js_controller = ctrl.sub( "Controller", "" ).classify
      end

      def set_root_scope( scope )
        self.scope_value = scope
      end

      def set_habtm_relations( *args )
        self.habtm_relations = args
      end

      def set_has_one_relations( *args )
        self.has_one_relations = args
      end

      def set_has_many_relations( *args )
        self.has_many_relations = args
      end

      def set_habtm_nested_relations( args )
        self.habtm_nested_relations = (self.habtm_nested_relations || {}).merge(args)
      end


      def has_image( *args )
        self.image_fields ||= []
        self.image_fields << args
        self.image_fields = self.image_fields.flatten
      end

      def uncreatable
        self.cant_create = true
      end

      def with_context
        self.with_context_menu = true
      end

      def on_collection( *args )
        self.collection_actions = args.map(&:to_sym)
      end

      def actions(**args)
        Rails.logger.info self
        args.symbolize_keys.each_pair do |k,v|
          case k
          when :none
            self.model_actions = {}
          when :except
            Array.wrap(v).map(&:to_sym).each do |action|
              self.model_actions.delete action
            end
          when :only
            self.model_actions = self.model_actions.slice(*Array.wrap(v).map(&:to_sym))
          when :with
            Array.wrap(v).each do |action|
              if action.kind_of?( Hash )
                key = action.keys.first
                self.model_actions = self.model_actions.merge( key.to_sym => action[key] )
              else
                self.model_actions = self.model_actions.merge( action => :inverse )
              end

            end
          end
        end
      end

      def order_by(order)
        self.sorters = Array.wrap(order).select do |item|
          key = item.keys.first
          self.model.column_names.include?( key.to_s ) && %w{asc desc}.include?( item[key].to_s )
        end#.concat( self.sorters )
      end

    end
    included do
      class_attribute :model
      class_attribute :scope_value
      class_attribute :serializer
      class_attribute :image_fields
      class_attribute :as_tree
      class_attribute :js_controller
      class_attribute :model_actions
      class_attribute :with_context_menu
      class_attribute :limit
      class_attribute :cant_create
      class_attribute :collection_actions
      class_attribute :model_includes
      class_attribute :sorters

      class_attribute :habtm_relations
      class_attribute :has_one_relations
      class_attribute :has_many_relations
      class_attribute :has_many_nested_relations
      class_attribute :habtm_nested_relations

      self.js_controller = 'BeOneBase'
      self.limit = 25
      self.model_includes = []
      self.sorters = {id: :desc}
      self.model_actions = {
        show: :primary,
        update: :warning,
        destroy: :danger,
      }


      helper_method :current_module_path
      helper_method :_template_path

    end


    module CrudActions
      extend ActiveSupport::Concern
      included do
        before_action :_setup#, only: [:index,:show]
        before_action :_setup_filter_variables, only: [:index]
        helper BeOneAdmin::FormHelper
      end

      def index( is_parent = true )
        @limit = is_parent ? (params[:limit].presence || self.class.limit).to_i : 500
        respond_to do |format|
          format.html do
            @columns = _prepare_columns( _serializer(true) )
            @has_filter = template_exists?( _template_path(:_filter) )
            @as_tree = self.class.as_tree
            @with_context_menu = self.class.with_context_menu

            @init_data = (@additional_data || {}).merge({
              filters: {},
              allowedActions: (@with_context_menu ? @model_actions.inject({}){|hash,(k,v)| hash.merge!( user_can?(k) ? {k=>v} : hash) } : []),
              deleteProperty: _serializer(true).delete_property
            })

            render template: _template_path(:index)
          end
          format.json do
            filters = (JSON.load(params[:filters]) || {})
            sorters = [(JSON.load(params[:sorting]) || self.sorters)]
            filters[:deleted] = false if self.class.model.column_names.include?("deleted")
            page = (params[:page].to_i - 1)
            page = 0 if page < 0
            args = { includes: self.class.model_includes, limit: @limit, start: ( @limit * page  ), filters: filters, sorters: sorters, only_roots: self.class.as_tree && is_parent, scope: self.class.scope_value}
            # args.merge!(params.to_unsafe_hash) if self.class.merge_list_params
            args[:current_admin] = current_admin

            process_and_respond!(operation: _operation(:list).new( args ) ) do |operation, result|
              render_as_json( { success: true, total: result[:total], items: _array_serialization( result[:items], _serializer(true) )  } )
            end
          end
        end
      end


      def new
        @item = _serializer.new(self.class.model.new)
        @init_data = _prepare_form_data
        render template: _template_path(:form), layout: !params[:only_template].present?
      end

      def show
        process_and_respond!(operation: _operation(:read).new( id: params[:id], current_admin: current_admin ) ) do |operation, result|
          render_as_json( {success: true, item: _serializer.new(result) } )
        end
      end

      def history
        process_and_respond!(operation: _operation(:history).new( id: params[:id], current_admin: current_admin ) ) do |operation, result|
          render_as_json( { success: true, total: result[:total], items: _array_serialization( result[:items], _serializer(true) )  } )
        end
      end

      def create
        process_and_respond!(operation: _operation(:create).new( _check_image(_permited_attributes) ) ) do |operation, result|
          render_as_json( { success: true, id: operation.model.id } )
        end
      end

      def update
        process_and_respond!(operation: _operation(:update).new( _check_image(_permited_attributes) ) ) do |operation, result|
          render_as_json( { success: true } )
        end
      end

      def destroy
        process_and_respond!(operation: _operation(:destroy).new( id: params[:id], current_admin: current_admin ) ) do |operation, result|
          render_as_json( { success: true } )
        end
      end

      def remove_attach
        process_and_respond!(operation: _operation(:remove_attach).new( id: params[:id], attach_type: params[:attach_type] , attach_id: params[:attach_id], current_admin: current_admin ) ) do |operation, result|
          render_as_json( { success: true } )
        end
      end

      def export
        process_and_respond!(show_404: true, operation: _operation(:exel).new( filters: params.to_unsafe_hash, current_admin: current_admin ) ) do |operation, result|
          send_data result, type: "application/vnd.ms-excel", disposition: 'attachment', filename: "#{operation.file_title}.xls"
        end
      end

      def habtm
        respond_to do |format|
          format.html do
            begin
              url = eval("habtm_#{@module.downcase}_#{@sufix.singularize}_path(#{params[:id]},'#{params[:type]}')")
            rescue Exception => e
              url = Rails.application.routes.url_helpers.send("habtm_#{BeOneAdmin.config.class_name.downcase}_#{@module.downcase}_#{@sufix.singularize}_path", id: params[:id], type: params[:type] )
            end
            @habtm_url = url
            render template: _template_path(:habtm), layout: false
          end
          format.json do
            process_and_respond!(operation: _operation(:habtm).new( id: params[:id], relation: params[:type], current_admin: current_admin ) ) do |operation, result|
              render_as_json( { success: true, available: _array_serialization( result[:available], _relation_serializer(params[:type]) ), exists: _array_serialization( result[:exists], _relation_serializer(params[:type]) ) } )
            end
          end
        end
      end

      def hasone
        respond_to do |format|
          format.html do
            render template: _template_path(:has_one), layout: false
          end
        end
      end


      def update_habtm
        process_and_respond!(operation: _operation(:habtm_update).new( ids: [params[:ids]].flatten.compact, relation: params[:type], id: params[:id], current_admin: current_admin ) ) do |operation, result|
          render_as_json( {success: true} )
        end
      end

      def many
        respond_to do |format|
          format.html do
            @type = params[:type]

            unless (relation = self.class.model.reflect_on_association(@type))
              render inline: "Missing rellation #{@type}"
              return
            end

            unless relation.options.any?
              render inline: "Missing rellation #{@type}"
              return
            end
            @has_filter = template_exists?( _template_path("_#{@type}_filter") )
            set_relations_filter_data(@type) if @has_filter

            @additional_keys = _additional_keys
            old_sufix = @sufix
            @foreign_key = relation.options[:foreign_key]
            @filters = {}
            @filter_relation = { @foreign_key => params[:id] }
            @has_many_relations  = _realtions(:has_many_nested_relations)
            @habtm_relations  = _realtions(:habtm_nested_relations)


            @init_data = (@additional_data || {}).merge({
              filters: { "#{@foreign_key}_eq" => params[:id] },
              allowedActions: (@with_context_menu ? @model_actions.inject({}){|hash,(k,v)| hash.merge!( user_can?(k) ? {k=>v} : hash) } : []),
              deleteProperty: _serializer(true).delete_property
            })

            @sufix = relation.klass.name.underscore.gsub("/","_").sub("#{@module.downcase}_","").sub("be_one_admin_","").sub("#{BeOneAdmin.config.class_name.downcase}_","")
            @model_actions = self.class.name.sub(old_sufix.classify.pluralize, @sufix.classify.pluralize).constantize.model_actions
            @columns = _prepare_columns( _relation_serializer(@type) )
            render template: _template_path(:many), layout: false
          end
        end
      end


      def current_module_path
        controller = "#{@module.underscore}_#{@sufix.pluralize}"
        if BeOneAdmin::Engine.routes.named_routes.instance_variable_get("@url_helpers").to_a.include?(:"#{controller}_url")
          send("#{controller}_path")
        else
          Rails.application.routes.url_helpers.send("#{BeOneAdmin.config.route}_#{controller}_path")
        end
      end

      def _template_path( _path )
        if template_exists?("#{BeOneAdmin.config.class_name.downcase}/#{@path}/#{_path}")
          "#{BeOneAdmin.config.class_name.downcase}/#{@path}/#{_path}"
        elsif template_exists?("be_one_admin/#{@path}/#{_path}")
          "be_one_admin/#{@path}/#{_path}"
        else
          "be_one_admin/shared/#{_path}"
        end
      end

      private

      def _array_serialization( items, serializer )
        ActiveModel::Serializer::CollectionSerializer.new( items, serializer: serializer )
      end

      def _permited_attributes
        params.require(:item).permit( *_serializer.allowed  )
      end

      def _prepare_columns( serializer )
        serializer._attributes_data.each_pair.inject({}){|hash,(key,struct)| hash[key] = struct.options ;hash  }
      end

      def _operation( type )
        "#{self.class.model.name}Operation::#{type.to_s.classify}".constantize
      end
      def _serializer( list = false )
        "BeOneAdmin#{_module_prefix}::#{self.class.model.name.demodulize}Serializer::#{(list ? 'List' : 'Item' )}".constantize
      end

      def _relation_serializer( relation )
        "BeOneAdmin#{_module_prefix}::#{relation.classify}Serializer::Relation".constantize
      end

      def _path(path)
        "#{BeOneAdmin.config.class_name.downcase}/#{@path}/#{path}"
      end

      def _realtions( type )
        Array.wrap(self.class.send(type)).inject({}) do |hash,relation|
          relation = relation.to_s
          if self.class.model.reflections.keys.include?( relation )
            hash[relation] = self.class.model.reflections[relation].options[:primary_key] || :id
          end
          hash
        end
      end

      def _module_prefix
        module_prefix = (self.class.serializer || @module).presence
        module_prefix ? "::#{module_prefix}" : ''
      end

      def _setup
        raise "Model not set" unless self.class.model
        @module = self.class.name.deconstantize.demodulize
        @sufix = self.class.model.name.underscore.gsub("/","_").sub("#{@module.downcase}_","").sub("be_one_admin_","").sub("#{BeOneAdmin.config.class_name.downcase}_","")
        @path = "#{@module.downcase}/#{@sufix.pluralize}"
        @habtm_relations = _realtions(:habtm_relations)
        @has_many_relations  = _realtions(:has_many_relations)
        @has_many_nested_relations  = _realtions(:has_many_nested_relations)
        @has_one_relations  = _realtions(:has_one_relations)

        @model_actions = self.class.model_actions.inject({}){|hash,(a,k)| user_can?(a) ? hash.merge!(a=>k) : hash }
        @cant_create = self.class.cant_create.presence
        @collection_actions = Array.wrap( self.class.collection_actions )
        @js_controller = self.class.js_controller.sub("Controller",'')
        @filters = {}
        @additional_keys = []
        @image_fields = self.class.image_fields
      end

      def _check_image( params_to_save, item = false )
        begin
          (self.class.image_fields || []).each do |field|
            params_to_save.delete(field)
            next unless data = params_to_save.delete( "#{field}_base64_data" ).presence
            params_to_save[field] = data.kind_of?(Array) ? data.map{|d| _fill_attachment_data( d.force_encoding("UTF-8") ) } : _fill_attachment_data( data.force_encoding("UTF-8") )
          end
          pp params_to_save
          params_to_save
        rescue Exception => e
          raise e
        end
        params_to_save
      end


      def _realtions( type )

        rel = self.class.send(type)
        if rel.kind_of?(Hash)
          rel.inject({}) do |hash,(parent_rel,relation)|
            relation = relation.to_s
            parent_rel = parent_rel.to_s
            if self.class.model.reflections.keys.include?( parent_rel )
              if self.class.model.reflections[parent_rel.to_s].options[:class_name].constantize.reflections.keys.include?( relation )
                hash[relation] = self.class.model.reflections[parent_rel.to_s].options[:class_name].constantize.reflections[relation].options[:primary_key] || :id
              end
            end
            hash
          end
        else
          Array.wrap(rel).inject({}) do |hash,relation|
            relation = relation.to_s
            if self.class.model.reflections.keys.include?( relation )
              hash[relation] = self.class.model.reflections[relation].options[:primary_key] || :id
            end
            hash
          end
        end

      end

      def _fill_attachment_data(base64_data)
        Base64ToFile.base64_to_file(base64_data)
      end


      def _prepare_form_data
        {}
      end

      def _additional_keys
        []
      end

      def _setup_filter_variables

      end


    end

  end
end
