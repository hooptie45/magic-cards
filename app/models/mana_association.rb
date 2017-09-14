module ManaAssociation
  def total_cost
    joins(:mana_type).sum(:cost)
  end

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

  def add_colorless(cost)
    fetch_method = "fetch_#{cost}"
    if ManaType.respond_to?(fetch_method)
      create(mana_type: ManaType.public_send(fetch_method))
    else
      Rails.logger.
        error("Skipping colorless mana: #{cost} on #{self}. Not Yet Implemented")
    end
  end

  def add_mana(color_name)
    create(mana_type: ManaType.public_send("fetch_#{color_name}"))
  end
end
