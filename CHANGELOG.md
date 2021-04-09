# ezcater_rubocop

# Versioning

This gem is moving onto its own [Semantic Versioning](https://semver.org/) scheme starting with v1.0.0. All version bumps moving forward should increment using `MAJOR.MINOR.PATCH` based on changes.

Prior to v1.0.0 this gem was versioned based on the `MAJOR`.`MINOR` version of RuboCop. The first release of the ezcater_rubocop gem was `v0.49.0`.

## v2.2.0
- Require Ruby 2.6 or later.
- Set `TargetRubyVersion` to 2.6 in `rubocop_gem` configuration.

## v2.1.0
- Enable `Rails/SaveBang` with `AllowImplicitReturn: false`, and with autocorrection disabled.

## v2.0.0
- Update to `rubocop` v0.81.0, `rubocop-rspec` v1.38.1 and `rubocop-rails` v2.5.2.
- This is being released as a major update because cops have been renamed so this is unlikely to be
  a drop-in replacement.
- This is the first release to support Ruby 2.7.

## v1.4.1
- Correct a matching syntax issue with `Ezcater/RubyTimeout` so that it applies in the expected cases.

## v1.4.0
- Add `Ezcater/RubyTimeout` cop.

## v1.3.0
- Add `Ezcater/GraphqlFieldsNaming` cop.

## v1.2.0
- Add `Ezcater/RailsTopLevelSqlExecute` to replace `ActiveRecord::Base.connection.execute` with `execute` in `db/migrate/`.

## v1.1.1
- Exclude `lib/tasks/` for `Ezcater/RailsEnv` and `Ezcater/DirectEnvCheck`.

## v1.1.0
- Add `Ezcater/RailsEnv` cop.
- Add `Ezcater/DirectEnvCheck` cop.

## v1.0.2
- Exclude bootsnap cache directory (`tmp/cache`).

## v1.0.1
- Disable `Rails/HasAndBelongsToMany` cop.
- Disable `Style/DoubleNegation` cop.

## v1.0.0
- Begin using Semantic Versioning
- Delete `Ezcater/PrivateAttr`

## v0.61.1
- `Layout/IndentHash` enforces consistent style
- `Layout/IndentArray` enforces consistent style

## v0.61.0
- Update to `rubocop` v0.61.1.
- Update to `rubocop-rspec` v1.30.1

## v0.59.0
- Disable `Style/NegatedIf`.

## v0.58.4
- Update `Metrics/BlockLength` to exclude `app/graphql/**/*.rb`
- Move `Metrics/BlockLength` exclusions for `lib/tasks/**/*.rake` and
  `config/environments/*.rb` into rubocop_rails.yml

## v0.58.3
- Updated `Layout/MultilineMethodCallIndentation` to `indented`.

## v0.58.2
- Updated `Ezcater/RspecDotNotSelfDot` to flag offenses for `::class_method`.

## v0.58.1
- Update to `rubocop-rspec` v1.28.0.
- Remove configuration for removed `FactoryBot/DynamicAttributeDefinedStatically` cop.

## v0.58.0
- Update to rubocop v0.58.1.
- Enable `Naming/MemoizedInstanceVariableName` with required leading
  underscore.

## v0.57.4
- Configure `Rspec/MessageExpectation` with the `allow` style.

## v0.57.3
- Do not use broken parser v2.5.1.1.

## v0.57.2
- Fix `Ezcater/RspecRequireHttpStatusMatcher` cop.

## v0.57.1
- Add `Ezcater/RspecRequireHttpStatusMatcher` cop.
- Enable `Rails/HttpStatus` cop and enforce symbols.

## v0.57.0
- Update to rubocop v0.57.2 and rubocop-rspec v1.27.0.
- Disable new cop `Naming/MemoizedInstanceVariableName` until configuration
  options are available.
- Disable `FactoryBot/DynamicAttributeDefinedStatically` due to
  https://github.com/rubocop-hq/rubocop-rspec/issues/655.
- Configure `Naming/UncommunicativeMethodParamName` to allow `e, ex, id`
  param names.
- Exclude appraisal generated gemfiles for gems.

## v0.52.8
- Add new configuration `rubocop_gem` for use with gems.

## v0.52.7
- Enable `Style/FrozenStringLiteralComment` with the `when_needed` style.

## v0.52.6
- Configure `Style/TrailingCommaInLiteral` with `consistent_comma` style.

## v0.52.5
- Add `Ezcater/RspecMatchOrderedArray` cop.
- Fix array equality matcher violations in specs.

## v0.52.4
- Configure `Style/RegexpLiteral` cop with the `AllowInnerSlashes: true` option.

## v0.52.3
- Disable `Style/GuardClause` cop.
- Exclude `spec/integrations` for `RSpec/DescribeClass`.

## v0.52.2
- Disable `Style/IfUnlessModifier` cop.

## v0.52.1
- Allow staging as a rails environment for the Rails/UnknownEnv cop.

## v0.52.0
- Update to rubocop v0.52.1 and rubocop-rspec v1.22.2.

## v0.51.8
- Disable `RSpec/LetSetup` cop.

## v0.51.7
- Rename `Ezcater/RspecRequireGqlErrorHelpers` cop to `Ezcater/RequireGqlErrorHelpers`.

## v0.51.6
- Add `Ezcater/RailsConfiguration` cop.
- Exclude `config/environments/*.rb` for the `Metrics/BlockLength` cop.

## v0.51.5
- Add `Ezcater/RspecRequireGqlErrorHelpers` cop.

## v0.51.4
- Exclude `Gemfile` for the `Metrics/LineLength` cop.
- Add `system` to the excluded spec directories for `RSpec/DescribeClass`.

## v0.51.3
- Configure `RSpec/DescribeClass` to exclude the spec directories which
  are excluded by explicit metadata.
- Exclude `lib/tasks` for the `Metrics/BlockLength` cop.

## v0.51.2
- Configure `Style/RaiseArgs` to use the `compact` style.

## v0.51.1
- Disable `Rails/FilePath` cop.
- Disable `Style/EmptyLiteral` cop.

## v0.51.0
- Update to rubocop v0.51.0 and rubocop-rspec v1.20.0.
- Disable new cop `RSpec/ContextWording`.
- Disable `Style/StderrPuts` for `bin/yarn`.

## v0.50.5
- Configure `RSpec/NestedGroups` with a `Max` value of 5.

## v0.50.4
- Configure `Style/PercentLiteralDelimiters` to prefer parentheses.

## v0.50.3
- Configure `RSpec/MultipleExpectations` with a `Max` value of 5.

## v0.50.2
- Add `Ezcater/PrivateAttr` custom cop.
- Configure `RSpec/ExampleLength` with a `Max` value of 25.
- Add `circle_rubocop.rb` script.

## v0.50.1
- Add shared configuration.
- Do not apply `Ezcater/StyleDig` to access using a range.

## v0.50.0
- Update to rubocop v0.50.0 and rubocop-rspec v1.18.0.
- Do not apply `Ezcater/StyleDig` to assignments with nested access.

# v0.49.3
- Do not apply `Ezcater/StyleDig` to access using a range.

# v0.49.2
- Do not apply `Ezcater/StyleDig` to assignments to with nested access.

## v0.49.1
- Add `Ezcater/RspecRequireBrowserMock` cop.

## v0.49.0
- Initial release.
- Add `Ezcater/RspecRequireFeatureFlagMock` cop.
- Add `Ezcater/RspecDotNotSelfDot` cop.
- Add `Ezcater/StyleDig` cop.
