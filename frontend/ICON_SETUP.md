# Configuración del Icono de la App - DesignAlma

## 📱 Pasos para configurar el icono personalizado "DA":

### 1. Guardar el icono:
- Guarda la imagen del icono "DA" que me enviaste como `app_icon.png` en la carpeta `assets/`
- La imagen debe ser de al menos 1024x1024 pixels para mejor calidad
- Reemplaza el archivo placeholder que creé

### 2. Instalar dependencias:
```bash
flutter pub get
```

### 3. Generar los iconos:
```bash
flutter pub run flutter_launcher_icons:main
```

### 4. Verificar la configuración:
El archivo `pubspec.yaml` ya está configurado con:
- ✅ Paquete `flutter_launcher_icons` agregado
- ✅ Configuración para Android, iOS, Web y Windows
- ✅ Ruta del icono: `assets/app_icon.png`

### 5. Compilar la APK:
```bash
flutter build apk --release
```

## 🎯 Resultado:
- El icono "DA" se verá en el celular cuando instales la APK
- También funcionará para iOS, Web y Windows
- El icono tendrá el diseño azul degradado que me enviaste

## 📁 Archivos modificados:
- `pubspec.yaml` - Configuración del launcher icon
- `assets/app_icon.png` - Archivo del icono (debes reemplazarlo)

## 🔧 Troubleshooting:
Si hay problemas, asegúrate de que:
1. La imagen `app_icon.png` esté en la carpeta `assets/`
2. La imagen sea cuadrada (1024x1024 recomendado)
3. Ejecutes `flutter clean` y luego `flutter pub get` si hay errores