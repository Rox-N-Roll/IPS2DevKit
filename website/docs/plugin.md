---
sidebar_position: 3
---

# Plugin

(what the plugin is used for) <p/>
(how to install plugin) <p/>
There are three expandable sidebars in the plugin, Dummies, Map Making Assets, and Map Linting.

### Dummies

There are six buttons under the Dummies category. Each button will spawn their respective model and select it for you to freely move around and edit.

1. Basic 
2. Mr. Black
3. Mr. White
4. Brownie
5. Ms. Purple
6. Pinky

### Map Making Assets

There are four buttons under the Map Making Assets category.

1. Camera Location
- Inserts a Camera Location and selects it.
- Two parts are created, **CamLocationCutout** and **RENAME_ME**.
- **CamLocationCutout** is a negative part that is used to make a hole in the ceiling where a camera can use as a hatch. The bevelled edges should match the looking direction as **RENAME_ME**.
- **RENAME_ME** is the location a camera hatch will be placed and used by Cameras. The arrow decals on the top and bottom sides indicate which direction the camera will be facing when a camera arrives at the hatch.
- **RENAME_ME** must be tagged as CamLocation and renamed to be a positive integer greater than zero.
- **RENAME_ME** will be parented to a folder named CamLocations instead of Workspace if CamLocations can be found.

2. NPC Spawn
- Inserts a NPC Spawning zone and selects it.
- This part will be parented to a folder named NPCSpawns, otherwise it will be parented to Workspace.
- If this part is parented to NPCSpawns, NPCs will randomly spawn in the area of the X and Z dimensions of the part.

3. Insert Standard Items Kit
- Inserts a model containing IPS2 models.
- Contains the ATM, Book, Bowl, Cash, Cash Register, four Chairs, Clock, Coffe, Coffee Brewer, the tall and short Filing Cabinet, Lamp, two versions of a Laptop, Microwave, four versions of a Monitor, Plant, Printer, Rug, Safe, Shirt, Soda Machine, Stove, Telephone, Toilet, and two Trash models.
- When making a map, these items are useful for placeholders, but you are encouraged to make item models on your own.

4. Reconcile Map Tags
- Creates the necessary tags for developing a map.
- The tags can be found in ServerStorage > TagList.

### Map Linting

There are seven buttons under the Map Linting category.

1. Run
2. Global
3. Items
4. Entrances
5. CamLocations
6. NPCSpawns
7. Clipping

Each button runs checks to make sure the corresponding category does not have any major errors.
Errors will be reported in the Output window, and if they exist under Workspace, they will also be highlighted and marked with a warning symbol.
Use in combination with map format documentation to produce a map that can be ported to IPS2!