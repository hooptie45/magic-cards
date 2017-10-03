Mutations::AddMetaCatalogType = GraphQL::Relay::Mutation.define do
  name "AddMetaCatalogType"
  # TODO: define return fields
  return_field :catalog, Types::MetaCatalogType

  # TODO: define arguments
  # input_field :name, !types.String

  resolve ->(obj, args, ctx) {
    # TODO: define resolve function
  }
end
