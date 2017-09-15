require 'hashie'
# IngestXmageJob.perform_now(perform_subtasks: :now)
class IngestXmageJob < ApplicationJob

  def perform(perform_subtasks = :now)
    ManaType.setup!
    ExpansionSet.delete_all
    ExpansionCard.delete_all
    Card.delete_all
    Pathname.glob(Rails.root.join("data/xmage/*.json")).sort_by {|p| p.basename.to_s.to_i }.each {|p|
      IngestXmageDumpJob.new.perform(p.to_s)
    }
  end
end

