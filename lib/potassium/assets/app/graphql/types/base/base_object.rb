module Types::Base
  class BaseObject < GraphQL::Schema::Object
    field_class Types::Base::BaseField
  end
end
