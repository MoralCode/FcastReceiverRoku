
## Install
The methods of installing this channel are (from most to least stable)...

<!-- through the store -->
<!-- through the store with a code -->
### Building and installing from source
THis install method will require your roku device to be in developer mode.

`npm install brighterscript -g`

To just run a build/generate the .zip manually:
`bsc` or `npm run build`

To deploy to a roku device in dev mode manually:
`bsc --deploy --host <IP ADDRESS> --password <PASSWORD>`

## Features
| Feature | Supported | Tested by |
| ------- | --------- | --------- |
| MP4 playback | :heavy_check_mark:  | printf + netcat with big buck bunny url from google |
| DASH playback | :x: | terminal sender |
| set speed | :x: | terminal sender/grayjay |
| set volume | :x: | terminal sender |
| report playback progress | :x: | terminal sender/grayjay |
| seek, pause, stop, resume | :x: | terminal sender/grayjay |
| Image playlist | :x: | terminal sender |
| video playlist | :x: | terminal sender |

<!-- :heavy_check_mark: :warning: :x: -->

## Setting up the IDE for development

Install the [BrightScript language extension](https://open-vsx.org/vscode/item?itemName=RokuCommunity.brightscript) for vscode or a compatible IDE (such as Vscodium).

Create a file at `.vscode/.env` with the following contents
```
ROKU_HOST=<IP of your Roku>
ROKU_PASSWORD=<development password you set when enabling dev mode>
```

The build and run and debug tooling within vscode works to allow you build and run (in debug mode) the roku channel on a real device.
