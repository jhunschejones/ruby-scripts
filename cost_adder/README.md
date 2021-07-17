# Cost Adder

The Cost Adder script reads dollar values out of a blob of text and sums the total of those amounts. To find the values, it looks for string matches that conform to the `$0.00` USD format.

### In use
To use the script, simply place the text you wish to parse in `./costs_to_add.txt` and then call `./bin/run` to execute. NOTE: The default regex simply searches for cost-looking numbers at the end of a line of text, so if the values are mid-sentence, you can try `AGGRESSIVE=true ./bin/run` to use a more aggressive regex
