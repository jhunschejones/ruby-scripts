class Expense
  VENDOR_CATEGORIES = [
    {name: "Shopping", vendors: ["FRED-MEYER", "BASICS MARKET", "TRADER JOE'S", "PLAID PANTRY", "SWL ENTERPRISES", "NEW SEASONS MARKET", "WALGREENS"]},
    {name: "Clothes", vendors: ["ROAD RUNNER"]},
    {name: "Eating Out", vendors: ["THAI ORCHID", "THAI SKY", "CITY THAI", "TACO CITY"]},
    {name: "Coffee & Tea", vendors: ["TEA CHAI TE", "COFFEE", "DRAGONFLY", "WELL & GOOD", "INSOMNIA"]},
    {name: "Subscriptions", vendors: ["APPLE.COM/BILL", "HEROKU", "DISNEYPLUS"]},
    {name: "Transportation", vendors: ["SHELL OIL", "SPACE AGE", "ARCO", "CHEVRON"]},
    {name: "Car Insurance", vendors: ["USAA"]},
    {name: "Electricity", vendors: ["PORTLAND GNL ELEC"]},
    {name: "Cell Phone", vendors: ["GOOGLE FI"]},
    {name: "Internet", vendors: ["COMCAST"]}
  ]

  attr_accessor :transaction_date, :description, :amount, :category

  def initialize(transaction_date:, description:, amount:, category:)
    @transaction_date = transaction_date
    @description = description
    @amount = amount
    @category = category
  end

  def self.category_for_description(description)
    matching_category = "Unknown"
    VENDOR_CATEGORIES.each do |vendor_category|
      value = vendor_category[:vendors].each do |vendor|
        if description.upcase.include?(vendor.upcase)
          matching_category = vendor_category[:name]
          break
        end
      end
    end
    matching_category
  end
end
