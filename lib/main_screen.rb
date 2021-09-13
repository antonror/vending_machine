require 'tty-prompt'
require 'tty-table'

class MainScreen
  PROMPT = TTY::Prompt.new(symbols: { marker: '>' }, interrupt: :exit)
  COINS = [
    { name: '$5', value: 5.00 },
    { name: '$2', value: 2.00 },
    { name: '1$', value: 1.00 },
    { name: '50c', value: 0.50 },
    { name: '25c', value: 0.25 }
  ]

  def welcome_message
    PROMPT.ok("Welcome to the Vending Machine!")
  end

  def menu
    options = [
      { name: 'Buy', value: 1 },
      { name: 'Reinitialize Inventory', value: 2 },
      { name: 'Reinitialize Counter', value: 3 },
      { name: 'quit', value: nil }
    ]
    PROMPT.select('Please make your choice', options)
  end

  def product_options(list:)
    product_list = list.map { |item| item_details(item: item) }
    product_list << { name: 'back', value: nil }
    
    PROMPT.select("Select product", product_list)
  end

  def invalid_selection
    PROMPT.error("Invalid selection. Please try again")
  end

  def product_unavailable
    PROMPT.error("Product unavailable. Please choose again")
  end

  def insert_coins(product:)
    PROMPT.ok("Selected #{product.name}. Please pay $#{product.price.round(2)}")
  end

  def coin_options
    PROMPT.select("Insert a coin", COINS)
  end

  def more_coins(paid:, remaining:)
    PROMPT.ok("Paid $#{paid.round(2)}.")
    PROMPT.warn("$#{remaining.round(2)} remaining")
  end

  def total_payment(total:)
    PROMPT.ok("Total amount of coins paid: $#{total.round(2)}")
  end

  def transaction_failed
    PROMPT.error("Failed to receive payment. Please try again")
  end

  def product_and_change(product:, change:)
    PROMPT.ok("Here is your: #{product.name}")
    unless change.nil?
      breakdown = change.map do |coin|
        prefix = '$' if coin.value >= 1
        suffix = 'c' if coin.value < 1
        "#{prefix unless prefix.nil?}#{coin.value.round(2)}#{suffix unless suffix.nil?}"
      end.join(', ')

      total = change.map(&:value).inject(0, &:+)
      PROMPT.ok("and your change of $#{total.round(2)}, coins: [#{breakdown}]")
    end
  end

  def coin_table(coins:)
    table = TTY::Table.new(header: ['Coin', 'Amount'], rows: coins)
    puts table.render(:ascii)
  end

  def insert_coin_to_reload
    PROMPT.select("Insert a coin to reload", COINS)
  end

  def continue?
    PROMPT.yes?('Continue?')
  end

  def select_product_to_reload(list:)
    product_list = list.map { |item| item_details(item: item) }
    product_list << { name: 'back', value: nil }
    PROMPT.select("Select a product to reload", product_list)
  end

  def select_coin_to_reload(coin_list:)
    coins = coin_list.map do |coin|
      { name: "#{coin[:value]}, quantity in counter: #{coin[:quantity]}", value: coin[:value]}
    end
    coins << { name: 'back', value: nil }
    PROMPT.select("Insert a coin to reload", coins)
  end

  def products_table(products:)
    table = TTY::Table.new(header: ['Product', 'Quantity'], rows: products)
    puts table.render(:ascii)
  end

  def goodbye
    PROMPT.ok("Ended gracefully!")
  end

  private

  def item_details(item:)
    {
      name: "#{item[:product].name} $#{item[:product].price.round(2)}, quantity: #{item[:qty]}",
      value: item
    }
  end
end
