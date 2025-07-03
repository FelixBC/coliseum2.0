# Coliseum - Product Requirements Document (PRD)

## 1. Resumen Ejecutivo

**Coliseum** es una aplicación móvil social que conecta personas a través de propiedades compartidas en su área geográfica. Inspirada visualmente en Instagram y Airbnb, la app permite a los usuarios descubrir, compartir y conectar con propiedades y personas cercanas, creando una experiencia social basada en ubicación.

### Objetivo Principal
Crear una plataforma visual y social donde los usuarios puedan:
- Publicar y descubrir propiedades (casas, apartamentos, espacios únicos)
- Conectar con personas de su área geográfica
- Explorar contenido basado en proximidad y intereses
- Crear una comunidad local centrada en propiedades y espacios

### Características Clave
- **Visual**: Interfaz tipo Instagram con feed de imágenes y stories
- **Social**: Sistema de seguimiento, likes, comentarios y mensajes
- **Geolocalizada**: Descubrimiento basado en ubicación y proximidad
- **Moderna**: Tema oscuro, diseño juvenil, arquitectura MVVM

---

## 2. Público Objetivo

### Primario
- **Edad**: 18-35 años
- **Perfil**: Jóvenes profesionales, estudiantes, nómadas digitales
- **Comportamiento**: Activos en redes sociales, valoran experiencias auténticas
- **Necesidades**: Buscan conectar con su comunidad local, descubrir espacios únicos

### Secundario
- **Edad**: 25-45 años
- **Perfil**: Propietarios que quieren compartir sus espacios
- **Comportamiento**: Interesados en generar ingresos pasivos o conexiones sociales
- **Necesidades**: Monetizar o compartir sus propiedades de forma segura

---

## 3. Arquitectura Técnica

### Framework y Arquitectura
- **Framework**: Flutter (multiplataforma)
- **Arquitectura**: MVVM (Model-View-ViewModel)
- **Estado**: Provider/Riverpod para gestión de estado
- **Diseño**: Material Design 3 con tema oscuro personalizado

### Organización del Código
```
lib/
├── models/          # Entidades de datos
├── services/        # Servicios y APIs simuladas
├── viewmodels/      # Lógica de negocio
├── views/           # Pantallas organizadas por módulos
├── widgets/         # Componentes reutilizables
└── constants/       # Constantes y configuración
```

### Enfoque de Desarrollo
- **Solo Frontend**: Sin integración de backend (datos simulados)
- **Datos Locales**: SharedPreferences y archivos JSON
- **Estado**: Gestión local con Provider/Riverpod
- **Navegación**: Named routes con parámetros

---

## 4. Módulos Funcionales

### Fase 1: Autenticación (AUTH)
**Objetivo**: Onboarding y gestión de cuentas de usuario

### Fase 2: Feed Principal (FEED)
**Objetivo**: Descubrimiento de contenido y interacciones sociales

### Fase 3: Perfil de Usuario (PROFILE)
**Objetivo**: Gestión de perfil personal y visualización de otros usuarios

### Fase 4: Publicación de Contenido (POST)
**Objetivo**: Creación y gestión de publicaciones de propiedades

### Fase 5: Búsqueda y Exploración (SEARCH)
**Objetivo**: Descubrimiento por filtros, ubicación y categorías

### Fase 6: Mensajería (MESSAGES)
**Objetivo**: Comunicación directa entre usuarios

### Fase 7: Configuración (SETTINGS)
**Objetivo**: Personalización y configuración de la app

---

## 5. Pantallas por Fase

### 🔐 FASE 1: AUTENTICACIÓN (4 pantallas)
**Prioridad**: Crítica | **Duración estimada**: 3-4 días

#### 1.1 Splash Screen
- **Archivo**: `lib/views/auth/splash_screen.dart`
- **Descripción**: Pantalla inicial con logo, animación de carga y verificación de sesión
- **Elementos**: Logo Coliseum, indicador de carga, transición automática
- **Navegación**: → Onboarding (nuevo) | Home (usuario existente)
- **Dependencias**: Ninguna
- **Prompt para Codex**: "Create a dark-themed splash screen with Coliseum logo, loading animation, and automatic navigation to onboarding or home based on user session"

#### 1.2 Onboarding
- **Archivo**: `lib/views/auth/onboarding_screen.dart`
- **Descripción**: Introducción con 3-4 slides explicando la app
- **Elementos**: PageView con slides, indicadores, botones Skip/Next
- **Navegación**: → Welcome
- **Dependencias**: Splash Screen
- **Prompt para Codex**: "Create an Instagram-style onboarding with 4 slides showing app features: property sharing, local discovery, social connections, and community building. Include page indicators and skip/next buttons"

#### 1.3 Welcome
- **Archivo**: `lib/views/auth/welcome_screen.dart`
- **Descripción**: Pantalla de bienvenida con opciones de registro/login
- **Elementos**: Logo, título, botones "Crear cuenta" y "Iniciar sesión"
- **Navegación**: → Register | Login
- **Dependencias**: Onboarding
- **Prompt para Codex**: "Create a welcome screen with Coliseum branding, hero text about connecting through properties, and two primary buttons for register/login with Instagram-inspired styling"

#### 1.4 Register/Login
- **Archivo**: `lib/views/auth/auth_screen.dart`
- **Descripción**: Formularios de registro e inicio de sesión con tabs
- **Elementos**: TabBar, formularios, validación, botones sociales
- **Navegación**: → Home (éxito) | Forgot Password
- **Dependencias**: Welcome
- **Prompt para Codex**: "Create a tabbed auth screen with register/login forms. Include email/password fields, social login buttons (Google, Apple), form validation, and smooth tab transitions. Use dark theme with blue accent colors"

---

### 🏠 FASE 2: FEED PRINCIPAL (5 pantallas)
**Prioridad**: Crítica | **Duración estimada**: 4-5 días

#### 2.1 Home Feed
- **Archivo**: `lib/views/feed/home_screen.dart`
- **Descripción**: Feed principal tipo Instagram con posts de propiedades
- **Elementos**: AppBar, Stories horizontales, ListView de posts, BottomNavBar
- **Navegación**: ↔ Todas las pantallas principales
- **Dependencias**: Auth completa
- **Prompt para Codex**: "Create an Instagram-style home feed with horizontal stories at top, vertical scrolling posts showing properties. Include like/comment/share buttons, user avatars, and location tags. Use dark theme with property images as main content"

#### 2.2 Post Detail
- **Archivo**: `lib/views/feed/post_detail_screen.dart`
- **Descripción**: Vista detallada de una publicación específica
- **Elementos**: Imagen expandida, detalles de propiedad, comentarios, acciones
- **Navegación**: ← Home | → Profile | Comments
- **Dependencias**: Home Feed
- **Prompt para Codex**: "Create a detailed post view with full-screen property images, swipeable gallery, property details (price, location, type), owner info, and expanded comments section. Include floating action buttons for interactions"

#### 2.3 Stories Viewer
- **Archivo**: `lib/views/feed/stories_viewer_screen.dart`
- **Descripción**: Visualizador de stories tipo Instagram
- **Elementos**: Fullscreen stories, progress indicators, tap to advance
- **Navegación**: ← Home | → Next story
- **Dependencias**: Home Feed
- **Prompt para Codex**: "Create an Instagram-style stories viewer with full-screen property photos/videos, progress bars, tap gestures for navigation, and user info overlay. Include story highlights for property features"

#### 2.4 Comments
- **Archivo**: `lib/views/feed/comments_screen.dart`
- **Descripción**: Lista de comentarios con opción de responder
- **Elementos**: Lista de comentarios, campo de entrada, replies anidadas
- **Navegación**: ← Post Detail | → User Profile
- **Dependencias**: Post Detail
- **Prompt para Codex**: "Create a comments screen with threaded replies, user avatars, timestamps, like buttons for comments, and a bottom input field with send button. Include nested replies and smooth animations"

#### 2.5 Notifications
- **Archivo**: `lib/views/feed/notifications_screen.dart`
- **Descripción**: Centro de notificaciones con diferentes tipos de alerts
- **Elementos**: Lista categorizada, badges, acciones rápidas
- **Navegación**: ← Home | → Post/Profile según notificación
- **Dependencias**: Home Feed
- **Prompt para Codex**: "Create a notifications center with categorized alerts: likes, comments, follows, nearby properties. Include user avatars, timestamps, and quick actions. Group by today/this week/earlier with different icons for each notification type"

---

### 👤 FASE 3: PERFIL DE USUARIO (5 pantallas)
**Prioridad**: Alta | **Duración estimada**: 4-5 días

#### 3.1 My Profile
- **Archivo**: `lib/views/profile/my_profile_screen.dart`
- **Descripción**: Perfil personal del usuario con estadísticas y posts
- **Elementos**: Header con stats, grid de posts propios, settings button
- **Navegación**: → Edit Profile | Settings | Own Posts
- **Dependencias**: Auth completa
- **Prompt para Codex**: "Create a personal profile screen with Instagram-style layout: large avatar, follower/following counts, bio section, and 3-column grid of user's property posts. Include edit profile and settings buttons"

#### 3.2 User Profile
- **Archivo**: `lib/views/profile/user_profile_screen.dart`
- **Descripción**: Perfil de otros usuarios
- **Elementos**: Header, botones Follow/Message, grid de posts
- **Navegación**: → Message | Posts | Followers list
- **Dependencias**: Feed interactions
- **Prompt para Codex**: "Create a user profile view with follow/unfollow button, message button, follower stats, bio, and property posts grid. Include follow status indicators and smooth button animations"

#### 3.3 Edit Profile
- **Archivo**: `lib/views/profile/edit_profile_screen.dart`
- **Descripción**: Edición de información personal
- **Elementos**: Formulario con foto, nombre, bio, ubicación
- **Navegación**: ← My Profile
- **Dependencias**: My Profile
- **Prompt para Codex**: "Create an edit profile form with avatar picker, text fields for name/username/bio/location, and save button. Include image selection from gallery/camera and form validation with dark theme styling"

#### 3.4 Followers/Following
- **Archivo**: `lib/views/profile/followers_screen.dart`
- **Descripción**: Lista de seguidores y seguidos
- **Elementos**: Tabs, lista de usuarios, botones Follow/Unfollow
- **Navegación**: ← Profile | → User Profile
- **Dependencias**: User Profile
- **Prompt para Codex**: "Create a followers/following screen with tabs, user list showing avatars, usernames, follow buttons, and search functionality. Include follower counts and smooth list animations"

#### 3.5 User Posts Grid
- **Archivo**: `lib/views/profile/user_posts_screen.dart`
- **Descripción**: Grid expandido de posts del usuario
- **Elementos**: Grid completo, filtros, ordenamiento
- **Navegación**: ← Profile | → Post Detail
- **Dependencias**: User Profile
- **Prompt para Codex**: "Create an expanded posts grid with filtering options (All, Properties, Highlights), sorting controls, and staggered grid layout. Include post counts and smooth grid animations with property images"

---

### 📝 FASE 4: PUBLICACIÓN DE CONTENIDO (4 pantallas)
**Prioridad**: Alta | **Duración estimada**: 3-4 días

#### 4.1 Create Post
- **Archivo**: `lib/views/post/create_post_screen.dart`
- **Descripción**: Formulario para crear nueva publicación
- **Elementos**: Image picker, formulario de detalles, ubicación
- **Navegación**: → Camera/Gallery | Location Picker
- **Dependencias**: Auth completa
- **Prompt para Codex**: "Create a property post creation form with multiple image picker, property details (title, description, price, type), location selector, and tags input. Include image preview carousel and form validation"

#### 4.2 Camera/Gallery
- **Archivo**: `lib/views/post/media_picker_screen.dart`
- **Descripción**: Selector de imágenes desde cámara o galería
- **Elementos**: Camera preview, gallery grid, multiple selection
- **Navegación**: ← Create Post
- **Dependencias**: Create Post
- **Prompt para Codex**: "Create a media picker with camera preview, gallery grid, multiple image selection, and basic editing tools (crop, filter). Include image counter and done/cancel buttons with smooth transitions"

#### 4.3 Location Picker
- **Archivo**: `lib/views/post/location_picker_screen.dart`
- **Descripción**: Mapa para seleccionar ubicación de la propiedad
- **Elementos**: Mapa interactivo, search bar, ubicaciones recientes
- **Navegación**: ← Create Post
- **Dependencias**: Create Post
- **Prompt para Codex**: "Create a location picker with interactive map, search bar for addresses, recent locations list, and current location button. Include map markers and address confirmation dialog"

#### 4.4 Post Preview
- **Archivo**: `lib/views/post/post_preview_screen.dart`
- **Descripción**: Vista previa antes de publicar
- **Elementos**: Preview del post, botones Edit/Publish
- **Navegación**: ← Create Post | → Home (published)
- **Dependencias**: Create Post
- **Prompt para Codex**: "Create a post preview screen showing how the property post will look in the feed, with edit/publish buttons, sharing options, and final confirmation dialog before posting"

---

### 🔍 FASE 5: BÚSQUEDA Y EXPLORACIÓN (4 pantallas)
**Prioridad**: Media | **Duración estimada**: 3-4 días

#### 5.1 Search
- **Archivo**: `lib/views/search/search_screen.dart`
- **Descripción**: Pantalla principal de búsqueda con tabs
- **Elementos**: Search bar, tabs (Properties, Users, Tags), results
- **Navegación**: → Search Results | User Profile | Post Detail
- **Dependencias**: Feed básico
- **Prompt para Codex**: "Create a search screen with tabs for Properties/Users/Tags, search bar with filters, trending searches, and recent searches. Include search suggestions and category chips"

#### 5.2 Search Results
- **Archivo**: `lib/views/search/search_results_screen.dart`
- **Descripción**: Resultados de búsqueda con filtros
- **Elementos**: Grid/List toggle, filtros, ordenamiento
- **Navegación**: ← Search | → Post Detail/Profile
- **Dependencias**: Search
- **Prompt para Codex**: "Create search results with grid/list view toggle, filter chips (price, location, property type), sort options, and property cards showing key details. Include map view toggle and result count"

#### 5.3 Map View
- **Archivo**: `lib/views/search/map_view_screen.dart`
- **Descripción**: Vista de mapa con propiedades cercanas
- **Elementos**: Mapa interactivo, markers, info cards
- **Navegación**: ← Search | → Post Detail
- **Dependencias**: Location services
- **Prompt para Codex**: "Create a map view showing nearby properties with custom markers, property info cards on tap, cluster markers for dense areas, and floating action buttons for filters and list view"

#### 5.4 Explore Categories
- **Archivo**: `lib/views/search/explore_screen.dart`
- **Descripción**: Exploración por categorías de propiedades
- **Elementos**: Grid de categorías, featured properties
- **Navegación**: → Category Results | Featured Posts
- **Dependencias**: Search básico
- **Prompt para Codex**: "Create an explore screen with property category grid (apartments, houses, unique spaces), featured properties carousel, trending locations, and curated collections with attractive imagery"

---

### 💬 FASE 6: MENSAJERÍA (4 pantallas)
**Prioridad**: Media | **Duración estimada**: 3-4 días

#### 6.1 Messages List
- **Archivo**: `lib/views/messages/messages_list_screen.dart`
- **Descripción**: Lista de conversaciones
- **Elementos**: Lista de chats, search, badges de no leídos
- **Navegación**: → Chat | → New Message
- **Dependencias**: User profiles
- **Prompt para Codex**: "Create a messages list with conversation previews, user avatars, last message, timestamps, unread badges, and search functionality. Include swipe actions for archive/delete"

#### 6.2 Chat
- **Archivo**: `lib/views/messages/chat_screen.dart`
- **Descripción**: Conversación individual
- **Elementos**: Mensajes, input field, typing indicators
- **Navegación**: ← Messages | → User Profile
- **Dependencias**: Messages List
- **Prompt para Codex**: "Create a chat interface with message bubbles, timestamps, message status indicators, typing indicators, and input field with attachment button. Include property sharing and location sharing"

#### 6.3 New Message
- **Archivo**: `lib/views/messages/new_message_screen.dart`
- **Descripción**: Iniciar nueva conversación
- **Elementos**: Search users, recent contacts, quick actions
- **Navegación**: ← Messages | → Chat
- **Dependencias**: User search
- **Prompt para Codex**: "Create a new message screen with user search, recent contacts list, suggested contacts based on interactions, and quick property sharing options"

#### 6.4 Message Settings
- **Archivo**: `lib/views/messages/message_settings_screen.dart`
- **Descripción**: Configuración de chat específico
- **Elementos**: Notificaciones, archivos compartidos, acciones
- **Navegación**: ← Chat
- **Dependencias**: Chat
- **Prompt para Codex**: "Create message settings with notification toggles, shared media gallery, user info, block/report options, and clear chat functionality with confirmation dialogs"

---

### ⚙️ FASE 7: CONFIGURACIÓN (4 pantallas)
**Prioridad**: Baja | **Duración estimada**: 2-3 días

#### 7.1 Settings
- **Archivo**: `lib/views/settings/settings_screen.dart`
- **Descripción**: Configuración principal de la app
- **Elementos**: Lista de opciones agrupadas, switches, navegación
- **Navegación**: → Account | Privacy | Notifications | About
- **Dependencias**: Profile básico
- **Prompt para Codex**: "Create a settings screen with grouped options: Account, Privacy & Security, Notifications, Display, Help & Support, About. Include user profile header and logout option"

#### 7.2 Account Settings
- **Archivo**: `lib/views/settings/account_settings_screen.dart`
- **Descripción**: Configuración de cuenta
- **Elementos**: Información personal, seguridad, vinculación
- **Navegación**: ← Settings | → Change Password
- **Dependencias**: Settings
- **Prompt para Codex**: "Create account settings with personal information editing, password change, linked accounts (social media), account deactivation, and data export options"

#### 7.3 Privacy Settings
- **Archivo**: `lib/views/settings/privacy_settings_screen.dart`
- **Descripción**: Configuración de privacidad
- **Elementos**: Visibilidad, bloqueos, permisos
- **Navegación**: ← Settings
- **Dependencias**: Settings
- **Prompt para Codex**: "Create privacy settings with profile visibility controls, blocked users list, location sharing preferences, and data usage permissions with clear explanations for each option"

#### 7.4 Help & Support
- **Archivo**: `lib/views/settings/help_screen.dart`
- **Descripción**: Centro de ayuda y soporte
- **Elementos**: FAQ, contacto, reportes
- **Navegación**: ← Settings
- **Dependencias**: Settings
- **Prompt para Codex**: "Create a help center with searchable FAQ, contact support options, report problem form, community guidelines, and tutorial links with collapsible sections"

---

## 6. Especificaciones Técnicas

### Componentes Comunes
- **BottomNavigationBar**: 5 tabs (Home, Search, Create, Messages, Profile)
- **AppBar**: Título centrado, iconos de acción, tema oscuro
- **Floating Action Button**: Para crear contenido
- **Loading States**: Shimmer loading para todas las listas
- **Error States**: Páginas de error con retry
- **Empty States**: Ilustraciones para contenido vacío

### Gestión de Estado
- **Provider/Riverpod**: Para estado global
- **Local State**: StatefulWidget para UI temporal
- **Persistence**: SharedPreferences para configuración
- **Mock Data**: JSON files para simular contenido

### Navegación
```dart
// Rutas principales
/home
/search
/create
/messages
/profile
/auth/login
/auth/register
/post/:id
/user/:id
/chat/:id
```

### Dependencias Flutter Sugeridas
```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.0.5
  go_router: ^10.1.2
  shared_preferences: ^2.2.0
  image_picker: ^1.0.2
  cached_network_image: ^3.2.3
  flutter_map: ^6.0.1
  geolocator: ^10.1.0
  shimmer: ^3.0.0
```

---

## 7. Criterios de Éxito

### Funcionales
- ✅ Usuario puede crear cuenta y iniciar sesión
- ✅ Usuario puede publicar propiedades con imágenes
- ✅ Usuario puede explorar propiedades cercanas
- ✅ Usuario puede seguir y enviar mensajes
- ✅ Usuario puede buscar y filtrar contenido

### UX/UI
- ✅ Interfaz fluida y responsiva (60fps)
- ✅ Tema oscuro consistente
- ✅ Navegación intuitiva
- ✅ Feedback visual inmediato
- ✅ Estados de carga suaves

### Técnicos
- ✅ Arquitectura MVVM implementada
- ✅ Código modular y reutilizable
- ✅ Gestión de estado eficiente
- ✅ Rendimiento optimizado
- ✅ Manejo de errores robusto

---

## 8. Próximos Pasos

### Desarrollo Inmediato
1. **Setup inicial**: Crear estructura de proyecto según `.cursor/project-structure.json`
2. **Fase 1 (Auth)**: Implementar flujo de autenticación completo
3. **Fase 2 (Feed)**: Desarrollar feed principal y interacciones básicas
4. **Iteración**: Validar y refinar cada fase antes de continuar

### Futuras Iteraciones
- Integración con backend real
- Notificaciones push
- Geolocalización avanzada
- Sistema de pagos
- Analytics y métricas

---

*Este PRD será la base para el desarrollo de Coliseum. Cada pantalla debe implementarse siguiendo las especificaciones de diseño en `.cursor/component-style.json` y la arquitectura definida en `.cursor/project-structure.json`.* 