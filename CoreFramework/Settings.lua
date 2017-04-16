local MODULE_NAME, MODULE_VERSION = "Settings", "1.1";

local module = CoreFramework:NewModule(MODULE_NAME, MODULE_VERSION);
if (not module) then return; end

local private = { };

module.GetSettings = function(self, ...) return private:GetSettings(...); end;
module.SetSettings = function(self, ...) return private:SetSettings(...); end;

function private:GetSettings(tbl, name, defaultSettings)
    if (type(tbl) ~= "nil" and type(tbl) ~= "table") then
        error(string.format("Invalide table."));
    end

    if (type(name) == "nil" or strlen(name) == 0) then
        error(string.format("Invalide variable name."));
    end
    
    if (type(defaultSettings) ~= "nil" and type(defaultSettings) ~= "table") then
        error(string.format("Invalide default settings."));
    end

    local settings = nil;
    if (tbl) then
        tbl[name] = tbl[name] or { };
        settings = tbl[name];
    else
        _G[name] = _G[name] or { };
        settings = _G[name];
    end
    
    if (defaultSettings) then
        self:CombineSettings(settings, defaultSettings);
    end

    return settings;
end

function private:SetSettings(tbl, name, settings)
    if (type(tbl) ~= "nil" and type(tbl) ~= "table") then
        error(string.format("Invalide table."));
    end

    if (type(name) == "nil" or strlen(name) == 0) then
        error(string.format("Invalide variable name."));
    end
    
    if (type(defaultSettings) ~= "nil" and type(defaultSettings) ~= "table") then
        error(string.format("Invalide default settings."));
    end

    if (tbl) then
        tbl[name] = settings;
    else
        _G[name] = settings;
    end
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
