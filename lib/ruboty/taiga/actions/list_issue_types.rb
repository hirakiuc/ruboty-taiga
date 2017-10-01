module Ruboty
  module Taiga
    module Actions
      class ListIssueTypes < Base
        def call
          auth_if_required

          project.issue_types.each do |issue_type|
            message.reply(format_issue_type(issue_type))
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
