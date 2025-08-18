import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalizationService extends ChangeNotifier {
  static const String _languageKey = 'language';
  
  String _currentLanguage = 'es';
  
  String get currentLanguage => _currentLanguage;
  
  // Supported languages
  static const List<String> supportedLanguages = ['en', 'es'];
  
  LocalizationService() {
    _loadLanguage();
  }
  
  Future<void> _loadLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final languageCode = prefs.getString(_languageKey) ?? 'es';
      _currentLanguage = languageCode;
      notifyListeners();
    } catch (e) {
      _currentLanguage = 'es';
    }
  }
  
  Future<void> setLanguage(String languageCode) async {
    if (languageCode != _currentLanguage && supportedLanguages.contains(languageCode)) {
      _currentLanguage = languageCode;
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_languageKey, languageCode);
      } catch (e) {
        // Ignore storage errors
      }
      notifyListeners();
    }
  }
  
  String getLanguageName(String languageCode) {
    switch (languageCode) {
      case 'en':
        return 'English';
      case 'es':
        return 'Español';
      default:
        return 'English';
    }
  }
  
  String getCurrentLanguageName() {
    return getLanguageName(_currentLanguage);
  }
  
  // Hardcoded translations
  String get(String key) {
    switch (_currentLanguage) {
      case 'en':
        return _englishTranslations[key] ?? key;
      case 'es':
        return _spanishTranslations[key] ?? key;
      default:
        return _englishTranslations[key] ?? key;
    }
  }
  
  // English translations
  static const Map<String, String> _englishTranslations = {
    // Navigation
    'home': 'Home',
    'explore': 'Explore',
    'messages': 'Messages',
    'profile': 'Profile',
    'saved': 'Saved',
    
    // Authentication
    'login': 'Log In',
    'register': 'Register',
    'email': 'Email',
    'password': 'Password',
    'confirmPassword': 'Confirm Password',
    'username': 'Username',
    'forgotPassword': 'Forgot Password?',
    'continueWithGoogle': 'Continue with Google',
    'useBiometric': 'Use Biometric Authentication',
    'biometricPrompt': 'Please authenticate using your fingerprint or face ID to continue.',
    'authenticate': 'Authenticate',
    'cancel': 'Cancel',
    'dontHaveAccount': "Don't have an account?",
    'alreadyHaveAccount': 'Already have an account?',
    'signUp': 'Sign Up',
    'signIn': 'Sign In',
    'recoverPassword': 'Recover Password',
    'enterEmailForRecoveryLink': 'Enter your email to receive a recovery link',
    'recoveryLinkSent': 'A recovery link has been sent to your email',
    
    // Profile
    'editProfile': 'Edit Profile',
    'followers': 'Followers',
    'following': 'Following',
    'posts': 'Posts',
    'bio': 'Bio',
    'website': 'Website',
    'location': 'Location',
    'birthDate': 'Birth Date',
    'gender': 'Gender',
    'phoneNumber': 'Phone Number',
    
    // Security
    'security': 'Security',
    'biometricAuthentication': 'Biometric Authentication',
    'enabled': 'Enabled',
    'disabled': 'Disabled',
    'useFingerprint': 'Use Fingerprint',
    'useFaceId': 'Use Face ID',
    'biometricLogin': 'Biometric Login',
    'authenticateWithBiometrics': 'Please authenticate using your fingerprint to continue.',
    
    // Settings
    'settings': 'Settings',
    'language': 'Language',
    'notifications': 'Notifications',
    'privacy': 'Privacy',
    'about': 'About',
    'logout': 'Log Out',
    'darkMode': 'Dark Mode',
    'lightMode': 'Light Mode',
    'public': 'Public',
    'private': 'Private',
    'archive': 'Archive',
    'qrCode': 'QR Code',
    
    // Common
    'loading': 'Loading...',
    'error': 'Error',
    'success': 'Success',
    'retry': 'Retry',
    'close': 'Close',
    'back': 'Back',
    'next': 'Next',
    'previous': 'Previous',
    'search': 'Search',
    'filter': 'Filter',
    'sort': 'Sort',
    
    // Messages
    'newMessage': 'New Message',
    'typeMessage': 'Type a message...',
    'send': 'Send',
    'online': 'Online',
    'offline': 'Offline',
    'lastSeen': 'Last seen',
    
    // Explore
    'searchProperties': 'Search Properties',
    'filters': 'Filters',
    'priceRange': 'Price Range',
    'propertyType': 'Property Type',
    'bedrooms': 'Bedrooms',
    'bathrooms': 'Bathrooms',
    'apply': 'Apply',
    'clear': 'Clear',
    
    // Create Post
    'createPost': 'Create Post',
    'addPhoto': 'Add Photo',
    'writeCaption': 'Write a caption...',
    'addLocation': 'Add Location',
    'addPrice': 'Add Price',
    'post': 'Post',
    
    // Comments
    'comments': 'Comments',
    'addComment': 'Add a comment...',
    'reply': 'Reply',
    'like': 'Like',
    'unlike': 'Unlike',
    'share': 'Share',
    
    // Booking
    'bookNow': 'Book Now',
    'contactOwner': 'Contact Owner',
    'scheduleVisit': 'Schedule Visit',
    'availableDates': 'Available Dates',
    'selectDate': 'Select Date',
    'confirmBooking': 'Confirm Booking',
    
    // Errors
    'invalidEmail': 'Invalid email',
    'passwordTooShort': 'Password must be at least 6 characters',
    'passwordsDontMatch': 'Passwords do not match',
    'fieldRequired': 'This field is required',
    'networkError': 'Network error. Please try again.',
    'unknownError': 'An unknown error occurred',
    
    // Additional keys
    'account': 'Account',
    'version': 'Version',
    'noUserDataAvailable': 'No user data available',
    'or': 'Or',
  };
  
  // Spanish translations
  static const Map<String, String> _spanishTranslations = {
    // Navigation
    'home': 'Inicio',
    'explore': 'Explorar',
    'messages': 'Mensajes',
    'profile': 'Perfil',
    'saved': 'Guardado',
    
    // Authentication
    'login': 'Iniciar Sesión',
    'register': 'Registrarse',
    'email': 'Correo Electrónico',
    'password': 'Contraseña',
    'confirmPassword': 'Confirmar Contraseña',
    'username': 'Nombre de Usuario',
    'forgotPassword': '¿Olvidaste tu contraseña?',
    'continueWithGoogle': 'Continuar con Google',
    'useBiometric': 'Usar Huella Digital',
    'biometricPrompt': 'Por favor, autentícate usando tu huella digital o cara ID para continuar.',
    'authenticate': 'Autenticar',
    'cancel': 'Cancelar',
    'dontHaveAccount': '¿No tienes una cuenta?',
    'alreadyHaveAccount': '¿Ya tienes una cuenta?',
    'signUp': 'Registrarse',
    'signIn': 'Iniciar Sesión',
    'recoverPassword': 'Recuperar Contraseña',
    'enterEmailForRecoveryLink': 'Ingresa tu email para recibir un enlace de recuperación',
    'recoveryLinkSent': 'Se ha enviado un enlace de recuperación a tu email',
    
    // Profile
    'editProfile': 'Editar Perfil',
    'followers': 'Seguidores',
    'following': 'Siguiendo',
    'posts': 'Publicaciones',
    'bio': 'Biografía',
    'firstName': 'Nombre',
    'lastName': 'Apellido',
    'phoneNumber': 'Número de Teléfono',
    'dateOfBirth': 'Fecha de Nacimiento',
    'saveChanges': 'Guardar Cambios',
    
    // Security
    'security': 'Seguridad',
    'biometricAuthentication': 'Autenticación Biométrica',
    'enabled': 'Activado',
    'disabled': 'Desactivado',
    'useFingerprint': 'Usar Huella Digital',
    'useFaceId': 'Usar Cara ID',
    'biometricLogin': 'Iniciar Sesión Biométrico',
    'authenticateWithBiometrics': 'Por favor, autentícate usando tu huella digital para continuar.',
    
    // Settings
    'settings': 'Configuración',
    'language': 'Idioma',
    'notifications': 'Notificaciones',
    'privacy': 'Privacidad',
    'about': 'Acerca de',
    'logout': 'Cerrar Sesión',
    'darkMode': 'Modo Oscuro',
    'lightMode': 'Modo Claro',
    'public': 'Público',
    'private': 'Privado',
    'archive': 'Archivo',
    'qrCode': 'Código QR',
    
    // Common
    'loading': 'Cargando...',
    'error': 'Error',
    'success': 'Éxito',
    'retry': 'Reintentar',
    'close': 'Cerrar',
    'back': 'Atrás',
    'next': 'Siguiente',
    'previous': 'Anterior',
    'search': 'Buscar',
    'filter': 'Filtrar',
    'sort': 'Ordenar',
    
    // Messages
    'newMessage': 'Nuevo Mensaje',
    'typeMessage': 'Escribe un mensaje...',
    'send': 'Enviar',
    'online': 'En línea',
    'offline': 'Desconectado',
    'lastSeen': 'Visto por última vez',
    
    // Explore
    'searchProperties': 'Buscar Propiedades',
    'filters': 'Filtros',
    'priceRange': 'Rango de Precio',
    'propertyType': 'Tipo de Propiedad',
    'bedrooms': 'Habitaciones',
    'bathrooms': 'Baños',
    'apply': 'Aplicar',
    'clear': 'Limpiar',
    
    // Create Post
    'createPost': 'Crear Publicación',
    'addPhoto': 'Agregar Foto',
    'writeCaption': 'Escribe una descripción...',
    'addLocation': 'Agregar Ubicación',
    'addPrice': 'Agregar Precio',
    'post': 'Publicar',
    
    // Comments
    'comments': 'Comentarios',
    'addComment': 'Agregar un comentario...',
    'reply': 'Responder',
    'like': 'Me gusta',
    'unlike': 'No me gusta',
    'share': 'Compartir',
    
    // Booking
    'bookNow': 'Reservar Ahora',
    'contactOwner': 'Contactar Propietario',
    'scheduleVisit': 'Programar Visita',
    'availableDates': 'Fechas Disponibles',
    'selectDate': 'Seleccionar Fecha',
    'confirmBooking': 'Confirmar Reserva',
    
    // Errors
    'invalidEmail': 'Correo electrónico inválido',
    'passwordTooShort': 'La contraseña debe tener al menos 6 caracteres',
    'passwordsDontMatch': 'Las contraseñas no coinciden',
    'fieldRequired': 'Este campo es requerido',
    'networkError': 'Error de red. Por favor intenta de nuevo.',
    'unknownError': 'Ocurrió un error desconocido',
    
    // Additional keys
    'account': 'Cuenta',
    'version': 'Versión',
    'noUserDataAvailable': 'No hay datos de usuario disponibles',
    'or': 'O',
  };
} 