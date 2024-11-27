# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Ezcater::FeatureFlagActive, :config do
  let(:tracking_id) { generate_tracking_id }

  %w(EzcaterFeatureFlag EzFF ::EzFF ::EzcaterFeatureFlag).each do |constant_name|
    describe "calling #{constant_name}.active?" do
      context "with a tracking_id" do
        it "does not report an offense" do
          expect_no_offenses <<~RUBY
            #{constant_name}.active?("FakeFlagName", tracking_id: "#{tracking_id}")
          RUBY
        end
      end

      context "with a variable instead of a flag name" do
        it "does not report an offense" do
          expect_no_offenses <<~RUBY
            def evaluate(my_flag_name_var)
              #{constant_name}.active?(my_flag_name_var, identifiers: ["#{tracking_id}"])
            end
          RUBY
        end
      end

      context "with an instance variable instead of a flag name" do
        it "does not report an offense" do
          expect_no_offenses <<~RUBY
            #{constant_name}.active?(@flag_ivar, identifiers: ["#{tracking_id}"])
          RUBY
        end
      end

      context "with a constant instead of a flag name" do
        it "does not report an offense" do
          expect_no_offenses <<~RUBY
            FLAG_VAR = "FAKE_FLAG_NAME"
            #{constant_name}.active?(FLAG_VAR, identifiers: ["#{tracking_id}"])
          RUBY
        end
      end

      context "with a dot method call instead of a flag name" do
        it "does not report an offense" do
          expect_no_offenses <<~RUBY
            #{constant_name}.active?(config.flag_name, identifiers: ["#{tracking_id}"])
          RUBY
        end
      end

      context "with a symbol instead of a flag name" do
        it "reports an offense" do
          dynamic_highlight_width = "^" * (constant_name.size + tracking_id.size)

          expect_offense <<~RUBY
            #{constant_name}.active?(:my_flag_sym, identifiers: ["#{tracking_id}"])
            #{dynamic_highlight_width}^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ The first argument to `EzFF.active?` must be a string literal or a variable or constant assigned to a string
          RUBY
        end
      end

      context "with an integer instead of a flag name" do
        it "reports an offense" do
          dynamic_highlight_width = "^" * (constant_name.size + tracking_id.size)

          expect_offense <<~RUBY
            #{constant_name}.active?(13, identifiers: ["#{tracking_id}"])
            #{dynamic_highlight_width}^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ The first argument to `EzFF.active?` must be a string literal or a variable or constant assigned to a string
          RUBY
        end
      end

      context "with an identifiers array" do
        it "does not report an offense" do
          expect_no_offenses <<~RUBY
            #{constant_name}.active?("FakeFlagName", identifiers: ["#{tracking_id}"])
          RUBY
        end
      end

      context "with unexpected keyword args" do
        it "reports an offense" do
          dynamic_highlight_width = "^" * (constant_name.size + tracking_id.size)

          expect_offense <<~RUBY
            #{constant_name}.active?("FakeFlagName", bad_arg: ["#{tracking_id}"])
            #{dynamic_highlight_width}^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ `EzFF.active?` must be called with at least one of `tracking_id` or `identifiers`
          RUBY
        end
      end

      context "with no keyword args" do
        it "reports an offense" do
          dynamic_highlight_width = "^" * constant_name.size

          expect_offense <<~RUBY
            #{constant_name}.active?("FakeFlagName")
            #{dynamic_highlight_width}^^^^^^^^^^^^^^^^^^^^^^^^ `EzFF.active?` must be called with at least one of `tracking_id` or `identifiers`
          RUBY
        end
      end
    end
  end

  context "other lines that parse to use `send` in the AST don't get caught" do
    context "require" do
      it "reports nothing" do
        expect_no_offenses <<~RUBY
          require "bar"
        RUBY
      end
    end

    context "config blocks" do
      it "reports nothing" do
        expect_no_offenses <<~RUBY
          Configuration.config do |config|
            config.foo = true
          end
        RUBY
      end
    end
  end

  def generate_tracking_id
    [
      %w(user brand caterer).sample,
      rand(200),
    ].join(":")
  end
end
