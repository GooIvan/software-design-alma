# Configuración de Google OAuth

## ✅ Setup automático (ya está listo!)

Este proyecto viene con credenciales de Google OAuth configuradas por defecto para desarrollo local.

**No necesitas hacer nada extra** - solo haz `docker-compose up` y funciona.

## 🔧 Para desarrollo local

Las credenciales están en:
- `config/initializers/omniauth.rb` (valores por defecto en el código)
- `docker-compose.yml` (variables de entorno con valores por defecto)

Si quieres usar tus propias credenciales de Google:

1. Ve a [Google Cloud Console](https://console.cloud.google.com/apis/credentials)
2. Crea un nuevo OAuth 2.0 Client ID
3. Configura las URIs autorizadas:
   - **Authorized JavaScript origins**: `http://localhost:3000`
   - **Authorized redirect URIs**: `http://localhost:3000/users/auth/google_oauth2/callback`
4. Sobrescribe las variables de entorno:
   ```bash
   export GOOGLE_CLIENT_ID=tu-id-aqui
   export GOOGLE_CLIENT_SECRET=tu-secret-aqui
   docker-compose up
   ```

## 🚀 Para producción

**IMPORTANTE**: En producción, DEBES sobrescribir estas variables con credenciales seguras:

```bash
# Heroku
heroku config:set GOOGLE_CLIENT_ID=xxx
heroku config:set GOOGLE_CLIENT_SECRET=xxx

# Render / Railway / Docker
# Configura las variables de entorno en el panel de administración
```

## Troubleshooting

- Si ves `CSRF detected`: Verifica que las URIs de callback coincidan exactamente
- Si no carga el `.env`: Asegúrate de que `docker-compose.yml` tenga `env_file: - .env`
