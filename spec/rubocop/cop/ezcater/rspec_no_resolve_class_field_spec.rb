# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Ezcater::RspecNoResolveClassField, :config do
  it "registers an offense for direct call to resolve_class_field" do
    expect_offense(<<~RUBY)
      resolve_class_field(:user, :name)
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Do not use `resolve_class_field`. Use a query instead.
    RUBY
  end

  it "registers an offense for calling resolve_class_field with multiple arguments" do
    expect_offense(<<~RUBY)
      resolve_class_field(:user, [:name, :email])
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Do not use `resolve_class_field`. Use a query instead.
    RUBY
  end

  it "registers an offense for object method call to resolve_class_field" do
    expect_offense(<<~RUBY)
      object.resolve_class_field(:user, :name)
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Do not use `resolve_class_field`. Use a query instead.
    RUBY
  end

  it "registers an offense when resolve_class_field is called with variables" do
    expect_offense(<<~RUBY)
      field = :name
      user_type = :user
      resolve_class_field(user_type, field)
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Do not use `resolve_class_field`. Use a query instead.
    RUBY
  end

  it "registers an offense when resolve_class_field is in a block" do
    expect_offense(<<~RUBY)
      describe "GraphQL fields" do
        it "resolves fields properly" do
          expect(
            resolve_class_field(:user, :name)
            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Do not use `resolve_class_field`. Use a query instead.
          ).to eq("John")
        end
      end
    RUBY
  end
end
