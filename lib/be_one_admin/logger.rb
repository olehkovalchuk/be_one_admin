module BeOneAdmin
  module Logger
    # Parametrize before writing to store
    # @param args [Hash] set of params to write to log
    def self.parametrize(args)
      request = RequestStore.store[:request]
      args[:core_ip] = Socket.ip_address_list.detect{|intf| intf.ipv4_private?}.try(:ip_address)
      args[:request_id] = RequestStore.store[:request_id]
      args[:request_type] = :admin
      args[:user_agent] = request.try(:user_agent)
      args[:http_method] = "#{request.method_symbol}".upcase
      args[:http_format] = "#{request.format.symbol}".upcase
      if RequestStore.store[:current_admin]
        args[:user_type] = 2
        args[:user_id] = RequestStore.store[:current_admin].id
        args[:user_login] = RequestStore.store[:current_admin].email
        
        args[:user_token] = RequestStore.store[:uniq_token]
      end
      args[:user_ip] = request.try(:remote_ip)
      if args[:user_ip]
        args[:client_ip] = args[:user_ip]
        args[:user_country] =  args[:client_country] = BeOneCore::Geo.country(args[:user_ip])
      end

      params = request.params

      

      args[:component] = params[:controller] unless args[:component]
      args[:activity] = params[:action] unless args[:activity]
      args[:args] = params.reject{|k| "#{k}" =~ /_base64_data/} unless args[:args]

      unless args[:file]
        args[:file] = RequestStore.store[:response_body]
        if args[:file]
          args[:file_type] = 'raw'
          if args[:file].respond_to?(:to_json)
            args[:file] = args[:file].to_json
            args[:file_type] = 'json'
          end
          args[:file_description] = 'Response'
        end
      end      
      args
    end
  end
end
