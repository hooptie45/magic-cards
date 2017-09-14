namespace :cards do
  desc "backup cards"

  task :backup => [:environment, :clean] do |t, args|
    dirname = "data/xmage"
    ManaType.setup!
    Pathname.glob("#{dirname}/*.json").sort_by {|p| p.basename.to_s.to_i }.each {|p|
      IngestXmageDumpJob.perform_now(p.to_s)
    }
  end

  task :clean => :environment do |t, args|
    ExpansionSet.delete_all
    Card.delete_all
  end
end
