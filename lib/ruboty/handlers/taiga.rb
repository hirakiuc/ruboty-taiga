module Ruboty
  module Handlers
    class Taiga < Base
      env :TAIGA_USERNAME, 'Pass taiga.io user name.', optional: false
      env :TAIGA_PASSWORD, 'Pass taiga.io password', optional: false

      on(
        /auth/,
        name: 'auth',
        description: 'Auth with TAIGA_USERNAME,TAIGA_PASSWORD'
      )

      on(
        /issues search ((?<query>.+) |)on (?<project_slug>.+)/,
        name: 'search_issues',
        description: 'Search issues'
      )

      on(
        /issues types on (?<project_slug>.+)/,
        name: 'list_issue_types',
        description: 'Show issue types'
      )

      on(
        /issues severities on (?<project_slug>.+)/,
        name: 'list_issue_severities',
        description: 'Show issue severities'
      )

      on(
        /issues priorities on (?<project_slug>.+)/,
        name: 'list_issue_priorities',
        description: 'Show issue priorities'
      )

      def auth(message)
        Ruboty::Taiga::Actions::Auth.new(message).call
      end

      def search_issues(message)
        Ruboty::Taiga::Actions::SearchIssues.new(message).call(message[:query])
      end

      def list_issue_types(message)
        Ruboty::Taiga::Actions::ListIssueTypes.new(message).call
      end

      def list_issue_severities(message)
        Ruboty::Taiga::Actions::ListIssueSeverities.new(message).call
      end

      def list_issue_priorities(message)
        Ruboty::Taiga::Actions::ListIssuePriorities.new(message).call
      end
    end
  end
end
