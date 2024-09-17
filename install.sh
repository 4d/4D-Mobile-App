#!/bin/sh

package="4D-Mobile-App"

root=$(pwd)

TMP="${TMPDIR}"
if [ "x$TMP" = "x" ]; then
  TMP="/tmp"
fi
TMP="${TMP}/$package.$$"
rm -rf "$TMP" || true
mkdir "$TMP"
if [ $? -ne 0 ]; then
  echo "failed to mkdir $TMP" >&2
  exit 1
fi

cd $TMP

echo "⬇️  Download $package component from latest release"
archive=$TMP/$package.zip 
curl -sL https://github.com/4d/$package/releases/latest/download/4D.Mobile.App.zip -o $archive

dst="$root/Components"
if [ ! -d "$dst" ]; then
  mkdir -p "$dst"
fi

echo "📦 Unpack into $dst"
unzip -q "$archive" -d "$dst"/

echo "🧹 Clean temporary files"
echo "rm -rf $TMP"

open "$dst"

echo "✅ Installed into $dst"

if [[ "$OSTYPE" == "darwin"* ]]; then
  open "$dst"
fi
