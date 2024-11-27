# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Ezcater::RspecDotNotSelfDot, :config do
  described_class::EXAMPLE_GROUP_IDENTIFIERS.each do |name|
    it "corrects #{name} with `self.class_method`" do
      left_pad_for_highlight = " " * name.size

      expect_offense <<~RUBY
        #{name} "self.class_method" do; end
        #{left_pad_for_highlight} ^^^^^^^^^^^^^^^^^^^ Use ".<class method>" instead of "self.<class method>" for example group description.
      RUBY

      expect_correction <<~RUBY
        #{name} ".class_method" do; end
      RUBY
    end

    it "corrects #{name} with `self.class_method` and metadata" do
      left_pad_for_highlight = " " * name.size

      expect_offense <<~RUBY
        #{name} "self.class_method", foo: true do; end
        #{left_pad_for_highlight} ^^^^^^^^^^^^^^^^^^^ Use ".<class method>" instead of "self.<class method>" for example group description.
      RUBY

      expect_correction <<~RUBY
        #{name} ".class_method", foo: true do; end
      RUBY
    end

    it "corrects #{name} with `::class_method`" do
      left_pad_for_highlight = " " * name.size

      expect_offense <<~RUBY
        #{name} "::class_method" do; end
        #{left_pad_for_highlight} ^^^^^^^^^^^^^^^^ Use ".<class method>" instead of "::<class method>" for example group description.
      RUBY

      expect_correction <<~RUBY
        #{name} ".class_method" do; end
      RUBY
    end

    it "corrects #{name} with `::class_method` and metadata" do
      left_pad_for_highlight = " " * name.size

      expect_offense <<~RUBY
        #{name} "::class_method", foo: true do; end
        #{left_pad_for_highlight} ^^^^^^^^^^^^^^^^ Use ".<class method>" instead of "::<class method>" for example group description.
      RUBY

      expect_correction <<~RUBY
        #{name} ".class_method", foo: true do; end
      RUBY
    end

    it "accepts #{name} with `.class_method`" do
      expect_no_offenses <<~RUBY
        #{name} ".class_method" do; end
      RUBY
    end

    it "accepts #{name} with `self.` not at the start of the string" do
      expect_no_offenses <<~RUBY
        #{name} "something self.class_method" do; end
      RUBY
    end

    it "accepts #{name} with `::` not at the start of the string" do
      expect_no_offenses <<~RUBY
        #{name} "something ::class_method" do; end
      RUBY
    end
  end

  described_class::EXAMPLE_IDENTIFIERS.each do |name|
    it "accepts #{name} with `self.class_method`" do
      expect_no_offenses <<~RUBY
        #{name} "self.class_method" do; end
      RUBY
    end
  end
end
