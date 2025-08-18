# Configuración de Google Sign-In para Coliseum

Este documento te guiará a través de la configuración de Google Sign-In para tu aplicación Flutter.

## 🚀 Pasos para Configurar Google Sign-In

### 1. Crear Proyecto en Google Cloud Console

1. Ve a [Google Cloud Console](https://console.cloud.google.com/)
2. Crea un nuevo proyecto o selecciona uno existente
3. Habilita la API de Google Sign-In:
   - Ve a "APIs & Services" > "Library"
   - Busca "Google Sign-In API" y habilítala

### 2. Configurar OAuth 2.0

1. Ve a "APIs & Services" > "Credentials"
2. Haz clic en "Create Credentials" > "OAuth 2.0 Client IDs"
3. Selecciona "Android" como tipo de aplicación
4. Completa la información:
   - **Package name**: `com.example.coliseum` (debe coincidir con tu `build.gradle.kts`)
   - **SHA-1 certificate fingerprint**: Obtén esto de tu keystore de desarrollo

### 3. Obtener SHA-1 Fingerprint

#### Para desarrollo (debug):
```bash
cd android
./gradlew signingReport
```

#### Para producción (release):
```bash
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
```

### 4. Configurar Firebase (Opcional pero Recomendado)

1. Ve a [Firebase Console](https://console.firebase.google.com/)
2. Crea un nuevo proyecto o selecciona uno existente
3. Agrega tu aplicación Android:
   - Package name: `com.example.coliseum`
   - Descarga el archivo `google-services.json`
   - Colócalo en `android/app/`

### 5. Actualizar Configuración en el Código

1. Abre `lib/constants/google_config.dart`
2. Reemplaza las claves de ejemplo con tus claves reales:

```dart
class GoogleConfig {
  static const String androidClientId = 'TU_CLIENT_ID_REAL.apps.googleusercontent.com';
  static const String iosClientId = 'TU_IOS_CLIENT_ID.apps.googleusercontent.com';
  static const String webClientId = 'TU_WEB_CLIENT_ID.apps.googleusercontent.com';
  
  // ... resto de la configuración
}
```

### 6. Configurar Android Manifest

Asegúrate de que tu `android/app/src/main/AndroidManifest.xml` tenga los permisos necesarios:

```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
```

### 7. Configurar build.gradle

Verifica que tu `android/app/build.gradle.kts` tenga:

```kotlin
plugins {
    id("com.google.gms.google-services") // Si usas Firebase
}

dependencies {
    implementation("com.google.android.gms:play-services-auth:20.7.0")
}
```

## 🔑 Obtener Claves OAuth 2.0

### Android Client ID
- Formato: `123456789-abcdefghijklmnop.apps.googleusercontent.com`
- Se encuentra en Google Cloud Console > Credentials > OAuth 2.0 Client IDs

### iOS Client ID (si desarrollas para iOS)
- Formato: `123456789-abcdefghijklmnop.apps.googleusercontent.com`
- Se crea de manera similar al Android

### Web Client ID
- Formato: `123456789-abcdefghijklmnop.apps.googleusercontent.com`
- Se crea seleccionando "Web application" como tipo

## 🧪 Probar la Configuración

1. Ejecuta `flutter clean`
2. Ejecuta `flutter pub get`
3. Ejecuta la aplicación en tu emulador/dispositivo
4. Intenta iniciar sesión con Google

## ❌ Solución de Problemas Comunes

### Error: "Google Sign-In is not properly configured"
- Verifica que hayas actualizado `google_config.dart` con tus claves reales
- Asegúrate de que las claves no contengan espacios extra

### Error: "Network error"
- Verifica tu conexión a internet
- Asegúrate de que el emulador tenga acceso a internet

### Error: "Sign in failed"
- Verifica que el SHA-1 fingerprint coincida
- Asegúrate de que el package name sea correcto

### Error: "Developer error"
- Verifica que hayas habilitado la API de Google Sign-In
- Asegúrate de que las credenciales OAuth 2.0 estén configuradas correctamente

## 🔒 Seguridad

- **NUNCA** subas tus claves OAuth 2.0 a repositorios públicos
- Usa variables de entorno o archivos de configuración locales
- Considera usar Firebase App Check para mayor seguridad

## 📱 Funcionalidades Disponibles

Con esta configuración, tu aplicación podrá:

- ✅ Iniciar sesión con cuentas de Google
- ✅ Obtener información básica del perfil (nombre, email, foto)
- ✅ Acceder a información adicional (cumpleaños, género, teléfono)
- ✅ Mantener la sesión activa
- ✅ Cerrar sesión de manera segura

## 🎯 Próximos Pasos

Una vez configurado Google Sign-In, puedes:

1. **Integrar con Firebase Auth** para sincronización de usuarios
2. **Implementar persistencia local** para mantener la sesión
3. **Agregar más proveedores** (Facebook, Apple, etc.)
4. **Implementar refresh tokens** para sesiones largas
5. **Agregar validación de tokens** en el servidor

## 📚 Recursos Adicionales

- [Google Sign-In para Flutter](https://pub.dev/packages/google_sign_in)
- [Google Cloud Console](https://console.cloud.google.com/)
- [Firebase Console](https://console.firebase.google.com/)
- [Flutter Authentication](https://docs.flutter.dev/development/data-and-backend/state-mgmt/simple#authentication)
