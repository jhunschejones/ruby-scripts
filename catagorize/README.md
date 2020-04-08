# Categorize

## Overview:
This script parses a CSV and reformats it to better fit my expense tracking tools.

## To Use:
1. Configure the vendors you want to use to auto-populate the categories column in `./vendors.yml` _(see example entry for required formatting)_
2. Dump the raw CSV into the root directory named `expenses.csv`
3. Run `ruby catagorize.rb`
4. `parsed_expenses.csv` will be created with the reformatted data

## Limitations:
* The script anticipates a very specific input CSV format: `transaction_date,description,credit_debit,amount`
* The `category_for_description()` method in the `Expense` model has not been highly optimized for efficient file processing, as this script is currently only used on shorter, one-month-long reports.
