require './lib/account'
require './lib/coin'
require './lib/inventory'
require './lib/counter'
require './lib/main_screen'

class VendingMachine
  def initialize
    @main_screen = MainScreen.new
    @inventory = Inventory.new
    @counter = Counter.new
    @account = Account.new
    @coins_inserted = []
    @item_selected = nil
  end

  def start
    main_screen.welcome_message
    loop do
      option = main_screen.menu
      case option
      when 1
        order
        next if item_selected.nil?
        pay(product: item_selected[:product])
        sell
      when 2
        reinitialize_inventory
      when 3
        reinitialize_counter
      else
        main_screen.goodbye
        exit
      end
    end
    main_screen.goodbye
  end

  private

  attr_accessor :coins_inserted, :item_selected
  attr_reader :inventory, :counter, :main_screen, :account

  def sell
    change = counter.calculate_change(paid: sum_coins_inserted, price: item_selected[:product].price)
    if change.positive?
      change_in_coins = counter.dispense_change(amount: change)
      if change_in_coins.nil?
        account.add_transaction(item: item_selected, type: :no_change)
        return main_screen.transaction_failed
      end
    end

    product_purchased = inventory.sell_product(uid: item_selected[:uid])
    account.add_transaction(item: item_selected, type: :sale)
    main_screen.product_and_change(product: product_purchased, change: change_in_coins)
    reset
  end

  def order
    product_list = inventory.product_listing
    self.item_selected = main_screen.product_options(list: product_list)
    return if item_selected.nil?
    if inventory.product_unavailable?(uid: item_selected[:uid])
      account.add_transaction(item: item_selected, type: :no_product)
      main_screen.product_unavailable
      reset
    end
  end

  def pay(product:)
    main_screen.insert_coins(product: product)
    until sum_coins_inserted >= product.price do
      remaining_to_pay = product.price - sum_coins_inserted
      main_screen.more_coins(paid: sum_coins_inserted, remaining: remaining_to_pay)
      coin_value = main_screen.coin_options
      insert_coin(value: coin_value)
    end
    counter.deposit(coins_inserted: coins_inserted)
    main_screen.total_payment(total: sum_coins_inserted)
  end

  def insert_coin(value:)
    coins_inserted << Coin.new(value: value)
  end

  def sum_coins_inserted
    coins_inserted.map(&:value).inject(0, &:+)
  end

  def reset
    self.coins_inserted = []
    self.item_selected = nil
  end

  def reinitialize_inventory
    item = main_screen.select_product_to_reload(list: inventory.product_listing)
    return if item.nil?
    inventory.reinitialize(uid: item[:uid])
  end

  def reinitialize_counter
    value = main_screen.select_coin_to_reload(coin_list: counter.coins_in_counter)
    return if value.nil?
    counter.reinitialize(value: value)
  end
end
