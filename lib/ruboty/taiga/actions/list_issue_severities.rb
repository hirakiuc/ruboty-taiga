module Ruboty
  module Taiga
    module Actions
      class ListIssueSeverities < Base
        def call
          auth_if_required

          project.severities.each do |severity|
            message.reply(format_issue_severity(severity))
          end
        rescue => e
          message.reply("Failed to load project:#{message[:project_slug]}, #{e.message}")
        end

        private

        def format_issue_severity(severity)
          severity.name
        end
      end
    end
  end
end
