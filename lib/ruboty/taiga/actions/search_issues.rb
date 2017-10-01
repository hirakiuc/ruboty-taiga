module Ruboty
  module Taiga
    module Actions
      class QueryConverter
        attr_reader :project, :query_string

        def initialize(project, query_string)
          @project = project
          @query_string = query_string
        end

        def is_valid_query?
          return true if query_string.nil?

          query_string.nil? || query_string =~ /^(([\w\-_]+)=([\w\-_,]+))(&(([\w\-_]+)=([\w\-_,]+)))*\z/
        end

        def convert
          return {} if (is_valid_query? == false || query_string.nil?)

          query_string.split('&').map do |keyValue|
            key, value = keyValue.split('=')

            {key.intern => convert_value(key.intern, value)}
          end.reduce(:merge)
        end

        private

        def convert_value(key, value)
          case key.intern
          when :status
            convert_status(value)
          when :severity
            convert_severity(value)
          when :owner
            convert_member(value)
          when :assigned_to
            convert_member(value)
          when :tags
            value
          when :type
            convert_type(value)
          when :watchers
            convert_member(value)
          else
            value
          end
        end

        def convert_status(value)
          status = project.issue_statuses.find {|status| status.slug == value}
          throw "No such issue_status found: #{value}" if status.nil?
          status.id
        end

        def convert_severity(value)
          severity = project.severities.find {|severity| severity.name == value}
          throw "No such severity found: #{value}" if severity.nil?
          severity.id
        end

        def convert_type(value)
          type = project.issue_types.find {|type| type.name == value}
          throw "No such issue_type found: #{value}" if type.nil?
          type.id
        end

        def convert_member(value)
          member = project.members.find {|member| member.username == value}
          throw "No such member found: #{value}" if member.nil?
          member.id
        end
      end

      class SearchIssues < Base
        def call(query_string = nil)
          auth_if_required

          converter = QueryConverter.new(project, query_string)
          unless converter.is_valid_query?
            message.reply("Invalid query string: #{query_string}")
            return
          end

          params = converter.convert
          search(params)
        end

        private

        def search(params)
          project.issues({order_by: '-created_at'}.merge(params)).take(10).each do |issue|
            message.reply("#{project.name}:##{format("% 6s", issue.ref)}: #{issue.subject}")
          end
        end
      end
    end
  end
end
