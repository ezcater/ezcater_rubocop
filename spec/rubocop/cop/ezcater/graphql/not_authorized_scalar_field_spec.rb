# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Ezcater::GraphQL::NotAuthorizedScalarField, :config do
  describe "configured to not AllowGuards (default)" do
    it "registers an offense on scalar fields when it does not detect `pundit_role` kwarg" do
      expect_offense(<<~RUBY)
        class SomeGraphQLType
          field :secret_name, String
          ^^^^^^^^^^^^^^^^^^^^^^^^^^ Ezcater/GraphQL/NotAuthorizedScalarFields: must be authorized.
        end
      RUBY
    end

    it "registers an offense on scalar fields even when a guard is used in a resolver method" do
      expect_offense(<<~RUBY)
        class SomeGraphQLType
          field :secret_name, String
          ^^^^^^^^^^^^^^^^^^^^^^^^^^ Ezcater/GraphQL/NotAuthorizedScalarFields: must be authorized.

          def secret_name
            PiiGuard.new(context, object).guard do |blah|
              "Rumplestiltskin"
            end
          end
        end
      RUBY
    end

    it "does not register an offense when it detects the `pundit_role` kwarg on scalar fields" do
      expect_no_offenses(<<~RUBY)
        class SomeGraphQLType
          field :secret_name, String, null: false, pundit_role: :owner, description: "PII"
        end
      RUBY
    end

    it "registers an offense on scalar fields with bodies when it does not detect `pundit_role` kwarg" do
      expect_offense(<<~RUBY)
        class SomeGraphQLType
          field :secret_name, String do
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Ezcater/GraphQL/NotAuthorizedScalarFields: must be authorized.
            "Rumplestiltskin"
          end
        end
      RUBY
    end

    it "registers an offense on scalar fields even when a guard is used in its body" do
      expect_offense(<<~RUBY)
        class SomeGraphQLType
          field :secret_name, String do
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Ezcater/GraphQL/NotAuthorizedScalarFields: must be authorized.
            PiiGuard.new(context, object).guard do |blah|
              "Rumplestiltskin"
            end
          end
        end
      RUBY
    end

    it "does not register an offense when it detects the `pundit_role` kwarg on scalar fields with bodies" do
      expect_no_offenses(<<~RUBY)
        class SomeGraphQLType
          field :pii, String, null: false, pundit_role: :owner, description: "PII" do
            "Rumplestiltskin"
          end
        end
      RUBY
    end
  end

  describe "configured to AllowGuards" do
    let(:cop_config) { { "AllowGuards" => true } }

    it "registers an offense on scalar fields without authorization" do
      expect_offense(<<~RUBY)
        class SomeGraphQLType
          field :secret_name, String
          ^^^^^^^^^^^^^^^^^^^^^^^^^^ Ezcater/GraphQL/NotAuthorizedScalarFields: must be authorized.
        end
      RUBY
    end

    it "does not register an offense if a guard is used in a resolver method" do
      expect_no_offenses(<<~RUBY)
        class SomeGraphQLType
          field :secret_name, String

          def secret_name
            PiiGuard.new(context, object).guard do |blah|
              "Rumplestiltskin"
            end
          end
        end
      RUBY
    end

    it "registers an offense on scalar fields with bodies which lack authorization" do
      expect_offense(<<~RUBY)
        class SomeGraphQLType
          field :secret_name, String do
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Ezcater/GraphQL/NotAuthorizedScalarFields: must be authorized.
            "Rumplestiltskin"
          end
        end
      RUBY
    end

    it "does not register an offense on scalar fields when a guard is used in its body" do
      expect_no_offenses(<<~RUBY)
        class SomeGraphQLType
          field :secret_name, String do
            PiiGuard.new(context, object).guard do |blah|
              "Rumplestiltskin"
            end
          end
        end
      RUBY
    end
  end

  describe "configured without AdditionalScalarTypes (default)" do
    %w(BigInt Boolean Float Int ID ISO8601Date ISO8601DateTime ISO8601Duration JSON
       String).each do |default_scalar_type|
      it "registers an offense on #{default_scalar_type} fields which lack authorization" do
        expect_offense(<<~RUBY)
          class SomeGraphQLType
            field :secret, #{default_scalar_type}
            ^^^^^^^^^^^^^^^#{'^' * default_scalar_type.length} Ezcater/GraphQL/NotAuthorizedScalarFields: must be authorized.
          end
        RUBY
      end
    end

    it "does not register an offense on non-scalar fields which lack authorization" do
      expect_no_offenses(<<~RUBY)
        class SomeGraphQLType
          field :secret_cabinet, Cabinet
        end
      RUBY
    end
  end

  describe "configured with AdditionalScalarTypes" do
    let(:cop_config) { { "AdditionalScalarTypes" => %w(File Folio) } }

    %w(BigInt Boolean Float Int ID ISO8601Date ISO8601DateTime ISO8601Duration JSON
       String).each do |default_scalar_type|
      it "registers an offense on #{default_scalar_type} fields which lack authorization" do
        expect_offense(<<~RUBY)
          class SomeGraphQLType
            field :secret, #{default_scalar_type}
            ^^^^^^^^^^^^^^^#{'^' * default_scalar_type.length} Ezcater/GraphQL/NotAuthorizedScalarFields: must be authorized.
          end
        RUBY
      end
    end

    %w(File Folio).each do |additional_scalar_type|
      it "registers an offense on #{additional_scalar_type} fields which lack authorization" do
        expect_offense(<<~RUBY)
          class SomeGraphQLType
            field :secret, #{additional_scalar_type}
            ^^^^^^^^^^^^^^^#{'^' * additional_scalar_type.length} Ezcater/GraphQL/NotAuthorizedScalarFields: must be authorized.
          end
        RUBY
      end
    end

    it "does not register an offense on a non-scalar field which lacks authorization" do
      expect_no_offenses(<<~RUBY)
        class SomeGraphQLType
          field :secret_cabinet, Cabinet
        end
      RUBY
    end
  end

  describe "configured without IgnoredFieldNames (default)" do
    it "registers an offense on a scalar field without authorization" do
      expect_offense(<<~RUBY)
        class SomeGraphQLType
          field :id, ID
          ^^^^^^^^^^^^^ Ezcater/GraphQL/NotAuthorizedScalarFields: must be authorized.
        end
      RUBY
    end
  end

  describe "configured with IgnoredFieldNames" do
    let(:cop_config) { { "IgnoredFieldNames" => %w(id secret) } }

    %w(id secret).each do |ignored_field_name|
      it "doesn't register an offense scalar fields, such as #{ignored_field_name}, without authn with ignored names" do
        expect_no_offenses(<<~RUBY)
          class SomeGraphQLType
            field :#{ignored_field_name}, ID
          end
        RUBY
      end
    end

    it "registers an offense on a scalar fields without authorization whose name is not ignored" do
      expect_offense(<<~RUBY)
        class SomeGraphQLType
          field :burn_after_reading, String
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Ezcater/GraphQL/NotAuthorizedScalarFields: must be authorized.
        end
      RUBY
    end
  end
end
