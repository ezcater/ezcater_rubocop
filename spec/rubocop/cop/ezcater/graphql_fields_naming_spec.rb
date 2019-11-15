# encoding utf-8
# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Ezcater::GraphqlFieldsNaming, :config do
  subject(:cop) { described_class.new(config) }

  let(:cop_config) do
    {
      "EnforcedStyle" => "snake_case",
      "SupportedStyles" => %w(snake_case camelCase),
      "Include" => ["*"] # allow all during specs
    }
  end

  let(:err_msg) { format(described_class::MSG, style: "snake_case") }

  context "when value is the enforced style" do
    let(:good_field_name) { :test_name }

    context "when field is given as a regular method call" do
      it "does not give any offense" do
        source = "field :#{good_field_name}"

        inspect_source(source)

        expect(cop.offenses).to be_empty
      end
    end

    context "when field is given as a block" do
      it "does not give any offense" do
        source = <<~TEXT
          field :#{good_field_name}, ID, null: true do
            argument :test, Boolean
          end
        TEXT
        inspect_source(source)

        expect(cop.offenses).to be_empty
      end
    end

    context "when an argument is given" do
      it "does not give any offense" do
        source = "argument :#{good_field_name}"

        inspect_source(source)

        expect(cop.offenses).to be_empty
      end
    end
  end

  context "when value is the incorrect style" do
    let(:bad_field_name) { :testName }

    context "when field is given as a regular method call" do
      it "warns the user to use the preferred style" do
        source = "field :#{bad_field_name}"

        inspect_source(source)

        expect(cop.messages).to match_array [err_msg]
      end
    end

    context "when field is given as a block" do
      it "warns the user to use the preferred style" do
        source = <<~TEXT
          field :#{bad_field_name}, ID, null: true do
            argument :test, Boolean
          end
        TEXT
        inspect_source(source)

        expect(cop.messages).to match_array [err_msg]
      end
    end

    context "when an argument is given" do
      it "warns the user to use the preferred style" do
        source = "argument :#{bad_field_name}"

        inspect_source(source)

        expect(cop.messages).to match_array [err_msg]
      end
    end

    context "when the user manually requested to camelize: the field" do
      it "does not register an offense" do
        source = <<~TEXT
          field :#{bad_field_name}, ID, null: true, camelize: false do
            argument :test, Boolean
          end
        TEXT
        inspect_source(source)

        expect(cop.offenses).to be_empty
      end
    end
  end

  context "when the field is defined from a different source" do
    it "does not try to lint the line" do
      source = <<~TEXT
        ['source'].each do |type|
          method_name = "type_url"
          field(method_name.camelize(:lower), String, null: true)
        end
      TEXT
      inspect_source(source)

      expect(cop.offenses).to be_empty
    end
  end

  context "when the method call is not a GraphQL definitions" do
    it "does not try to lint the line" do
      source = <<~TEXT
        object.payments.order(order_by.field => order_by.direction)
      TEXT
      inspect_source(source)

      expect(cop.offenses).to be_empty
    end
  end

  context "when method call does not create a field or argument" do
    it "does not try to lint the line" do
      source = "description('Too Cool For School')"
      inspect_source(source)

      expect(cop.offenses).to be_empty
    end
  end
end
