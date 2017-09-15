Types::CardSubTypeEnum = GraphQL::EnumType.define do
  name "CardSubTypeEnum"

  ActsAsTaggableOn::Tag.for_context(:card_sub_types).each do |tag|
    value(tag.name.gsub(" ", "_").gsub(/[^a-zA-Z0-9]/, '').camelize, tag.name, value: tag.name)
  end
end
