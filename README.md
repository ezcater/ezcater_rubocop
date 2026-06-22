> [!IMPORTANT]
> ## ⚠️ This gem is deprecated and this repository is archived
>
> `ezcater_rubocop` has been replaced by **`linter`** (repository:
> [`ezcater/linter-ruby`](https://github.com/ezcater/linter-ruby)), a rewrite
> built on composable lint profiles. No further releases of `ezcater_rubocop`
> will be published, and this repository is now read-only.
>
> **For ezCater engineers:** migrate to the `linter` gem. See the
> [`linter-ruby` README](https://github.com/ezcater/linter-ruby) for setup.
>
> **For external / public consumers:** the replacement `linter` gem is
> **internal to ezCater and not publicly available**. We recommend dropping the
> `ezcater_rubocop` development dependency and vendoring your own RuboCop
> configuration (copy whichever rules you rely on from this repo's `conf/`
> directory into a local `.rubocop.yml`).
>
> The content below is preserved for historical reference only.

---

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

### Documentation

Visit https://gemdocs.org/gems/ezcater_rubocop to view the documentation for our custom cops in the latest release.

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
* [RspecNoResolveClassField](https://github.com/ezcater/ezcater_rubocop/blob/main/lib/rubocop/cop/ezcater/rspec_no_resolve_class_field.rb) - Do not use deprecated GraphQL testing interface `resolve_class_field`.
* [RspecRequireBrowserMock](https://github.com/ezcater/ezcater_rubocop/blob/main/lib/rubocop/cop/ezcater/rspec_require_browser_mock.rb) - Enforce use of `mock_ezcater_app`, `mock_chrome_browser` & `mock_custom_browser` helpers instead of mocking `Browser` or `EzBrowser` directly.
* [RspecRequireFeatureFlagMock](https://github.com/ezcater/ezcater_rubocop/blob/main/lib/rubocop/cop/ezcater/rspec_require_feature_flag_mock.rb) - Enforce use of `mock_feature_flag` helper instead of mocking `FeatureFlag.is_active?` directly.
* [RspecRequireHttpStatusMatcher](https://github.com/ezcater/ezcater_rubocop/blob/main/lib/rubocop/cop/ezcater/rspec_require_http_status_matcher.rb) - Use the HTTP status code matcher, like `expect(response).to have_http_status :bad_request`, rather than `expect(response.code).to eq 400`
* [StyleDig](https://github.com/ezcater/ezcater_rubocop/blob/main/lib/rubocop/cop/ezcater/style_dig.rb) - Recommend `dig` for deeply nested access.
* [Migration/BigintForeignKey](https://github.com/ezcater/ezcater_rubocop/blob/main/lib/rubocop/cop/ezcater/migration/bigint_foreign_key.rb) - Use `#bigint` instead of `#integer` for all foreign keys.

[GraphQL/NotAuthorizedScalarField]: https://github.com/ezcater/ezcater_rubocop/blob/main/lib/rubocop/cop/ezcater/graphql/not_authorized_scalar_field.rb

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

### Releasing a New Version

Releases are automated via [release-please](https://github.com/googleapis/release-please-action). When commits following the [Conventional Commits](https://www.conventionalcommits.org/) format are merged to `main`, release-please opens (or updates) a release PR that bumps `version.rb` and updates `CHANGELOG.md` automatically. Merging that PR triggers the `publish-to-rubygems` job, which tags the release and pushes the `.gem` file to [rubygems.org](https://rubygems.org).

You do not need to manually edit `version.rb` or `CHANGELOG.md`. Use the correct commit prefix to drive the version bump:

- `fix:` → patch bump
- `feat:` → minor bump
- `feat!:` or `BREAKING CHANGE:` in the body → major bump

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
2. Use a conventional commit prefix (`feat:` for a non-breaking new cop, `feat!:` for a breaking one) so release-please bumps the version and updates the CHANGELOG automatically.


### Version Bumps & Changelog Entries

Version bumps and CHANGELOG entries are managed automatically by release-please based on [Conventional Commits]. Use the correct prefix on your PR title (squash-and-merge is required):

| Commit prefix | Version bump | Example |
|---|---|---|
| `fix:` | Patch | `fix: correct typo in cop message` |
| `feat:` | Minor | `feat: add StyleDig cop` |
| `feat!:` or `BREAKING CHANGE:` in body | Major | `feat!: enable StyleDig by default` |
| `chore:`, `docs:`, `ci:` | None | `chore: update CI config` |

[Conventional Commits]: https://www.conventionalcommits.org/

`chore:` commits do not trigger a release. This keeps the CHANGELOG focused on changes that affect users of the gem.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
