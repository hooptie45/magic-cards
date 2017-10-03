Types::MagicSetType = GraphQL::ObjectType.define do
  name "MagicSet"

  field :code,            types.String,  "The unique three or four-letter code for this set."
  field :name,            types.String,  "The English name of the set."
  field :set_type,        types.String,  "A computer-readable classification for this set. See below."
  field :released_at,     types.String,  "Nullable "
  field :block_code,      types.String,  "Nullable The block code for this set, if any."
  field :block,           types.String,  "Nullable The block or group name code for this set, if any."
  field :parent_set_code, types.String,  "String		The set code for the parent set, if any. promo and token sets often have a parent set."
  field :card_count,      types.Int,     "The number of cards in this set."
  field :digital,         types.Boolean, "True if this set was only released on Magic Online."
  field :foil,            types.Boolean, "True if this set contains only foil cards."
  field :icon_svg_uri,    types.String,  "A URI to an SVG file for this set’s icon on Scryfall’s CDN. Hotlinking this image isn’t recommended, because it may change slightly over time. You should download it and use it locally for your particular user interface needs."
  field :search_uri,      types.String,  "A Scryfall API URI that you can request to begin paginating over the cards in this set."
end

