# IPS2DevKit

Tools to assist with [In Plain Sight 2](https://www.roblox.com/games/2901172949) content development, such as maps or character submissions. Specifically, a Roblox Studio plugin and a documentation website.

To learn more, go to the [documentation](https://crystalflxme.github.io/IPS2DevKit/) website.

## Installing

To install the Roblox Studio plugin, go to the [latest release](https://github.com/Crystalflxme/IPS2DevKit/releases/latest) and download the `IPS2DevKit.rbxm` attachment. Place this file in your plugins folder after deleting any old versions, if you have any.

## Developing

First, enable `Reload plugins on file changed` in the Roblox Studio settings.

Next, run the following command on Windows:
```bash
rojo build -o $env:LOCALAPPDATA/Roblox/Plugins/IPS2DevKit.rbxm --watch
```

There is also a test place Rojo project provided.
