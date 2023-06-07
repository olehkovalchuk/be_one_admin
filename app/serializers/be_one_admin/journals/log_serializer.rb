module BeOneAdmin
  module Journals
    module LogSerializer
      class List < Serializer

        self.sorting = {
          execution_time: :execution_time,
          request_type: :request_type,
          status: :status,
          component: :component
        }
        attributes :created_at, :request_type, :format, :execution_time, :component, :user_ip, :user_token
        hidden  :id
        
        attribute :status, type: :enum
        hidden :status_text
        def component
          [object.component,object.activity].reject(&:blank?).join("<br>").html_safe
        end

        def user_ip
          [
            object.user_ip.presence || "-",
            object.user_ip.presence ? "<img src=\"/#{BeOneAdmin.config.class_name.downcase}/flags/#{object.client_country}.png\"/>" : '',
          ].join("&nbsp").html_safe
        end

        def user_token
          [
            object.user_login.presence || "-",
            object.user_token.presence || "-",
          ].join("<br/>").html_safe
        end

        def format
          [object.http_method,object.http_format].join("|")
        end

        def status
          {
            1=> "success",
            2=> "failure",
            3=> "exception",
            4=> "unknown"
          }.fetch(object.status)
        end

        def status_text
          status
        end

        def execution_time
          object.execution_time.to_f.round(3)
        end

        def created_at
          object.created_at.strftime("%Y-%m-%d %H:%M:%S UTC")
        end
      end
      class Item < Serializer
        attributes :request_type, :http_method, :http_format, :execution_time, :created_at, :component,:activity,:args, :files
        attributes :user_ip,:user_agent,:user_login, :user_token, :client_ip, :client_country, :description, :core_ip
        

        def args
          JSON.pretty_generate(JSON.parse(object.args)) rescue args
        end

        def files
          object.files.map do |f| 
            {
              content: 'json' == f.content_type ? (JSON.pretty_generate(JSON.parse(f.content)) rescue f.content) : f.content,
              content_type: f.content_type,
              file_description: f.file_description.capitalize,
              id: f.id,
              created_at: f.created_at.strftime("%Y-%m-%d %H:%M:%S UTC")
            }
          end
        end

      end
    end
  end
end

