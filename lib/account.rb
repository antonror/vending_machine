require './lib/transaction'

class Account
  attr_reader :transactions

  def initialize
    @transactions = []
  end

  def add_transaction(item:, type:)
    self.transactions = transactions << Transaction.new(
      product_name: item[:product].name,
      value: item[:product].price,
      type: type)
  end

  private

  attr_writer :transactions
end