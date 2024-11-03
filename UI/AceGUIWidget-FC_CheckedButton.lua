local Type, Version = "FC_CheckedButton", 1
local AceGUI = LibStub and LibStub("AceGUI-3.0", true)
if not AceGUI or (AceGUI:GetWidgetVersion(Type) or 0) >= Version then return end


local function Button_OnClick(frame, button)
	frame.obj:Fire("OnClick", button)
	AceGUI:ClearFocus()
end

local methods = {
	["OnAcquire"] = function(self)
		self:SetHeight(42)
		self:SetWidth(42)
		self:SetImage(nil)
	end,

	["SetImage"] = function(self, path, ...)
		local image = self.image
		image:SetTexture(path)

		if image:GetTexture() then
			local n = select("#", ...)
			if n == 4 or n == 8 then
				image:SetTexCoord(...)
			else
				image:SetTexCoord(0, 1, 0, 1)
			end
		end
	end,
	["SetChecked"] = function(self, checked)
		self.frame:SetChecked(checked)
	end,
}

local function Constructor()
	local frame = CreateFrame("CheckButton", nil, UIParent, "ActionButtonTemplate")

	frame:EnableMouse(true)
	frame:SetScript("OnClick", Button_OnClick)

	-- ElvUI hack
	if frame.StyleButton then
		frame:StyleButton()
	end

	local widget = {
		image = frame.icon,
		frame = frame,
		type  = Type
	}
	for method, func in pairs(methods) do
		widget[method] = func
	end

	return AceGUI:RegisterAsWidget(widget)
end

AceGUI:RegisterWidgetType(Type, Constructor, Version)
