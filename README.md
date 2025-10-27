# Mercury Interactive

A modern UI library for Roblox scripts, based on Rayfield Interface Suite.

[License: MIT](LICENSE) | [Version: 1.0.0]() | [Documentation](#documentation)

## Overview

Mercury Interactive is a clean, minimal UI library designed for Roblox script interfaces. Built on the foundation of Rayfield Interface Suite, Mercury removes unnecessary startup sequences and branding while maintaining full functionality and adding enhanced control features.

### Key Features

- Instant Loading - No startup animations by default (customizable)
- Seven Built-in Themes - Professional color schemes
- Configuration System - Automatic saving and loading
- Complete Control API - Full programmatic control over all elements
- Mobile Compatible - Touch-friendly interface
- Rich Element Library - Comprehensive UI components including CodeBox
- Smooth Animations - Polished TweenService transitions
- Keybind System - Custom hotkey support
- Error Handling - Built-in callback error management
- Dynamic Updates - Modify elements after creation
- Custom Startup Screen - Optional branded loading screen
- Sound Effects - Customizable UI interaction sounds

## Table of Contents

1. [Installation](#installation)
2. [Quick Start](#quick-start)
3. [Available Themes](#available-themes)
4. [Window API](#window-api)
5. [Tab Management](#tab-management)
6. [UI Elements](#ui-elements)
7. [Advanced Control](#advanced-control)
8. [Configuration System](#configuration-system)
9. [Error Handling](#error-handling)
10. [Complete Examples](#complete-examples)
11. [Best Practices](#best-practices)

## Installation

```lua
local Mercury = loadstring(game:HttpGet("https://raw.githubusercontent.com/superfastisfast/MercuryInterface/main/Mercury.lua"))()
```

## Quick Start

```lua
local Mercury = loadstring(game:HttpGet("https://raw.githubusercontent.com/superfastisfast/MercuryInterface/main/Mercury.lua"))()

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

-- Add Toggle with control
local Toggle = Tab:CreateToggle({
    Name = "Feature Toggle",
    CurrentValue = false,
    Flag = "Toggle1",
    Callback = function(Value)
        print("Toggle:", Value)
    end
})

-- Programmatically control toggle
Toggle:Set(true)

-- Add Slider with dynamic range
local Slider = Tab:CreateSlider({
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

-- Change slider range dynamically
Slider:SetRange({10, 200})
```

## Available Themes

Mercury includes seven professionally designed themes:

| Theme | Description |
|-------|-------------|
| Default | Classic dark interface with blue accents |
| Ocean | Teal and cyan color scheme |
| Light | Clean light mode for bright environments |
| Midnight | Deep blue night theme |
| Forest | Natural green palette |
| Sunset | Warm pink and orange tones |
| Purple | Royal purple accent colors |

```lua
-- Set theme
Window:SetTheme("Ocean")

-- Get all available themes
local themes = Mercury:GetThemes()
for _, theme in ipairs(themes) do
    print(theme)
end
```

## Window API

### Window Creation

```lua
local Window = Mercury:CreateWindow({
    Name = "Window Title",              -- String: Window title
    ToggleKey = Enum.KeyCode.RightShift, -- KeyCode: Key to toggle visibility (optional)
    ConfigurationSaving = {
        Enabled = true,                 -- Boolean: Enable config system
        FileName = "ConfigName"         -- String: Configuration file name
    }
})
```

### Window Control Methods

```lua
-- Theme Management
Window:SetTheme(themeName)              -- Change UI theme
-- Example: Window:SetTheme("Ocean")

-- Visibility Control
Window:Toggle()                         -- Toggle visibility on/off
Window:Show()                           -- Show window
Window:Hide()                           -- Hide window
local isVisible = Window:IsVisible()    -- Returns: boolean

-- Size Control
Window:Minimize()                       -- Minimize to title bar only
Window:Maximize()                       -- Restore to full size
local isMinimized = Window:IsMinimized() -- Returns: boolean

-- Tab Management
local tabs = Window:GetTabs()           -- Returns: table of all tabs
Window:SelectTab(tabName)               -- Switch to specific tab
-- Example: Window:SelectTab("Settings")

-- Cleanup
Window:Destroy()                        -- Remove window completely
```

## Tab Management

### Creating Tabs

```lua
local Tab = Window:CreateTab("Tab Name", icon)  -- icon is optional
```

### Tab Control Methods

```lua
-- Get all elements in tab
local elements = Tab:GetElements()      -- Returns: table of all elements

-- Remove tab completely
Tab:Remove()                            -- Destroys tab and all its elements

-- Access tab properties
print(Tab.Name)                         -- Tab name
print(Tab.Window)                       -- Parent window reference
```

## UI Elements

### Button

Create clickable buttons with callback functions.

```lua
local Button = Tab:CreateButton({
    Name = "Button Name",               -- String: Button text
    Callback = function()
        -- Code executed when clicked
        print("Button clicked!")
    end
})

-- Button Methods
Button:Set("New Button Text")           -- Change button text
Button:SetCallback(function()           -- Change callback function
    print("New callback!")
end)
Button:Remove()                         -- Remove button from UI
```

### Toggle

Create on/off switches with state management.

```lua
local Toggle = Tab:CreateToggle({
    Name = "Toggle Name",               -- String: Toggle label
    CurrentValue = false,               -- Boolean: Initial state
    Flag = "Toggle1",                   -- String: For config saving (optional)
    Callback = function(Value)
        print("Toggle is now:", Value)
    end
})

-- Toggle Methods
Toggle:Set(true)                        -- Set toggle state
local state = Toggle:Get()              -- Get current state (returns boolean)
Toggle:SetCallback(function(Value)      -- Change callback
    print("New callback:", Value)
end)
Toggle:Remove()                         -- Remove toggle from UI
```

### Slider

Create numeric sliders with range control.

```lua
local Slider = Tab:CreateSlider({
    Name = "Slider Name",               -- String: Slider label
    Range = {0, 100},                   -- Table: {min, max}
    Increment = 1,                      -- Number: Step size
    Suffix = "studs",                   -- String: Unit display (optional)
    CurrentValue = 50,                  -- Number: Initial value
    Flag = "Slider1",                   -- String: For config saving (optional)
    Callback = function(Value)
        print("Slider value:", Value)
    end
})

-- Slider Methods
Slider:Set(75)                          -- Set slider value
local value = Slider:Get()              -- Get current value (returns number)
Slider:SetRange({10, 200})              -- Change min/max range dynamically
Slider:SetCallback(function(Value)      -- Change callback
    print("New value:", Value)
end)
Slider:Remove()                         -- Remove slider from UI
```

### Dropdown

Create selection menus with single or multiple options.

```lua
local Dropdown = Tab:CreateDropdown({
    Name = "Dropdown Name",             -- String: Dropdown label
    Options = {"Option 1", "Option 2", "Option 3"},  -- Table: Available options
    CurrentOption = {"Option 1"},       -- Table: Initial selection
    MultipleOptions = false,            -- Boolean: Allow multiple selections
    Flag = "Dropdown1",                 -- String: For config saving (optional)
    Callback = function(Options)
        print("Selected:", Options[1])
    end
})

-- Dropdown Methods
Dropdown:Set({"Option 2"})              -- Set selected option(s)
local selected = Dropdown:Get()         -- Get current selection (returns table)
Dropdown:Refresh({"New 1", "New 2"})    -- Update available options
Dropdown:SetCallback(function(Options)  -- Change callback
    print("New selection:", Options)
end)
Dropdown:Remove()                       -- Remove dropdown from UI
```

### Input

Create text input fields with placeholder support.

```lua
local Input = Tab:CreateInput({
    Name = "Input Name",                -- String: Input label
    CurrentValue = "",                  -- String: Initial text
    Placeholder = "Enter text...",      -- String: Placeholder text
    Flag = "Input1",                    -- String: For config saving (optional)
    Callback = function(Text)
        print("Input:", Text)
    end
})

-- Input Methods
Input:Set("New text")                   -- Set input text
local text = Input:Get()                -- Get current text (returns string)
Input:SetPlaceholder("New hint...")     -- Change placeholder text
Input:SetCallback(function(Text)        -- Change callback
    print("New input:", Text)
end)
Input:Remove()                          -- Remove input from UI
```

### Label

Create text labels with optional colors.

```lua
local Label = Tab:CreateLabel(
    "Label Text",                       -- String: Label text
    nil,                                -- Icon (optional, not implemented)
    Color3.fromRGB(255, 255, 255)      -- Color3: Text color (optional)
)

-- Label Methods
Label:Set("Updated Text", Color3.fromRGB(0, 255, 0))  -- Update text and color
Label:Remove()                          -- Remove label from UI
```

### Section

Create section headers to organize UI elements.

```lua
local Section = Tab:CreateSection("Section Name")  -- String: Section title

-- Section Methods
Section:Set("New Section Name")         -- Update section title
Section:Remove()                        -- Remove section from UI
```

### Paragraph

Create multi-line text blocks with titles.

```lua
local Paragraph = Tab:CreateParagraph({
    Title = "Paragraph Title",          -- String: Title text
    Content = "Paragraph content goes here. This can be multiple lines of text that provide detailed information."
})

-- Paragraph Methods
Paragraph:Set({
    Title = "New Title",
    Content = "New content with more details..."
})
Paragraph:Remove()                      -- Remove paragraph from UI
```

### Divider

Create visual separators between UI elements.

```lua
local Divider = Tab:CreateDivider()

-- Divider Methods
Divider:Set(false)                      -- Hide divider
Divider:Set(true)                       -- Show divider
Divider:Remove()                        -- Remove divider from UI
```

### Keybind

Create keybind selectors that respond to key presses.

```lua
local Keybind = Tab:CreateKeybind({
    Name = "Keybind Name",              -- String: Keybind label
    CurrentKeybind = "Q",               -- String: Initial key
    Flag = "Keybind1",                  -- String: For config saving (optional)
    Callback = function(Key)
        print("Key pressed:", Key)
    end
})

-- Keybind Methods
Keybind:Set("E")                        -- Set keybind
local key = Keybind:Get()               -- Get current key (returns string)
Keybind:SetCallback(function(Key)       -- Change callback
    print("New key:", Key)
end)
Keybind:Remove()                        -- Remove keybind from UI
```

### ColorPicker

Create color selection interfaces.

```lua
local ColorPicker = Tab:CreateColorPicker({
    Name = "Color Picker",              -- String: Picker label
    Color = Color3.fromRGB(255, 255, 255),  -- Color3: Initial color
    Flag = "ColorPicker1",              -- String: For config saving (optional)
    Callback = function(Color)
        print("Color:", Color)
    end
})

-- ColorPicker Methods
ColorPicker:Set(Color3.fromRGB(255, 0, 0))  -- Set color
local color = ColorPicker:Get()         -- Get current color (returns Color3)
ColorPicker:SetCallback(function(Color) -- Change callback
    print("New color:", Color)
end)
ColorPicker:Remove()                    -- Remove picker from UI
```

## Advanced Control

### Dynamic Element Management

```lua
-- Create elements and store references
local elements = {}

elements.speedSlider = Tab:CreateSlider({
    Name = "Speed",
    Range = {1, 100},
    CurrentValue = 50,
    Callback = function(Value)
        _G.Speed = Value
    end
})

elements.toggleFeature = Tab:CreateToggle({
    Name = "Enable Feature",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            -- Enable logic
            elements.speedSlider:Set(100)  -- Set slider to max when enabled
        else
            -- Disable logic
            elements.speedSlider:Set(1)    -- Reset slider when disabled
        end
    end
})

-- Remove elements dynamically
local function cleanup()
    for name, element in pairs(elements) do
        element:Remove()
    end
end
```

### Conditional Element Creation

```lua
local MainTab = Window:CreateTab("Main")

-- Create base elements
local modeDropdown = MainTab:CreateDropdown({
    Name = "Mode",
    Options = {"Basic", "Advanced"},
    CurrentOption = {"Basic"},
    Callback = function(Option)
        local mode = Option[1]
        
        if mode == "Advanced" then
            -- Create advanced options
            advancedSlider = MainTab:CreateSlider({
                Name = "Advanced Setting",
                Range = {0, 1000},
                CurrentValue = 500,
                Callback = function(Value)
                    print("Advanced:", Value)
                end
            })
        else
            -- Remove advanced options if they exist
            if advancedSlider then
                advancedSlider:Remove()
                advancedSlider = nil
            end
        end
    end
})
```

### Tab Switching Control

```lua
-- Create multiple tabs
local HomeTab = Window:CreateTab("Home")
local SettingsTab = Window:CreateTab("Settings")
local AboutTab = Window:CreateTab("About")

-- Create navigation buttons
HomeTab:CreateButton({
    Name = "Go to Settings",
    Callback = function()
        Window:SelectTab("Settings")
    end
})

SettingsTab:CreateButton({
    Name = "Back to Home",
    Callback = function()
        Window:SelectTab("Home")
    end
})

-- Get current tab
print("Current tab:", Window.CurrentTab.Name)
```

### Bulk Element Updates

```lua
-- Store all toggles
local toggles = {}

toggles.feature1 = Tab:CreateToggle({
    Name = "Feature 1",
    CurrentValue = false,
    Callback = function(Value) end
})

toggles.feature2 = Tab:CreateToggle({
    Name = "Feature 2",
    CurrentValue = false,
    Callback = function(Value) end
})

toggles.feature3 = Tab:CreateToggle({
    Name = "Feature 3",
    CurrentValue = false,
    Callback = function(Value) end
})

-- Create master toggle
Tab:CreateToggle({
    Name = "Enable All Features",
    CurrentValue = false,
    Callback = function(Value)
        -- Update all toggles at once
        for name, toggle in pairs(toggles) do
            toggle:Set(Value)
        end
    end
})
```

## Configuration System

The configuration system automatically saves and loads element values.

### Setup Configuration

```lua
local Window = Mercury:CreateWindow({
    Name = "My Script",
    ConfigurationSaving = {
        Enabled = true,                 -- Enable auto-save
        FileName = "MyScriptConfig"     -- Config file name
    }
})
```

### Flag System

Add the `Flag` parameter to any element to include it in configuration:

```lua
-- Elements with flags will be saved
Tab:CreateToggle({
    Name = "Auto Farm",
    Flag = "AutoFarm",                  -- Unique identifier
    CurrentValue = false,
    Callback = function(Value) end
})

Tab:CreateSlider({
    Name = "Speed",
    Flag = "PlayerSpeed",               -- Unique identifier
    Range = {1, 100},
    CurrentValue = 50,
    Callback = function(Value) end
})
```

### Manual Configuration Control

```lua
-- Load configuration manually
Mercury:LoadConfiguration()

-- Configuration is automatically saved when:
-- - Element values change
-- - Flag is present on the element

-- File location: workspace/Mercury/Configurations/FileName.json
```

### Configuration Best Practices

```lua
-- Use descriptive flag names
Flag = "MainTab_AutoFarm"              -- Good: Clear and unique
Flag = "Toggle1"                       -- Avoid: Generic

-- Don't reuse flag names
local Tab1Toggle = Tab1:CreateToggle({
    Flag = "AutoFarm",                 -- Conflict!
    -- ...
})

local Tab2Toggle = Tab2:CreateToggle({
    Flag = "AutoFarm",                 -- Conflict!
    -- ...
})
```

## Error Handling

Mercury includes built-in error handling for all callbacks.

### Error Notifications

```lua
-- Enable/disable error notifications
Mercury:SetErrorNotifications(true)    -- Show error popups (default)
Mercury:SetErrorNotifications(false)   -- Silent mode (still logs to console)

-- Check current setting
local enabled = Mercury:GetErrorNotifications()
```

### Error Handling in Callbacks

```lua
-- Errors in callbacks are automatically caught
Tab:CreateButton({
    Name = "Test Error",
    Callback = function()
        error("This error will be caught!")
        -- User sees notification
        -- Error logged to console
        -- Script continues running
    end
})

-- Safe callback pattern
Tab:CreateToggle({
    Name = "Safe Toggle",
    CurrentValue = false,
    Callback = function(Value)
        local success, err = pcall(function()
            -- Your code here
            if not someCondition then
                error("Custom error message")
            end
        end)
        
        if not success then
            print("Handled error:", err)
        end
    end
})
```

## Complete Examples

### Example 1: Simple Script Hub

```lua
local Mercury = loadstring(game:HttpGet("https://raw.githubusercontent.com/superfastisfast/MercuryInterface/main/Mercury.lua"))()

local Window = Mercury:CreateWindow({
    Name = "Simple Hub",
    ToggleKey = Enum.KeyCode.RightShift
})

local MainTab = Window:CreateTab("Main")

MainTab:CreateSection("Player")

MainTab:CreateSlider({
    Name = "Walk Speed",
    Range = {16, 200},
    Increment = 1,
    CurrentValue = 16,
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
    end
})

MainTab:CreateSlider({
    Name = "Jump Power",
    Range = {50, 500},
    Increment = 10,
    CurrentValue = 50,
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
    end
})

MainTab:CreateButton({
    Name = "Reset Character",
    Callback = function()
        game.Players.LocalPlayer.Character.Humanoid.Health = 0
    end
})
```

### Example 2: Advanced Script with Configuration

```lua
local Mercury = loadstring(game:HttpGet("https://raw.githubusercontent.com/superfastisfast/MercuryInterface/main/Mercury.lua"))()

-- Global variables
_G.AutoFarm = false
_G.FarmSpeed = 50
_G.SelectedWeapon = "Sword"

local Window = Mercury:CreateWindow({
    Name = "Advanced Hub",
    ToggleKey = Enum.KeyCode.RightShift,
    ConfigurationSaving = {
        Enabled = true,
        FileName = "AdvancedHub"
    }
})

-- Main Tab
local MainTab = Window:CreateTab("Main")

MainTab:CreateSection("Automation")

local AutoFarmToggle = MainTab:CreateToggle({
    Name = "Auto Farm",
    CurrentValue = false,
    Flag = "AutoFarm",
    Callback = function(Value)
        _G.AutoFarm = Value
        if Value then
            Mercury:Notify({
                Title = "Auto Farm",
                Content = "Auto farm enabled",
                Duration = 2
            })
        end
    end
})

local SpeedSlider = MainTab:CreateSlider({
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
    Name = "Weapon",
    Options = {"Sword", "Bow", "Staff"},
    CurrentOption = {"Sword"},
    Flag = "SelectedWeapon",
    Callback = function(Option)
        _G.SelectedWeapon = Option[1]
    end
})

MainTab:CreateSection("Player Stats")

MainTab:CreateLabel("Current Level: 45")

MainTab:CreateParagraph({
    Title = "Farm Statistics",
    Content = "Total farmed: 0\nTime elapsed: 0s\nItems per minute: 0"
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
        Mercury:Notify({
            Title = "Theme Changed",
            Content = "UI theme set to " .. Option[1],
            Duration = 2
        })
    end
})

SettingsTab:CreateKeybind({
    Name = "Toggle UI",
    CurrentKeybind = "RightShift",
    Flag = "UIKeybind",
    Callback = function(Key)
        Window:Toggle()
    end
})

SettingsTab:CreateSection("Notifications")

SettingsTab:CreateToggle({
    Name = "Error Notifications",
    CurrentValue = true,
    Flag = "ErrorNotifs",
    Callback = function(Value)
        Mercury:SetErrorNotifications(Value)
    end
})

SettingsTab:CreateButton({
    Name = "Test Notification",
    Callback = function()
        Mercury:Notify({
            Title = "Test",
            Content = "This is a test notification!",
            Duration = 3
        })
    end
})

SettingsTab:CreateSection("Configuration")

SettingsTab:CreateButton({
    Name = "Reload Configuration",
    Callback = function()
        Mercury:LoadConfiguration()
        Mercury:Notify({
            Title = "Configuration",
            Content = "Settings reloaded",
            Duration = 2
        })
    end
})

-- Load saved configuration
Mercury:LoadConfiguration()
```

### Example 3: Dynamic UI Updates

```lua
local Mercury = loadstring(game:HttpGet("https://raw.githubusercontent.com/superfastisfast/MercuryInterface/main/Mercury.lua"))()

local Window = Mercury:CreateWindow({
    Name = "Dynamic UI Example"
})

local Tab = Window:CreateTab("Main")

-- Create status label
local StatusLabel = Tab:CreateLabel("Status: Idle")

-- Create progress paragraph
local ProgressParagraph = Tab:CreateParagraph({
    Title = "Progress",
    Content = "0/100 items collected"
})

-- Simulation variables
local itemsCollected = 0
local isRunning = false

-- Start button
Tab:CreateButton({
    Name = "Start Collection",
    Callback = function()
        if isRunning then return end
        isRunning = true
        
        StatusLabel:Set("Status: Running", Color3.fromRGB(0, 255, 0))
        
        -- Simulate collection process
        task.spawn(function()
            for i = 1, 100 do
                if not isRunning then break end
                
                itemsCollected = i
                ProgressParagraph:Set({
                    Title = "Progress",
                    Content = string.format("%d/100 items collected\nCompletion: %d%%", i, i)
                })
                
                task.wait(0.1)
            end
            
            isRunning = false
            StatusLabel:Set("Status: Complete", Color3.fromRGB(255, 255, 0))
        end)
    end
})

-- Stop button
Tab:CreateButton({
    Name = "Stop Collection",
    Callback = function()
        isRunning = false
        StatusLabel:Set("Status: Stopped", Color3.fromRGB(255, 0, 0))
    end
})

-- Reset button
Tab:CreateButton({
    Name = "Reset Progress",
    Callback = function()
        itemsCollected = 0
        isRunning = false
        StatusLabel:Set("Status: Idle", Color3.fromRGB(255, 255, 255))
        ProgressParagraph:Set({
            Title = "Progress",
            Content = "0/100 items collected"
        })
    end
})
```

## Best Practices

### Organization

```lua
-- Structure your UI logically
local Window = Mercury:CreateWindow({Name = "My Script"})

-- Group related features in tabs
local CombatTab = Window:CreateTab("Combat")
local MovementTab = Window:CreateTab("Movement")
local VisualsTab = Window:CreateTab("Visuals")
local SettingsTab = Window:CreateTab("Settings")

-- Use sections within tabs
CombatTab:CreateSection("Weapons")
-- Weapon-related elements here

CombatTab:CreateSection("Abilities")
-- Ability-related elements here
```

### Performance

```lua
-- Store element references when you need to update them frequently
local elements = {
    statusLabel = Tab:CreateLabel("Status: Ready"),
    progressBar = Tab:CreateSlider({
        Name = "Progress",
        Range = {0, 100},
        CurrentValue = 0,
        Callback = function() end
    })
}

-- Update efficiently
game:GetService("RunService").Heartbeat:Connect(function()
    -- Only update when necessary
    if needsUpdate then
        elements.progressBar:Set(currentProgress)
    end
end)
```

### User Experience

```lua
-- Provide clear feedback
Tab:CreateButton({
    Name = "Execute Action",
    Callback = function()
        Mercury:Notify({
            Title = "Action Executed",
            Content = "The action completed successfully",
            Duration = 2
        })
    end
})

-- Use sensible defaults
Tab:CreateSlider({
    Name = "Speed",
    Range = {1, 100},
    Increment = 1,              -- Easy to control
    Suffix = "%",               -- Clear units
    CurrentValue = 50,          -- Safe default
    Callback = function(Value) end
})

-- Group related controls
Tab:CreateSection("Auto Farm Settings")
Tab:CreateToggle({Name = "Enable Auto Farm", ...})
Tab:CreateSlider({Name = "Farm Speed", ...})
Tab:CreateDropdown({Name = "Farm Location", ...})
```

### Configuration Management

```lua
-- Use consistent naming for flags
local PREFIX = "MyScript_"

Tab:CreateToggle({
    Name = "Feature 1",
    Flag = PREFIX .. "Feature1",        -- "MyScript_Feature1"
    CurrentValue = false,
    Callback = function(Value) end
})

Tab:CreateToggle({
    Name = "Feature 2",
    Flag = PREFIX .. "Feature2",        -- "MyScript_Feature2"
    CurrentValue = false,
    Callback = function(Value) end
})
```

### Error Prevention

```lua
-- Validate input in callbacks
Tab:CreateInput({
    Name = "Player Name",
    Callback = function(Text)
        if Text == "" then
            Mercury:Notify({
                Title = "Error",
                Content = "Please enter a valid name",
                Duration = 3
            })
            return
        end
        
        -- Process valid input
        print("Player name set to:", Text)
    end
})

-- Check for nil values
Tab:CreateDropdown({
    Name = "Select Option",
    Options = {"Option 1", "Option 2"},
    Callback = function(Options)
        if not Options or #Options == 0 then
            return
        end
        
        local selected = Options[1]
        print("Selected:", selected)
    end
})
```

## Library Methods

### Global Functions

```lua
-- Notifications
Mercury:Notify({
    Title = "Notification Title",      -- String: Notification title
    Content = "Notification content",  -- String: Notification message
    Duration = 5                       -- Number: Display time in seconds
})

-- Theme Management
Mercury:SetTheme("Ocean")              -- Set default theme for new windows
local themes = Mercury:GetThemes()     -- Returns table of all theme names

-- Error Handling
Mercury:SetErrorNotifications(true)    -- Enable error notifications
local enabled = Mercury:GetErrorNotifications()  -- Check if enabled

-- Configuration
Mercury:LoadConfiguration()            -- Manually load saved configuration
```

## Credits

Mercury Interactive is based on [Rayfield Interface Suite](https://github.com/shlexware/Rayfield) by Sirius Software.

Modifications include:
- Removed startup sequences and loading screens
- Removed branding and analytics
- Added enhanced window control methods
- Added tab management functions
- Added element control methods (Get, SetCallback, Remove)
- Added dynamic range updates for sliders
- Added dropdown refresh functionality
- Simplified codebase
- Added additional themes
- Improved error handling
- Enhanced documentation

## License

MIT License - see LICENSE file for details.

Based on Rayfield Interface Suite by Sirius Software.

## Support

For issues or questions, please open an issue on the [GitHub repository](https://github.com/superfastisfast/MercuryInterface/issues).

## Changelog

### Version 1.0.0
- Initial release
- Complete element control API
- Seven built-in themes
- Configuration system
- Error handling
- Mobile support

---

Repository: [github.com/superfastisfast/MercuryInterface](https://github.com/superfastisfast/MercuryInterface)

Documentation: [Full API Reference](#table-of-contents)

Examples: [Complete Examples](#complete-examples)
