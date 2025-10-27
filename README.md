# Mercury UI Library - Documentation

A modern, feature-rich UI library for Roblox with smooth animations, drag support, and extensive customization options.

---

## Table of Contents

1. [Installation](#installation)
2. [Quick Start](#quick-start)
3. [Creating Windows](#creating-windows)
4. [Creating Tabs](#creating-tabs)
5. [UI Elements](#ui-elements)
6. [Window Management](#window-management)
7. [Themes](#themes)
8. [Notifications](#notifications)
9. [Configuration System](#configuration-system)
10. [Advanced Features](#advanced-features)
11. [Complete Examples](#complete-examples)

---

## Installation

Load the library with the following code:

```lua
local Mercury = loadstring(game:HttpGet("https://raw.githubusercontent.com/superfastisfast/MercuryInteractive/main/Mercury.lua"))()
```

---

## Quick Start

Minimal example to get started:

```lua
local Mercury = loadstring(game:HttpGet("https://raw.githubusercontent.com/superfastisfast/MercuryInteractive/main/Mercury.lua"))()

local Window = Mercury:CreateWindow({
    Name = "My Script",
    ToggleKey = Enum.KeyCode.RightShift
})

local Tab = Window:CreateTab("Main")

Tab:CreateButton({
    Name = "Click Me",
    Callback = function()
        print("Button clicked!")
    end
})
```

---

## Creating Windows

### Basic Window

```lua
local Window = Mercury:CreateWindow({
    Name = "Window Title",
    ToggleKey = Enum.KeyCode.RightShift,
    ConfigurationSaving = {
        Enabled = true,
        FileName = "MyConfig"
    }
})
```

### Window Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `Name` | string | "Mercury" | Window title displayed in topbar |
| `ToggleKey` | KeyCode | nil | Key to show/hide the UI |
| `ConfigurationSaving.Enabled` | boolean | false | Enable automatic config saving |
| `ConfigurationSaving.FileName` | string | PlaceId | Name of the config file |

---

## Creating Tabs

Tabs organize your UI into different sections.

```lua
local MainTab = Window:CreateTab("Main")
local SettingsTab = Window:CreateTab("Settings")
local CreditsTab = Window:CreateTab("About")
```

### Tab Methods

```lua
-- Get all elements in a tab
local elements = MainTab:GetElements()

-- Remove a tab
MainTab:Remove()
```

---

## UI Elements

### Button

Creates a clickable button that executes a function.

```lua
local Button = Tab:CreateButton({
    Name = "Button Name",
    Callback = function()
        print("Button pressed")
    end
})
```

**Methods:**
```lua
Button:Set("New Name")                    -- Change button text
Button:SetCallback(function() end)        -- Update callback function
Button:SetLocked(true)                    -- Disable interaction
Button:Remove()                           -- Delete button
```

---

### Toggle

Creates an on/off switch.

```lua
local Toggle = Tab:CreateToggle({
    Name = "Toggle Name",
    CurrentValue = false,
    Flag = "Toggle1",
    Callback = function(Value)
        print("Toggle state:", Value)
    end
})
```

**Parameters:**
- `Name` (string) - Display name
- `CurrentValue` (boolean) - Initial state
- `Flag` (string) - Config save identifier
- `Callback` (function) - Function called when toggled

**Methods:**
```lua
Toggle:Set(true)                          -- Set toggle state
local state = Toggle:Get()                -- Get current state
Toggle:SetCallback(function(Value) end)   -- Update callback
Toggle:SetLocked(false)                   -- Enable/disable
Toggle:Remove()                           -- Delete toggle
```

---

### Slider

Creates a draggable slider for numeric values.

```lua
local Slider = Tab:CreateSlider({
    Name = "Slider Name",
    Range = {0, 100},
    Increment = 1,
    CurrentValue = 50,
    Suffix = "%",
    Flag = "Slider1",
    Callback = function(Value)
        print("Slider value:", Value)
    end
})
```

**Parameters:**
- `Name` (string) - Display name
- `Range` (table) - {Min, Max} values
- `Increment` (number) - Step size
- `CurrentValue` (number) - Starting value
- `Suffix` (string) - Text after value (optional)
- `Flag` (string) - Config save identifier
- `Callback` (function) - Function called when changed

**Methods:**
```lua
Slider:Set(75)                            -- Set slider value
local value = Slider:Get()                -- Get current value
Slider:SetRange({0, 200})                 -- Update min/max
Slider:SetCallback(function(Value) end)   -- Update callback
Slider:SetLocked(true)                    -- Enable/disable
Slider:Remove()                           -- Delete slider
```

---

### Dropdown

Creates a selection menu with single or multiple choice.

```lua
-- Single selection
local Dropdown = Tab:CreateDropdown({
    Name = "Select Option",
    Options = {"Option 1", "Option 2", "Option 3"},
    CurrentOption = {"Option 1"},
    MultipleOptions = false,
    Flag = "Dropdown1",
    Callback = function(Options)
        print("Selected:", Options[1])
    end
})

-- Multiple selection
local MultiDropdown = Tab:CreateDropdown({
    Name = "Select Multiple",
    Options = {"Item 1", "Item 2", "Item 3"},
    CurrentOption = {},
    MultipleOptions = true,
    Flag = "MultiDropdown1",
    Callback = function(Options)
        for _, option in ipairs(Options) do
            print("Selected:", option)
        end
    end
})
```

**Parameters:**
- `Name` (string) - Display name
- `Options` (table) - Array of option strings
- `CurrentOption` (table) - Array of selected options
- `MultipleOptions` (boolean) - Allow multiple selections
- `Flag` (string) - Config save identifier
- `Callback` (function) - Function called when selection changes

**Methods:**
```lua
Dropdown:Set({"Option 2"})                -- Set selected option(s)
local selected = Dropdown:Get()           -- Get current selection
Dropdown:Refresh({"New", "Options"})      -- Update available options
Dropdown:SetCallback(function(Options) end) -- Update callback
Dropdown:SetLocked(false)                 -- Enable/disable
Dropdown:Remove()                         -- Delete dropdown
```

---

### Input

Creates a text input field.

```lua
local Input = Tab:CreateInput({
    Name = "Input Name",
    Placeholder = "Enter text...",
    CurrentValue = "",
    Flag = "Input1",
    Callback = function(Text)
        print("Input text:", Text)
    end
})
```

**Parameters:**
- `Name` (string) - Display name
- `Placeholder` (string) - Placeholder text
- `CurrentValue` (string) - Initial text
- `Flag` (string) - Config save identifier
- `Callback` (function) - Function called when text is entered

**Methods:**
```lua
Input:Set("New text")                     -- Set input text
local text = Input:Get()                  -- Get current text
Input:SetPlaceholder("New placeholder")   -- Update placeholder
Input:SetCallback(function(Text) end)     -- Update callback
Input:SetLocked(true)                     -- Enable/disable
Input:Remove()                            -- Delete input
```

---

### Keybind

Creates a keybind selector that triggers a function.

```lua
local Keybind = Tab:CreateKeybind({
    Name = "Keybind Name",
    CurrentKeybind = "E",
    Flag = "Keybind1",
    Callback = function(Key)
        print("Key pressed:", Key)
    end
})
```

**Parameters:**
- `Name` (string) - Display name
- `CurrentKeybind` (string) - Initial key name
- `Flag` (string) - Config save identifier
- `Callback` (function) - Function called when key is pressed

**Methods:**
```lua
Keybind:Set("Q")                          -- Set keybind
local key = Keybind:Get()                 -- Get current keybind
Keybind:SetCallback(function(Key) end)    -- Update callback
Keybind:SetLocked(false)                  -- Enable/disable
Keybind:Remove()                          -- Delete keybind
```

**Usage:**
Click the keybind box and press any key to set it. The callback fires when that key is pressed during gameplay.

---

### Color Picker

Creates a color selection button.

```lua
local ColorPicker = Tab:CreateColorPicker({
    Name = "Color Name",
    Color = Color3.fromRGB(255, 0, 0),
    Flag = "Color1",
    Callback = function(Color)
        print("Color changed:", Color)
    end
})
```

**Parameters:**
- `Name` (string) - Display name
- `Color` (Color3) - Initial color
- `Flag` (string) - Config save identifier
- `Callback` (function) - Function called when color changes

**Methods:**
```lua
ColorPicker:Set(Color3.fromRGB(0, 255, 0)) -- Set color
local color = ColorPicker:Get()            -- Get current color
ColorPicker:SetCallback(function(Color) end) -- Update callback
ColorPicker:SetLocked(true)                -- Enable/disable
ColorPicker:Remove()                       -- Delete color picker
```

---

### Label

Creates a text label for display purposes.

```lua
local Label = Tab:CreateLabel("Label Text", {
    Color = Color3.fromRGB(255, 255, 255)  -- Optional
})
```

**Methods:**
```lua
Label:Set("New text", Color3.fromRGB(255, 0, 0)) -- Update text and color
Label:SetVisible(false)                    -- Show/hide label
Label:Remove()                             -- Delete label
```

---

## Window Management

### Visibility Control

```lua
Window:Toggle()                           -- Toggle visibility
Window:Show()                             -- Show window
Window:Hide()                             -- Hide window
local visible = Window:IsVisible()        -- Check if visible
```

### Size Control

```lua
Window:Minimize()                         -- Minimize to topbar
Window:Maximize()                         -- Restore full size
local minimized = Window:IsMinimized()    -- Check if minimized
```

### Tab Control

```lua
Window:SelectTab("TabName")               -- Switch to a tab
local tabs = Window:GetTabs()             -- Get all tabs
```

### Window Destruction

```lua
Window:Destroy()                          -- Remove window completely
```

---

## Themes

Mercury includes multiple pre-built themes.

### Available Themes

- `Default` - Classic dark theme
- `Ocean` - Blue/teal color scheme
- `Light` - Light mode
- `Midnight` - Deep blue theme
- `Forest` - Green nature theme
- `Sunset` - Pink/orange warm theme
- `Purple` - Purple accent theme

### Setting Themes

```lua
-- Set on window
Window:SetTheme("Ocean")

-- Set globally
Mercury:SetTheme("Midnight")

-- Get list of themes
local themes = Mercury:GetThemes()
for _, theme in ipairs(themes) do
    print(theme)
end
```

### Custom Themes

Create your own theme by passing a table:

```lua
local CustomTheme = {
    TextColor = Color3.fromRGB(255, 255, 255),
    Background = Color3.fromRGB(30, 30, 30),
    Topbar = Color3.fromRGB(40, 40, 40),
    ElementBackground = Color3.fromRGB(35, 35, 35),
    ElementBackgroundHover = Color3.fromRGB(45, 45, 45),
    AccentColor = Color3.fromRGB(100, 150, 255),
    -- Add more colors as needed
}

Mercury:SetTheme(CustomTheme)
```

---

## Notifications

Display temporary notifications to users.

```lua
Mercury:Notify({
    Title = "Notification Title",
    Content = "Notification message",
    Duration = 3,
    Type = "Default"  -- Default, Success, Warning, Error
})
```

**Parameters:**
- `Title` (string) - Notification title
- `Content` (string) - Notification message
- `Duration` (number) - Display time in seconds
- `Type` (string) - Notification style

**Types:**
- `"Default"` - Blue accent
- `"Success"` - Green accent
- `"Warning"` - Yellow accent
- `"Error"` - Red accent

---

## Configuration System

Mercury automatically saves and loads element values using flags.

### Enabling Auto-Save

```lua
local Window = Mercury:CreateWindow({
    Name = "My Script",
    ConfigurationSaving = {
        Enabled = true,
        FileName = "MyScript"
    }
})
```

### Using Flags

Any element with a `Flag` parameter will be saved:

```lua
local Toggle = Tab:CreateToggle({
    Name = "Auto Farm",
    Flag = "AutoFarm",  -- This value will be saved
    Callback = function(Value)
        -- Your code
    end
})
```

### Manual Config Management

```lua
-- Load configuration
Mercury:LoadConfiguration()

-- Access saved values
local value = Mercury.Flags["AutoFarm"]:Get()

-- Set values programmatically
Mercury.Flags["AutoFarm"]:Set(true)
```

### Config File Location

Configs are saved to: `workspace/Mercury/Configurations/YourFileName.json`

---

## Advanced Features

### Element Locking

Temporarily disable user interaction:

```lua
Toggle:SetLocked(true)   -- Disable element
Toggle:SetLocked(false)  -- Enable element
```

### Element Visibility

Control label visibility:

```lua
Label:SetVisible(false)  -- Hide
Label:SetVisible(true)   -- Show
```

### Error Notifications

Control whether callback errors show notifications:

```lua
Mercury:SetErrorNotifications(true)   -- Enable
Mercury:SetErrorNotifications(false)  -- Disable
local enabled = Mercury:GetErrorNotifications()
```

### Batch Operations

Iterate through elements:

```lua
local elements = Tab:GetElements()
for _, element in ipairs(elements) do
    if element.Type == "Toggle" then
        element:SetLocked(true)
    end
end
```

---

## Complete Examples

### Basic Script Hub

```lua
local Mercury = loadstring(game:HttpGet("https://raw.githubusercontent.com/superfastisfast/MercuryInteractive/main/Mercury.lua"))()

local Window = Mercury:CreateWindow({
    Name = "Script Hub",
    ToggleKey = Enum.KeyCode.RightControl,
    ConfigurationSaving = {
        Enabled = true,
        FileName = "ScriptHub"
    }
})

Window:SetTheme("Ocean")

local MainTab = Window:CreateTab("Main")

MainTab:CreateLabel("Welcome to Script Hub")

MainTab:CreateButton({
    Name = "Execute Script",
    Callback = function()
        Mercury:Notify({
            Title = "Executed",
            Content = "Script executed successfully!",
            Type = "Success"
        })
    end
})

Mercury:Notify({
    Title = "Loaded",
    Content = "Script Hub loaded successfully",
    Duration = 5,
    Type = "Success"
})
```

### Player Modifications

```lua
local Mercury = loadstring(game:HttpGet("https://raw.githubusercontent.com/superfastisfast/MercuryInteractive/main/Mercury.lua"))()

local Window = Mercury:CreateWindow({
    Name = "Player Mods",
    ToggleKey = Enum.KeyCode.RightShift,
    ConfigurationSaving = {
        Enabled = true,
        FileName = "PlayerMods"
    }
})

local PlayerTab = Window:CreateTab("Player")

local SpeedSlider = PlayerTab:CreateSlider({
    Name = "Walk Speed",
    Range = {16, 200},
    Increment = 1,
    CurrentValue = 16,
    Flag = "WalkSpeed",
    Callback = function(Value)
        local player = game.Players.LocalPlayer
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = Value
        end
    end
})

local JumpSlider = PlayerTab:CreateSlider({
    Name = "Jump Power",
    Range = {50, 300},
    Increment = 1,
    CurrentValue = 50,
    Flag = "JumpPower",
    Callback = function(Value)
        local player = game.Players.LocalPlayer
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.JumpPower = Value
        end
    end
})

local FlyToggle = PlayerTab:CreateToggle({
    Name = "Fly",
    CurrentValue = false,
    Flag = "FlyEnabled",
    Callback = function(Value)
        if Value then
            -- Enable fly code
            Mercury:Notify({
                Title = "Fly",
                Content = "Fly enabled",
                Type = "Success"
            })
        else
            -- Disable fly code
        end
    end
})
```

### ESP Configuration

```lua
local Mercury = loadstring(game:HttpGet("https://raw.githubusercontent.com/superfastisfast/MercuryInteractive/main/Mercury.lua"))()

local Window = Mercury:CreateWindow({
    Name = "ESP Config",
    ToggleKey = Enum.KeyCode.Insert
})

local ESPTab = Window:CreateTab("ESP")

local ESPToggle = ESPTab:CreateToggle({
    Name = "Enable ESP",
    CurrentValue = false,
    Flag = "ESPEnabled",
    Callback = function(Value)
        -- Toggle ESP
    end
})

local ESPColor = ESPTab:CreateColorPicker({
    Name = "ESP Color",
    Color = Color3.fromRGB(255, 0, 0),
    Flag = "ESPColor",
    Callback = function(Color)
        -- Update ESP color
    end
})

local ESPDistance = ESPTab:CreateSlider({
    Name = "Max Distance",
    Range = {0, 5000},
    Increment = 10,
    CurrentValue = 1000,
    Suffix = " studs",
    Flag = "ESPDistance",
    Callback = function(Value)
        -- Update ESP distance
    end
})

local ESPType = ESPTab:CreateDropdown({
    Name = "ESP Type",
    Options = {"Box", "Tracer", "Both"},
    CurrentOption = {"Box"},
    Flag = "ESPType",
    Callback = function(Option)
        -- Change ESP type
    end
})
```

### Settings Menu

```lua
local Mercury = loadstring(game:HttpGet("https://raw.githubusercontent.com/superfastisfast/MercuryInteractive/main/Mercury.lua"))()

local Window = Mercury:CreateWindow({
    Name = "My Script",
    ToggleKey = Enum.KeyCode.RightShift
})

local SettingsTab = Window:CreateTab("Settings")

local ThemeDropdown = SettingsTab:CreateDropdown({
    Name = "Theme",
    Options = Mercury:GetThemes(),
    CurrentOption = {"Default"},
    Callback = function(Option)
        Window:SetTheme(Option[1])
    end
})

local UIKeybind = SettingsTab:CreateKeybind({
    Name = "Toggle UI",
    CurrentKeybind = "RightShift",
    Callback = function()
        Window:Toggle()
    end
})

SettingsTab:CreateButton({
    Name = "Reset Configuration",
    Callback = function()
        Mercury:Notify({
            Title = "Reset",
            Content = "Configuration has been reset",
            Type = "Warning"
        })
    end
})

SettingsTab:CreateLabel("Version 1.0.0")
```

---

## Best Practices

### Organization
- Use descriptive tab names
- Group related elements together
- Use labels to separate sections

### Flags
- Give flags unique, descriptive names
- Use flags for any setting you want to save
- Follow a naming convention (e.g., "Tab_ElementName")

### Callbacks
- Keep callbacks short and efficient
- Handle errors gracefully
- Use notifications for user feedback

### Performance
- Don't create elements in loops
- Remove unused elements
- Use element locking instead of creating/destroying

### User Experience
- Provide clear element names
- Use appropriate value ranges
- Add helpful notifications
- Choose readable themes

---

## API Reference Summary

### Library Functions
- `Mercury:CreateWindow(Settings)` - Create a new window
- `Mercury:Notify(Settings)` - Show notification
- `Mercury:SetTheme(Theme)` - Set global theme
- `Mercury:GetThemes()` - Get available themes
- `Mercury:LoadConfiguration()` - Load saved config
- `Mercury:SetErrorNotifications(Boolean)` - Toggle error notifications
- `Mercury:GetErrorNotifications()` - Get error notification state

### Window Methods
- `Window:CreateTab(Name)` - Create new tab
- `Window:SetTheme(Theme)` - Set window theme
- `Window:Toggle()` - Toggle visibility
- `Window:Show()` - Show window
- `Window:Hide()` - Hide window
- `Window:IsVisible()` - Check visibility
- `Window:Minimize()` - Minimize window
- `Window:Maximize()` - Maximize window
- `Window:IsMinimized()` - Check if minimized
- `Window:SelectTab(Name)` - Switch tabs
- `Window:GetTabs()` - Get all tabs
- `Window:Destroy()` - Destroy window

### Tab Methods
- `Tab:CreateButton(Settings)` - Create button
- `Tab:CreateToggle(Settings)` - Create toggle
- `Tab:CreateSlider(Settings)` - Create slider
- `Tab:CreateDropdown(Settings)` - Create dropdown
- `Tab:CreateInput(Settings)` - Create input
- `Tab:CreateKeybind(Settings)` - Create keybind
- `Tab:CreateColorPicker(Settings)` - Create color picker
- `Tab:CreateLabel(Text, Settings)` - Create label
- `Tab:GetElements()` - Get all elements
- `Tab:Remove()` - Remove tab

### Element Methods (Common)
- `:Set(Value)` - Set element value
- `:Get()` - Get current value
- `:SetCallback(Function)` - Update callback
- `:SetLocked(Boolean)` - Lock/unlock element
- `:Remove()` - Delete element

---

## Support

For issues, updates, and support:
- GitHub: https://github.com/superfastisfast/MercuryInteractive

---

**Mercury UI Library - Professional Roblox UI Framework**

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
