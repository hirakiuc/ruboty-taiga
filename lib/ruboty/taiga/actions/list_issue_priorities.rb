module Ruboty
  module Taiga
    module Actions
      class ListIssuePriorities < Base
        def call
          auth_if_required

          project.priorities.each do |priority|
            message.reply(format_priority(priority))
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
