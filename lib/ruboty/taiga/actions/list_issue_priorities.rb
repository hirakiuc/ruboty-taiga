module Ruboty
  module Taiga
    module Actions
      class ListIssuePriorities < Base
        def call
          auth_if_required

          result = project.priorities.map { |priority| format_priority(priority) }

          if result.empty?
            message.reply('Not found.')
          else
            message.reply(result.join("\n"))
          end
        rescue => e
          message.reply("Failed to load project:#{message[:project_slug]}, #{e.message}")
        end

        private

        def format_priority(priority)
          priority.name
        end
      end
    end
  end
end
