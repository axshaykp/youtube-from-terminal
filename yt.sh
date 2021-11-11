#!/bin/bash

[ $# -eq 0 ] && echo "Syntax : $0 <search-query>" && exit 1

query=$(echo $@ | awk '{gsub(" ","+")}1')
menu=fzf
yt="https://www.youtube.com/watch?v="
id=$(curl https://www.youtube.com/results \
        -s -G --data-urlencode search_query=$query \
        -G --data-urlencode sp= \
        -H 'Authority: www.youtube.com' \
        -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4324.152 Safari/537.36' \
        -H 'Accept-Language: en-US,en;q=0.9' \
        -L --compressed \
	| awk '{gsub("<","\n<")}1' \
	| awk '{gsub("videoId","\n videoId")}1' \
	| awk '{gsub("views","views\n")}1' \
	| awk -F '"' '/videoId/ { print $39 "  " $3 }' \
	| awk '/views/' | $menu | awk -F ' ' '{ print $(NF-0) }')
mpv ${yt}${id}
