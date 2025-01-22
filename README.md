# ezcater_rubocop [![CircleCI](https://circleci.com/gh/ezcater/ezcater_rubocop/tree/main.svg?style=svg)](https://circleci.com/gh/ezcater/ezcater_rubocop/tree/main)

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

The behavior of the script is that all files are checked on main or if the rubocop
configuration has changed. On non-main branches, only the files added or changed on
the branch are checked.

For non-main branches, `[rubocop skip]` can be included in the commit message to skip
running rubocop.

## Versioning

This gem is using [Semantic Versioning](https://semver.org/). All version bumps should increment using `MAJOR.MINOR.PATCH` based on changes.

When adding a new cop, please enable the cop and release a new major version. This allows us to
constantly roll out improvements without clients having their suite break unknowingly. When a
breaking change is released, users can opt to use `--regenerate-todo` to update their TODO file. Do
not add cops with `enabled: false` unless you want that cop to always be disabled.

## Custom Cops

* [FeatureFlagActive](https://github.com/ezcater/ezcater_rubocop/blob/main/lib/rubocop/cop/ezcater/feature_flag_active.rb) - Enforce the proper arguments are given to `EzcaterFeatureFlag.active?`
* [FeatureFlagNameValid](https://github.com/ezcater/ezcater_rubocop/blob/main/lib/rubocop/cop/ezcater/feature_flag_name_valid.rb) - Enforce correct flag name format is being used.
* [GraphQL/NotAuthorizedScalarField] - Enforces the use of
  authorization (pundit or, optionally, the guard pattern) for scalar
  fields. See examples within class comment for additional configuration.
* [RailsConfiguration](https://github.com/ezcater/ezcater_rubocop/blob/main/lib/rubocop/cop/ezcater/rails_configuration.rb) - Enforce use of `Rails.configuration` instead of `Rails.application.config`.
* [RequireGqlErrorHelpers](https://github.com/ezcater/ezcater_rubocop/blob/main/lib/rubocop/cop/ezcater/require_gql_error_helpers.rb) - Use the helpers provided by `GQLErrors` instead of raising `GraphQL::ExecutionError` directly.
* [RspecDotNotSelfDot](https://github.com/ezcater/ezcater_rubocop/blob/main/lib/rubocop/cop/ezcater/rspec_dot_not_self_dot.rb) - Enforce ".<class method>" instead of "self.<class method>" and "::<class method>" for example group description.
* [RspecMatchOrderedArray](https://github.com/ezcater/ezcater_rubocop/blob/main/lib/rubocop/cop/ezcater/rspec_match_ordered_array.rb) - Enforce use of `match_ordered_array` matcher instead of `eq` matcher. This matcher comes from the [ezcater_matchers](https://github.com/ezcater/ezcater_matchers) gem.
* [RspecRequireBrowserMock](https://github.com/ezcater/ezcater_rubocop/blob/main/lib/rubocop/cop/ezcater/rspec_require_browser_mock.rb) - Enforce use of `mock_ezcater_app`, `mock_chrome_browser` & `mock_custom_browser` helpers instead of mocking `Browser` or `EzBrowser` directly.
* [RspecRequireFeatureFlagMock](https://github.com/ezcater/ezcater_rubocop/blob/main/lib/rubocop/cop/ezcater/rspec_require_feature_flag_mock.rb) - Enforce use of `mock_feature_flag` helper instead of mocking `FeatureFlag.is_active?` directly.
* [RspecRequireHttpStatusMatcher](https://github.com/ezcater/ezcater_rubocop/blob/main/lib/rubocop/cop/ezcater/rspec_require_http_status_matcher.rb) - Use the HTTP status code matcher, like `expect(response).to have_http_status :bad_request`, rather than `expect(response.code).to eq 400`
* [StyleDig](https://github.com/ezcater/ezcater_rubocop/blob/main/lib/rubocop/cop/ezcater/style_dig.rb) - Recommend `dig` for deeply nested access.
* [Migration/BigintForeignKey](https://github.com/ezcater/ezcater_rubocop/blob/main/lib/rubocop/cop/ezcater/migration/bigint_foreign_key.rb) - Use `#bigint` instead of `#integer` for all foreign keys.

[GraphQL/NotAuthorizedScalarField]: https://github.com/ezcater/ezcater_rubocop/blob/main/lib/rubocop/cop/ezcater/graphql/not_authorized_scalar_field.rb)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

### Releasing a New Version

To release a new version, update the version number in `version.rb`, merge your PR to `main`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ezcater/ezcater_rubocop.

### Adding New Cops

New cops can be generated via the `new_cop` rake task which generates
the cop, the spec, updates imports, and adds configuration. Example:

``` shell
rake 'new_cop[Ezcater/foo_bar]'
```

Follow the instructions after the task executes and update code as
necessary for consistency.


In addition, you need to:

1. Add the cop to the "Custom Cops" section of this README
2. Bump the version.
3. Add a CHANGELOG entry.


### Version Bumps & Changelog Entries

The version for this gem follows [Semantic Versioning]:

1. Bump the MAJOR version for breaking changes. Example: new cop,
   enabled by default and which cannot be safely autofixed.

2. Bump the MINOR version for new functionality which will not disrupt
   projects which depend on this gem. Example: new cop, not enabled by
   default or which can safely be autofixed.

3. Bump the PATCH version for backwards compatible bugfixes.

[Semantic Versioning]: https://semver.org/

The version does not need to be bumped and the changelog does not need
to be updated for chores which do not affect users of this
gem. Example: updating CI. Omitting these details helps keep the
signal-to-noise ratio high for people upgrading the gem as these types
of changes will not affect them.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
