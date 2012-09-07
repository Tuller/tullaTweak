--override action bar detector
local AddonName, Addon = ...
do
	local frame = CreateFrame('Frame', nil, UIParent, 'SecureHandlerStateTemplate, SecureHandlerShowHideTemplate')
	
	frame.PrintoutStates = function(self)
		print('In Pet Battle?', self:GetAttribute('state-petbattle') == 'enabled')
		print('In Vehicle?', self:GetAttribute('state-vehicle') == 'enabled')
		print('Has Vehicle UI?', self:GetAttribute('state-vehicleui') == 'enabled')
		print('Has Override Bar?', self:GetAttribute('state-overridebar') == 'enabled')
		print('Has Override UI?', _G['OverrideActionBar']:IsShown())
		print('Has Possess Bar?', self:GetAttribute('state-possessbar') == 'enabled')
	end
	
	RegisterStateDriver(frame, 'vehicle', '[@vehicle,exists]enabled;disabled')
	RegisterStateDriver(frame, 'vehicleui', '[vehicleui]enabled;disabled')
	RegisterStateDriver(frame, 'overridebar', '[overridebar]enabled;disabled')
	RegisterStateDriver(frame, 'overrideui', '[overridebar]enabled;disabled')
	RegisterStateDriver(frame, 'possessbar', '[possessbar]enabled;disabled')
	RegisterStateDriver(frame, 'petbattle', '[petbattle]enabled;disabled')	
	
	frame:SetAttribute('_onstate', [[ self:CallMethod('PrintoutStates') ]])
	
	frame:SetAttribute('_onshow', [[ self:SetAttribute('state-overrideui', 'enabled') ]])
	
	frame:SetAttribute('_onhide', [[ self:SetAttribute('state-overrideui', 'disabled') ]])	
	
	_G['SLASH_DEBUGSTATES1'] = '/debugstates'
	SlashCmdList['DEBUGSTATES'] = function() frame:PrintoutStates() end
end	