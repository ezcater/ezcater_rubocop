# frozen_string_literal: true

require "ezcater_rubocop/version"
require "rubocop-graphql"
require "rubocop-rails"
require "rubocop-rspec"

# Because RuboCop doesn't yet support plugins, we have to monkey patch in a
# bit of our configuration. Based on approach from rubocop-rspec:
DEFAULT_FILES = File.expand_path("../config/default.yml", __dir__)

path = File.absolute_path(DEFAULT_FILES)
hash = RuboCop::ConfigLoader.send(:load_yaml_configuration, path)
config = RuboCop::Config.new(hash, path)
puts "configuration from #{DEFAULT_FILES}" if RuboCop::ConfigLoader.debug?
config = RuboCop::ConfigLoader.merge_with_default(config, path)
RuboCop::ConfigLoader.instance_variable_set(:@default_configuration, config)

require_relative "rubocop/cop/ezcater/direct_env_check"
require_relative "rubocop/cop/ezcater/feature_flag_active"
require_relative "rubocop/cop/ezcater/feature_flag_name_valid"
require_relative "rubocop/cop/ezcater/graphql/not_authorized_scalar_field"
require_relative "rubocop/cop/ezcater/rails_configuration"
require_relative "rubocop/cop/ezcater/rails_env"
require_relative "rubocop/cop/ezcater/ruby_timeout"
require_relative "rubocop/cop/ezcater/rails_top_level_sql_execute"
require_relative "rubocop/cop/ezcater/require_custom_error"
require_relative "rubocop/cop/ezcater/require_gql_error_helpers"
require_relative "rubocop/cop/ezcater/rspec_match_ordered_array"
require_relative "rubocop/cop/ezcater/rspec_require_browser_mock"
require_relative "rubocop/cop/ezcater/rspec_require_feature_flag_mock"
require_relative "rubocop/cop/ezcater/rspec_require_http_status_matcher"
require_relative "rubocop/cop/ezcater/rspec_dot_not_self_dot"
require_relative "rubocop/cop/ezcater/style_dig"
require_relative "rubocop/cop/ezcater/migration/bigint_foreign_key"
