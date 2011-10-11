class InvoiceVatItem
  attr_accessor :vat_percent, :vat_value
  
  def initialize(body)
    @vat_percent = body["VAT_PERCENT"]
    @vat_value = body["VAT_VALUE"]
    self
  end
  def to_xml
    xml = "<VAT_ITEM>"
    unless @vat_percent.nil?
      xml = "<VAT_PERCENT>#{@vat_percent}</VAT_PERCENT>"
    end
    unless @vat_value.nil?
      xml = "<VAT_VALUE>#{@vat_value}</VAT_VALUE>"
    end
    xml + "</VAT_ITEM>"
  end
end