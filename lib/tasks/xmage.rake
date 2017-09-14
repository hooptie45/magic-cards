namespace :xmage do
  XMAGE_REPO_PATH = Pathname("/app/tmp/xmage")
  XMAGE_ABILITIES_PATH = Pathname("/app/data/abilities.txt")
  XMAGE_ABILITY_TYPES_PATH = Pathname("/app/data/ability-types.txt")
  MODELS_PATH = Rails.root.join("app", "models")
  ABILITY_MODELS_PATH = MODELS_PATH.join("abilities")
  ABILITIES_LINE_REGEX = /(\w)\/(\w+).java:(\d+):\s?import mage\.(.*)\.(\w+);$/

  desc "clone xmage repo"
  task :clone => [:clean] do |t, args|
    url = ENV.fetch("XMAGE_REPO_URL", "https://github.com/magefree/mage.git")
    sh("git clone #{url} #{XMAGE_REPO_PATH}")
  end

  desc "remove xmage repo"
  task :clean do |t, args|
    path = Pathname(XMAGE_REPO_PATH)
    path.delete if path.exist?
  end

  desc "derive abilities from source"
  task :abilities => [:environment] do |t, args|
    [XMAGE_REPO_PATH, XMAGE_ABILITY_TYPES_PATH, XMAGE_ABILITIES_PATH].each do |path|
      path.dirname.mkpath unless path.dirname.exist?
    end

    Dir.chdir(XMAGE_REPO_PATH) do
      Dir.chdir("Mage.Sets/src/mage/cards") do
        sh("ack --no-heading 'import mage.abilities' > #{XMAGE_ABILITIES_PATH}")
      end
    end

    sh("gawk '{print $2}' #{XMAGE_ABILITIES_PATH} | sort | uniq -c | sort -n > #{XMAGE_ABILITY_TYPES_PATH}")

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

          skipped = nil
          Rails.logger.silence do
            if card = Card.where(xmage_name: xmage_card_name).first
              skipped = false
              card.tag_list << full_ability_name
              card.tag_list << ability_name
              card.save
            else
              skipped = true
            end
          end

          if skipped
            msg = "[#{index}] Skipped #{ability_name}(#{full_ability_name}) to #{xmage_card_name}" #
            Rails.logger.info msg
            puts msg
          else
            msg = "[#{index}] Added #{ability_name}(#{full_ability_name}) to #{xmage_card_name}" #
            Rails.logger.info msg
            puts msg
          end
        end
      end
    end

  end
end
