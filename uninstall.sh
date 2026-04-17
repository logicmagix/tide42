#!/usr/bin/env bash
# uninstall.sh - Uninstall tide42 and associated files
# Copyright (C) 2025 Pavle Dzakula
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <https://www.gnu.org/licenses/>.

# === Initialize ===
set -e
echo "[tide42] Uninstalling tide42..."

# === Resolve the script's directory ===
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# === Remove installed files and directories ===
echo "[tide42] Removing /usr/local/bin/tide42..."
if [ -f "/usr/local/bin/tide42" ]; then
  sudo rm -f "/usr/local/bin/tide42" || {
    echo "[tide42] Error: Failed to remove /usr/local/bin/tide42. Check permissions."
    exit 1
  }
  echo "[tide42] Removed /usr/local/bin/tide42."
else
  echo "[tide42] /usr/local/bin/tide42 not found. Skipping."
fi

echo "[tide42] Removing /usr/local/bin/termic..."
if [ -f "/usr/local/bin/termic" ]; then
  sudo rm -f "/usr/local/bin/termic" || {
    echo "[tide42] Error: Failed to remove /usr/local/bin/termic. Check permissions."
    exit 1
  }
  echo "[tide42] Removed /usr/local/bin/termic."
else
  echo "[tide42] /usr/local/bin/termic not found. Skipping."
fi

echo "[tide42] Removing ~/.config/tide42..."
if [ -d "${XDG_CONFIG_HOME:-$HOME/.config}/tide42" ]; then
  rm -rf "${XDG_CONFIG_HOME:-$HOME/.config}/tide42" || {
    echo "[tide42] Error: Failed to remove ~/.config/tide42. Check permissions."
    exit 1
  }
  echo "[tide42] Removed ~/.config/tide42."
else
  echo "[tide42] ~/.config/tide42 not found. Skipping."
fi

# === Leave the repository directory alone ===
# Removing the repo from here is too easy to misclick. If you want it gone,
# delete it yourself with a path you've typed deliberately.
echo "[tide42] Repository directory left in place: $SCRIPT_DIR"
echo "[tide42] To remove it, run: rm -rf \"$SCRIPT_DIR\""

echo "[tide42] Uninstallation complete."
echo "[tide42] Thank you for trying tide42! Share feedback: github.com/logicmagix/tide42/discussions"
