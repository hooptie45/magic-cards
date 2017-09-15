
Types::TagsType = GraphQL::EnumType.define do
  name "Tags"
  description "An part of the Star Wars saga"

  value(:Flyer, value: 1)
end
