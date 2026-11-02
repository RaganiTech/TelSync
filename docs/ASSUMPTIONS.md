# Project Assumptions and Invariant Conformance Log

## Invariants Checklist
- [x] INV-01: All contact processing and matching happens on the device.
- [x] INV-02: No sensitive data or session is sent to developer servers (zero developer backend).
- [x] INV-03: No user account in the app.
- [x] INV-04: Existing phone contacts are never deleted, edited, merged, or reordered.
- [x] INV-04a: Undo only applies in-session to newly written records held in RAM.
- [x] INV-05: Only new items from Telegram are added to the phone.
- [x] INV-06: Preview and explicit user confirmation before writing anything.
- [x] INV-07: All core features are free.
- [x] INV-08: Future ads must have no access to contact data.
- [x] INV-09: No analytics, crash SDKs, or third-party trackers in MVP.
- [x] INV-10: Only fixed allowlist of Telegram API requests.
- [x] INV-11: Ephemeral session: server-side logOut and local wipe at end of every run.

## Technical Assumptions
1. Default region for phone number normalization is `IR` (+98), configurable in Settings.
2. In-memory data structures are used during flow; nothing persisted to disk except temporary TDLib database with per-run hardware-backed encryption key.
3. Matching key is normalized E.164 string; contact names never affect matching.
