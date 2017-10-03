Types::MutationType = GraphQL::ObjectType.define do
  name "Mutation"

  field :addCardMetaAbility, Mutations::AddCardMetaAbility.field
end
