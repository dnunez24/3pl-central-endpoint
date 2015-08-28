class Shipment
  def initialize(args)
    @data = {
      id: nil,
      order_id: nil,
      email: nil,
      cost: nil,
      status: nil,
      stock_location: nil,
      shipping_method: nil,
      traking: nil,
      updated_at: nil,
      shipped_at: nil,
      retailer: nil,
      shipping_address: ShippingAddress.new.to_h,
      packages: [],
      items: []
    }
  end

  def add_address(address)
    @data[:shipping_address] = address
  end

  def add_packages(packages)
    packages.each do |package|
      add_package(package)
    end
  end

  def add_package(package)
    @data[:packages] << Package.new(package).to_h
  end

  def add_items(items)

  end

  def add_item(item)

  end

  def to_h
    @data
  end

  def method_misssing(meth, args, &block)

  end

  def respond_to?(meth)

  end
end
