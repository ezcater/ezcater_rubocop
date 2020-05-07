# frozen_string_literal: true

module RuboCop
  module Cop
    module Ezcater
      # Enforce use of migration best practices by adding comment of documentation url
      #
      # @example
      #   # bad
      #   # frozen_string_literal: true
      #
      #   class CreateUsers < ActiveRecord::Migration[5.1]
      #     def change
      #
      #   # good
      #   # frozen_string_literal: true
      #   # https://ezcater.atlassian.net/wiki/spaces/POL/pages/53248012/Adding+a+migration
      #
      #   class CreateUsers < ActiveRecord::Migration[5.1]
      #     def change
      #
      #
      class MigrationDocumentation < Cop
        MIGRATION_DOC_URL = "https://ezcater.atlassian.net/wiki/spaces/POL/pages/53248012/Adding+a+migration"
        MIGRATION_DOC_COMMENT = "# #{MIGRATION_DOC_URL}"
        MSG = "Missing the comment `#{MIGRATION_DOC_COMMENT}` " \
              "at the top of your migration file."

        def investigate(processed_source)
          return if processed_source.tokens.empty?

          ensure_comment(processed_source)
        end

        def autocorrect(_node)
          lambda do |corrector|
            corrector.insert_after(line_range(1), "\n#{MIGRATION_DOC_COMMENT}")
          end
        end

        private

        def ensure_comment(processed_source)
          return if migration_documentation_comment(processed_source)

          missing_offense(processed_source)
        end

        def migration_documentation_comment(processed_source)
          processed_source.find_token do |token|
            token.text.start_with?(MIGRATION_DOC_COMMENT)
          end
        end

        def missing_offense(processed_source)
          range = Parser::Source::Range.new(processed_source.buffer, 1, 2)

          add_offense(processed_source.tokens[0], location: range, message: MSG)
        end

        def line_range(line)
          processed_source.buffer.line_range(line)
        end
      end
    end
  end
end
