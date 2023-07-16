---
sidebar_position: 2
---

# Map Tags

This is an explanation of all tags that can be applied with CollectionService or the Tag Editor.

- CamLocation
    - All instances tagged `CamLocation` are BaseParts
    - CanCollide is false, CanQuery is false, and CanTouch is false
	- All instances have an attribute called DisplayName, storing a string, which displays to a camera as the name of the hatch
- Clip_Bounds
    - All instances tagged `Clip_Bounds` are BaseParts
    - CanCollide is false, CanQuery is false, and CanTouch is true
    - All instances have an attribute called Entrance, with the name of the Entrance's folder name which it teleports you to upon touching it
    - Instances named Broad will be disabled during the round start and round end, to allow for entering and escaping
    - Instances not named Broad always teleport thieves
- Clip_Entrance
    - All instances tagged `Clip_Entrance` are BaseParts
    - CanCollide is true, CanQuery is true, and CanTouch is true
    - CanCollide set to false during round intro and escape sequence, to allow for entering and escaping
- Clip_Player
    - All instances tagged `Clip_Player` are BaseParts
    - CanCollide is true, CanQuery is true, and CanTouch is true
    - Instances that only thieves can collide with
    - Does not prevent camera lasers or any projectile from moving through
    - Mostly used for out of bounds protection
- EntranceNode
	- All instances tagged `EntranceNode` are BaseParts
	- CanCollide is false, CanTouch is false, but CanQuery is true
	- Node has Attachment children named 1, 2, ..., n, corresponding to n number of seats in the corresponding entrance van
	- When entering the map, the first thief to exit the van will end at attachment point 1, the second thief to exit the van will end at attachment point 2, and so on
	- Orientation doesn't matter, only position
- Item
    - Everything stealable
    - All Items are Models
    - Any Item can have the following attributes:
        - DisplayName, string, overrides the model name for the client's UI
        - CashValue, num, overrides the cash value of an item
    - Items are picked up by the biggest part of a volume. To disable this, add an underscore prefix to the name of the item
    - The position used for distance calculations for picking up items is determined by the pivot point of the item's model
    - There should be at least 1 BasePart as a child of the item model
    - Instances also tagged with `SpecialItem` have additional properties...
		- The direct children of the model make up the stealable item
		- Optional model/folder called ExtraItems, containing tagged items that spawn when the special item spawns
		- Optional model/folder called FallbackItems, containing tagged items that spawn when the special item DOESN'T spawn
		- Optional model/folder called MapModel, parents the children of this to the map if the special item check succeeds
		- Optional model/folder called FallbackMapModel, parents the children of this to the map if the special item check fails