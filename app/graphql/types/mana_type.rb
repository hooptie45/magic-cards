Types::ManaType = GraphQL::ObjectType.define do
  name "Mana"
  field :cost, types.Int
  field :name, types.String
end
