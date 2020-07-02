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
puts "" # add newline after debug progress

CSV.open("./parsed_expenses.csv", "wb") do |csv|
  csv << [
    "Transaction Date",
    "Description",
    "Amount",
    "Category"
  ]
  expenses.each do |expense|
    csv << [
      expense.transaction_date,
      expense.description,
      expense.amount,
      expense.category
    ]
  end
end

CSV.open("./expenses_by_vendors.csv", "wb") do |csv|
  csv << [
    "Vendor",
    "Total"
  ]
  expenses.group_by(&:vendor).each do |vendor, expenses|
    csv << [
      vendor,
      expenses.map { |expense| expense.amount.to_f }.reduce(0, :+).abs
    ]
  end
end

# Print out the unknown vendors for debugging purposes
CSV.open("./unknown_vendors.csv", "wb") do |csv|
  csv << [
    "Description",
    "Total"
  ]
  expenses.each do |expense|
    if expense.vendor == "Unknown"
      csv << [
        expense.description,
        expense.amount
      ]
    end
  end
end
