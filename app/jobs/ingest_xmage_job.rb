require 'hashie'
# IngestXmageJob.perform_now(perform_subtasks: :now)
class IngestXmageJob < ApplicationJob

  def perform(dirname: "data/xmage", perform_subtasks: :later)
    ManaType.setup!
    ExpansionSet.delete_all
    ExpansionCard.delete_all
    Card.delete_all
    Pathname.glob("#{dirname}/*.json").sort_by {|p| p.basename.to_s.to_i }.each {|p|
      IngestXmageDumpJob.send("perform_#{perform_subtasks}", p.to_s)
    }
  end
end

