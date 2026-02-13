#!/usr/bin/env bash
set -e
cd "$(dirname "$0")"

# Pull latest if this is an update
if [ -d .git ]; then
    git pull --ff-only 2>/dev/null || true
fi

# Build with version info
VERSION=$(git describe --tags --always --dirty 2>/dev/null || echo dev)
COMMIT=$(git rev-parse --short=12 HEAD 2>/dev/null || echo "")
DATE=$(date -u +%Y-%m-%dT%H:%M:%SZ)
LDFLAGS="-X github.com/steipete/gogcli/internal/cmd.version=$VERSION -X github.com/steipete/gogcli/internal/cmd.commit=$COMMIT -X github.com/steipete/gogcli/internal/cmd.date=$DATE"

mkdir -p bin
go build -ldflags "$LDFLAGS" -o bin/gog ./cmd/gog

# Install binary
mkdir -p ~/prj/util/bin
cp bin/gog ~/prj/util/bin/gog
chmod +x ~/prj/util/bin/gog

echo "Installed: $(~/prj/util/bin/gog --version 2>/dev/null || echo 'gog')"
