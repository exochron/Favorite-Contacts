local ADDON_NAME = ...;

local CONTACT_BUTTON = ADDON_NAME .. "ContactButton";
local CONTACT_BUTTON_SIZE = 36;
local CONTACT_BUTTON_MARGIN = 12;
local CONTACT_DEFAULT_ICON = "INV_Misc_GroupLooking";

local EDIT_CONTACT_POPUP = ADDON_NAME .. "EditContactPopup";
local NUM_ICONS_PER_ROW = 5;
local NUM_ICON_ROWS = 4;
local NUM_ICONS_SHOWN = NUM_ICONS_PER_ROW * NUM_ICON_ROWS;
local ICON_ROW_HEIGHT = 36;

local CONFIRM_DELETE_CONTACT = ADDON_NAME .. "_CONFIRM_DELETE_CONTACT";
local SET_CONTACT_NOTE = ADDON_NAME .. "_SET_CONTACT_NOTE";

local L = CoreFramework:GetModule("Localization", "1.1"):GetLocalization(ADDON_NAME);

local defaultSettings = {
    contacts = { },
    columnCount = 2,
    rowCount = 9,
    position = "RIGHT",
    scale = 1.0,
    clickToSend = false,
};

local initialState = {
    globalSettings = {
        settingsScope = "realm",
    },
};
local private = CoreFramework:GetModule("Addon", "1.2"):NewAddon(ADDON_NAME, initialState);

private.contactContainer = nil;
private.iconFiles = nil;
private.contactButtonContextMenu = nil;
private.contextMenuContactIndex = 0;
private.currentDragContact = 0;

private.dragIcon = nil;

local function SetTexture(texture, iconName)
    if (iconName:sub(1,9) == "raceicon-") then
        texture:SetAtlas(iconName);
    else
        texture:SetTexture("INTERFACE\\ICONS\\" .. iconName);
    end
end

function private:CreateDragIcon()
    self.dragIcon = CreateFrame("Frame")
    self.dragIcon:SetSize(20,20)
    self.dragIcon:SetDontSavePosition()
    self.dragIcon:SetMovable(false)
    self.dragIcon:EnableMouse(false)
    self.dragIcon:SetFrameStrata("TOOLTIP")
    self.dragIcon.background = self.dragIcon:CreateTexture(nil, "BACKGROUND")
    self.dragIcon.background:SetAllPoints()

    self.dragIcon:Hide();
end

function private:SetDragIconWithCursor()
    private.dragIcon:ClearAllPoints();
    private.dragIcon:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", GetCursorPosition())
end

function private:StartDrag(index)
    local contact = self.settings.contacts[index];
    if (not contact) then
        return;
    end

    self.currentDragContact = index;

    -- couldn't use SetCursor() because of missing Atlas features => therefore usage of own cursor frame.
    -- couldn't use dragIcon:StartMoving() properly => therefore usage of own update Ticker.
    self:SetDragIconWithCursor()
    self.dragIcon.background:SetAtlas('')
    self.dragIcon.background:SetTexture('')
    SetTexture(self.dragIcon.background, contact.icon)
    self.dragIcon:Show()
    self.dragIcon.timer = C_Timer.NewTicker(0.013, self.SetDragIconWithCursor) --0.013s = ~60fps
    --self.dragIcon:StartMoving()
end

function private:StopDrag(index)
    --self.dragIcon:StopMovingOrSizing();
    self.dragIcon.timer:Cancel()
    self.dragIcon:Hide();

    for i = 1, (self.settings.columnCount * self.settings.rowCount) do
        _G[CONTACT_BUTTON .. i]:SetChecked(false);
    end
end

function private:CreateContactContainer()
    self.contactContainer = CreateFrame("Frame", ADDON_NAME .. "ContactContainer", UIParent);
    self.contactContainer:SetToplevel(true);
    self.contactContainer:SetFrameStrata("HIGH");
    self.contactContainer:Hide();

    self.contactButtonContextMenu = CreateFrame("Frame", CONTACT_BUTTON .. "ContextMenu", nil, "UIDropDownMenuTemplate");
    UIDropDownMenu_Initialize(self.contactButtonContextMenu, function(sender, level) self:CreateContactButtonContextMenu(sender, level); end, "MENU");
end

function private:CreateContactButton(index)
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
        end
    end);
    button:SetScript("OnDragStop", function(sender)
        if (sender:IsEnabled()) then
            self:StopDrag(sender.index);
            if (false == self.contactContainer:IsMouseOver()) then
                self:DeleteContact(private.currentDragContact);
                private.currentDragContact = 0;
            end
        end
    end);
    button:SetScript("OnReceiveDrag", function(sender)
        if (sender:IsEnabled()) then
            self:SwapContacts(private.currentDragContact, index);
            private.currentDragContact = 0;
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

function private:OnContactButtonClicked(button, buttonType)
    if (self.currentDragContact ~= 0) then
        self:StopDrag(button.index);
        return;
    end

    if (buttonType == "LeftButton") then
        if (button.index) then
            local contact = self.settings.contacts[button.index];
            if (contact) then
                MailFrameTab_OnClick(nil, 2);
                SendMailNameEditBox:SetText(contact.recipient);
                SendMailNameEditBox:SetFocus();

                if (self.settings.clickToSend) then
                    self:SendMail();
                end
            end
        end
        return;
    end

    if (buttonType == "RightButton") then
        self.contextMenuContactIndex = button.index;
        ToggleDropDownMenu(1, nil, self.contactButtonContextMenu, button, 0, 0);
        return;
    end
end

function private:SendMail()
    if (not SendMailMailButton:IsVisible() or
        not SendMailMailButton:IsEnabled())
    then
        return;
    end

    SendMailMailButton:Click();
end

function private:CreateContactButtonContextMenu(sender, level)
    local info = UIDropDownMenu_CreateInfo();
    info.notCheckable = true;

    local contact = self.settings.contacts[self.contextMenuContactIndex];
    if (contact) then
        info.text = EDIT;
        info.func = function()
            self:ShowEditContactPopup(self.contextMenuContactIndex);
        end;
        UIDropDownMenu_AddButton(info, level);

        info.text = SET_NOTE;
        info.func = function()
            self:EditContactNote(self.contextMenuContactIndex);
        end;
        UIDropDownMenu_AddButton(info, level);

        info.text = DELETE;
        info.func = function()
            self:DeleteContact(self.contextMenuContactIndex);
        end;
        UIDropDownMenu_AddButton(info, level);
    else
        info.text = L["Create"];
        info.func = function()
            self:ShowEditContactPopup(self.contextMenuContactIndex);
        end;
        UIDropDownMenu_AddButton(info, level);
    end

    info.text = CANCEL;
    info.func = nil;
    UIDropDownMenu_AddButton(info, level);
end

function private:UpdateContactButton(index)
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

        SetTexture(button.icon, icon)
    else
        button.icon:SetTexture("");
        button.icon:SetAtlas("");
    end

    self:SetContactButtonPosition(index);

    button:Show();
end

function private:UpdateContactButtons()
    for index = 1, (self.settings.columnCount * self.settings.rowCount) do
        self:UpdateContactButton(index);
    end
end

function private:SetContactButtonPosition(index)
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

function private:CreateEditContactPopup()
    local popup = _G[EDIT_CONTACT_POPUP];
    popup:SetScript("OnShow", function(sender)
    self.iconFiles = {
        CONTACT_DEFAULT_ICON,

        -- class
        "ClassIcon_DeathKnight", "ClassIcon_DemonHunter", "ClassIcon_Druid", "ClassIcon_Hunter", "ClassIcon_Mage", "ClassIcon_Monk",
        "ClassIcon_Paladin", "ClassIcon_Priest", "ClassIcon_Rogue", "ClassIcon_Shaman", "ClassIcon_Warlock", "ClassIcon_Warrior",

        -- people - uses texture atlas instead of plain textures
        "raceicon-human-female", "raceicon-human-male",
        "raceicon-gnome-female", "raceicon-gnome-male",
        "raceicon-dwarf-female", "raceicon-dwarf-male",
        "raceicon-nightelf-female", "raceicon-nightelf-male",
        "raceicon-draenei-female", "raceicon-draenei-male",
        "raceicon-worgen-female", "raceicon-worgen-male",
        "raceicon-voidelf-female", "raceicon-voidelf-male",
        "raceicon-lightforged-female", "raceicon-lightforged-male",
        --"raceicon-darkiron-female", "raceicon-darkiron-male",
        "raceicon-pandaren-female", "raceicon-pandaren-male",
        "raceicon-orc-female", "raceicon-orc-male",
        "raceicon-tauren-female", "raceicon-tauren-male",
        "raceicon-troll-female", "raceicon-troll-male",
        "raceicon-undead-female", "raceicon-undead-male",
        "raceicon-bloodelf-female", "raceicon-bloodelf-male",
        "raceicon-goblin-female", "raceicon-goblin-male",
        "raceicon-highmountain-female", "raceicon-highmountain-male",
        "raceicon-nightborne-female", "raceicon-nightborne-male",
        --"raceicon-maghar-female", "raceicon-maghar-male",

        --profession
        "inv_misc_gem_01",
        "Trade_Engraving",
        "Trade_Engineering",
        "Trade_Alchemy",
        "inv_inscription_tradeskill01",
        "Trade_Tailoring",
        "inv_misc_armorkit_17",
        "Trade_BlackSmithing",
        "Trade_Herbalism",
        "inv_misc_pelt_wolf_01",
        "Trade_Mining",
        "trade_archaeology",
        "inv_misc_food_15",
        "Trade_Fishing",
        "spell_holy_sealofsacrifice",

        -- faction
        "INV_BannerPVP_01",
        "INV_BannerPVP_02",

        "ACHIEVEMENT_GUILDPERK_MOBILEBANKING",
        "Garrison_Building_TradingPost",
    };

    _G[EDIT_CONTACT_POPUP .. "ContactNameLabel"]:SetText(L["Contact Name:"]);

    end);
    popup:SetScript("OnHide", function()
        self.iconFiles = nil;
        collectgarbage();
    end);

    for index = 1, NUM_ICONS_SHOWN do
        local icon = _G[EDIT_CONTACT_POPUP .. "Button" .. index];
        icon:SetScript("OnClick", function(sender)
            local scrollFrame = _G[EDIT_CONTACT_POPUP .. "ScrollFrame"];
            local scrollOffset = FauxScrollFrame_GetOffset(scrollFrame);

            self:EditContactPopupSelectTexture(sender:GetID() + (scrollOffset * NUM_ICONS_PER_ROW));
        end);
    end

    local scrollFrame = _G[EDIT_CONTACT_POPUP .. "ScrollFrame"];
    scrollFrame:SetScript("OnVerticalScroll", function(sender, offset)
        FauxScrollFrame_OnVerticalScroll(sender, offset, ICON_ROW_HEIGHT, function() self:UpdateEditContactPopup(); end);
    end);

    local okayButton = _G[EDIT_CONTACT_POPUP .. "OkayButton"];
    okayButton:SetScript("OnClick", function()
        local popup = _G[EDIT_CONTACT_POPUP];
        popup:Hide();

        local editBox = _G[EDIT_CONTACT_POPUP .. "ContactNameEditBox"];

        local index = popup.index;
        local recipient = editBox:GetText();

        local editBox2 = _G[EDIT_CONTACT_POPUP .. "IconName"];
        local icon = editBox2:GetText();
        if (not icon or string.len(icon) == 0) then
            icon = CONTACT_DEFAULT_ICON;
        end

        self.settings.contacts[index] = self.settings.contacts[index] or { };
        local contact = self.settings.contacts[index];
        contact.recipient = recipient;
        contact.icon = icon;

        self:SetSelectedContact(-1);
        self:SetEnableContacts(true);

        self:UpdateContactButton(index);
    end);

    local cancelButton = _G[EDIT_CONTACT_POPUP .. "CancelButton"];
    cancelButton:SetScript("OnClick", function()
        local popup = _G[EDIT_CONTACT_POPUP];
        popup:Hide();

        self:SetSelectedContact(-1);
        self:SetEnableContacts(true);
    end);
end

function private:ShowEditContactPopup(index)
    local popup = _G[EDIT_CONTACT_POPUP];
    popup.index = index;

    local contact = self.settings.contacts[index] or { };
    popup.icon = contact.icon or CONTACT_DEFAULT_ICON;

    local editBox = _G[EDIT_CONTACT_POPUP .. "ContactNameEditBox"];
    editBox:SetText(contact.recipient or "");

    local editBox2 = _G[EDIT_CONTACT_POPUP .. "IconName"];
    editBox2:SetText(popup.icon or "");

    popup:Show();
    editBox:SetFocus();

    self:SetSelectedContact(popup.index);
    self:SetEnableContacts(false);

    self:UpdateEditContactPopup();
end

function private:SetSelectedContact(selectedIndex)
    for index = 1, (self.settings.columnCount * self.settings.rowCount) do
        local button = _G[CONTACT_BUTTON .. index];
        button:SetChecked(false);
    end

    if (selectedIndex >= 1 and selectedIndex <= (self.settings.columnCount * self.settings.rowCount)) then
        local button = _G[CONTACT_BUTTON .. selectedIndex];
        button:SetChecked(true);
    end
end

function private:SetEnableContacts(enabled)
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

function private:UpdateEditContactPopup()
    local popup = _G[EDIT_CONTACT_POPUP];
    local scrollFrame = _G[EDIT_CONTACT_POPUP .. "ScrollFrame"];
    local numIcons = #self.iconFiles;
    local scrollOffset = FauxScrollFrame_GetOffset(scrollFrame);

    for i = 1, NUM_ICONS_SHOWN do
        local button = _G[EDIT_CONTACT_POPUP .. "Button" .. i];
        local buttonIcon = _G[EDIT_CONTACT_POPUP .. "Button" .. i .. "Icon"];
        local index = (scrollOffset * NUM_ICONS_PER_ROW) + i;
        local texture = self.iconFiles[index];

        if (index <= numIcons and texture) then
            SetTexture(buttonIcon, texture)
            button:Show();
        else
            buttonIcon:SetTexture("");
            buttonIcon:SetAtlas("");
            button:Hide();
        end
        if (popup.icon == texture) then
            button:SetChecked(true);
        else
            button:SetChecked(false);
        end
    end

    FauxScrollFrame_Update(scrollFrame, ceil(numIcons / NUM_ICONS_PER_ROW), NUM_ICON_ROWS, ICON_ROW_HEIGHT);
end

function private:EditContactPopupSelectTexture(iconIndex)
    local popup = _G[EDIT_CONTACT_POPUP];
    popup.icon = self.iconFiles[iconIndex];

    local editBox = _G[EDIT_CONTACT_POPUP .. "IconName"];
    editBox:SetText(popup.icon);

    self:UpdateEditContactPopup();
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

function private:DeleteContact(index, confirmed)
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

StaticPopupDialogs[SET_CONTACT_NOTE] = {
   text = SET_FRIENDNOTE_LABEL,
   button1 = ACCEPT,
   button2 = CANCEL,
   hasEditBox = 1,
   maxLetters = 48,
   countInvisibleLetters = true,
   editBoxWidth = 350,
   OnAccept = function(self) end,
   OnShow = function(self) end,
   OnHide = function(self)
      ChatEdit_FocusActiveWindow();
      self.editBox:SetText("");
   end,
   EditBoxOnEnterPressed = function(self)
      self:GetParent().button1:Click();
   end,
   EditBoxOnEscapePressed = function(self)
      self:GetParent():Hide();
   end,
   timeout = 0,
   exclusive = 1,
   whileDead = 1,
   hideOnEscape = 1
};

function private:EditContactNote(index)
    local contact = self.settings.contacts[index];
    if (not contact) then
        return;
    end

    local dialog = StaticPopupDialogs[SET_CONTACT_NOTE];
    dialog.OnShow = function(self)
        if (contact.note) then
            self.editBox:SetText(contact.note);
        else
            self.editBox:SetText("");
        end
      self.editBox:SetFocus();
   end;
    dialog.OnAccept = function(self)
        contact.note = self.editBox:GetText();
    end;
    StaticPopup_Show(SET_CONTACT_NOTE, contact.recipient);
end

function private:SwapContacts(index1, index2)
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

function private:UpdateContactContainer()
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

function private:BulkMailInboxSupport()
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

function private:CombineSettings(settings, defaultSettings)
    for key, value in pairs(defaultSettings) do
        if (settings[key] == nil) then
            settings[key] = value;
        elseif (type(settings[key]) == "table" and type(value) == "table") then
            self:CombineSettings(settings[key], value);
        end
    end
end

function private:LoadSettings()
    local settingsScope = self.globalSettings.settingsScope;
    if (settingsScope == "character") then
        self.settings = self.characterSettings;
    elseif (settingsScope == "global") then
        self.settings = self.globalSettings;
    else
        self.settings = self.realmSettings;
    end

    self:CombineSettings(self.settings, defaultSettings);
end

function private:Load()
    self:LoadSettings();

    self:CreateContactContainer();
    self:CreateEditContactPopup();
    self:CreateDragIcon();

    self:UpdateContactContainer();
    self:UpdateContactButtons();

    if (not MailFrame:GetScript("OnShow")) then
        MailFrame:SetScript("OnShow", function() end);
    end

    MailFrame:HookScript("OnShow", function()
        local frameLevel = max(InboxFrame:GetFrameLevel(), SendMailFrame:GetFrameLevel());
        self.contactContainer:SetFrameLevel(frameLevel);
        self.contactContainer:Show();
    end);
    MailFrame:HookScript("OnHide", function() self.contactContainer:Hide(); end);

    self:AddSlashCommand(ADDON_NAME, function(...) self:OnSlashCommand(...) end, 'favoritecontacts', 'fc');

    self:BulkMailInboxSupport();
end

function private:OnSlashCommand(command, parameter1, parameter2, parameter3, parameter4)
    if (command == "settingsscope") then
        local settingsScope = parameter1;
        if (settingsScope == "character" or settingsScope == "realm" or settingsScope == "global") then
            self.globalSettings.settingsScope = settingsScope;

            self:LoadSettings();
            self:UpdateContactContainer();
            self:UpdateContactButtons();

            print(string.format("Favorite Contacts: " .. L["Settings scope changed to %s"], settingsScope));
            return;
        end
    end

    if (command == "size") then
        local columnCount = tonumber(parameter1);
        local rowCount = tonumber(parameter2);
        if (type(columnCount) == "number" and type(rowCount) == "number") then
            for index = 1, (self.settings.columnCount * self.settings.rowCount) do
                local button = _G[CONTACT_BUTTON .. index];
                if (button) then
                    button:Hide();
                end
            end

            self.settings.columnCount = columnCount;
            self.settings.rowCount = rowCount;

            self:UpdateContactContainer();
            self:UpdateContactButtons();
            print(string.format("Favorite Contacts: " .. L["Size changed to %dx%d"], columnCount, rowCount));
            return;
        end
    end

    if (command == "contact") then
        local index = tonumber(parameter1);
        local recipient = tostring(parameter2);
        local icon = tostring(parameter3);
        if (type(index) == "number" and index >= 1) then
            if (recipient and string.len(recipient) > 0) then
                self.settings.contacts[index] = {
                    recipient = recipient,
                    icon = icon,
                };
                self:UpdateContactButton(index);
                if (not icon or string.len(icon) == 0) then
                    icon = "<empty>";
                end
                print(string.format("Favorite Contacts: " .. L["Contact added (Position: %d, Recipient: %s, Icon: %s)"], index, recipient, icon));
                return;
            else
                self:DeleteContact(index, true);
                print(string.format("Favorite Contacts: " .. L["Contact removed (Position: %d)"], index));
                return;
            end
        end
    end

    if (command == "note") then
        local index = tonumber(parameter1);
        local note = tostring(parameter2);
        if (type(index) == "number" and index >= 1) then
            local contact = self.settings.contacts[index];
            if (not contact) then
                print(string.format("Favorite Contacts: " .. L["No Contact on position %d"], index));
                return;
            end
            if (note and string.len(note) > 0) then
                contact.note = note;
                print(string.format("Favorite Contacts: " .. L["Note changed to %s (Position: %d)"], note, index));
                return;
            end
            contact.note = nil;
            print(string.format("Favorite Contacts: " .. L["Note removed (Position: %d)"], index));
            return;
        end
    end

    if (command == "position") then
        local position = string.upper(tostring(parameter1));
        if (position == "TOP" or position == "LEFT" or position == "BOTTOM" or position == "RIGHT") then
            self.settings.position = position;
            self:UpdateContactContainer();
            self:UpdateContactButtons();
            print(string.format("Favorite Contacts: " .. L["Position set to %s"], position));
            return;
        end
    end

    if (command == "scale") then
        local scale = tonumber(parameter1);
        if (type(scale) == "number" and scale > 0) then
            self.settings.scale = scale;
            self:UpdateContactContainer();
            self:UpdateContactButtons();
            print(string.format("Favorite Contacts: " .. L["Button scale factor set to %d"], scale));
            return;
        end
    end

    if (command == "clicktosend") then
        local onOff = tostring(parameter1);
        if (not onOff or string.len(onOff) == 0) then
            self.settings.clickToSend = not self.settings.clickToSend;
            if (self.settings.clickToSend) then
                print(string.format("Favorite Contacts: " .. L["ClickToSend mode enabled"]));
            else
                print(string.format("Favorite Contacts: " .. L["ClickToSend mode disabled"]));
            end
            return;
        end
        if (onOff == "on") then
            self.settings.clickToSend = true;
            print(string.format("Favorite Contacts: " .. L["ClickToSend mode enabled"]));
            return;
        end
        if (onOff == "off") then
            self.settings.clickToSend = false;
            print(string.format("Favorite Contacts: " .. L["ClickToSend mode disabled"]));
            return;
        end
    end

    print("Syntax:");
    print("/fc size <column count> <rows count>");
    print("/fc position (TOP | LEFT | BOTTOM | RIGHT)");
    print("/fc scale <button scale factor>");
    print("/fc contact <index> [<recipient> [<icon>]]");
    print("/fc note <index> [<note>]");
    print("/fc settingsscope [character|realm|global]");
    print("/fc clicktosend [on|off]");
end