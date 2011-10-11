class Customer
  include HTTParty
  base_uri 'https://portal.fastbill.com'

  attr_accessor :id, :number, :days_for_payment, :created_at, :payment_type, :bank_name, :bank_account_number, :bank_code, :bank_account_owner, :show_payment_notice, :account_receiveable, :customer_type, :top, :organization, :position, :saltuation, :first_name, :last_name, :address, :address_2, :zipcode, :city, :country_code, :phone, :phone_2, :fax, :mobile, :email, :vat_id, :currency_code, :comment 

  def initialize(auth = nil)
    @auth = auth
    @is_new = true
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
  def save
    if @is_new
      #create
      options = {
        :basic_auth => @auth,
        :headers => {
          "Content-Type" => "application/xml"
        },
        :body => '<?xml version="1.0" encoding="utf-8"?><FBAPI><SERVICE>customer.create</SERVICE><DATA>' + self.to_xml + '</DATA></FBAPI>'
      }
      r = self.class.post('/api/0.1/api.php', options)
      body = Crack::XML.parse r.body
      if !body['FBAPI']["RESPONSE"]["STATUS"].nil? && body['FBAPI']["RESPONSE"]["STATUS"] == "success"
        unless body['FBAPI']["RESPONSE"]["STATUS"]["CUSTOMER_ID"].nil?
          @id = body['FBAPI']["RESPONSE"]["STATUS"]["CUSTOMER_ID"]
        end
        @is_new = false
        self
      else
        false
      end
    else
      #update
      options = {
        :basic_auth => @auth,
        :headers => {
          "Content-Type" => "application/xml"
        },
        :body => '<?xml version="1.0" encoding="utf-8"?><FBAPI><SERVICE>customer.update</SERVICE><DATA>' + self.to_xml + '</DATA></FBAPI>'
      }
      r = self.class.post('/api/0.1/api.php', options)
      body = Crack::XML.parse r.body
      if !body['FBAPI']["RESPONSE"]["STATUS"].nil? && body['FBAPI']["RESPONSE"]["STATUS"] == "success"
        unless body['FBAPI']["RESPONSE"]["STATUS"]["CUSTOMER_ID"].nil?
          @id = body['FBAPI']["RESPONSE"]["STATUS"]["CUSTOMER_ID"]
        end
        self
      else
        false
      end
    end
  end
  def delete!
    options = {
      :basic_auth => @auth,
      :headers => {
        "Content-Type" => "application/xml"
      },
      :body => '<?xml version="1.0" encoding="utf-8"?><FBAPI><SERVICE>customer.delete</SERVICE><DATA><CUSTOMER_ID>' + @id + '</CUSTOMER_ID></DATA></FBAPI>'
    }
    r = self.class.post('/api/0.1/api.php', options)
    body = Crack::XML.parse r.body
    if !body['FBAPI']["RESPONSE"]["STATUS"].nil? && body['FBAPI']["RESPONSE"]["STATUS"] == "success"
      true
    else
      false
    end    
  end
  
  def hydrate(body)
    @is_new = false
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
  def to_xml
    xml = ""
    unless @id.nil?
      xml = xml + "<CUSTOMER_ID>#{@id}</CUSTOMER_ID>"
    end
    unless @number.nil?
      xml = xml + "<CUSTOMER_NUMBER>#{@number}</CUSTOMER_NUMBER>"
    end
    unless @days_for_payment.nil?
      xml = xml + "<DAYS_FOR_PAYMENT>#{@days_for_payment}</DAYS_FOR_PAYMENT>"
    end
    unless @payment_type.nil?
      xml = xml + "<PAYMENT_TYPE>#{@payment_type}</PAYMENT_TYPE>"
    end
    unless @bank_name.nil?
      xml = xml + "<BANK_NAME>#{@bank_name}</BANK_NAME>"
    end
    unless @bank_account_number.nil?
      xml = xml + "<BANK_ACCOUNT_NUMBER>#{@bank_account_number}</BANK_ACCOUNT_NUMBER>"
    end
    unless @bank_code.nil?
      xml = xml + "<BANK_CODE>#{@bank_code}</BANK_CODE>"
    end
    unless @bank_account_owner.nil?
      xml = xml + "<BANK_ACCOUNT_OWNER>#{@bank_account_owner}</BANK_ACCOUNT_OWNER>"
    end
    unless @show_payment_notice.nil?
      xml = xml + "<SHOW_PAYMENT_NOTICE>#{@show_payment_notice}</SHOW_PAYMENT_NOTICE>"
    end
    unless @account_receivable.nil?
      xml = xml + "<ACCOUNT_RECEIVABLE>#{@account_receivable}</ACCOUNT_RECEIVABLE>"
    end
    unless @customer_type.nil?
      xml = xml + "<CUSTOMER_TYPE>#{@customer_type}</CUSTOMER_TYPE>"
    end
    unless @top.nil?
      t = @top ? 1 : 0
      xml = xml + "<TOP>#{t}</TOP>"
    end
    unless @organization.nil?
      xml = xml + "<ORGANIZATION>#{@organization}</ORGANIZATION>"
    end
    unless @position.nil?
      xml = xml + "<POSITION>#{@position}</POSITION>"
    end
    unless @saltuation.nil?
      xml = xml + "<SALUATION>#{@saltuation}</SALUATION>"
    end
    unless @first_name.nil?
      xml = xml + "<FIRST_NAME>#{@first_name}</FIRST_NAME>"
    end
    unless @last_name.nil?
      xml = xml + "<LAST_NAME>#{@last_name}</LAST_NAME>"
    end
    unless @address.nil?
      xml = xml + "<ADDRESS>#{@address}</ADDRESS>"
    end
    unless @address_2.nil?
      xml = xml + "<ADDRESS_2>#{@address_2}</ADDRESS_2>"
    end
    unless @zipcode.nil?
      xml = xml + "<ZIPCODE>#{@zipcode}</ZIPCODE>"
    end
    unless @city.nil?
      xml = xml + "<CITY>#{@city}</CITY>"
    end
    unless @country_code.nil?
      xml = xml + "<COUNTRY_CODE>#{@country_code}</COUNTRY_CODE>"
    end
    unless @phone.nil?
      xml = xml + "<PHONE>#{@phone}</PHONE>"
    end
    unless @phone_2.nil?
      xml = xml + "<PHONE_2>#{@phone_2}</PHONE_2>"
    end
    unless @fax.nil?
      xml = xml + "<FAX>#{@fax}</FAX>"
    end
    unless @mobile.nil?
      xml = xml + "<MOBILE>#{@mobile}</MOBILE>"
    end
    unless @email.nil?
      xml = xml + "<EMAIL>#{@email}</EMAIL>"
    end
    unless @vat_id.nil?
      xml = xml + "<VAT_ID>#{@vat_id}</VAT_ID>"
    end
    unless @currency_code.nil?
      xml = xml + "<CURRENCY_CODE>#{@currency_code}</CURRENCY_CODE>"
    end
    unless @comment.nil?
      xml = xml + "<COMMENT>#{@comment}</COMMENT>"
    end
    xml
  end
end