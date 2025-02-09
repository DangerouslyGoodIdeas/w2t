#!/bin/bash
# "Dangerously Good Ideas" by Rob-niX

#emoji_convert

# wttr_to_txt_download() {
# #    echo "...downloading a weather report for your area"
#
#     # location grab from closest public IP address
#     json_content=$(curl -s https://ipinfo.io/json)
#     #extracts .city information from json file
#     city_name=$(jq -r '.city' <<<"$json_content")
#     # grabs the weather report using
#     weather_report=$(curl -s wttr.in/$city_name\?format=2)
# } && wttr_to_txt_download
# #hot city for testing
# #weather_report=$(curl -s wttr.in/Ouargla\?format=2)
#
#
# #created a function so it can be refrenced by other aplications
# wttr_auto_report() {
# echo $weather_report
# }
# wttr_auto_report

#echo $weather_emoji
#-------------------------
w2t_emoji_convert_weather() {
    #pulls out the weather weather_emoji from the weather_report curl command.
    #weather_emoji=${weather_report:0:1}
    #weather_text=$"The weather today in $city_name"
    #echo -n "$weather_text "

    case $W2T_EXTRACTED_EMOJI in
    #sunny emoji
        ☀)
        W2T_EMOJI_WEATHER_TXT="black_sun_with_rays"
        #printf "has a high likelyhood of being clear. "
        ;;
    #cloudy
        ☁️)
        W2T_EMOJI_WEATHER_TXT="cloud"
        #printf "has a high likelyhood of being cloudy. "
        ;;
    #partly cloudy
        ⛅)
        W2T_EMOJI_WEATHER_TXT="sun_behind_cloud"
        #printf "has a high likelyhood of being partly cloudy. "
        ;;
    #mist/fog
        🌦)
        W2T_EMOJI_WEATHER_TXT="sun_behind_rain_cloud"
        #printf "has a likelyhood of being partly cloudy with rain. "
        ;;

        ⛈️)
        W2T_EMOJI_WEATHER_TXT="thunder_cloud_and_rain"
        #printf "may thunder and rain. "
        ;;
    #snow
        ❄️)
        W2T_EMOJI_WEATHER_TXT="snowflake"
        #printf "has a likelyhood of snowing. "
        ;;
    #heavy rain
        🌧️)
        W2T_EMOJI_WEATHER_TXT="cloud_with_rain"
        #printf "is condusive of heavy rain. "
        ;;
    #blizzard
        🌨)
        W2T_EMOJI_WEATHER_TXT="cloud_with_snow"
        #printf "is condusive of a blizzard. "
        ;;
    #lightening
        🌩️)
        W2T_EMOJI_WEATHER_TXT="cloud_with_lightening"
        #printf "is condusive of lightening. "
        ;;

        🌫)
        W2T_EMOJI_WEATHER_TXT="fog"
        #printf "is foggy. "
        ;;

        *)
        W2T_EMOJI_WEATHER_TXT="unknown"
        #printf "is unusual. "
        ;;
    esac
}

w2t_emoji_convert_wind() {

    #prints appropiate wind emoji to the screen
    case $W2T_EXTRACTED_WIND_DIRECTION in
    #north
        ↑)
        W2T_EMOJI_ARROW_TXT="north_arrow"
        ;;
    #north esat
        ↗)
        W2T_EMOJI_ARROW_TXT="north_east_arrow"
        ;;
    #east
        →)
        W2T_EMOJI_ARROW_TXT="east_arrow"
        ;;
    #south-east
        ↘)
        W2T_EMOJI_ARROW_TXT="south_east_arrow"
        ;;
    #south
        ↓)
        W2T_EMOJI_ARROW_TXT="down_arrow"
        ;;
    #south west
        ↙)
        W2T_EMOJI_ARROW_TXT="south_west_arrow"
        ;;
    #west
        ←)
        W2T_EMOJI_ARROW_TXT="west_arrow"
        ;;
    #south east
        ↖)
        W2T_EMOJI_ARROW_TXT="north_west_arrow"
        ;;
    #nonexistant. this is an error handling msg. I think the wind is constantly displayed
        *)
        W2T_EMOJI_ARROW_TXT="nonexistent"
        ;;
    esac
}
