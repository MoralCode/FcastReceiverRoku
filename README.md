
## Install
The methods of installing this channel are (from most to least stable)...

<!-- through the store -->
<!-- through the store with a code -->
### Building and installing from source
THis install method will require your roku device to be in developer mode.

`npm install brighterscript -g`



## Setting up the IDE for development

Install the [BrightScript language extension](https://open-vsx.org/vscode/item?itemName=RokuCommunity.brightscript) for vscode.

Create a file at `.vscode/.env` with the following contents
```
ROKU_HOST=<IP of your Roku>
ROKU_PASSWORD=<development password you set when enabling dev mode>
```