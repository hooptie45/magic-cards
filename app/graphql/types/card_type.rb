Types::LegalStatusEnum = GraphQL::EnumType.define do
  name "LegalStatusEnum"
  value("LEGAL", "legal", value: :legal)
  value("NOT_LEGAL", "not legal", value: :not_legal)
end

Types::LegalityType = GraphQL::ObjectType.define do
  name "Legality"
  field :format_name, !types.String
  field :legality, !Types::LegalStatusEnum
end

Types::CardType = GraphQL::ObjectType.define do
  name "Card"

  field :id,                     types.ID,                   'A unique ID for this card in Scryfall’s database.'
  field :mtgo_id,                types.String,               'This card’s Magic Online ID (also known as the CatID), if any. A large percentage of cards are not available on Magic Online and do not have this ID.'
  field :multiverse_ids,         types[types.String],        'This card’s multiverse IDs on Gatherer, if any, as an array of integers. Note that Scryfall includes many promo cards, tokens, and other esoteric objects that do not have these identifiers.'
  field :name,                   types.String,               'The name of this card. If this card has multiple faces, this field will contain both names separated by ␣//␣.'
  field :prints_search_uri,      types.String,               'A link to where you can begin paginating all re/prints for this card on Scryfall’s API.'
  field :scryfall_uri,           types.String,               'A link to this card’s permapage on Scryfall’s website.'
  field :uri,                    types.String,               'A link to this card object on Scryfall’s API.'

  field :cmc,                    types.Boolean,              'The card’s converted mana cost. Note that some funny cards have fractional mana costs.'
  field :collector_number,       types.String,               'This card’s collector number. Note that collector numbers can contain non-numeric characters, such as letters or ★.'
  field :color_identity,         types.String,               'This card’s color identity.'
  field :color_indicator,        types.String,               'The colors in this card’s color indicator, if any. A null value for this field indicates the card does not have one.'
  field :colors,                 types.String,               'This card’s colors.'
  field :edhrec_rank,            types.Float,                'This card’s overall rank/popularity on EDHREC. Not all carsd are ranked.'
  field :hand_modifier,          types.String,               'This card’s hand modifier, if it is Vanguard card. This value will contain a delta, such as -1.'
  field :layout,                 types.Boolean,              'A computer-readable designation for this card’s layout. See the layout article.'
  field :legalities,             types[Types::LegalityType], 'An object describing the legality of this card.'
  field :life_modifier,          types.String,               'This card’s life modifier, if it is Vanguard card. This value will contain a delta, such as +2.'
  field :loyalty,                types.String,               'This loyalty if any. Note that some cards have loyalties that are not numeric, such as X.'
  field :mana_cost,              types.String,               'The mana cost for this card. This value will be any empty string  if the cost is absent. Remember that per the game rules, a missing mana cost and a mana cost of {0} are different values.'
  field :oracle_text,            types.Boolean,              'The Oracle text for this card, if any.'
  field :oracle_text,            types.String,               'The Oracle text for this face, if any.'
  field :power,                  types.Int,                  'This card’s power, if any. Note that some cards have powers that are not numeric, such as *.'
  field :toughness,              types.Int,                  'This card’s toughness, if any. Note that some cards have toughnesses that are not numeric, such as *.'

  field :reserved,               types.Boolean,              'True if this card is on the Reserved List.'
  field :set  do
    type Types::MagicSetType
    description 'This card’s set code.'

    resolve ->(card, args, ctx) {
      if id = card.set
        resp = ScryfallClient.new.fetch("/sets/#{id}")
        Hashie::Mash.new(resp.body)
      end
    }
  end
  field :type_line,              types.Boolean,              'The type line of this card.'
end
