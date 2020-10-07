unrecognized_kanji = [ "檎", "撃" ]
skipped_kanji = [ "人", "４", "八" ]

previous_kanji = [
  "形", "容", "詞", "大", "午", "後", "空", "港", "健", "在", "動", "物", "部",
  "屋", "林", "檎", "月", "腕", "軍", "術", "芸", "芸", "家", "家", "攻", "撃",
  "作",
] + unrecognized_kanji + skipped_kanji

new_words = [
  "形容詞", "大人", "午後", "空", "空港", "健在", "動物", "部屋", "林檎", "４月", "腕", "軍", "術", "芸術家", "攻撃", "八月", "作家"
]

p "New Kanji list:"
p new_words.flat_map {|word| word.split("") }.uniq - previous_kanji
