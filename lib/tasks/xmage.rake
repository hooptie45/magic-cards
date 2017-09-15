namespace :xmage do
  XMAGE_REPO_PATH = Pathname("/app/tmp/xmage")
  XMAGE_ABILITIES_PATH = Pathname("/app/data/abilities.txt")
  XMAGE_ABILITY_TYPES_PATH = Pathname("/app/data/ability-types.txt")
  XMAGE_ABILITY_DUMP_PATH = Pathname("/app/data/ability-dump.yml")
  MODELS_PATH = Rails.root.join("app", "models")
  ABILITY_MODELS_PATH = MODELS_PATH.join("abilities")
  ABILITIES_LINE_REGEX = /(\w)\/(\w+).java:(\d+):\s?import mage\.(.*)\.(\w+);$/

  desc "clone xmage repo"
  task :clone do |t, args|
    unless XMAGE_REPO_PATH.exist?
      url = ENV.fetch("XMAGE_REPO_URL", "https://github.com/magefree/mage.git")
      sh("git clone --depth 1 #{url} #{XMAGE_REPO_PATH}")
    end
  end

  desc "remove xmage repo"
  task :clean do |t, args|
    path = Pathname(XMAGE_REPO_PATH)
    path.rmtree if path.exist?
  end


  desc "add abilities"
  task :add_abilities => [:environment] do |t, args|
    hash = Hash.new {|h,k| h[k] = [] }
    XMAGE_ABILITIES_PATH.open do |f|
      f.each_with_index do |line, index|

        if line =~ ABILITIES_LINE_REGEX
          # 1.	u                  #
          # 2.	UlamogsNullifier   #
          # 3.	37                 #
          # 4.	abilities.keyword  #
          # 5.	FlyingAbility      #
          letter = $1
          xmage_card_name = [$2]
          xmage_card_name |= [xmage_card_name.first.underscore.split("_").map(&:classify).join("")]
          line = $3.to_s
          package = $4
          ability_name = $5
          next if ability_name == "Ability" ||
                  ability_name == "Effect"

          full_ability_name = [$4, ability_name].join(".")
          ruby_ability_class = full_ability_name.split(".").map(&:camelize).join("::")
          hash[full_ability_name] |= xmage_card_name
        end
      end
    end

    XMAGE_ABILITY_DUMP_PATH.open("w") do |f|
      f.write YAML.dump(hash)
    end

    ActsAsTaggableOn.tags_counter = false

    ActsAsTaggableOn::Tagging.bulk_insert do |tagging|
      hash.each do |full_ability_name, card_names|
        tag = ActsAsTaggableOn::Tag.where(name: full_ability_name).first_or_create
        Card.where(xmage_name: card_names).find_each do |card|
          tagging.add(taggable_type: card.class.name, taggable_id: card.id, context: "ability_tags", tag_id: tag.id)
        end
      end
    end
    Rake::Task["xmage:update_tag_counts"].invoke
  end

  desc "update tag counts"
  task :update_tag_counts => [:environment] do |t, args|
    ActsAsTaggableOn::Tag.pluck(:id).each do |id|
      begin
        ActsAsTaggableOn::Tag.reset_counters(id, :taggings)
      rescue => e
        Rails.logger.warn "FAILED TO reset counters on tag: #{id}"
      end
    end
  end

  desc "derive abilities from source"
  task :abilities => [:clone, :environment] do |t, args|
    [XMAGE_REPO_PATH, XMAGE_ABILITY_TYPES_PATH, XMAGE_ABILITIES_PATH].each do |path|
      path.dirname.mkpath unless path.dirname.exist?
    end

    Dir.chdir(XMAGE_REPO_PATH) do
      Dir.chdir("Mage.Sets/src/mage/cards") do
        sh("ack --no-heading 'import mage.abilities' > #{XMAGE_ABILITIES_PATH}")
      end
    end

    sh("gawk '{print $2}' #{XMAGE_ABILITIES_PATH} | sort | uniq -c | sort -n > #{XMAGE_ABILITY_TYPES_PATH}")
    Rake::Task["xmage:add_abilities"].invoke

    # XMAGE_ABILITY_TYPES_PATH.open do |f|                                                 #
    #   f.each do |line|                                                                   #
    #     count, type = line.squish.split(" ")                                             #
    #     type = type.sub(/^mage\./, '').sub(";", "")                                      #
    #     next if type.end_with?("Impl")                                                   #
    #     ruby_model = type.gsub(".", "/")                                                 #
    #     ruby_class = ruby_model.split("/").last                                          #
    #     sh("rails generate model #{ruby_model} --no-migration --parent=Ability --force") #
    #   end                                                                                #
    # end                                                                                  #
  end
end
