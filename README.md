# youtube-from-terminal

A simple script to search youtube from terminal and watch video in mpv

# Usage

```sh
./yt.sh <search-query>
```
# Setup

```sh
git clone https://github.com/axxsh/youtube-from-terminal.git
cd youtube-from-terminal
chmod +x yt.sh
```
# Dependencies

- curl
- sed
- grep
- awk
- fzf or dmenu (change variable from ```sh menu=fzf ``` to ```sh menu=dmenu ``` to use dmenu)
- mpv (for streaming video)
