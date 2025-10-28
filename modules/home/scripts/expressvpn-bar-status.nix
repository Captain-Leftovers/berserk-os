{ pkgs }:

pkgs.writeShellScriptBin "expressvpn-bar-status" ''

  status=$(expressvpn status 2>&1)

  if echo "$status" | grep -q "Connected to"; then
    location=$(echo "$status"| sed 's/\x1b\[[0-9;]*m//g' | sed -n 's/Connected to \(.*\)/\1/p')
    echo "{\"text\":\"󰖂\",\"tooltip\":\"Connected to $location\",\"class\":\"connected\"}"
  else
    echo "{\"text\":\"󰖂\",\"tooltip\":\"Not connected to VPN\",\"class\":\"disconnected\"}"
  fi
''
