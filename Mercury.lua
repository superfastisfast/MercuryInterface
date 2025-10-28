
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
local AnimationSpeed = 0.25
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
	Windows = {}, -- Track all Mercury windows
	DetectedGUIs = {}, -- Track non-Mercury GUIs
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
			SliderBackground = Color3.fromRGB(43, 43, 43),
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
			SliderBackground = Color3.fromRGB(35, 55, 55),
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
			PlaceholderColor = Color3.fromRGB(140, 160, 160),
			AccentColor = Color3.fromRGB(0, 140, 140),
			ErrorColor = Color3.fromRGB(220, 80, 80),
			SuccessColor = Color3.fromRGB(50, 200, 150),
			WarningColor = Color3.fromRGB(220, 180, 80)
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
			SliderBackground = Color3.fromRGB(220, 220, 220),
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
			PlaceholderColor = Color3.fromRGB(140, 140, 140),
			AccentColor = Color3.fromRGB(0, 146, 214),
			ErrorColor = Color3.fromRGB(220, 50, 50),
			SuccessColor = Color3.fromRGB(50, 200, 100),
			WarningColor = Color3.fromRGB(220, 160, 50)
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
			SliderBackground = Color3.fromRGB(30, 30, 45),
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
			PlaceholderColor = Color3.fromRGB(120, 120, 140),
			AccentColor = Color3.fromRGB(100, 100, 200),
			ErrorColor = Color3.fromRGB(220, 80, 100),
			SuccessColor = Color3.fromRGB(100, 200, 150),
			WarningColor = Color3.fromRGB(220, 180, 100)
		}
	}
}

local SelectedTheme = MercuryLibrary.Theme.Default
local Hidden = false
local Minimized = false

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

local function Tween(Object, Properties, Duration, Style, Direction, Callback)
	Duration = Duration or AnimationSpeed
	Style = Style or AnimationStyle
	Direction = Direction or AnimationDirection
	
	local tween = TweenService:Create(
		Object,
		TweenInfo.new(Duration, Style, Direction),
		Properties
	)
	
	if Callback then
		tween.Completed:Connect(Callback)
	end
	
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
	}, 0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out, function()
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
		local Type = Settings.Type or "Default"
		
		-- Create notification holder if it doesn't exist
		local NotificationHolder = nil
		
		if gethui then
			NotificationHolder = gethui():FindFirstChild("MercuryNotifications")
		else
			NotificationHolder = CoreGui:FindFirstChild("MercuryNotifications")
		end
		
		if not NotificationHolder then
			NotificationHolder = Instance.new("ScreenGui")
			NotificationHolder.Name = "MercuryNotifications"
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
		Notification.Position = UDim2.new(1, 20, 1, -100 - (#NotificationHolder:GetChildren() * 90))
		Notification.ClipsDescendants = true
		Notification.Parent = NotificationHolder
		
		local Corner = Instance.new("UICorner")
		Corner.CornerRadius = UDim.new(0, 8)
		Corner.Parent = Notification
		
		local Stroke = Instance.new("UIStroke")
		Stroke.Color = SelectedTheme.ElementStroke
		Stroke.Thickness = 1
		Stroke.Parent = Notification
		
		local Shadow = Instance.new("ImageLabel")
		Shadow.Name = "Shadow"
		Shadow.BackgroundTransparency = 1
		Shadow.Position = UDim2.new(0, -15, 0, -15)
		Shadow.Size = UDim2.new(1, 30, 1, 30)
		Shadow.ZIndex = -1
		Shadow.Image = "rbxassetid://5554236805"
		Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
		Shadow.ImageTransparency = 0.7
		Shadow.ScaleType = Enum.ScaleType.Slice
		Shadow.SliceCenter = Rect.new(23, 23, 277, 277)
		Shadow.Parent = Notification
		
		local TitleLabel = Instance.new("TextLabel")
		TitleLabel.Name = "Title"
		TitleLabel.BackgroundTransparency = 1
		TitleLabel.Position = UDim2.new(0, 50, 0, 10)
		TitleLabel.Size = UDim2.new(1, -60, 0, 20)
		TitleLabel.Font = Enum.Font.GothamBold
		TitleLabel.Text = Title
		TitleLabel.TextColor3 = SelectedTheme.TextColor
		TitleLabel.TextSize = 14
		TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
		TitleLabel.Parent = Notification
		
		local ContentLabel = Instance.new("TextLabel")
		ContentLabel.Name = "Content"
		ContentLabel.BackgroundTransparency = 1
		ContentLabel.Position = UDim2.new(0, 50, 0, 35)
		ContentLabel.Size = UDim2.new(1, -60, 0, 35)
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
		IndicatorCorner.CornerRadius = UDim.new(0, 8)
		IndicatorCorner.Parent = Indicator
		
		local Icon = Instance.new("TextLabel")
		Icon.Name = "Icon"
		Icon.BackgroundTransparency = 1
		Icon.Position = UDim2.new(0, 15, 0, 0)
		Icon.Size = UDim2.new(0, 30, 1, 0)
		Icon.Font = Enum.Font.GothamBold
		Icon.TextColor3 = TypeColor
		Icon.TextSize = 24
		Icon.Text = "i"
		if Type == "Success" then Icon.Text = "✓"
		elseif Type == "Warning" then Icon.Text = "⚠"
		elseif Type == "Error" then Icon.Text = "✕" end
		Icon.Parent = Notification
		
		-- Animate in
		Tween(Notification, {Position = UDim2.new(1, -320, 1, -100 - (#NotificationHolder:GetChildren() - 1) * 90)}, 0.5, Enum.EasingStyle.Back)
		
		-- Animate out
		task.delay(Duration, function()
			Tween(Notification, {
				Position = UDim2.new(1, 20, 1, -100 - (#NotificationHolder:GetChildren() - 1) * 90),
				BackgroundTransparency = 1
			}, 0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.In, function()
				Notification:Destroy()
			end)
			
			Tween(TitleLabel, {TextTransparency = 1}, 0.5)
			Tween(ContentLabel, {TextTransparency = 1}, 0.5)
			Tween(Icon, {TextTransparency = 1}, 0.5)
			Tween(Indicator, {BackgroundTransparency = 1}, 0.5)
			Tween(Stroke, {Transparency = 1}, 0.5)
			Tween(Shadow, {ImageTransparency = 1}, 0.5)
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
	
	-- Load the Mercury GUI from asset
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
	
	-- Apply theme
	Main.BackgroundColor3 = SelectedTheme.Background
	Topbar.BackgroundColor3 = SelectedTheme.Topbar
	
	-- Configure
	Topbar.Title.Text = Settings.Name or "Mercury"
	Mercury.Enabled = true
	Main.Visible = true
	
	-- Add resize handle
	local ResizeHandle = Instance.new("Frame")
	ResizeHandle.Name = "ResizeHandle"
	ResizeHandle.BackgroundColor3 = SelectedTheme.AccentColor
	ResizeHandle.BackgroundTransparency = 0.7
	ResizeHandle.BorderSizePixel = 0
	ResizeHandle.Position = UDim2.new(1, -15, 1, -15)
	ResizeHandle.Size = UDim2.new(0, 15, 0, 15)
	ResizeHandle.ZIndex = 100
	ResizeHandle.Parent = Main
	
	local ResizeCorner = Instance.new("UICorner")
	ResizeCorner.CornerRadius = UDim.new(0, 4)
	ResizeCorner.Parent = ResizeHandle
	
	ResizeHandle.MouseEnter:Connect(function()
		Tween(ResizeHandle, {BackgroundTransparency = 0.3}, 0.2)
	end)
	
	ResizeHandle.MouseLeave:Connect(function()
		Tween(ResizeHandle, {BackgroundTransparency = 0.7}, 0.2)
	end)
	
	-- Dragging setup
	local Dragging = false
	local DragStart = nil
	local StartPos = nil
	local Resizing = false
	local ResizeStart = nil
	local StartSize = nil
	
	Topbar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType.Touch then
			Dragging = true
			DragStart = input.Position
			StartPos = Main.Position
			
			Tween(Main, {Size = Main.Size + UDim2.new(0, 10, 0, 10)}, 0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
			task.wait(0.1)
			Tween(Main, {Size = Main.Size - UDim2.new(0, 10, 0, 10)}, 0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
			
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					Dragging = false
				end
			end)
		end
	end)
	
	Topbar.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			if Dragging then
				local Delta = input.Position - DragStart
				Main.Position = UDim2.new(
					StartPos.X.Scale,
					StartPos.X.Offset + Delta.X,
					StartPos.Y.Scale,
					StartPos.Y.Offset + Delta.Y
				)
			end
		end
	end)
	
	-- Resizing
	ResizeHandle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			Resizing = true
			ResizeStart = input.Position
			StartSize = Main.Size
			
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					Resizing = false
				end
			end)
		end
	end)
	
	UserInputService.InputChanged:Connect(function(input)
		if Resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
			local Delta = input.Position - ResizeStart
			local NewSize = UDim2.new(
				0,
				math.max(400, StartSize.X.Offset + Delta.X),
				0,
				math.max(300, StartSize.Y.Offset + Delta.Y)
			)
			Main.Size = NewSize
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
	
	function Window:SetSize(Width, Height)
		Tween(Main, {Size = UDim2.new(0, Width, 0, Height)}, 0.4, Enum.EasingStyle.Quart)
	end
	
	function Window:GetSize()
		return Main.Size
	end
	
	function Window:SetPosition(X, Y)
		Tween(Main, {Position = UDim2.new(0, X, 0, Y)}, 0.4, Enum.EasingStyle.Quart)
	end
	
	function Window:Center()
		local ViewportSize = workspace.CurrentCamera.ViewportSize
		Tween(Main, {
			Position = UDim2.new(0, (ViewportSize.X - Main.AbsoluteSize.X) / 2, 0, (ViewportSize.Y - Main.AbsoluteSize.Y) / 2)
		}, 0.5, Enum.EasingStyle.Quart)
	end
	
	function Window:Shake(Intensity)
		Intensity = Intensity or 10
		local OriginalPos = Main.Position
		for i = 1, 5 do
			Tween(Main, {
				Position = OriginalPos + UDim2.new(0, math.random(-Intensity, Intensity), 0, math.random(-Intensity, Intensity))
			}, 0.05)
			task.wait(0.05)
		end
		Tween(Main, {Position = OriginalPos}, 0.1)
	end
	
	function Window:Pulse()
		local OriginalSize = Main.Size
		Tween(Main, {Size = OriginalSize * 1.05}, 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		task.wait(0.15)
		Tween(Main, {Size = OriginalSize}, 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
	end
		if typeof(ThemeName) == 'string' and MercuryLibrary.Theme[ThemeName] then
			ChangeTheme(ThemeName)
		elseif typeof(ThemeName) == 'table' then
			ChangeTheme(ThemeName)
		end
		
		Tween(Main, {BackgroundColor3 = SelectedTheme.Background}, 0.3)
		Tween(Topbar, {BackgroundColor3 = SelectedTheme.Topbar}, 0.3)
	end
	
	function Window:Toggle()
		Hidden = not Hidden
		Mercury.Enabled = not Hidden
	end
	
	function Window:Show()
		Hidden = false
		Mercury.Enabled = true
		Tween(Main, {Size = UDim2.new(0, 500, 0, 475)}, 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
	end
	
	function Window:Hide()
		Tween(Main, {Size = UDim2.new(0, 500, 0, 0)}, 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In, function()
			Hidden = true
			Mercury.Enabled = false
		end)
	end
	
	function Window:FadeIn()
		Mercury.Enabled = true
		Main.BackgroundTransparency = 1
		Topbar.BackgroundTransparency = 1
		for _, v in pairs(Main:GetDescendants()) do
			if v:IsA("TextLabel") or v:IsA("TextButton") then
				v.TextTransparency = 1
			elseif v:IsA("ImageLabel") or v:IsA("ImageButton") then
				v.ImageTransparency = 1
			elseif v:IsA("Frame") then
				v.BackgroundTransparency = 1
			end
		end
		
		Tween(Main, {BackgroundTransparency = 0}, 0.5)
		Tween(Topbar, {BackgroundTransparency = 0}, 0.5)
		
		for _, v in pairs(Main:GetDescendants()) do
			if v:IsA("TextLabel") or v:IsA("TextButton") then
				Tween(v, {TextTransparency = 0}, 0.5)
			elseif v:IsA("ImageLabel") or v:IsA("ImageButton") then
				Tween(v, {ImageTransparency = 0}, 0.5)
			elseif v:IsA("Frame") and v.Name ~= "Template" then
				Tween(v, {BackgroundTransparency = 0}, 0.5)
			end
		end
		
		Hidden = false
	end
	
	function Window:FadeOut()
		Tween(Main, {BackgroundTransparency = 1}, 0.5)
		Tween(Topbar, {BackgroundTransparency = 1}, 0.5)
		
		for _, v in pairs(Main:GetDescendants()) do
			if v:IsA("TextLabel") or v:IsA("TextButton") then
				Tween(v, {TextTransparency = 1}, 0.5)
			elseif v:IsA("ImageLabel") or v:IsA("ImageButton") then
				Tween(v, {ImageTransparency = 1}, 0.5)
			elseif v:IsA("Frame") then
				Tween(v, {BackgroundTransparency = 1}, 0.5)
			end
		end
		
		task.wait(0.5)
		Hidden = true
		Mercury.Enabled = false
	end
	
	function Window:IsVisible()
		return not Hidden
	end
	
	function Window:Minimize()
		if Minimized then return end
		Minimized = true
		Tween(Main, {Size = UDim2.new(0, 500, 0, 45)}, 0.4, Enum.EasingStyle.Quart)
	end
	
	function Window:Maximize()
		if not Minimized then return end
		Minimized = false
		Tween(Main, {Size = UDim2.new(0, 500, 0, 475)}, 0.4, Enum.EasingStyle.Quart)
	end
	
	function Window:IsMinimized()
		return Minimized
	end
	
	function Window:Destroy()
		Mercury:Destroy()
	end
	
	function Window:GetTabs()
		return Window.Tabs
	end
	
	function Window:SelectTab(TabName)
		for _, tab in pairs(Window.Tabs) do
			if tab.Name == TabName then
				Elements.UIPageLayout:JumpTo(tab.Page)
				Window.CurrentTab = tab
				
				for _, btn in ipairs(TabList:GetChildren()) do
					if btn:IsA("Frame") and btn.Name ~= "Template" then
						if btn.Name == TabName then
							Tween(btn, {BackgroundColor3 = SelectedTheme.TabBackgroundSelected}, 0.2)
							Tween(btn.Title, {TextColor3 = SelectedTheme.SelectedTabTextColor}, 0.2)
						else
							Tween(btn, {BackgroundColor3 = SelectedTheme.TabBackground}, 0.2)
							Tween(btn.Title, {TextColor3 = SelectedTheme.TabTextColor}, 0.2)
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
			Window = Window
		}
		
		-- Create tab button
		local TabButton = TabList.Template:Clone()
		TabButton.Name = Name
		TabButton.Title.Text = Name
		TabButton.Visible = true
		TabButton.Parent = TabList
		
		-- Apply theme
		TabButton.BackgroundColor3 = SelectedTheme.TabBackground
		TabButton.Title.TextColor3 = SelectedTheme.TabTextColor
		
		-- Create tab page
		local TabPage = Elements.Template:Clone()
		TabPage.Name = Name
		TabPage.Visible = true
		TabPage.Parent = Elements
		
		Tab.Button = TabButton
		Tab.Page = TabPage
		
		table.insert(Window.Tabs, Tab)
		
		-- Tab button click with ripple
		TabButton.Interact.MouseButton1Click:Connect(function()
			local mousePos = UserInputService:GetMouseLocation()
			local buttonPos = TabButton.AbsolutePosition
			RippleEffect(TabButton, mousePos.X - buttonPos.X, mousePos.Y - buttonPos.Y)
			Window:SelectTab(Name)
		end)
		
		-- Hover effects
		TabButton.Interact.MouseEnter:Connect(function()
			if Window.CurrentTab ~= Tab then
				Tween(TabButton, {BackgroundColor3 = SelectedTheme.ElementBackgroundHover}, 0.2)
			end
		end)
		
		TabButton.Interact.MouseLeave:Connect(function()
			if Window.CurrentTab ~= Tab then
				Tween(TabButton, {BackgroundColor3 = SelectedTheme.TabBackground}, 0.2)
			end
		end)
		
		-- Auto-select first tab
		if #Window.Tabs == 1 then
			Window:SelectTab(Name)
		end
		
		function Tab:GetElements()
			return Tab.Elements
		end
		
		function Tab:CreateLabel(Text, Settings)
			Settings = Settings or {}
			
			local Label = TabPage.Label:Clone()
			Label.Title.Text = Text
			Label.Visible = true
			Label.Parent = TabPage
			
			if Settings.Color then
				Label.BackgroundColor3 = Settings.Color
			else
				Label.BackgroundColor3 = SelectedTheme.ElementBackground
			end
			
			local LabelValue = {
				Type = "Label",
				Element = Label,
				Visible = true
			}
			
			function LabelValue:Set(NewText, NewColor)
				-- Animate text change
				Tween(Label.Title, {TextTransparency = 1}, 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, function()
					Label.Title.Text = NewText
					Tween(Label.Title, {TextTransparency = 0}, 0.15)
				end)
				
				if NewColor then
					Tween(Label, {BackgroundColor3 = NewColor}, 0.3)
				end
			end
			
			function LabelValue:SetVisible(Visible)
				LabelValue.Visible = Visible
				if Visible then
					Label.Visible = true
					Tween(Label, {BackgroundTransparency = 0}, 0.3)
					Tween(Label.Title, {TextTransparency = 0}, 0.3)
				else
					Tween(Label, {BackgroundTransparency = 1}, 0.3)
					Tween(Label.Title, {TextTransparency = 1}, 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, function()
						Label.Visible = false
					end)
				end
			end
			
			function LabelValue:Flash(Times, Speed)
				Times = Times or 3
				Speed = Speed or 0.3
				for i = 1, Times do
					Tween(Label, {BackgroundColor3 = SelectedTheme.AccentColor}, Speed / 2)
					task.wait(Speed / 2)
					Tween(Label, {BackgroundColor3 = SelectedTheme.ElementBackground}, Speed / 2)
					task.wait(Speed / 2)
				end
			end
			
			function LabelValue:Remove()
				Label:Destroy()
			end
			
			table.insert(Tab.Elements, LabelValue)
			return LabelValue
		end
		
		function Tab:CreateButton(ButtonSettings)
			local Button = TabPage.Button:Clone()
			Button.Name = ButtonSettings.Name
			Button.Title.Text = ButtonSettings.Name
			Button.Visible = true
			Button.Parent = TabPage
			
			Button.BackgroundColor3 = SelectedTheme.ElementBackground
			
			local ButtonValue = {
				Type = "Button",
				Element = Button,
				Callback = ButtonSettings.Callback or function() end,
				Locked = false
			}
			
			Button.Interact.MouseEnter:Connect(function()
				if not ButtonValue.Locked then
					Tween(Button, {BackgroundColor3 = SelectedTheme.ElementBackgroundHover}, 0.2)
				end
			end)
			
			Button.Interact.MouseLeave:Connect(function()
				if not ButtonValue.Locked then
					Tween(Button, {BackgroundColor3 = SelectedTheme.ElementBackground}, 0.2)
				end
			end)
			
			Button.Interact.MouseButton1Click:Connect(function()
				if ButtonValue.Locked then return end
				
				local mousePos = UserInputService:GetMouseLocation()
				local buttonPos = Button.AbsolutePosition
				RippleEffect(Button, mousePos.X - buttonPos.X, mousePos.Y - buttonPos.Y)
				
				local success, err = pcall(ButtonValue.Callback)
				if not success then
					ShowError(ButtonSettings.Name, err)
				end
			end)
			
			function ButtonValue:Set(NewName)
				Button.Title.Text = NewName
			end
			
			function ButtonValue:SetCallback(NewCallback)
				ButtonValue.Callback = NewCallback
			end
			
			function ButtonValue:SetLocked(Locked)
				ButtonValue.Locked = Locked
				if Locked then
					Tween(Button, {BackgroundColor3 = SelectedTheme.SecondaryElementBackground}, 0.3)
					Tween(Button.Title, {TextTransparency = 0.5}, 0.3)
				else
					Tween(Button, {BackgroundColor3 = SelectedTheme.ElementBackground}, 0.3)
					Tween(Button.Title, {TextTransparency = 0}, 0.3)
				end
			end
			
			function ButtonValue:Remove()
				Button:Destroy()
			end
			
			table.insert(Tab.Elements, ButtonValue)
			return ButtonValue
		end
		
		function Tab:CreateToggle(ToggleSettings)
			local Toggle = TabPage.Toggle:Clone()
			Toggle.Name = ToggleSettings.Name
			Toggle.Title.Text = ToggleSettings.Name
			Toggle.Visible = true
			Toggle.Parent = TabPage
			
			Toggle.BackgroundColor3 = SelectedTheme.ElementBackground
			
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
				local ToggleFrame = Toggle:FindFirstChild("ToggleFrame")
				if ToggleFrame then
					local Indicator = ToggleFrame:FindFirstChild("Indicator")
					if Indicator then
						if ToggleValue.CurrentValue then
							Tween(Indicator, {
								Position = UDim2.new(1, -18, 0.5, -8),
								BackgroundColor3 = SelectedTheme.ToggleEnabled
							}, 0.2)
							if Indicator:FindFirstChild("UIStroke") then
								Tween(Indicator.UIStroke, {Color = SelectedTheme.ToggleEnabledOuterStroke}, 0.2)
							end
							if ToggleFrame:FindFirstChild("UIStroke") then
								Tween(ToggleFrame.UIStroke, {Color = SelectedTheme.ToggleEnabledStroke}, 0.2)
							end
						else
							Tween(Indicator, {
								Position = UDim2.new(0, 2, 0.5, -8),
								BackgroundColor3 = SelectedTheme.ToggleDisabled
							}, 0.2)
							if Indicator:FindFirstChild("UIStroke") then
								Tween(Indicator.UIStroke, {Color = SelectedTheme.ToggleDisabledOuterStroke}, 0.2)
							end
							if ToggleFrame:FindFirstChild("UIStroke") then
								Tween(ToggleFrame.UIStroke, {Color = SelectedTheme.ToggleDisabledStroke}, 0.2)
							end
						end
					end
				end
			end
			
			UpdateVisual()
			
			Toggle.Interact.MouseEnter:Connect(function()
				if not ToggleValue.Locked then
					Tween(Toggle, {BackgroundColor3 = SelectedTheme.ElementBackgroundHover}, 0.2)
					Tween(Toggle, {Size = UDim2.new(1, 3, 0, 40)}, 0.12)
				end
			end)
			
			Toggle.Interact.MouseLeave:Connect(function()
				if not ToggleValue.Locked then
					Tween(Toggle, {BackgroundColor3 = SelectedTheme.ElementBackground}, 0.2)
					Tween(Toggle, {Size = UDim2.new(1, 0, 0, 40)}, 0.12)
				end
			end)
			
			Toggle.Interact.MouseButton1Click:Connect(function()
				if ToggleValue.Locked then return end
				
				ToggleValue.CurrentValue = not ToggleValue.CurrentValue
				
				-- Bounce effect on toggle
				local toggleFrame = Toggle:FindFirstChild("ToggleFrame")
				if toggleFrame then
					local origSize = toggleFrame.Size
					Tween(toggleFrame, {Size = origSize * 1.1}, 0.1)
					task.wait(0.1)
					Tween(toggleFrame, {Size = origSize}, 0.1)
				end
				
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
					Tween(Toggle, {BackgroundColor3 = SelectedTheme.SecondaryElementBackground}, 0.3)
					Tween(Toggle.Title, {TextTransparency = 0.5}, 0.3)
				else
					Tween(Toggle, {BackgroundColor3 = SelectedTheme.ElementBackground}, 0.3)
					Tween(Toggle.Title, {TextTransparency = 0}, 0.3)
				end
			end
			
			function ToggleValue:Remove()
				Toggle:Destroy()
			end
			
			if ToggleSettings.Flag then
				MercuryLibrary.Flags[ToggleSettings.Flag] = ToggleValue
			end
			
			table.insert(Tab.Elements, ToggleValue)
			return ToggleValue
		end
		
		function Tab:CreateSlider(SliderSettings)
			local Slider = TabPage.Slider:Clone()
			Slider.Name = SliderSettings.Name
			Slider.Title.Text = SliderSettings.Name
			Slider.Visible = true
			Slider.Parent = TabPage
			
			Slider.BackgroundColor3 = SelectedTheme.ElementBackground
			Slider.Main.BackgroundColor3 = SelectedTheme.SliderBackground
			Slider.Main.Progress.BackgroundColor3 = SelectedTheme.SliderProgress
			
			SliderSettings.CurrentValue = SliderSettings.CurrentValue or SliderSettings.Range[1]
			SliderSettings.Range = SliderSettings.Range or {0, 100}
			SliderSettings.Increment = SliderSettings.Increment or 1
			SliderSettings.Type = "Slider"
			SliderSettings.Callback = SliderSettings.Callback or function() end
			
			local Dragging = false
			local SliderMain = Slider.Main
			local Progress = SliderMain.Progress
			local Info = SliderMain.Information
			
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
			
			SliderMain.Interact.InputBegan:Connect(function(input)
				if SliderValue.Locked then return end
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					Dragging = true
					Tween(Slider, {BackgroundColor3 = SelectedTheme.ElementBackgroundHover}, 0.2)
				end
			end)
			
			SliderMain.Interact.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					Dragging = false
					Tween(Slider, {BackgroundColor3 = SelectedTheme.ElementBackground}, 0.2)
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
					Tween(Slider, {BackgroundColor3 = SelectedTheme.SecondaryElementBackground}, 0.3)
					Tween(Slider.Title, {TextTransparency = 0.5}, 0.3)
				else
					Tween(Slider, {BackgroundColor3 = SelectedTheme.ElementBackground}, 0.3)
					Tween(Slider.Title, {TextTransparency = 0}, 0.3)
				end
			end
			
			function SliderValue:Remove()
				Slider:Destroy()
			end
			
			if SliderSettings.Flag then
				MercuryLibrary.Flags[SliderSettings.Flag] = SliderValue
			end
			
			table.insert(Tab.Elements, SliderValue)
			return SliderValue
		end
		
		function Tab:CreateDropdown(DropdownSettings)
			local Dropdown = TabPage.Dropdown:Clone()
			Dropdown.Name = DropdownSettings.Name
			Dropdown.Title.Text = DropdownSettings.Name
			Dropdown.Visible = true
			Dropdown.Parent = TabPage
			
			Dropdown.BackgroundColor3 = SelectedTheme.ElementBackground
			
			DropdownSettings.CurrentOption = DropdownSettings.CurrentOption or {}
			DropdownSettings.Options = DropdownSettings.Options or {}
			DropdownSettings.MultipleOptions = DropdownSettings.MultipleOptions or false
			DropdownSettings.Type = "Dropdown"
			DropdownSettings.Callback = DropdownSettings.Callback or function() end
			
			if type(DropdownSettings.CurrentOption) == "string" then
				DropdownSettings.CurrentOption = {DropdownSettings.CurrentOption}
			end
			
			local DropdownList = Dropdown.List
			local Selected = Dropdown.Selected
			local Arrow = Dropdown.Arrow
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
					if child:IsA("Frame") and child.Name ~= "Template" then
						child:Destroy()
					end
				end
				
				for _, option in ipairs(DropdownValue.Options) do
					local OptionFrame = DropdownList.Template:Clone()
					OptionFrame.Name = option
					OptionFrame.Title.Text = option
					OptionFrame.Visible = true
					OptionFrame.Parent = DropdownList
					
					if table.find(DropdownValue.CurrentOption, option) then
						OptionFrame.BackgroundColor3 = SelectedTheme.DropdownSelected
					else
						OptionFrame.BackgroundColor3 = SelectedTheme.DropdownUnselected
					end
					
					OptionFrame.Interact.MouseEnter:Connect(function()
						Tween(OptionFrame, {BackgroundColor3 = SelectedTheme.ElementBackgroundHover}, 0.2)
					end)
					
					OptionFrame.Interact.MouseLeave:Connect(function()
						if table.find(DropdownValue.CurrentOption, option) then
							Tween(OptionFrame, {BackgroundColor3 = SelectedTheme.DropdownSelected}, 0.2)
						else
							Tween(OptionFrame, {BackgroundColor3 = SelectedTheme.DropdownUnselected}, 0.2)
						end
					end)
					
					OptionFrame.Interact.MouseButton1Click:Connect(function()
						if DropdownValue.Locked then return end
						
						local mousePos = UserInputService:GetMouseLocation()
						local framePos = OptionFrame.AbsolutePosition
						RippleEffect(OptionFrame, mousePos.X - framePos.X, mousePos.Y - framePos.Y)
						
						if table.find(DropdownValue.CurrentOption, option) then
							table.remove(DropdownValue.CurrentOption, table.find(DropdownValue.CurrentOption, option))
							Tween(OptionFrame, {BackgroundColor3 = SelectedTheme.DropdownUnselected}, 0.2)
						else
							if not DropdownValue.MultipleOptions then
								table.clear(DropdownValue.CurrentOption)
								for _, optFrame in ipairs(DropdownList:GetChildren()) do
									if optFrame:IsA("Frame") and optFrame.Name ~= "Template" then
										Tween(optFrame, {BackgroundColor3 = SelectedTheme.DropdownUnselected}, 0.2)
									end
								end
							end
							table.insert(DropdownValue.CurrentOption, option)
							Tween(OptionFrame, {BackgroundColor3 = SelectedTheme.DropdownSelected}, 0.2)
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
							Tween(Arrow, {Rotation = 0}, 0.2)
						end
					end)
				end
			end
			
			CreateOptions()
			UpdateText()
			
			Dropdown.Interact.MouseEnter:Connect(function()
				if not DropdownValue.Locked then
					Tween(Dropdown, {BackgroundColor3 = SelectedTheme.ElementBackgroundHover}, 0.2)
				end
			end)
			
			Dropdown.Interact.MouseLeave:Connect(function()
				if not DropdownValue.Locked then
					Tween(Dropdown, {BackgroundColor3 = SelectedTheme.ElementBackground}, 0.2)
				end
			end)
			
			Dropdown.Interact.MouseButton1Click:Connect(function()
				if DropdownValue.Locked then return end
				
				IsOpen = not IsOpen
				DropdownList.Visible = IsOpen
				
				if IsOpen then
					Tween(Arrow, {Rotation = 180}, 0.2)
				else
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
					Tween(Dropdown, {BackgroundColor3 = SelectedTheme.SecondaryElementBackground}, 0.3)
					Tween(Dropdown.Title, {TextTransparency = 0.5}, 0.3)
				else
					Tween(Dropdown, {BackgroundColor3 = SelectedTheme.ElementBackground}, 0.3)
					Tween(Dropdown.Title, {TextTransparency = 0}, 0.3)
				end
			end
			
			function DropdownValue:Remove()
				Dropdown:Destroy()
			end
			
			if DropdownSettings.Flag then
				MercuryLibrary.Flags[DropdownSettings.Flag] = DropdownValue
			end
			
			table.insert(Tab.Elements, DropdownValue)
			return DropdownValue
		end
		
		function Tab:CreateInput(InputSettings)
			local Input = TabPage.Input:Clone()
			Input.Name = InputSettings.Name
			Input.Title.Text = InputSettings.Name
			Input.Visible = true
			Input.Parent = TabPage
			
			Input.BackgroundColor3 = SelectedTheme.ElementBackground
			Input.InputFrame.BackgroundColor3 = SelectedTheme.InputBackground
			
			InputSettings.CurrentValue = InputSettings.CurrentValue or ""
			InputSettings.Type = "Input"
			InputSettings.Placeholder = InputSettings.Placeholder or "Enter text..."
			InputSettings.Callback = InputSettings.Callback or function() end
			
			Input.InputFrame.InputBox.PlaceholderText = InputSettings.Placeholder
			Input.InputFrame.InputBox.Text = InputSettings.CurrentValue
			
			local InputValue = {
				Type = "Input",
				Element = Input,
				CurrentValue = InputSettings.CurrentValue,
				Callback = InputSettings.Callback,
				Locked = false
			}
			
			Input.InputFrame.InputBox.Focused:Connect(function()
				Tween(Input.InputFrame.UIStroke, {Color = SelectedTheme.AccentColor}, 0.2)
			end)
			
			Input.InputFrame.InputBox.FocusLost:Connect(function()
				Tween(Input.InputFrame.UIStroke, {Color = SelectedTheme.InputStroke}, 0.2)
				
				if not InputValue.Locked then
					InputValue.CurrentValue = Input.InputFrame.InputBox.Text
					local success, err = pcall(InputValue.Callback, InputValue.CurrentValue)
					if not success then
						ShowError(InputSettings.Name, err)
					end
					SaveConfiguration()
				end
			end)
			
			function InputValue:Set(Text)
				Input.InputFrame.InputBox.Text = Text
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
				Input.InputFrame.InputBox.PlaceholderText = NewPlaceholder
			end
			
			function InputValue:SetLocked(Locked)
				InputValue.Locked = Locked
				Input.InputFrame.InputBox.TextEditable = not Locked
				if Locked then
					Tween(Input, {BackgroundColor3 = SelectedTheme.SecondaryElementBackground}, 0.3)
					Tween(Input.Title, {TextTransparency = 0.5}, 0.3)
				else
					Tween(Input, {BackgroundColor3 = SelectedTheme.ElementBackground}, 0.3)
					Tween(Input.Title, {TextTransparency = 0}, 0.3)
				end
			end
			
			function InputValue:Remove()
				Input:Destroy()
			end
			
			if InputSettings.Flag then
				MercuryLibrary.Flags[InputSettings.Flag] = InputValue
			end
			
			table.insert(Tab.Elements, InputValue)
			return InputValue
		end
		
		function Tab:CreateKeybind(KeybindSettings)
			local Keybind = TabPage.Keybind:Clone()
			Keybind.Name = KeybindSettings.Name
			Keybind.Title.Text = KeybindSettings.Name
			Keybind.Visible = true
			Keybind.Parent = TabPage
			
			Keybind.BackgroundColor3 = SelectedTheme.ElementBackground
			Keybind.KeybindFrame.BackgroundColor3 = SelectedTheme.InputBackground
			
			KeybindSettings.CurrentKeybind = KeybindSettings.CurrentKeybind or "None"
			KeybindSettings.Type = "Keybind"
			KeybindSettings.Callback = KeybindSettings.Callback or function() end
			Keybind.KeybindFrame.KeybindBox.Text = KeybindSettings.CurrentKeybind
			
			local CheckingForKey = false
			
			local KeybindValue = {
				Type = "Keybind",
				Element = Keybind,
				CurrentKeybind = KeybindSettings.CurrentKeybind,
				Callback = KeybindSettings.Callback,
				Locked = false
			}
			
			Keybind.KeybindFrame.KeybindBox.Focused:Connect(function()
				CheckingForKey = true
				Keybind.KeybindFrame.KeybindBox.Text = "..."
				Tween(Keybind.KeybindFrame.UIStroke, {Color = SelectedTheme.AccentColor}, 0.2)
			end)
			
			Keybind.KeybindFrame.KeybindBox.FocusLost:Connect(function()
				CheckingForKey = false
				if Keybind.KeybindFrame.KeybindBox.Text == "..." then
					Keybind.KeybindFrame.KeybindBox.Text = KeybindValue.CurrentKeybind
				end
				Tween(Keybind.KeybindFrame.UIStroke, {Color = SelectedTheme.InputStroke}, 0.2)
			end)
			
			UserInputService.InputBegan:Connect(function(input, processed)
				if CheckingForKey and input.KeyCode ~= Enum.KeyCode.Unknown then
					local NewKey = input.KeyCode.Name
					Keybind.KeybindFrame.KeybindBox.Text = NewKey
					KeybindValue.CurrentKeybind = NewKey
					Keybind.KeybindFrame.KeybindBox:ReleaseFocus()
					SaveConfiguration()
				elseif not processed and not CheckingForKey and input.KeyCode.Name == KeybindValue.CurrentKeybind and KeybindValue.CurrentKeybind ~= "None" then
					local success, err = pcall(KeybindValue.Callback, KeybindValue.CurrentKeybind)
					if not success then
						ShowError(KeybindSettings.Name, err)
					end
				end
			end)
			
			function KeybindValue:Set(NewKeybind)
				Keybind.KeybindFrame.KeybindBox.Text = NewKeybind
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
					Tween(Keybind, {BackgroundColor3 = SelectedTheme.SecondaryElementBackground}, 0.3)
					Tween(Keybind.Title, {TextTransparency = 0.5}, 0.3)
				else
					Tween(Keybind, {BackgroundColor3 = SelectedTheme.ElementBackground}, 0.3)
					Tween(Keybind.Title, {TextTransparency = 0}, 0.3)
				end
			end
			
			function KeybindValue:Remove()
				Keybind:Destroy()
			end
			
			if KeybindSettings.Flag then
				MercuryLibrary.Flags[KeybindSettings.Flag] = KeybindValue
			end
			
			table.insert(Tab.Elements, KeybindValue)
			return KeybindValue
		end
		
		function Tab:CreateColorPicker(ColorPickerSettings)
			local ColorPicker = TabPage.ColorPicker:Clone()
			ColorPicker.Name = ColorPickerSettings.Name
			ColorPicker.Title.Text = ColorPickerSettings.Name
			ColorPicker.Visible = true
			ColorPicker.Parent = TabPage
			
			ColorPicker.BackgroundColor3 = SelectedTheme.ElementBackground
			
			ColorPickerSettings.Color = ColorPickerSettings.Color or Color3.fromRGB(255, 255, 255)
			ColorPickerSettings.Type = "ColorPicker"
			ColorPickerSettings.Callback = ColorPickerSettings.Callback or function() end
			
			local Display = ColorPicker.CPBackground.Display
			Display.BackgroundColor3 = ColorPickerSettings.Color
			
			local ColorPickerValue = {
				Type = "ColorPicker",
				Element = ColorPicker,
				Color = ColorPickerSettings.Color,
				Callback = ColorPickerSettings.Callback,
				Locked = false
			}
			
			ColorPicker.Interact.MouseEnter:Connect(function()
				if not ColorPickerValue.Locked then
					Tween(ColorPicker, {BackgroundColor3 = SelectedTheme.ElementBackgroundHover}, 0.2)
				end
			end)
			
			ColorPicker.Interact.MouseLeave:Connect(function()
				if not ColorPickerValue.Locked then
					Tween(ColorPicker, {BackgroundColor3 = SelectedTheme.ElementBackground}, 0.2)
				end
			end)
			
			ColorPicker.Interact.MouseButton1Click:Connect(function()
				if ColorPickerValue.Locked then return end
				
				local mousePos = UserInputService:GetMouseLocation()
				local pickerPos = ColorPicker.AbsolutePosition
				RippleEffect(ColorPicker, mousePos.X - pickerPos.X, mousePos.Y - pickerPos.Y)
				
				-- Cycle through preset colors as a demo
				local r, g, b = ColorPickerValue.Color.R, ColorPickerValue.Color.G, ColorPickerValue.Color.B
				local newColor = Color3.fromRGB(
					math.floor((r * 255 + 50) % 256),
					math.floor((g * 255 + 100) % 256),
					math.floor((b * 255 + 150) % 256)
				)
				ColorPickerValue:Set(newColor)
			end)
			
			function ColorPickerValue:Set(NewColor)
				ColorPickerValue.Color = NewColor
				Tween(Display, {BackgroundColor3 = NewColor}, 0.3)
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
					Tween(ColorPicker, {BackgroundColor3 = SelectedTheme.SecondaryElementBackground}, 0.3)
					Tween(ColorPicker.Title, {TextTransparency = 0.5}, 0.3)
				else
					Tween(ColorPicker, {BackgroundColor3 = SelectedTheme.ElementBackground}, 0.3)
					Tween(ColorPicker.Title, {TextTransparency = 0}, 0.3)
				end
			end
			
			function ColorPickerValue:Remove()
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
	
	-- Auto-load configuration
	task.delay(1, function()
		MercuryLibrary:LoadConfiguration()
	end)
	
	return Window
end

return MercuryLibrary
