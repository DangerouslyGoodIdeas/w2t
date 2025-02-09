#!/bin/bash
# "Dangerously Good Ideas" by Rob-niX
#-----------------------------------------------------------------------------------
#--------------------------------find directory------------------------------------

script_dir=$(dirname "$(realpath "$0")")
#echo "Script directory: $script_dir"

#------------------------------------------------------------------------------------
#-----------------------------------flags--------------------------------------------

W2T_ALPHA2="false"
W2T_VERBOS="false"
W2T_SETTLE="false"

while getopts ":a:hs:v" W2T_OPTIONS;
do
  case "${W2T_OPTIONS}" in
    a) W2T_ALPHA2="$OPTARG"
      #echo "-a option selected"
      #printf "${W2T_ALPHA2}\n"
      #need to parse option to allow only valid country codes
      json_path="$script_dir/lang/iso_languages.json"
        if [ ! -f "$json_path" ]; then
        printf "\"$json_path\"; File not found!\n"
        exit 1
        fi

      #cross refrences alpha-2 code and Changes files to selected language
      W2T_GET_A_NAME=$(jq -r '.'$W2T_ALPHA2'[0]' $json_path)
        if [ $W2T_GET_A_NAME == "null" ];
          then
          printf "this is not a valid alpha-2 country code\n"
          exit 1
        fi
          json_path="$script_dir/lang/$W2T_GET_A_NAME.json"
        if [ ! -f "$json_path" ]; then
        printf "\"$json_path\"; File not found!\n"
        exit 1
        fi
          json_path="$script_dir/lang/$W2T_GET_A_NAME-numbers.json"
        if [ ! -f "$json_path" ]; then
        printf "\"$json_path\"; File not found!\n"
        exit 1
        fi
      ;;
    h) h_flag=''
      printf " -h    =  This option prints this help screen\n\n"
      printf " -a    =  This option overides alpha-2 code and uses another option\n"
      printf "          For example; '-a HU' will use the hungarian HU country code to find the 'hungarian' language\n"
      printf "          All country codes are in capitals only.\n"
      printf "          Country codes are refrenced to languages in /lang/iso_languages.json if your code isn't in this add it.\n\n"
      printf " -s    =  This option activates custom settlement mode\n"
      printf "          For example; '-s Exeter' will use the city Exeter instead of the settlement obtained from https://ipinfo.io/json \n"
      printf "          Settlements must be written according to wttr.in instructions.\n\n"
      printf " -e       This option enables 'espeak' mode if the program is installed.\n"
      printf "          If it is not installed, 'w2t' will try and install it for you.\n\n"
      printf " -v    =  This option prints a verbose weather report\n\n"
      exit 1
      ;;
    s) W2T_SETTLE="$OPTARG"
      # activates custom settlement mode
      ;;
    v) W2T_VERBOS="true"
      # activates verbose mode
      ;;
    \?)
      echo "invalid option $W2T_OPTIONS" 1>&2
       exit 1
       ;;
  esac
done

#-----------------------------------------------------------------------------------
#-----------------------------------Source list-------------------------------------
#-----------------------------------------------------------------------------------


if [ -f "$script_dir/components/install_dependencies.sh" ]; then
  #echo "Sourcing install_dependencies.sh..."
  source "$script_dir/components/install_dependencies.sh"
else
  echo "install_dependencies.sh not found!"
  exit 1
fi

if [ -f "$script_dir/components/json_handling.sh" ]; then
  #echo "Sourcing json_handling.sh..."
  source "$script_dir/components/json_handling.sh"
else
  echo "json_handling.sh not found!"
  exit 1
fi

if [ -f "$script_dir/components/w2t_extract_data_from_weather_string.sh" ]; then
  #echo "Sourcing w2t_extract_data_from_weather_string.sh..."
  source "$script_dir/components/w2t_extract_data_from_weather_string.sh"
else
  echo "w2t_extract_data_from_weather_string.sh not found!"
  exit 1
fi

if [ -f "$script_dir/components/w2t_alpha_code_handling.sh" ]; then
  #echo "Sourcing w2t_alpha_code_handling.sh..."
  source "$script_dir/components/w2t_alpha_code_handling.sh"
else
  echo "w2t_alpha_code_handling.sh not found!"
  exit 1
fi

if [ -f "$script_dir/components/w2t_emoji_convert.sh" ]; then
  #echo "Sourcing w2t_emoji_convert.sh..."
  source "$script_dir/components/w2t_emoji_convert.sh"
else
  echo "w2t_emoji_convert.sh not found!"
  exit 1
fi

if [ -f "$script_dir/components/w2t_structure_report.sh" ]; then
  #echo "Sourcing w2t_structure_report.sh.sh..."
  source "$script_dir/components/w2t_structure_report.sh"
else
  echo "w2t_structure_report.sh not found!"
  exit 1
fi

if [ -f "$script_dir/config/variables.sh" ]; then
  #echo "Sourcing variables.sh..."
  source "$script_dir/config/variables.sh"
else
  echo "Configuration file not found!"
  exit 1
fi

#---------------------------------------------------------
#------------------Insta$OPTARGll Dependencies-------------------
#---------------------------------------------------------
# The following use; install_dependencies.sh

# Check that 'jq' is installed by calling install_dependencies.sh, if not ask user to install it
w2t_install_jq
# Check that 'curl' is installed by calling install_dependencies.sh, if not ask user to install it
w2t_install_curl


#---------------------------------------------------------
#-----------------Get JSON location data------------------
#---------------------------------------------------------
# The following uses; json_handling.sh

# Download JSON file and extract info using "jq"
w2t_download_json
#returns;  $JSON_HANDLING_CITY        # e.g., Plymouth
#returns;  $JSON_HANDLING_COUNTRY"    # e.g., UK (Alpha-2 Codes accepted)

# if "-s $OPTARG" is not equal to true then use $OPTARG.
 if [ $W2T_SETTLE != "false" ]; then
   JSON_HANDLING_CITY="$W2T_SETTLE"
 fi

# if "-a $OPTARG" is not equal to true then use $OPTARG.
 if [ $W2T_ALPHA2 != "false" ]; then
   JSON_HANDLING_COUNTRY="$W2T_ALPHA2"
 fi

#---------------------------------------------------------
#---use JSON location data to get (curl) weather report---
#---------------------------------------------------------

# Curl wttr.in for weather report using JSON data
w2t_download_wttr
#returns; $JSON_HANDLING_WEATHER_CURL" # this is the full weather report in emoji form

#---------------------------------------------------------
#-------------wttr.in extract data from string------------
#---------------------------------------------------------
# The following uses; w2t_extract_data_from_weather_string.sh


w2t_extract_weather_emoji
#returns;"$W2T_EXTRACTED_EMOJI"

w2t_extract_wind_direction
#echo for showing extracted wind direction
#echo "$W2T_EX#echo "City: $JSON_HANDLING_CITY"        # e.g., Plymouth
#echo "Country: $JSON_HANDLING_COUNTRY" TRACTED_WIND_DIRECTION"

w2t_extract_windspeed
#returns; $W2T_EXTRACTED_WINDSPEED"Km/h" #write options for mph and mps

w2t_extract_temprature
#returns; $W2T_EXTRACTED_TEMPRATURE"°c" # write options for "f"

w2t_extract_temprature_symbol
#returns; $W2T_EXTRACTED_SYMBOL


#---------------------------------------------------------
# turn emoji into text for better handling
#---------------------------------------------------------
#the following use w2t_emoji_convert.sh

w2t_emoji_convert_weather
#returns; $W2T_EMOJI_WEATHER_TXT
w2t_emoji_convert_wind
#returns; $W2T_EMOJI_ARROW_TXT

#---------------------------------------------------------
#---------------------Get Language Data-------------------
#---------------------------------------------------------
w2t_code_to_lang
#echo $W2T_GET_LANG


#---------------------------------------------------------
#------------------Print Weather Report-------------------
w2t_structure_report
#returns; $W2T_REPORT_WIND
#returns; $W2T_REPORT_WEATHER
#returns; $W2T_STRUCTURE_REPORT_HELLO_GREETING

# if the -v verbose flag is used this will add more information
if $W2T_VERBOS = "true"; then
  printf "\nWeather report from 'wttn.io'; '\e[1;32m$JSON_HANDLING_WEATHER_CURL\e[0m'\n\n"

  printf "  w2t has extracted the '$W2T_EXTRACTED_EMOJI' emoji and translated it as; \e[1;32m$W2T_EMOJI_WEATHER_TXT\e[0m\n"
  printf "  w2t has extracted the '\e[1;32m$W2T_EXTRACTED_WIND_DIRECTION\e[0m' arrow and translated it as; \e[1;32m$W2T_EMOJI_ARROW_TXT\e[0m\n"
  printf "  w2t has extracted the temprature ('\e[1;32m$W2T_EXTRACTED_TEMPRATURE\e[0m') in words it's; \n"
    printf "  w2t has extracted the windspeed '\e[1;32m$W2T_EXTRACTED_WINDSPEED\e[0m'). in words it's; \n\n"
  printf "Queried settlement name; \e[1;32m$JSON_HANDLING_CITY\e[0m\n"
  printf "Current ISO 3166-1 alpha-2 code; \e[1;32m$JSON_HANDLING_COUNTRY\e[0m\n\n"
fi

printf "$W2T_STRUCTURE_REPORT_HELLO_GREETING\n"
printf "$W2T_REPORT_WIND\n" # | espeak -v hu
printf "$W2T_REPORT_WEATHER\n"



#---------------------------------------------------------
#-----------------------NOTES-----------------------------

# [x] add greeting related to time of day                                                        -needs testing
# this will get your user name not "whoami"                                                      -needs testing
# cat /etc/passwd | grep $(whoami) | cut -d: -f 5
# [x] make sure that a parse this name because some people dont have a user name just whoami

# [x] add negitive number for temp                                                               -needs testing

# [ ] add espeak intigration
# ./w2t.sh -a HU | espeak-ng -v hu
