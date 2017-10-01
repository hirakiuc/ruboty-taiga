module Ruboty
  module Taiga
    module Actions
      class Base
        NAMESPACE = 'taiga'

        attr_reader :message

        def initialize(message)
          @message = message
        end

        protected

        def project
          @project ||= client.project(slug: message[:project_slug])
        rescue => e
          message.reply("Failed to fetch the project:#{message[:project_slug]}, #{e.message}")
        end

        private

        def memory
          message.robot.brain.data[NAMESPACE] ||= {}
        end

        def access_token
          @access_token ||= memory[:token]
        end

        def has_access_token?
          !!access_token
        end

        def client
          @client ||= Taigar.new
        end

        def auth_if_required
          return if has_access_token?
          auth!(verbose: false)
        end

        def auth!(options = {verbose: true})
          client.login(ENV['TAIGA_USERNAME'], ENV['TAIGA_PASSWORD'])
          memory[:token] = Taigar.config.auth

          message.reply('Auth success!') if options[:verbose]
        rescue => e
          message.reply("Auth failed: #{e.message}")
        end
      end
    end
  end
end
