class UpsController < ApplicationController
  def index
    @shipment = create_shipment
    @rates = create_rates
    @tracking = tracking_request
    @valid_address = validate_address
    @valid_address_street = validate_address_street
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

  def create_rates
    @config  = OMNISHIP_CONFIG['ups']
    @tracking = create_ups_rates
  end

  def create_ups_rates
    ups = Omniship::UPS.new(@config)
    send_options = {}
    send_options[:test] = true
    send_options[:origin_account] = @config["account"]
    send_options[:service]        = "03"
    response = ups.find_rates(origin, destination, packages, send_options)
  end

  def tracking_request
    ups = Omniship::UPS.new(@config)
    send_options = {}
    send_options[:test] = true
    response = ups.find_tracking_info("1Z12345E0291980793", send_options)
  end

  def validate_address
    ups = Omniship::UPS.new(@config)
    send_options = {}
    send_options[:test] = true
    response = ups.validate_address("St. George","UT","84790","US", send_options)
  end

  def validate_address_street
    ups = Omniship::UPS.new(@config)
    send_options = {}
    send_options[:test] = false
    response = ups.validate_address_street("2930 E 450 N #20","St. George","UT","84790","US", send_options)
  end

  def create_shipment
    # If you have created the omniship.yml config file
    @config  = OMNISHIP_CONFIG['ups']
    @shipment = create_ups_shipment
  end

  def create_ups_shipment
    ups = Omniship::UPS.new(@config)
    send_options = {}
    send_options[:description] = "My shipment"
    send_options[:test] = true
    send_options[:origin_account] = @config["account"]
    send_options[:service]        = "03"
    send_options[:return_service_code] = "9"
    send_options[:return_service_description] = "UPS Print Return Label (PRL)"
    send_options[:return_label_email] = "digi.cazter@gmail.com"
    send_options[:from_email_address] = "donavan@efusionpro.com"
    send_options[:from_name] = "Donavan White"
    send_options[:nonvalidate] = true
    response = ups.create_shipment(origin, destination, packages, send_options)
    logger.info "*************************"
    logger.info response
    logger.info "*************************"
    return ups.accept_shipment(response)
  end

  def origin
    address = {}
    address[:name]         = "My House"
    address[:company_name] = "Big Toy Barn"
    address[:address1]     = "555 Diagonal"
    address[:city]         = "Saint George"
    address[:state]        = "UT"
    address[:zip]          = "84770"
    address[:country]      = "USA"
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
    pkg_list << Omniship::Package.new(weight.to_i,[length.to_i,width.to_i,height.to_i],units: :imperial, package_type: package_type)
    return pkg_list
  end
end