#!/bin/bash

# Function to check if a URL is reachable
function check() {
    local url="$1"
    local max_retries=10
    local timeout=1
    local attempt=0

    if [ -z "$url" ]; then
        echo "No URL provided."
        return 1
    fi

    echo "Checking and waiting for $url to become available..."

    while [ $attempt -lt $max_retries ]; do
        ((attempt++))
        response=$(curl --location --silent --head --max-time "$timeout" --write-out "%{http_code}" --output /dev/null "$url")
        curl_exit_code=$?
        if [ $curl_exit_code -ne 0 ]; then
            if [ $curl_exit_code -eq 28 ]; then
                echo "Attempt ${attempt}: Timeout occurred."
            else
                echo "Attempt ${attempt}: Curl encountered an error (code: $curl_exit_code)."
            fi
        elif [ "$response" -ne 200 ]; then
            echo "Attempt ${attempt}: Non-200 HTTP response: $response."
        else
            echo "URL retrieved successfully with HTTP status 200."
            return 0
        fi
        sleep 1
    done

    echo "Failed to retrieve URL after $max_retries attempts."
    return 1
}

# Check and wait for HOME_URL
if ! check "$HOME_URL"; then
    HOME_URL=""
fi

# Optional wait based on WAIT variable
case "$WAIT" in
    '' | *[!0-9]*)
        # WAIT is not a number, do nothing
        ;;
    *)
        if [ "$WAIT" -gt 0 ]; then
            sleep "$WAIT"
        fi
        ;;
esac

# start dbus
dbus-daemon --nosyslog --fork --session --address=unix:path=$HOME/.dbus-socket
export DBUS_SESSION_BUS_ADDRESS=unix:path=$HOME/.dbus-socket

# start i3 and Firefox
/usr/bin/i3 &

cd $HOME
/usr/bin/firefox &>firefox.log $HOME_URL &

# wait for Firefox window
while ! xdotool search --name "Firefox"; do
    sleep 1
done

# for the "boot ready" logic
echo "READY" >/dev/console

# send fullscreen command to i3
sleep 2
i3-msg fullscreen

# wait for Firefox to exit
wait $!
