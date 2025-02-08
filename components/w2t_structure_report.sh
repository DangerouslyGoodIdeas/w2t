#!/bin/bash
w2t_structure_report(){

    local json_lang_dir

    # find current path
    json_lang_dir=$(dirname "$(realpath "$0")")
    #echo "json_lang_dir= $json_lang_dir"

    # Find JSON language file and catalogue it.
    json_lang_file="$json_lang_dir/lang/$W2T_GET_LANG.json"
    #echo "$json_lang_file"
    #echo "-------------"
    #json_lang_catalogue="$json_lang_file"

    #pull emojis
    #weather
    lang_weather_emoji=$(jq -r .weather_type_emoji.$W2T_EMOJI_WEATHER_TXT "$json_lang_file")
    #echo "lang_weather_emoji = $lang_weather_emoji"
    #wind
    lang_wind_emoji=$(jq -r .wind_direction_emoji.$W2T_EMOJI_ARROW_TXT "$json_lang_file")
    #echo "lang_wind_emoji = $lang_wind_emoji"

    # Find JSON language numbers file and catalogue it.
    json_lang_numbers_file="$json_lang_dir/lang/$W2T_GET_LANG-numbers.json"
    #echo "$json_lang_numbers_file"
    #echo "<$W2T_EXTRACTED_WINDSPEED>"
    #echo "-------------"
    # Convert numbers to text
    # example command; jq -r --arg num "31" '.number[$num]' English-numbers.json
    W2T_WINDSPEED_TO_WORDS=$(jq -r --arg num "$W2T_EXTRACTED_WINDSPEED" '.number[$num]' "$json_lang_numbers_file")
    #echo "wind speed is $W2T_WINDSPEED_TO_WORDS"

    parse_wind

    #echo parse_wind output
    #echo $W2T_REPORT_WIND #| festival --tts

    parse_weather

    #echo "$W2T_REPORT_WEATHER" #| espeak

}


parse_wind(){
#get your mind out the gutter
#first_chunk
#really.. ..I am talking about chunks of sentences.
    parse_wind_first_chunk=$(jq -r .wind_sentence.first_chunk "$json_lang_file")
    parse_wind_kmh=$(jq -r .variables.language_kmh_words "$json_lang_file")

    if [[ "$parse_wind_first_chunk" = "WIND" ]]; then
        parsed_wind_first_chunk="$lang_wind_emoji"
        else
            if [[ "$parse_wind_first_chunk" = "SPEED" ]]; then
            parsed_wind_first_chunk="$W2T_WINDSPEED_TO_WORDS $parse_wind_kmh"
            else
            parsed_wind_first_chunk="$parse_wind_first_chunk"
            fi
    fi
    #test chunk
    #echo "$parsed_wind_first_chunk"

#second_chunk
    parse_wind_second_chunk=$(jq -r .wind_sentence.second_chunk "$json_lang_file")

    if [[ "$parse_wind_second_chunk" = "WIND" ]]; then
        parsed_wind_second_chunk="$lang_wind_emoji"
        else
            if [[ "$parse_wind_second_chunk" = "SPEED" ]]; then
            parsed_wind_second_chunk="$W2T_WINDSPEED_TO_WORDS $parse_wind_kmh"
            else
            parsed_wind_second_chunk="$parse_wind_second_chunk"
            fi
    fi
    #test chunk
    #echo "$parsed_wind_second_chunk"

#third_chunk
    parse_wind_third_chunk=$(jq -r .wind_sentence.third_chunk "$json_lang_file")

    if [[ "$parse_wind_third_chunk" = "WIND" ]]; then
        parsed_wind_third_chunk="$lang_wind_emoji"
        else
            if [[ "$parse_wind_third_chunk" = "SPEED" ]]; then
            parsed_wind_third_chunk="$W2T_WINDSPEED_TO_WORDS $parse_wind_kmh"
            else
            parsed_wind_third_chunk="$parse_wind_third_chunk"
            fi
    fi
    #test chunk
    #echo "$parsed_wind_third_chunk"

#fourth_chunk
    parse_wind_fourth_chunk=$(jq -r .wind_sentence.fourth_chunk "$json_lang_file")

    if [[ "$parse_wind_fourth_chunk" = "WIND" ]]; then
        parsed_wind_fourth_chunk="$lang_wind_emoji"
        else
            if [[ "$parse_wind_fourth_chunk" = "SPEED" ]]; then
            parsed_wind_fourth_chunk="$W2T_WINDSPEED_TO_WORDS $parse_wind_kmh"
            else
            parsed_wind_fourth_chunk="$parse_wind_fourth_chunk"
            fi
    fi
    #test chunk
    #echo "$parsed_wind_fourth_chunk"

#fifth_chunk
    parse_wind_fifth_chunk=$(jq -r .wind_sentence.fifth_chunk "$json_lang_file")

    if [[ "$parse_wind_fifth_chunk" = "WIND" ]]; then
        parsed_wind_fifth_chunk="$lang_wind_emoji"
        else
            if [[ "$parse_wind_fifth_chunk" = "SPEED" ]]; then
            parsed_wind_fifth_chunk="$W2T_WINDSPEED_TO_WORDS $parse_wind_kmh"
            else
            parsed_wind_fifth_chunk="$parse_wind_fifth_chunk"
            fi
    fi
    #test chunk
    #echo "$parsed_wind_fifth_chunk"

#sixth_chunk
    parse_wind_sixth_chunk=$(jq -r .wind_sentence.sixth_chunk "$json_lang_file")

    if [[ "$parse_wind_sixth_chunk" = "WIND" ]]; then
        parsed_wind_sixth_chunk="$lang_wind_emoji"
        else
            if [[ "$parse_wind_sixth_chunk" = "SPEED" ]]; then
            parsed_wind_sixth_chunk="$W2T_WINDSPEED_TO_WORDS $parse_wind_kmh"
            else
            parsed_wind_sixth_chunk="$parse_wind_sixth_chunk"
            fi
    fi
    #test poop
    #echo "$parsed_wind_sixth_chunk"
    W2T_REPORT_WIND="$parsed_wind_first_chunk$parsed_wind_second_chunk$parsed_wind_third_chunk$parsed_wind_fourth_chunk$parsed_wind_fifth_chunk$parsed_wind_sixth_chunk"

}

parse_weather(){
#first_chunk
    parse_weather_first_chunk=$(jq -r .weather_sentence.first_chunk "$json_lang_file")
    parse_weather_temp=$(jq -r .variables.language_c_words "$json_lang_file")

    if [[ "$parse_weather_first_chunk" = "WEATHER" ]]; then
        parsed_weather_first_chunk="$lang_weather_emoji"
        else
            if [[ "$parse_weather_first_chunk" = "TEMPRATURE" ]]; then
            parsed_weather_first_chunk="$W2T_EXTRACTED_TEMPRATURE $parse_weather_temp"
            else
            parsed_weather_first_chunk="$parse_weather_first_chunk"
            fi
    fi
    #test chunk
    #echo "$parsed_wind_first_chunk"

#second_chunk
    parse_weather_second_chunk=$(jq -r .weather_sentence.second_chunk "$json_lang_file")

    if [[ "$parse_weather_second_chunk" = "WEATHER" ]]; then
        parsed_weather_second_chunk="$lang_weather_emoji"
        else
            if [[ "$parse_weather_second_chunk" = "TEMPRATURE" ]]; then
            parsed_weather_second_chunk="$W2T_EXTRACTED_TEMPRATURE $parse_weather_temp"
            else
            parsed_weather_second_chunk="$parse_weather_second_chunk"
            fi
    fi
    #test chunk
    #echo "$parsed_wind_second_chunk"

#third_chunk
    parse_weather_third_chunk=$(jq -r .weather_sentence.third_chunk "$json_lang_file")

    if [[ "$parse_weather_third_chunk" = "WEATHER" ]]; then
        parsed_weather_third_chunk="$lang_weather_emoji"
        else
            if [[ "$parse_weather_third_chunk" = "TEMPRATURE" ]]; then
            parsed_weather_third_chunk="$W2T_EXTRACTED_TEMPRATURE $parse_weather_temp"
            else
            parsed_weather_third_chunk="$parse_weather_third_chunk"
            fi
    fi

#fourth_chunk
    parse_weather_fourth_chunk=$(jq -r .weather_sentence.fourth_chunk "$json_lang_file")

    if [[ "$parse_weather_fourth_chunk" = "WEATHER" ]]; then
        parsed_weather_fourth_chunk="$lang_weather_emoji"
        else
            if [[ "$parse_weather_fourth_chunk" = "TEMPRATURE" ]]; then
            parsed_weather_fourth_chunk="$W2T_EXTRACTED_TEMPRATURE $parse_weather_temp"
            else
            parsed_weather_fourth_chunk="$parse_weather_fourth_chunk"
            fi
    fi
    #test chunk
    #echo "$parsed_wind_fourth_chunk"

#fifth_chunk
    parse_weather_fifth_chunk=$(jq -r .weather_sentence.fifth_chunk "$json_lang_file")

    if [[ "$parse_weather_fifth_chunk" = "WEATHER" ]]; then
        parsed_weather_fifth_chunk="$lang_weather_emoji"
        else
            if [[ "$parse_weather_fifth_chunk" = "TEMPRATURE" ]]; then
            parsed_weather_fifth_chunk="$W2T_EXTRACTED_TEMPRATURE $parse_weather_temp"
            else
            parsed_weather_fifth_chunk="$parse_weather_fifth_chunk"
            fi
    fi
    #test chunk
    #echo "$parsed_wind_fifth_chunk"

#sixth_chunk
    parse_weather_sixth_chunk=$(jq -r .weather_sentence.sixth_chunk "$json_lang_file")

    if [[ "$parse_weather_sixth_chunk" = "WEATHER" ]]; then
        parsed_weather_sixth_chunk="$lang_weather_emoji"
        else
            if [[ "$parse_weather_sixth_chunk" = "TEMPRATURE" ]]; then
            parsed_weather_sixth_chunk="$W2T_EXTRACTED_TEMPRATURE $parse_weather_temp"
            else
            parsed_weather_sixth_chunk="$parse_weather_sixth_chunk"
            fi
    fi
    #test chunk
    #echo "$parsed_wind_sixth_chunk"



W2T_REPORT_WEATHER="$parsed_weather_first_chunk$parsed_weather_second_chunk$parsed_weather_third_chunk$parsed_weather_fourth_chunk$parsed_weather_fifth_chunk$parsed_weather_sixth_chunk"

}

