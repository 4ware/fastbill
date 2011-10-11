class Invoice
  include HTTParty
  base_uri 'https://portal.fastbill.com'

  attr_accessor :id, :invoice_type, :customer_id, :customer_costcenter_id, :currency_code, :template_id, :intro_text, :invoice_number, :payed_date, :is_canceled, :invoice_date, :due_date, :delivery_date, :sub_total, :vat_total, :total, :vat_items, :invoice_items, :is_new

  def initialize(auth = nil)
    @auth = auth
    @is_new = true
  end
  
  def get(id = nil, customer_id = nil, month = nil, year = nil)
    if id
      #fetch invoice
      options = {
        :basic_auth => @auth,
        :headers => {
          "Content-Type" => "application/xml"
        },
        :body => '<?xml version="1.0" encoding="utf-8"?><FBAPI><SERVICE>invoice.get</SERVICE><FILTER><INVOICE_ID>' + id.to_s + '</INVOICE_ID></FILTER></FBAPI>'
      }
      r = self.class.post('/api/0.1/api.php', options)
      body = Crack::XML.parse r.body
      if !body['FBAPI']["RESPONSE"]["INVOICES"].nil?
        hydrate(body['FBAPI']["RESPONSE"]["INVOICES"]["INVOICE"])
        self
      else
        false
      end
    else
      #search invoices
    end
  end
  def save
    
  end
  def delete!
    
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
    @vat_items = []
    @total = body["TOTAL"]
    for vat_item in body["VAT_ITEMS"].each
      @vat_items.push InvoiceVatItem.new vat_item.last
    end
    @invoice_items = []
    for item in body["ITEMS"].each
      i =  InvoiceItem.new(@auth)
      i.hydrate(item.last)
      @invoice_items.push i
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
    
  end
  def complete
    
  end
  def sign!
    
  end
  def send_by_email
    
  end
  def send_by_ground_mail
    
  end
  def set_paid
    
  end
  def items
    
  end
end