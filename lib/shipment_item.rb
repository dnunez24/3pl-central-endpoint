class ShipmentItem
  def initialize()
    @data = {
      product_id: nil,
      name: nil,
      quantity: nil,
      price: nil
    }
  end

  def to_h
    @data
  end
end
