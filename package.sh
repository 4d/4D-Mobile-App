#!/bin/sh

echo "Script to use all sources and packages"

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
RESOURCES_DIR="$SCRIPT_DIR/Resources"

root="./.."
if [ ! -d "$root/ios-sdk" ]; then # if existing as sibling
  root="./.checkout" # else we use an hiddent folder to checkout
  mkdir -p "$root"
fi
echo "Work inside $(realpath $root)"

inside_git_repo="$(git rev-parse --is-inside-work-tree 2>/dev/null)"
if [ "$inside_git_repo" ]; then
  GIT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
else
  GIT_BRANCH="main"
  >&2 echo "❌ You are not in git repository, git branch $GIT_BRANCH will be used"
fi

if [ -d "$root/ios-sdk" ]; then
  cd "$root"
  git clone https://github.com/4d/ios-sdk.git
fi
cd "$root/ios-sdk" || exit 1
git checkout "$GIT_BRANCH"
cd "$SCRIPT_DIR" || exit 1

if [ -d "$root/android-sdk" ]; then
  cd "$root" || exit 1
  git clone https://github.com/4d/android-sdk.git
fi
cd "$root/android-sdk" || exit 1
git checkout "$GIT_BRANCH"
cd "$SCRIPT_DIR" || exit 1

if [ -d "$root/android-ProjectGenerator" ]; then
  cd "$root" || exit 1
  git clone https://github.com/4d/android-ProjectGenerator.git
fi
cd "$root/android-ProjectGenerator" || exit 1
git checkout "$GIT_BRANCH"
cd "$SCRIPT_DIR" || exit 1

mkdir -p "$RESOURCES_DIR/sdk/"

echo "🍏"
$root/ios-sdk/build.sh
cat "$root/ios-sdk/sdkarchive.sh"
$root/ios-sdk/sdkarchive.sh

ls "$root/ios-sdk/ios.zip"
cp "$root/ios-sdk/ios.zip" "$RESOURCES_DIR/sdk/"

echo "🤖"
$root/android-sdk/build.sh
$root/android-sdk/sdkarchive.sh
ls "$root/android-sdk/android.zip"
cp "$root/android-sdk/android.zip" "$RESOURCES_DIR/sdk/"

echo "🤖 ⚙️"
$root/android-ProjectGenerator/build.sh
ls "androidprojectgenerator.jar"
mv "androidprojectgenerator.jar" "$RESOURCES_DIR/scripts/"
