class Expense
  VENDOR_CATEGORIES = YAML.load(File.read("./vendors.yml"))["vendor_categories"]

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
      value = vendor_category["vendors"].each do |vendor|
        if description.upcase.include?(vendor.upcase)
          matching_category = vendor_category["name"]
          break
        end
      end
    end
    matching_category
  end
end
