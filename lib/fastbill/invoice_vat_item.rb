class InvoiceVatItem
  attr_accessor :vat_percent, :vat_value
  
  def initialize(body)
    @vat_percent = body["VAT_PERCENT"]
    @vat_value = body["VAT_VALUE"]
    self
  end
  def to_xml
    
  end
end