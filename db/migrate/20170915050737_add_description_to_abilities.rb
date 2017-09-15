class AddDescriptionToAbilities < ActiveRecord::Migration[5.1]
  def up
    add_column(:abilities, :description, :string)
    create_join_table :cards, :abilities
    remove_reference(:abilities, :targetable, :polymorphic => true, :index => true)
    ActsAsTaggableOn::Tagging.where(:context => "abilities")
      .update_all(:context => "ability_tags")
  end

  def down
    remove_column(:abilities, :description)
    drop_join_table :cards, :abilities
    add_reference(:abilities, :targetable, :polymorphic => true, :index => true)

    ActsAsTaggableOn::Tagging.where(:context => "ability_tags")
      .update_all(:context => "abilities")
  end

end
