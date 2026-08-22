#!/usr/bin/env bash
# Pick a random wallpaper on startup and every 30 minutes.
set -euo pipefail

wallpaper_dir="${HOME}/Pictures/Wallpapers"
interval_seconds=1800
overview_wallpaper="${XDG_RUNTIME_DIR:-/tmp}/niri-overview-wallpaper.png"

if [[ ! -d "$wallpaper_dir" ]]; then
    printf 'Wallpaper directory does not exist: %s\n' "$wallpaper_dir" >&2
    exit 1
fi

# Let both the desktop and Overview wallpaper daemons create their sockets
# before sending the first image.
for _ in {1..30}; do
    if awww query >/dev/null 2>&1 && awww query --namespace overview >/dev/null 2>&1; then
        break
    fi
    sleep 1
done

while true; do
    mapfile -d '' -t wallpapers < <(
        find "$wallpaper_dir" -type f \
            \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \) -print0
    )

    if ((${#wallpapers[@]})); then
        wallpaper="${wallpapers[RANDOM % ${#wallpapers[@]}]}"
        # Keep the desktop sharp and use a heavily blurred copy in Mod+O.
        magick "$wallpaper" -resize '25%' -blur 0x16 -resize '400%' "$overview_wallpaper"
        awww img "$wallpaper" --resize crop --transition-type fade --transition-duration 1
        awww img --namespace overview "$overview_wallpaper" --resize crop --transition-type fade --transition-duration 1
    else
        printf 'No supported images found in: %s\n' "$wallpaper_dir" >&2
    fi

    sleep "$interval_seconds"
done
