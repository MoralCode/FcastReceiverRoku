
## Install
The methods of installing this channel are (from most to least stable)...

<!-- through the store -->
<!-- through the store with a code -->
### Building and installing from source
THis install method will require your roku device to be in developer mode.

`npm install`

To just run a non-development build/generate the .zip to install via developer mode:
`npm run build`

<details>
<summary>Super-manual stuff</summary>

To deploy to a roku device in dev mode manually:
`bsc --deploy --host <IP ADDRESS> --password <PASSWORD>`

</details>

## Features
| Feature | Supported | Tested by |
| ------- | --------- | --------- |
| MP4 playback | :heavy_check_mark:  | printf + netcat with big buck bunny url from google |
| DASH playback | :x: | terminal sender |
| V2: set speed | :x: | terminal sender/grayjay |
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

Manual builds can be generated for upload to the tv using `npm run build:dev`. Uploading this way may not provide all of the debugging features, line highlighting on errors, or other niceties of the extension.

### Troubleshooting
Sometimes, simply running a dev build can help get things un-stuck if "build and run" from vscode causes the tv to make the "roku bonk" noise but the channel doesn't open. Checking the extension logs are another way to potentially get more info on what happened 


## Testing Options

Testing protocol support can be done in several ways

printf + netcat with big buck bunny url from google:
```
printf "\x73\x00\x00\x00\x01{\"container\":\"video/mp4\",\"url\":\"http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4\"}" | nc IP_ADDRESS 46899
```

[FCast Sender terminal client](https://gitlab.futo.org/videostreaming/fcast/-/tree/master/senders/terminal?ref_type=heads) (rust):


Using an app with support, such as Grayjay


## Credits, Licensing, and Disclaimers

Thanks to FUTO for making the open source FCast protocol!

Thanks to @vadymbl for writing the [video player UI](https://github.com/vadymbl/roku-custom-video)(BSD-0 Licensed) and sample channel that was used as the basis for this project's own player UI.

Thanks to the Roku Developers for the documentation of the brightscript language and hello world sample code this channel used to get started.

Minimal or no AI was used in the main branch of this channel (attempts were made and they were not good enough to continue trying).