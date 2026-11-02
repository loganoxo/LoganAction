#!/bin/sh

XRAY_VERSION="v26.6.27"
TARGET_PLATFORM="$1"
if [ -z "$TARGET_PLATFORM" ]; then
    ARCH="amd64"
else
    case "$TARGET_PLATFORM" in
    "linux/amd64")
        ARCH="64"
        ;;
    "linux/arm64")
        ARCH="arm64-v8a"
        ;;
    "linux/arm/v7")
        ARCH="arm32-v7a"
        ;;
    "linux/386")
        ARCH="32"
        ;;
    "linux/s390x")
        ARCH="s390x"
        ;;
    *)
        echo "Error: Unsupported target platform: $TARGET_PLATFORM"
        exit 1
        ;;
    esac
fi
[ -z "${ARCH}" ] && echo "Error: Not supported OS Architecture" && exit 1
echo "Info: TARGET_PLATFORM is $TARGET_PLATFORM, mapped to Xray arch: $ARCH"

if [ -z "$XRAY_VERSION" ] || [ "$XRAY_VERSION" = "latest" ]; then
    echo "Info: Fetching latest Xray version..."
    LATEST_URL=$(curl -sL -o /dev/null -w "%{url_effective}" "https://github.com/XTLS/Xray-core/releases/latest")
    XRAY_VERSION=${LATEST_URL##*/}
fi

[ -z "${XRAY_VERSION}" ] && echo "Error: Failed to determine Xray version." && exit 1
echo "Info: Target Xray version is $XRAY_VERSION"

# https://github.com/XTLS/Xray-core/releases/download/v26.9.30/Xray-linux-64.zip
DOWNLOAD_URL="https://github.com/XTLS/Xray-core/releases/download/${XRAY_VERSION}/Xray-linux-${ARCH}.zip"
echo "Info: Downloading from $DOWNLOAD_URL"

if wget -O /tmp/xray.zip "$DOWNLOAD_URL"; then
    echo "Download completed"
else
    echo "Error: Download Failed" && exit 1
fi

unzip -q /tmp/xray.zip xray -d /usr/bin/
chmod +x /usr/bin/xray
rm -f /tmp/xray.zip
echo "Info: Xray $XRAY_VERSION installed successfully."
