#!/bin/sh
show_menu(){
    normal=`echo "\033[m"`
    menu=`echo "\033[36m"` #Blue
    number=`echo "\033[33m"` #yellow
    bgred=`echo "\033[41m"`
    fgred=`echo "\033[31m"`
    printf "\n${menu}*********************************************${normal}\n"
    printf "${menu}**${number} 1)${menu} Parse XML ${normal}\n"
    printf "${menu}**${number} 2)${menu} Display XML ${normal}\n"
    printf "${menu}**${number} 3)${menu} Display Parsed XML ${normal}\n"
    printf "${menu}**${number} 4)${menu} Send Parsed XML ${normal}\n"
    printf "${menu}*********************************************${normal}\n"
    printf "Please enter a menu option and enter or ${fgred}x to exit. ${normal}"
    read opt
}

option_picked(){
    msgcolor=`echo "\033[01;31m"` # bold red
    normal=`echo "\033[00;00m"` # normal white
    message=${@:-"${normal}Error: No message passed"}
    printf "${msgcolor}${message}${normal}\n"
}
list_file(){
    num=0
    declare -a filename=()
    echo "${filename[*]}"
    option_picked "Choose $2 !!";
    for i in `ls *.$1 2> ./dump`
    do
        echo "$num.) $i"
            filename[$num]=$i
            echo ${filename[0]}
            #  filename+=($i)
            num=$(($num+1))
    done
}

clear
show_menu
while [ $opt != '' ]
    do
    if [ $opt = '' ]; then
      exit;
    else
      case $opt in
        1) clear;
            list_file xml "XML TO BE PARSED"
            if [ -z $filename ]; then
                echo "Empty !!"
            else 
                read file
                printf "Parsing ${filename[$file]} File !!"
                `gcc parser.c -lxml2 -o parser`
                `./parser ${filename[$file]} > "${filename[$file]}.parse"`
                echo "Parsing Done !!"
            fi    
            show_menu;
        ;;
        2) clear;
            list_file xml "XML TO BE DISPLAYED"
            read file 
            if [ -z $filename ]; then
                echo "Empty !!"
            else     
                printf "Displaying ${filename[$file]} XML File !!"
                printf "`cat ${filename[$file]}`"
            fi    
            show_menu;
        ;;
        3) clear;
            list_file parse "PARSED XML TO BE DISPLAYED"
            if [ "${#filename[@]}" -ne 0 ]; then
                echo "Empty.. No files parsed yet !!"
            else
                read file
                printf "Displaying ${filename[$file]} XML Parsed File !!"
                printf "`cat ${filename[$file]}`"
            fi 
            show_menu;
        ;;
        4) clear;
            list_file parse "PARSED XML TO SEND TO SERVER"
            if [ ${#filename[@]} == "0" ]; then
                echo "Empty.. No files to send !!"
            else
                read file
                printf "sending ${filename[$file]} to server";
                echo
                printf "`curl -H "Expect:" --data @"${filename[$file]}" 127.0.0.1:8080`";
                echo
            fi    
            show_menu;
        ;;
        x)
        `rm *.parse parser 2> /dev/null`
        exit;
        ;;
        \n)exit;
        ;;
        *)clear;
            option_picked "Pick an option from the menu";
            show_menu;
        ;;
      esac
    fi
done
