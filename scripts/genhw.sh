#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <host>" >&2
  exit 64
fi

host="$1"

if [[ ! "$host" =~ ^[a-zA-Z0-9_-]+$ ]]; then
  echo "Invalid host name: $host" >&2
  exit 64
fi

host_dir="hosts/$host"
output="$host_dir/hardware-configuration.nix"

if [[ ! -d "$host_dir" ]]; then
  echo "Host directory does not exist: $host_dir" >&2
  exit 1
fi

if ! command -v nixos-generate-config >/dev/null; then
  echo "nixos-generate-config is unavailable; run this on NixOS." >&2
  exit 1
fi

temporary_file="$(mktemp "$host_dir/.hardware-configuration.nix.XXXXXX")"
trap 'rm -f "$temporary_file"' EXIT

sudo nixos-generate-config --show-hardware-config > "$temporary_file"
mv "$temporary_file" "$output"

trap - EXIT
echo "Updated $output"
echo "Review it with: git diff -- $output"
