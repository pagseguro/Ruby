require "spec_helper"

describe PagSeguro::PaymentRequest::RequestSerializer do
  let(:payment_request) { PagSeguro::PaymentRequest.new }
  let(:params) { serializer.to_params }
  subject(:serializer) { described_class.new(payment_request) }

  context "global configuration serialization" do
    before do
      PagSeguro.configuration.receiver_email = "RECEIVER"
    end

    it { expect(params).to include(receiverEmail: PagSeguro.configuration.receiver_email) }
  end

  context "generic attributes serialization" do
    let(:payment_request) do
      double(:PaymentRequest,
        currency: "BRL",
        reference: "REF123",
        extra_amount: 1234.50,
        redirect_url: "REDIRECT_URL",
        notification_url: "NOTIFICATION_URL",
        abandon_url: "ABANDON_URL",
        max_uses: 5,
        max_age: 3600,
      ).as_null_object
    end

    it { expect(params).to include(currency: "BRL") }
    it { expect(params).to include(reference: "REF123") }
    it { expect(params).to include(extraAmount: "1234.50") }
    it { expect(params).to include(redirectURL: "REDIRECT_URL") }
    it { expect(params).to include(notificationURL: "NOTIFICATION_URL") }
    it { expect(params).to include(abandonURL: "ABANDON_URL") }
    it { expect(params).to include(maxUses: 5) }
    it { expect(params).to include(maxAge: 3600) }
  end

  context "shipping serialization" do
    before do
      payment_request.shipping = PagSeguro::Shipping.new({
        type_id: 1,
        cost: 1234.56
      })
    end

    it { expect(params).to include(shippingType: 1) }
    it { expect(params).to include(shippingCost: "1234.56") }
  end

  context "receiver serialization" do
    before do
      payment_request.receivers = [
        {
          email: 'a@example.com',
          split: {
            amount: 10,
            fee_percent: 11,
            rate_percent: 12
          }
        }
      ]
    end

    it { expect(params).to include('receiver[1].email' => 'a@example.com') }
    it { expect(params).to include('receiver[1].split.amount' => 10) }
    it { expect(params).to include('receiver[1].split.feePercent' => 11) }
    it { expect(params).to include('receiver[1].split.ratePercent' => 12) }
  end

  context "address serialization" do
    let(:address) do
      PagSeguro::Address.new(
        street: "STREET",
        state: "STATE",
        city: "CITY",
        postal_code: "POSTAL_CODE",
        district: "DISTRICT",
        number: "NUMBER",
        complement: "COMPLEMENT"
      )
    end
    let(:payment_request) do
      double(:PaymentRequest, shipping: shipping).as_null_object
    end
    let(:shipping) do
      double(:Shipping, address: address).as_null_object
    end

    it { expect(params).to include(shippingAddressStreet: "STREET") }
    it { expect(params).to include(shippingAddressCountry: "BRA") }
    it { expect(params).to include(shippingAddressState: "STATE") }
    it { expect(params).to include(shippingAddressCity: "CITY") }
    it { expect(params).to include(shippingAddressPostalCode: "POSTAL_CODE") }
    it { expect(params).to include(shippingAddressDistrict: "DISTRICT") }
    it { expect(params).to include(shippingAddressNumber: "NUMBER") }
    it { expect(params).to include(shippingAddressComplement: "COMPLEMENT") }
  end

  context "sender serialization" do
    before do
      sender = PagSeguro::Sender.new({
        email: "EMAIL",
        name: "NAME",
        cpf: "CPF"
      })

      allow(payment_request).to receive(:sender).and_return(sender)
    end

    it { expect(params).to include(senderEmail: "EMAIL") }
    it { expect(params).to include(senderName: "NAME") }
    it { expect(params).to include(senderCPF: "CPF") }
  end

  context "phone serialization" do
    before do
      sender = PagSeguro::Sender.new({
        phone: {
          area_code: "AREA_CODE",
          number: "NUMBER"
        }
      })

      allow(payment_request).to receive(:sender).and_return(sender)
    end

    it { expect(params).to include(senderAreaCode: "AREA_CODE") }
    it { expect(params).to include(senderPhone: "NUMBER") }
  end

  context "items serialization" do
    def build_item(index)
      PagSeguro::Item.new({
        id: "ID#{index}",
        description: "DESC#{index}",
        quantity: "QTY#{index}",
        amount: index * 100 + 0.12,
        weight: "WEIGHT#{index}",
        shipping_cost: index * 100 + 0.34
      })
    end

    shared_examples_for "item serialization" do |index|
      it { expect(params).to include("itemId#{index}" => "ID#{index}") }
      it { expect(params).to include("itemDescription#{index}" => "DESC#{index}") }
      it { expect(params).to include("itemAmount#{index}" => "#{index}00.12") }
      it { expect(params).to include("itemShippingCost#{index}" => "#{index}00.34") }
      it { expect(params).to include("itemQuantity#{index}" => "QTY#{index}") }
      it { expect(params).to include("itemWeight#{index}" => "WEIGHT#{index}") }
    end

    before do
      payment_request.items << build_item(1)
      payment_request.items << build_item(2)
    end

    it_behaves_like "item serialization", 1
    it_behaves_like "item serialization", 2
  end

  context "credentials serialization" do
    before do
      credentials = PagSeguro::ApplicationCredentials.new(
        "app123", "qwerty", "authocode"
      )

      payment_request.stub(credentials: credentials)
    end
  end

  context "extra params serialization" do
    let(:payment_request) do
      double(:PaymentRequest,
        extra_params: [
          { extraParam: 'param_value' },
          { newExtraParam: 'extra_param_value' }
        ]).as_null_object
    end

    it { expect(params).to include(extraParam: 'param_value') }
    it { expect(params).to include(newExtraParam: 'extra_param_value') }
  end
end
