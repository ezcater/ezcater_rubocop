# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Ezcater::RequireGqlErrorHelpers, :config do
  context "when attempting to directly use GraphQL::ExecutionError" do
    it "registers an offense" do
      expect_offense <<~RUBY
        GraphQL::ExecutionError.new("An error occurred")
        ^^^^^^^^^^^^^^^^^^^^^^^ Use the helpers provided by `GQLErrors` instead of raising `GraphQL::ExecutionError` directly.
      RUBY
    end

    context "and additional options are provided" do
      it "registers an offense" do
        expect_offense <<~RUBY
          GraphQL::ExecutionError.new("An error occurred", extensions: { "statusCode" => 401 })
          ^^^^^^^^^^^^^^^^^^^^^^^ Use the helpers provided by `GQLErrors` instead of raising `GraphQL::ExecutionError` directly.
        RUBY
      end
    end
  end
end
