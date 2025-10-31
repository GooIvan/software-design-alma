Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2,
    ENV["GOOGLE_CLIENT_ID"],
    ENV["GOOGLE_CLIENT_SECRET"],
    {
      scope: "email, profile",
      prompt: "select_account",
      image_aspect_ratio: "square",
      image_size: 50,
    }

  provider :facebook,
    ENV["FACEBOOK_APP_ID"],
    ENV["FACEBOOK_APP_SECRET"],
    {
      scope: "public_profile",
      info_fields: "name",
      image_size: "square",
      callback_url: "#{ENV['APP_URL']}/users/auth/facebook/callback",
    }
end

# Configuración de seguridad CSRF para OmniAuth
OmniAuth.config.allowed_request_methods = [:post, :get]
