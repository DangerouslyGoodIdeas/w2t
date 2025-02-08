#!/bin/bash
# "Dangerously Good Ideas" by Rob-niX

#----------------------------------------------------------------------------
#--------------------------Extract Data from Emoji---------------------------
#----------------------------------------------------------------------------

#Extract weather emoji
w2t_extract_weather_emoji(){
    W2T_EXTRACTED_EMOJI=${JSON_HANDLING_WEATHER_CURL:0:1}
    #echo "$W2T_EXTRACTED_EMOJI"
}

#Extract Temprature
w2t_extract_temprature() {
  # Define symbols
  themometer_emoji="🌡"
  degrees_symbol="°"

  # Find positions of symbols
  temprature_start_position=$(expr index "$JSON_HANDLING_WEATHER_CURL" "$themometer_emoji")
  temprature_end_position=$(expr index "$JSON_HANDLING_WEATHER_CURL" "$degrees_symbol")

  #echo "The character '$themometer_emoji' is at position $temprature_start_position"
  #echo "The character '$degrees_symbol' is at position $temprature_end_position"

  # Compute offsets
  temprature_start_offset=$((temprature_start_position + 2))
  temprature_end_offset=$((temprature_end_position - 1))

  # Extract the substring
  wind_speed_var_length=$((temprature_end_offset - temprature_start_offset))
  W2T_EXTRACTED_TEMPRATURE=${JSON_HANDLING_WEATHER_CURL:$temprature_start_offset:$wind_speed_var_length}

  #echo "Extracted temperature: $W2T_EXTRACTED_TEMPRATURE"
}

#Extract Wind Direction
w2t_extract_wind_direction(){
    local wind_emoji emoji_position wind_emoji_offset
    #wind direction
    # defines emoji to track
    wind_emoji="🌬"
    # weather_report=$(curl -s wttr.in/$city_name\?format=2)
    #pulls the index of $wind emoji from $weather_report
    emoji_position=$(expr index "$JSON_HANDLING_WEATHER_CURL" "wind_emoji")
    #offset=$("5")
    #echo "The character '$wind_emoji' is at position $emoji_position"

    #offsets the position of the wind emoji to find the arrow position
    wind_emoji_offset=$(( $emoji_position - 5 ))
    #uncomment to see the wind offset value
    #echo "offset for wind is $wind_emoji_offset"

    #pulls the wind emoji from the $weather_report.
    W2T_EXTRACTED_WIND_DIRECTION=${JSON_HANDLING_WEATHER_CURL:$wind_emoji_offset:1}
    #test output
    #echo $W2T_EXTRACTED_WIND_DIRECTION
}

# #Extract Wind Speed
 w2t_extract_windspeed(){
    local wind_emoji emoji_position letter_k wind_speed_end_position wind_speed_start_offset wind_speed_end_offset wind_speed_var_length
     wind_emoji="🌬"
    # weather_report=$(curl -s wttr.in/$city_name\?format=2)
    #pulls the index of $wind emoji from $weather_report
    emoji_position=$(expr index "$JSON_HANDLING_WEATHER_CURL" "wind_emoji")
    #offset=$("5")
    #echo "The character '$wind_emoji' is at position $emoji_position"

    #wind_emoji_offset=$(( $emoji_position - 5 ))
    letter_k_="k"

    #find the position of the letter k in $weather_report
    wind_speed_end_position=$(expr index "$JSON_HANDLING_WEATHER_CURL" "letter_k")
    #emoji_position=$(expr index "$weather_report" "wind_emoji")
    #using the emoji position from earlier count -4 to find start of the windspeed
    wind_speed_start_offset=$(( $emoji_position - 4 ))
    #using the $wind_speed_end_position, count 1 space back to find the actual end point
    wind_speed_end_offset=$(( $wind_speed_end_position - 1 ))
    #subtract numbers to get length of string
    wind_speed_var_length=$(( $wind_speed_end_offset - $wind_speed_start_offset ))
    #the script needs this so the command line appears in the correct place!
    W2T_EXTRACTED_WINDSPEED=${JSON_HANDLING_WEATHER_CURL:$wind_speed_start_offset:$wind_speed_var_length}

    #echo $W2T_EXTRACTED_WINDSPEED
 }
