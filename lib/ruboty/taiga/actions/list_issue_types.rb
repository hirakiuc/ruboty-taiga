module Ruboty
  module Taiga
    module Actions
      class ListIssueTypes < Base
        def call
          auth_if_required

          result = project.issue_types.map { |issue_type| format_issue_type(issue_type) }

          if result.empty?
            message.reply('Not found.')
          else
            message.reply(result.join("\n"))
          end
        rescue => e
          message.reply("Failed to load project:#{message[:project_slug]}, #{e.message}")
        end

        private

        def format_issue_type(issue_type)
          issue_type.name
        end
      end
    end
  end
end
