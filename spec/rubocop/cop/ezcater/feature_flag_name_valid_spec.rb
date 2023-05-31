# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Ezcater::FeatureFlagNameValid, :config do
  subject(:cop) { described_class.new(config) }

  before { inspect_source(line) }
  describe "assignment to a constant" do
    %w(_FF _FLAG _FLAG_NAME _FEATURE_FLAG).each do |suffix|
      describe "assignment to a constant ending in #{suffix}" do
        %w(Flag1 Foo Foo::Bar Foo::Bar::Baz).each do |valid_flag_name|
          context "with a valid feature flag name: #{valid_flag_name}" do
            let(:line) { %[SOMETHING#{suffix} = #{valid_flag_name}] }
      
            it "does not report an offense" do
              expect(cop.offenses).to be_empty
            end
          end
        end

        context "with an invalid feature flag name: flag1" do
          let(:line) { %[SOMETHING#{suffix} = "flag1"] }
    
          it "reports an offense for titlecase" do
            expect(cop.messages).to match_array(["Feature flag names must use titlecase for each segment."])
          end
        end

        context "with an invalid feature flag name: Foo:bar" do
          let(:line) { %[SOMETHING#{suffix} = "Foo:bar"] }
    
          it "reports an offense for single colon use and titlecase" do
            expect(cop.messages).to match_array(
              [
                "Feature flag names must use double colons (::) as namespace separators., " \
                "Feature flag names must use titlecase for each segment."
              ]
            )
          end
        end

        context "with an invalid feature flag name: Foo:::Bar " do
          let(:line) { %[SOMETHING#{suffix} = "Foo :::B%ar"] }
    
          it "reports an offense for triple colon use and whitespace" do
            expect(cop.messages).to match_array(
              [
                "Feature flag names must not contain whitespace., " \
                "Feature flag names must use double colons (::) as namespace separators., " \
                "Feature flag names must only contain alphanumeric characters and colons., " \
                "Feature flag names must use titlecase for each segment."
              ]
            )
          end
        end
      end
    end
  end

  %w(EzcaterFeatureFlag EzFF ::EzFF ::EzcaterFeatureFlag).each do |klass_name|
    %w(active? at_100? random_sample_active?).each do |method_name|
      describe "method call to #{klass_name}.#{method_name}" do
        context "with a valid feature flag name" do
          let(:line) { %[#{klass_name}.#{method_name}("Foo::Bar", tracking_id: 1234)] }

          it "does not report an offense" do
            expect(cop.offenses).to be_empty
          end
        end

        context "with an invalid feature flag name" do
          let(:line) { %[#{klass_name}.#{method_name}("Foo:bar")] }

          it "reports an offense" do
            expect(cop.messages).to match_array(
              ["Feature flag names must use double colons (::) as namespace separators., Feature flag names must use titlecase for each segment."]
            )
          end
        end
      end
    end
  end
end
