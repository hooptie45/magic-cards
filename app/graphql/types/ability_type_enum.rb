Types::AbilityTypeEnum = GraphQL::EnumType.define do
  name "AbilityTypeEnum"

  ActsAsTaggableOn::Tag.for_context(:ability_tags).each do |tag|
    value(Ability.sanitized_name(tag.name), tag.name, value: tag.name)
  end
end
