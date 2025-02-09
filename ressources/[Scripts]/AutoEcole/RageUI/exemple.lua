
-- local Indexs = {
--     List = {
--         Index = 1
--     },
--     Panel = {
--         Index = 1
--     },
--     ColourPanel = {
--         Index = 1
--     },
--     PercentagePanel = {
--         Index = 1
--     }
-- }

-- Panel = {
-- 	GridPanel = {
-- 		x = 0.5,
-- 		y = 0.5,
-- 		Top = "Haut",
--         Bottom = "Bas",
--         Left = "Gauche",
--         Right = "Droite",
-- 		enable = false
-- 	},
-- 	GridPanelHorizontal = {
-- 		x = 0.5,
--         Left = "Gauche",
--         Right = "Droite",
-- 		enable = false
-- 	},
--     ColourPanel = {
--         index_one = 1,
--         index_two = 1,
-- 		name = "Couleur",
--         Color = RageUI.PanelColour.HairCut,
-- 		enable = false
-- 	},
-- 	PercentagePanel = {
-- 		index = 1,
--         MinText = '0%',
--         HeaderText = "Opacité",
--         MaxText = '100%',
-- 		enable = false
-- 	}
-- }

--     local open = false

-- function Locations:OpenMenu()
--     Locations.MainMenu = RageUI.CreateMenu(Config[""].MenuTitle.MainMenu, Config[""].MenuSubTitle.MainMenu, 8, 200)

--     Locations.MainMenu.Closed = function()
--         open = false
--     end

--     if open then
--         RageUI.CloseAll()
--         RageUI.Visible(Locations.MainMenu, false)
--         open = false
--     else
--         RageUI.CloseAll()
--         RageUI.Visible(Locations.MainMenu, true)
--         open = true

--         CreateThread(function()
--             while open do
--                 Wait(1)

--                 RageUI.IsVisible(Locations.MainMenu, true, true, true, function()

--                     RageUI.Separator("")

--                     RageUI.Line()

--                     RageUI.List("", { 0,1,2,3,4,5 }, Indexs.List.Index, nil, {}, true, function(Hovered, Active, Selected, Index)
-- 					end, function(Index, Item)
--                         Indexs.List.Index = Index
--                     end)

--                     RageUI.ButtonWithStyle("", nil, { RightLabel = "" }, true, function(Hovered, Active, Selected)
--                         if Selected then
--                         end
--                     end)
--                 end, function() 
--                     if Panel.GridPanel.enable then
--                         RageUI.GridPanel(Panel.GridPanel.x, Panel.GridPanel.y, Panel.GridPanel.Top, Panel.GridPanel.Bottom, Panel.GridPanel.Left, Panel.GridPanel.Right, function(Hovered, Active, X, Y)
--                             if Panel.GridPanel.lastItem == Panel.GridPanel.currentItem then
--                                 Panel.GridPanel.x = X
--                                 Panel.GridPanel.y = Y
--                             else
--                                 Panel.GridPanel.x = Panel.GridPanel[Panel.GridPanel.currentItem].x
--                                 Panel.GridPanel.y = Panel.GridPanel[Panel.GridPanel.currentItem].y
--                             end
            
            
--                             if Active then
--                                 Panel.GridPanel[Panel.GridPanel.currentItem].x = X
--                                 Panel.GridPanel[Panel.GridPanel.currentItem].y = Y
--                             end
--                         end)
--                     end
            
--                     if Panel.GridPanelHorizontal.enable then
--                         RageUI.GridPanelHorizontal(Panel.GridPanelHorizontal.x, Panel.GridPanelHorizontal.Left, Panel.GridPanelHorizontal.Right, function(Hovered, Active, X)
--                             if Panel.GridPanelHorizontal.lastItem == Panel.GridPanelHorizontal.currentItem then
--                                 Panel.GridPanelHorizontal.x = X
--                             else
--                                 Panel.GridPanelHorizontal.x = Panel.GridPanelHorizontal[Panel.GridPanelHorizontal.currentItem].x
--                             end

--                             if Active then
--                                 Panel.GridPanelHorizontal[Panel.GridPanelHorizontal.currentItem].x = X
--                             end
--                         end)
--                     end

--                     RageUI.ColourPanel("", RageUI.PanelColour.HairCut, Indexs.ColourPanel.Index, Indexs.ColourPanel.Index, function(Hovered, Active, MinimumIndex, CurrentIndex)
--                         Indexs.ColourPanel.Index = MinimumIndex
--                         Indexs.ColourPanel.Index = CurrentIndex

--                         if Active then        
--                         end
--                     end, 1);

--                     RageUI.PercentagePanel(Indexs.PercentagePanel.Index, "", "0%", "100%", function(Hovered, Active, Percent)
--                         Indexs.PercentagePanel.Index = Percent

--                         if Active then
--                         end
--                     end, 2);
--                 end)
--             end
--         end)
--     end
-- end