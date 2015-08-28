class ShippingAddress
  def initialize()
    @data = {
      firstname: nil,
      lastname: nil,
      address1: nil,
      address2: nil,
      zipcode: nil,
      city: nil,
      state: nil,
      country: nil,
      phone: nil
    }
  end

  def to_h
    @data
  end
end
