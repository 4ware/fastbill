class Invoice
  include HTTParty
  base_uri 'https://portal.fastbill.com'

  attr_accessor :id, :invoice_type, :customer_id, :customer_costcenter_id, :currency_code, :template_id, :intro_text, :invoice_number, :payed_date, :is_canceled, :invoice_date, :due_date, :delivery_date, :sub_total, :vat_total, :total, :vat_items, :invoice_items, :is_new, :eu_delivery

  def initialize(auth = nil)
    @auth = auth
    @is_new = true
  end
  def get(id = nil, customer_id = nil, year = nil, month = nil)
    invoices = []
    body = '<?xml version="1.0" encoding="utf-8"?><FBAPI><SERVICE>invoice.get</SERVICE><FILTER>'
    if id
      body = body + '<INVOICE_ID>' + id.to_s + '</INVOICE_ID>'
    elsif customer_id
      body = body + '<CUSTOMER_ID>' + customer_id.to_s + '</CUSTOMER_ID>'
    elsif year
      body = body + '<YEAR>' + year.to_s + '</YEAR>'
    elsif month
      body = body + '<MONTH>' + month.to_s + '</MONTH>'
    end
    body = body + '</FILTER></FBAPI>'
    options = {
      :basic_auth => @auth,
      :headers => {
        "Content-Type" => "application/xml"
      },
      :body => body
    }
    r = self.class.post('/api/0.1/api.php', options)
    body = Crack::XML.parse r.body
    if body['FBAPI']["RESPONSE"]["INVOICES"]["INVOICE"].class.to_s == 'Hash'
      inv = Invoice.new(@auth)
      inv.hydrate(body['FBAPI']["RESPONSE"]["INVOICES"]["INVOICE"])
      invoices.push inv
    else
      for invoice in body['FBAPI']["RESPONSE"]["INVOICES"]["INVOICE"].each
        inv = Invoice.new(@auth)
        inv.hydrate(invoice)
        invoices.push inv
      end
    end
    invoices
  end
  def hydrate(body)
    @is_new = false
    @id = body["INVOICE_ID"]
    @invoice_type = body["INVOICE_TYPE"]
    @customer_id = body["CUSTOMER_ID"]
    @customer_costcenter_id = body["CUSTOMER_COSTCENTER_ID"]
    @currency_code = body["CURRENCY_CODE"]
    @template_id = body["TEMPLATE_ID"]
    @invoice_number = body["INVOICE_NUMBER"]
    @introtext = body["INTROTEXT"]
    @payed_date = parse_date body["PAYED_DATE"]
    @is_canceled = body["IS_CANCELED"] == "1" ? true : false
    @invoice_date = parse_date body["INVOICE_DATE"]
    @due_date = parse_date body["INVOICE_DATE"]
    @delivery_date = parse_date body["DELIVERY_DATE"]
    @sub_total = body["SUB_TOTAL"]
    @vat_total = body["VAT_TOTAL"]
    @eu_delivery = body["EU_DELIVERY"] == "1" ? true : false
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
  def to_xml
    xml = "<INVOICE>"
    unless @id.nil?
      xml = xml + "<INVOICE_ID>#{@id}</INVOICE_ID>"
    end
    unless @invoice_type.nil?
      xml = xml + "<INVOICE_TYPE>#{@invoice_type}</INVOICE_TYPE>"
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
    unless @eu_delivery.nil?
      eu = @eu_delivery ? 1 : 0
      xml = xml + "<EU_DELIVERY>#{eu}</EU_DELIVERY>"
    end
    if @payed_date
      xml = xml + "<PAYED_DATE>#{@payed_date.strftime("%Y-%m-%d")}</PAYED_DATE>"
    end
    unless @is_canceled.nil?
      c = @is_canceled ? 1 : 0
      xml = xml + "<IS_CANCELED>#{c}</IS_CANCELED>"
    end
    if @invoice_date
      xml = xml + "<IVOICE_DATE>#{@invoice_date.strftime("%Y-%m-%d")}</INVOICE_DATE>"
    end
    if @due_date
      xml = xml + "<DUE_DATE>#{@due_date.strftime("%Y-%m-%d")}</DUE_DATE>"
    end
    if @delivery_date
      xml = xml + "<DELIVERY_DATE>#{@delivery_date.strftime("%Y-%m-%d")}</DELIVERY_DATE>"
    end
    if @payed_date
      xml = xml + "<PAYED_DATE>#{@payed_date.strftime("%Y-%m-%d")}</PAYED_DATE>"
    end
    unless @sub_total.nil?
      xml = xml + "<SUB_TOTAL>#{@sub_total}</SUB_TOTAL>"
    end
    unless @vat_total.nil?
      xml = xml + "<VAT_TOTAL>#{@vat_total}</VAT_TOTAL>"
    end
    unless @total.nil?
      xml = xml + "<TOTAL>#{@total}</TOTAL>"
    end
    unless @vat_items.length == 0
      xml = xml + "<VAT_ITEMS>"
      for vat_item in @vat_items.each
        xml = xml + vat_item.to_xml
      end
      xml = xml + "</VAT_ITEMS>"
    end
    unless @invoice_items.length == 0
      xml = xml + "<ITEMS>"
      for item in @invoice_items.each
        xml = xml + item.to_xml
      end
      xml = xml + "</ITEMS>"
    end
    xml + "</INVOICE>"
  end
  def complete
    options = {
      :basic_auth => @auth,
      :headers => {
        "Content-Type" => "application/xml"
      },
      :body => '<?xml version="1.0" encoding="utf-8"?><FBAPI><SERVICE>invoice.complete</SERVICE><DATA><INVOICE_ID>' + @id + '</INVOICE_ID></DATA></FBAPI>'
    }
    r = self.class.post('/api/0.1/api.php', options)
    body = Crack::XML.parse r.body
    if !body['FBAPI']["RESPONSE"]["STATUS"].nil? && body['FBAPI']["RESPONSE"]["STATUS"] == "success"
      true
    else
      false
    end
  end
  def sign!
    options = {
      :basic_auth => @auth,
      :headers => {
        "Content-Type" => "application/xml"
      },
      :body => '<?xml version="1.0" encoding="utf-8"?><FBAPI><SERVICE>invoice.sign</SERVICE><DATA><INVOICE_ID>' + @id + '</INVOICE_ID></DATA></FBAPI>'
    }
    r = self.class.post('/api/0.1/api.php', options)
    body = Crack::XML.parse r.body
    if !body['FBAPI']["RESPONSE"]["STATUS"].nil? && body['FBAPI']["RESPONSE"]["STATUS"] == "success"
      true
    else
      false
    end    
  end
  def send_by_email(from = nil, to = nil, cc = nil, subject = nil, message = nil, confirmation = false)
    unless to.nil? && cc.nil?
      xml = "<INVOICE_ID>#{@id}</INVOICE_ID>"
      xml = xml + "<RECIPIENT>"
      unless to.nil?
        xml = xml + "<TO>#{to}</TO>"
      end
      unless cc.nil?
        xml = xml + "<CC>#{cc}</CC>"
      end
      xml = xml + "</RECIPIENT>"
      unless subject.nil?
        xml = xml + "<SUBJECT>#{subject}</SUBJECT>"
      end
      unless message.nil?
        xml = xml + "<MESSAGE>#{message}</MESSAGE>"
      end
      c = confirmation ? 1 : 0
      xml = xml + "<CONFIRMATION>#{c}</CONFIRMATION>"
      options = {
        :basic_auth => @auth,
        :headers => {
          "Content-Type" => "application/xml"
        },
        :body => '<?xml version="1.0" encoding="utf-8"?><FBAPI><SERVICE>invoice.sendbyemail</SERVICE><DATA><INVOICE_ID>' + @id + '</INVOICE_ID></DATA>'+ xml +'</FBAPI>'
      }
      r = self.class.post('/api/0.1/api.php', options)
      body = Crack::XML.parse r.body
      if !body['FBAPI']["RESPONSE"]["STATUS"].nil? && body['FBAPI']["RESPONSE"]["STATUS"] == "success"
        true
      else
        false
      end
    end
  end
  def send_by_ground_mail
    options = {
      :basic_auth => @auth,
      :headers => {
        "Content-Type" => "application/xml"
      },
      :body => '<?xml version="1.0" encoding="utf-8"?><FBAPI><SERVICE>invoice.sendbypost</SERVICE><DATA><INVOICE_ID>' + @id + '</INVOICE_ID></DATA></FBAPI>'
    }
    r = self.class.post('/api/0.1/api.php', options)
    body = Crack::XML.parse r.body
    if !body['FBAPI']["RESPONSE"]["STATUS"].nil? && body['FBAPI']["RESPONSE"]["STATUS"] == "success"
      true
    else
      false
    end
  end
  def set_paid!
    options = {
      :basic_auth => @auth,
      :headers => {
        "Content-Type" => "application/xml"
      },
      :body => '<?xml version="1.0" encoding="utf-8"?><FBAPI><SERVICE>invoice.setpaid</SERVICE><DATA><INVOICE_ID>' + @id + '</INVOICE_ID></DATA></FBAPI>'
    }
    r = self.class.post('/api/0.1/api.php', options)
    body = Crack::XML.parse r.body
    if !body['FBAPI']["RESPONSE"]["STATUS"].nil? && body['FBAPI']["RESPONSE"]["STATUS"] == "success"
      true
    else
      false
    end
  end
  def safe!
    if @is_new
      #create
      options = {
        :basic_auth => @auth,
        :headers => {
          "Content-Type" => "application/xml"
        },
        :body => '<?xml version="1.0" encoding="utf-8"?><FBAPI><SERVICE>invoice.create</SERVICE><DATA>' + self.to_xml + '</DATA></FBAPI>'
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
        :body => '<?xml version="1.0" encoding="utf-8"?><FBAPI><SERVICE>invoice.update</SERVICE><DATA>' + self.to_xml + '</DATA></FBAPI>'
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
      :body => '<?xml version="1.0" encoding="utf-8"?><FBAPI><SERVICE>invoice.delete</SERVICE><DATA><INVOICE_ID>' + @id + '</INVOICE_ID></DATA></FBAPI>'
    }
    r = self.class.post('/api/0.1/api.php', options)
    body = Crack::XML.parse r.body
    if !body['FBAPI']["RESPONSE"]["STATUS"].nil? && body['FBAPI']["RESPONSE"]["STATUS"] == "success"
      true
    else
      false
    end    
  end
end