local Type, Version = "FC_ContactButton", 1
local AceGUI = LibStub and LibStub("AceGUI-3.0", true)
if not AceGUI or (AceGUI:GetWidgetVersion(Type) or 0) >= Version then return end

local methods = {
	["OnAcquire"] = function(self)
		self:SetHeight(66)
		self:SetWidth(66)
		self:SetImage(nil)
		self:SetDisabled(false)
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

	["SetDisabled"] = function(self, disabled)
		self.disabled = disabled
		if disabled then
			self.frame:Disable()
			self.image:SetVertexColor(0.5, 0.5, 0.5, 0.5)
		else
			self.frame:Enable()
			self.image:SetVertexColor(1, 1, 1, 1)
		end
	end
}

--[[-----------------------------------------------------------------------------
Constructor
-------------------------------------------------------------------------------]]
local function Constructor()
	local frame = CreateFrame("Button", nil, UIParent, "ActionButtonTemplate")

	frame:EnableMouse(true)
	frame:RegisterForClicks("AnyUp")
	frame:RegisterForDrag("LeftButton", "RightButton")
	frame:SetScript("OnEnter", function (self)
		self.obj:Fire("OnEnter")
	end)
	frame:SetScript("OnLeave", function (self)
		self.obj:Fire("OnLeave")
	end)
	frame:SetScript("OnClick", function (self, button)
		self.obj:Fire("OnClick", button)
		AceGUI:ClearFocus()
	end)
	frame:SetScript("OnDragStart", function(self)
		self.obj:Fire("OnDragStart")
	end)
	frame:SetScript("OnDragStop", function(self)
		self.obj:Fire("OnDragStop")
	end)
	frame:SetScript("OnReceiveDrag", function(self)
		self.obj:Fire("OnReceiveDrag")
	end)

	-- ElvUI hack
	if frame.StyleButton then
		frame:StyleButton()
	end

	frame:SetNormalTexture(0) -- border texture
	frame:SetPushedTexture(0)
	frame:GetHighlightTexture():SetAllPoints(frame)

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
