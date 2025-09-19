Devise.setup do |config|
  config.jwt do |jwt|
    jwt.secret = Rails.application.credentials.devise_jwt_secret_key || Rails.application.secret_key_base
    jwt.dispatch_requests = [
      ['POST', %r{^/api/auth/sign_in$}],
      ['POST', %r{^/.*/api/auth/sign_in$}]
    ]
    jwt.revocation_requests = [
      ['DELETE', %r{^/api/auth/sign_out$}],
      ['DELETE', %r{^/.*/api/auth/sign_out$}]
    ]
    jwt.expiration_time = 1.day.to_i
  end
end
