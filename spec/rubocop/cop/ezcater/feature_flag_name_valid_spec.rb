# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Ezcater::FeatureFlagNameValid, :config do
  describe "assignment to a constant" do
    %w(_FF _FLAG _FLAG_NAME _FEATURE_FLAG).each do |suffix|
      describe "assignment to a constant ending in #{suffix}" do
        %w(Flag1 Foo Foo::Bar Foo::Bar::Baz).each do |valid_flag_name|
          context "with a valid feature flag name: #{valid_flag_name}" do
            it "does not report an offense" do
              expect_no_offenses <<~RUBY
                SOMETHING#{suffix} = #{valid_flag_name}
              RUBY
            end
          end
        end

        context "with an invalid feature flag name: flag1" do
          it "reports an offense for titlecase" do
            dynamic_highlight_width = "^" * suffix.size

            expect_offense <<~RUBY
              SOMETHING#{suffix} = "flag1"
              #{dynamic_highlight_width}^^^^^^^^^^^^^^^^^^^ Feature flag names must use titlecase for each segment.
            RUBY
          end
        end

        context "with an invalid feature flag name: Foo:bar" do
          let(:line) { %(SOMETHING#{suffix} = "Foo:bar") }

          it "reports an offense for single colon use and titlecase" do
            dynamic_highlight_width = "^" * suffix.size

            expect_offense <<~RUBY
              SOMETHING#{suffix} = "Foo:bar"
              #{dynamic_highlight_width}^^^^^^^^^^^^^^^^^^^^^ Feature flag names must use double colons (::) as namespace separators., Feature flag names must use titlecase for each segment.
            RUBY
          end
        end

        context "with an invalid feature flag name: Foo:::Bar " do
          it "reports an offense for triple colon use and whitespace" do
            dynamic_highlight_width = "^" * suffix.size

            expect_offense <<~RUBY
              SOMETHING#{suffix} = "Foo :::B%ar"
              #{dynamic_highlight_width}^^^^^^^^^^^^^^^^^^^^^^^^^ Feature flag names must not contain whitespace., Feature flag names must use double colons (::) as namespace separators., Feature flag names must only contain alphanumeric characters and colons., Feature flag names must use titlecase for each segment.
            RUBY
          end
        end
      end
    end
  end

  %w(EzcaterFeatureFlag EzFF ::EzFF ::EzcaterFeatureFlag).each do |klass_name|
    %w(active? at_100? random_sample_active?).each do |method_name|
      describe "method call to #{klass_name}.#{method_name}" do
        context "with a valid feature flag name" do
          it "does not report an offense" do
            expect_no_offenses <<~RUBY
              #{klass_name}.#{method_name}("Foo::Bar", tracking_id: "1234")
            RUBY
          end
        end

        context "with an invalid feature flag name" do
          it "reports an offense" do
            dynamic_highlight_width = "^" * (klass_name.size + method_name.size)

            expect_offense <<~RUBY
              #{klass_name}.#{method_name}("Foo:bar")
              #{dynamic_highlight_width}^^^^^^^^^^^^ Feature flag names must use double colons (::) as namespace separators., Feature flag names must use titlecase for each segment.
            RUBY
          end

          context "without a tracking id" do
            it "does not report an offense" do
              expect_no_offenses <<~RUBY
                #{klass_name}.#{method_name}("Foobar")
              RUBY
            end
          end
        end
      end
    end
  end
end
