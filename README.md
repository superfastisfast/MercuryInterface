Here's a more professional GitHub repository structure for Mercury Interface:

## **Repository Structure:**

```
Mercury-Interface/
├── README.md
├── LICENSE
├── CHANGELOG.md
├── .gitignore
├── docs/
│   ├── getting-started.md
│   ├── api-reference.md
│   ├── themes.md
│   └── examples.md
├── src/
│   └── Mercury.lua
├── examples/
│   ├── basic-usage.lua
│   ├── all-elements.lua
│   ├── custom-theme.lua
│   └── advanced-features.lua
└── assets/
    └── screenshots/
```

## **README.md Template:**

```markdown
# Mercury Interface

A modern UI library for Roblox scripts, based on Rayfield Interface Suite.

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Version](https://img.shields.io/badge/version-1.0.0-brightgreen.svg)]()

[Documentation](docs/api-reference.md) | [Examples](examples/) | [Themes](docs/themes.md)

---

## Overview

Mercury Interface is a clean, minimal UI library designed for Roblox script interfaces. Built on the foundation of Rayfield Interface Suite, Mercury removes unnecessary startup sequences and branding while maintaining full functionality and adding enhanced control features.

### Key Features

- **Instant Loading** - No startup animations or loading screens
- **Seven Built-in Themes** - Professional color schemes for different preferences
- **Configuration System** - Automatic saving and loading of user settings
- **Complete Control API** - Full programmatic control over window state
- **Mobile Compatible** - Touch-friendly interface design
- **Rich Element Library** - Comprehensive set of UI components
- **Smooth Animations** - Polished transitions using TweenService
- **Keybind System** - Custom hotkey support for UI and elements

## Installation

### Loadstring Method (Recommended)
```lua
local Mercury = loadstring(game:HttpGet("https://raw.githubusercontent.com/yourusername/Mercury-Interface/main/src/Mercury.lua"))()
```

### Manual Installation
Download `src/Mercury.lua` and include it in your script.

## Quick Start

```lua
local Mercury = loadstring(game:HttpGet("https://raw.githubusercontent.com/yourusername/Mercury-Interface/main/src/Mercury.lua"))()

local Window = Mercury:CreateWindow({
    Name = "Script Hub",
    ToggleKey = Enum.KeyCode.RightShift,
    ConfigurationSaving = {
        Enabled = true,
        FileName = "MyConfig"
    }
})

local Tab = Window:CreateTab("Main")

Tab:CreateButton({
    Name = "Execute Action",
    Callback = function()
        print("Action executed")
    end
})

Tab:CreateToggle({
    Name = "Feature Toggle",
    CurrentValue = false,
    Flag = "Toggle1",
    Callback = function(Value)
        print("Toggle state:", Value)
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

Change themes programmatically:
```lua
Window:SetTheme("Ocean")
```

View all themes: [Theme Documentation](docs/themes.md)

## Documentation

### Window API

```lua
Window:SetTheme(themeName)    -- Change UI theme
Window:Toggle()                 -- Toggle visibility
Window:Show()                   -- Show window
Window:Hide()                   -- Hide window
Window:Minimize()              -- Minimize window
Window:Maximize()              -- Maximize window
Window:Destroy()               -- Remove window
Window:IsVisible()             -- Check visibility state
```

### UI Elements

Mercury provides the following UI components:

- **Button** - Clickable action buttons
- **Toggle** - Boolean on/off switches
- **Slider** - Numeric value adjustment
- **Dropdown** - Single or multiple selection menus
- **Input** - Text input fields
- **Label** - Static text display
- **Section** - Organizational headers
- **Paragraph** - Multi-line text blocks
- **Divider** - Visual section separators
- **Keybind** - Hotkey binding interface
- **ColorPicker** - Color selection tool

Full API documentation: [API Reference](docs/api-reference.md)

## Example Usage

### Complete Feature Hub

```lua
local Mercury = loadstring(game:HttpGet("https://raw.githubusercontent.com/yourusername/Mercury-Interface/main/src/Mercury.lua"))()

local Window = Mercury:CreateWindow({
    Name = "Feature Hub",
    ToggleKey = Enum.KeyCode.RightShift,
    ConfigurationSaving = {
        Enabled = true,
        FileName = "FeatureHub"
    }
})

local MainTab = Window:CreateTab("Main Features")
local SettingsTab = Window:CreateTab("Settings")

-- Main Features
MainTab:CreateSection("Automation")

MainTab:CreateToggle({
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

-- Settings
SettingsTab:CreateDropdown({
    Name = "Theme Selection",
    Options = {"Default", "Ocean", "Light", "Midnight", "Forest", "Sunset", "Purple"},
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
        print("UI keybind set to:", Key)
    end
})
```

Additional examples: [Examples Directory](examples/)

## Configuration Saving

Mercury automatically saves element states when configuration saving is enabled:

```lua
ConfigurationSaving = {
    Enabled = true,
    FileName = "MyScript"  -- Saved as MyScript.json
}
```

Configurations are stored in `workspace/Mercury/Configurations/` directory.

Load saved configuration:
```lua
Mercury:LoadConfiguration()
```

## Credits

Mercury Interface is based on [Rayfield Interface Suite](https://github.com/shlexware/Rayfield) by Sirius Software.

Mercury modifications include:
- Removed startup sequences and loading screens
- Removed branding and credits
- Added enhanced window control methods
- Simplified codebase
- Added additional themes
- Improved element controllability

## Contributing

Contributions are welcome. Please follow these guidelines:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request with a clear description

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.

## Support

For issues, questions, or suggestions:
- Open an issue on GitHub
- Check existing documentation
- Review example scripts

---

Mercury Interface | Based on Rayfield Interface Suite
```

## **Key Documentation Files:**

### **docs/getting-started.md**
```markdown
# Getting Started with Mercury Interface

## Installation

[Installation instructions]

## Basic Window Creation

[Basic examples]

## Element Overview

[Element descriptions]

## Configuration System

[Configuration guide]
```

### **docs/api-reference.md**
```markdown
# API Reference

## Mercury Library

### Mercury:CreateWindow(Settings)
[Detailed documentation]

### Mercury:LoadConfiguration()
[Detailed documentation]

### Mercury:Notify(Settings)
[Detailed documentation]

## Window Methods

[All window methods documented]

## Element Methods

[All element methods documented]
```

### **CHANGELOG.md**
```markdown
# Changelog

All notable changes to Mercury Interface will be documented in this file.

## [1.0.0] - 2025-01-XX

### Added
- Initial release based on Rayfield Interface Suite
- Seven built-in themes
- Full element suite with all UI components
- Configuration saving and loading system
- Enhanced window control methods
- Keybind support for UI toggling
- ColorPicker element
- Dropdown refresh method
- Comprehensive API for element control

### Changed
- Removed startup animations and loading screens
- Removed branding and credit systems
- Simplified codebase for better performance
- Improved element controllability

### Removed
- Analytics and telemetry
- Discord integration
- Key system functionality
- Promotional notifications
```

### **LICENSE (MIT)**
```
MIT License

Copyright (c) 2025 [Your Name]
Based on Rayfield Interface Suite by Sirius Software

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
