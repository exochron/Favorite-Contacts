local ADDON_NAME, ADDON = ...

local CONTACT_BUTTON = ADDON_NAME .. "ContactButton";
local CONTACT_BUTTON_SIZE = 36;
local CONTACT_BUTTON_MARGIN = 12;
local CONTACT_DEFAULT_ICON = "INV_Misc_GroupLooking";

local CONFIRM_DELETE_CONTACT = ADDON_NAME .. "_CONFIRM_DELETE_CONTACT";

local L = ADDON.L

ADDON.contactContainer = nil;
ADDON.contactButtonContextMenu = nil;
ADDON.contextMenuContactIndex = 0;
ADDON.currentDragContact = 0;

-- region callbacks
local loginCallbacks, loadUICallbacks = {}, {}
function ADDON:RegisterLoginCallback(func)
    table.insert(loginCallbacks, func)
end
function ADDON:RegisterLoadUICallback(func)
    table.insert(loadUICallbacks, func)
end
local function FireCallbacks(callbacks)
    for _, callback in pairs(callbacks) do
        callback()
    end
end
--endregion

function ADDON:SetTexture(texture, iconName)
    if (iconName:sub(1,9) == "raceicon-") then
        texture:SetAtlas(iconName);
    else
        texture:SetTexture("INTERFACE\\ICONS\\" .. iconName);
    end
end


local function CreateContactContainer()
    ADDON.contactContainer = CreateFrame("Frame", nil, UIParent)
    ADDON.contactContainer:SetToplevel(true)
    ADDON.contactContainer:SetFrameStrata("HIGH")
    ADDON.contactContainer:Hide()
    ADDON.contactContainer.buttons = {}

    ADDON.contactButtonContextMenu = MSA_DropDownMenu_Create(CONTACT_BUTTON .. "ContextMenu", ADDON.contactContainer)
    MSA_DropDownMenu_Initialize(ADDON.contactButtonContextMenu, ADDON.CreateContactButtonContextMenu, "MENU");
end

function ADDON:CreateContactButton(index)
    local button = _G[CONTACT_BUTTON .. index];
    if (not button) then
        button = CreateFrame("CheckButton", CONTACT_BUTTON .. index, self.contactContainer, "PopupButtonTemplate");
    end

    button:SetToplevel(true);
    button:RegisterForClicks("AnyUp");
    button:RegisterForDrag("LeftButton", "RightButton");
    button:SetScript("OnMouseDown", function(sender)
        if (sender:IsEnabled()) then
            sender:SetChecked(true);
        end
    end);
    button:SetScript("PreClick", function(sender) sender:SetChecked(false); end);
    button:SetScript("OnClick", function(sender, buttonType) self:OnContactButtonClicked(sender, buttonType); end);
    button:SetScript("OnDoubleClick", function(sender)
        if (sender:IsEnabled()) then
            sender:SetChecked(false);
        end

        if (not self.settings.contacts[sender.index]) then
            self:ShowEditContactPopup(sender.index);
        end
    end);
    button:SetScript("OnDragStart", function(sender)
        if (sender:IsEnabled()) then
            self:StartDrag(sender.index);
            self.currentDragContact = sender.index;
        end
    end);
    button:SetScript("OnDragStop", function(sender)
        if (sender:IsEnabled()) then
            self:StopDrag(sender.index)
            for i = 1, (self.settings.columnCount * self.settings.rowCount) do
                _G[CONTACT_BUTTON .. i]:SetChecked(false)
            end

            if (false == self.contactContainer:IsMouseOver()) then
                self:DeleteContact(ADDON.currentDragContact);
                ADDON.currentDragContact = 0;
            end
        end
    end);
    button:SetScript("OnReceiveDrag", function(sender)
        if (sender:IsEnabled()) then
            self:SwapContacts(ADDON.currentDragContact, index);
            ADDON.currentDragContact = 0;
        end
    end);

    button:SetScript("OnEnter", function(sender)
        if (not sender.index) then return end;
        local contact = self.settings.contacts[index];
        if (not contact) then return end;

        GameTooltip:SetOwner(sender, "ANCHOR_NONE");
        GameTooltip:SetPoint("TOPLEFT", sender, "TOPRIGHT", 6, 2);
        GameTooltip:SetText(contact.recipient);
        if (contact.note) then
            GameTooltip:AddLine(contact.note, GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b, 1);
        end
        GameTooltip:Show();
    end);
    button:SetScript("OnLeave", function(sender)
        GameTooltip:Hide();
    end);

    button.index = index;
    button.icon = _G[CONTACT_BUTTON .. index .. "Icon"];

    return button;
end

function ADDON:OnContactButtonClicked(button, buttonType)
    if (self.currentDragContact ~= 0) then
        self:StopDrag(button.index)
        for i = 1, (self.settings.columnCount * self.settings.rowCount) do
            _G[CONTACT_BUTTON .. i]:SetChecked(false)
        end
        return;
    end

    if (buttonType == "LeftButton") then
        if (button.index) then
            local contact = self.settings.contacts[button.index];
            if (contact) then
                MailFrameTab_OnClick(nil, 2);
                SendMailNameEditBox:SetText(contact.recipient);
                SendMailSubjectEditBox:SetFocus();

                if (self.settings.clickToSend) then
                    self:SendMail();
                end
            end
        end
        return;
    end

    if (buttonType == "RightButton") then
        self.contextMenuContactIndex = button.index;
        MSA_ToggleDropDownMenu(1, nil, self.contactButtonContextMenu, button, 0, 0);
        return;
    end
end

function ADDON:SendMail()
    if (not SendMailMailButton:IsVisible() or
        not SendMailMailButton:IsEnabled())
    then
        return;
    end

    SendMailMailButton:Click();
end

function ADDON:CreateContactButtonContextMenu(sender, level)
    local info = MSA_DropDownMenu_CreateInfo();
    info.notCheckable = true;

    local contact = self.settings.contacts[self.contextMenuContactIndex];
    if (contact) then
        info.text = EDIT;
        info.func = function()
            self:ShowEditContactPopup(self.contextMenuContactIndex);
        end;
        MSA_DropDownMenu_AddButton(info, level);

        info.text = DELETE;
        info.func = function()
            self:DeleteContact(self.contextMenuContactIndex);
        end;
        MSA_DropDownMenu_AddButton(info, level);
    else
        info.text = L["Create"];
        info.func = function()
            self:ShowEditContactPopup(self.contextMenuContactIndex);
        end;
        MSA_DropDownMenu_AddButton(info, level);
    end

    info.text = CANCEL;
    info.func = nil;
    MSA_DropDownMenu_AddButton(info, level);
end

function ADDON:UpdateContactButton(index)
    if (index < 1 and index > self.settings.columnCount * self.settings.rowCount) then
        return;
    end

    local button = self:CreateContactButton(index);

    local contact = self.settings.contacts[index];
    if (contact) then
        local icon = contact.icon;
        if (not icon or string.len(icon) == 0) then
            icon = CONTACT_DEFAULT_ICON;
            contact.icon = icon;
        end

        self:SetTexture(button.icon, icon)
    else
        button.icon:SetTexture("");
        button.icon:SetAtlas("");
    end

    self:SetContactButtonPosition(index);

    button:Show();
end

function ADDON:UpdateContactButtons()
    for index = 1, (self.settings.columnCount * self.settings.rowCount) do
        self:UpdateContactButton(index);
    end
end

function ADDON:SetContactButtonPosition(index)
    local button = _G[CONTACT_BUTTON .. index];

    button:ClearAllPoints();
    if (index == 1) then
        button:SetPoint("TOPLEFT", self.contactContainer, "TOPLEFT", 0, -1);
    elseif (mod(index, self.settings.rowCount) == 1) then
        button:SetPoint("LEFT", CONTACT_BUTTON .. (index - self.settings.rowCount), "RIGHT", CONTACT_BUTTON_MARGIN, 0);
    else
        button:SetPoint("TOP", CONTACT_BUTTON .. (index - 1), "BOTTOM", 0, -CONTACT_BUTTON_MARGIN);
    end
end

function ADDON:SetSelectedContact(selectedIndex)
    for index = 1, (self.settings.columnCount * self.settings.rowCount) do
        local button = _G[CONTACT_BUTTON .. index];
        button:SetChecked(false);
    end

    if (selectedIndex >= 1 and selectedIndex <= (self.settings.columnCount * self.settings.rowCount)) then
        local button = _G[CONTACT_BUTTON .. selectedIndex];
        button:SetChecked(true);
    end
end

function ADDON:SetEnableContacts(enabled)
    for index = 1, (self.settings.columnCount * self.settings.rowCount) do
        local button = _G[CONTACT_BUTTON .. index];
        button:SetEnabled(enabled);

        if (enabled) then
            button.icon:SetAlpha(1.0);
        else
            button.icon:SetAlpha(0.5);
        end
    end
end

function ADDON:SetContact(index, recipient, icon, note)
    self.settings.contacts[index] = self.settings.contacts[index] or { }
    local contact = self.settings.contacts[index]
    contact.recipient = recipient
    contact.icon = icon
    contact.note = note

    self:UpdateContactButton(index)
end

StaticPopupDialogs[CONFIRM_DELETE_CONTACT] = {
    text = L["Are you sure that you want to delete this Contact?"],
    button1 = YES,
    button2 = NO,
    OnAccept = function() end,
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
    preferredIndex = 3,
}

function ADDON:DeleteContact(index, confirmed)
    if (not confirmed) then
        self:SetSelectedContact(index);
        self:SetEnableContacts(false);

        StaticPopupDialogs[CONFIRM_DELETE_CONTACT].OnAccept = function()
            self:DeleteContact(index, true);
            self:SetSelectedContact(0);
            self:SetEnableContacts(true);
        end;
        StaticPopupDialogs[CONFIRM_DELETE_CONTACT].OnCancel = function()
            self:SetSelectedContact(0);
            self:SetEnableContacts(true);
        end;
        StaticPopup_Show(CONFIRM_DELETE_CONTACT);
        return;
    end

    self.settings.contacts[index] = nil;

    self:UpdateContactButtons();
end

function ADDON:SwapContacts(index1, index2)
    if (index1 < 1 or index1 > (self.settings.columnCount * self.settings.rowCount)) then
        return;
    end

    if (index2 < 1 or index2 > (self.settings.columnCount * self.settings.rowCount)) then
        return;
    end

    local contact1 = self.settings.contacts[index1];
    local contact2 = self.settings.contacts[index2];

    self.settings.contacts[index1] = contact2;
    self.settings.contacts[index2] = contact1;

    self:UpdateContactButtons();
end

function ADDON:UpdateContactContainer()
    self.contactContainer:SetScale(self.settings.scale);

    local width = (CONTACT_BUTTON_SIZE + CONTACT_BUTTON_MARGIN) * self.settings.columnCount;
    local height = (CONTACT_BUTTON_SIZE + CONTACT_BUTTON_MARGIN) * self.settings.rowCount;
    self.contactContainer:SetSize(width, height);

    if (self.settings.position == "LEFT") then
        MailFrame:SetAttribute("UIPanelLayout-xoffset", width * self.settings.scale + CONTACT_BUTTON_MARGIN);
        MailFrame:SetAttribute("UIPanelLayout-yoffset", 0);
        MailFrame:SetAttribute("UIPanelLayout-extraWidth", 0);
        MailFrame:SetAttribute("UIPanelLayout-extraHeight", 0);

        self.contactContainer:ClearAllPoints();
        self.contactContainer:SetPoint("TOPRIGHT", MailFrame, "TOPLEFT", -CONTACT_BUTTON_MARGIN, 0);

        OpenMailFrame:ClearAllPoints();
        OpenMailFrame:SetPoint("TOPLEFT", InboxFrame, "TOPRIGHT", 0, 0);
    elseif (self.settings.position == "TOP") then
        MailFrame:SetAttribute("UIPanelLayout-xoffset", 0);
        MailFrame:SetAttribute("UIPanelLayout-yoffset", -(height * self.settings.scale + CONTACT_BUTTON_MARGIN));
        MailFrame:SetAttribute("UIPanelLayout-extraWidth", 0);
        MailFrame:SetAttribute("UIPanelLayout-extraHeight", 0);

        self.contactContainer:ClearAllPoints();
        self.contactContainer:SetPoint("BOTTOMLEFT", MailFrame, "TOPLEFT", 0, CONTACT_BUTTON_MARGIN);

        OpenMailFrame:ClearAllPoints();
        OpenMailFrame:SetPoint("TOPLEFT", InboxFrame, "TOPRIGHT", 0, 0);
    elseif (self.settings.position == "BOTTOM") then
        MailFrame:SetAttribute("UIPanelLayout-xoffset", 0);
        MailFrame:SetAttribute("UIPanelLayout-yoffset", 0);
        MailFrame:SetAttribute("UIPanelLayout-extraWidth", 0);
        MailFrame:SetAttribute("UIPanelLayout-extraHeight", height * self.settings.scale);

        self.contactContainer:ClearAllPoints();
        self.contactContainer:SetPoint("TOPLEFT", MailFrameTab1, "BOTTOMLEFT", 0, -CONTACT_BUTTON_MARGIN);

        OpenMailFrame:ClearAllPoints();
        OpenMailFrame:SetPoint("TOPLEFT", InboxFrame, "TOPRIGHT", 0, 0);
    else
        MailFrame:SetAttribute("UIPanelLayout-xoffset", 0);
        MailFrame:SetAttribute("UIPanelLayout-yoffset", 0);
        MailFrame:SetAttribute("UIPanelLayout-extraWidth", width * self.settings.scale + CONTACT_BUTTON_MARGIN);
        MailFrame:SetAttribute("UIPanelLayout-extraHeight", 0);

        self.contactContainer:ClearAllPoints();
        self.contactContainer:SetPoint("TOPLEFT", MailFrame, "TOPRIGHT", CONTACT_BUTTON_MARGIN, 0);

        OpenMailFrame:ClearAllPoints();
        OpenMailFrame:SetPoint("TOPLEFT", InboxFrame, "TOPRIGHT", width * self.settings.scale + CONTACT_BUTTON_MARGIN, 0);
    end

    UpdateUIPanelPositions(MailFrame);
    UpdateUIPanelPositions(OpenMailFrame);
end

function ADDON:BulkMailInboxSupport()
    if (not BulkMailInbox) then
        return;
    end

    hooksecurefunc(BulkMailInbox, "AdjustSizeAndPosition", function(sender, tooltip)
        if (not tooltip.moved) then
            local extraWidth = MailFrame:GetAttribute("UIPanelLayout-extraWidth");

            local scale = BulkMailInbox.db.profile.scale;
            local barHeight = BulkMailInbox._toolbar:GetHeight() * scale;
            local uiHeight = UIParent:GetHeight()

            local tipHeight = tooltip:GetHeight() * scale;
            local offx = math.min((uiHeight - tipHeight - barHeight) / 2, uiHeight + 12 - MailFrame:GetTop() * MailFrame:GetScale()) + barHeight;

            tooltip:ClearAllPoints();
            tooltip:SetPoint("TOPLEFT", UIParent, "TOPLEFT", (MailFrame:GetRight() + extraWidth) * MailFrame:GetScale() / scale, -offx / scale);
        end
    end);
end

function ADDON:Load()
    FireCallbacks(loginCallbacks)

    local initUI = true
    MailFrame:HookScript("OnShow", function()
        if initUI then
            CreateContactContainer()
            FireCallbacks(loadUICallbacks)

            self:UpdateContactContainer();
            self:UpdateContactButtons();
            initUI = false
        end
    end)

    MailFrame:HookScript("OnShow", function()
        local frameLevel = max(InboxFrame:GetFrameLevel(), SendMailFrame:GetFrameLevel());
        self.contactContainer:SetFrameLevel(frameLevel);
        self.contactContainer:Show();
    end);
    MailFrame:HookScript("OnHide", function() self.contactContainer:Hide(); end);

    self:BulkMailInboxSupport();
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")
frame:SetScript("OnEvent", function(self, event, arg1)
    ADDON:Load()
end)