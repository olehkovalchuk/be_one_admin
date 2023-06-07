module BeOneAdmin
  module MenuOperation
    class Base
      include Operation::Base
      crudify do
        model_name Menu
      end
    end
    class Move < Read
      def perform
        form.up ? @model.up! : @model.down!
      end
    end

    class Tree < Base 
      def process
        to_node = -> (item,children){ { id: item.id, title: item.title, nodes: children.map{|item| to_node.call item, item.children.to_a } } }
        BeOneAdmin::Menu.where(parent_id: 0).includes(:children).to_a.map{|item| to_node.call item, item.children.includes(:children).to_a }
      end
    end
  end
end
