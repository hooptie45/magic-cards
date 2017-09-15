class ApplicationJob
  include Sidekiq::Worker

  sidekiq_options unique: :until_and_while_executing

  def self.perform_now(*args, **kwargs)
    new.perform(*args, **kwargs)
  end

  def self.perform_later(*args, **kwargs)
    perform_async(*args)
  end

end
