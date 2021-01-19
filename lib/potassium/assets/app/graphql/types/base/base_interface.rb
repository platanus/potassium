module Types::Base
  module BaseInterface
    include GraphQL::Schema::Interface

    field_class Types::Base::BaseField
  end
end
