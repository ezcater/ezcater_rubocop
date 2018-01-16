# ezcater_rubocop

ezCater custom cops, and eventually shared rubocop configuration.

[RuboCop](https://github.com/bbatsov/rubocop) is a static code analyzer that
can enforce style conventions as well as identify common problems.

## Installation

Add this line to your application's Gemfile:

```ruby
group :development do
  gem "ezcater_rubocop", require: false
end
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install ezcater_rubocop

## Usage

Run `rubocop` for an entire project:

    $ bundle exec rubocop

See the `rubocop` command-line for additional options including auto-generating
configuration for existing offenses and auto-correction.

## Versioning

This gem is versioned based on the MAJOR.MINOR version of `rubocop`. The first
release of the `ezcater_rubocop` gem was v0.49.0.

The patch version for this gem does _not_ correspond to the patch version of
`rubocop`. The patch version for this gem will change any time that one of its
configurations is modified _or_ its dependency on `rubocop` is changed to require
a different patch version.

This gem also includes a dependency on `rubocop-rspec` that will be updated to
the latest compatible version each time that the MAJOR.MINOR version of `rubocop`
is updated.

## Custom Cops
1. [RailsConfiguration](https://github.com/ezcater/ezcater_rubocop/blob/master/lib/rubocop/cop/ezcater/rails_configuration.rb) - Enforce use of `Rails.configuration` instead of `Rails.application.config`.
1. [RspecDotNotSelfDot](https://github.com/ezcater/ezcater_rubocop/blob/master/lib/rubocop/cop/ezcater/rspec_dot_not_self_dot.rb) - Enforce ".<class method>" instead of "self.<class method>" for example group description.
1. [RspecRequireBrowserMock](https://github.com/ezcater/ezcater_rubocop/blob/master/lib/rubocop/cop/ezcater/rspec_require_browser_mock.rb) - Enforce use of `mock_ezcater_app`, `mock_chrome_browser` & `mock_custom_browser` helpers instead of mocking `Browser` or `EzBrowser` directly.
1. [RspecRequireFeatureFlagMock](https://github.com/ezcater/ezcater_rubocop/blob/master/lib/rubocop/cop/ezcater/rspec_require_feature_flag_mock.rb) - Enforce use of `mock_feature_flag` helper instead of mocking `FeatureFlag.is_active?` directly.
1. [RspecRequireGqlErrorHelpers](https://github.com/ezcater/ezcater_rubocop/blob/master/lib/rubocop/cop/ezcater/rspec_require_gql_error_helpers.rb) - Use the helpers provided by `GQLErrors` instead of raising `GraphQL::ExecutionError` directly.
1. [StyleDig](https://github.com/ezcater/ezcater_rubocop/blob/master/lib/rubocop/cop/ezcater/style_dig.rb) - Recommend `dig` for deeply nested access.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ezcater/ezcater_rubocop.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
