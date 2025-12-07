#  Flutter E-Commerce App (BLoC + Hive + Mock API)

#  Project Overview

This is a Flutter-based e-commerce application built using the **BLoC state management pattern** with a clean, scalable architecture.  
All product data is **mocked locally using JSON**, while user authentication and cart data are stored persistently using **Hive**.

The app includes:
- Product listing with responsive grid
- Add to cart & quantity selection
- Guest & authenticated user flow
- Cart persistence with Hive
- 3-step checkout flow
- Pull-to-refresh with mock API delay
- Product sorting
- Bottom navigation with Home, Cart, Profile
- Snackbars for user feedback
- Clean Material 3 UI

---

#  Setup Instructions

Follow these steps to run the project locally:

# 1. Install dependencies

flutter pub get

# 2. Run the application

flutter run

# Make sure:

An Android emulator or physical device is connected
                     OR
An iOS simulator is running (macOS required)

# Flutter & Dart Version Used

Flutter:Flutter 3.32.6(stable)

Dart : 3.8.1

# How to Test

No automated unit or widget tests were added for this assignment.
All features were tested manually on an Android emulator including:

Login & Guest flow

Product loading from mock JSON

Add to cart & cart persistence

Checkout steps

Logout & navigation behavior

Pull-to-refresh

Product sorting
