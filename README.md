# Mercury Interactive

A modern UI library for Roblox scripts, based on Rayfield Interface Suite.

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Version](https://img.shields.io/badge/version-1.0.0-brightgreen.svg)]()

## Overview

Mercury Interactive is a clean, minimal UI library designed for Roblox script interfaces. Built on the foundation of Rayfield Interface Suite, Mercury removes unnecessary startup sequences and branding while maintaining full functionality and adding enhanced control features.

### Key Features

- Instant Loading - No startup animations or loading screens
- Seven Built-in Themes - Professional color schemes
- Configuration System - Automatic saving and loading
- Complete Control API - Full programmatic control
- Mobile Compatible - Touch-friendly interface
- Rich Element Library - Comprehensive UI components
- Smooth Animations - Polished TweenService transitions
- Keybind System - Custom hotkey support

## Installation
```lua
local Mercury = loadstring(game:HttpGet("https://raw.githubusercontent.com/superfastisfast/MercuryInteractive/main/Mercury.lua"))()
```

## Quick Start
```lua
local Mercury = loadstring(game:HttpGet("https://raw.githubusercontent.com/superfastisfast/MercuryInteractive/main/Mercury.lua"))()

-- Create Window
local Window = Mercury:CreateWindow({
    Name = "Script Hub",
    ToggleKey = Enum.KeyCode.RightShift,
    ConfigurationSaving = {
        Enabled = true,
        FileName = "MyConfig"
    }
})

-- Create Tab
local Tab = Window:CreateTab("Main")

-- Add Button
Tab:CreateButton({
    Name = "Execute Action",
    Callback = function()
        print("Button clicked!")
    end
})

-- Add Toggle
Tab:CreateToggle({
    Name = "Feature Toggle",
    CurrentValue = false,
    Flag = "Toggle1",
    Callback = function(Value)
        print("Toggle:", Value)
    end
})

-- Add Slider
Tab:CreateSlider({
    Name = "Speed",
    Range = {1, 100},
    Increment = 1,
    Suffix = "%",
    CurrentValue = 50,
    Flag = "Speed",
    Callback = function(Value)
        print("Speed:", Value)
    end
})
```

## Available Themes

Mercury includes seven professionally designed themes:

- **Default** - Classic dark interface
- **Ocean** - Teal and cyan color scheme
- **Light** - Clean light mode
- **Midnight** - Deep blue night theme
- **Forest** - Natural green palette
- **Sunset** - Warm pink and orange tones
- **Purple** - Royal purple accent colors
```lua
Window:SetTheme("Ocean")
```

## Window API

### Window Methods
```lua
-- Theme Control
Window:SetTheme(themeName)    -- Change UI theme

-- Visibility Control
Window:Toggle()                 -- Toggle visibility
Window:Show()                   -- Show window
Window:Hide()                   -- Hide window
Window:IsVisible()             -- Returns boolean

-- Size Control
Window:Minimize()              -- Minimize window
Window:Maximize()              -- Maximize window

-- Cleanup
Window:Destroy()               -- Remove window completely
```

### Window Settings
```lua
Mercury:CreateWindow({
    Name = "Window Title",              -- String
    ToggleKey = Enum.KeyCode.RightShift, -- KeyCode (optional)
    ConfigurationSaving = {
        Enabled = true,                 -- Boolean
        FileName = "ConfigName"         -- String
    }
})
```

## UI Elements

### Button
```lua
Tab:CreateButton({
    Name = "Button Name",
    Callback = function()
        -- Code here
    end
})
```

### Toggle
```lua
local Toggle = Tab:CreateToggle({
    Name = "Toggle Name",
    CurrentValue = false,
    Flag = "Toggle1",  -- For config saving
    Callback = function(Value)
        print(Value)
    end
})

Toggle:Set(true)  -- Programmatic control
```

### Slider
```lua
local Slider = Tab:CreateSlider({
    Name = "Slider Name",
    Range = {0, 100},
    Increment = 1,
    Suffix = "studs",
    CurrentValue = 50,
    Flag = "Slider1",
    Callback = function(Value)
        print(Value)
    end
})

Slider:Set(75)  -- Programmatic control
```

### Dropdown
```lua
local Dropdown = Tab:CreateDropdown({
    Name = "Dropdown Name",
    Options = {"Option 1", "Option 2", "Option 3"},
    CurrentOption = {"Option 1"},
    MultipleOptions = false,  -- true for multi-select
    Flag = "Dropdown1",
    Callback = function(Options)
        print(Options[1])
    end
})

Dropdown:Set({"Option 2"})
Dropdown:Refresh({"New Option 1", "New Option 2"})
```

### Input
```lua
local Input = Tab:CreateInput({
    Name = "Input Name",
    CurrentValue = "",
    PlaceholderText = "Enter text...",
    RemoveTextAfterFocusLost = false,
    Flag = "Input1",
    Callback = function(Text)
        print(Text)
    end
})

Input:Set("New text")
```

### Label
```lua
local Label = Tab:CreateLabel("Label Text", nil, Color3.fromRGB(255, 255, 255))

Label:Set("Updated Text", Color3.fromRGB(0, 255, 0))
```

### Section
```lua
local Section = Tab:CreateSection("Section Name")

Section:Set("New Section Name")
```

### Paragraph
```lua
local Paragraph = Tab:CreateParagraph({
    Title = "Paragraph Title",
    Content = "Paragraph content goes here. This can be multiple lines of text."
})

Paragraph:Set({
    Title = "New Title",
    Content = "New content"
})
```

### Divider
```lua
local Divider = Tab:CreateDivider()

Divider:Set(false)  -- Hide divider
```

### Keybind
```lua
local Keybind = Tab:CreateKeybind({
    Name = "Keybind Name",
    CurrentKeybind = "Q",
    Flag = "Keybind1",
    Callback = function(Key)
        print("Key pressed:", Key)
    end
})

Keybind:Set("E")
```

### ColorPicker
```lua
local ColorPicker = Tab:CreateColorPicker({
    Name = "Color Picker",
    Color = Color3.fromRGB(255, 255, 255),
    Flag = "ColorPicker1",
    Callback = function(Color)
        print(Color)
    end
})

ColorPicker:Set(Color3.fromRGB(255, 0, 0))
```

## Configuration System

Configuration automatically saves element values when enabled:
```lua
-- Enable in window creation
ConfigurationSaving = {
    Enabled = true,
    FileName = "MyScript"
}

-- Add Flag to elements for saving
Flag = "UniqueIdentifier"

-- Manual load
Mercury:LoadConfiguration()
```

Configurations are saved to: `workspace/Mercury/Configurations/FileName.json`

## Library Methods
```lua
-- Notifications
Mercury:Notify({
    Title = "Notification Title",
    Content = "Notification content",
    Duration = 5
})

-- Theme Management
Mercury:SetTheme("Ocean")
local themes = Mercury:GetThemes()  -- Returns table of theme names
```

## Complete Example
```lua
local Mercury = loadstring(game:HttpGet("https://raw.githubusercontent.com/superfastisfast/MercuryInteractive/main/Mercury.lua"))()

local Window = Mercury:CreateWindow({
    Name = "Advanced Hub",
    ToggleKey = Enum.KeyCode.RightShift,
    ConfigurationSaving = {
        Enabled = true,
        FileName = "AdvancedHub"
    }
})

-- Main Tab
local MainTab = Window:CreateTab("Main Features")

MainTab:CreateSection("Automation")

local AutoFarm = MainTab:CreateToggle({
    Name = "Auto Farm",
    CurrentValue = false,
    Flag = "AutoFarm",
    Callback = function(Value)
        _G.AutoFarm = Value
    end
})

MainTab:CreateSlider({
    Name = "Farm Speed",
    Range = {1, 100},
    Increment = 5,
    Suffix = "%",
    CurrentValue = 50,
    Flag = "FarmSpeed",
    Callback = function(Value)
        _G.FarmSpeed = Value
    end
})

MainTab:CreateDropdown({
    Name = "Farm Location",
    Options = {"Location 1", "Location 2", "Location 3"},
    CurrentOption = {"Location 1"},
    Flag = "FarmLocation",
    Callback = function(Option)
        _G.FarmLocation = Option[1]
    end
})

-- Settings Tab
local SettingsTab = Window:CreateTab("Settings")

SettingsTab:CreateSection("Interface")

SettingsTab:CreateDropdown({
    Name = "Theme",
    Options = Mercury:GetThemes(),
    CurrentOption = {"Default"},
    Flag = "Theme",
    Callback = function(Option)
        Window:SetTheme(Option[1])
    end
})

SettingsTab:CreateKeybind({
    Name = "Toggle UI",
    CurrentKeybind = "RightShift",
    Flag = "UIKeybind",
    Callback = function(Key)
        print("UI keybind:", Key)
    end
})

SettingsTab:CreateButton({
    Name = "Reset Configuration",
    Callback = function()
        Mercury:Notify({
            Title = "Configuration Reset",
            Content = "Settings have been reset to defaults",
            Duration = 3
        })
    end
})

-- Load saved configuration
Mercury:LoadConfiguration()
```

## Credits

Mercury Interactive is based on [Rayfield Interface Suite](https://github.com/shlexware/Rayfield) by Sirius Software.

Modifications include:
- Removed startup sequences and loading screens
- Removed branding and analytics
- Added enhanced window control methods
- Simplified codebase
- Added additional themes
- Improved element controllability

## License

MIT License - see LICENSE file for details.

Based on Rayfield Interface Suite by Sirius Software.

## Support

For issues or questions, please open an issue on the [GitHub repository](https://github.com/superfastisfast/MercuryInteractive/issues).

---

Repository: [github.com/superfastisfast/MercuryInteractive](https://github.com/superfastisfast/MercuryInteractive)
