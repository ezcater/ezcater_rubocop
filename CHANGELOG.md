# ezcater_rubocop

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
