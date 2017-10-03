Types::MetaAbilityTypeEnum = GraphQL::EnumType.define do
  name "MetaAbilityTypeEnum"

  ActsAsTaggableOn::Tag.for_context(:meta_ability_tags).each do |tag|
    value(Ability.sanitized_name(tag.name), tag.name, value: tag.name)
  end
end
