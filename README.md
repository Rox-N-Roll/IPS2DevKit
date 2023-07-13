# IPS2DevKit

Tools to assist with [In Plain Sight 2](https://www.roblox.com/games/2901172949) content development, such as maps or character submissions.

To learn more, go to the [documentation](https://crystalflxme.github.io/IPS2DevKit/) website.

## Building

At the moment, the only way to use the plugin is to build it yourself using [Rojo](https://github.com/rojo-rbx/rojo).

## Developing

First, enable `Reload plugins on file changed` in the Roblox Studio settings.

Next, run the following command on Windows:
```bash
rojo build default.project.json -o $env:LOCALAPPDATA/Roblox/Plugins/IPS2DevKit.rbxm --watch
```

There is also a test place Rojo project provided.
