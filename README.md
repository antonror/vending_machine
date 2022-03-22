### Vending Machine
Design a vending machine in code. The vending machine, once a product is selected and the appropriate amount of money 
(coins) is inserted, should return that product. 
It should also return change (coins) if too much money is provided or ask for more money (coins) if there is not enough.
Keep in mind that you need to manage the scenario where the item is out of stock or the machine does not have enough 
change to return to the customer.

**Allowed coins:**
25c 50c 1$ 2$ 5$

### Initialization
**To operate the Vending Machine please launch**

```
machine.rb
```

**Initialized with the following products in inventory:**

|Product Description|Price|Quantity|
|-------------------|-----|--------|
|Chocolate Bar|$1.75|2 pcs.|
|Apple Juice|$2.50|2 pcs.|
|Cotton Candy|$3.25|3 pcs.|
|Mineral Water|$1.00| 1 pcs.|
|Safety Matches|$0.25| 0 pcs.|

**Initial counter total:**

|Coin|Quantity|
|----|--------|
|$5.00|5|
|$2.00|5|
|$1.00|5|
|$0.50|5|
|$0.25|5|

### Built With
- Ruby 3.0.0

### Gem dependencies
- tty-prompt
- tty-table
