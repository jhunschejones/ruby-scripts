# Categorize

## Overview:
This script parses a CSV and reformats it to better fit my expense tracking tools.

## To Use:
1. Dump the raw CSV into the root directory named `expenses.csv`
2. Run `ruby catagorize.rb`
3. `parsed_expenses.csv` will be created with the reformatted data

## Limitations:
* The script anticipates a very specific input CSV format: `transaction_date,description,credit_debit,amount`
* Vendor categories are hard-coded as constants in the `./lib/models/expense.rb` model.
* The `category_for_description()` method in the `Expense` model has not been highly optimized for efficient file processing, as this script is currently only used on shorter, one-month-long reports.
