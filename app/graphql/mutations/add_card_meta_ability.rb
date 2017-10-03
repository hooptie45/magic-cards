Mutations::AddCardMetaAbility = GraphQL::Relay::Mutation.define do
  name "AddCardMetaAbility"
  # TODO: define return fields
  return_field :meta_ability_name, Types::MetaAbilityTypeEnum

  # TODO: define arguments
  input_field :meta_ability_name, !types.String
  input_field :abilities, !types[Types::AbilityTypeEnum]

  resolve ->(obj, args, ctx) {
    Ability.add_meta_ability(args[:meta_ability_name], ability_tags: args[:abilities])
  }
end
