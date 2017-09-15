Types::QueryType = GraphQL::ObjectType.define do
  name "Query"
  field :mana do
    type types[Types::ManaType]
    resolve -> (args, ctx, env){ ManaType.all }
  end

  field :cards do
    type types[Types::CardType]
    argument :with_abilities, types[Types::AbilityTypeEnum]
    argument :with_types, types[Types::CardTypeEnum]
    resolve -> (obj, args, env) {
      scope = Card
      scope = scope.tagged_with(args[:with_abilities],  :on => :ability_tags, :any => true) if args[:with_abilities].present?
      scope = scope.tagged_with(args[:with_types],      :on => :card_types,   :any => true) if args[:with_types].present?
      scope.limit(50).all
    }
  end

end
