module Types::Base
  class BaseField < GraphQL::Schema::Field
    argument_class Types::Base::BaseArgument
  end
end
