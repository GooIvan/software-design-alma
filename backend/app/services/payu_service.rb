require "net/http"
require "uri"
require "json"

class PayuService
  API_LOGIN = "pRRXKOl8ikMmt9u" # Sandbox public credentials
  API_KEY = "4Vj8eK4rloUd272L48hsrarnUA"
  MERCHANT_ID = "508029"
  ACCOUNT_ID = "512321"
  ENDPOINT = "https://sandbox.api.payulatam.com/payments-api/4.0/service.cgi"

  def self.create_payment(order, user, card_info)
    expiration_parts = card_info[:expiration].split("/")
    expiration_year = expiration_parts[0]
    expiration_month = expiration_parts[1]

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
        paymentMethod: "VISA", # Cambia a "MASTERCARD" u otro según el número
        paymentCountry: "CO",
        deviceSessionId: "session123456",
        ipAddress: "127.0.0.1",
        userAgent: "RailsApp",
      },
      test: true,
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
end
