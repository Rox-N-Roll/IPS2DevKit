local IPS2DevKit = script.Parent.Parent

local React = require(IPS2DevKit.Packages.React)
local PanelGroup = require(IPS2DevKit.App.Components.PanelGroup)
local Panel = require(IPS2DevKit.App.Components.Panel)
local Dummies = require(IPS2DevKit.PanelCode.Dummies)
local Linting = require(IPS2DevKit.PanelCode.Linting)
local MapMakingAssets = require(IPS2DevKit.PanelCode.MapMakingAssets)
local Entrances = require(IPS2DevKit.PanelCode.Entrances)
local AttributeList = require(IPS2DevKit.App.AttributeList)
local PanelComps = require(IPS2DevKit.App.PanelComps)
local createNextOrder = require(IPS2DevKit.App.Util.createNextOrder)
local AttributeIndex = require(IPS2DevKit.AttributeIndex)

local e = React.createElement

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
				Title = e(PanelComps.Title, {
					text = "Cameras",
					layoutOrder = nextOrder(),
				}),
				Basic = e(PanelComps.Button, {
					text = "Basic",
					layoutOrder = nextOrder(),
					activated = Dummies.InsertCamera,
				}),
			}),

			Thieves = e(Panel, {
				layoutOrder = nextOrder(),
			}, {
				Title = e(PanelComps.Title, {
					text = "Thieves",
					layoutOrder = nextOrder(),
				}),
				MrBlack = e(PanelComps.Button, {
					text = "Mr. Black",
					layoutOrder = nextOrder(),
					activated = function()
						Dummies.InsertThief("Mr. Black")
					end,
				}),
				MrWhite = e(PanelComps.Button, {
					text = "Mr. White",
					layoutOrder = nextOrder(),
					activated = function()
						Dummies.InsertThief("Mr. White")
					end,
				}),
				Brownie = e(PanelComps.Button, {
					text = "Brownie",
					layoutOrder = nextOrder(),
					activated = function()
						Dummies.InsertThief("Brownie")
					end,
				}),
				MsPurple = e(PanelComps.Button, {
					text = "Ms. Purple",
					layoutOrder = nextOrder(),
					activated = function()
						Dummies.InsertThief("Ms. Purple")
					end,
				}),
				Pinky = e(PanelComps.Button, {
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
				Title = e(PanelComps.Title, {
					text = "Functional",
					layoutOrder = nextOrder(),
				}),
				CameraLocation = e(PanelComps.Button, {
					text = "Camera Location",
					layoutOrder = nextOrder(),
					activated = MapMakingAssets.CameraLocation,
				}),
				NPCSpawn = e(PanelComps.Button, {
					text = "NPC Spawn",
					layoutOrder = nextOrder(),
					activated = MapMakingAssets.NPCSpawn,
				}),
			}),

			Other = e(Panel, {
				layoutOrder = nextOrder(),
			}, {
				Title = e(PanelComps.Title, {
					text = "Other",
					layoutOrder = nextOrder(),
				}),
				StandardItemsKit = e(PanelComps.Button, {
					text = "Insert Standard Items Kit",
					layoutOrder = nextOrder(),
					activated = MapMakingAssets.StandardItemsKit,
				}),
				ReconcileMapTags = e(PanelComps.Button, {
					text = "Reconcile Map Tags",
					layoutOrder = nextOrder(),
					activated = MapMakingAssets.ReconcileMapTags,
				}),
			}),
		}),

		Linting = e(PanelGroup, {
			name = "Linting",
			layoutOrder = nextOrder(),
		}, {
			AllGroups = e(Panel, {
				layoutOrder = nextOrder(),
			}, {
				Title = e(PanelComps.Title, {
					text = "All Groups",
					layoutOrder = nextOrder(),
				}),
				Run = e(PanelComps.Button, {
					text = "Run",
					layoutOrder = nextOrder(),
					activated = Linting.StartAll,
				}),
			}),

			SpecificGroups = e(Panel, {
				layoutOrder = nextOrder(),
			}, {
				Title = e(PanelComps.Title, {
					text = "Specific Groups",
					layoutOrder = nextOrder(),
				}),
				Global = e(PanelComps.Button, {
					text = "Global",
					layoutOrder = nextOrder(),
					activated = function()
						Linting.Start("Global")
					end,
				}),
				Items = e(PanelComps.Button, {
					text = "Items",
					layoutOrder = nextOrder(),
					activated = function()
						Linting.Start("Items")
					end,
				}),
				Entrances = e(PanelComps.Button, {
					text = "Entrances",
					layoutOrder = nextOrder(),
					activated = function()
						Linting.Start("Entrances")
					end,
				}),
				CamLocations = e(PanelComps.Button, {
					text = "CamLocations",
					layoutOrder = nextOrder(),
					activated = function()
						Linting.Start("CamLocations")
					end,
				}),
				NPCSpawns = e(PanelComps.Button, {
					text = "NPCSpawns",
					layoutOrder = nextOrder(),
					activated = function()
						Linting.Start("NPCSpawns")
					end,
				}),
				Clipping = e(PanelComps.Button, {
					text = "Clipping",
					layoutOrder = nextOrder(),
					activated = function()
						Linting.Start("Clipping")
					end,
				}),
				Conditionals = e(PanelComps.Button, {
					text = "Conditionals",
					layoutOrder = nextOrder(),
					activated = function()
						Linting.Start("Conditionals")
					end,
				}),
				Links = e(PanelComps.Button, {
					text = "Links",
					layoutOrder = nextOrder(),
					activated = function()
						Linting.Start("Links")
					end,
				}),
			}),
		}),

		Entrances = e(PanelGroup, {
			name = "Entrances",
			layoutOrder = nextOrder(),
		}, {
			Nodes = e(Panel, {
				layoutOrder = nextOrder(),
			}, {
				Title = e(PanelComps.Title, {
					text = "Path Nodes",
					layoutOrder = nextOrder(),
				}),
				CreateNodeAtNPC = e(PanelComps.Button, {
					text = "Create Path Node at Selected NPC",
					layoutOrder = nextOrder(),
					activated = Entrances.CreatePathNodeAtNPC,
				}),
				CreateNPCAtNode = e(PanelComps.Button, {
					text = "Create NPC at Selected Path Node",
					layoutOrder = nextOrder(),
					activated = Entrances.CreateNPCAtPathNode,
				}),
			}),

			Attributes = e(Panel, {
				layoutOrder = nextOrder(),
			}, {
				Title = e(PanelComps.Title, {
					text = "Add Attributes",
					layoutOrder = nextOrder(),
				}),
				Children = e(
					React.Fragment,
					nil,
					e(AttributeList, {
						attributes = AttributeIndex.Entrances,
						nextOrder = nextOrder,
					})
				),
			}),
		}),

		Items = e(PanelGroup, {
			name = "Items",
			layoutOrder = nextOrder(),
		}, {
			Attributes = e(Panel, {
				layoutOrder = nextOrder(),
			}, {
				Title = e(PanelComps.Title, {
					text = "Add Attributes",
					layoutOrder = nextOrder(),
				}),
				Children = e(
					React.Fragment,
					nil,
					e(AttributeList, {
						attributes = AttributeIndex.Items,
						nextOrder = nextOrder,
					})
				),
			}),
		}),

		NPCSpawns = e(PanelGroup, {
			name = "NPCSpawns",
			layoutOrder = nextOrder(),
		}, {
			Attributes = e(Panel, {
				layoutOrder = nextOrder(),
			}, {
				Title = e(PanelComps.Title, {
					text = "Add Attributes",
					layoutOrder = nextOrder(),
				}),
				Children = e(
					React.Fragment,
					nil,
					e(AttributeList, {
						attributes = AttributeIndex.NPCSpawns,
						nextOrder = nextOrder,
					})
				),
			}),
		}),

		Clipping = e(PanelGroup, {
			name = "Clipping",
			layoutOrder = nextOrder(),
		}, {
			Attributes = e(Panel, {
				layoutOrder = nextOrder(),
			}, {
				Title = e(PanelComps.Title, {
					text = "Add Attributes",
					layoutOrder = nextOrder(),
				}),
				Children = e(
					React.Fragment,
					nil,
					e(AttributeList, {
						attributes = AttributeIndex.Clipping,
						nextOrder = nextOrder,
					})
				),
			}),
		}),

		Conditionals = e(PanelGroup, {
			name = "Conditionals",
			layoutOrder = nextOrder(),
		}, {
			Attributes = e(Panel, {
				layoutOrder = nextOrder(),
			}, {
				Title = e(PanelComps.Title, {
					text = "Add Attributes",
					layoutOrder = nextOrder(),
				}),
				Children = e(
					React.Fragment,
					nil,
					e(AttributeList, {
						attributes = AttributeIndex.Conditionals,
						nextOrder = nextOrder,
					})
				),
			}),
		}),
	}
end
