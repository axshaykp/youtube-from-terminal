#!/bin/bash

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

handle_error() {
    echo "Error: $1"
    exit 1
}

if ! command_exists mpv || ! command_exists fzf || ! command_exists awk || ! command_exists curl; then
    handle_error "Please make sure 'mpv', 'fzf', 'awk' and 'curl' are installed."
fi

if [ $# -eq 0 ] || [[ "$1" != "-q" ]]; then
    echo "Syntax: $0 -q <search-query>"
    exit 1
fi

query_encoded=$(printf '%q ' "${@:2}")

menu=fzf

yt="https://www.youtube.com/watch?v="

video_id=$(curl "https://www.youtube.com/results" \
        -s -G --data-urlencode "search_query=$query_encoded" \
        -G --data-urlencode "sp=" \
        -H "Authority: www.youtube.com" \
        -H "User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4324.152 Safari/537.36" \
        -H "Accept-Language: en-US,en;q=0.9" \
        -L --compressed \
	| awk '{gsub("<","\n<")}1' \
	| awk '{gsub("videoId","\n videoId")}1' \
	| awk '{gsub("views","views\n")}1' \
	| awk -F '"' '/videoId/ { print $39 "  " $3 }' \
	| awk '/views/' | "$menu" | awk -F ' ' '{ print $(NF-0) }')

if [ -z "$video_id" ]; then
    handle_error "No video selected or found."
fi

echo "Loading..."

if ! mpv "${yt}${video_id}"; then
    handle_error "Failed to play the video."
fi
