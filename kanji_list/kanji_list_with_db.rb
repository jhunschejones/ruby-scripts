require 'active_record'

ActiveRecord::Base.logger = Logger.new(STDERR)
ActiveRecord::Base.establish_connection(
  adapter: "sqlite3",
  database: "./db/local"
)

ActiveRecord::Schema.define do
  create_table :kanji do |t|
    t.column :character, :string
  end

  add_index :kanji, :character, unique: true
end
