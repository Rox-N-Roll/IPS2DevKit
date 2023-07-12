local IPS2DevKit = script.Parent.Parent

local React = require(IPS2DevKit.Packages.React)
local Button = require(IPS2DevKit.App.Components.Button)
local Title = require(IPS2DevKit.App.Components.Title)
local PanelGroup = require(IPS2DevKit.App.Components.PanelGroup)
local Panel = require(IPS2DevKit.App.Components.Panel)
local Dummies = require(IPS2DevKit.PanelCode.Dummies)
local MapLinting = require(IPS2DevKit.PanelCode.MapLinting)
local MapMakingAssets = require(IPS2DevKit.PanelCode.MapMakingAssets)

local DISPLAY_SIZE = 50

local e = React.createElement

local function PanelTitle(props: {
	text: string,
	layoutOrder: number,
})
	local size = math.floor(DISPLAY_SIZE * 0.5)
	return e(Title, {
		text = props.text,
		size = UDim2.new(1, 0, 0, size),
		layoutOrder = props.layoutOrder,
	})
end

local function PanelButton(props: {
	text: string,
	layoutOrder: number,
	activated: () -> (),
})
	return e(Button, {
		text = props.text,
		size = UDim2.new(1, 0, 0, DISPLAY_SIZE),
		layoutOrder = props.layoutOrder,
		activated = props.activated,
	})
end

return function()
	return {
		Dummies = e(PanelGroup, {
			name = "Dummies",
			layoutOrder = 1,
		}, {
			Cameras = e(Panel, {
				layoutOrder = 1,
			}, {
				Title = e(PanelTitle, {
					text = "Cameras",
					layoutOrder = 1,
				}),
				Basic = e(PanelButton, {
					text = "Basic",
					layoutOrder = 2,
					activated = Dummies.InsertCamera,
				}),
			}),

			Thieves = e(Panel, {
				layoutOrder = 2,
			}, {
				Title = e(PanelTitle, {
					text = "Thieves",
					layoutOrder = 1,
				}),
				MrBlack = e(PanelButton, {
					text = "Mr. Black",
					layoutOrder = 2,
					activated = function()
						Dummies.InsertThief("Mr. Black")
					end,
				}),
				MrWhite = e(PanelButton, {
					text = "Mr. White",
					layoutOrder = 3,
					activated = function()
						Dummies.InsertThief("Mr. White")
					end,
				}),
				Brownie = e(PanelButton, {
					text = "Brownie",
					layoutOrder = 4,
					activated = function()
						Dummies.InsertThief("Brownie")
					end,
				}),
				MsPurple = e(PanelButton, {
					text = "Ms. Purple",
					layoutOrder = 5,
					activated = function()
						Dummies.InsertThief("Ms. Purple")
					end,
				}),
				Pinky = e(PanelButton, {
					text = "Pinky",
					layoutOrder = 6,
					activated = function()
						Dummies.InsertThief("Pinky")
					end,
				}),
			}),
		}),

		MapMakingAssets = e(PanelGroup, {
			name = "Map Making Assets",
			layoutOrder = 2,
		}, {
			Functional = e(Panel, {
				layoutOrder = 1,
			}, {
				Title = e(PanelTitle, {
					text = "Functional",
					layoutOrder = 1,
				}),
				CameraLocation = e(PanelButton, {
					text = "Camera Location",
					layoutOrder = 2,
					activated = MapMakingAssets.CameraLocation,
				}),
				NPCSpawn = e(PanelButton, {
					text = "NPC Spawn",
					layoutOrder = 3,
					activated = MapMakingAssets.NPCSpawn,
				}),
			}),

			Other = e(Panel, {
				layoutOrder = 2,
			}, {
				Title = e(PanelTitle, {
					text = "Other",
					layoutOrder = 1,
				}),
				StandardItemsKit = e(PanelButton, {
					text = "Insert Standard Items Kit",
					layoutOrder = 2,
					activated = MapMakingAssets.StandardItemsKit,
				}),
				ReconcileMapTags = e(PanelButton, {
					text = "Reconcile Map Tags",
					layoutOrder = 3,
					activated = MapMakingAssets.ReconcileMapTags,
				}),
			}),
		}),

		MapLinting = e(PanelGroup, {
			name = "Map Linting",
			layoutOrder = 3,
		}, {
			AllGroups = e(Panel, {
				layoutOrder = 1,
			}, {
				Title = e(PanelTitle, {
					text = "All Groups",
					layoutOrder = 1,
				}),
				Run = e(PanelButton, {
					text = "Run",
					layoutOrder = 2,
					activated = MapLinting.StartAll,
				}),
			}),

			SpecificGroups = e(Panel, {
				layoutOrder = 2,
			}, {
				Title = e(PanelTitle, {
					text = "Specific Groups",
					layoutOrder = 1,
				}),
				Global = e(PanelButton, {
					text = "Global",
					layoutOrder = 2,
					activated = function()
						MapLinting.Start("Global")
					end,
				}),
				Items = e(PanelButton, {
					text = "Items",
					layoutOrder = 3,
					activated = function()
						MapLinting.Start("Items")
					end,
				}),
				Entrances = e(PanelButton, {
					text = "Entrances",
					layoutOrder = 4,
					activated = function()
						MapLinting.Start("Entrances")
					end,
				}),
				CamLocations = e(PanelButton, {
					text = "CamLocations",
					layoutOrder = 5,
					activated = function()
						MapLinting.Start("CamLocations")
					end,
				}),
				NPCSpawns = e(PanelButton, {
					text = "NPCSpawns",
					layoutOrder = 6,
					activated = function()
						MapLinting.Start("NPCSpawns")
					end,
				}),
				Clipping = e(PanelButton, {
					text = "Clipping",
					layoutOrder = 7,
					activated = function()
						MapLinting.Start("Clipping")
					end,
				}),
			}),
		}),
	}
end
