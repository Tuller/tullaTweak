local Stats = CreateFrame('Button')
Stats:SetScript('OnEvent', function(self) self:Load() end)
Stats:RegisterEvent('PLAYER_LOGIN')


--[[ Startup ]]--

function Stats:Load()
	local f = _G['MiniMapTrackingButton']
	f:SetScript('OnEnter', self.OnEnter)
	f:SetScript('OnLeave', self.OnLeave)
	setmetatable(f, {__index = self})
end


--[[ Stats Frame Widget ]]--

local NUM_ADDONS_TO_DISPLAY = 15
local UPDATE_DELAY = 1
local topAddOns

function Stats:OnEnter()
	GameTooltip:SetOwner(self, 'ANCHOR_BOTTOMLEFT', 0, self:GetHeight())
	self:UpdateTooltip()
end

function Stats:OnLeave()
	GameTooltip:Hide()
end

function Stats:UpdateTooltip()
	--clear topAddOns list
	if topAddOns then
		for i,addon in pairs(topAddOns) do
			addon.value = 0
		end
	else
		topAddOns = {}
		for i=1, NUM_ADDONS_TO_DISPLAY do
			topAddOns[i] = {name = '', value = 0}
		end
	end
	
	--add FPS and latency
	local down, up, latency = GetNetStats()
	local fps = format('FPS: %.1f', GetFramerate())
	local net = format('Ping: %d ms', latency)

	GameTooltip:SetOwner(self, 'ANCHOR_BOTTOMLEFT', 0, self:GetHeight())
	GameTooltip:ClearLines()
	GameTooltip:AddDoubleLine(fps, net, 1, 1, 1, 1, 1, 1)
	GameTooltip:AddLine('--------------------------------------------------')

	self:UpdateAddonsList(GetCVar('scriptProfile') == '1' and not IsModifierKeyDown())
end

function Stats:UpdateAddonsList(watchingCPU)
	if watchingCPU then
		UpdateAddOnCPUUsage()
	else
		UpdateAddOnMemoryUsage()
	end

	local total = 0
	for i=1, GetNumAddOns() do
		local value = (watchingCPU and GetAddOnCPUUsage(i)/1000) or GetAddOnMemoryUsage(i)
		local name = (GetAddOnInfo(i))
		total = total + value

		for j,addon in ipairs(topAddOns) do
			if value > addon.value then
				for k = NUM_ADDONS_TO_DISPLAY, 1, -1 do
					if k == j then
						topAddOns[k].value = value
						topAddOns[k].name = GetAddOnInfo(i)
						break
					elseif k ~= 1 then
						topAddOns[k].value = topAddOns[k-1].value
						topAddOns[k].name = topAddOns[k-1].name
					end
				end
				break
			end
		end
	end

	if total > 0 then
		if watchingCPU then
			GameTooltip:AddLine('Addon CPU Usage')
		else
			GameTooltip:AddLine('Addon Memory Usage')
		end
		GameTooltip:AddLine('--------------------------------------------------')

		for _,addon in ipairs(topAddOns) do
			if watchingCPU then
				self:AddCPULine(addon.name, addon.value)
			else
				self:AddMemoryLine(addon.name, addon.value)
			end
		end

		GameTooltip:AddLine('--------------------------------------------------')
		if watchingCPU then
			self:AddCPULine('Total', total)
		else
			self:AddMemoryLine('Total', total)
		end
	end
	GameTooltip:Show()
end

function Stats:AddCPULine(name, secs)
	if secs > 3600 then
		GameTooltip:AddDoubleLine(name, format('%.2f h', secs/3600), 1, 1, 1, 1, 0.2, 0.2)
	elseif secs > 60 then
		GameTooltip:AddDoubleLine(name, format('%.2f m', secs/60), 1, 1, 1, 1, 1, 0.2)
	elseif secs >= 1 then
		GameTooltip:AddDoubleLine(name, format('%.1f s', secs), 1, 1, 1, 0.2, 1, 0.2)
	elseif secs > 0 then
		GameTooltip:AddDoubleLine(name, format('%.1f ms', secs * 1000), 1, 1, 1, 0.2, 1, 0.2)
	end
end

function Stats:AddMemoryLine(name, size)
	if size > 1000 then
		GameTooltip:AddDoubleLine(name, format('%.2f mb', size/1000), 1, 1, 1, 1, 1, 0.2)
	elseif size > 0 then
		GameTooltip:AddDoubleLine(name, format('%.2f kb', size), 1, 1, 1, 0.2, 1, 0.2)
	end
end