Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2,
    ENV.fetch("GOOGLE_CLIENT_ID", "354443077313-0fno50ulf9pt68kvb44hsu5fq3t8pnt1.apps.googleusercontent.com"),
    ENV.fetch("GOOGLE_CLIENT_SECRET", "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"),
    {
      scope: "email, profile",
      prompt: "select_account",
      image_aspect_ratio: "square",
      image_size: 50,
    }
end

# Configuración de seguridad CSRF para OmniAuth
OmniAuth.config.allowed_request_methods = [:post, :get]
