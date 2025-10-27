# Mercury UI Library - Quick Start Guide

A modern, feature-rich UI library for Roblox with smooth animations, drag support, and extensive customization options.

## 🚀 Getting Started

### Basic Setup

```lua
local Mercury = loadstring(game:HttpGet("your-mercury-url-here"))()

-- Create your first window
local Window = Mercury:CreateWindow({
    Name = "My First App",
    ToggleKey = Enum.KeyCode.RightShift, -- Press RightShift to toggle UI
    ConfigurationSaving = {
        Enabled = true,
        FileName = "MyAppConfig"
    }
})
```

### Creating Tabs

```lua
-- Create a main tab
local MainTab = Window:CreateTab("Main", "icon-id-here")

-- Create more tabs
local SettingsTab = Window:CreateTab("Settings")
local CreditsTab = Window:CreateTab("Credits")
```

---

## 📦 UI Elements

### 1. Button

```lua
local MyButton = MainTab:CreateButton({
    Name = "Click Me!",
    Callback = function()
        print("Button was clicked!")
        Mercury:Notify({
            Title = "Success",
            Content = "Button executed successfully!",
            Duration = 3,
            Type = "Success" -- Default, Success, Warning, Error
        })
    end
})

-- Update button
MyButton:Set("New Text")
MyButton:SetCallback(function() print("New action!") end)
MyButton:SetLocked(true) -- Disable the button
MyButton:Remove() -- Delete the button
```

### 2. Toggle

```lua
local MyToggle = MainTab:CreateToggle({
    Name = "Enable Feature",
    CurrentValue = false,
    Flag = "ToggleFlag1", -- Saves to config
    Callback = function(Value)
        print("Toggle is now:", Value)
        if Value then
            -- Do something when enabled
        else
            -- Do something when disabled
        end
    end
})

-- Control toggle
MyToggle:Set(true) -- Turn on
print(MyToggle:Get()) -- Get current state
MyToggle:SetLocked(false) -- Enable/disable interaction
```

### 3. Slider

```lua
local MySlider = MainTab:CreateSlider({
    Name = "Speed",
    Range = {0, 100},
    Increment = 1,
    CurrentValue = 50,
    Suffix = "%",
    Flag = "SliderFlag1",
    Callback = function(Value)
        print("Slider value:", Value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
    end
})

-- Update slider
MySlider:Set(75)
MySlider:SetRange({0, 200})
print(MySlider:Get())
```

### 4. Dropdown

```lua
-- Single selection
local MyDropdown = MainTab:CreateDropdown({
    Name = "Select Weapon",
    Options = {"Sword", "Bow", "Staff", "Axe"},
    CurrentOption = {"Sword"},
    MultipleOptions = false,
    Flag = "DropdownFlag1",
    Callback = function(Option)
        print("Selected:", Option[1])
    end
})

-- Multiple selection
local MultiDropdown = MainTab:CreateDropdown({
    Name = "Select Items",
    Options = {"Item 1", "Item 2", "Item 3"},
    CurrentOption = {},
    MultipleOptions = true,
    Callback = function(Options)
        for _, item in ipairs(Options) do
            print("Selected:", item)
        end
    end
})

-- Control dropdown
MyDropdown:Set({"Bow"})
MyDropdown:Refresh({"Sword", "Bow", "Staff", "Dagger", "Hammer"})
print(MyDropdown:Get())
```

### 5. Input

```lua
local MyInput = MainTab:CreateInput({
    Name = "Enter Username",
    Placeholder = "Type here...",
    CurrentValue = "",
    Flag = "InputFlag1",
    Callback = function(Text)
        print("User entered:", Text)
    end
})

-- Control input
MyInput:Set("DefaultName")
MyInput:SetPlaceholder("New placeholder...")
print(MyInput:Get())
```

### 6. Keybind

```lua
local MyKeybind = MainTab:CreateKeybind({
    Name = "Toggle ESP",
    CurrentKeybind = "E",
    Flag = "KeybindFlag1",
    Callback = function(Key)
        print("Keybind pressed:", Key)
        -- Toggle your ESP here
    end
})

-- Control keybind
MyKeybind:Set("Q")
print(MyKeybind:Get())
```

### 7. Color Picker

```lua
local MyColorPicker = MainTab:CreateColorPicker({
    Name = "ESP Color",
    Color = Color3.fromRGB(255, 0, 0),
    Flag = "ColorFlag1",
    Callback = function(Color)
        print("Color changed:", Color)
        -- Update your ESP color
    end
})

-- Control color picker
MyColorPicker:Set(Color3.fromRGB(0, 255, 0))
print(MyColorPicker:Get())
```

### 8. Label

```lua
local MyLabel = MainTab:CreateLabel("This is a label", {
    Color = Color3.fromRGB(50, 50, 150) -- Optional custom color
})

-- Update label
MyLabel:Set("Updated text!", Color3.fromRGB(255, 100, 100))
MyLabel:SetVisible(false)
```

---

## 🎨 Themes

### Available Themes
- **Default** - Classic dark theme
- **Ocean** - Blue/teal theme
- **Light** - Light mode
- **Midnight** - Deep blue theme
- **Forest** - Green theme
- **Sunset** - Pink/orange theme
- **Purple** - Purple theme

### Set Theme

```lua
-- Set theme at creation
Window:SetTheme("Ocean")

-- Or globally
Mercury:SetTheme("Midnight")

-- Get available themes
local themes = Mercury:GetThemes()
for _, theme in ipairs(themes) do
    print(theme)
end
```

---

## 🔔 Notifications

```lua
Mercury:Notify({
    Title = "Welcome!",
    Content = "Mercury UI loaded successfully",
    Duration = 5,
    Type = "Success" -- Default, Success, Warning, Error
})
```

---

## 🪟 Window Controls

```lua
-- Toggle visibility
Window:Toggle()
Window:Show()
Window:Hide()
print(Window:IsVisible())

-- Minimize/Maximize
Window:Minimize()
Window:Maximize()
print(Window:IsMinimized())

-- Switch tabs
Window:SelectTab("Settings")

-- Get all tabs
local tabs = Window:GetTabs()

-- Destroy window
Window:Destroy()
```

---

## 💾 Configuration Saving

### Automatic Saving
Flags automatically save when you interact with elements:

```lua
local MyToggle = MainTab:CreateToggle({
    Name = "Auto Save",
    Flag = "AutoSave", -- This creates a saved value
    Callback = function(Value)
        print("Value saved:", Value)
    end
})
```

### Manual Config Control

```lua
-- Load configuration
Mercury:LoadConfiguration()

-- Access flag values
local value = Mercury.Flags["AutoSave"]:Get()
Mercury.Flags["AutoSave"]:Set(true)
```

---

## 🎯 Complete Example

```lua
local Mercury = loadstring(game:HttpGet("your-url"))()

-- Create window
local Window = Mercury:CreateWindow({
    Name = "My Script Hub",
    ToggleKey = Enum.KeyCode.RightControl,
    ConfigurationSaving = {
        Enabled = true,
        FileName = "MyScriptHub"
    }
})

-- Set theme
Window:SetTheme("Ocean")

-- Create tabs
local MainTab = Window:CreateTab("Main")
local PlayerTab = Window:CreateTab("Player")

-- Add elements
MainTab:CreateLabel("Welcome to my script!")

local SpeedSlider = PlayerTab:CreateSlider({
    Name = "Walk Speed",
    Range = {16, 200},
    Increment = 1,
    CurrentValue = 16,
    Flag = "WalkSpeed",
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
    end
})

local FlyToggle = PlayerTab:CreateToggle({
    Name = "Fly",
    Flag = "FlyEnabled",
    Callback = function(Value)
        if Value then
            -- Enable fly
            Mercury:Notify({
                Title = "Fly",
                Content = "Fly enabled!",
                Type = "Success"
            })
        else
            -- Disable fly
        end
    end
})

local ThemeDropdown = MainTab:CreateDropdown({
    Name = "Theme",
    Options = Mercury:GetThemes(),
    CurrentOption = {"Ocean"},
    Callback = function(Option)
        Window:SetTheme(Option[1])
    end
})

-- Welcome notification
Mercury:Notify({
    Title = "Loaded",
    Content = "Script loaded successfully!",
    Duration = 5,
    Type = "Success"
})
```

---

## 🛠️ Advanced Features

### Element Locking
```lua
-- Lock an element to prevent interaction
MySlider:SetLocked(true)
MyToggle:SetLocked(false)
```

### Element Removal
```lua
-- Remove any element
MyButton:Remove()
MyToggle:Remove()
```

### Error Notifications
```lua
-- Enable/disable error notifications
Mercury:SetErrorNotifications(true)
print(Mercury:GetErrorNotifications())
```

### Tab Management
```lua
-- Get all elements in a tab
local elements = MainTab:GetElements()

-- Remove entire tab
MainTab:Remove()
```

---

## 📝 Tips

1. **Use Flags** for any setting you want to save
2. **Test callbacks** - errors are shown in notifications
3. **Lock elements** when you want to temporarily disable them
4. **Use appropriate types** for notifications (Success, Warning, Error)
5. **Organize with tabs** - don't put everything in one tab
6. **Choose readable themes** - Light theme for daytime, Dark for nighttime

---

## 🎨 Customization

All elements support:
- `:Set()` - Update value
- `:Get()` - Get current value
- `:SetCallback()` - Change callback function
- `:SetLocked()` - Lock/unlock element
- `:Remove()` - Delete element

---

## 📦 Features Summary

✅ Draggable windows  
✅ Smooth animations  
✅ Multiple themes  
✅ Config saving  
✅ Notifications  
✅ Tab system  
✅ All standard UI elements  
✅ Element locking  
✅ Error handling  
✅ Ripple effects  
✅ Hover animations  

---

Im too lazy so i just used ai for now
**Made with Mercury UI Library** 🚀
