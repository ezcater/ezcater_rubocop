# ezcater_rubocop

ezCater custom cops and shared RuboCop configuration.

[RuboCop](https://github.com/bbatsov/rubocop) is a static code analyzer that
can enforce style conventions as well as identify common problems.

## Installation

Add this line to your application's Gemfile:

```ruby
group :development do
  gem "ezcater_rubocop", require: false
end
```

Or to your gem's gemspec file:

```ruby
spec.add_development_dependency "ezcater_rubocop"
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install ezcater_rubocop

## Configuration

To use one of the shared RuboCop configurations from this gem, you must define a
.rubocop.yml file in your project:

```yaml
inherit_gem:
  ezcater_rubocop: conf/rubocop_rails.yml
```

Further customization of RuboCop for your local project may be added to this file.

### Available Configurations

- **rubocop**: Assumes RSpec is used and requires [rubocop-rspec](https://github.com/backus/rubocop-rspec).
  This configuration should be used for gems.
- **rubocop_gem**: For use in Ruby gem projects, this inherits from the **rubocop** configuration.
- **rubocop_rails**: For Rails projects, this inherits from the **rubocop** configuration.

## Usage

Run `rubocop` for an entire project:

    $ bundle exec rubocop

See the `rubocop` command-line for additional options including auto-generating
configuration for existing offenses and auto-correction.

### Circle Script

This gem contains a script, `circle_rubocop.rb`, that can be used to run RuboCop in CI.

The behavior of the script is that all files are checked on master or if the rubocop
configuration has changed. On non-master branches, only the files added or changed on
the branch are checked.

For non-master branches, `[rubocop skip]` can be included in the commit message to skip
running rubocop.

## Versioning

This gem is using [Semantic Versioning](https://semver.org/). All version bumps should increment using `MAJOR.MINOR.PATCH` based on changes.

## Custom Cops

1. [RailsConfiguration](https://github.com/ezcater/ezcater_rubocop/blob/master/lib/rubocop/cop/ezcater/rails_configuration.rb) - Enforce use of `Rails.configuration` instead of `Rails.application.config`.
1. [RequireGqlErrorHelpers](https://github.com/ezcater/ezcater_rubocop/blob/master/lib/rubocop/cop/ezcater/require_gql_error_helpers.rb) - Use the helpers provided by `GQLErrors` instead of raising `GraphQL::ExecutionError` directly.
1. [RspecDotNotSelfDot](https://github.com/ezcater/ezcater_rubocop/blob/master/lib/rubocop/cop/ezcater/rspec_dot_not_self_dot.rb) - Enforce ".<class method>" instead of "self.<class method>" and "::<class method>" for example group description.
1. [RspecMatchOrderedArray](https://github.com/ezcater/ezcater_rubocop/blob/master/lib/rubocop/cop/ezcater/rspec_match_ordered_array.rb) - Enforce use of `match_ordered_array` matcher instead of `eq` matcher. This matcher comes from the [ezcater_matchers](https://github.com/ezcater/ezcater_matchers) gem.
1. [RspecRequireBrowserMock](https://github.com/ezcater/ezcater_rubocop/blob/master/lib/rubocop/cop/ezcater/rspec_require_browser_mock.rb) - Enforce use of `mock_ezcater_app`, `mock_chrome_browser` & `mock_custom_browser` helpers instead of mocking `Browser` or `EzBrowser` directly.
1. [RspecRequireFeatureFlagMock](https://github.com/ezcater/ezcater_rubocop/blob/master/lib/rubocop/cop/ezcater/rspec_require_feature_flag_mock.rb) - Enforce use of `mock_feature_flag` helper instead of mocking `FeatureFlag.is_active?` directly.
1. [RspecRequireHttpStatusMatcher](https://github.com/ezcater/ezcater_rubocop/blob/master/lib/rubocop/cop/ezcater/rspec_require_http_status_matcher.rb) - Use the HTTP status code matcher, like `expect(response).to have_http_status :bad_request`, rather than `expect(response.code).to eq 400`
1. [StyleDig](https://github.com/ezcater/ezcater_rubocop/blob/master/lib/rubocop/cop/ezcater/style_dig.rb) - Recommend `dig` for deeply nested access.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ezcater/ezcater_rubocop.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
