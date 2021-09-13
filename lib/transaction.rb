class Transaction
  attr_reader :product_name, :value, :time, :type

  def initialize(product_name:, value:, type:)
    @product_name = product_name
    @value = value
    @type = type
  end
end
