Types::MetaAbilityTypeEnum = GraphQL::EnumType.define do
  name "MetaAbilityTypeEnum"

  value("FETCH_LAND", "Artifacts which products land", value: :fetch_land)
end
