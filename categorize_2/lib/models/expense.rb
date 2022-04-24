class Expense
  module Configuration
    VENDOR_CATEGORIES = YAML.load(File.read("./config/vendors.yml"))["vendor_categories"]

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
        if vendor.upcase.split(",").map { |v| description.upcase.include?(v.strip) }.any?
          # Unknown catagory used for vendor_by_catagory report, be careful
          # not to set this though unless no other catagories match
          unless vendor_category["name"] == "Unknown"
            matching_category = vendor_category["name"]
            break
          end
        end
      end
    end
    matching_category
  end

  def self.vendor_for_description(description)
    matching_vendor = "Unknown"
    Configuration::VENDOR_CATEGORIES.each do |vendor_category|
      value = vendor_category["vendors"].each do |vendor|
        if vendor.upcase.split(",").map { |v| description.upcase.include?(v.strip) }.any?
          matching_vendor = vendor
          break
        end
      end
    end
    matching_vendor
  end

  attr_reader :transaction_date, :description, :amount, :category, :vendor

  def initialize(transaction_date:, description:, amount:, category:, vendor:)
    @transaction_date = transaction_date
    @description = description
    @amount = amount
    @category = category
    @vendor = vendor
  end
end
