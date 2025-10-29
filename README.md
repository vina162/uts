# 🕌 Flutter Project - HalalFinder App

A modern *Flutter-based halal product finder* app built for the UTS project.  
This app integrates *Firebase*, *Provider state management*, and **Shared Preferences** to handle authentication, data persistence, and product management in a clean and modular architecture.

## 🧩 Overview
The app features:
- *Firebase integration* for authentication and cloud data handling.  
- *Provider architecture* for managing app state efficiently.  
- *Shared Preferences* for local data storage.  
- *Dynamic routing* based on user role:
  - 👤 Regular users → *Home Page*  
  - 🛠️ Admin users → *Admin Dashboard*  
  - 🔐 Unauthenticated users → *Login Page*  

## 💡 Result
When you run the app, it will:
- Initialize Firebase with fallback handling.  
- Load user preferences and services (Auth, Storage, Product).  
- Display the appropriate page depending on login state and role.  

```
-------------------------------
|        HalalFinder App      |
|                             |
|  → Login (if not signed in) |
|  → Home Page (user)         |
|  → Admin Dashboard (admin)  |
-------------------------------
```

## 🛠️ Tech Used
- *Flutter SDK*
- *Dart Language*
- *Firebase Core*
- *Provider (State Management)*
- *Shared Preferences*
- *Material Design*

## 🌿 Theme & UI
- Dark theme with *deep green accents* representing “Halal” identity.  
- Rounded buttons, modern typography, and minimalistic form fields for a professional look.  

✨ *A fully structured Flutter app combining Firebase, Provider, and modern design principles — built as part of a UTS project!*  
````
