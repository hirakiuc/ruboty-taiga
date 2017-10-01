module Ruboty
  module Handlers
    class Taiga < Base
      env :TAIGA_USERNAME, "Pass taiga.io user name.", optional: false
      env :TAIGA_PASSWORD, "Pass taiga.io password", optional: false

      on(
        /auth/,
        name: 'auth',
        description: "Auth with TAIGA_USERNAME,TAIGA_PASSWORD"
      )

      on(
        /issues search ((?<query>.+) |)on (?<project_slug>.+)/,
        name: 'search_issues',
        description: "Search issues"
      )

      def auth(message)
        Ruboty::Taiga::Actions::Auth.new(message).call
      end

      def search_issues(message)
        Ruboty::Taiga::Actions::SearchIssues.new(message).call(message[:query])
      end
    end
  end
end
