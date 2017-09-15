Types::CardType = GraphQL::ObjectType.define do
  name "Card"
  field :name, types.String
  field :xmage_name, types.String
  field :power, types.Int
  field :toughness, types.Int
  field :cost, types.String
  field :card_type, Types::CardTypeEnum
  field :card_sub_type, Types::CardSubTypeEnum
  field :raw_abilities, types[types.String]
  field :ability_tags, types[Types::AbilityTypeEnum] do
    resolve ->(obj, ctx, env) {
      obj.ability_tag_list.map {|tag| tag }
    }
  end
end
