#!/bin/bash
# "Dangerously Good Ideas" by Rob-niX

# checks if "jq" is installed, if it isn't then installs it.
w2t_install_jq(){
    local YyNn NULL
         if ! command -v jq 2>&1 >/dev/null; then
            clear
            read -p 'program "jq" could not be found. Would you like to attempt to install it? y/n;' YyNn
            case $YyNn in
                [Yy]* ) sudo apt-get install jq -y
                read -p  'Press the "↵" key to continue...' NULL
                clear
                #do somthing to stop prog ending
                ;;
                [Nn]* ) echo '"wttr_to_text" needs "jq" to run. The program is quitting!'
                read -p  'Press the "↵" key to continue...' NULL
                clear
                #do somthing to stop prog ending
                exit 1
                ;;
                * ) echo "Please answer \"Y/y\" or \"N/n\""
                clear
                install_jq
                ;;
            esac
        fi
}

# checks if "curl" is installed, if it isn't then installs it.
w2t_install_curl(){
         if ! command -v curl 2>&1 >/dev/null; then
            clear
            read -p 'program "curl" could not be found. Would you like to attempt to install it? y/n;' YyNn
            case $YyNn in
                [Yy]* ) sudo apt-get install curl -y
                read -p  'Press the "↵" key to continue...' NULL
                clear
                #do somthing to stop prog ending?
                ;;
                [Nn]* ) echo '"wttr_to_text" needs "curl" to run. The program is quitting!'
                read -p  'Press the "↵" key to continue...' NULL
                clear
                #do somthing to stop prog ending?
                exit 1
                ;;
                * ) echo "Please answer \"Y/y\" or \"N/n\""
                clear
                install_curl
                ;;
            esac
        fi
}
