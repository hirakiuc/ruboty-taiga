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
          issues = search(params)

          message.reply(format_issues(issues))
        end

        private

        def search(params)
          project.issues({ order_by: '-created_at' }.merge(params[:query])).take(params[:limit])
        end

        def format_issues(issues)
          return 'Not found' if issues.empty?
          issues.map { |issue| format_issue(issue) }.join("\n")
        end

        def format_issue(issue)
          "_#{project.name}_:*##{format('% 6s', issue.ref)}*: #{issue.subject}"
        end
      end
    end
  end
end
