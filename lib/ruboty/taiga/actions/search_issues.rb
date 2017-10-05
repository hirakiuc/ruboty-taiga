module Ruboty
  module Taiga
    module Actions
      class SearchIssues < Base
        def call(query_string = nil)
          auth_if_required

          converter = ::Ruboty::Taiga::IssueQueryConverter.new(project, query_string)
          unless converter.valid_query?
            message.reply("Invalid query string: #{query_string}")
            return
          end

          params = converter.convert
          search(params)
        end

        private

        def search(params)
          project.issues({ order_by: '-created_at' }.merge(params[:query])).take(params[:limit]).each do |issue|
            message.reply("#{project.name}:##{format('% 6s', issue.ref)}: #{issue.subject}")
          end
        end
      end
    end
  end
end
