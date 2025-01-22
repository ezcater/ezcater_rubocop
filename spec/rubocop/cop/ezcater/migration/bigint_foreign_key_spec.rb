# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Ezcater::Migration::BigintForeignKey, :config do
  it "registers an offense when adding a column ending in \"_id\" that's not a bigint (symbol name)" do
    expect_offense(<<~RUBY)
      create_table :foos do |t|
        t.integer :bar_id
        ^^^^^^^^^^^^^^^^^ To prevent foreign keys from potentially running out of int values before their referenced primary keys, use `#bigint` instead of `#integer`.
      end
    RUBY
  end

  it "registers an offense when adding a column ending in \"_id\" that's not a bigint (string name)" do
    expect_offense(<<~RUBY)
      create_table :foos do |t|
        t.integer "bar_id"
        ^^^^^^^^^^^^^^^^^^ To prevent foreign keys from potentially running out of int values before their referenced primary keys, use `#bigint` instead of `#integer`.
      end
    RUBY
  end

  it "registers an offense when adding a column ending in \"_id\" that specifies a limit < 8 as its only hash key" do
    expect_offense(<<~RUBY)
      create_table :foos do |t|
        t.integer :bar_id, limit: 7
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^ To prevent foreign keys from potentially running out of int values before their referenced primary keys, use `#bigint` instead of `#integer`.
      end
    RUBY
  end

  it "registers an offense when adding a column ending in \"_id\" that specifies a limit < 8 as one of several hash keys" do
    expect_offense(<<~RUBY)
      create_table :foos do |t|
        t.integer :bar_id, null: false, limit: 7
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ To prevent foreign keys from potentially running out of int values before their referenced primary keys, use `#bigint` instead of `#integer`.
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

  it "does not register an offense when adding a foreign key column using #belongs_to" do
    expect_no_offenses(<<~RUBY)
      create_table :foos do |t|
        t.belongs_to :bar
      end
    RUBY
  end

  it "does not register an offense when adding a foreign key column using #references" do
    expect_no_offenses(<<~RUBY)
      create_table :foos do |t|
        t.references :bar
      end
    RUBY
  end
end
