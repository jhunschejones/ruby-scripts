require_relative './lib/module_loader.rb'

Expense::Configuration.check_for_duplicate_vendors

expenses = []
CSV.foreach("./expenses.csv") do |row|
  if row[2] == "DEBIT"
    print "." # show each loop in the console
    expenses << Expense.new(
      transaction_date: row[0],
      description: row[1],
      category: Expense.category_for_description(row[1]),
      amount: row[3],
      vendor: Expense.vendor_for_description(row[1])
    )
  end
end

expenses_by_vendor = expenses.group_by(&:vendor).map do |vendor, expenses|
  OpenStruct.new(
    vendor: vendor,
    total: expenses.map { |expense| expense.amount.to_f }.reduce(0, :+).abs
  )
end.sort_by(&:total).reverse

puts "" # add newline after parsing progress dots

CSV.open("./parsed_expenses/parsed_expenses.csv", "wb") do |csv|
  csv << ["Transaction Date", "Description", "Amount", "Category"]
  expenses.each do |expense|
    csv << [expense.transaction_date, expense.description, expense.amount, expense.category]
  end
end

CSV.open("./parsed_expenses/expenses_by_vendor.csv", "wb") do |csv|
  csv << ["Vendor", "Total" ]
  expenses_by_vendor.each do |expense_by_vendor|
    csv << [expense_by_vendor[:vendor], expense_by_vendor[:total]]
  end
end

# Print out the unknown vendors for debugging purposes
CSV.open("./parsed_expenses/unknown_vendors.csv", "wb") do |csv|
  csv << ["Description", "Total"]
  expenses.each { |expense| csv << [expense.description, expense.amount] if expense.vendor == "Unknown" }
end
