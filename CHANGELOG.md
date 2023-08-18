# IPS2DevKit Changelog

## Unreleased Changes
* Added support for CamLocations and NPCSpawns in conditionals
* Added support for a nonstrict NPCSpawns directory
* Added support for the DisplayAction attribute
* Added a lint for a Geometry folder

## [v0.7.0] - August 8, 2023
* Added a lint group for Conditionals
* Added a section for Conditionals
* Added LinkedItem support
* Added an unneeded LinkedItem lint
* Added a lint to prevent nested items
* Added support for a nonstrict items directory
* Updated map tags to newest map format version
* Updated the Studio plugin toolbar
* Removed lint for stray items
* Removed SpecialItem lints

[v0.7.0]: https://github.com/Crystalflxme/IPS2DevKit/releases/tag/v0.7.0

## [v0.6.0] - July 30, 2023
* Added a lint to prevent scripts in maps
* Added Map Items, Map NPCSpawns, Map Clipping sections
* Added lints to tagged instances to ensure they are descendants of their respective map folder
* Added VisProblems subjects to more lints
* Added Event_Banana_Station map tag
* Changed the color of Clip_Player to differ from Clip_Bounds
* Changed the PanelGroup dropdown visual
* Fixed entrance linting throwing an error if a node wasn't found

[v0.6.0]: https://github.com/Crystalflxme/IPS2DevKit/releases/tag/v0.6.0

## [v0.5.0] - July 17, 2023
* Added a "Map Entrances" section for utility relating to entrances
* Inserted camera locations are now automatically named, if the folders exist
* Dummies now parented to the selected object otherwise workspace
* Added lints for the SpecialItem, Case, and ButtonInteration items
* The map linter now allows items of the same order

[v0.5.0]: https://github.com/Crystalflxme/IPS2DevKit/releases/tag/v0.5.0

## [v0.4.0] - July 13, 2023
* Added VisProblems
* Added documentation website
* Added GitHub actions
* Added lints to ensure camera locations are parts and items are models
* Added a lint that ensures camera locations have the tag
* Added a favicon to the plugin
* Refactored app

[v0.4.0]: https://github.com/Crystalflxme/IPS2DevKit/releases/tag/v0.4.0