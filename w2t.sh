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

      W2T_GET_A_CODE=$(jq -r '.'$W2T_ALPHA2'[0]' $json_path)
        if [ $W2T_GET_A_CODE == "null" ];
          then
          printf "this is not a valid alpha-2 country code\n"
          exit 1
        fi
          json_path="$script_dir/lang/Hungarian.json"
        if [ ! -f "$json_path" ]; then
        printf "\"$json_path\"; File not found!\n"
        exit 1
        fi
          json_path="$script_dir/lang/Hungarian-numbers.json"
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
#--------------Check install_dependencies.sh--------------
#---------------------------------------------------------

# Check that 'jq' is installed by calling install_dependencies.sh, if not ask user to install it
w2t_install_jq
# Check that 'curl' is installed by calling install_dependencies.sh, if not ask user to install it
w2t_install_curl


#---------------------------------------------------------
#-----------------Get JSON location data------------------
#---------------------------------------------------------


w2t_download_json
# Download JSON file and extract info using "jq".

# w2t_download_json Output
#echo "City: $JSON_HANDLING_CITY"        # e.g., Plymouth
#echo "Country: $JSON_HANDLING_COUNTRY"  # e.g., UK (Alpha-2 Codes accepted)
#

 if [ $W2T_SETTLE != "false" ]; then
   JSON_HANDLING_CITY="$W2T_SETTLE"
 fi


 if [ $W2T_ALPHA2 != "false" ]; then
   JSON_HANDLING_COUNTRY="$W2T_ALPHA2"
 fi

#---------------------------------------------------------
#---use JSON location data to get (curl) weather report---
#---------------------------------------------------------

# Curl wttr.in for weather report using JSON data
w2t_download_wttr
#echo "Weather Report: $JSON_HANDLING_WEATHER_CURL"

#---------------------------------------------------------
#-------------wttr.in extract data from string------------
#---------------------------------------------------------
w2t_extract_weather_emoji
#echo for showing extracted weather emoji
#echo "$W2T_EXTRACTED_EMOJI"

w2t_extract_wind_direction
#echo for showing extracted wind direction
#echo "$W2T_EX#echo "City: $JSON_HANDLING_CITY"        # e.g., Plymouth
#echo "Country: $JSON_HANDLING_COUNTRY" TRACTED_WIND_DIRECTION"

w2t_extract_windspeed
#echo $W2T_EXTRACTED_WINDSPEED"Km/h" #write options for mph and mps

w2t_extract_temprature
#echo $W2T_EXTRACTED_TEMPRATURE"°c" # write options for "f"

#---------------------------------------------------------
# turn emoji into text for better handling

w2t_emoji_convert_weather
#echo "$W2T_EMOJI_WEATHER_TXT"
w2t_emoji_convert_wind
#echo "$W2T_EMOJI_ARROW_TXT"

#---------------------------------------------------------
#---------------------Get Language Data-------------------
#---------------------------------------------------------
w2t_code_to_lang
#echo $W2T_GET_LANG


#---------------------------------------------------------
#------------------Print Weather Report-------------------
w2t_structure_report

# if the -v verbose flag is used this will add more information
if $W2T_VERBOS = "true"; then

  printf "\nWeather report from wttn.io; $JSON_HANDLING_WEATHER_CURL\n\n"

  printf "Queried settlement name; $JSON_HANDLING_CITY\n"
  printf "Current ISO 3166-1 alpha-2 code; $JSON_HANDLING_COUNTRY\n\n"
fi

printf "$W2T_REPORT_WIND\n"
#printf "$W2T_REPORT_WIND\n" | espeak -v hu
printf "$W2T_REPORT_WEATHER\n"
#printf "$W2T_REPORT_WEATHER\n" | espeak -v hu


#---------------------------------------------------------
#-----------------------NOTES-----------------------------

# this will get your user name not "whoami"
# cat /etc/passwd | grep $(whoami) | cut -d: -f 5
# make sure that a parse this though because some people dont have a user name just whoami

#add negitive number for temp
