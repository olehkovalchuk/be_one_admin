module BeOneAdmin
  module RoutableConcern
    def self.extended(base)
      base.instance_eval do

        concern :habtm_concern do
          member do
            get 'habtm/:type', action: 'habtm', as: 'habtm'
            post 'habtm/:type', action: 'update_habtm', as: 'update_habtm'
          end
        end

        concern :has_many_concern do
          member do
            get 'many/:type', action: 'many', as: 'many'
          end
        end

        concern :has_one_concern do
          member do
            get 'hasone/:type', action: 'hasone', as: 'hasone'
          end
        end

        concern :attach_concern do
          member do
            post 'remove_attach/:attach_type/:attach_id', action: 'remove_attach', as: 'remove_attach'
          end
        end

      end
    end
  end
end
