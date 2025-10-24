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

    # Generar referenceCode único usando timestamp para evitar duplicados
    reference_code = "ORDER-#{order.id}-#{Time.now.to_i}"
    
    Rails.logger.info "[PAYU] Procesando pago - Order: #{order.id}, Total: #{order.total}, Card: ****#{card_info[:number][-4..]}"
    Rails.logger.info "[PAYU] Expiration recibida: #{card_info[:expiration]} -> Año: #{expiration_year}, Mes: #{expiration_month}"
    Rails.logger.info "[PAYU] Reference Code: #{reference_code}"

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
          referenceCode: reference_code,
          description: "Compra Design Alma",
          language: "es",
          signature: Digest::MD5.hexdigest("#{API_KEY}~#{MERCHANT_ID}~#{reference_code}~#{order.total.to_i}~COP"),
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
      "Accept" => "application/json",
    })
    request.body = payload.to_json

    Rails.logger.info "[PAYU] Enviando request a PayU..."
    Rails.logger.debug "[PAYU] Payload: #{payload.to_json}"

    response = http.request(request)

    Rails.logger.info "[PAYU] Respuesta recibida - Status: #{response.code}"
    Rails.logger.info "[PAYU] Body: #{response.body}"

    # PayU devuelve JSON, no XML
    begin
      parsed = JSON.parse(response.body)
      
      result = {
        code: parsed["code"],
        transaction_state: parsed.dig("transactionResponse", "state"),
        transaction_id: parsed.dig("transactionResponse", "transactionId"),
        order_id: parsed.dig("transactionResponse", "orderId"),
        response_code: parsed.dig("transactionResponse", "responseCode"),
        message: parsed.dig("transactionResponse", "responseMessage") || parsed["error"],
      }

      Rails.logger.info "[PAYU] Resultado parseado: #{result.inspect}"
      result
    rescue JSON::ParserError => e
      Rails.logger.error "[PAYU] Error al parsear respuesta JSON: #{e.message}"
      {
        code: "ERROR",
        transaction_state: "ERROR",
        message: "Error al procesar respuesta de PayU: #{e.message}",
      }
    end
  end
end