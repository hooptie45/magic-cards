Types::MutationType = GraphQL::ObjectType.define do
  name "Mutation"

  field :editMetaCatalogType, Mutations::EditMetaCatalogType.field
  field :addMetaCatalogType, Mutations::AddMetaCatalogType.field
  field :addCardMetaAbility, Mutations::AddCardMetaAbility.field
end
