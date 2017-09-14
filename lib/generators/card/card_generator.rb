class CardGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)

  def add_model
    template()
  end
end
