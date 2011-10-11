class InvoiceItem
  include HTTParty
  base_uri 'https://portal.fastbill.com'

  attr_accessor :id, :description, :quantity, :unit_price, :vat_percent, :vat_value, :complete_net, :complete_gross, :currency_code, :sort_order
  
  def initialize(auth = nil)
    @auth = auth
  end
  def get(invoice_id)
    
  end
  def delete!
    
  end
  def hydrate(body)
    @id = body["INVOICE_ITEM_ID"]
    @article_number = body["ARTICLE_NUMBER"]
    @description = body["DESCRIPTION"]
    @quantity = body["QUANTITY"]
    @unit_price = body["UNIT_PRICE"]
    @vat_percent = body["VAT_PERCENT"]
    @vat_value = body["VAT_VALUE"]
    @complete_net = body["COMPLETE_NET"]
    @complete_gross = body["COMPLETE_GROSS"]
    @sort_order = body["SORT_ORDER"]
  end
  def to_xml
    xml = "<ITEM>"
    unless @id.nil
      xml = xml + "<INVOICE_ITEM_ID>#{@id}</INVOICE_ITEM_ID>"
    end
    xml = xml + "</ITEM>"
  end
end