# #!/bin/sh

# # Install CocoaPods using Homebrew.
# brew install cocoapods

# # Install Flutter
# brew install --cask flutter

# # Run Flutter doctor
# flutter doctor

# # Get packages
# flutter packages get

# # Update generated files
# flutter pub run build_runner build

# # Build ios app
# flutter build ios --no-codesign

#!/bin/sh

# by default, the execution directory of this script is the ci_scripts directory
# CI_WORKSPACE is the directory of your cloned repo
echo "🟩 Navigate from ($PWD) to ($CI_WORKSPACE)"
cd $CI_WORKSPACE

echo "🟩 Install Flutter"
time git clone https://github.com/flutter/flutter.git -b stable $HOME/flutter
export PATH="$PATH:$HOME/flutter/bin"

echo "🟩 Flutter Precache"
time flutter precache --ios

echo "🟩 Install Flutter Dependencies"
time flutter pub get

echo "🟩 Install CocoaPods via Homebrew"
time HOMEBREW_NO_AUTO_UPDATE=1 brew install cocoapods

echo "🟩 Install CocoaPods dependencies..."
time cd ios && pod install

exit 0