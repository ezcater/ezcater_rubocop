# ezcater_rubocop

## v0.58.4
- Update `Metrics/BlockLength` to exclude `app/graphql/**/*.rb`
- Move `Metrics/BlockLength` exclusions for `lib/tasks/**/*.rake` and `config/environments/*.rb` into rubocop_rails.yml

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
