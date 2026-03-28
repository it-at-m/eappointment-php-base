#!/usr/bin/env bash
set -euo pipefail

EDGE_DRIVER_VERSION="${EDGE_DRIVER_VERSION:-146.0.3856.62}"

ARCH="$(dpkg --print-architecture)"

echo "Installing Microsoft Edge + WebDriver for architecture: ${ARCH}"

mkdir -p /etc/apt/keyrings

curl -fsSL https://packages.microsoft.com/keys/microsoft.asc \
  | gpg --batch --no-tty --dearmor -o /etc/apt/keyrings/microsoft.gpg

case "$ARCH" in
  amd64)
    echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/edge stable main" \
      > /etc/apt/sources.list.d/microsoft-edge.list

    apt-get update
    apt-get install -y --no-install-recommends microsoft-edge-stable

    EDGE_VERSION="$(microsoft-edge --version | awk '{print $3}' | sed 's/-.*//')"

    curl -fsSL -o /tmp/edgedriver.zip \
      "https://msedgedriver.microsoft.com/${EDGE_VERSION}/edgedriver_linux64.zip"
    ;;

  arm64)
    echo "deb [arch=arm64 signed-by=/etc/apt/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/edge stable main" \
      > /etc/apt/sources.list.d/microsoft-edge.list

    apt-get update || true
    apt-get install -y --no-install-recommends microsoft-edge-stable || true

    if command -v microsoft-edge >/dev/null 2>&1; then
      EDGE_VERSION="$(microsoft-edge --version | awk '{print $3}' | sed 's/-.*//')"
    else
      EDGE_VERSION="${EDGE_DRIVER_VERSION}"
    fi

    curl -fsSL -o /tmp/edgedriver.zip \
      "https://msedgedriver.microsoft.com/${EDGE_VERSION}/edgedriver_arm64.zip"
    ;;

  *)
    echo "Skipping Edge install for unsupported arch: ${ARCH}"
    exit 0
    ;;
esac

unzip -o /tmp/edgedriver.zip -d /tmp

if [ -f /tmp/msedgedriver ]; then
  mv /tmp/msedgedriver /usr/local/bin/msedgedriver
else
  mv /tmp/*/msedgedriver /usr/local/bin/msedgedriver
fi

chmod +x /usr/local/bin/msedgedriver
rm -f /tmp/edgedriver.zip

apt-get clean
rm -rf /var/lib/apt/lists/*

echo "Edge + WebDriver installation complete"