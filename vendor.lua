--auto repair and sell trash when visiting a vendor
local f = CreateFrame('Frame')
f:SetScript('OnEvent', function(self, event)
	if event == 'MERCHANT_SHOW' then
		--auto repair items
		if CanMerchantRepair() then
			local repairAllCost, canRepair = GetRepairAllCost()
			if canRepair then
				RepairAllItems()
			end
		end

		--sell gray items
		for bag = BACKPACK_CONTAINER, NUM_BAG_SLOTS do
			for slot = 0, GetContainerNumSlots(bag) do
				local link = GetContainerItemLink(bag, slot)
				if link and select(3, GetItemInfo(link)) == ITEM_QUALITY_POOR then
					ShowMerchantSellCursor(1)
					UseContainerItem(bag, slot)
				end
			end
		end
	end
end)
f:RegisterEvent('MERCHANT_SHOW')