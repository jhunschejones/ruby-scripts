class Expense
  module Configuration
    VENDOR_CATEGORIES = YAML.load(File.read("./vendors.yml"))["vendor_categories"]

    def self.check_for_duplicate_vendors
      vendors = VENDOR_CATEGORIES.flat_map { |vendor_category| vendor_category["vendors"] }
      duplicate_vendors = vendors.select { |vendor| vendors.count(vendor) > 1 }.uniq

      if duplicate_vendors.size > 0
        raise "Duplicate vendors found: '#{duplicate_vendors.join("', '")}'"
      end
    end
  end

  def self.category_for_description(description)
    matching_category = "Unknown"
    Configuration::VENDOR_CATEGORIES.each do |vendor_category|
      value = vendor_category["vendors"].each do |vendor|
        if description.upcase.include?(vendor.upcase)
          matching_category = vendor_category["name"]
          break
        end
      end
    end
    matching_category
  end

  attr_accessor :transaction_date, :description, :amount, :category

  def initialize(transaction_date:, description:, amount:, category:)
    @transaction_date = transaction_date
    @description = description
    @amount = amount
    @category = category
  end
end
