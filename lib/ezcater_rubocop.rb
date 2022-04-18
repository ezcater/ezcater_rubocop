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

require "rubocop/cop/ezcater/direct_env_check"
require "rubocop/cop/ezcater/feature_flag_active"
require "rubocop/cop/ezcater/rails_configuration"
require "rubocop/cop/ezcater/rails_env"
require "rubocop/cop/ezcater/ruby_timeout"
require "rubocop/cop/ezcater/rails_top_level_sql_execute"
require "rubocop/cop/ezcater/require_gql_error_helpers"
require "rubocop/cop/ezcater/rspec_match_ordered_array"
require "rubocop/cop/ezcater/rspec_require_browser_mock"
require "rubocop/cop/ezcater/rspec_require_feature_flag_mock"
require "rubocop/cop/ezcater/rspec_require_http_status_matcher"
require "rubocop/cop/ezcater/rspec_dot_not_self_dot"
require "rubocop/cop/ezcater/style_dig"
