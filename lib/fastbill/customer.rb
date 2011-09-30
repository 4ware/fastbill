class Customer
  include HTTParty
  base_uri 'https://portal.fastbill.com'

  attr_accessor :id, :number, :days_for_payment, :created_at, :payment_type, :bank_name, :bank_account_number, :bank_code, :bank_account_owner, :show_payment_notice, :account_receiveable, :customer_type, :top, :organization, :position, :saltuation, :first_name, :last_name, :address, :address_2, :zipcode, :city, :country_code, :phone, :phone_2, :fax, :mobile, :email, :vat_id, :currency_code, :comment 

  def initialize(auth)
    @auth = auth
  end
  
  def customers
    options = {
      :basic_auth => @auth,
      :headers => {
        "Content-Type" => "application/xml"
      },
      :body => '<?xml version="1.0" encoding="utf-8"?><FBAPI><SERVICE>customer.get</SERVICE></FBAPI>'
    }
    r = self.class.post('/api/0.1/api.php', options)
    unless r.body.nil?
      body = Crack::XML.parse r.body
      unless body['FBAPI']["RESPONSE"]["CUSTOMERS"].nil?
        customers = []
        for customer in body['FBAPI']["RESPONSE"]["CUSTOMERS"]["CUSTOMER"].each
          c = Customer.new(@auth)
          c.hydrate(customer)
          customers.push c
        end
        customers
      end
    end
  end

  def get(id)
    options = {
      :basic_auth => @auth,
      :headers => {
        "Content-Type" => "application/xml"
      },
      :body => '<?xml version="1.0" encoding="utf-8"?><FBAPI><SERVICE>customer.get</SERVICE><FILTER><CUSTOMER_ID>' + id.to_s + '</CUSTOMER_ID></FILTER></FBAPI>'
    }
    r = self.class.post('/api/0.1/api.php', options)
    body = Crack::XML.parse r.body
    if !body['FBAPI']["RESPONSE"]["CUSTOMERS"].nil?
      hydrate(body['FBAPI']["RESPONSE"]["CUSTOMERS"]["CUSTOMER"])
      self
    else
      false
    end
  end
  
  def hydrate(body)
    @id = body["CUSTOMER_ID"]
    @number = body["CUSTOMER_NUMBER"]
    @days_for_payment = body["DAYS_FOR_PAYMENT"]
    @created_at = Time.parse body["CREATED"]
    @payment_type = body["PAYMENT_TYPE"]
    @bank_name = body["BANK_NAME"]
    @bank_account_number = body["BANK_ACCOUNT_NUMBER"]
    @bank_code = body["BANK_CODE"]
    @bank_account_owner = body["BANK_ACCOUNT_OWNER"]
    @show_payment_notice = body["SHOW_PAYMENT_NOTICE"]
    @account_receiveable = body["ACCOUNT_RECEIVEABLE"]
    @customer_type = body["CUSTOMER_TYPE"]
    @top = body["TOP"] == "1" ? true : false
    @organization = body["ORGANIZATION"]
    @position = body["POSITION"]
    @saltuation = body["SALUATION"]
    @first_name = body["FIRST_NAME"]
    @last_name = body["LAST_NAME"]
    @address = body["ADDRESS"]
    @address_2 = body["ADDRESS_2"]
    @zipcode = body["ZIPCODE"]
    @city = body["CITY"]
    @country_code = body["COUNTRY_CODE"]
    @phone = body["PHONE"]
    @phone_2 = body["PHONE_2"]
    @fax = body["FAX"]
    @mobile = body["MOBILE"]
    @email = body["EMAIL"]
    @vat_id = body["VAT_ID"]
    @currency_code = body["CURRENCY_CODE"]
    @comment = body["COMMENT"]    
  end
end