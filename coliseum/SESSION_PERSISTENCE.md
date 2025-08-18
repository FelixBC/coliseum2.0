# Persistencia Local de Sesiones en Coliseum

Este documento explica cómo funciona el sistema de persistencia local de sesiones implementado en la aplicación.

## 🎯 Características Principales

### ✅ Persistencia Automática
- **Almacenamiento local**: Los datos del usuario se guardan automáticamente en el dispositivo
- **Restauración automática**: La sesión se restaura automáticamente al abrir la app
- **Sincronización**: Los datos se mantienen sincronizados entre servicios

### ✅ Gestión Inteligente de Sesiones
- **Timeout configurable**: Las sesiones expiran después de 30 días por defecto
- **Renovación automática**: Las sesiones se renuevan automáticamente cada 24 horas
- **Monitoreo de actividad**: El sistema detecta la actividad del usuario y extiende la sesión

### ✅ Seguridad y Privacidad
- **Datos encriptados**: Los datos sensibles se almacenan de forma segura
- **Limpieza automática**: Los datos expirados se eliminan automáticamente
- **Control de acceso**: Solo la aplicación puede acceder a los datos almacenados

## 🏗️ Arquitectura del Sistema

### 1. StorageService
Maneja el almacenamiento local usando SharedPreferences:

```dart
// Guardar usuario
await StorageService.saveUser(user);

// Obtener usuario
final user = await StorageService.getUser();

// Verificar autenticación
final isAuth = await StorageService.isAuthenticated();
```

### 2. SessionService
Gestiona el ciclo de vida de las sesiones:

```dart
// Crear sesión
await sessionService.createSession(user);

// Extender sesión
await sessionService.extendSession();

// Verificar validez
final isValid = sessionService.validateSession();
```

### 3. AuthService
Integra todos los servicios de autenticación:

```dart
// Iniciar sesión con Google
final user = await authService.signInWithGoogle();

// Verificar estado de sesión
final isSessionValid = authService.isSessionValid;

// Obtener información de sesión
final sessionInfo = authService.getSessionInfo();
```

## 📱 Uso en la Interfaz

### Widget de Información de Sesión
Muestra el estado actual de la sesión:

```dart
SessionInfoWidget(
  showExtendedInfo: true,
  onExtendSession: () {
    // Manejar extensión de sesión
  },
  onRefreshSession: () {
    // Manejar refresco de sesión
  },
)
```

### Widget Compacto de Sesión
Indicador compacto para AppBars:

```dart
CompactSessionInfoWidget(
  onTap: () {
    // Navegar a configuración o mostrar detalles
  },
)
```

## 🔧 Configuración

### Timeouts de Sesión
Los timeouts se pueden configurar en `SessionService`:

```dart
class SessionService {
  static const Duration _sessionTimeout = Duration(days: 30);
  static const Duration _refreshThreshold = Duration(hours: 24);
}
```

### Almacenamiento de Datos
Los datos se almacenan con las siguientes claves:

- `user_data`: Información del usuario
- `auth_token`: Token de autenticación
- `last_login`: Último inicio de sesión
- `is_authenticated`: Estado de autenticación
- `auth_provider`: Proveedor de autenticación

## 📊 Monitoreo y Debugging

### Información de Sesión
Obtener información detallada de la sesión:

```dart
final sessionInfo = authService.getSessionInfo();
print(sessionInfo);
// Output:
// {
//   'isValid': true,
//   'userEmail': 'user@example.com',
//   'authProvider': 'google',
//   'lastActivity': '2024-01-15T10:30:00.000Z',
//   'sessionExpiry': '2024-02-14T10:30:00.000Z',
//   'timeUntilExpiry': 2592000,
//   'sessionDuration': 3600
// }
```

### Estadísticas de Almacenamiento
Obtener estadísticas del almacenamiento local:

```dart
final storageStats = await authService.getStorageStats();
print(storageStats);
// Output:
// {
//   'total_keys': 5,
//   'user_data_exists': true,
//   'auth_token_exists': true,
//   'is_authenticated': true,
//   'auth_provider': 'google',
//   'last_login': '2024-01-15T10:30:00.000Z',
//   'settings_count': 3,
//   'theme': 'dark',
//   'language': 'en'
// }
```

## 🚀 Funcionalidades Avanzadas

### Rastreo de Actividad del Usuario
Usar mixins para rastrear la actividad:

```dart
class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> with PageActivityMixin {
  @override
  void onPageInteraction() {
    super.onPageInteraction();
    // La sesión se actualiza automáticamente
  }
}
```

### Renovación Manual de Sesión
Renovar la sesión manualmente:

```dart
// Extender sesión
await authService.extendSession();

// Refrescar sesión
await authService.refreshSession();

// Actualizar actividad
authService.updateActivity();
```

## 🔒 Seguridad

### Validación de Datos
El sistema valida automáticamente:

- **Integridad de datos**: Verifica que los datos almacenados sean válidos
- **Expiración**: Elimina datos expirados automáticamente
- **Formato**: Valida el formato de los datos antes de usarlos

### Limpieza Automática
- Los datos se limpian automáticamente al cerrar sesión
- Las sesiones expiradas se eliminan automáticamente
- Los datos corruptos se descartan y se solicita nueva autenticación

## 🧪 Testing

### Verificar Persistencia
```dart
// Verificar que el usuario persiste
final hasData = await authService.hasValidLocalData();
assert(hasData == true);

// Verificar estado de sesión
final isSessionValid = authService.isSessionValid;
assert(isSessionValid == true);
```

### Simular Expiración de Sesión
```dart
// Forzar expiración (solo para testing)
await Future.delayed(Duration(days: 31));
final isValid = authService.validateSession();
assert(isValid == false);
```

## 📝 Mejores Prácticas

### 1. Manejo de Errores
```dart
try {
  await authService.signInWithGoogle();
} catch (e) {
  // Manejar errores de autenticación
  print('Error de autenticación: $e');
}
```

### 2. Verificación de Estado
```dart
// Verificar estado antes de operaciones
if (authService.isAuthenticated && authService.isSessionValid) {
  // Realizar operaciones que requieren autenticación
} else {
  // Redirigir a login
}
```

### 3. Actualización de Actividad
```dart
// Actualizar actividad en interacciones importantes
void onImportantAction() {
  authService.updateActivity();
  // Realizar acción
}
```

## 🐛 Solución de Problemas

### Sesión No Se Restaura
1. Verificar que `StorageService.initialize()` se llame
2. Verificar permisos de almacenamiento
3. Verificar que los datos no estén corruptos

### Sesión Expira Prematuramente
1. Verificar configuración de timeouts
2. Verificar que `updateActivity()` se llame
3. Verificar logs de renovación automática

### Datos No Se Persisten
1. Verificar que `StorageService.saveUser()` retorne `true`
2. Verificar espacio disponible en el dispositivo
3. Verificar permisos de escritura

## 🔮 Futuras Mejoras

- **Sincronización en la nube**: Sincronizar datos entre dispositivos
- **Encriptación avanzada**: Usar encriptación AES para datos sensibles
- **Backup automático**: Hacer backup de datos importantes
- **Sincronización offline**: Manejar cambios offline y sincronizar cuando haya conexión
- **Múltiples cuentas**: Soporte para múltiples cuentas de usuario

## 📚 Recursos Adicionales

- [SharedPreferences Documentation](https://pub.dev/packages/shared_preferences)
- [Flutter State Management](https://docs.flutter.dev/development/data-and-backend/state-mgmt/simple)
- [Flutter Security Best Practices](https://docs.flutter.dev/deployment/security)
- [Google Sign-In Flutter](https://pub.dev/packages/google_sign_in)
