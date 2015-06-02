require_relative "boot"

payment = PagSeguro::CreditCardTransactionRequest.new
payment.notification_url = "http://www.meusite.com.br/notification"
payment.payment_mode = "gateway"

payment.items << {
  id: 1234,
  description: %[Televisão 19" Sony],
  amount: 459.50,
  weight: 0
}

payment.reference = "REF1234-credit-card"
payment.sender = {
  hash: "f8d95a0747cdddf277a111ec1bab1d68628e095243b7a56382ec01f260216313",
  name: "Joao Comprador",
  email: "joao@sandbox.pagseguro.com.br",
  cpf: "75073461100",
  phone: {
    area_code: 11,
    number: "12345678"
  }
}

payment.shipping = {
  type_name: "sedex",
  address: {
    street: "Av. Brig. Faria Lima",
    number: "1384",
    complement: "5º andar",
    city: "São Paulo",
    state: "SP",
    district: "Jardim Paulistano",
    postal_code: "01452002"
  }
}

payment.billing_address = {
  street: "Av. Brig. Faria Lima",
  number: "1384",
  complement: "5º andar",
  city: "São Paulo",
  state: "SP",
  district: "Jardim Paulistano",
  postal_code: "01452002"
}

payment.credit_card_token = "41c1f784216748ccae689fcd854aaca1"
payment.holder = {
  name: "João Comprador",
  birth_date: "07/05/1981",
  document: {
    type: "CPF",
    value: "00000000191"
  },
  phone: {
    area_code: 11,
    number: "123456789"
  }
}

payment.installment = {
  value: 459.50,
  quantity: 1
}

# Add extras params to request
# payment.extra_params << { paramName: 'paramValue' }
# payment.extra_params << { senderBirthDate: '07/05/1981' }

puts "=> REQUEST"
puts PagSeguro::TransactionRequest::Serializer.new(payment).to_params
puts

transaction = payment.create

if transaction.errors.any?
  puts "=> ERRORS"
  puts transaction.errors.join("\n")
else
  puts "=> Transaction"
  puts "  code: #{transaction.code}"
  puts "  reference: #{transaction.reference}"
  puts "  type: #{transaction.type_id}"
  puts "  payment link: #{transaction.payment_link}"
  puts "  status: #{transaction.status}"
  puts "  payment method type: #{transaction.payment_method.type}"
  puts "  created at: #{transaction.created_at}"
  puts "  updated at: #{transaction.updated_at}"
  puts "  gross amount: #{transaction.gross_amount.to_f}"
  puts "  discount amount: #{transaction.discount_amount.to_f}"
  puts "  net amount: #{transaction.net_amount.to_f}"
  puts "  extra amount: #{transaction.extra_amount.to_f}"
  puts "  installment count: #{transaction.installment_count}"

  puts "    => Items"
  puts "      items count: #{transaction.items.size}"
  transaction.items.each do |item|
    puts "      item id: #{item.id}"
    puts "      description: #{item.description}"
    puts "      quantity: #{item.quantity}"
    puts "      amount: #{item.amount.to_f}"
  end

  puts "    => Sender"
  puts "      name: #{transaction.sender.name}"
  puts "      email: #{transaction.sender.email}"
  puts "      phone: (#{transaction.sender.phone.area_code}) #{transaction.sender.phone.number}"
  puts "      document: #{transaction.sender.document.type}: #{transaction.sender.document.value}"

  puts "    => Shipping"
  puts "      street: #{transaction.shipping.address.street}, #{transaction.shipping.address.number}"
  puts "      complement: #{transaction.shipping.address.complement}"
  puts "      postal code: #{transaction.shipping.address.postal_code}"
  puts "      district: #{transaction.shipping.address.district}"
  puts "      city: #{transaction.shipping.address.city}"
  puts "      state: #{transaction.shipping.address.state}"
  puts "      country: #{transaction.shipping.address.country}"
  puts "      type: #{transaction.shipping.type_name}"
  puts "      cost: #{transaction.shipping.cost}"
end
