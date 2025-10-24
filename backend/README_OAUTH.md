# Configuración de Google OAuth

## Setup inicial (para cada desarrollador)

1. Copia el archivo de ejemplo:
   ```bash
   cp .env.example .env
   ```

2. Ve a [Google Cloud Console](https://console.cloud.google.com/apis/credentials)

3. Crea un nuevo OAuth 2.0 Client ID (o usa las credenciales compartidas del equipo)

4. Configura las URIs autorizadas:
   - **Authorized JavaScript origins**: `http://localhost:3000`
   - **Authorized redirect URIs**: `http://localhost:3000/users/auth/google_oauth2/callback`

5. Copia el Client ID y Client Secret en tu archivo `.env`:
   ```
   GOOGLE_CLIENT_ID=tu-id-aqui.apps.googleusercontent.com
   GOOGLE_CLIENT_SECRET=tu-secret-aqui
   ```

6. Reinicia Docker:
   ```bash
   docker-compose down
   docker-compose up --build
   ```

## Compartir credenciales en el equipo

**Opción A (Segura)**: Cada desarrollador crea sus propias credenciales en Google Cloud  
**Opción B (Compartida)**: Un líder del equipo crea las credenciales y las comparte de forma segura (Slack privado, 1Password, etc.) - **NUNCA las subas a GitHub**

## Troubleshooting

- Si ves `CSRF detected`: Verifica que las URIs de callback coincidan exactamente
- Si no carga el `.env`: Asegúrate de que `docker-compose.yml` tenga `env_file: - .env`
