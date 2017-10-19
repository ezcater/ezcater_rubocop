# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Ezcater::PrivateAttr do
  subject(:cop) { described_class.new }

  %i[private protected].each do |access_modifier|
    described_class::ATTR_METHODS.each do |method_name|
      context "when `#{access_modifier}` is applied to `#{method_name}`" do
        it "registers an offense" do
          expect_offense(<<-RUBY.strip_indent)
        class C
          #{access_modifier}

          #{method_name} :foo
          #{'^' * (method_name.size + 5)} Use `#{access_modifier}_#{method_name}` instead
        end
          RUBY
        end
      end

      context "when `#{access_modifier}` is applied to `#{method_name}` across multiple lines" do
        it "registers an offense" do
          expect_offense(<<-RUBY.strip_indent)
        class C
          #{access_modifier}

          #{method_name} :foo,
          #{'^' * (method_name.size + 6)} Use `#{access_modifier}_#{method_name}` instead
                         :bar
        end
          RUBY
        end
      end

      context "when `#{access_modifier}` is applied after `#{method_name}`" do
        it "doesn't register an offense" do
          expect_no_offenses(<<-RUBY.strip_indent)
        class C
          #{method_name} :foo

          #{access_modifier}
        end
          RUBY
        end
      end

      context "when `protected` is applied after `#{method_name}`" do
        it "doesn't register an offense" do
          expect_no_offenses(<<-RUBY.strip_indent)
        class C
          #{method_name} :foo

          protected
        end
          RUBY
        end
      end
    end

    context "when `#{access_modifier}` is applied to `alias_method`" do
      it "registers an offense" do
        expect_offense(<<-RUBY.strip_indent)
      class C
        #{access_modifier}

        alias_method :new_foo, :foo
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use `#{access_modifier}_alias_method` instead
      end
        RUBY
      end
    end
  end
end
