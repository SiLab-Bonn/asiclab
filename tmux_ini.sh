#!/bin/bash -x

ssh_list=(  asiclab@asiclab000.physik.uni-bonn.de \
            asiclab@asiclab001.physik.uni-bonn.de \
            asiclab@asiclab002.physik.uni-bonn.de \
            asiclab@asiclab003.physik.uni-bonn.de \
            asiclab@asiclab004.physik.uni-bonn.de \
            asiclab@asiclab006.physik.uni-bonn.de \
            asiclab@asiclab007.physik.uni-bonn.de \
	        asiclab@asiclab008.physik.uni-bonn.de \
            asiclab@asiclab011.physik.uni-bonn.de \
   )
split_list=()
for ssh_entry in "${ssh_list[@]:1}"; do
    split_list+=( split-pane -v -p 30 -h -p 50 ssh "$ssh_entry" ';' select-layout tiled ';' )
done

tmux new-session ssh "${ssh_list[0]}" ';' \
    "${split_list[@]}" \
    set-option -w synchronize-panes
