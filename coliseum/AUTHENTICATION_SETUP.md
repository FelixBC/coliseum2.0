# Configuración de Autenticación - Coliseum 2.0

Este documento explica cómo configurar todas las funcionalidades de autenticación implementadas en Coliseum 2.0.

## 🚀 Funcionalidades Implementadas

### ✅ Completadas
1. **Login propio** - Autenticación con email y contraseña
2. **Login con Google** - Integración con Google Sign-In
3. **Registro de usuarios** - Formulario completo de registro
4. **Perfil de usuario** - Vista y edición de información personal
5. **Modo oscuro** - Toggle para cambiar entre tema claro y oscuro
6. **Selección de idioma** - Soporte para múltiples idiomas
7. **Recuperación de contraseña** - Sistema de reset de contraseña
8. **Autenticación biométrica** - Huella digital y Face ID
9. **Cambio de contraseña** - Actualización de contraseña desde perfil
10. **Configuración de app** - Página completa de configuraciones

## 📱 Configuración Requerida

### 1. Dependencias Instaladas

Las siguientes dependencias ya están incluidas en `pubspec.yaml`:

```yaml
# Authentication & Social Login
google_sign_in: ^6.2.1
flutter_facebook_auth: ^6.1.1

# Biometric Authentication
local_auth: ^2.2.0
local_auth_android: ^1.1.8
local_auth_ios: ^1.1.8

# Theme & Localization
flutter_localizations:
  sdk: flutter

# Email & Password Reset
mailer: ^6.1.0

# Settings & Preferences
shared_preferences: ^2.2.3
```

### 2. Configuración de Google Sign-In

#### Para Android:
1. Ve a [Google Cloud Console](https://console.cloud.google.com/)
2. Crea un nuevo proyecto o selecciona uno existente
3. Habilita la API de Google Sign-In
4. Crea credenciales OAuth 2.0
5. Descarga el archivo `google-services.json`
6. Reemplaza el archivo en `android/app/google-services.json`

#### Para iOS:
1. En Google Cloud Console, agrega una configuración para iOS
2. Descarga el archivo `GoogleService-Info.plist`
3. Agrégalo a tu proyecto iOS en Xcode

### 3. Configuración de Firebase (Opcional)

Para funcionalidades avanzadas como recuperación de contraseña real:

1. Crea un proyecto en [Firebase Console](https://console.firebase.google.com/)
2. Habilita Authentication
3. Configura los proveedores de autenticación (Email/Password, Google)
4. Descarga los archivos de configuración

### 4. Configuración de Biometría

#### Android:
Los permisos ya están configurados en `android/app/src/main/AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.USE_BIOMETRIC" />
<uses-permission android:name="android.permission.USE_FINGERPRINT" />
```

#### iOS:
La configuración ya está en `ios/Runner/Info.plist`:
```xml
<key>NSFaceIDUsageDescription</key>
<string>Esta app usa Face ID para autenticación biométrica</string>
```

## 🛠️ Uso de las Funcionalidades

### Login Principal
- **Ubicación**: `lib/views/auth/login_page.dart`
- **Características**:
  - Validación de email y contraseña
  - Login con Google
  - Autenticación biométrica
  - Recuperación de contraseña
  - Manejo de errores

### Registro
- **Ubicación**: `lib/views/auth/register_page.dart`
- **Características**:
  - Validación completa de formulario
  - Verificación de contraseñas
  - Validación de dominios de email permitidos

### Perfil de Usuario
- **Ubicación**: `lib/views/profile/profile_page.dart`
- **Edición**: `lib/views/profile/edit_profile_page.dart`
- **Características**:
  - Vista de información personal
  - Edición de datos
  - Cambio de foto de perfil
  - Cambio de contraseña

### Configuración
- **Ubicación**: `lib/views/settings/settings_page.dart`
- **Características**:
  - Toggle de modo oscuro
  - Selección de idioma
  - Configuración de biometría
  - Información de la app
  - Cerrar sesión

## 🔧 Servicios Implementados

### AuthService
- **Ubicación**: `lib/services/auth_service.dart`
- **Funcionalidad**: Interfaz para autenticación

### MockAuthService
- **Ubicación**: `lib/services/mock_auth_service.dart`
- **Funcionalidad**: Implementación mock para desarrollo

### GoogleAuthService
- **Ubicación**: `lib/services/google_auth_service.dart`
- **Funcionalidad**: Integración con Google Sign-In

### BiometricService
- **Ubicación**: `lib/services/biometric_service.dart`
- **Funcionalidad**: Autenticación biométrica

### SettingsService
- **Ubicación**: `lib/services/settings_service.dart`
- **Funcionalidad**: Gestión de configuraciones

## 📊 ViewModels

### AuthViewModel
- **Ubicación**: `lib/viewmodels/auth_view_model.dart`
- **Funcionalidades**:
  - Login/Logout
  - Registro
  - Google Sign-In
  - Autenticación biométrica
  - Recuperación de contraseña
  - Actualización de perfil
  - Cambio de contraseña

## 🎨 Temas y Localización

### Modo Oscuro
- Implementado en `SettingsService`
- Cambio dinámico de tema
- Persistencia de preferencias

### Idiomas Soportados
- Español (default)
- Inglés
- Francés
- Portugués

## 🔐 Seguridad

### Validaciones Implementadas
- Email con dominios permitidos
- Contraseñas con requisitos mínimos
- Validación de formularios
- Manejo de errores

### Almacenamiento Seguro
- Uso de `SharedPreferences` para configuraciones
- `flutter_secure_storage` para datos sensibles

## 🚀 Próximos Pasos

### Para Producción:
1. **Configurar Firebase** para autenticación real
2. **Implementar backend** para gestión de usuarios
3. **Configurar Google Sign-In** con credenciales reales
4. **Implementar Facebook Auth** si es necesario
5. **Configurar email real** para recuperación de contraseña

### Mejoras Sugeridas:
1. **Autenticación con GitHub** (ya preparada la estructura)
2. **Verificación de email** en registro
3. **Autenticación de dos factores**
4. **Sesiones múltiples**
5. **Logs de seguridad**

## 📝 Notas Importantes

- **Desarrollo**: La app usa servicios mock para desarrollo
- **Producción**: Reemplazar servicios mock con implementaciones reales
- **Testing**: Todas las funcionalidades están listas para testing
- **UI/UX**: Interfaz moderna y responsive implementada

## 🆘 Solución de Problemas

### Error de Google Sign-In:
1. Verificar configuración de `google-services.json`
2. Confirmar que la API está habilitada
3. Verificar credenciales OAuth

### Error de Biometría:
1. Verificar permisos en AndroidManifest.xml
2. Confirmar que el dispositivo soporta biometría
3. Verificar configuración en Info.plist (iOS)

### Error de Tema:
1. Verificar que `SettingsService` está en el provider
2. Confirmar que el tema se actualiza correctamente

---

**¡Coliseum 2.0 está listo para usar todas las funcionalidades de autenticación!** 🎉 