Types::AbilityTypeEnum = GraphQL::EnumType.define do
  name "AbilityTypeEnum"

  value :flying, "Creature has flying", value: "flying"
  Ability.group(:name).count.each do |ability, count|
    next unless ability.present?
    value(ability, ability, value: ability)
  end
end
