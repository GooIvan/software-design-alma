Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins '*'  # O solo 'http://localhost:5000' para Flutter Web
    resource '*',
      headers: :any,
      methods: [:get, :post, :patch, :put, :delete, :options, :head]
  end
end
# Configuración de CORS para permitir solicitudes desde cualquier origen.
# Puedes restringir los orígenes a tu aplicación Flutter Web si es necesario.