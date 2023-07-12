# IPS2DevKit

A Roblox Studio plugin to assist with [In Plain Sight 2](https://www.roblox.com/games/2901172949) content development, such as maps or character submissions.

As of version `0.2.0`, the plugin can insert utility dummies, assets for map development, and has a map linter to ensure maps comply with the proper format.

## Developing

First, enable `Reload plugins on file changed` in the Roblox Studio settings.

Next, run the following command on Windows:
```bash
rojo build default.project.json -o $env:LOCALAPPDATA/Roblox/Plugins/IPS2DevKit.rbxm --watch
```