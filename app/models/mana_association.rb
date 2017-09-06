module ManaAssociation
  def add_black
    add_mana(:black)
  end

  def add_blue
    add_mana(:blue)
  end

  def add_green
    add_mana(:green)
  end

  def add_red
    add_mana(:red)
  end

  def add_white
    add_mana(:white)
  end

  def add_colorless
    build(mana_type: ManaType.colorless.first)
  end

  def add_mana(color_name)
    build(mana_type: ManaType.public_send(color_name).first)
  end
end
