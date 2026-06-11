#!/bin/sh
set -eu

arch="${NOIRSONANCE_CONTROL_CENTER_ARCH:-$(dpkg --print-architecture)}"
case "$arch" in
    amd64|arm64) ;;
    *)
        echo "Unsupported architecture: $arch" >&2
        echo "Control Center public binary packages are available for amd64 and arm64." >&2
        exit 1
        ;;
esac

asset="noirsonance-control-center_0.1.0-noirsonance2_${arch}.deb"
repo="${NOIRSONANCE_CONTROL_CENTER_REPO:-rimedag/control_center_cardputerzero}"
base_url="${NOIRSONANCE_CONTROL_CENTER_BASE_URL:-https://raw.githubusercontent.com/${repo}/main/pool/main/n/noirsonance-control-center}"
url="${base_url}/${asset}"
tmp_dir="$(mktemp -d)"

cleanup() {
    rm -rf "$tmp_dir"
}
trap cleanup EXIT INT TERM

echo "Downloading ${asset}..."
curl -fL "$url" -o "${tmp_dir}/${asset}"

echo "Installing Control Center..."
(
    cd "$tmp_dir"
    sudo apt install -y "./${asset}"
)

echo "Done. Launch with: noirsonance-control-center-desktop, noirsonance-control-center-cardputerzero, or noirsonance-control-center"
