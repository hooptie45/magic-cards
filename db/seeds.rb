# This file should contain all the record creation needed to seed the database
# with its default values.
# The data can then be loaded with the rails db:seed command
# or created alongside the database with db:setup.
#
# Examples:
#
# movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
# Character.create(name: 'Luke', movie: movies.first)
%w(black blue green red white).each {|name| ManaType.send(name).first_or_create(name: name) }
IngestMagicSetListJob.perform_later

Pathname.glob("data/xmage/*.json").each do |path|
  IngestXmageDumpJob.perform_later(path.expand_path.to_s)
end

