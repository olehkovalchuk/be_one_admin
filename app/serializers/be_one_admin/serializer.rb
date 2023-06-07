module BeOneAdmin
  class Serializer < ActiveModel::Serializer
    include Rails.application.routes.url_helpers
    class_attribute :delete_property, default: :id
    class_attribute :sorting, default: {}
    # class_attribute :allowed_as_hash, default: {}
   
      

    def image_path(instance, default = nil, resize = nil )
      default ||= "https://upload.wikimedia.org/wikipedia/commons/b/b1/Missing-image-232x150.png"
      resize ||= "100x100"
      instance.kind_of?(ActiveStorage::Attachment) || instance&.attached? ? rails_representation_url( instance.variant(resize: resize), only_path: true ) : default
    end

    def attachment_path(instance, default = nil)
      default ||= "https://upload.wikimedia.org/wikipedia/commons/b/b1/Missing-image-232x150.png"
      instance.kind_of?(ActiveStorage::Attachment) || instance&.attached? ? rails_blob_path( instance ) : default
    end
     
    class << self

      @allowed_as_hash = {}

      def allowed_as_hash
        return @allowed_as_hash || {}
      end

      def allowed_as_hash=(val)
        @allowed_as_hash = (@allowed_as_hash || {})
        @allowed_as_hash.merge(val)
      end

      def translated *args
        args.each do |method|
          self.allowed_as_hash[method] = {}
          attributes method
          define_method(method) do
            self.object.send(method).translation.translations
          end
        end
      end

      def hidden *args
        with_type :hidden, *args
      end

      def allowed
        _attributes_data.keys.map do |key|
          self.allowed_as_hash.key?(key) ? {key => self.allowed_as_hash[key]} : key
        end
      end

      def as_tags *args
        args.each do |method|
          self.allowed_as_hash[method] = []
          attributes method, "#{method}_tags"
          define_method("#{method}_tags") do
            self.object.send(method).map{|a| {text: a.respond_to?(:title) ? a.title : a,id:a.respond_to?(:id) ? a.id : a} }
          end
          define_method method do
            []
          end
        end
      end

      def with_type type, *args
        args.each do |method|
          attribute method, type: type
          define_method(method) do
            self.object.send(method)
          end
        end
      end


      def as_string *args
        args.each do |method|
          attributes method
          define_method(method) do
            self.object.send(method).to_s
          end
        end
      end


      def as_image *args
        args.each do |method|
          attribute "#{method}_base64_data", type: :hidden
          attribute method, type: :image
          define_method "#{method}_base64_data" do
            nil
          end
          define_method(method) do
            image_path(self.object.image, ActionController::Base.helpers.image_url("missing.png"), "250x250")
          end
        end
      end

      def as_images *args
        args.each do |method|
          self.allowed_as_hash["#{method}_base64_data"] = []
          attribute "#{method}_base64_data", type: :hidden
          attribute method
          define_method "#{method}_base64_data" do
            []
          end
          define_method method do
            object.send(method).map do |i|
              {
                id: i.id,
                type: method,
                src: image_path(i)
              }
            end
          end
        end
      end

      def as_attachments *args
        args.each do |method|
          self.allowed_as_hash["#{method}_base64_data"] = []
          attribute "#{method}_base64_data", type: :hidden
          attribute method
          define_method "#{method}_base64_data" do
            []
          end
          define_method method do
            object.send(method).map do |i|
              {
                id: i.id,
                type: method,
                src: attachment_path(i),
                filename: i.blob.filename
              }
            end
          end
        end
      end

      def as_checkboxes *args
        args.each do |method|
          self.allowed_as_hash[method] = []
          meth = "#{method.to_s.sub("_ids","").singularize}"
          attributes meth, method
          define_method meth do
            object.send(method).inject({}){|hash, id| hash[id.to_s] = true; hash }
          end

        end
      end

      def ham_many_attributes *args
        args.each do |method|
          method = method.to_s
          attributes :"#{method}_attributes"
          define_method(:"#{method}_attributes") do
            serializer = "#{self.class.name.split("::").take(2).join("::")}::#{method.classify}Serializer::Item".constantize
            items = self.object.send(method).map{|item| serializer.new(item) }
            items.any? ? items : [serializer.new(self.object.class.reflections[method].klass.new)]
          end
        end
      end


      def attributes(*attrs)
        Rails.logger.info self.sorting.inspect
        Array.wrap(attrs).flatten.each do |attr|
          attribute(attr,{sorting: self.sorting[attr]})
        end
      end

    end
  end
end