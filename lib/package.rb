class Package
  def initialize()
    @data = {
      tracking_number: nil,
      sku: nil,
      quantity: nil,
      cost: nil
    }
  end

  def to_h
    @data
  end
end
