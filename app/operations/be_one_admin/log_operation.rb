module BeOneAdmin
  module LogOperation
    class List
      include Operation::Base
      validate_with BeOneAdmin::LogValidation::List
      def perform
          date = if params.dig(:filters, :created_at)
             Date.parse(params[:filters].delete(:created_at))
          else
            Date.today
          end
        {items: Journal::Record.search(_build_search_options(params,date)), total: Journal::Record.count(_build_search_options(params,date)) }
      end

      private

      def _build_search_options(options,date)
        {}.tap do |result|
          result[:time] = date
          result[:from] = options[:start] if options[:start]
          result[:size] = options[:limit] || 100
          result[:sort] = if options[:sorters].presence
            options[:sorters].map{ |s| s.to_a.join(":") }.join(',')
          else
            "created_at:desc"
          end
          result[:sort] = "created_at:desc"
          result[:query] = if options[:filters] || options[:query] || options[:scope]
            scope = [].tap do |s|
              options[:scope].each do |sk, sv|
                s << { sk => sv }
              end if options[:scope].is_a?(Hash)
            end
            options[:filters].inject({}){|hash,(k,v)| hash[k.sub(/_eq|_matches/,'')] = v;hash }
          else
            {}
          end
          # result[:ignore_indices] = :missing
          result[:allow_no_indices] = true
        end
      end

    end

    class Read
      include Operation::Base
      validate_with BeOneAdmin::LogValidation::Read
      def perform
        Journal::Record.find(form.id)
      end
    end
  end
end
