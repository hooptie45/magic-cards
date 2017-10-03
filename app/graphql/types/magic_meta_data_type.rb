Types::MagicMetaDataTypeEnum = GraphQL::EnumType.define do
  name "MagicMetaDataTypeEnum"

  value :MTG_META_TYPE_WORD_BANK,         "/catalog/word-bank",          value: :word_bank
  value :MTG_META_TYPE_CREATURE_TYPE,     "/catalog/creature-types",     value: :creature_types
  value :MTG_META_TYPE_PLANESWALKER_TYPE, "/catalog/planeswalker-types", value: :planeswalker_types
  value :MTG_META_TYPE_LAND_TYPE,         "/catalog/land-types",         value: :land_types
  value :MTG_META_TYPE_SPELL_TYPE,        "/catalog/spell-types",        value: :spell_types
  value :MTG_META_TYPE_ARTIFACT_TYPE,     "/catalog/artifact-types",     value: :artifact_types
  value :MTG_META_TYPE_POWER,             "/catalog/powers",             value: :powers
  value :MTG_META_TYPE_TOUGHNESS,         "/catalog/toughnesses",        value: :toughnesses
  value :MTG_META_TYPE_LOYALTY,           "/catalog/loyalties",          value: :loyalties
end

Types::MetaCatalogType = GraphQL::ObjectType.define do
  name "MetaCatalog"
  field :meta_data_type, Types::MagicMetaDataType
  field :name, Types::StringType

  def resolve(obj, args, ctx)
    ScryfallClient.new.fetch()
  end
end
