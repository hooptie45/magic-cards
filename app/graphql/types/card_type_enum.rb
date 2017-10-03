Types::CardTypeEnum = GraphQL::EnumType.define do
  name "CardTypeEnum"
  Card.group(:card_type).count.each do |type, count|
    value(Ability.sanitized_name(type), type, value: type)
  end
end
