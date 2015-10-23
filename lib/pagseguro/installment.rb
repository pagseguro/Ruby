module PagSeguro
  class Installment
    include Extensions::MassAssignment

    # Set the credit card brand.
    attr_accessor :card_brand

    # Set the installments quantity.
    attr_accessor :quantity

    # Set the amount.
    # Must fit the patern: \\d+.\\d{2} (e.g. "12.00")
    attr_accessor :amount

    # Set total amount.
    attr_accessor :total_amount

    # Set interest free.
    attr_accessor :interest_free

    # Find installment options by a given amount
    # Optional. Credit card brand
    # Return a PagSeguro::Installment::Collection instance
    def self.find(amount, card_brand = nil)
      request = Request.get("installments", api_version, params(amount: amount, card_brand: card_brand))
      collection = Collection.new
      Response.new(request, collection).serialize

      collection
    end

    private
    def self.params(options)
      RequestSerializer.new(options).to_params
    end

    def self.api_version
      'v2'
    end
  end
end
