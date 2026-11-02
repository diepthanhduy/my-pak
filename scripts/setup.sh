#!/usr/bin/env bash
# One-time project bootstrap. Run from the project root: ./scripts/setup.sh
set -euo pipefail

cd "$(dirname "$0")/.."

# 1. Generate native android/ and ios/ folders (existing files are not overwritten).
flutter create . \
  --org com.diepthanhduy \
  --project-name assistant_pak \
  --platforms android,ios

# 2. Add dependencies with versions resolved against the local Flutter SDK.
flutter pub add \
  flutter_bloc \
  equatable \
  get_it \
  injectable \
  go_router \
  drift \
  drift_flutter \
  path_provider \
  pdfrx \
  file_picker \
  url_launcher \
  intl

flutter pub add \
  dev:flutter_lints \
  dev:build_runner \
  dev:injectable_generator \
  dev:drift_dev \
  dev:bloc_test \
  dev:mocktail

# 3. Code generation (injectable config, drift).
dart run build_runner build --delete-conflicting-outputs

flutter analyze
