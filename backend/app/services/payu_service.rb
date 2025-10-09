require "net/http"
require "uri"
require "json"

class PayuService
  # Credenciales de sandbox para transacciones APROBADAS
  API_LOGIN = "pRRXKOl8ikMmt9u"
  API_KEY = "4Vj8eK4rloUd272L48hsrarnUA"
  MERCHANT_ID = "508029"
  ACCOUNT_ID = "512321"
  ENDPOINT = "https://sandbox.api.payulatam.com/payments-api/4.0/service.cgi"

  def self.create_payment(order, user, card_info)
    expiration_parts = card_info[:expiration].split("/")
    expiration_year = expiration_parts[0]
    expiration_month = expiration_parts[1]

    # Detectar automáticamente el tipo de tarjeta
    payment_method = detect_card_type(card_info[:number])

    payload = {
      language: "es",
      command: "SUBMIT_TRANSACTION",
      merchant: {
        apiLogin: API_LOGIN,
        apiKey: API_KEY,
      },
      transaction: {
        order: {
          accountId: ACCOUNT_ID,
          referenceCode: order.id.to_s,
          description: "Compra Design Alma",
          language: "es",
          signature: Digest::MD5.hexdigest("#{API_KEY}~#{MERCHANT_ID}~#{order.id}~#{order.total.to_i}~COP"),
          buyer: {
            fullName: user.name || user.email,
            emailAddress: user.email,
          },
          additionalValues: {
            TX_VALUE: {
              value: order.total.to_f,
              currency: "COP",
            },
          },
        },
        payer: {
          fullName: card_info[:name],
          emailAddress: user.email,
        },
        creditCard: {
          number: card_info[:number].delete(" "),
          securityCode: card_info[:cvv],
          expirationDate: "#{expiration_year}/#{expiration_month}",
          name: card_info[:name],
        },
        extraParameters: {
          INSTALLMENTS_NUMBER: 1,
        },
        type: "AUTHORIZATION_AND_CAPTURE",
        paymentMethod: payment_method,
        paymentCountry: "CO",
        deviceSessionId: "session123456",
        ipAddress: "127.0.0.1",
        userAgent: "RailsApp",
      },
      test: true, # Sandbox mode
    }

    uri = URI.parse(ENDPOINT)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri.request_uri, {
      "Content-Type" => "application/json",
    })
    request.body = payload.to_json

    response = http.request(request)

    # Parseamos XML si la respuesta viene como texto XML
    xml = Nokogiri::XML(response.body)

    {
      code: xml.at("code")&.text,
      transaction_state: xml.at("transactionResponse > state")&.text,
      transaction_id: xml.at("transactionResponse > transactionId")&.text,
      order_id: xml.at("transactionResponse > orderId")&.text,
      response_code: xml.at("transactionResponse > responseCode")&.text,
      message: xml.at("transactionResponse > responseMessage")&.text,
    }
  end

  # Detecta automáticamente el tipo de tarjeta basado en el número
  def self.detect_card_type(card_number)
    clean_number = card_number.delete(" ")

    case clean_number
    when /^4/
      "VISA"
    when /^5[1-5]/, /^2[2-7]/
      "MASTERCARD"
    when /^3[47]/
      "AMEX"
    when /^30/, /^36/, /^38/
      "DINERS"
    else
      "VISA" # Default fallback
    end
  end

  # Números de tarjeta de prueba para sandbox que SIEMPRE aprueban
  def self.test_cards
    {
      visa_approved: "4037997623271984",
      mastercard_approved: "5303710409428926",
      amex_approved: "377813000000001",
      diners_approved: "36032605786674",
    }
  end
end
