class ShipmentData < Hash
  def initialize(shipment)
    self.merge!(shipment)
  end

  def transaction
    self[:warehouse_transaction]
  end

  def transaction_id
    transaction[:transaction_id]
  end

  def shipping_instructions
    transaction[:shipping_instructions]
  end

  def retailer
    self[:retailer]
  end

  def reference_number
    transaction[:trans_info][:reference_num]
  end

  def ship_to
    transaction[:ship_to]
  end

  def ship_method
    carrier = shipping_instructions[:carrier]
    service = shipping_instructions[:ship_service]
    "#{carrier} #{service}"
  end
end


ShipmentData = Struct.new(
  :order_transaction_id,
  :order_reference_number
).new do
  def ship_to
    Struct.new(:address1, :address2)
  end
end

address_properties = [
  :first_name,
  :last_name,
  :address1,
  :address2,
  :city,
  :state,
  :zip_code,
  :country,
  :phone
]

Address = Struct.new(*address_properties) do
  def initialize(attrs)
    first_name, last_name = split_name(attrs[:name])
    super first_name, last_name, attrs[:address1], attrs[:address2],
      attrs[:city], attrs[:state], attrs[:zip], attrs[:country], attrs[:phone]
  end

private

  def split_name(full_name)
    return [nil, nil] if full_name.nil?
    *first_name, last_name = full_name.split(/\s+/)
    [first_name.join(' '), last_name]
  end
end

address_properties = [
  :first_name,
  :last_name,
  :address1,
  :address2,
  :city,
  :state,
  :zip_code,
  :country,
  :phone
]

Address = Struct.new(*address_properties) do
  def initialize(args)
    self.name = args[:name]
    @address1 = args[:address][:address1]
    @address2 = args[:address][:address2]
    @city = args[:address][:city]
    @state = args[:address][:state]
    @zip_code = args[:address][:zip]
    @country = args[:address][:country]
    @phone = args[:phone_number1]
  end

private

  def name=(full_name)
    @first_name, @last_name = split_name(full_name)
  end

  def split_name(full_name)
    return [nil, nil] if full_name.nil?
    *first_name, last_name = full_name.split(/\s+/)
    [first_name.join(' '), last_name]
  end
end

ship_to = {
  contact_id: "73556",
  name: nil,
  title: nil,
  company_name: "Amazon.com dedc, LLC",
  address: {
    address1: "7200 Discovery Dr",
    address2: nil,
    city: "Chattanooga",
    state: "TN",
    zip: "37416",
    country: "US"
  },
  phone_number1: nil
}
