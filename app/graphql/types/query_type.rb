Types::QueryType = GraphQL::ObjectType.define do
  name "Query"
  field :mana do
    type types[Types::ManaType]
    resolve -> (args, ctx, env){ ManaType.all }
  end

  field :cards do
    type types[Types::CardType]

    argument :keywords, types.String

    argument :with_meta_abilities,     types[Types::MetaAbilityTypeEnum]
    argument :without_meta_abilities,  types[Types::MetaAbilityTypeEnum]
    argument :with_all_meta_abilities, types[Types::MetaAbilityTypeEnum]

    argument :with_abilities,     types[Types::AbilityTypeEnum]
    argument :without_abilities,  types[Types::AbilityTypeEnum]
    argument :with_all_abilities, types[Types::AbilityTypeEnum]

    argument :with_types,     types[Types::CardTypeEnum]
    argument :without_types,  types[Types::CardTypeEnum]
    argument :with_all_types, types[Types::CardTypeEnum]

    resolve -> (obj, args, env) {
      scope = Card
      scope = scope.search_by_name(args[:keywords]) if args[:keywords].present?

      scope = scope.tagged_with(args[:without_types],      :on => :card_types,   :exclude => true)   if args[:without_types].present?
      scope = scope.tagged_with(args[:with_types],         :on => :card_types,   :any => true)       if args[:with_types].present?
      scope = scope.tagged_with(args[:with_all_types],     :on => :card_types,   :match_all => true) if args[:with_all_types].present?

      scope = scope.tagged_with(args[:without_meta_abilities],  :on => :meta_ability_tags, :exclude => true)   if args[:without_meta_abilities].present?
      scope = scope.tagged_with(args[:with_meta_abilities],     :on => :meta_ability_tags, :any => true)       if args[:with_meta_abilities].present?
      scope = scope.tagged_with(args[:with_all_meta_abilities], :on => :meta_ability_tags, :match_all => true) if args[:with_all_meta_abilities].present?

      scope = scope.tagged_with(args[:without_abilities],  :on => :ability_tags, :exclude => true)   if args[:without_abilities].present?
      scope = scope.tagged_with(args[:with_abilities],     :on => :ability_tags, :any => true)       if args[:with_abilities].present?
      scope = scope.tagged_with(args[:with_all_abilities], :on => :ability_tags, :match_all => true) if args[:with_all_abilities].present?

      scope.limit(50).all
    }
  end
end
