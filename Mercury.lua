function Tab:CreateLabel(Text, Icon, Color)
			local Label = Elements.Template.Label:Clone()
			Label.Title.Text = Text
			Label.Visible = true
			Label.Parent = TabPage
			
			if Color then
				Label.BackgroundColor3 = Color
			end
			
			local LabelValue = {}
			function LabelValue:Set(NewText, NewColor)
				Label.Title.Text = NewText
				if NewColor then
					Label.BackgroundColor3 = NewColor
				end
			end
			
			return LabelValue
		end--[[
	Mercury Interface Suite
	Clean, minimal UI library
]]

local function getService(name)
	local service = game:GetService(name)
	return if cloneref then cloneref(service) else service
end

local HttpService = getService('HttpService')
local RunService = getService('RunService')
local UserInputService = getService("UserInputService")
local TweenService = getService("TweenService")
local Players = getService("Players")
local CoreGui = getService("CoreGui")

-- Configuration
local MercuryFolder = "Mercury"
local ConfigurationFolder = MercuryFolder.."/Configurations"
local ConfigurationExtension = ".json"
local CFileName = nil
local CEnabled = false
local ErrorNotificationsEnabled = true -- Global error notification setting

-- Create folders if needed
if isfolder and not isfolder(MercuryFolder) then
	makefolder(MercuryFolder)
end

if isfolder and not isfolder(ConfigurationFolder) then
	makefolder(ConfigurationFolder)
end

local MercuryLibrary = {
	Flags = {},
	Theme = {
		Default = {
			TextColor = Color3.fromRGB(240, 240, 240),
			Background = Color3.fromRGB(25, 25, 25),
			Topbar = Color3.fromRGB(34, 34, 34),
			Shadow = Color3.fromRGB(20, 20, 20),
			TabBackground = Color3.fromRGB(80, 80, 80),
			TabStroke = Color3.fromRGB(85, 85, 85),
			TabBackgroundSelected = Color3.fromRGB(210, 210, 210),
			TabTextColor = Color3.fromRGB(240, 240, 240),
			SelectedTabTextColor = Color3.fromRGB(50, 50, 50),
			ElementBackground = Color3.fromRGB(35, 35, 35),
			ElementBackgroundHover = Color3.fromRGB(40, 40, 40),
			SecondaryElementBackground = Color3.fromRGB(25, 25, 25),
			ElementStroke = Color3.fromRGB(50, 50, 50),
			SecondaryElementStroke = Color3.fromRGB(40, 40, 40),
			SliderBackground = Color3.fromRGB(50, 138, 220),
			SliderProgress = Color3.fromRGB(50, 138, 220),
			SliderStroke = Color3.fromRGB(58, 163, 255),
			ToggleBackground = Color3.fromRGB(30, 30, 30),
			ToggleEnabled = Color3.fromRGB(0, 146, 214),
			ToggleDisabled = Color3.fromRGB(100, 100, 100),
			ToggleEnabledStroke = Color3.fromRGB(0, 170, 255),
			ToggleDisabledStroke = Color3.fromRGB(125, 125, 125),
			ToggleEnabledOuterStroke = Color3.fromRGB(100, 100, 100),
			ToggleDisabledOuterStroke = Color3.fromRGB(65, 65, 65),
			DropdownSelected = Color3.fromRGB(40, 40, 40),
			DropdownUnselected = Color3.fromRGB(30, 30, 30),
			InputBackground = Color3.fromRGB(30, 30, 30),
			InputStroke = Color3.fromRGB(65, 65, 65),
			PlaceholderColor = Color3.fromRGB(178, 178, 178)
		},
		
		Ocean = {
			TextColor = Color3.fromRGB(230, 240, 240),
			Background = Color3.fromRGB(20, 30, 30),
			Topbar = Color3.fromRGB(25, 40, 40),
			Shadow = Color3.fromRGB(15, 20, 20),
			TabBackground = Color3.fromRGB(40, 60, 60),
			TabStroke = Color3.fromRGB(50, 70, 70),
			TabBackgroundSelected = Color3.fromRGB(100, 180, 180),
			TabTextColor = Color3.fromRGB(210, 230, 230),
			SelectedTabTextColor = Color3.fromRGB(20, 50, 50),
			ElementBackground = Color3.fromRGB(30, 50, 50),
			ElementBackgroundHover = Color3.fromRGB(40, 60, 60),
			SecondaryElementBackground = Color3.fromRGB(30, 45, 45),
			ElementStroke = Color3.fromRGB(45, 70, 70),
			SecondaryElementStroke = Color3.fromRGB(40, 65, 65),
			SliderBackground = Color3.fromRGB(0, 110, 110),
			SliderProgress = Color3.fromRGB(0, 140, 140),
			SliderStroke = Color3.fromRGB(0, 160, 160),
			ToggleBackground = Color3.fromRGB(30, 50, 50),
			ToggleEnabled = Color3.fromRGB(0, 130, 130),
			ToggleDisabled = Color3.fromRGB(70, 90, 90),
			ToggleEnabledStroke = Color3.fromRGB(0, 160, 160),
			ToggleDisabledStroke = Color3.fromRGB(85, 105, 105),
			ToggleEnabledOuterStroke = Color3.fromRGB(50, 100, 100),
			ToggleDisabledOuterStroke = Color3.fromRGB(45, 65, 65),
			DropdownSelected = Color3.fromRGB(30, 60, 60),
			DropdownUnselected = Color3.fromRGB(25, 40, 40),
			InputBackground = Color3.fromRGB(30, 50, 50),
			InputStroke = Color3.fromRGB(50, 70, 70),
			PlaceholderColor = Color3.fromRGB(140, 160, 160)
		},
		
		Light = {
			TextColor = Color3.fromRGB(40, 40, 40),
			Background = Color3.fromRGB(245, 245, 245),
			Topbar = Color3.fromRGB(230, 230, 230),
			Shadow = Color3.fromRGB(200, 200, 200),
			TabBackground = Color3.fromRGB(235, 235, 235),
			TabStroke = Color3.fromRGB(215, 215, 215),
			TabBackgroundSelected = Color3.fromRGB(255, 255, 255),
			TabTextColor = Color3.fromRGB(80, 80, 80),
			SelectedTabTextColor = Color3.fromRGB(0, 0, 0),
			ElementBackground = Color3.fromRGB(240, 240, 240),
			ElementBackgroundHover = Color3.fromRGB(225, 225, 225),
			SecondaryElementBackground = Color3.fromRGB(235, 235, 235),
			ElementStroke = Color3.fromRGB(210, 210, 210),
			SecondaryElementStroke = Color3.fromRGB(210, 210, 210),
			SliderBackground = Color3.fromRGB(150, 180, 220),
			SliderProgress = Color3.fromRGB(100, 150, 200),
			SliderStroke = Color3.fromRGB(120, 170, 220),
			ToggleBackground = Color3.fromRGB(220, 220, 220),
			ToggleEnabled = Color3.fromRGB(0, 146, 214),
			ToggleDisabled = Color3.fromRGB(150, 150, 150),
			ToggleEnabledStroke = Color3.fromRGB(0, 170, 255),
			ToggleDisabledStroke = Color3.fromRGB(170, 170, 170),
			ToggleEnabledOuterStroke = Color3.fromRGB(100, 100, 100),
			ToggleDisabledOuterStroke = Color3.fromRGB(180, 180, 180),
			DropdownSelected = Color3.fromRGB(230, 230, 230),
			DropdownUnselected = Color3.fromRGB(220, 220, 220),
			InputBackground = Color3.fromRGB(240, 240, 240),
			InputStroke = Color3.fromRGB(180, 180, 180),
			PlaceholderColor = Color3.fromRGB(140, 140, 140)
		},
		
		Midnight = {
			TextColor = Color3.fromRGB(200, 200, 220),
			Background = Color3.fromRGB(15, 15, 25),
			Topbar = Color3.fromRGB(20, 20, 35),
			Shadow = Color3.fromRGB(10, 10, 15),
			TabBackground = Color3.fromRGB(30, 30, 50),
			TabStroke = Color3.fromRGB(40, 40, 60),
			TabBackgroundSelected = Color3.fromRGB(80, 80, 150),
			TabTextColor = Color3.fromRGB(180, 180, 200),
			SelectedTabTextColor = Color3.fromRGB(255, 255, 255),
			ElementBackground = Color3.fromRGB(25, 25, 40),
			ElementBackgroundHover = Color3.fromRGB(30, 30, 50),
			SecondaryElementBackground = Color3.fromRGB(20, 20, 35),
			ElementStroke = Color3.fromRGB(40, 40, 60),
			SecondaryElementStroke = Color3.fromRGB(35, 35, 55),
			SliderBackground = Color3.fromRGB(60, 60, 120),
			SliderProgress = Color3.fromRGB(100, 100, 200),
			SliderStroke = Color3.fromRGB(120, 120, 220),
			ToggleBackground = Color3.fromRGB(25, 25, 40),
			ToggleEnabled = Color3.fromRGB(100, 100, 200),
			ToggleDisabled = Color3.fromRGB(60, 60, 80),
			ToggleEnabledStroke = Color3.fromRGB(130, 130, 230),
			ToggleDisabledStroke = Color3.fromRGB(80, 80, 100),
			ToggleEnabledOuterStroke = Color3.fromRGB(70, 70, 120),
			ToggleDisabledOuterStroke = Color3.fromRGB(50, 50, 70),
			DropdownSelected = Color3.fromRGB(30, 30, 50),
			DropdownUnselected = Color3.fromRGB(25, 25, 40),
			InputBackground = Color3.fromRGB(25, 25, 40),
			InputStroke = Color3.fromRGB(50, 50, 70),
			PlaceholderColor = Color3.fromRGB(120, 120, 140)
		},
		
		Forest = {
			TextColor = Color3.fromRGB(220, 240, 220),
			Background = Color3.fromRGB(20, 30, 20),
			Topbar = Color3.fromRGB(25, 40, 25),
			Shadow = Color3.fromRGB(15, 20, 15),
			TabBackground = Color3.fromRGB(40, 60, 40),
			TabStroke = Color3.fromRGB(50, 70, 50),
			TabBackgroundSelected = Color3.fromRGB(80, 150, 80),
			TabTextColor = Color3.fromRGB(200, 220, 200),
			SelectedTabTextColor = Color3.fromRGB(20, 40, 20),
			ElementBackground = Color3.fromRGB(30, 45, 30),
			ElementBackgroundHover = Color3.fromRGB(40, 55, 40),
			SecondaryElementBackground = Color3.fromRGB(25, 40, 25),
			ElementStroke = Color3.fromRGB(50, 70, 50),
			SecondaryElementStroke = Color3.fromRGB(45, 65, 45),
			SliderBackground = Color3.fromRGB(60, 120, 60),
			SliderProgress = Color3.fromRGB(80, 160, 80),
			SliderStroke = Color3.fromRGB(100, 180, 100),
			ToggleBackground = Color3.fromRGB(30, 45, 30),
			ToggleEnabled = Color3.fromRGB(70, 150, 70),
			ToggleDisabled = Color3.fromRGB(60, 80, 60),
			ToggleEnabledStroke = Color3.fromRGB(90, 180, 90),
			ToggleDisabledStroke = Color3.fromRGB(80, 100, 80),
			ToggleEnabledOuterStroke = Color3.fromRGB(50, 100, 50),
			ToggleDisabledOuterStroke = Color3.fromRGB(40, 60, 40),
			DropdownSelected = Color3.fromRGB(35, 55, 35),
			DropdownUnselected = Color3.fromRGB(30, 45, 30),
			InputBackground = Color3.fromRGB(30, 45, 30),
			InputStroke = Color3.fromRGB(50, 70, 50),
			PlaceholderColor = Color3.fromRGB(130, 150, 130)
		},
		
		Sunset = {
			TextColor = Color3.fromRGB(255, 240, 230),
			Background = Color3.fromRGB(40, 25, 30),
			Topbar = Color3.fromRGB(50, 30, 35),
			Shadow = Color3.fromRGB(30, 20, 25),
			TabBackground = Color3.fromRGB(70, 40, 50),
			TabStroke = Color3.fromRGB(80, 50, 60),
			TabBackgroundSelected = Color3.fromRGB(220, 100, 120),
			TabTextColor = Color3.fromRGB(240, 220, 230),
			SelectedTabTextColor = Color3.fromRGB(40, 20, 30),
			ElementBackground = Color3.fromRGB(55, 35, 45),
			ElementBackgroundHover = Color3.fromRGB(65, 45, 55),
			SecondaryElementBackground = Color3.fromRGB(50, 30, 40),
			ElementStroke = Color3.fromRGB(80, 50, 65),
			SecondaryElementStroke = Color3.fromRGB(70, 45, 60),
			SliderBackground = Color3.fromRGB(200, 80, 100),
			SliderProgress = Color3.fromRGB(240, 120, 140),
			SliderStroke = Color3.fromRGB(255, 140, 160),
			ToggleBackground = Color3.fromRGB(55, 35, 45),
			ToggleEnabled = Color3.fromRGB(230, 100, 120),
			ToggleDisabled = Color3.fromRGB(90, 60, 70),
			ToggleEnabledStroke = Color3.fromRGB(255, 130, 150),
			ToggleDisabledStroke = Color3.fromRGB(110, 75, 85),
			ToggleEnabledOuterStroke = Color3.fromRGB(180, 70, 90),
			ToggleDisabledOuterStroke = Color3.fromRGB(70, 50, 60),
			DropdownSelected = Color3.fromRGB(65, 45, 55),
			DropdownUnselected = Color3.fromRGB(55, 35, 45),
			InputBackground = Color3.fromRGB(55, 35, 45),
			InputStroke = Color3.fromRGB(80, 50, 65),
			PlaceholderColor = Color3.fromRGB(180, 150, 160)
		},
		
		Purple = {
			TextColor = Color3.fromRGB(240, 230, 255),
			Background = Color3.fromRGB(25, 20, 40),
			Topbar = Color3.fromRGB(35, 25, 50),
			Shadow = Color3.fromRGB(20, 15, 30),
			TabBackground = Color3.fromRGB(50, 40, 80),
			TabStroke = Color3.fromRGB(60, 45, 90),
			TabBackgroundSelected = Color3.fromRGB(150, 100, 200),
			TabTextColor = Color3.fromRGB(220, 210, 240),
			SelectedTabTextColor = Color3.fromRGB(40, 20, 60),
			ElementBackground = Color3.fromRGB(40, 30, 60),
			ElementBackgroundHover = Color3.fromRGB(50, 40, 70),
			SecondaryElementBackground = Color3.fromRGB(35, 25, 55),
			ElementStroke = Color3.fromRGB(65, 50, 90),
			SecondaryElementStroke = Color3.fromRGB(60, 45, 85),
			SliderBackground = Color3.fromRGB(100, 60, 150),
			SliderProgress = Color3.fromRGB(140, 90, 200),
			SliderStroke = Color3.fromRGB(160, 110, 220),
			ToggleBackground = Color3.fromRGB(40, 30, 60),
			ToggleEnabled = Color3.fromRGB(130, 80, 180),
			ToggleDisabled = Color3.fromRGB(80, 60, 100),
			ToggleEnabledStroke = Color3.fromRGB(160, 110, 210),
			ToggleDisabledStroke = Color3.fromRGB(100, 80, 120),
			ToggleEnabledOuterStroke = Color3.fromRGB(90, 60, 130),
			ToggleDisabledOuterStroke = Color3.fromRGB(65, 50, 85),
			DropdownSelected = Color3.fromRGB(50, 40, 70),
			DropdownUnselected = Color3.fromRGB(40, 30, 60),
			InputBackground = Color3.fromRGB(40, 30, 60),
			InputStroke = Color3.fromRGB(70, 55, 95),
			PlaceholderColor = Color3.fromRGB(160, 140, 180)
		}
	}
}

local SelectedTheme = MercuryLibrary.Theme.Default
local Hidden = false
local Minimized = false
local Debounce = false

local function ChangeTheme(Theme)
	if typeof(Theme) == 'string' then
		SelectedTheme = MercuryLibrary.Theme[Theme]
	elseif typeof(Theme) == 'table' then
		SelectedTheme = Theme
	end
	
	-- Apply theme to all elements (will be implemented per window)
end

-- Utility Functions
local function PackColor(Color)
	return {R = Color.R * 255, G = Color.G * 255, B = Color.B * 255}
end    

local function UnpackColor(Color)
	return Color3.fromRGB(Color.R, Color.G, Color.B)
end

local function SaveConfiguration()
	if not CEnabled then return end
	
	local Data = {}
	for i, v in pairs(MercuryLibrary.Flags) do
		if v.Type == "ColorPicker" then
			Data[i] = PackColor(v.Color)
		else
			Data[i] = v.CurrentValue or v.CurrentKeybind or v.CurrentOption or v.Color
		end
	end
	
	if writefile then
		writefile(ConfigurationFolder .. "/" .. CFileName .. ConfigurationExtension, HttpService:JSONEncode(Data))
	end
end

local function LoadConfiguration(Configuration)
	local success, Data = pcall(function() return HttpService:JSONDecode(Configuration) end)
	if not success then return end
	
	for FlagName, Flag in pairs(MercuryLibrary.Flags) do
		local FlagValue = Data[FlagName]
		if FlagValue ~= nil then
			task.spawn(function()
				if Flag.Type == "ColorPicker" then
					Flag:Set(UnpackColor(FlagValue))
				else
					Flag:Set(FlagValue)
				end
			end)
		end
	end
end

function MercuryLibrary:LoadConfiguration()
	if CEnabled and isfile and isfile(ConfigurationFolder .. "/" .. CFileName .. ConfigurationExtension) then
		LoadConfiguration(readfile(ConfigurationFolder .. "/" .. CFileName .. ConfigurationExtension))
	end
end

function MercuryLibrary:Notify(Settings)
	task.spawn(function()
		Settings = Settings or {}
		local Title = Settings.Title or "Notification"
		local Content = Settings.Content or ""
		local Duration = Settings.Duration or 3
		
		print("[Mercury] " .. Title .. ": " .. Content)
		
		-- Create notification UI element if Mercury interface exists
		-- This would need the actual notification template from the UI
	end)
end

function MercuryLibrary:SetTheme(ThemeName)
	if typeof(ThemeName) == 'string' and MercuryLibrary.Theme[ThemeName] then
		ChangeTheme(ThemeName)
	elseif typeof(ThemeName) == 'table' then
		ChangeTheme(ThemeName)
	end
end

function MercuryLibrary:GetThemes()
	local themes = {}
	for name, _ in pairs(MercuryLibrary.Theme) do
		table.insert(themes, name)
	end
	return themes
end

function MercuryLibrary:SetErrorNotifications(enabled)
	ErrorNotificationsEnabled = enabled
end

function MercuryLibrary:GetErrorNotifications()
	return ErrorNotificationsEnabled
end

local function ShowError(elementName, errorMessage)
	if ErrorNotificationsEnabled then
		warn("Mercury Error [" .. elementName .. "]: " .. tostring(errorMessage))
		MercuryLibrary:Notify({
			Title = "Callback Error",
			Content = elementName .. " encountered an error. Check console for details.",
			Duration = 3
		})
	else
		-- Still log to console even if notifications disabled
		warn("Mercury Error [" .. elementName .. "]: " .. tostring(errorMessage))
	end
end

function MercuryLibrary:CreateWindow(Settings)
	Settings = Settings or {}
	
	-- Create UI
	local Mercury = game:GetObjects("rbxassetid://10804731440")[1]
	Mercury.Name = "Mercury"
	Mercury.Enabled = false
	
	if gethui then
		Mercury.Parent = gethui()
	else
		Mercury.Parent = CoreGui
	end
	
	-- Remove old instances
	if gethui then
		for _, Interface in ipairs(gethui():GetChildren()) do
			if Interface.Name == "Mercury" and Interface ~= Mercury then
				Interface:Destroy()
			end
		end
	end
	
	local Main = Mercury.Main
	local Topbar = Main.Topbar
	local Elements = Main.Elements
	local TabList = Main.TabList
	
	-- Configure
	Topbar.Title.Text = Settings.Name or "Mercury"
	Mercury.Enabled = true
	Main.Visible = true
	
	-- Configuration saving
	if Settings.ConfigurationSaving then
		CFileName = Settings.ConfigurationSaving.FileName or tostring(game.PlaceId)
		CEnabled = Settings.ConfigurationSaving.Enabled or false
	end
	
	-- Window object
	local Window = {}
	
	-- Theme management
	function Window:SetTheme(ThemeName)
		if typeof(ThemeName) == 'string' and MercuryLibrary.Theme[ThemeName] then
			ChangeTheme(ThemeName)
			-- Apply theme colors
			Main.BackgroundColor3 = SelectedTheme.Background
			Topbar.BackgroundColor3 = SelectedTheme.Topbar
		end
	end
	
	-- Visibility control
	function Window:Toggle()
		Hidden = not Hidden
		Mercury.Enabled = not Hidden
	end
	
	function Window:Show()
		Hidden = false
		Mercury.Enabled = true
	end
	
	function Window:Hide()
		Hidden = true
		Mercury.Enabled = false
	end
	
	function Window:IsVisible()
		return not Hidden
	end
	
	-- Size control
	function Window:Minimize()
		if Minimized then return end
		Minimized = true
		TweenService:Create(Main, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {
			Size = UDim2.new(0, 500, 0, 45)
		}):Play()
	end
	
	function Window:Maximize()
		if not Minimized then return end
		Minimized = false
		TweenService:Create(Main, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {
			Size = UDim2.new(0, 500, 0, 475)
		}):Play()
	end
	
	-- Destroy window
	function Window:Destroy()
		Mercury:Destroy()
	end
	
	-- Keybind for toggling UI
	if Settings.ToggleKey then
		UserInputService.InputBegan:Connect(function(input, processed)
			if processed then return end
			if input.KeyCode == Settings.ToggleKey then
				Window:Toggle()
			end
		end)
	end
	
	function Window:CreateTab(Name, Icon)
		local Tab = {}
		
		-- Create tab button
		local TabButton = TabList.Template:Clone()
		TabButton.Name = Name
		TabButton.Title.Text = Name
		TabButton.Visible = true
		TabButton.Parent = TabList
		
		-- Create tab page
		local TabPage = Elements.Template:Clone()
		TabPage.Name = Name
		TabPage.Visible = true
		TabPage.Parent = Elements
		
		-- Tab button click
		TabButton.Interact.MouseButton1Click:Connect(function()
			Elements.UIPageLayout:JumpTo(TabPage)
			
			for _, btn in ipairs(TabList:GetChildren()) do
				if btn:IsA("Frame") and btn.Name ~= "Template" then
					if btn == TabButton then
						btn.BackgroundColor3 = SelectedTheme.TabBackgroundSelected
						btn.Title.TextColor3 = SelectedTheme.SelectedTabTextColor
					else
						btn.BackgroundColor3 = SelectedTheme.TabBackground
						btn.Title.TextColor3 = SelectedTheme.TabTextColor
					end
				end
			end
		end)
		
		-- Elements
		function Tab:CreateSection(SectionName)
			local Section = Elements.Template.SectionTitle:Clone()
			Section.Title.Text = SectionName
			Section.Visible = true
			Section.Parent = TabPage
			
			local SectionValue = {}
			function SectionValue:Set(NewName)
				Section.Title.Text = NewName
			end
			
			return SectionValue
		end
		
		function Tab:CreateParagraph(ParagraphSettings)
			local Paragraph = Elements.Template.Paragraph:Clone()
			Paragraph.Title.Text = ParagraphSettings.Title
			Paragraph.Content.Text = ParagraphSettings.Content
			Paragraph.Visible = true
			Paragraph.Parent = TabPage
			
			local ParagraphValue = {}
			function ParagraphValue:Set(NewSettings)
				Paragraph.Title.Text = NewSettings.Title
				Paragraph.Content.Text = NewSettings.Content
			end
			
			return ParagraphValue
		end
		
		function Tab:CreateDivider()
			local Divider = Elements.Template.Divider:Clone()
			Divider.Visible = true
			Divider.Parent = TabPage
			
			local DividerValue = {}
			function DividerValue:Set(Visible)
				Divider.Visible = Visible
			end
			
			return DividerValue
		end
		function Tab:CreateButton(ButtonSettings)
			local Button = Elements.Template.Button:Clone()
			Button.Name = ButtonSettings.Name
			Button.Title.Text = ButtonSettings.Name
			Button.Visible = true
			Button.Parent = TabPage
			
			Button.Interact.MouseButton1Click:Connect(function()
				local success, err = pcall(ButtonSettings.Callback)
				if not success then
					ShowError(ButtonSettings.Name, err)
				end
			end)
			
			local ButtonValue = {}
			function ButtonValue:Set(NewName)
				Button.Title.Text = NewName
				Button.Name = NewName
			end
			
			return ButtonValue
		end
		
		function Tab:CreateToggle(ToggleSettings)
			local Toggle = Elements.Template.Toggle:Clone()
			Toggle.Name = ToggleSettings.Name
			Toggle.Title.Text = ToggleSettings.Name
			Toggle.Visible = true
			Toggle.Parent = TabPage
			
			ToggleSettings.CurrentValue = ToggleSettings.CurrentValue or false
			
			Toggle.Interact.MouseButton1Click:Connect(function()
				ToggleSettings.CurrentValue = not ToggleSettings.CurrentValue
				local success, err = pcall(ToggleSettings.Callback, ToggleSettings.CurrentValue)
				if not success then
					ShowError(ToggleSettings.Name, err)
				end
				SaveConfiguration()
			end)
			
			function ToggleSettings:Set(Value)
				ToggleSettings.CurrentValue = Value
				local success, err = pcall(ToggleSettings.Callback, Value)
				if not success then
					ShowError(ToggleSettings.Name, err)
				end
				SaveConfiguration()
			end
			
			if ToggleSettings.Flag then
				MercuryLibrary.Flags[ToggleSettings.Flag] = ToggleSettings
			end
			
			return ToggleSettings
		end
		
		function Tab:CreateSlider(SliderSettings)
			local Slider = Elements.Template.Slider:Clone()
			Slider.Name = SliderSettings.Name
			Slider.Title.Text = SliderSettings.Name
			Slider.Visible = true
			Slider.Parent = TabPage
			
			SliderSettings.CurrentValue = SliderSettings.CurrentValue or SliderSettings.Range[1]
			SliderSettings.Range = SliderSettings.Range or {0, 100}
			SliderSettings.Increment = SliderSettings.Increment or 1
			
			local Dragging = false
			local SliderMain = Slider.Main
			local Progress = SliderMain.Progress
			local Info = SliderMain.Information
			
			local function UpdateSlider(Value)
				local Percentage = (Value - SliderSettings.Range[1]) / (SliderSettings.Range[2] - SliderSettings.Range[1])
				Progress.Size = UDim2.new(Percentage, 0, 1, 0)
				
				if SliderSettings.Suffix then
					Info.Text = tostring(Value) .. " " .. SliderSettings.Suffix
				else
					Info.Text = tostring(Value)
				end
				
				SliderSettings.CurrentValue = Value
			end
			
			UpdateSlider(SliderSettings.CurrentValue)
			
			SliderMain.Interact.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					Dragging = true
				end
			end)
			
			SliderMain.Interact.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					Dragging = false
				end
			end)
			
			UserInputService.InputChanged:Connect(function(input)
				if Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
					local MousePos = UserInputService:GetMouseLocation().X
					local SliderPos = SliderMain.AbsolutePosition.X
					local SliderSize = SliderMain.AbsoluteSize.X
					
					local Percentage = math.clamp((MousePos - SliderPos) / SliderSize, 0, 1)
					local Value = SliderSettings.Range[1] + (Percentage * (SliderSettings.Range[2] - SliderSettings.Range[1]))
					Value = math.floor(Value / SliderSettings.Increment + 0.5) * SliderSettings.Increment
					Value = math.clamp(Value, SliderSettings.Range[1], SliderSettings.Range[2])
					
					UpdateSlider(Value)
					pcall(SliderSettings.Callback, Value)
					SaveConfiguration()
				end
			end)
			
			function SliderSettings:Set(Value)
				Value = math.clamp(Value, SliderSettings.Range[1], SliderSettings.Range[2])
				UpdateSlider(Value)
				local success, err = pcall(SliderSettings.Callback, Value)
				if not success then
					ShowError(SliderSettings.Name, err)
				end
				SaveConfiguration()
			end
			
			if SliderSettings.Flag then
				MercuryLibrary.Flags[SliderSettings.Flag] = SliderSettings
			end
			
			return SliderSettings
		end
		
		function Tab:CreateDropdown(DropdownSettings)
			local Dropdown = Elements.Template.Dropdown:Clone()
			Dropdown.Name = DropdownSettings.Name
			Dropdown.Title.Text = DropdownSettings.Name
			Dropdown.Visible = true
			Dropdown.Parent = TabPage
			
			DropdownSettings.CurrentOption = DropdownSettings.CurrentOption or {}
			DropdownSettings.Options = DropdownSettings.Options or {}
			DropdownSettings.MultipleOptions = DropdownSettings.MultipleOptions or false
			
			if type(DropdownSettings.CurrentOption) == "string" then
				DropdownSettings.CurrentOption = {DropdownSettings.CurrentOption}
			end
			
			local DropdownList = Dropdown.List
			local Selected = Dropdown.Selected
			local IsOpen = false
			
			local function UpdateText()
				if #DropdownSettings.CurrentOption == 0 then
					Selected.Text = "None"
				elseif #DropdownSettings.CurrentOption == 1 then
					Selected.Text = DropdownSettings.CurrentOption[1]
				else
					Selected.Text = "Multiple"
				end
			end
			
			UpdateText()
			DropdownList.Visible = false
			
			-- Clear existing options
			for _, child in ipairs(DropdownList:GetChildren()) do
				if child:IsA("Frame") and child.Name ~= "Template" then
					child:Destroy()
				end
			end
			
			-- Create options
			for _, option in ipairs(DropdownSettings.Options) do
				local OptionFrame = DropdownList.Template:Clone()
				OptionFrame.Name = option
				OptionFrame.Title.Text = option
				OptionFrame.Visible = true
				OptionFrame.Parent = DropdownList
				
				OptionFrame.Interact.MouseButton1Click:Connect(function()
					if table.find(DropdownSettings.CurrentOption, option) then
						-- Remove option
						table.remove(DropdownSettings.CurrentOption, table.find(DropdownSettings.CurrentOption, option))
					else
						-- Add option
						if not DropdownSettings.MultipleOptions then
							table.clear(DropdownSettings.CurrentOption)
						end
						table.insert(DropdownSettings.CurrentOption, option)
					end
					
					UpdateText()
					pcall(DropdownSettings.Callback, DropdownSettings.CurrentOption)
					SaveConfiguration()
					
					if not DropdownSettings.MultipleOptions then
						DropdownList.Visible = false
						IsOpen = false
					end
				end)
			end
			
			Dropdown.Interact.MouseButton1Click:Connect(function()
				IsOpen = not IsOpen
				DropdownList.Visible = IsOpen
			end)
			
			function DropdownSettings:Set(Option)
				if type(Option) == "string" then
					Option = {Option}
				end
				
				DropdownSettings.CurrentOption = Option
				UpdateText()
				pcall(DropdownSettings.Callback, Option)
				SaveConfiguration()
			end
			
			function DropdownSettings:Refresh(NewOptions)
				DropdownSettings.Options = NewOptions
				
				-- Clear and recreate options
				for _, child in ipairs(DropdownList:GetChildren()) do
					if child:IsA("Frame") and child.Name ~= "Template" then
						child:Destroy()
					end
				end
				
				for _, option in ipairs(NewOptions) do
					local OptionFrame = DropdownList.Template:Clone()
					OptionFrame.Name = option
					OptionFrame.Title.Text = option
					OptionFrame.Visible = true
					OptionFrame.Parent = DropdownList
					
					OptionFrame.Interact.MouseButton1Click:Connect(function()
						if table.find(DropdownSettings.CurrentOption, option) then
							table.remove(DropdownSettings.CurrentOption, table.find(DropdownSettings.CurrentOption, option))
						else
							if not DropdownSettings.MultipleOptions then
								table.clear(DropdownSettings.CurrentOption)
							end
							table.insert(DropdownSettings.CurrentOption, option)
						end
						
						UpdateText()
						pcall(DropdownSettings.Callback, DropdownSettings.CurrentOption)
						SaveConfiguration()
						
						if not DropdownSettings.MultipleOptions then
							DropdownList.Visible = false
							IsOpen = false
						end
					end)
				end
			end
			
			if DropdownSettings.Flag then
				MercuryLibrary.Flags[DropdownSettings.Flag] = DropdownSettings
			end
			
			return DropdownSettings
		end
		
		function Tab:CreateInput(InputSettings)
			local Input = Elements.Template.Input:Clone()
			Input.Name = InputSettings.Name
			Input.Title.Text = InputSettings.Name
			Input.Visible = true
			Input.Parent = TabPage
			
			Input.InputFrame.InputBox.FocusLost:Connect(function()
				InputSettings.CurrentValue = Input.InputFrame.InputBox.Text
				pcall(InputSettings.Callback, InputSettings.CurrentValue)
				SaveConfiguration()
			end)
			
			function InputSettings:Set(Text)
				Input.InputFrame.InputBox.Text = Text
				InputSettings.CurrentValue = Text
				pcall(InputSettings.Callback, Text)
				SaveConfiguration()
			end
			
			if InputSettings.Flag then
				MercuryLibrary.Flags[InputSettings.Flag] = InputSettings
			end
			
			return InputSettings
		end
		
		function Tab:CreateKeybind(KeybindSettings)
			local Keybind = Elements.Template.Keybind:Clone()
			Keybind.Name = KeybindSettings.Name
			Keybind.Title.Text = KeybindSettings.Name
			Keybind.Visible = true
			Keybind.Parent = TabPage
			
			KeybindSettings.CurrentKeybind = KeybindSettings.CurrentKeybind or "None"
			Keybind.KeybindFrame.KeybindBox.Text = KeybindSettings.CurrentKeybind
			
			local CheckingForKey = false
			
			Keybind.KeybindFrame.KeybindBox.Focused:Connect(function()
				CheckingForKey = true
				Keybind.KeybindFrame.KeybindBox.Text = "..."
			end)
			
			Keybind.KeybindFrame.KeybindBox.FocusLost:Connect(function()
				CheckingForKey = false
				if Keybind.KeybindFrame.KeybindBox.Text == "..." then
					Keybind.KeybindFrame.KeybindBox.Text = KeybindSettings.CurrentKeybind
				end
			end)
			
			UserInputService.InputBegan:Connect(function(input, processed)
				if CheckingForKey and input.KeyCode ~= Enum.KeyCode.Unknown then
					local NewKey = input.KeyCode.Name
					Keybind.KeybindFrame.KeybindBox.Text = NewKey
					KeybindSettings.CurrentKeybind = NewKey
					Keybind.KeybindFrame.KeybindBox:ReleaseFocus()
					SaveConfiguration()
				elseif not processed and input.KeyCode.Name == KeybindSettings.CurrentKeybind then
					pcall(KeybindSettings.Callback, KeybindSettings.CurrentKeybind)
				end
			end)
			
			function KeybindSettings:Set(NewKeybind)
				Keybind.KeybindFrame.KeybindBox.Text = NewKeybind
				KeybindSettings.CurrentKeybind = NewKeybind
				SaveConfiguration()
			end
			
			if KeybindSettings.Flag then
				MercuryLibrary.Flags[KeybindSettings.Flag] = KeybindSettings
			end
			
			return KeybindSettings
		end
		
		function Tab:CreateColorPicker(ColorPickerSettings)
			local ColorPicker = Elements.Template.ColorPicker:Clone()
			ColorPicker.Name = ColorPickerSettings.Name
			ColorPicker.Title.Text = ColorPickerSettings.Name
			ColorPicker.Visible = true
			ColorPicker.Parent = TabPage
			
			ColorPickerSettings.Color = ColorPickerSettings.Color or Color3.fromRGB(255, 255, 255)
			ColorPickerSettings.Type = "ColorPicker"
			
			-- Color picker logic (simplified)
			local Display = ColorPicker.CPBackground.Display
			Display.BackgroundColor3 = ColorPickerSettings.Color
			
			ColorPicker.Interact.MouseButton1Click:Connect(function()
				-- Toggle color picker interface
			end)
			
			function ColorPickerSettings:Set(NewColor)
				ColorPickerSettings.Color = NewColor
				Display.BackgroundColor3 = NewColor
				pcall(ColorPickerSettings.Callback, NewColor)
				SaveConfiguration()
			end
			
			if ColorPickerSettings.Flag then
				MercuryLibrary.Flags[ColorPickerSettings.Flag] = ColorPickerSettings
			end
			
			return ColorPickerSettings
		end
		
		return Tab
	end
	
	-- Auto-load configuration after 1 second
	task.delay(1, function()
		MercuryLibrary:LoadConfiguration()
	end)
	
	return Window
end

return MercuryLibrary
