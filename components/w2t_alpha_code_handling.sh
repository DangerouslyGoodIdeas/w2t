#!/bin/bash
# by Rob-niX

#displays country code and language
#jq -r 'to_entries[] | "\(.value[0])"' iso_languages.json

# pulls language from country code in this case using AF
#jq -r '.AF[0]' iso_languages.json

#displays every unique language.
#jq -r 'to_entries | .[].value[]' iso_languages.json | sort | uniq

w2t_code_to_lang(){
    local script_dir json_path
    script_dir=$(dirname "$(realpath "$0")")
    json_path="$script_dir/lang/iso_languages.json"
    W2T_GET_LANG=$(jq -r '.'$JSON_HANDLING_COUNTRY'[0]' $json_path)
    #echo "in the country; $JSON_HANDLING_COUNTRY they speak $W2T_GET_LANG"
    #echo $script_dir
}
