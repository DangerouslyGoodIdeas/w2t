#!/bin/bash
# "Dangerously Good Ideas" by Rob-niX

w2t_download_json() {
# $VAR_IPINFO_NO_HTTP  =  ipinfo.io/json



local json_content
if curl -s --head --request GET "$VAR_IPINFO_NO_HTTP" | grep "200 OK" > /dev/null; then
    # Location grab from closest public IP address
    json_content=$(curl -s "$VAR_IPINFO_NO_HTTP")

    # Debugging: Check the JSON content to ensure we're getting the correct response
    #echo "Received JSON: $json_content"

    # Extract .city and .country from the JSON content using jq
    JSON_HANDLING_CITY=$(jq -r '.city' <<<"$json_content")
    JSON_HANDLING_COUNTRY=$(jq -r '.country' <<<"$json_content")

    #------------------------------------------------------------
    # Output the extracted city and country if nothings wrong
    #------------------------------------------------------------
    #echo "Json handling City: $JSON_HANDLING_CITY"
    #echo "JSON_HANDLING country: $JSON_HANDLING_COUNTRY"
else
    echo "ipinfo.com is DOWN or you're having connection issues. Try again later!"
    exit 1
fi
}
# curl wttr.in for weather report using json data
w2t_download_wttr() {
if curl -s --head  --request GET "wttr.in" | grep "200 OK" > /dev/null;
    then
        # grabs the weather report using
        JSON_HANDLING_WEATHER_CURL=$(curl -s wttr.in/$JSON_HANDLING_CITY\?format=2)
    else
        echo "wttr.in is DOWN or, your having connection issues. Try again later!";
        exit 1
    fi


}
