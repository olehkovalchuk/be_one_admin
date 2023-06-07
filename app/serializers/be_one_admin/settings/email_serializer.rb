module BeOneAdmin
  module Settings
    module EmailSerializer
      class List < Serializer
        attributes :subject, :code
        hidden :id
      end

      class Item < Serializer
        translated :subject, :text
        attributes :id,:code
      end

    end
  end
end

