# OfflineArticles

Offline-first iOS app that lists space news articles, shows detail, and keeps cached content available without connectivity.

## Tech Stack

- Swift 6
- SwiftUI
- Realm
- URLSession + Swift Concurrency (`async/await`)

## API Choice

This project uses **Spaceflight News API v4**:

- Base URL: `https://api.spaceflightnewsapi.net/v4`
- List endpoint: `GET /articles`
- Detail endpoint: `GET /articles/{id}`

Reference:
- https://api.spaceflightnewsapi.net/v4/docs/#/

## Architecture

The project follows a **Clean + MVVM hybrid** with feature-based organization.

## Running the Project

1. Open `OfflineArticles.xcodeproj` in Xcode.
2. Let Swift Package Manager resolve Realm dependencies.
3. Build and run the `OfflineArticles` scheme.
