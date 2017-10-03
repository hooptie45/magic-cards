Types::CardSymbolType = GraphQL::ObjectType.define do
  name "CardSymbol"
  field :symbol, Types::StringType
  field :loose_variant, Types::StringType
  field :english, Types::StringType
  field :transposable, Types::BooleanType
  field :represents_mana, Types::BooleanType
  field :appears_in_mana_costs, Types::BooleanType
  field :cmc, Types::StringType
  field :funny, Types::BooleanType
  field :colors, Types::StringType
end
