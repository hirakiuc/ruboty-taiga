module Ruboty
  module Taiga
    module Actions
      class ListIssueSeverities < Base
        def call
          auth_if_required

          result = project.severities.map { |severity| format_issue_severity(severity) }

          if result.empty?
            message.reply('Not found.')
          else
            message.reply(result.join("\n"))
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
