class FedexController < ApplicationController
  def index
  end

  def edit
  end

  def update
  end

  def create
  end

  def new
  end

  def destroy
  end

  private

  def create_shipment
    # If you have created the omniship.yml config file
    @config  = OMNISHIP_CONFIG[Rails.env]['ups']
    shipment = create_ups_shipment
  end

  def create_ups_shipment
    # If using the yml config
    ups = Omniship::UPS.new
    # Else just pass in the credentials
    ups = Omniship::UPS.new(:login => @user, :password => @password, :key => @key)
    send_options = {}
    send_options[:origin_account] = @config["account"] # Or just put the shipper account here
    send_options[:service]        = "03"
    response = ups.create_shipment(origin, destination, package, options = send_options)
    return ups.accept_shipment(response)
  end

  def origin
    address = {}
    address[:name]     = "My House"
    address[:address1] = "555 Diagonal"
    address[:city]     = "Saint George"
    address[:state]    = "UT"
    address[:zip]      = "84770"
    address[:country]  = "USA"
    return Omniship::Address.new(address)
  end

  def destination
    address = {}
    address[:company_name] = "Wal-Mart"
    address[:address1]     = "555 Diagonal"
    address[:city]         = "Saint George"
    address[:state]        = "UT"
    address[:zip]          = "84770"
    address[:country]      = "USA"
    return Omniship::Address.new(address)
  end

  def packages
    # UPS can handle a single package or multiple packages
    pkg_list = []
    weight = 1
    length = 1
    width  = 1
    height = 1
    package_type = "02"
    pkg_list << Omniship::Package.new(weight.to_i,[length.to_i,width.to_i,height.to_i],:units => :imperial, :package_type => package_type)
    return pkg_list
  end
end
