require './lib/product'

class Inventory
  attr_reader :products

  PRODUCT_LIST = [
    {
      product: Product.new(name: 'Chocolate Bar', price: 1.75),
      qty: 2,
      uid: '1'
    },
    {
      product: Product.new(name: 'Apple Juice', price: 2.50),
      qty: 2,
      uid: '2'
    },
    {
      product: Product.new(name: 'Cotton Candy', price: 3.25),
      qty: 3,
      uid: '3'
    },
    {
      product: Product.new(name: 'Mineral Water', price: 1.00),
      qty: 1,
      uid: '4'
    },
    {
      product: Product.new(name: 'Matches', price: 0.25),
      qty: 0,
      uid: '5'
    }
  ]

  def initialize
    @products = generate_products
  end

  def sell_product(uid:)
    products[uid].pop
  end

  def product_unavailable?(uid:)
    products[uid].empty?
  end

  def product_listing
    PRODUCT_LIST.map do |item|
      item[:qty] = products[item[:uid]].length
      item
    end
  end

  def find_product(uid:)
    products[uid].last
  end

  def reinitialize(uid:)
    product = PRODUCT_LIST.find { |item| item[:uid] == uid }[:product]
    products[uid] <<  product unless product.nil?
  end

  private

  def generate_products
    PRODUCT_LIST.map do |item|
      [item[:uid], Array.new(item[:qty], item[:product])]
    end.to_h
  end
end
