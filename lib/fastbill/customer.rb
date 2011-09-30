class Customer
  # 62288
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
    self.class.post('/api/0.1/api.php', options)
  end

  def find(id)
    options = {
      :basic_auth => @auth,
      :headers => {
        "Content-Type" => "application/xml"
      },
      :body => '<?xml version="1.0" encoding="utf-8"?><FBAPI><SERVICE>customer.get</SERVICE><FILTER><CUSTOMER_ID>' + id.to_s + '</CUSTOMER_ID></FILTER></FBAPI>'
    }
    r = self.class.post('/api/0.1/api.php', options)
    body = Crack::XML.parse r.body
    #check for error
    if !body['FBAPI']["RESPONSE"]["CUSTOMERS"].nil?
      @id = body['FBAPI']["RESPONSE"]["CUSTOMERS"]["CUSTOMER"]["CUSTOMER_ID"]
      @number = body['FBAPI']["RESPONSE"]["CUSTOMERS"]["CUSTOMER"]["CUSTOMER_NUMBER"]
      @days_for_payment = body['FBAPI']["RESPONSE"]["CUSTOMERS"]["CUSTOMER"]["DAYS_FOR_PAYMENT"]
      @created_at = Time.parse body['FBAPI']["RESPONSE"]["CUSTOMERS"]["CUSTOMER"]["CREATED"]
      @payment_type = body['FBAPI']["RESPONSE"]["CUSTOMERS"]["CUSTOMER"]["PAYMENT_TYPE"]
      @bank_name = body['FBAPI']["RESPONSE"]["CUSTOMERS"]["CUSTOMER"]["BANK_NAME"]
      @bank_account_number = body['FBAPI']["RESPONSE"]["CUSTOMERS"]["CUSTOMER"]["BANK_ACCOUNT_NUMBER"]
      @bank_code = body['FBAPI']["RESPONSE"]["CUSTOMERS"]["CUSTOMER"]["BANK_CODE"]
      @bank_account_owner = body['FBAPI']["RESPONSE"]["CUSTOMERS"]["CUSTOMER"]["BANK_ACCOUNT_OWNER"]
      @show_payment_notice = body['FBAPI']["RESPONSE"]["CUSTOMERS"]["CUSTOMER"]["SHOW_PAYMENT_NOTICE"]
      @account_receiveable = body['FBAPI']["RESPONSE"]["CUSTOMERS"]["CUSTOMER"]["ACCOUNT_RECEIVEABLE"]
      @customer_type = body['FBAPI']["RESPONSE"]["CUSTOMERS"]["CUSTOMER"]["CUSTOMER_TYPE"]
      @top = body['FBAPI']["RESPONSE"]["CUSTOMERS"]["CUSTOMER"]["TOP"] == "1" ? true : false
      @organization = body['FBAPI']["RESPONSE"]["CUSTOMERS"]["CUSTOMER"]["ORGANIZATION"]
      @position = body['FBAPI']["RESPONSE"]["CUSTOMERS"]["CUSTOMER"]["POSITION"]
      @saltuation = body['FBAPI']["RESPONSE"]["CUSTOMERS"]["CUSTOMER"]["SALUATION"]
      @first_name = body['FBAPI']["RESPONSE"]["CUSTOMERS"]["CUSTOMER"]["FIRST_NAME"]
      @last_name = body['FBAPI']["RESPONSE"]["CUSTOMERS"]["CUSTOMER"]["LAST_NAME"]
      @address = body['FBAPI']["RESPONSE"]["CUSTOMERS"]["CUSTOMER"]["ADDRESS"]
      @address_2 = body['FBAPI']["RESPONSE"]["CUSTOMERS"]["CUSTOMER"]["ADDRESS_2"]
      @zipcode = body['FBAPI']["RESPONSE"]["CUSTOMERS"]["CUSTOMER"]["ZIPCODE"]
      @city = body['FBAPI']["RESPONSE"]["CUSTOMERS"]["CUSTOMER"]["CITY"]
      @country_code = body['FBAPI']["RESPONSE"]["CUSTOMERS"]["CUSTOMER"]["COUNTRY_CODE"]
      @phone = body['FBAPI']["RESPONSE"]["CUSTOMERS"]["CUSTOMER"]["PHONE"]
      @phone_2 = body['FBAPI']["RESPONSE"]["CUSTOMERS"]["CUSTOMER"]["PHONE_2"]
      @fax = body['FBAPI']["RESPONSE"]["CUSTOMERS"]["CUSTOMER"]["FAX"]
      @mobile = body['FBAPI']["RESPONSE"]["CUSTOMERS"]["CUSTOMER"]["MOBILE"]
      @email = body['FBAPI']["RESPONSE"]["CUSTOMERS"]["CUSTOMER"]["EMAIL"]
      @vat_id = body['FBAPI']["RESPONSE"]["CUSTOMERS"]["CUSTOMER"]["VAT_ID"]
      @currency_code = body['FBAPI']["RESPONSE"]["CUSTOMERS"]["CUSTOMER"]["CURRENCY_CODE"]
      @comment = body['FBAPI']["RESPONSE"]["CUSTOMERS"]["CUSTOMER"]["COMMENT"]
      self
    else
      false
    end
  end
  
end