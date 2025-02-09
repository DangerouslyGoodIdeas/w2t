# w2t 
This script converts ***w***ttr.in information into (***2***) readable ***t***ext.
### Introduction
I wrote this so I could learn more BASH scripting. Someone may find it useful. It takes an online weather report and reconfigures it into human-readable text. It might be useful for people with disabilities or, even just fun to use when piped into "espeak". 

I put all the sentence information in JSON files. This way you can copy one and edit according to your own country's language requirements.


### Features

List of features
- [x] Grabs wttr.in (=format2) data using a curl command, then seperates it.
    - [x] Seperates the weather emoji
    - [x] Seperates wind direction
    - [x] Seperates wind speed
    - [x] Seperates temprature
        - [ ] Seperates "+" or "-" value.
- [x] Translates data into usable strings
    - [x] weather emoji = $W2T_EMOJI_WEATHER_TXT
    - [x] arrow emoji = $W2T_EMOJI_ARROW_TXT
- [x] JSON multi-language support
    - [x] sentence builder
    - [x] number to text conversion
        - [x] Wind speed number to text conversion.
        - [ ] temprature value to text.
            - [ ] Support for negitive temprature numbers.
    - [ ]     
