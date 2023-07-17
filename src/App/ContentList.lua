local IPS2DevKit = script.Parent.Parent

local React = require(IPS2DevKit.Packages.React)
local Button = require(IPS2DevKit.App.Components.Button)
local Title = require(IPS2DevKit.App.Components.Title)
local PanelGroup = require(IPS2DevKit.App.Components.PanelGroup)
local Panel = require(IPS2DevKit.App.Components.Panel)
local Dummies = require(IPS2DevKit.PanelCode.Dummies)
local MapLinting = require(IPS2DevKit.PanelCode.MapLinting)
local MapMakingAssets = require(IPS2DevKit.PanelCode.MapMakingAssets)
local createNextOrder = require(IPS2DevKit.App.Util.createNextOrder)

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
	local nextOrder = createNextOrder()

	return {
		Dummies = e(PanelGroup, {
			name = "Dummies",
			layoutOrder = nextOrder(),
		}, {
			Cameras = e(Panel, {
				layoutOrder = nextOrder(),
			}, {
				Title = e(PanelTitle, {
					text = "Cameras",
					layoutOrder = nextOrder(),
				}),
				Basic = e(PanelButton, {
					text = "Basic",
					layoutOrder = nextOrder(),
					activated = Dummies.InsertCamera,
				}),
			}),

			Thieves = e(Panel, {
				layoutOrder = nextOrder(),
			}, {
				Title = e(PanelTitle, {
					text = "Thieves",
					layoutOrder = nextOrder(),
				}),
				MrBlack = e(PanelButton, {
					text = "Mr. Black",
					layoutOrder = nextOrder(),
					activated = function()
						Dummies.InsertThief("Mr. Black")
					end,
				}),
				MrWhite = e(PanelButton, {
					text = "Mr. White",
					layoutOrder = nextOrder(),
					activated = function()
						Dummies.InsertThief("Mr. White")
					end,
				}),
				Brownie = e(PanelButton, {
					text = "Brownie",
					layoutOrder = nextOrder(),
					activated = function()
						Dummies.InsertThief("Brownie")
					end,
				}),
				MsPurple = e(PanelButton, {
					text = "Ms. Purple",
					layoutOrder = nextOrder(),
					activated = function()
						Dummies.InsertThief("Ms. Purple")
					end,
				}),
				Pinky = e(PanelButton, {
					text = "Pinky",
					layoutOrder = nextOrder(),
					activated = function()
						Dummies.InsertThief("Pinky")
					end,
				}),
			}),
		}),

		MapMakingAssets = e(PanelGroup, {
			name = "Map Making Assets",
			layoutOrder = nextOrder(),
		}, {
			Functional = e(Panel, {
				layoutOrder = nextOrder(),
			}, {
				Title = e(PanelTitle, {
					text = "Functional",
					layoutOrder = nextOrder(),
				}),
				CameraLocation = e(PanelButton, {
					text = "Camera Location",
					layoutOrder = nextOrder(),
					activated = MapMakingAssets.CameraLocation,
				}),
				NPCSpawn = e(PanelButton, {
					text = "NPC Spawn",
					layoutOrder = nextOrder(),
					activated = MapMakingAssets.NPCSpawn,
				}),
			}),

			Other = e(Panel, {
				layoutOrder = nextOrder(),
			}, {
				Title = e(PanelTitle, {
					text = "Other",
					layoutOrder = nextOrder(),
				}),
				StandardItemsKit = e(PanelButton, {
					text = "Insert Standard Items Kit",
					layoutOrder = nextOrder(),
					activated = MapMakingAssets.StandardItemsKit,
				}),
				ReconcileMapTags = e(PanelButton, {
					text = "Reconcile Map Tags",
					layoutOrder = nextOrder(),
					activated = MapMakingAssets.ReconcileMapTags,
				}),
			}),
		}),

		MapLinting = e(PanelGroup, {
			name = "Map Linting",
			layoutOrder = nextOrder(),
		}, {
			AllGroups = e(Panel, {
				layoutOrder = nextOrder(),
			}, {
				Title = e(PanelTitle, {
					text = "All Groups",
					layoutOrder = nextOrder(),
				}),
				Run = e(PanelButton, {
					text = "Run",
					layoutOrder = nextOrder(),
					activated = MapLinting.StartAll,
				}),
			}),

			SpecificGroups = e(Panel, {
				layoutOrder = nextOrder(),
			}, {
				Title = e(PanelTitle, {
					text = "Specific Groups",
					layoutOrder = nextOrder(),
				}),
				Global = e(PanelButton, {
					text = "Global",
					layoutOrder = nextOrder(),
					activated = function()
						MapLinting.Start("Global")
					end,
				}),
				Items = e(PanelButton, {
					text = "Items",
					layoutOrder = nextOrder(),
					activated = function()
						MapLinting.Start("Items")
					end,
				}),
				Entrances = e(PanelButton, {
					text = "Entrances",
					layoutOrder = nextOrder(),
					activated = function()
						MapLinting.Start("Entrances")
					end,
				}),
				CamLocations = e(PanelButton, {
					text = "CamLocations",
					layoutOrder = nextOrder(),
					activated = function()
						MapLinting.Start("CamLocations")
					end,
				}),
				NPCSpawns = e(PanelButton, {
					text = "NPCSpawns",
					layoutOrder = nextOrder(),
					activated = function()
						MapLinting.Start("NPCSpawns")
					end,
				}),
				Clipping = e(PanelButton, {
					text = "Clipping",
					layoutOrder = nextOrder(),
					activated = function()
						MapLinting.Start("Clipping")
					end,
				}),
			}),
		}),
	}
end
