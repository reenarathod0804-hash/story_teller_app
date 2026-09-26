# Story Teller – Flutter Kids Storytelling App & Admin Panel

A multilingual kids storytelling application built with Flutter, Firebase, and a separate Flutter Web admin panel for managing stories and categories.

## Project Overview

Story Teller is a Flutter-based mobile application designed to provide children with an interactive storytelling experience.

The project also includes a Flutter Web admin panel that allows administrators to manage story content and categories through Firebase.

This repository contains both:

- Story Teller mobile application
- Story Teller admin panel

## Features

### Mobile Application

- User authentication
- Multilingual story content
- Story categories
- Story details and descriptions
- Text-to-speech storytelling
- User profile
- Favorite category selection
- Age selection
- Local data storage
- Push notifications
- Notification preferences
- Firebase integration
- Story content management through Firebase
- Download/payment functionality

### Admin Panel

- Admin authentication
- Dashboard
- Category management
- Story management
- Add stories
- Edit stories
- Delete/manage stories
- Firebase Firestore integration
- Web-based administration

## Languages Supported

The application supports:

- English
- Hindi
- Spanish

## Technology Stack

### Mobile Application

- Flutter
- Dart
- Provider
- Firebase Authentication
- Cloud Firestore
- Firebase Cloud Messaging
- Hive
- Flutter TTS
- Device Preview

### Admin Panel

- Flutter Web
- Dart
- Firebase Authentication
- Cloud Firestore

## Project Structure

```text
story_teller_app/
│
├── admin_storyteller/
│   └── Flutter Web Admin Panel
│
├── lib/
│   └── Story Teller Mobile Application
│
├── assets/
│   └── Application assets
│
├── android/
├── ios/
├── web/
├── windows/
├── macos/
├── linux/
│
├── pubspec.yaml
└── README.md
