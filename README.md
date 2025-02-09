# w2t  
This script converts ***w***ttr.in information into (***2***) readable ***t***ext.

### Introduction  
I wrote this to learn more about BASH scripting for my ***Debian***-based ***Linux*** system. Someone may find it useful. It takes an online weather report and reconfigures it into human-readable text. It might be useful for people with disabilities or just fun to use when piped into "espeak" or "espeak-ng."  

To use it with `espeak-ng`, you can run:  
```bash
./w2t.sh | espeak-ng -v en-gb-x-rp
```

All sentence information is stored in JSON files. This allows you to copy and edit them according to your country's language requirements.

### Features  

- Grabs wttr.in (format2) data using a `curl` command and separates it:
    - Separates the weather emoji
    - Separates wind direction
    - Separates wind speed
    - Separates temperature  
        - Handles "+" or "-" temperature values  
- Translates data into usable strings:
    - Weather emoji → `$W2T_EMOJI_WEATHER_TXT`
    - Arrow emoji → `$W2T_EMOJI_ARROW_TXT`
- JSON multi-language support:
    - Sentence builder  
    - Number-to-text conversion:  
        - Wind speed conversion to text  
        - Temperature value conversion (including support for negative numbers)  
- Uses the username from the login screen instead of `$USER` if possible  

### Example
```bash
user@machine:~/git/git/DangerouslyGoodIdeas/w2t$ ./w2t.sh
    Good evening Real Name
    The wind is blowing from the northeast towards the southwest at ten kilometers an hour.
    The weather near you looks to be foggy with a temperature of four degrees Celsius.
```

### Usage  
In its basic form, `w2t` gets a weather report from `wttr.in` and, using your local IP data, builds a weather report.  
This report uses your country's alpha-2 code to determine the language.  

```bash
./w2t.sh
```

#### -h  
Displays a help screen:  
```bash
./w2t.sh -h
```

#### -a  
Overrides the alpha-2 country code:  
For example, `-a HU` will use the Hungarian `HU` country code to find the Hungarian language.  
All country codes must be in uppercase.  
Country codes are referenced to languages in `/lang/iso_languages.json`. If your code isn't listed, you can add it.  
```bash
./w2t.sh -a HU
```

#### -s  
Activates custom settlement mode:  
For example, `-s Exeter` will use the city Exeter instead of the settlement obtained from `https://ipinfo.io/json`.  
Settlements must be written according to `wttr.in` instructions.  
```bash
./w2t.sh -s Exeter
```

#### -e  
Enables 'espeak' mode if the program is installed.  
If it is not installed, `w2t` will attempt to install it for you.  
```
This is a placeholder; espeak integration is a work in progress.
```

#### -v  
Prints a verbose weather report:  
```bash
./w2t.sh -v
```

