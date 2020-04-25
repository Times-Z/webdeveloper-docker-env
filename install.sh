#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
RESET='\033[0m'

install() {
    echo "Need root to perform"
    sudo echo "Installing..."
    if [ -z "$1" ] ;
    then
        echo -e "${RED}Missing argument"
        echo "Valid arguments are :"
        echo "  - cron"
        echo -e "  - alias${RESET}"
        return 1
    fi

    DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
    MODE=$1

    if [ "$MODE" == "cron" ] ;
    then
        crontab -l > $DIR/tmp.txt
        if grep -Fq "docker_start.sh" $DIR/tmp.txt
        then
            echo -e "${GREEN}Crontab already exist for docker_start.sh ${RESET}"
            rm $DIR/tmp.txt
            return 1
        else
            echo "Crontab not found, creating..."
            echo "@reboot $DIR/docker_start.sh" >> $DIR/tmp.txt
            crontab $DIR/tmp.txt
            rm $DIR/tmp.txt
        fi
    elif [ "$MODE" == "alias" ]
    then
        ALIAS_ROUTE="$HOME/.bashrc"
        if grep -Fq "alias westart=" $ALIAS_ROUTE
        then
            echo -e "${RED}Alias already exist${RESET}"
        else
            echo "Creating alias"
            echo "" >> $ALIAS_ROUTE
            echo "# ALIAS FOR CRASH-ZEUS WEB DOCKER ENV" >> $ALIAS_ROUTE
            echo "alias westart='${DIR}/docker_start.sh'" >> $ALIAS_ROUTE
            echo "alias westop='${DIR}/docker_stop.sh'" >> $ALIAS_ROUTE

            if [ "$?" == "0" ] ;
            then
                echo -e "${GREEN}Install completed${RESET}"
                read -r -p "Need restart for finish configuration, do you want to reboot now ? [Y/n] " response
                if [ -z "$response" ] ;
                then
                    response="Y"
                fi
                if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
                then
                    reboot -f
                fi
            fi
        fi
    else
        echo -e "${RED}Syntax error"
        echo "Valid arguments are :"
        echo "  - cron"
        echo -e "  - alias${RESET}"
        return 1
    fi

}

install $1
