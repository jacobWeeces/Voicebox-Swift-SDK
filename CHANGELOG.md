# Changelog

All notable changes to the VoiceBox Swift SDK will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.0] - 2024-12-16

### Added
- `VoiceBox.FeedbackButton(style:)` - Customizable button to open feedback form
  - Styles: `.standard`, `.pill`, `.floating`, `.text`
  - Custom label support via ViewBuilder
- `VoiceBox.NewRequestView()` - Standalone feedback submission form
- Image upload size validation (10MB max)
- Converted debug prints to `os.log` for production safety

### Changed
- Module name simplified from `VoiceBoxSDK` to `VoiceBox`
- Updated platform requirement to iOS 16+ (was iOS 15+)

### Fixed
- README platform version now matches Package.swift
- Removed false claim about automatic retries

---

## [1.0.0] - 2024-12-10

### Added
- Initial release
- `VoiceBox.FeedbackView()` - Full tabbed experience with requests, roadmap, and changelog
- `VoiceBox.RequestsView()` - Standalone feature requests list
- `VoiceBox.RoadmapView()` - Public roadmap display
- `VoiceBox.ChangelogView()` - Release notes and changelog
- `VoiceBox.NewRequestView()` - Feedback submission form
- `VoiceBox.FeedbackButton(style:)` - Customizable button to open feedback form
  - Styles: `.standard`, `.pill`, `.floating`, `.text`
  - Custom label support via ViewBuilder
- `VoiceBox.AnnouncementBanner()` - In-app announcements with configurable behavior
- `.voiceBoxAnnouncement()` view modifier for easy banner integration
- Voting system with optimistic updates
- Comments on feedback items
- Image attachments for feedback and comments (10MB limit)
- User segmentation by email, payment tier, and custom metadata
- Comprehensive theming system (colors, typography, spacing)
- Full localization support for all UI strings
- Feature toggles for granular control
- UIKit support via `VoiceBox.viewController()`

### Security
- Image upload size validation (10MB max)
- API key-based authentication
- Secure device identification

---

## Versioning

We use [Semantic Versioning](https://semver.org/):

- **MAJOR** version for incompatible API changes
- **MINOR** version for backwards-compatible new features
- **PATCH** version for backwards-compatible bug fixes

When updating, check the changelog for any breaking changes in major versions.
