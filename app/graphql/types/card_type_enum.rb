Types::CardTypeEnum = GraphQL::EnumType.define do
  name "CardTypeEnum"
  ActsAsTaggableOn::Tag.for_context(:card_types).each do |tag|
    value(tag.name.gsub(" ", "_").camelize, tag.name, value: tag.name)
  end
end
