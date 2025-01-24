# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Ezcater::Migration::BigintForeignKey, :config do
  let(:message) do
    <<~MSG.chomp
      To prevent foreign keys from potentially running out of int values before their referenced primary keys, use `bigint` instead of `integer`.
    MSG
  end

  context "when adding a column using t.* methods" do
    it "registers an offense when adding a column ending in \"_id\" that's not a bigint (symbol name)" do
      expect_offense(<<~RUBY)
        create_table :foos do |t|
          t.integer :bar_id
          ^^^^^^^^^^^^^^^^^ #{message}
        end
      RUBY

      expect_correction(<<~RUBY)
        create_table :foos do |t|
          t.bigint :bar_id
        end
      RUBY
    end

    it "registers an offense when adding a column ending in \"_id\" that's not a bigint (string name)" do
      expect_offense(<<~RUBY)
        create_table :foos do |t|
          t.integer "bar_id"
          ^^^^^^^^^^^^^^^^^^ #{message}
        end
      RUBY

      expect_correction(<<~RUBY)
        create_table :foos do |t|
          t.bigint "bar_id"
        end
      RUBY
    end

    it "registers an offense when adding a column ending in \"_id\" that specifies a limit < 8 as its only hash key" do
      expect_offense(<<~RUBY)
        create_table :foos do |t|
          t.integer :bar_id, limit: 7
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^ #{message}
        end
      RUBY

      expect_correction(<<~RUBY)
        create_table :foos do |t|
          t.bigint :bar_id
        end
      RUBY
    end

    it "registers an offense when adding a column ending in \"_id\" that \
    specifies a limit < 8 as one of several hash keys" do
      expect_offense(<<~RUBY)
        create_table :foos do |t|
          t.integer :bar_id, null: false, limit: 7
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ #{message}
        end
      RUBY

      expect_no_corrections
    end

    it "registers an offense when adding a reference that specifies an :integer type" do
      expect_offense(<<~RUBY)
        create_table :foos do |t|
          t.references :bar, type: :integer
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ #{message}
        end
      RUBY

      expect_correction(<<~RUBY)
        create_table :foos do |t|
          t.references :bar
        end
      RUBY
    end

    it "registers an offense when adding a reference that specifies an :integer type and a limit < 8" do
      expect_offense(<<~RUBY)
        create_table :foos do |t|
          t.references :bar, type: :integer, limit: 7
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ #{message}
        end
      RUBY

      expect_correction(<<~RUBY)
        create_table :foos do |t|
          t.references :bar
        end
      RUBY
    end

    it "registers an offense when adding a belongs_to that specifies an :integer type" do
      expect_offense(<<~RUBY)
        create_table :foos do |t|
          t.belongs_to :bar, type: :integer
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ #{message}
        end
      RUBY

      expect_correction(<<~RUBY)
        create_table :foos do |t|
          t.belongs_to :bar
        end
      RUBY
    end

    it "registers an offense when adding a belongs_to that specifies an :integer type and a limit < 8" do
      expect_offense(<<~RUBY)
        create_table :foos do |t|
          t.belongs_to :bar, type: :integer, limit: 7
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ #{message}
        end
      RUBY

      expect_correction(<<~RUBY)
        create_table :foos do |t|
          t.belongs_to :bar
        end
      RUBY
    end

    it "does not register an offense when adding a column not ending in \"_id\"" do
      expect_no_offenses(<<~RUBY)
        create_table :foos do |t|
          t.integer :bar
        end
      RUBY
    end

    it "does not register an offense when adding a column ending in \"_id\" that's a bigint" do
      expect_no_offenses(<<~RUBY)
        create_table :foos do |t|
          t.bigint :bar_id
        end
      RUBY
    end

    it "does not register an offense when adding a column ending in \"_id\" that specifies a limit >= 8" do
      expect_no_offenses(<<~RUBY)
        create_table :foos do |t|
          t.integer :bar_id, limit: 8
        end
      RUBY
    end

    it "does not register an offense when using #references" do
      expect_no_offenses(<<~RUBY)
        create_table :foos do |t|
          t.references :bar
        end
      RUBY
    end

    it "does not register an offense when using #references with limit >= 8" do
      expect_no_offenses(<<~RUBY)
        create_table :foos do |t|
          t.references :bar, type: :integer, limit: 8
        end
      RUBY
    end

    it "does not register an offense when using #belongs_to" do
      expect_no_offenses(<<~RUBY)
        create_table :foos do |t|
          t.belongs_to :bar
        end
      RUBY
    end

    it "does not register an offense when using #belongs_to with limit >= 8" do
      expect_no_offenses(<<~RUBY)
        create_table :foos do |t|
          t.belongs_to :bar, type: :integer, limit: 8
        end
      RUBY
    end
  end

  context "when adding a column using add_* methods" do
    it "registers an offense when adding a column ending in \"_id\" that's not a bigint (symbol name)" do
      expect_offense(<<~RUBY)
        add_column :foos, :bar_id, :integer
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ #{message}
      RUBY

      expect_correction(<<~RUBY)
        add_column :foos, :bar_id, :bigint
      RUBY
    end

    it "registers an offense when adding a column ending in \"_id\" that's not a bigint (string name)" do
      expect_offense(<<~RUBY)
        add_column :foos, "bar_id", :integer
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ #{message}
      RUBY

      expect_correction(<<~RUBY)
        add_column :foos, "bar_id", :bigint
      RUBY
    end

    it "registers an offense when adding a column ending in \"_id\" that specifies a limit < 8 as its only hash key" do
      expect_offense(<<~RUBY)
        add_column :foos, :bar_id, :integer, limit: 7
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ #{message}
      RUBY

      expect_correction(<<~RUBY)
        add_column :foos, :bar_id, :bigint
      RUBY
    end

    it "registers an offense when adding a column ending in \"_id\" that \
    specifies a limit < 8 as one of several hash keys" do
      expect_offense(<<~RUBY)
        add_column :foos, :bar_id, :integer, null: false, limit: 7
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ #{message}
      RUBY

      expect_no_corrections
    end

    it "registers an offense when adding a reference that specifies an :integer type" do
      expect_offense(<<~RUBY)
        add_reference :foos, :bar, type: :integer
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ #{message}
      RUBY

      expect_correction(<<~RUBY)
        add_reference :foos, :bar
      RUBY
    end

    it "registers an offense when adding a reference that specifies an :integer type and a limit < 8" do
      expect_offense(<<~RUBY)
        add_reference :foos, :bar, type: :integer, limit: 7
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ #{message}
      RUBY

      expect_correction(<<~RUBY)
        add_reference :foos, :bar
      RUBY
    end

    it "registers an offense when adding a belongs_to that specifies an :integer type" do
      expect_offense(<<~RUBY)
        add_belongs_to :foos, :bar, type: :integer
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ #{message}
      RUBY

      expect_correction(<<~RUBY)
        add_belongs_to :foos, :bar
      RUBY
    end

    it "registers an offense when adding a belongs_to that specifies an :integer type and a limit < 8" do
      expect_offense(<<~RUBY)
        add_belongs_to :foos, :bar, type: :integer, limit: 7
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ #{message}
      RUBY

      expect_correction(<<~RUBY)
        add_belongs_to :foos, :bar
      RUBY
    end

    it "does not register an offense when adding a column not ending in \"_id\"" do
      expect_no_offenses(<<~RUBY)
        add_column :foos, :bar, :integer
      RUBY
    end

    it "does not register an offense when adding a column ending in \"_id\" that's a bigint" do
      expect_no_offenses(<<~RUBY)
        add_column :foos, :bar_id, :bigint
      RUBY
    end

    it "does not register an offense when adding a column ending in \"_id\" that specifies a limit >= 8" do
      expect_no_offenses(<<~RUBY)
        add_column :foos, :bar_id, :integer, limit: 8
      RUBY
    end

    it "does not register an offense when using #add_reference" do
      expect_no_offenses(<<~RUBY)
        add_reference :foos, :bar
      RUBY
    end

    it "does not register an offense when using #add_reference with limit >= 8" do
      expect_no_offenses(<<~RUBY)
        add_reference :foos, :bar, type: :integer, limit: 8
      RUBY
    end

    it "does not register an offense when using #add_belongs_to" do
      expect_no_offenses(<<~RUBY)
        add_belongs_to :foos, :bar
      RUBY
    end

    it "does not register an offense when using #add_belongs_to with limit >= 8" do
      expect_no_offenses(<<~RUBY)
        add_belongs_to :foos, :bar, type: :integer, limit: 8
      RUBY
    end
  end
end
