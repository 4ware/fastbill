class Recurring
  include HTTParty
  base_uri 'https://portal.fastbill.com'
  
  attr_accessor :id, :invoice_type, :customer_id, :customer_costcenter_id, :currency_code, :template_id, :invoice_number, :introtext, :start_date, :frequency, :occurences, :output_type, :email_notify, :delivery_date, :eu_delivery, :vat_items, :invoice_items, :is_new
  
  def initialize(auth = nil)
    @auth = auth
    @is_new = true
  end
  
  def get(id = nil)
    body = '<?xml version="1.0" encoding="utf-8"?><FBAPI><SERVICE>recurring.get</SERVICE>'
    if id
      body = body + "<FILTER><INVOICE_ID>#{id}</INVOICE_ID></FILTER>"
    end
    body = body + "</FBAPI>"
    options = {
      :basic_auth => @auth,
      :headers => {
        "Content-Type" => "application/xml"
      },
      :body => body
    }
    r = self.class.post('/api/0.1/api.php', options)
    body = Crack::XML.parse r.body
    invoices = []
    if body['FBAPI']["RESPONSE"]["INVOICES"]["INVOICE"].class.to_s == 'Hash'
      inv = Recurring.new(@auth)
      inv.hydrate(body['FBAPI']["RESPONSE"]["INVOICES"]["INVOICE"])
      invoices.push inv
    else
      for invoice in body['FBAPI']["RESPONSE"]["INVOICES"]["INVOICE"].each
        inv = Recurring.new(@auth)
        inv.hydrate(invoice)
        invoices.push inv
      end
    end
    invoices
  end
  def save!
    if @is_new
      #create
      options = {
        :basic_auth => @auth,
        :headers => {
          "Content-Type" => "application/xml"
        },
        :body => '<?xml version="1.0" encoding="utf-8"?><FBAPI><SERVICE>recurring.create</SERVICE><DATA>' + self.to_xml + '</DATA></FBAPI>'
      }
      r = self.class.post('/api/0.1/api.php', options)
      body = Crack::XML.parse r.body
      if !body['FBAPI']["RESPONSE"]["STATUS"].nil? && body['FBAPI']["RESPONSE"]["STATUS"] == "success"
        unless body['FBAPI']["RESPONSE"]["STATUS"]["INVOICE_ID"].nil?
          @id = body['FBAPI']["RESPONSE"]["STATUS"]["INVOICE_ID"]
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
        :body => '<?xml version="1.0" encoding="utf-8"?><FBAPI><SERVICE>recurring.update</SERVICE><DATA>' + self.to_xml + '</DATA></FBAPI>'
      }
      r = self.class.post('/api/0.1/api.php', options)
      body = Crack::XML.parse r.body
      if !body['FBAPI']["RESPONSE"]["STATUS"].nil? && body['FBAPI']["RESPONSE"]["STATUS"] == "success"
        unless body['FBAPI']["RESPONSE"]["STATUS"]["INVOICE_ID"].nil?
          @id = body['FBAPI']["RESPONSE"]["STATUS"]["INVOICE_ID"]
        end
        @is_new = false
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
      :body => '<?xml version="1.0" encoding="utf-8"?><FBAPI><SERVICE>recurring.delete</SERVICE><DATA><INVOICE_ID>' + @id + '</INVOICE_ID></DATA></FBAPI>'
    }
    r = self.class.post('/api/0.1/api.php', options)
    body = Crack::XML.parse r.body
    if !body['FBAPI']["RESPONSE"]["STATUS"].nil? && body['FBAPI']["RESPONSE"]["STATUS"] == "success"
      true
    else
      false
    end    
  end
  def to_xml
    xml = ""
    unless @id.nil?
      xml = xml + "<INVOICE_ID>#{@id}</INVOICE_ID>"
    end
    unless @customer_id.nil?
      xml = xml + "<CUSTOMER_ID>#{@customer_id}</CUSTOMER_ID>"
    end
    unless @customer_costcenter_id.nil?
      xml = xml + "<CUSTOMER_COSTCENTER_ID>#{@customer_costcenter_id}</CUSTOMER_COSTCENTER_ID>"
    end
    unless @currency_code.nil?
      xml = xml + "<CURRENCY_CODE>#{@currency_code}</CURRENCY_CODE>"
    end
    unless @template_id.nil?
      xml = xml + "<TEMPLATE_ID>#{@template_id}</TEMPLATE_ID>"
    end
    unless @invoice_number.nil?
      xml = xml + "<INVOICE_NUMBER>#{@invoice_number}</INVOICE_NUMBER>"
    end
    unless @introtext.nil?
      xml = xml + "<INTROTEXT>#{@introtext}</INTROTEXT>"
    end
    if @start_date
      xml = xml + "<START_DATE>#{@start_date.strftime("%Y-%m-%d")}</START_DATE>"
    end
    unless @frequency.nil?
      xml = xml + "<FREQUENCY>#{@frequency}</FREQUENCY>"
    end
    unless @occurrences.nil?
      xml = xml + "<OCCURENCES>#{@occurences}</OCCURENCES>"
    end
    unless @output_type.nil?
      xml = xml + "<OUTPUT_TYPE>#{@output_type}</OUTPUT_TYPE>"
    end
    unless @email_notify.nil?
      xml = xml + "<EMAIL_NOTIFY>#{@email_notify}</EMAIL_NOTIFY>"
    end
    unless @delivery_date.nil?
      xml = xml + "<DELIVERY_DATE>#{@delivery_date.strftime("%Y-%m-%d")}</DELIVERY_DATE>"
    end
    unless @eu_delivery.nil?
      eu = @eu_delivery ? 1 : 0
      xml = xml + "<EU_DELIVERY>#{@eu}</EU_DELIVERY>"
    end
    unless @invoice_items.length == 0
      xml = xml + "<ITEMS>"
      for item in @invoice_items.each
        xml = xml + item.to_xml
      end
      xml = xml + "</ITEMS>"
    end
    xml
  end
  def hydrate(body)
    @is_new = false
    @id = body["INVOICE_ID"]
    @invoice_type = body["INVOICE_TYPE"]
    @customer_id = body["CUSTOMER_ID"]
    @customer_costcenter_id = body["CUSTOMER_COSTCENTER_ID"]
    @currency_code = body["CURRENCY_CODE"]
    @template_id = body["TEMPLATE_ID"]
    @occurances = body["OCCURANCES"]
    @frequency = body["FREQUENCY"]
    @start_date = parse_date body["START_DATE"]
    @email_notify = body["EMAIL_NOTIFY"]
    @output_type = body["OUTPUT_TYPE"]
    @introtext = body["INTROTEXT"]
    #@delivery_date = parse_date body["DELIVERY_DATE"]
    @sub_total = body["SUB_TOTAL"]
    @vat_total = body["VAT_TOTAL"]
    #@eu_delivery = body["EU_DELIVERY"] == "1" ? true : false
    @vat_items = []
    @total = body["TOTAL"]
    for vat_item in body["VAT_ITEMS"].each
      @vat_items.push InvoiceVatItem.new vat_item.last
    end
    @invoice_items = []
    for item in body["ITEMS"].each
      begin
        i =  InvoiceItem.new(@auth)
        i.hydrate(item.last)
        @invoice_items.push i
      rescue
      end
    end
  end
  def parse_date(date)
    if date != nil && date != "0000-00-00 00:00:00"
      Time.parse date
    else
      false
    end
  end
end