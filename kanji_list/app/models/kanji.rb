class Kanji < ActiveRecord::Base
  CARD_CREATED_STATUS = "card_created".freeze
  SKIPPED_STATUS = "skipped".freeze

  validates :character, presence: true, uniqueness: true
end
