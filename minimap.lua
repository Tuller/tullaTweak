--make the minimap scrollable via the mousewheel
local scroll = CreateFrame('Frame', nil, Minimap)
scroll:SetAllPoints(Minimap)
scroll:EnableMouse(false)
scroll:EnableMouseWheel(true)
scroll:SetScript('OnMouseWheel', function(self, arg1)
	if (Minimap:GetZoom() + arg1 <= Minimap:GetZoomLevels()) and (Minimap:GetZoom() + arg1 >= 0) then
		Minimap:SetZoom(Minimap:GetZoom() + arg1)
	end
end)

--hide excess buttons
MiniMapWorldMapButton:Hide()
MinimapZoomIn:Hide()
MinimapZoomOut:Hide()

MinimapZoneTextButton:Hide()
if MinimapToggleButton then
	MinimapToggleButton:Hide()
end
MinimapBorderTop:Hide()

MinimapCluster:ClearAllPoints()
MinimapCluster:SetPoint('TOPRIGHT', 0, 12)