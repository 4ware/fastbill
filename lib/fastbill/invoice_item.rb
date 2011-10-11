class InvoiceItem
  include HTTParty
  base_uri 'https://portal.fastbill.com'

  attr_accessor :id, :description, :quantity, :unit_price, :vat_percent, :vat_value, :complete_net, :complete_gross, :currency_code, :sort_order
  
  def initialize(auth = nil)
    @auth = auth
  end
  def delete!
    options = {
      :basic_auth => @auth,
      :headers => {
        "Content-Type" => "application/xml"
      },
      :body => '<?xml version="1.0" encoding="utf-8"?><FBAPI><SERVICE>item.delete</SERVICE><DATA><INVOICE_ITEM_ID>' + @id + '</INVOICE_ITEM_ID></DATA></FBAPI>'
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
    unless @id.nil?
      xml = xml + "<INVOICE_ITEM_ID>#{@id}</INVOICE_ITEM_ID>"
    end
    unless @article_number.nil?
      xml = xml + "<ARTICLE_NUMBER>#{@article_number}</ARTICLE_NUMBER>"
    end
    unless @description.nil?
      xml = xml + "<DESCRIPTION>#{@description}</DESCRIPTION>"
    end
    unless @quantity.nil?
      xml = xml + "<QUANTITY>#{@quantity}</QUANTITY>"
    end
    unless @unit_price.nil?
      xml = xml + "<UNIT_PRICE>#{@unit_price}</UNIT_PRICE>"
    end
    unless @vat_percent.nil?
      xml = xml + "<VAT_PERCENT>#{@vat_percent}</VAT_PERCENT>"
    end
    unless @vat_value.nil?
      xml = xml + "<VAT_VALUE>#{@vat_value}</VAT_VALUE>"
    end
    unless @complete_net.nil?
      xml = xml + "<COMPLETE_NET>#{@complete_net}</COMPLETE_NET>"
    end
    unless @complete_gross.nil?
      xml = xml + "<COMPLETE_GROSS>#{@complete_gross}</COMPLETE_GROSS>"
    end
    unless @sort_order.nil?
      xml = xml + "<SORT_ORDER>#{@sort_order}</SORT_ORDER>"
    end
    xml = xml + "</ITEM>"
  end
end