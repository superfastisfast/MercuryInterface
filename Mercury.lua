

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
local ErrorNotificationsEnabled = true

-- Animation Settings
local AnimationSpeed = 0.3
local AnimationStyle = Enum.EasingStyle.Quart
local AnimationDirection = Enum.EasingDirection.Out

-- Create folders
if isfolder and not isfolder(MercuryFolder) then
	makefolder(MercuryFolder)
end

if isfolder and not isfolder(ConfigurationFolder) then
	makefolder(ConfigurationFolder)
end

local MercuryLibrary = {
	Flags = {},
	Notifications = {},
	Sounds = {
		Enabled = false,
		Click = nil,
		Toggle = nil,
		Slider = nil,
		Dropdown = nil,
		Notification = nil
	},
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
			PlaceholderColor = Color3.fromRGB(178, 178, 178),
			AccentColor = Color3.fromRGB(0, 146, 214),
			ErrorColor = Color3.fromRGB(220, 50, 50),
			SuccessColor = Color3.fromRGB(50, 220, 100),
			WarningColor = Color3.fromRGB(220, 180, 50)
		}
	}
}

local SelectedTheme = MercuryLibrary.Theme.Default
local Hidden = false
local Minimized = false
local Debounce = false

-- Utility Functions
local function ChangeTheme(Theme)
	if typeof(Theme) == 'string' then
		SelectedTheme = MercuryLibrary.Theme[Theme] or MercuryLibrary.Theme.Default
	elseif typeof(Theme) == 'table' then
		SelectedTheme = Theme
	end
end

local function PackColor(Color)
	return {R = Color.R * 255, G = Color.G * 255, B = Color.B * 255}
end    

local function UnpackColor(Color)
	return Color3.fromRGB(Color.R, Color.G, Color.B)
end

local function Tween(Object, Properties, Duration, Style, Direction)
	Duration = Duration or AnimationSpeed
	Style = Style or AnimationStyle
	Direction = Direction or AnimationDirection
	
	local tween = TweenService:Create(
		Object,
		TweenInfo.new(Duration, Style, Direction),
		Properties
	)
	tween:Play()
	return tween
end

local function RippleEffect(Object, X, Y)
	local Ripple = Instance.new("Frame")
	Ripple.Name = "Ripple"
	Ripple.AnchorPoint = Vector2.new(0.5, 0.5)
	Ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Ripple.BackgroundTransparency = 0.5
	Ripple.Size = UDim2.new(0, 0, 0, 0)
	Ripple.Position = UDim2.new(0, X, 0, Y)
	Ripple.ZIndex = 1000
	Ripple.Parent = Object
	
	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(1, 0)
	Corner.Parent = Ripple
	
	local MaxSize = math.max(Object.AbsoluteSize.X, Object.AbsoluteSize.Y) * 2
	
	Tween(Ripple, {
		Size = UDim2.new(0, MaxSize, 0, MaxSize),
		BackgroundTransparency = 1
	}, 0.5)
	
	task.delay(0.5, function()
		Ripple:Destroy()
	end)
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
		local Type = Settings.Type or "Default" -- Default, Success, Warning, Error
		
		-- Create notification GUI
		local NotificationHolder = game:GetObjects("rbxassetid://10804731440")[1].Main.Parent:FindFirstChild("Notifications")
		
		if not NotificationHolder then
			NotificationHolder = Instance.new("ScreenGui")
			NotificationHolder.Name = "Notifications"
			NotificationHolder.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
			NotificationHolder.ResetOnSpawn = false
			
			if gethui then
				NotificationHolder.Parent = gethui()
			else
				NotificationHolder.Parent = CoreGui
			end
		end
		
		local Notification = Instance.new("Frame")
		Notification.Name = "Notification"
		Notification.BackgroundColor3 = SelectedTheme.ElementBackground
		Notification.BorderSizePixel = 0
		Notification.Size = UDim2.new(0, 300, 0, 80)
		Notification.Position = UDim2.new(1, 20, 1, -100)
		Notification.ClipsDescendants = true
		Notification.Parent = NotificationHolder
		
		local Corner = Instance.new("UICorner")
		Corner.CornerRadius = UDim.new(0, 6)
		Corner.Parent = Notification
		
		local Stroke = Instance.new("UIStroke")
		Stroke.Color = SelectedTheme.ElementStroke
		Stroke.Thickness = 1
		Stroke.Parent = Notification
		
		local TitleLabel = Instance.new("TextLabel")
		TitleLabel.Name = "Title"
		TitleLabel.BackgroundTransparency = 1
		TitleLabel.Position = UDim2.new(0, 15, 0, 10)
		TitleLabel.Size = UDim2.new(1, -30, 0, 20)
		TitleLabel.Font = Enum.Font.GothamBold
		TitleLabel.Text = Title
		TitleLabel.TextColor3 = SelectedTheme.TextColor
		TitleLabel.TextSize = 14
		TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
		TitleLabel.Parent = Notification
		
		local ContentLabel = Instance.new("TextLabel")
		ContentLabel.Name = "Content"
		ContentLabel.BackgroundTransparency = 1
		ContentLabel.Position = UDim2.new(0, 15, 0, 35)
		ContentLabel.Size = UDim2.new(1, -30, 0, 35)
		ContentLabel.Font = Enum.Font.Gotham
		ContentLabel.Text = Content
		ContentLabel.TextColor3 = SelectedTheme.TextColor
		ContentLabel.TextSize = 12
		ContentLabel.TextWrapped = true
		ContentLabel.TextXAlignment = Enum.TextXAlignment.Left
		ContentLabel.TextYAlignment = Enum.TextYAlignment.Top
		ContentLabel.Parent = Notification
		
		-- Type indicator
		local TypeColor = SelectedTheme.AccentColor
		if Type == "Success" then
			TypeColor = SelectedTheme.SuccessColor
		elseif Type == "Warning" then
			TypeColor = SelectedTheme.WarningColor
		elseif Type == "Error" then
			TypeColor = SelectedTheme.ErrorColor
		end
		
		local Indicator = Instance.new("Frame")
		Indicator.Name = "Indicator"
		Indicator.BackgroundColor3 = TypeColor
		Indicator.BorderSizePixel = 0
		Indicator.Size = UDim2.new(0, 4, 1, 0)
		Indicator.Parent = Notification
		
		local IndicatorCorner = Instance.new("UICorner")
		IndicatorCorner.CornerRadius = UDim.new(0, 6)
		IndicatorCorner.Parent = Indicator
		
		-- Animate in
		Tween(Notification, {Position = UDim2.new(1, -320, 1, -100)}, 0.5, Enum.EasingStyle.Back)
		
		-- Animate out
		task.delay(Duration, function()
			Tween(Notification, {Position = UDim2.new(1, 20, 1, -100)}, 0.5)
			task.wait(0.5)
			Notification:Destroy()
		end)
		
		table.insert(MercuryLibrary.Notifications, Notification)
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
			Content = elementName .. " encountered an error.",
			Duration = 3,
			Type = "Error"
		})
	else
		warn("Mercury Error [" .. elementName .. "]: " .. tostring(errorMessage))
	end
end

function MercuryLibrary:CreateWindow(Settings)
	Settings = Settings or {}
	
	-- Create base UI structure
	local Mercury = Instance.new("ScreenGui")
	Mercury.Name = "Mercury"
	Mercury.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	Mercury.ResetOnSpawn = false
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
	
	-- Main frame
	local Main = Instance.new("Frame")
	Main.Name = "Main"
	Main.BackgroundColor3 = SelectedTheme.Background
	Main.BorderSizePixel = 0
	Main.Position = UDim2.new(0.5, -250, 0.5, -237)
	Main.Size = UDim2.new(0, 500, 0, 475)
	Main.ClipsDescendants = true
	Main.Parent = Mercury
	
	local MainCorner = Instance.new("UICorner")
	MainCorner.CornerRadius = UDim.new(0, 8)
	MainCorner.Parent = Main
	
	local MainStroke = Instance.new("UIStroke")
	MainStroke.Color = SelectedTheme.Shadow
	MainStroke.Thickness = 2
	MainStroke.Parent = Main
	
	-- Topbar
	local Topbar = Instance.new("Frame")
	Topbar.Name = "Topbar"
	Topbar.BackgroundColor3 = SelectedTheme.Topbar
	Topbar.BorderSizePixel = 0
	Topbar.Size = UDim2.new(1, 0, 0, 45)
	Topbar.Parent = Main
	
	local TopbarCorner = Instance.new("UICorner")
	TopbarCorner.CornerRadius = UDim.new(0, 8)
	TopbarCorner.Parent = Topbar
	
	-- Fix topbar corner bottom
	local TopbarFix = Instance.new("Frame")
	TopbarFix.BackgroundColor3 = SelectedTheme.Topbar
	TopbarFix.BorderSizePixel = 0
	TopbarFix.Position = UDim2.new(0, 0, 1, -8)
	TopbarFix.Size = UDim2.new(1, 0, 0, 8)
	TopbarFix.Parent = Topbar
	
	local Title = Instance.new("TextLabel")
	Title.Name = "Title"
	Title.BackgroundTransparency = 1
	Title.Position = UDim2.new(0, 15, 0, 0)
	Title.Size = UDim2.new(0, 400, 1, 0)
	Title.Font = Enum.Font.GothamBold
	Title.Text = Settings.Name or "Mercury"
	Title.TextColor3 = SelectedTheme.TextColor
	Title.TextSize = 16
	Title.TextXAlignment = Enum.TextXAlignment.Left
	Title.Parent = Topbar
	
	-- Control buttons
	local ControlsFrame = Instance.new("Frame")
	ControlsFrame.Name = "Controls"
	ControlsFrame.BackgroundTransparency = 1
	ControlsFrame.Position = UDim2.new(1, -100, 0, 0)
	ControlsFrame.Size = UDim2.new(0, 100, 1, 0)
	ControlsFrame.Parent = Topbar
	
	local ControlsList = Instance.new("UIListLayout")
	ControlsList.FillDirection = Enum.FillDirection.Horizontal
	ControlsList.HorizontalAlignment = Enum.HorizontalAlignment.Right
	ControlsList.VerticalAlignment = Enum.VerticalAlignment.Center
	ControlsList.Padding = UDim.new(0, 5)
	ControlsList.Parent = ControlsFrame
	
	-- Minimize button
	local MinimizeBtn = Instance.new("TextButton")
	MinimizeBtn.Name = "Minimize"
	MinimizeBtn.BackgroundColor3 = SelectedTheme.ElementBackground
	MinimizeBtn.BorderSizePixel = 0
	MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
	MinimizeBtn.Font = Enum.Font.GothamBold
	MinimizeBtn.Text = "_"
	MinimizeBtn.TextColor3 = SelectedTheme.TextColor
	MinimizeBtn.TextSize = 18
	MinimizeBtn.Parent = ControlsFrame
	
	local MinCorner = Instance.new("UICorner")
	MinCorner.CornerRadius = UDim.new(0, 4)
	MinCorner.Parent = MinimizeBtn
	
	-- Close button
	local CloseBtn = Instance.new("TextButton")
	CloseBtn.Name = "Close"
	CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
	CloseBtn.BorderSizePixel = 0
	CloseBtn.Size = UDim2.new(0, 30, 0, 30)
	CloseBtn.Font = Enum.Font.GothamBold
	CloseBtn.Text = "X"
	CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	CloseBtn.TextSize = 14
	CloseBtn.Parent = ControlsFrame
	
	local CloseCorner = Instance.new("UICorner")
	CloseCorner.CornerRadius = UDim.new(0, 4)
	CloseCorner.Parent = CloseBtn
	
	-- Tab list
	local TabList = Instance.new("ScrollingFrame")
	TabList.Name = "TabList"
	TabList.BackgroundTransparency = 1
	TabList.BorderSizePixel = 0
	TabList.Position = UDim2.new(0, 10, 0, 55)
	TabList.Size = UDim2.new(0, 120, 1, -65)
	TabList.CanvasSize = UDim2.new(0, 0, 0, 0)
	TabList.ScrollBarThickness = 4
	TabList.ScrollBarImageColor3 = SelectedTheme.ElementStroke
	TabList.Parent = Main
	
	local TabListLayout = Instance.new("UIListLayout")
	TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	TabListLayout.Padding = UDim.new(0, 5)
	TabListLayout.Parent = TabList
	
	TabListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		TabList.CanvasSize = UDim2.new(0, 0, 0, TabListLayout.AbsoluteContentSize.Y + 10)
	end)
	
	-- Elements container
	local Elements = Instance.new("Frame")
	Elements.Name = "Elements"
	Elements.BackgroundTransparency = 1
	Elements.Position = UDim2.new(0, 140, 0, 55)
	Elements.Size = UDim2.new(1, -150, 1, -65)
	Elements.ClipsDescendants = true
	Elements.Parent = Main
	
	local ElementsPageLayout = Instance.new("UIPageLayout")
	ElementsPageLayout.FillDirection = Enum.FillDirection.Horizontal
	ElementsPageLayout.SortOrder = Enum.SortOrder.LayoutOrder
	ElementsPageLayout.EasingStyle = Enum.EasingStyle.Quart
	ElementsPageLayout.EasingDirection = Enum.EasingDirection.Out
	ElementsPageLayout.TweenTime = 0.3
	ElementsPageLayout.Parent = Elements
	
	Mercury.Enabled = true
	Main.Visible = true
	
	-- Dragging
	local Dragging = false
	local DragStart = nil
	local StartPos = nil
	
	Topbar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			Dragging = true
			DragStart = input.Position
			StartPos = Main.Position
		end
	end)
	
	Topbar.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			Dragging = false
		end
	end)
	
	UserInputService.InputChanged:Connect(function(input)
		if Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local Delta = input.Position - DragStart
			Tween(Main, {
				Position = UDim2.new(
					StartPos.X.Scale,
					StartPos.X.Offset + Delta.X,
					StartPos.Y.Scale,
					StartPos.Y.Offset + Delta.Y
				)
			}, 0.1)
		end
	end)
	
	-- Configuration
	if Settings.ConfigurationSaving then
		CFileName = Settings.ConfigurationSaving.FileName or tostring(game.PlaceId)
		CEnabled = Settings.ConfigurationSaving.Enabled or false
	end
	
	-- Window object
	local Window = {
		Tabs = {},
		CurrentTab = nil,
		Main = Main,
		Mercury = Mercury
	}
	
	-- Close button
	CloseBtn.MouseButton1Click:Connect(function()
		RippleEffect(CloseBtn, CloseBtn.AbsoluteSize.X / 2, CloseBtn.AbsoluteSize.Y / 2)
		Window:Toggle()
	end)
	
	-- Minimize button
	MinimizeBtn.MouseButton1Click:Connect(function()
		RippleEffect(MinimizeBtn, MinimizeBtn.AbsoluteSize.X / 2, MinimizeBtn.AbsoluteSize.Y / 2)
		if Minimized then
			Window:Maximize()
		else
			Window:Minimize()
		end
	end)
	
	-- Hover effects
	MinimizeBtn.MouseEnter:Connect(function()
		Tween(MinimizeBtn, {BackgroundColor3 = SelectedTheme.ElementBackgroundHover}, 0.2)
	end)
	
	MinimizeBtn.MouseLeave:Connect(function()
		Tween(MinimizeBtn, {BackgroundColor3 = SelectedTheme.ElementBackground}, 0.2)
	end)
	
	CloseBtn.MouseEnter:Connect(function()
		Tween(CloseBtn, {BackgroundColor3 = Color3.fromRGB(255, 80, 80)}, 0.2)
	end)
	
	CloseBtn.MouseLeave:Connect(function()
		Tween(CloseBtn, {BackgroundColor3 = Color3.fromRGB(220, 50, 50)}, 0.2)
	end)
	
	function Window:SetTheme(ThemeName)
		if typeof(ThemeName) == 'string' and MercuryLibrary.Theme[ThemeName] then
			ChangeTheme(ThemeName)
		elseif typeof(ThemeName) == 'table' then
			ChangeTheme(ThemeName)
		end
		
		-- Update colors
		Tween(Main, {BackgroundColor3 = SelectedTheme.Background})
		Tween(Topbar, {BackgroundColor3 = SelectedTheme.Topbar})
		Tween(TopbarFix, {BackgroundColor3 = SelectedTheme.Topbar})
	end
	
	function Window:Toggle()
		Hidden = not Hidden
		Mercury.Enabled = not Hidden
	end
	
	function Window:Show()
		Hidden = false
		Mercury.Enabled = true
		Tween(Main, {Size = UDim2.new(0, 500, 0, 475)}, 0.5, Enum.EasingStyle.Back)
	end
	
	function Window:Hide()
		Hidden = true
		Tween(Main, {Size = UDim2.new(0, 500, 0, 0)}, 0.3)
		task.wait(0.3)
		Mercury.Enabled = false
	end
	
	function Window:IsVisible()
		return not Hidden
	end
	
	function Window:Minimize()
		if Minimized then return end
		Minimized = true
		MinimizeBtn.Text = "□"
		Tween(Main, {Size = UDim2.new(0, 500, 0, 45)}, 0.5, Enum.EasingStyle.Exponential)
	end
	
	function Window:Maximize()
		if not Minimized then return end
		Minimized = false
		MinimizeBtn.Text = "_"
		Tween(Main, {Size = UDim2.new(0, 500, 0, 475)}, 0.5, Enum.EasingStyle.Exponential)
	end
	
	function Window:IsMinimized()
		return Minimized
	end
	
	function Window:Destroy()
		Tween(Main, {Size = UDim2.new(0, 0, 0, 0)}, 0.5)
		task.wait(0.5)
		Mercury:Destroy()
	end
	
	function Window:GetTabs()
		return Window.Tabs
	end
	
	function Window:SelectTab(TabName)
		for _, tab in pairs(Window.Tabs) do
			if tab.Name == TabName then
				ElementsPageLayout:JumpToIndex(tab.Index)
				Window.CurrentTab = tab
				
				for _, btn in ipairs(TabList:GetChildren()) do
					if btn:IsA("Frame") and btn.Name ~= "Template" then
						if btn.Name == TabName then
							Tween(btn, {BackgroundColor3 = SelectedTheme.TabBackgroundSelected})
							Tween(btn.Title, {TextColor3 = SelectedTheme.SelectedTabTextColor})
						else
							Tween(btn, {BackgroundColor3 = SelectedTheme.TabBackground})
							Tween(btn.Title, {TextColor3 = SelectedTheme.TabTextColor})
						end
					end
				end
				return true
			end
		end
		return false
	end
	
	if Settings.ToggleKey then
		UserInputService.InputBegan:Connect(function(input, processed)
			if processed then return end
			if input.KeyCode == Settings.ToggleKey then
				Window:Toggle()
			end
		end)
	end
	
	function Window:CreateTab(Name, Icon)
		local Tab = {
			Name = Name,
			Elements = {},
			Window = Window,
			Index = #Window.Tabs + 1
		}
		
		-- Tab button
		local TabButton = Instance.new("Frame")
		TabButton.Name = Name
		TabButton.BackgroundColor3 = SelectedTheme.TabBackground
		TabButton.BorderSizePixel = 0
		TabButton.Size = UDim2.new(1, 0, 0, 35)
		TabButton.Parent = TabList
		
		local TabCorner = Instance.new("UICorner")
		TabCorner.CornerRadius = UDim.new(0, 6)
		TabCorner.Parent = TabButton
		
		local TabStroke = Instance.new("UIStroke")
		TabStroke.Color = SelectedTheme.TabStroke
		TabStroke.Thickness = 1
		TabStroke.Parent = TabButton
		
		local TabTitle = Instance.new("TextLabel")
		TabTitle.Name = "Title"
		TabTitle.BackgroundTransparency = 1
		TabTitle.Size = UDim2.new(1, -10, 1, 0)
		TabTitle.Position = UDim2.new(0, 10, 0, 0)
		TabTitle.Font = Enum.Font.GothamSemibold
		TabTitle.Text = Name
		TabTitle.TextColor3 = SelectedTheme.TabTextColor
		TabTitle.TextSize = 13
		TabTitle.TextXAlignment = Enum.TextXAlignment.Left
		TabTitle.Parent = TabButton
		
		local TabInteract = Instance.new("TextButton")
		TabInteract.Name = "Interact"
		TabInteract.BackgroundTransparency = 1
		TabInteract.Size = UDim2.new(1, 0, 1, 0)
		TabInteract.Text = ""
		TabInteract.Parent = TabButton
		
		-- Tab page
		local TabPage = Instance.new("ScrollingFrame")
		TabPage.Name = Name
		TabPage.BackgroundTransparency = 1
		TabPage.BorderSizePixel = 0
		TabPage.Size = UDim2.new(1, 0, 1, 0)
		TabPage.CanvasSize = UDim2.new(0, 0, 0, 0)
		TabPage.ScrollBarThickness = 4
		TabPage.ScrollBarImageColor3 = SelectedTheme.ElementStroke
		TabPage.LayoutOrder = Tab.Index
		TabPage.Parent = Elements
		
		local PageLayout = Instance.new("UIListLayout")
		PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
		PageLayout.Padding = UDim.new(0, 8)
		PageLayout.Parent = TabPage
		
		local PagePadding = Instance.new("UIPadding")
		PagePadding.PaddingLeft = UDim.new(0, 10)
		PagePadding.PaddingRight = UDim.new(0, 10)
		PagePadding.PaddingTop = UDim.new(0, 10)
		PagePadding.PaddingBottom = UDim.new(0, 10)
		PagePadding.Parent = TabPage
		
		PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			TabPage.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 20)
		end)
		
		Tab.Button = TabButton
		Tab.Page = TabPage
		
		table.insert(Window.Tabs, Tab)
		
		-- Hover effect
		TabInteract.MouseEnter:Connect(function()
			if Window.CurrentTab ~= Tab then
				Tween(TabButton, {BackgroundColor3 = SelectedTheme.ElementBackgroundHover})
			end
		end)
		
		TabInteract.MouseLeave:Connect(function()
			if Window.CurrentTab ~= Tab then
				Tween(TabButton, {BackgroundColor3 = SelectedTheme.TabBackground})
			end
		end)
		
		TabInteract.MouseButton1Click:Connect(function()
			RippleEffect(TabButton, TabButton.AbsoluteSize.X / 2, TabButton.AbsoluteSize.Y / 2)
			Window:SelectTab(Name)
		end)
		
		if #Window.Tabs == 1 then
			Window:SelectTab(Name)
		end
		
		function Tab:GetElements()
			return Tab.Elements
		end
		
		function Tab:CreateLabel(Text, Settings)
			Settings = Settings or {}
			
			local Label = Instance.new("Frame")
			Label.Name = "Label"
			Label.BackgroundColor3 = Settings.Color or SelectedTheme.ElementBackground
			Label.BorderSizePixel = 0
			Label.Size = UDim2.new(1, 0, 0, 40)
			Label.Parent = TabPage
			
			local LabelCorner = Instance.new("UICorner")
			LabelCorner.CornerRadius = UDim.new(0, 6)
			LabelCorner.Parent = Label
			
			local LabelTitle = Instance.new("TextLabel")
			LabelTitle.Name = "Title"
			LabelTitle.BackgroundTransparency = 1
			LabelTitle.Position = UDim2.new(0, 15, 0, 0)
			LabelTitle.Size = UDim2.new(1, -30, 1, 0)
			LabelTitle.Font = Enum.Font.Gotham
			LabelTitle.Text = Text
			LabelTitle.TextColor3 = SelectedTheme.TextColor
			LabelTitle.TextSize = 13
			LabelTitle.TextXAlignment = Enum.TextXAlignment.Left
			LabelTitle.TextWrapped = true
			LabelTitle.Parent = Label
			
			local LabelValue = {
				Type = "Label",
				Element = Label,
				Visible = true
			}
			
			function LabelValue:Set(NewText, NewColor)
				LabelTitle.Text = NewText
				if NewColor then
					Tween(Label, {BackgroundColor3 = NewColor})
				end
			end
			
			function LabelValue:SetVisible(Visible)
				LabelValue.Visible = Visible
				Label.Visible = Visible
			end
			
			function LabelValue:Remove()
				Tween(Label, {Size = UDim2.new(1, 0, 0, 0)}, 0.3)
				task.wait(0.3)
				Label:Destroy()
			end
			
			table.insert(Tab.Elements, LabelValue)
			return LabelValue
		end
		
		function Tab:CreateButton(ButtonSettings)
			local Button = Instance.new("Frame")
			Button.Name = ButtonSettings.Name
			Button.BackgroundColor3 = SelectedTheme.ElementBackground
			Button.BorderSizePixel = 0
			Button.Size = UDim2.new(1, 0, 0, 40)
			Button.Parent = TabPage
			
			local ButtonCorner = Instance.new("UICorner")
			ButtonCorner.CornerRadius = UDim.new(0, 6)
			ButtonCorner.Parent = Button
			
			local ButtonStroke = Instance.new("UIStroke")
			ButtonStroke.Color = SelectedTheme.ElementStroke
			ButtonStroke.Thickness = 1
			ButtonStroke.Parent = Button
			
			local ButtonTitle = Instance.new("TextLabel")
			ButtonTitle.Name = "Title"
			ButtonTitle.BackgroundTransparency = 1
			ButtonTitle.Position = UDim2.new(0, 15, 0, 0)
			ButtonTitle.Size = UDim2.new(1, -30, 1, 0)
			ButtonTitle.Font = Enum.Font.GothamSemibold
			ButtonTitle.Text = ButtonSettings.Name
			ButtonTitle.TextColor3 = SelectedTheme.TextColor
			ButtonTitle.TextSize = 13
			ButtonTitle.TextXAlignment = Enum.TextXAlignment.Center
			ButtonTitle.Parent = Button
			
			local ButtonInteract = Instance.new("TextButton")
			ButtonInteract.Name = "Interact"
			ButtonInteract.BackgroundTransparency = 1
			ButtonInteract.Size = UDim2.new(1, 0, 1, 0)
			ButtonInteract.Text = ""
			ButtonInteract.Parent = Button
			
			local ButtonValue = {
				Type = "Button",
				Element = Button,
				Callback = ButtonSettings.Callback or function() end,
				Locked = false
			}
			
			ButtonInteract.MouseEnter:Connect(function()
				if not ButtonValue.Locked then
					Tween(Button, {BackgroundColor3 = SelectedTheme.ElementBackgroundHover})
				end
			end)
			
			ButtonInteract.MouseLeave:Connect(function()
				if not ButtonValue.Locked then
					Tween(Button, {BackgroundColor3 = SelectedTheme.ElementBackground})
				end
			end)
			
			ButtonInteract.MouseButton1Click:Connect(function()
				if ButtonValue.Locked then return end
				
				RippleEffect(Button, ButtonInteract.AbsolutePosition.X - Button.AbsolutePosition.X + ButtonInteract.AbsoluteSize.X / 2, ButtonInteract.AbsolutePosition.Y - Button.AbsolutePosition.Y + ButtonInteract.AbsoluteSize.Y / 2)
				
				local success, err = pcall(ButtonValue.Callback)
				if not success then
					ShowError(ButtonSettings.Name, err)
				end
			end)
			
			function ButtonValue:Set(NewName)
				ButtonTitle.Text = NewName
			end
			
			function ButtonValue:SetCallback(NewCallback)
				ButtonValue.Callback = NewCallback
			end
			
			function ButtonValue:SetLocked(Locked)
				ButtonValue.Locked = Locked
				if Locked then
					Tween(Button, {BackgroundColor3 = SelectedTheme.SecondaryElementBackground})
					Tween(ButtonTitle, {TextTransparency = 0.5})
				else
					Tween(Button, {BackgroundColor3 = SelectedTheme.ElementBackground})
					Tween(ButtonTitle, {TextTransparency = 0})
				end
			end
			
			function ButtonValue:Remove()
				Tween(Button, {Size = UDim2.new(1, 0, 0, 0)})
				task.wait(0.3)
				Button:Destroy()
			end
			
			table.insert(Tab.Elements, ButtonValue)
			return ButtonValue
		end
		
		function Tab:CreateToggle(ToggleSettings)
			local Toggle = Instance.new("Frame")
			Toggle.Name = ToggleSettings.Name
			Toggle.BackgroundColor3 = SelectedTheme.ElementBackground
			Toggle.BorderSizePixel = 0
			Toggle.Size = UDim2.new(1, 0, 0, 40)
			Toggle.Parent = TabPage
			
			local ToggleCorner = Instance.new("UICorner")
			ToggleCorner.CornerRadius = UDim.new(0, 6)
			ToggleCorner.Parent = Toggle
			
			local ToggleStroke = Instance.new("UIStroke")
			ToggleStroke.Color = SelectedTheme.ElementStroke
			ToggleStroke.Thickness = 1
			ToggleStroke.Parent = Toggle
			
			local ToggleTitle = Instance.new("TextLabel")
			ToggleTitle.Name = "Title"
			ToggleTitle.BackgroundTransparency = 1
			ToggleTitle.Position = UDim2.new(0, 15, 0, 0)
			ToggleTitle.Size = UDim2.new(1, -70, 1, 0)
			ToggleTitle.Font = Enum.Font.GothamSemibold
			ToggleTitle.Text = ToggleSettings.Name
			ToggleTitle.TextColor3 = SelectedTheme.TextColor
			ToggleTitle.TextSize = 13
			ToggleTitle.TextXAlignment = Enum.TextXAlignment.Left
			ToggleTitle.Parent = Toggle
			
			local ToggleFrame = Instance.new("Frame")
			ToggleFrame.Name = "ToggleFrame"
			ToggleFrame.BackgroundColor3 = SelectedTheme.ToggleBackground
			ToggleFrame.BorderSizePixel = 0
			ToggleFrame.Position = UDim2.new(1, -55, 0.5, -10)
			ToggleFrame.Size = UDim2.new(0, 45, 0, 20)
			ToggleFrame.Parent = Toggle
			
			local ToggleFrameCorner = Instance.new("UICorner")
			ToggleFrameCorner.CornerRadius = UDim.new(1, 0)
			ToggleFrameCorner.Parent = ToggleFrame
			
			local ToggleFrameStroke = Instance.new("UIStroke")
			ToggleFrameStroke.Color = SelectedTheme.ToggleDisabledStroke
			ToggleFrameStroke.Thickness = 1
			ToggleFrameStroke.Parent = ToggleFrame
			
			local Indicator = Instance.new("Frame")
			Indicator.Name = "Indicator"
			Indicator.BackgroundColor3 = SelectedTheme.ToggleDisabled
			Indicator.BorderSizePixel = 0
			Indicator.Position = UDim2.new(0, 2, 0.5, -8)
			Indicator.Size = UDim2.new(0, 16, 0, 16)
			Indicator.Parent = ToggleFrame
			
			local IndicatorCorner = Instance.new("UICorner")
			IndicatorCorner.CornerRadius = UDim.new(1, 0)
			IndicatorCorner.Parent = Indicator
			
			local IndicatorStroke = Instance.new("UIStroke")
			IndicatorStroke.Color = SelectedTheme.ToggleDisabledOuterStroke
			IndicatorStroke.Thickness = 2
			IndicatorStroke.Parent = Indicator
			
			local ToggleInteract = Instance.new("TextButton")
			ToggleInteract.Name = "Interact"
			ToggleInteract.BackgroundTransparency = 1
			ToggleInteract.Size = UDim2.new(1, 0, 1, 0)
			ToggleInteract.Text = ""
			ToggleInteract.Parent = Toggle
			
			ToggleSettings.CurrentValue = ToggleSettings.CurrentValue or false
			ToggleSettings.Type = "Toggle"
			ToggleSettings.Callback = ToggleSettings.Callback or function() end
			
			local ToggleValue = {
				Type = "Toggle",
				Element = Toggle,
				CurrentValue = ToggleSettings.CurrentValue,
				Callback = ToggleSettings.Callback,
				Locked = false
			}
			
			local function UpdateVisual()
				if ToggleValue.CurrentValue then
					Tween(Indicator, {
						Position = UDim2.new(1, -18, 0.5, -8),
						BackgroundColor3 = SelectedTheme.ToggleEnabled
					})
					Tween(IndicatorStroke, {Color = SelectedTheme.ToggleEnabledOuterStroke})
					Tween(ToggleFrameStroke, {Color = SelectedTheme.ToggleEnabledStroke})
				else
					Tween(Indicator, {
						Position = UDim2.new(0, 2, 0.5, -8),
						BackgroundColor3 = SelectedTheme.ToggleDisabled
					})
					Tween(IndicatorStroke, {Color = SelectedTheme.ToggleDisabledOuterStroke})
					Tween(ToggleFrameStroke, {Color = SelectedTheme.ToggleDisabledStroke})
				end
			end
			
			UpdateVisual()
			
			ToggleInteract.MouseEnter:Connect(function()
				if not ToggleValue.Locked then
					Tween(Toggle, {BackgroundColor3 = SelectedTheme.ElementBackgroundHover})
				end
			end)
			
			ToggleInteract.MouseLeave:Connect(function()
				if not ToggleValue.Locked then
					Tween(Toggle, {BackgroundColor3 = SelectedTheme.ElementBackground})
				end
			end)
			
			ToggleInteract.MouseButton1Click:Connect(function()
				if ToggleValue.Locked then return end
				
				ToggleValue.CurrentValue = not ToggleValue.CurrentValue
				UpdateVisual()
				
				local success, err = pcall(ToggleValue.Callback, ToggleValue.CurrentValue)
				if not success then
					ShowError(ToggleSettings.Name, err)
				end
				SaveConfiguration()
			end)
			
			function ToggleValue:Set(Value)
				ToggleValue.CurrentValue = Value
				UpdateVisual()
				local success, err = pcall(ToggleValue.Callback, Value)
				if not success then
					ShowError(ToggleSettings.Name, err)
				end
				SaveConfiguration()
			end
			
			function ToggleValue:Get()
				return ToggleValue.CurrentValue
			end
			
			function ToggleValue:SetCallback(NewCallback)
				ToggleValue.Callback = NewCallback
			end
			
			function ToggleValue:SetLocked(Locked)
				ToggleValue.Locked = Locked
				if Locked then
					Tween(Toggle, {BackgroundColor3 = SelectedTheme.SecondaryElementBackground})
					Tween(ToggleTitle, {TextTransparency = 0.5})
				else
					Tween(Toggle, {BackgroundColor3 = SelectedTheme.ElementBackground})
					Tween(ToggleTitle, {TextTransparency = 0})
				end
			end
			
			function ToggleValue:Remove()
				Tween(Toggle, {Size = UDim2.new(1, 0, 0, 0)})
				task.wait(0.3)
				Toggle:Destroy()
			end
			
			if ToggleSettings.Flag then
				MercuryLibrary.Flags[ToggleSettings.Flag] = ToggleValue
			end
			
			table.insert(Tab.Elements, ToggleValue)
			return ToggleValue
		end
		
		function Tab:CreateSlider(SliderSettings)
			local Slider = Instance.new("Frame")
			Slider.Name = SliderSettings.Name
			Slider.BackgroundColor3 = SelectedTheme.ElementBackground
			Slider.BorderSizePixel = 0
			Slider.Size = UDim2.new(1, 0, 0, 60)
			Slider.Parent = TabPage
			
			local SliderCorner = Instance.new("UICorner")
			SliderCorner.CornerRadius = UDim.new(0, 6)
			SliderCorner.Parent = Slider
			
			local SliderStroke = Instance.new("UIStroke")
			SliderStroke.Color = SelectedTheme.ElementStroke
			SliderStroke.Thickness = 1
			SliderStroke.Parent = Slider
			
			local SliderTitle = Instance.new("TextLabel")
			SliderTitle.Name = "Title"
			SliderTitle.BackgroundTransparency = 1
			SliderTitle.Position = UDim2.new(0, 15, 0, 8)
			SliderTitle.Size = UDim2.new(1, -30, 0, 20)
			SliderTitle.Font = Enum.Font.GothamSemibold
			SliderTitle.Text = SliderSettings.Name
			SliderTitle.TextColor3 = SelectedTheme.TextColor
			SliderTitle.TextSize = 13
			SliderTitle.TextXAlignment = Enum.TextXAlignment.Left
			SliderTitle.Parent = Slider
			
			local SliderMain = Instance.new("Frame")
			SliderMain.Name = "Main"
			SliderMain.BackgroundColor3 = SelectedTheme.SecondaryElementBackground
			SliderMain.BorderSizePixel = 0
			SliderMain.Position = UDim2.new(0, 15, 1, -22)
			SliderMain.Size = UDim2.new(1, -30, 0, 8)
			SliderMain.Parent = Slider
			
			local SliderMainCorner = Instance.new("UICorner")
			SliderMainCorner.CornerRadius = UDim.new(1, 0)
			SliderMainCorner.Parent = SliderMain
			
			local Progress = Instance.new("Frame")
			Progress.Name = "Progress"
			Progress.BackgroundColor3 = SelectedTheme.SliderProgress
			Progress.BorderSizePixel = 0
			Progress.Size = UDim2.new(0.5, 0, 1, 0)
			Progress.Parent = SliderMain
			
			local ProgressCorner = Instance.new("UICorner")
			ProgressCorner.CornerRadius = UDim.new(1, 0)
			ProgressCorner.Parent = Progress
			
			local ProgressStroke = Instance.new("UIStroke")
			ProgressStroke.Color = SelectedTheme.SliderStroke
			ProgressStroke.Thickness = 1
			ProgressStroke.Parent = Progress
			
			local Info = Instance.new("TextLabel")
			Info.Name = "Information"
			Info.BackgroundTransparency = 1
			Info.Position = UDim2.new(1, -60, 0, 8)
			Info.Size = UDim2.new(0, 60, 0, 20)
			Info.Font = Enum.Font.GothamSemibold
			Info.Text = "50"
			Info.TextColor3 = SelectedTheme.TextColor
			Info.TextSize = 12
			Info.TextXAlignment = Enum.TextXAlignment.Right
			Info.Parent = Slider
			
			local SliderInteract = Instance.new("TextButton")
			SliderInteract.Name = "Interact"
			SliderInteract.BackgroundTransparency = 1
			SliderInteract.Position = UDim2.new(0, 15, 0, 30)
			SliderInteract.Size = UDim2.new(1, -30, 0, 20)
			SliderInteract.Text = ""
			SliderInteract.Parent = Slider
			
			SliderSettings.CurrentValue = SliderSettings.CurrentValue or SliderSettings.Range[1]
			SliderSettings.Range = SliderSettings.Range or {0, 100}
			SliderSettings.Increment = SliderSettings.Increment or 1
			SliderSettings.Type = "Slider"
			SliderSettings.Callback = SliderSettings.Callback or function() end
			
			local Dragging = false
			
			local SliderValue = {
				Type = "Slider",
				Element = Slider,
				CurrentValue = SliderSettings.CurrentValue,
				Range = SliderSettings.Range,
				Increment = SliderSettings.Increment,
				Callback = SliderSettings.Callback,
				Locked = false
			}
			
			local function UpdateSlider(Value)
				local Percentage = (Value - SliderValue.Range[1]) / (SliderValue.Range[2] - SliderValue.Range[1])
				Tween(Progress, {Size = UDim2.new(Percentage, 0, 1, 0)}, 0.1)
				
				if SliderSettings.Suffix then
					Info.Text = tostring(Value) .. " " .. SliderSettings.Suffix
				else
					Info.Text = tostring(Value)
				end
				
				SliderValue.CurrentValue = Value
			end
			
			UpdateSlider(SliderSettings.CurrentValue)
			
			SliderInteract.InputBegan:Connect(function(input)
				if SliderValue.Locked then return end
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					Dragging = true
					Tween(Slider, {BackgroundColor3 = SelectedTheme.ElementBackgroundHover})
				end
			end)
			
			SliderInteract.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					Dragging = false
					Tween(Slider, {BackgroundColor3 = SelectedTheme.ElementBackground})
				end
			end)
			
			UserInputService.InputChanged:Connect(function(input)
				if Dragging and not SliderValue.Locked and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
					local MousePos = UserInputService:GetMouseLocation().X
					local SliderPos = SliderMain.AbsolutePosition.X
					local SliderSize = SliderMain.AbsoluteSize.X
					
					local Percentage = math.clamp((MousePos - SliderPos) / SliderSize, 0, 1)
					local Value = SliderValue.Range[1] + (Percentage * (SliderValue.Range[2] - SliderValue.Range[1]))
					Value = math.floor(Value / SliderValue.Increment + 0.5) * SliderValue.Increment
					Value = math.clamp(Value, SliderValue.Range[1], SliderValue.Range[2])
					
					UpdateSlider(Value)
					local success, err = pcall(SliderValue.Callback, Value)
					if not success then
						ShowError(SliderSettings.Name, err)
					end
					SaveConfiguration()
				end
			end)
			
			function SliderValue:Set(Value)
				Value = math.clamp(Value, SliderValue.Range[1], SliderValue.Range[2])
				UpdateSlider(Value)
				local success, err = pcall(SliderValue.Callback, Value)
				if not success then
					ShowError(SliderSettings.Name, err)
				end
				SaveConfiguration()
			end
			
			function SliderValue:Get()
				return SliderValue.CurrentValue
			end
			
			function SliderValue:SetCallback(NewCallback)
				SliderValue.Callback = NewCallback
			end
			
			function SliderValue:SetRange(NewRange)
				SliderValue.Range = NewRange
				SliderValue.CurrentValue = math.clamp(SliderValue.CurrentValue, NewRange[1], NewRange[2])
				UpdateSlider(SliderValue.CurrentValue)
			end
			
			function SliderValue:SetLocked(Locked)
				SliderValue.Locked = Locked
				if Locked then
					Tween(Slider, {BackgroundColor3 = SelectedTheme.SecondaryElementBackground})
					Tween(SliderTitle, {TextTransparency = 0.5})
				else
					Tween(Slider, {BackgroundColor3 = SelectedTheme.ElementBackground})
					Tween(SliderTitle, {TextTransparency = 0})
				end
			end
			
			function SliderValue:Remove()
				Tween(Slider, {Size = UDim2.new(1, 0, 0, 0)})
				task.wait(0.3)
				Slider:Destroy()
			end
			
			if SliderSettings.Flag then
				MercuryLibrary.Flags[SliderSettings.Flag] = SliderValue
			end
			
			table.insert(Tab.Elements, SliderValue)
			return SliderValue
		end
		
		function Tab:CreateDropdown(DropdownSettings)
			local Dropdown = Instance.new("Frame")
			Dropdown.Name = DropdownSettings.Name
			Dropdown.BackgroundColor3 = SelectedTheme.ElementBackground
			Dropdown.BorderSizePixel = 0
			Dropdown.Size = UDim2.new(1, 0, 0, 40)
			Dropdown.Parent = TabPage
			Dropdown.ClipsDescendants = true
			
			local DropdownCorner = Instance.new("UICorner")
			DropdownCorner.CornerRadius = UDim.new(0, 6)
			DropdownCorner.Parent = Dropdown
			
			local DropdownStroke = Instance.new("UIStroke")
			DropdownStroke.Color = SelectedTheme.ElementStroke
			DropdownStroke.Thickness = 1
			DropdownStroke.Parent = Dropdown
			
			local DropdownTitle = Instance.new("TextLabel")
			DropdownTitle.Name = "Title"
			DropdownTitle.BackgroundTransparency = 1
			DropdownTitle.Position = UDim2.new(0, 15, 0, 0)
			DropdownTitle.Size = UDim2.new(1, -60, 0, 40)
			DropdownTitle.Font = Enum.Font.GothamSemibold
			DropdownTitle.Text = DropdownSettings.Name
			DropdownTitle.TextColor3 = SelectedTheme.TextColor
			DropdownTitle.TextSize = 13
			DropdownTitle.TextXAlignment = Enum.TextXAlignment.Left
			DropdownTitle.Parent = Dropdown
			
			local Selected = Instance.new("TextLabel")
			Selected.Name = "Selected"
			Selected.BackgroundTransparency = 1
			Selected.Position = UDim2.new(1, -150, 0, 0)
			Selected.Size = UDim2.new(0, 130, 0, 40)
			Selected.Font = Enum.Font.Gotham
			Selected.Text = "None"
			Selected.TextColor3 = SelectedTheme.PlaceholderColor
			Selected.TextSize = 12
			Selected.TextXAlignment = Enum.TextXAlignment.Right
			Selected.Parent = Dropdown
			
			local Arrow = Instance.new("TextLabel")
			Arrow.Name = "Arrow"
			Arrow.BackgroundTransparency = 1
			Arrow.Position = UDim2.new(1, -20, 0, 0)
			Arrow.Size = UDim2.new(0, 20, 0, 40)
			Arrow.Font = Enum.Font.GothamBold
			Arrow.Text = "▼"
			Arrow.TextColor3 = SelectedTheme.TextColor
			Arrow.TextSize = 10
			Arrow.Parent = Dropdown
			
			local DropdownInteract = Instance.new("TextButton")
			DropdownInteract.Name = "Interact"
			DropdownInteract.BackgroundTransparency = 1
			DropdownInteract.Size = UDim2.new(1, 0, 0, 40)
			DropdownInteract.Text = ""
			DropdownInteract.ZIndex = 10
			DropdownInteract.Parent = Dropdown
			
			local DropdownList = Instance.new("ScrollingFrame")
			DropdownList.Name = "List"
			DropdownList.BackgroundTransparency = 1
			DropdownList.Position = UDim2.new(0, 0, 0, 45)
			DropdownList.Size = UDim2.new(1, 0, 0, 0)
			DropdownList.CanvasSize = UDim2.new(0, 0, 0, 0)
			DropdownList.ScrollBarThickness = 4
			DropdownList.ScrollBarImageColor3 = SelectedTheme.ElementStroke
			DropdownList.Visible = false
			DropdownList.Parent = Dropdown
			
			local ListLayout = Instance.new("UIListLayout")
			ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
			ListLayout.Padding = UDim.new(0, 2)
			ListLayout.Parent = DropdownList
			
			ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
				DropdownList.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y)
			end)
			
			DropdownSettings.CurrentOption = DropdownSettings.CurrentOption or {}
			DropdownSettings.Options = DropdownSettings.Options or {}
			DropdownSettings.MultipleOptions = DropdownSettings.MultipleOptions or false
			DropdownSettings.Type = "Dropdown"
			DropdownSettings.Callback = DropdownSettings.Callback or function() end
			
			if type(DropdownSettings.CurrentOption) == "string" then
				DropdownSettings.CurrentOption = {DropdownSettings.CurrentOption}
			end
			
			local IsOpen = false
			
			local DropdownValue = {
				Type = "Dropdown",
				Element = Dropdown,
				CurrentOption = DropdownSettings.CurrentOption,
				Options = DropdownSettings.Options,
				MultipleOptions = DropdownSettings.MultipleOptions,
				Callback = DropdownSettings.Callback,
				Locked = false
			}
			
			local function UpdateText()
				if #DropdownValue.CurrentOption == 0 then
					Selected.Text = "None"
					Selected.TextColor3 = SelectedTheme.PlaceholderColor
				elseif #DropdownValue.CurrentOption == 1 then
					Selected.Text = DropdownValue.CurrentOption[1]
					Selected.TextColor3 = SelectedTheme.TextColor
				else
					Selected.Text = "Multiple (" .. #DropdownValue.CurrentOption .. ")"
					Selected.TextColor3 = SelectedTheme.TextColor
				end
			end
			
			local function CreateOptions()
				for _, child in ipairs(DropdownList:GetChildren()) do
					if child:IsA("Frame") then
						child:Destroy()
					end
				end
				
				for _, option in ipairs(DropdownValue.Options) do
					local OptionFrame = Instance.new("Frame")
					OptionFrame.Name = option
					OptionFrame.BackgroundColor3 = SelectedTheme.DropdownUnselected
					OptionFrame.BorderSizePixel = 0
					OptionFrame.Size = UDim2.new(1, -10, 0, 30)
					OptionFrame.Parent = DropdownList
					
					local OptionCorner = Instance.new("UICorner")
					OptionCorner.CornerRadius = UDim.new(0, 4)
					OptionCorner.Parent = OptionFrame
					
					local OptionTitle = Instance.new("TextLabel")
					OptionTitle.Name = "Title"
					OptionTitle.BackgroundTransparency = 1
					OptionTitle.Position = UDim2.new(0, 10, 0, 0)
					OptionTitle.Size = UDim2.new(1, -20, 1, 0)
					OptionTitle.Font = Enum.Font.Gotham
					OptionTitle.Text = option
					OptionTitle.TextColor3 = SelectedTheme.TextColor
					OptionTitle.TextSize = 12
					OptionTitle.TextXAlignment = Enum.TextXAlignment.Left
					OptionTitle.Parent = OptionFrame
					
					local OptionInteract = Instance.new("TextButton")
					OptionInteract.Name = "Interact"
					OptionInteract.BackgroundTransparency = 1
					OptionInteract.Size = UDim2.new(1, 0, 1, 0)
					OptionInteract.Text = ""
					OptionInteract.Parent = OptionFrame
					
					if table.find(DropdownValue.CurrentOption, option) then
						OptionFrame.BackgroundColor3 = SelectedTheme.DropdownSelected
					end
					
					OptionInteract.MouseEnter:Connect(function()
						Tween(OptionFrame, {BackgroundColor3 = SelectedTheme.ElementBackgroundHover}, 0.2)
					end)
					
					OptionInteract.MouseLeave:Connect(function()
						if table.find(DropdownValue.CurrentOption, option) then
							Tween(OptionFrame, {BackgroundColor3 = SelectedTheme.DropdownSelected}, 0.2)
						else
							Tween(OptionFrame, {BackgroundColor3 = SelectedTheme.DropdownUnselected}, 0.2)
						end
					end)
					
					OptionInteract.MouseButton1Click:Connect(function()
						if DropdownValue.Locked then return end
						
						RippleEffect(OptionFrame, OptionInteract.AbsolutePosition.X - OptionFrame.AbsolutePosition.X + OptionInteract.AbsoluteSize.X / 2, OptionInteract.AbsolutePosition.Y - OptionFrame.AbsolutePosition.Y + OptionInteract.AbsoluteSize.Y / 2)
						
						if table.find(DropdownValue.CurrentOption, option) then
							table.remove(DropdownValue.CurrentOption, table.find(DropdownValue.CurrentOption, option))
							Tween(OptionFrame, {BackgroundColor3 = SelectedTheme.DropdownUnselected})
						else
							if not DropdownValue.MultipleOptions then
								table.clear(DropdownValue.CurrentOption)
								for _, optFrame in ipairs(DropdownList:GetChildren()) do
									if optFrame:IsA("Frame") then
										Tween(optFrame, {BackgroundColor3 = SelectedTheme.DropdownUnselected})
									end
								end
							end
							table.insert(DropdownValue.CurrentOption, option)
							Tween(OptionFrame, {BackgroundColor3 = SelectedTheme.DropdownSelected})
						end
						
						UpdateText()
						local success, err = pcall(DropdownValue.Callback, DropdownValue.CurrentOption)
						if not success then
							ShowError(DropdownSettings.Name, err)
						end
						SaveConfiguration()
						
						if not DropdownValue.MultipleOptions then
							task.wait(0.1)
							IsOpen = false
							DropdownList.Visible = false
							Tween(Dropdown, {Size = UDim2.new(1, 0, 0, 40)})
							Tween(Arrow, {Rotation = 0}, 0.2)
						end
					end)
				end
			end
			
			CreateOptions()
			UpdateText()
			
			DropdownInteract.MouseEnter:Connect(function()
				if not DropdownValue.Locked then
					Tween(Dropdown, {BackgroundColor3 = SelectedTheme.ElementBackgroundHover})
				end
			end)
			
			DropdownInteract.MouseLeave:Connect(function()
				if not DropdownValue.Locked then
					Tween(Dropdown, {BackgroundColor3 = SelectedTheme.ElementBackground})
				end
			end)
			
			DropdownInteract.MouseButton1Click:Connect(function()
				if DropdownValue.Locked then return end
				
				IsOpen = not IsOpen
				DropdownList.Visible = IsOpen
				
				if IsOpen then
					local maxHeight = math.min(#DropdownValue.Options * 32, 150)
					Tween(Dropdown, {Size = UDim2.new(1, 0, 0, 45 + maxHeight)})
					Tween(DropdownList, {Size = UDim2.new(1, 0, 0, maxHeight)}, 0.3)
					Tween(Arrow, {Rotation = 180}, 0.2)
				else
					Tween(Dropdown, {Size = UDim2.new(1, 0, 0, 40)})
					Tween(DropdownList, {Size = UDim2.new(1, 0, 0, 0)}, 0.3)
					Tween(Arrow, {Rotation = 0}, 0.2)
				end
			end)
			
			function DropdownValue:Set(Option)
				if type(Option) == "string" then
					Option = {Option}
				end
				
				DropdownValue.CurrentOption = Option
				UpdateText()
				CreateOptions()
				local success, err = pcall(DropdownValue.Callback, Option)
				if not success then
					ShowError(DropdownSettings.Name, err)
				end
				SaveConfiguration()
			end
			
			function DropdownValue:Get()
				return DropdownValue.CurrentOption
			end
			
			function DropdownValue:SetCallback(NewCallback)
				DropdownValue.Callback = NewCallback
			end
			
			function DropdownValue:Refresh(NewOptions)
				DropdownValue.Options = NewOptions
				CreateOptions()
			end
			
			function DropdownValue:SetLocked(Locked)
				DropdownValue.Locked = Locked
				if Locked then
					Tween(Dropdown, {BackgroundColor3 = SelectedTheme.SecondaryElementBackground})
					Tween(DropdownTitle, {TextTransparency = 0.5})
				else
					Tween(Dropdown, {BackgroundColor3 = SelectedTheme.ElementBackground})
					Tween(DropdownTitle, {TextTransparency = 0})
				end
			end
			
			function DropdownValue:Remove()
				Tween(Dropdown, {Size = UDim2.new(1, 0, 0, 0)})
				task.wait(0.3)
				Dropdown:Destroy()
			end
			
			if DropdownSettings.Flag then
				MercuryLibrary.Flags[DropdownSettings.Flag] = DropdownValue
			end
			
			table.insert(Tab.Elements, DropdownValue)
			return DropdownValue
		end
		
		function Tab:CreateInput(InputSettings)
			local Input = Instance.new("Frame")
			Input.Name = InputSettings.Name
			Input.BackgroundColor3 = SelectedTheme.ElementBackground
			Input.BorderSizePixel = 0
			Input.Size = UDim2.new(1, 0, 0, 70)
			Input.Parent = TabPage
			
			local InputCorner = Instance.new("UICorner")
			InputCorner.CornerRadius = UDim.new(0, 6)
			InputCorner.Parent = Input
			
			local InputStroke = Instance.new("UIStroke")
			InputStroke.Color = SelectedTheme.ElementStroke
			InputStroke.Thickness = 1
			InputStroke.Parent = Input
			
			local InputTitle = Instance.new("TextLabel")
			InputTitle.Name = "Title"
			InputTitle.BackgroundTransparency = 1
			InputTitle.Position = UDim2.new(0, 15, 0, 8)
			InputTitle.Size = UDim2.new(1, -30, 0, 20)
			InputTitle.Font = Enum.Font.GothamSemibold
			InputTitle.Text = InputSettings.Name
			InputTitle.TextColor3 = SelectedTheme.TextColor
			InputTitle.TextSize = 13
			InputTitle.TextXAlignment = Enum.TextXAlignment.Left
			InputTitle.Parent = Input
			
			local InputFrame = Instance.new("Frame")
			InputFrame.Name = "InputFrame"
			InputFrame.BackgroundColor3 = SelectedTheme.InputBackground
			InputFrame.BorderSizePixel = 0
			InputFrame.Position = UDim2.new(0, 15, 0, 35)
			InputFrame.Size = UDim2.new(1, -30, 0, 25)
			InputFrame.Parent = Input
			
			local InputFrameCorner = Instance.new("UICorner")
			InputFrameCorner.CornerRadius = UDim.new(0, 4)
			InputFrameCorner.Parent = InputFrame
			
			local InputFrameStroke = Instance.new("UIStroke")
			InputFrameStroke.Color = SelectedTheme.InputStroke
			InputFrameStroke.Thickness = 1
			InputFrameStroke.Parent = InputFrame
			
			local InputBox = Instance.new("TextBox")
			InputBox.Name = "InputBox"
			InputBox.BackgroundTransparency = 1
			InputBox.Position = UDim2.new(0, 10, 0, 0)
			InputBox.Size = UDim2.new(1, -20, 1, 0)
			InputBox.Font = Enum.Font.Gotham
			InputBox.PlaceholderText = InputSettings.Placeholder or "Enter text..."
			InputBox.PlaceholderColor3 = SelectedTheme.PlaceholderColor
			InputBox.Text = InputSettings.CurrentValue or ""
			InputBox.TextColor3 = SelectedTheme.TextColor
			InputBox.TextSize = 12
			InputBox.TextXAlignment = Enum.TextXAlignment.Left
			InputBox.ClearTextOnFocus = false
			InputBox.Parent = InputFrame
			
			InputSettings.CurrentValue = InputSettings.CurrentValue or ""
			InputSettings.Type = "Input"
			InputSettings.Callback = InputSettings.Callback or function() end
			
			local InputValue = {
				Type = "Input",
				Element = Input,
				CurrentValue = InputSettings.CurrentValue,
				Callback = InputSettings.Callback,
				Locked = false
			}
			
			InputBox.Focused:Connect(function()
				Tween(InputFrameStroke, {Color = SelectedTheme.AccentColor})
			end)
			
			InputBox.FocusLost:Connect(function()
				Tween(InputFrameStroke, {Color = SelectedTheme.InputStroke})
				
				if not InputValue.Locked then
					InputValue.CurrentValue = InputBox.Text
					local success, err = pcall(InputValue.Callback, InputValue.CurrentValue)
					if not success then
						ShowError(InputSettings.Name, err)
					end
					SaveConfiguration()
				end
			end)
			
			function InputValue:Set(Text)
				InputBox.Text = Text
				InputValue.CurrentValue = Text
				local success, err = pcall(InputValue.Callback, Text)
				if not success then
					ShowError(InputSettings.Name, err)
				end
				SaveConfiguration()
			end
			
			function InputValue:Get()
				return InputValue.CurrentValue
			end
			
			function InputValue:SetCallback(NewCallback)
				InputValue.Callback = NewCallback
			end
			
			function InputValue:SetPlaceholder(NewPlaceholder)
				InputBox.PlaceholderText = NewPlaceholder
			end
			
			function InputValue:SetLocked(Locked)
				InputValue.Locked = Locked
				InputBox.TextEditable = not Locked
				if Locked then
					Tween(Input, {BackgroundColor3 = SelectedTheme.SecondaryElementBackground})
					Tween(InputTitle, {TextTransparency = 0.5})
					Tween(InputBox, {TextTransparency = 0.5})
				else
					Tween(Input, {BackgroundColor3 = SelectedTheme.ElementBackground})
					Tween(InputTitle, {TextTransparency = 0})
					Tween(InputBox, {TextTransparency = 0})
				end
			end
			
			function InputValue:Remove()
				Tween(Input, {Size = UDim2.new(1, 0, 0, 0)})
				task.wait(0.3)
				Input:Destroy()
			end
			
			if InputSettings.Flag then
				MercuryLibrary.Flags[InputSettings.Flag] = InputValue
			end
			
			table.insert(Tab.Elements, InputValue)
			return InputValue
		end
		
		function Tab:CreateKeybind(KeybindSettings)
			local Keybind = Instance.new("Frame")
			Keybind.Name = KeybindSettings.Name
			Keybind.BackgroundColor3 = SelectedTheme.ElementBackground
			Keybind.BorderSizePixel = 0
			Keybind.Size = UDim2.new(1, 0, 0, 40)
			Keybind.Parent = TabPage
			
			local KeybindCorner = Instance.new("UICorner")
			KeybindCorner.CornerRadius = UDim.new(0, 6)
			KeybindCorner.Parent = Keybind
			
			local KeybindStroke = Instance.new("UIStroke")
			KeybindStroke.Color = SelectedTheme.ElementStroke
			KeybindStroke.Thickness = 1
			KeybindStroke.Parent = Keybind
			
			local KeybindTitle = Instance.new("TextLabel")
			KeybindTitle.Name = "Title"
			KeybindTitle.BackgroundTransparency = 1
			KeybindTitle.Position = UDim2.new(0, 15, 0, 0)
			KeybindTitle.Size = UDim2.new(1, -130, 1, 0)
			KeybindTitle.Font = Enum.Font.GothamSemibold
			KeybindTitle.Text = KeybindSettings.Name
			KeybindTitle.TextColor3 = SelectedTheme.TextColor
			KeybindTitle.TextSize = 13
			KeybindTitle.TextXAlignment = Enum.TextXAlignment.Left
			KeybindTitle.Parent = Keybind
			
			local KeybindFrame = Instance.new("Frame")
			KeybindFrame.Name = "KeybindFrame"
			KeybindFrame.BackgroundColor3 = SelectedTheme.InputBackground
			KeybindFrame.BorderSizePixel = 0
			KeybindFrame.Position = UDim2.new(1, -115, 0.5, -12)
			KeybindFrame.Size = UDim2.new(0, 100, 0, 24)
			KeybindFrame.Parent = Keybind
			
			local KeybindFrameCorner = Instance.new("UICorner")
			KeybindFrameCorner.CornerRadius = UDim.new(0, 4)
			KeybindFrameCorner.Parent = KeybindFrame
			
			local KeybindFrameStroke = Instance.new("UIStroke")
			KeybindFrameStroke.Color = SelectedTheme.InputStroke
			KeybindFrameStroke.Thickness = 1
			KeybindFrameStroke.Parent = KeybindFrame
			
			local KeybindBox = Instance.new("TextButton")
			KeybindBox.Name = "KeybindBox"
			KeybindBox.BackgroundTransparency = 1
			KeybindBox.Size = UDim2.new(1, 0, 1, 0)
			KeybindBox.Font = Enum.Font.GothamSemibold
			KeybindBox.Text = KeybindSettings.CurrentKeybind or "None"
			KeybindBox.TextColor3 = SelectedTheme.TextColor
			KeybindBox.TextSize = 11
			KeybindBox.Parent = KeybindFrame
			
			KeybindSettings.CurrentKeybind = KeybindSettings.CurrentKeybind or "None"
			KeybindSettings.Type = "Keybind"
			KeybindSettings.Callback = KeybindSettings.Callback or function() end
			
			local CheckingForKey = false
			
			local KeybindValue = {
				Type = "Keybind",
				Element = Keybind,
				CurrentKeybind = KeybindSettings.CurrentKeybind,
				Callback = KeybindSettings.Callback,
				Locked = false
			}
			
			KeybindBox.MouseButton1Click:Connect(function()
				if KeybindValue.Locked then return end
				
				CheckingForKey = true
				KeybindBox.Text = "..."
				Tween(KeybindFrameStroke, {Color = SelectedTheme.AccentColor})
			end)
			
			UserInputService.InputBegan:Connect(function(input, processed)
				if CheckingForKey and input.KeyCode ~= Enum.KeyCode.Unknown then
					local NewKey = input.KeyCode.Name
					KeybindBox.Text = NewKey
					KeybindValue.CurrentKeybind = NewKey
					CheckingForKey = false
					Tween(KeybindFrameStroke, {Color = SelectedTheme.InputStroke})
					SaveConfiguration()
				elseif not processed and not CheckingForKey and input.KeyCode.Name == KeybindValue.CurrentKeybind and KeybindValue.CurrentKeybind ~= "None" then
					local success, err = pcall(KeybindValue.Callback, KeybindValue.CurrentKeybind)
					if not success then
						ShowError(KeybindSettings.Name, err)
					end
				end
			end)
			
			KeybindBox.MouseEnter:Connect(function()
				if not KeybindValue.Locked then
					Tween(KeybindFrame, {BackgroundColor3 = SelectedTheme.ElementBackgroundHover})
				end
			end)
			
			KeybindBox.MouseLeave:Connect(function()
				Tween(KeybindFrame, {BackgroundColor3 = SelectedTheme.InputBackground})
			end)
			
			function KeybindValue:Set(NewKeybind)
				KeybindBox.Text = NewKeybind
				KeybindValue.CurrentKeybind = NewKeybind
				SaveConfiguration()
			end
			
			function KeybindValue:Get()
				return KeybindValue.CurrentKeybind
			end
			
			function KeybindValue:SetCallback(NewCallback)
				KeybindValue.Callback = NewCallback
			end
			
			function KeybindValue:SetLocked(Locked)
				KeybindValue.Locked = Locked
				if Locked then
					Tween(Keybind, {BackgroundColor3 = SelectedTheme.SecondaryElementBackground})
					Tween(KeybindTitle, {TextTransparency = 0.5})
					Tween(KeybindBox, {TextTransparency = 0.5})
				else
					Tween(Keybind, {BackgroundColor3 = SelectedTheme.ElementBackground})
					Tween(KeybindTitle, {TextTransparency = 0})
					Tween(KeybindBox, {TextTransparency = 0})
				end
			end
			
			function KeybindValue:Remove()
				Tween(Keybind, {Size = UDim2.new(1, 0, 0, 0)})
				task.wait(0.3)
				Keybind:Destroy()
			end
			
			if KeybindSettings.Flag then
				MercuryLibrary.Flags[KeybindSettings.Flag] = KeybindValue
			end
			
			table.insert(Tab.Elements, KeybindValue)
			return KeybindValue
		end
		
		function Tab:CreateColorPicker(ColorPickerSettings)
			local ColorPicker = Instance.new("Frame")
			ColorPicker.Name = ColorPickerSettings.Name
			ColorPicker.BackgroundColor3 = SelectedTheme.ElementBackground
			ColorPicker.BorderSizePixel = 0
			ColorPicker.Size = UDim2.new(1, 0, 0, 40)
			ColorPicker.Parent = TabPage
			
			local ColorPickerCorner = Instance.new("UICorner")
			ColorPickerCorner.CornerRadius = UDim.new(0, 6)
			ColorPickerCorner.Parent = ColorPicker
			
			local ColorPickerStroke = Instance.new("UIStroke")
			ColorPickerStroke.Color = SelectedTheme.ElementStroke
			ColorPickerStroke.Thickness = 1
			ColorPickerStroke.Parent = ColorPicker
			
			local ColorPickerTitle = Instance.new("TextLabel")
			ColorPickerTitle.Name = "Title"
			ColorPickerTitle.BackgroundTransparency = 1
			ColorPickerTitle.Position = UDim2.new(0, 15, 0, 0)
			ColorPickerTitle.Size = UDim2.new(1, -70, 1, 0)
			ColorPickerTitle.Font = Enum.Font.GothamSemibold
			ColorPickerTitle.Text = ColorPickerSettings.Name
			ColorPickerTitle.TextColor3 = SelectedTheme.TextColor
			ColorPickerTitle.TextSize = 13
			ColorPickerTitle.TextXAlignment = Enum.TextXAlignment.Left
			ColorPickerTitle.Parent = ColorPicker
			
			local CPBackground = Instance.new("Frame")
			CPBackground.Name = "CPBackground"
			CPBackground.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			CPBackground.BorderSizePixel = 0
			CPBackground.Position = UDim2.new(1, -50, 0.5, -12)
			CPBackground.Size = UDim2.new(0, 35, 0, 24)
			CPBackground.Parent = ColorPicker
			
			local CPBackgroundCorner = Instance.new("UICorner")
			CPBackgroundCorner.CornerRadius = UDim.new(0, 4)
			CPBackgroundCorner.Parent = CPBackground
			
			local CPBackgroundStroke = Instance.new("UIStroke")
			CPBackgroundStroke.Color = SelectedTheme.ElementStroke
			CPBackgroundStroke.Thickness = 2
			CPBackgroundStroke.Parent = CPBackground
			
			local Display = Instance.new("Frame")
			Display.Name = "Display"
			Display.BackgroundColor3 = ColorPickerSettings.Color or Color3.fromRGB(255, 255, 255)
			Display.BorderSizePixel = 0
			Display.Position = UDim2.new(0, 2, 0, 2)
			Display.Size = UDim2.new(1, -4, 1, -4)
			Display.Parent = CPBackground
			
			local DisplayCorner = Instance.new("UICorner")
			DisplayCorner.CornerRadius = UDim.new(0, 2)
			DisplayCorner.Parent = Display
			
			local ColorPickerInteract = Instance.new("TextButton")
			ColorPickerInteract.Name = "Interact"
			ColorPickerInteract.BackgroundTransparency = 1
			ColorPickerInteract.Size = UDim2.new(1, 0, 1, 0)
			ColorPickerInteract.Text = ""
			ColorPickerInteract.Parent = ColorPicker
			
			ColorPickerSettings.Color = ColorPickerSettings.Color or Color3.fromRGB(255, 255, 255)
			ColorPickerSettings.Type = "ColorPicker"
			ColorPickerSettings.Callback = ColorPickerSettings.Callback or function() end
			
			local ColorPickerValue = {
				Type = "ColorPicker",
				Element = ColorPicker,
				Color = ColorPickerSettings.Color,
				Callback = ColorPickerSettings.Callback,
				Locked = false
			}
			
			ColorPickerInteract.MouseEnter:Connect(function()
				if not ColorPickerValue.Locked then
					Tween(ColorPicker, {BackgroundColor3 = SelectedTheme.ElementBackgroundHover})
				end
			end)
			
			ColorPickerInteract.MouseLeave:Connect(function()
				if not ColorPickerValue.Locked then
					Tween(ColorPicker, {BackgroundColor3 = SelectedTheme.ElementBackground})
				end
			end)
			
			ColorPickerInteract.MouseButton1Click:Connect(function()
				if ColorPickerValue.Locked then return end
				
				RippleEffect(ColorPicker, ColorPickerInteract.AbsolutePosition.X - ColorPicker.AbsolutePosition.X + ColorPickerInteract.AbsoluteSize.X / 2, ColorPickerInteract.AbsolutePosition.Y - ColorPicker.AbsolutePosition.Y + ColorPickerInteract.AbsoluteSize.Y / 2)
				
				-- Simple color rotation demo
				local r, g, b = ColorPickerValue.Color.R, ColorPickerValue.Color.G, ColorPickerValue.Color.B
				local newColor = Color3.fromRGB(
					math.floor((r * 255 + 30) % 255),
					math.floor((g * 255 + 60) % 255),
					math.floor((b * 255 + 90) % 255)
				)
				ColorPickerValue:Set(newColor)
			end)
			
			function ColorPickerValue:Set(NewColor)
				ColorPickerValue.Color = NewColor
				Tween(Display, {BackgroundColor3 = NewColor})
				local success, err = pcall(ColorPickerValue.Callback, NewColor)
				if not success then
					ShowError(ColorPickerSettings.Name, err)
				end
				SaveConfiguration()
			end
			
			function ColorPickerValue:Get()
				return ColorPickerValue.Color
			end
			
			function ColorPickerValue:SetCallback(NewCallback)
				ColorPickerValue.Callback = NewCallback
			end
			
			function ColorPickerValue:SetLocked(Locked)
				ColorPickerValue.Locked = Locked
				if Locked then
					Tween(ColorPicker, {BackgroundColor3 = SelectedTheme.SecondaryElementBackground})
					Tween(ColorPickerTitle, {TextTransparency = 0.5})
				else
					Tween(ColorPicker, {BackgroundColor3 = SelectedTheme.ElementBackground})
					Tween(ColorPickerTitle, {TextTransparency = 0})
				end
			end
			
			function ColorPickerValue:Remove()
				Tween(ColorPicker, {Size = UDim2.new(1, 0, 0, 0)})
				task.wait(0.3)
				ColorPicker:Destroy()
			end
			
			if ColorPickerSettings.Flag then
				MercuryLibrary.Flags[ColorPickerSettings.Flag] = ColorPickerValue
			end
			
			table.insert(Tab.Elements, ColorPickerValue)
			return ColorPickerValue
		end
		
		function Tab:Remove()
			TabButton:Destroy()
			TabPage:Destroy()
			for i, t in ipairs(Window.Tabs) do
				if t == Tab then
					table.remove(Window.Tabs, i)
					break
				end
			end
		end
		
		return Tab
	end
	
	task.delay(1, function()
		MercuryLibrary:LoadConfiguration()
	end)
	
	return Window
end

return MercuryLibrary
