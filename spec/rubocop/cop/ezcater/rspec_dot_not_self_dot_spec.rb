# encoding utf-8
# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Ezcater::RspecDotNotSelfDot, :config do
  subject(:cop) { described_class.new(config) }

  let(:self_dot_msg) { [described_class::SELF_DOT_MSG] }
  let(:colon_colon_msg) { [described_class::COLON_COLON_REGEXP] }

  RuboCop::RSpec::Language::ExampleGroups::ALL.each do |name|
    it "corrects #{name} with `self.class_method`" do
      source = "#{name} \"self.class_method\" do\nend"
      inspect_source(source)
      expect(cop.highlights).to match_array(['"self.class_method"'])
      expect(cop.messages).to match_array(self_dot_msg)
      expect(autocorrect_source(source)).to eq(source.sub("self.", "."))
    end

    it "corrects #{name} with `self.class_method` and metadata" do
      source = "#{name} \"self.class_method\", foo: true do\nend"
      inspect_source(source)
      expect(cop.highlights).to match_array(['"self.class_method"'])
      expect(cop.messages).to match_array(self_dot_msg)
      expect(autocorrect_source(source)).to eq(source.sub("self.", "."))
    end

    it "corrects #{name} with `::class_method`" do
      source = "#{name} \"::class_method\" do\nend"
      inspect_source(source)
      expect(cop.highlights).to match_array(['"::class_method"'])
      expect(cop.messages).to match_array(colon_colon_msg)
      expect(autocorrect_source(source)).to eq(source.sub("::", "."))
    end

    it "corrects #{name} with `::class_method` and metadata" do
      source = "#{name} \"::class_method\", foo: true do\nend"
      inspect_source(source)
      expect(cop.highlights).to match_array(['"::class_method"'])
      expect(cop.messages).to match_array(colon_colon_msg)
      expect(autocorrect_source(source)).to eq(source.sub("::", "."))
    end

    it "accepts #{name} with `.class_method`" do
      source = "#{name} \".class_method\" do\nend"
      inspect_source(source)
      expect(cop.offenses).to be_empty
    end
  end

  RuboCop::RSpec::Language::Examples::ALL.each do |name|
    it "accepts #{name} with `self.class_method`" do
      source = "#{name} \"self.class_method\" do\nend"
      inspect_source(source)
      expect(cop.offenses).to be_empty
    end
  end
end
