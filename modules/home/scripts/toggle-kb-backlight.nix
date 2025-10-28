# { pkgs }:
# pkgs.writeShellScriptBin "toggle-kb-backlight" ''

#   LED_PATH="/sys/class/leds/tpacpi::kbd_backlight/brightness"
#   MAX=2

#   cur=$(cat "$LED_PATH")
#   next=$(( (cur + 1) % (MAX + 1) ))

#   echo $next > "$LED_PATH"

#   case "$next" in
#     0) notify-send "💡 Keyboard Backlight" "Turned OFF" ;;
#     1) notify-send "💡 Keyboard Backlight" "Set to LOW" ;;
#     2) notify-send "💡 Keyboard Backlight" "Set to HIGH" ;;
#   esac
# ''

# ----------------------------------------------------------------------------
#
{ pkgs, ... }:
pkgs.writeShellScriptBin "toggle-kb-backlight" ''
  set -e

  # 1) Discover a keyboard backlight LED from sysfs (most reliable).
  #    We match common vendor names like: tpacpi::kbd_backlight, asus::kbd_backlight, dell::kbd_backlight, etc.
  pick_dev_from_sysfs() {
    for p in /sys/class/leds/*; do
      [ -e "$p" ] || continue
      base="$(basename "$p")"
      # case-insensitive match for "kbd" or "keyboard" + "backlight"
      if printf '%s\n' "$base" | grep -iqE '(kbd|keyboard).*backlight|backlight.*(kbd|keyboard)|kbd_backlight'; then
        printf '%s' "$base"
        return 0
      fi
    done
    return 1
  }

  # 2) Fallback: try to ask brightnessctl to list devices and pick likely LED names.
  pick_dev_from_bctl() {
    # Some brightnessctl builds print CSV with class,name,...; others print colon style.
    # Grab anything containing "kbd" and "backlight".
    bctl_list="$(brightnessctl --list 2>/dev/null || true)"
    printf '%s\n' "$bctl_list" \
      | sed 's/,/ /g' \
      | tr ':' ' ' \
      | awk '{for(i=1;i<=NF;i++) if (tolower($i) ~ /kbd/ && tolower($i) ~ /backlight/) {print $i; exit}}'
  }

  # Try sysfs first, then brightnessctl list, then a last-known-good ThinkPad value.
  dev="$(pick_dev_from_sysfs || true)"
  if [ -z "$dev" ]; then
    dev="$(pick_dev_from_bctl || true)"
  fi
  if [ -z "$dev" ]; then
    # Final fallback for ThinkPads
    if brightnessctl -d 'tpacpi::kbd_backlight' info >/dev/null 2>&1; then
      dev='tpacpi::kbd_backlight'
    fi
  fi

  if [ -z "$dev" ]; then
    notify-send "💡 Keyboard Backlight" "No keyboard backlight device found"
    exit 1
  fi

  # Read current/max, compute next level (wrap), and set it.
  max="$(brightnessctl -d "$dev" max)"
  cur="$(brightnessctl -d "$dev" get)"
  next=$(( (cur + 1) % (max + 1) ))

  brightnessctl -d "$dev" set "$next" >/dev/null

  case "$next" in
    0) notify-send "💡 Keyboard Backlight" "[$dev] OFF" ;;
    1) notify-send "💡 Keyboard Backlight" "[$dev] LOW" ;;
    *) notify-send "💡 Keyboard Backlight" "[$dev] Level $next / $max" ;;
  esac
''
