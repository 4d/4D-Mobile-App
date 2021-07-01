#!/bin/sh
##
# Copy frameworks, symbols, strip architectures and remove useless files.
##

if [ -z "${TARGET_BUILD_DIR}" ]; then
    echo "TARGET_BUILD_DIR not defined"
    exit 1
fi
if [ -z "${WRAPPER_NAME}" ]; then
    echo "WRAPPER_NAME not defined"
    exit 1
fi
if [ -z "${ARCHS}" ]; then
    echo "ARCHS not defined"
    exit 1
fi

APP_PATH="${TARGET_BUILD_DIR}/${WRAPPER_NAME}"
TO_STRIP_FOLDERS="Headers PrivateHeaders Modules"
if [ "$ACTION" == "install" ]
then
  DEBUG_SYMBOL_DEST="$BUILT_PRODUCTS_DIR"
else
  DEBUG_SYMBOL_DEST="$TARGET_BUILD_DIR"
fi

# This script loops through the frameworks embedded in the application
for (( i = 0; i < ${SCRIPT_INPUT_FILE_COUNT}; i++ ))
do
  FRAMEWORK="$(eval echo \${SCRIPT_INPUT_FILE_${i}})"
  FRAMEWORK_OUT="$(eval echo \${SCRIPT_OUTPUT_FILE_${i}})"
  SYMBOL_PATH=$(dirname "$FRAMEWORK")

  # Read executable name
  FRAMEWORK_EXECUTABLE_NAME=$(defaults read "$FRAMEWORK/Info.plist" CFBundleExecutable)

  if [ -z "${FRAMEWORK_EXECUTABLE_NAME}" ]
  then
    FRAMEWORK_EXECUTABLE_NAME=$(/usr/libexec/PlistBuddy "$FRAMEWORK/Info.plist" -c "Print CFBundleExecutable")
  fi

  if [ -z "$FRAMEWORK_EXECUTABLE_NAME" ]
  then
    echo "warning: $i - $FRAMEWORK skipped"
    continue
  fi

  FRAMEWORK_EXECUTABLE_PATH="$FRAMEWORK_OUT/$FRAMEWORK_EXECUTABLE_NAME"
 
  echo "note: copy $FRAMEWORK_EXECUTABLE_NAME"

  ## do copy (replace)
  rm -Rf "$FRAMEWORK_OUT"
  cp -R "$FRAMEWORK" "$FRAMEWORK_OUT"

  ## and removes unused architectures.
  ## TODO use lipo -info and -remove instead
  EXTRACTED_ARCHS=()

  for ARCH in $ARCHS
  do
    ### echo "Extracting $ARCH from $FRAMEWORK_EXECUTABLE_NAME"
    lipo -extract "$ARCH" "$FRAMEWORK_EXECUTABLE_PATH" -o "$FRAMEWORK_EXECUTABLE_PATH-$ARCH"
    EXTRACTED_ARCHS+=("$FRAMEWORK_EXECUTABLE_PATH-$ARCH")
  done

  ### echo "Merging extracted architectures: ${ARCHS}"
  lipo -o "$FRAMEWORK_EXECUTABLE_PATH-merged" -create "${EXTRACTED_ARCHS[@]}"
  rm "${EXTRACTED_ARCHS[@]}"

  ### echo "Replacing original executable with thinned version of $FRAMEWORK_EXECUTABLE_NAME"
  rm "$FRAMEWORK_EXECUTABLE_PATH"
  mv "$FRAMEWORK_EXECUTABLE_PATH-merged" "$FRAMEWORK_EXECUTABLE_PATH"

  ## and remove debug symbol if necessary
  if [ "$COPY_PHASE_STRIP" == "YES" ]
  then
    strip -S -o "$FRAMEWORK_EXECUTABLE_PATH" "$FRAMEWORK_EXECUTABLE_PATH"
  fi

  ## and removes useless folder.
  ### "Strip folders '$TO_STRIP_FOLDERS' from $FRAMEWORK_EXECUTABLE_NAME"
  for TO_STRIP_FOLDER in $TO_STRIP_FOLDERS
  do
    rm -rf "$FRAMEWORK_OUT/$TO_STRIP_FOLDER"
  done

  ## and resign if necessary
  if [ "$CODE_SIGNING_ALLOWED" == "YES" ]
  then
    codesign --force --sign "$EXPANDED_CODE_SIGN_IDENTITY" --preserve-metadata=identifier,entitlements "$FRAMEWORK_OUT"
  fi

  ## copy symbol maps
  if [ "$ACTION" == "install" ]
  then
    for UUID in $(dwarfdump --uuid "$FRAMEWORK_EXECUTABLE_PATH" | awk '{print $2}')
    do
        cp "$SYMBOL_PATH"/$UUID.bcsymbolmap "$BUILT_PRODUCTS_DIR"
    done
  fi

  ## and copy debug symbol and strip according to architecture
  FRAMEWORK_DEBUG_SYMBOL_PATH="$FRAMEWORK.dSYM"
  FRAMEWORK_DEBUG_SYMBOL_EXECUTABLE_PATH="$DEBUG_SYMBOL_DEST/$FRAMEWORK_EXECUTABLE_NAME.framework.dSYM/Contents/Resources/DWARF/$FRAMEWORK_EXECUTABLE_NAME"
  cp -R "$FRAMEWORK_DEBUG_SYMBOL_PATH" "$DEBUG_SYMBOL_DEST"

  EXTRACTED_ARCHS=()

  for ARCH in $ARCHS
  do
    lipo -extract "$ARCH" "$FRAMEWORK_DEBUG_SYMBOL_EXECUTABLE_PATH" -o "$FRAMEWORK_DEBUG_SYMBOL_EXECUTABLE_PATH-$ARCH"
    EXTRACTED_ARCHS+=("$FRAMEWORK_DEBUG_SYMBOL_EXECUTABLE_PATH-$ARCH")
  done

  ### Merging extracted architectures: ${ARCHS}"
  lipo -o "$FRAMEWORK_DEBUG_SYMBOL_EXECUTABLE_PATH-merged" -create "${EXTRACTED_ARCHS[@]}"
  rm "${EXTRACTED_ARCHS[@]}"

  ### Replacing original executable with thinned version of $FRAMEWORK_EXECUTABLE_NAME"
  rm "$FRAMEWORK_DEBUG_SYMBOL_EXECUTABLE_PATH"
  mv "$FRAMEWORK_DEBUG_SYMBOL_EXECUTABLE_PATH-merged" "$FRAMEWORK_DEBUG_SYMBOL_EXECUTABLE_PATH"

done
