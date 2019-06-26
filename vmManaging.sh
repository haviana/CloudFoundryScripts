#!/bin/bash
# Bash Menu Script for Virtual Machine control

PS3='Please enter your choice: '
options=("Option 1 - Start Virtual Machine" "Option 2 - Save Virtual Machine State" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Option 1 - Start Virtual Machine")
            echo "you chose choice 1"
	    vboxmanage startvm $(bosh int ./state.json --path /current_vm_cid) --type headless
            ;;
        "Option 2 - Save Virtual Machine State")
            echo "Save Virtual Machine State"
            vboxmanage controlvm $(bosh int ./state.json --path /current_vm_cid) savestate
            ;;
        "Quit")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done
