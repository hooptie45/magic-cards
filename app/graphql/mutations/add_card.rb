Mutations::AddCardMetaAbility = GraphQL::Relay::Mutation.define do
  name "AddCardMetaAbility"
  # TODO: define return fields
  return_field :card, Types::CardType

  # TODO: define arguments
  field :id,                     types[types.String],        :documentation => 'A unique ID for this card in Scryfall’s database.'
  field :multiverse_ids,         types[types.String],        :documentation => 'This card’s multiverse IDs on Gatherer, if any, as an array of integers. Note that Scryfall includes many promo cards, tokens, and other esoteric objects that do not have these identifiers.'
  field :mtgo_id,                types[types.String],        :documentation => 'This card’s Magic Online ID (also known as the CatID), if any. A large percentage of cards are not available on Magic Online and do not have this ID.'
  field :uri,                    Types::Bool,                :documentation => 'A link to this card object on Scryfall’s API.'
  field :scryfall_uri,           Types::Bool,                :documentation => 'A link to this card’s permapage on Scryfall’s website.'
  field :prints_search_uri,      Types::Bool,                :documentation => 'A link to where you can begin paginating all re/prints for this card on Scryfall’s API.'
  field :name,                   Types::Bool,                :documentation => 'The name of this card. If this card has multiple faces, this field will contain both names separated by ␣//␣.'
  field :layout,                 Types::Bool,                :documentation => 'A computer-readable designation for this card’s layout. See the layout article.'
  field :cmc,                    Types::Bool,                :documentation => 'The card’s converted mana cost. Note that some funny cards have fractional mana costs.'
  field :type_line,              Types::Bool,                :documentation => 'The type line of this card.'
  field :oracle_text,            Types::Bool,                :documentation => 'The Oracle text for this card, if any.'
  field :mana_cost,              Types::String,                 :documentation => 'The mana cost for this card. This value will be any empty string  if the cost is absent. Remember that per the game rules, a missing mana cost and a mana cost of {0} are different values.'
  field :power,                  Types::Int,                 :documentation => 'This card’s power, if any. Note that some cards have powers that are not numeric, such as *.'
  field :toughness,              Types::Int,                 :documentation => 'This card’s toughness, if any. Note that some cards have toughnesses that are not numeric, such as *.'
  field :loyalty,                Types::String,                 :documentation => 'This loyalty if any. Note that some cards have loyalties that are not numeric, such as X.'
  field :life_modifier,          Types::String,                 :documentation => 'This card’s life modifier, if it is Vanguard card. This value will contain a delta, such as +2.'
  field :hand_modifier,          Types::String,                 :documentation => 'This card’s hand modifier, if it is Vanguard card. This value will contain a delta, such as -1.'
  field :colors,                 Types::String,                 :documentation => 'This card’s colors.'
  field :color_indicator,        Types::String,                 :documentation => 'The colors in this card’s color indicator, if any. A null value for this field indicates the card does not have one.'
  field :color_identity,         Types::String,                 :documentation => 'This card’s color identity.'
  field :legalities,             types[Types::LegalityType], :documentation => 'An object describing the legality of this card.'
  field :reserved,               Types::Bool,                :documentation => 'True if this card is on the Reserved List.'
  field :edhrec_rank,            Types::Float,               :documentation => 'This card’s overall rank/popularity on EDHREC. Not all carsd are ranked.'
  field :set,                    Types::MagicSet,            :documentation => 'This card’s set code.'
  field :collector_number,       Types::String,              :documentation => 'This card’s collector number. Note that collector numbers can contain non-numeric characters, such as letters or ★.'

  input_field :meta_ability_name, !types.String
  input_field :abilities, !types[Types::AbilityTypeEnum]

  resolve ->(obj, args, ctx) {
    Ability.add_meta_ability(args[:meta_ability_name], ability_tags: args[:abilities])
  }
end
