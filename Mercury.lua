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
	Windows = {},
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
		
		Tween(Notification, {Position = UDim2.new(1, -320, 1, -100 - (#NotificationHolder:GetChildren() - 1) * 90)}, 0.5, Enum.EasingStyle.Back)
		
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
		end)
		
		table.insert(MercuryLibrary.Notifications, Notification)
	end)
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
	
	-- Create ScreenGui
	local Mercury = Instance.new("ScreenGui")
	Mercury.Name = "Mercury"
	Mercury.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	Mercury.ResetOnSpawn = false
	Mercury.Enabled = true
	
	if gethui then
		Mercury.Parent = gethui()
	else
		Mercury.Parent = CoreGui
	end
	
	-- Main Window Frame
	local Main = Instance.new("Frame")
	Main.Name = "Main"
	Main.BackgroundColor3 = SelectedTheme.Background
	Main.BorderSizePixel = 0
	Main.Position = UDim2.new(0.5, -250, 0.5, -237)
	Main.Size = UDim2.new(0, 500, 0, 475)
	Main.ClipsDescendants = true
	Main.Parent = Mercury
	
	local MainCorner = Instance.new("UICorner")
	MainCorner.CornerRadius = UDim.new(0, 10)
	MainCorner.Parent = Main
	
	-- Topbar
	local Topbar = Instance.new("Frame")
	Topbar.Name = "Topbar"
	Topbar.BackgroundColor3 = SelectedTheme.Topbar
	Topbar.BorderSizePixel = 0
	Topbar.Size = UDim2.new(1, 0, 0, 45)
	Topbar.Parent = Main
	
	local TopbarCorner = Instance.new("UICorner")
	TopbarCorner.CornerRadius = UDim.new(0, 10)
	TopbarCorner.Parent = Topbar
	
	local TopbarFill = Instance.new("Frame")
	TopbarFill.BackgroundColor3 = SelectedTheme.Topbar
	TopbarFill.BorderSizePixel = 0
	TopbarFill.Position = UDim2.new(0, 0, 1, -10)
	TopbarFill.Size = UDim2.new(1, 0, 0, 10)
	TopbarFill.Parent = Topbar
	
	local Title = Instance.new("TextLabel")
	Title.Name = "Title"
	Title.BackgroundTransparency = 1
	Title.Position = UDim2.new(0, 15, 0, 0)
	Title.Size = UDim2.new(1, -30, 1, 0)
	Title.Font = Enum.Font.GothamBold
	Title.Text = Settings.Name or "Mercury"
	Title.TextColor3 = SelectedTheme.TextColor
	Title.TextSize = 16
	Title.TextXAlignment = Enum.TextXAlignment.Left
	Title.Parent = Topbar
	
	-- Tab List
	local TabList = Instance.new("ScrollingFrame")
	TabList.Name = "TabList"
	TabList.BackgroundTransparency = 1
	TabList.BorderSizePixel = 0
	TabList.Position = UDim2.new(0, 10, 0, 55)
	TabList.Size = UDim2.new(0, 130, 1, -65)
	TabList.ScrollBarThickness = 3
	TabList.ScrollBarImageColor3 = SelectedTheme.AccentColor
	TabList.Parent = Main
	
	local TabListLayout = Instance.new("UIListLayout")
	TabListLayout.Padding = UDim.new(0, 5)
	TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	TabListLayout.Parent = TabList
	
	-- Elements Container
	local Elements = Instance.new("Frame")
	Elements.Name = "Elements"
	Elements.BackgroundTransparency = 1
	Elements.Position = UDim2.new(0, 150, 0, 55)
	Elements.Size = UDim2.new(1, -160, 1, -65)
	Elements.ClipsDescendants = true
	Elements.Parent = Main
	
	local ElementsLayout = Instance.new("UIPageLayout")
	ElementsLayout.FillDirection = Enum.FillDirection.Vertical
	ElementsLayout.SortOrder = Enum.SortOrder.LayoutOrder
	ElementsLayout.EasingStyle = Enum.EasingStyle.Quart
	ElementsLayout.EasingDirection = Enum.EasingDirection.Out
	ElementsLayout.TweenTime = 0.3
	ElementsLayout.Parent = Elements
	
	-- Resize Handle
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
	
	-- Dragging & Resizing
	local Dragging = false
	local DragStart = nil
	local StartPos = nil
	local Resizing = false
	local ResizeStart = nil
	local StartSize = nil
	
	Topbar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			Dragging = true
			DragStart = input.Position
			StartPos = Main.Position
			
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
	
	-- Window Object
	local Window = {
		Tabs = {},
		CurrentTab = nil,
		Main = Main,
		Mercury = Mercury,
		Elements = Elements,
		TabList = TabList,
		ElementsLayout = ElementsLayout
	}
	
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
	
	function Window:Destroy()
		Mercury:Destroy()
	end
	
	function Window:SelectTab(TabName)
		for _, tab in pairs(Window.Tabs) do
			if tab.Name == TabName then
				ElementsLayout:JumpTo(tab.Page)
				Window.CurrentTab = tab
				
				for _, btn in ipairs(TabList:GetChildren()) do
					if btn:IsA("Frame") then
						if btn.Name == TabName then
							Tween(btn, {BackgroundColor3 = SelectedTheme.TabBackgroundSelected}, 0.2)
							Tween(btn:FindFirstChild("Title"), {TextColor3 = SelectedTheme.SelectedTabTextColor}, 0.2)
						else
							Tween(btn, {BackgroundColor3 = SelectedTheme.TabBackground}, 0.2)
							Tween(btn:FindFirstChild("Title"), {TextColor3 = SelectedTheme.TabTextColor}, 0.2)
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
	
	function Window:CreateTab(Name)
		local Tab = {
			Name = Name,
			Elements = {},
			Window = Window
		}
		
		-- Tab Button
		local TabButton = Instance.new("Frame")
		TabButton.Name = Name
		TabButton.BackgroundColor3 = SelectedTheme.TabBackground
		TabButton.BorderSizePixel = 0
		TabButton.Size = UDim2.new(1, 0, 0, 35)
		TabButton.Parent = TabList
		
		local TabCorner = Instance.new("UICorner")
		TabCorner.CornerRadius = UDim.new(0, 6)
		TabCorner.Parent = TabButton
		
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
		
		-- Tab Page
		local TabPage = Instance.new("ScrollingFrame")
		TabPage.Name = Name
		TabPage.BackgroundTransparency = 1
		TabPage.BorderSizePixel = 0
		TabPage.Size = UDim2.new(1, 0, 1, 0)
		TabPage.ScrollBarThickness = 3
		TabPage.ScrollBarImageColor3 = SelectedTheme.AccentColor
		TabPage.Parent = Elements
		
		local PageLayout = Instance.new("UIListLayout")
		PageLayout.Padding = UDim.new(0, 8)
		PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
		PageLayout.Parent = TabPage
		
		local PagePadding = Instance.new("UIPadding")
		PagePadding.PaddingTop = UDim.new(0, 5)
		PagePadding.PaddingBottom = UDim.new(0, 5)
		PagePadding.PaddingLeft = UDim.new(0, 5)
		PagePadding.PaddingRight = UDim.new(0, 5)
		PagePadding.Parent = TabPage
		
		Tab.Button = TabButton
		Tab.Page = TabPage
		
		table.insert(Window.Tabs, Tab)
		
		TabInteract.MouseButton1Click:Connect(function()
			Window:SelectTab(Name)
		end)
		
		TabInteract.MouseEnter:Connect(function()
			if Window.CurrentTab ~= Tab then
				Tween(TabButton, {BackgroundColor3 = SelectedTheme.ElementBackgroundHover}, 0.2)
			end
		end)
		
		TabInteract.MouseLeave:Connect(function()
			if Window.CurrentTab ~= Tab then
				Tween(TabButton, {BackgroundColor3 = SelectedTheme.TabBackground}, 0.2)
			end
		end)
		
		if #Window.Tabs == 1 then
			Window:SelectTab(Name)
		end
		
		-- CREATE ELEMENTS
		
		function Tab:CreateLabel(Text)
			local Label = Instance.new("Frame")
			Label.Name = "Label"
			Label.BackgroundColor3 = SelectedTheme.ElementBackground
			Label.BorderSizePixel = 0
			Label.Size = UDim2.new(1, 0, 0, 35)
			Label.Parent = TabPage
			
			local LabelCorner = Instance.new("UICorner")
			LabelCorner.CornerRadius = UDim.new(0, 6)
			LabelCorner.Parent = Label
			
			local LabelTitle = Instance.new("TextLabel")
			LabelTitle.Name = "Title"
			LabelTitle.BackgroundTransparency = 1
			LabelTitle.Size = UDim2.new(1, -20, 1, 0)
			LabelTitle.Position = UDim2.new(0, 10, 0, 0)
			LabelTitle.Font = Enum.Font.Gotham
			LabelTitle.Text = Text
			LabelTitle.TextColor3 = SelectedTheme.TextColor
			LabelTitle.TextSize = 13
			LabelTitle.TextXAlignment = Enum.TextXAlignment.Left
			LabelTitle.Parent = Label
			
			local LabelValue = {
				Type = "Label",
				Element = Label
			}
			
			function LabelValue:Set(NewText)
				LabelTitle.Text = NewText
			end
			
			function LabelValue:Remove()
				Label:Destroy()
			end
			
			table.insert(Tab.Elements, LabelValue)
			return LabelValue
		end
		
		function Tab:CreateButton(ButtonSettings)
			local Button = Instance.new("Frame")
			Button.Name = "Button"
			Button.BackgroundColor3 = SelectedTheme.ElementBackground
			Button.BorderSizePixel = 0
			Button.Size = UDim2.new(1, 0, 0, 35)
			Button.Parent = TabPage
			
			local ButtonCorner = Instance.new("UICorner")
			ButtonCorner.CornerRadius = UDim.new(0, 6)
			ButtonCorner.Parent = Button
			
			local ButtonTitle = Instance.new("TextLabel")
			ButtonTitle.Name = "Title"
			ButtonTitle.BackgroundTransparency = 1
			ButtonTitle.Size = UDim2.new(1, -20, 1, 0)
			ButtonTitle.Position = UDim2.new(0, 10, 0, 0)
			ButtonTitle.Font = Enum.Font.GothamSemibold
			ButtonTitle.Text = ButtonSettings.Name
			ButtonTitle.TextColor3 = SelectedTheme.TextColor
			ButtonTitle.TextSize = 13
			ButtonTitle.TextXAlignment = Enum.TextXAlignment.Left
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
				Callback = ButtonSettings.Callback or function() end
			}
			
			ButtonInteract.MouseEnter:Connect(function()
				Tween(Button, {BackgroundColor3 = SelectedTheme.ElementBackgroundHover}, 0.2)
			end)
			
			ButtonInteract.MouseLeave:Connect(function()
				Tween(Button, {BackgroundColor3 = SelectedTheme.ElementBackground}, 0.2)
			end)
			
			ButtonInteract.MouseButton1Click:Connect(function()
				local mousePos = UserInputService:GetMouseLocation()
				local buttonPos = Button.AbsolutePosition
				RippleEffect(Button, mousePos.X - buttonPos.X, mousePos.Y - buttonPos.Y)
				
				local success, err = pcall(ButtonValue.Callback)
				if not success then
					ShowError(ButtonSettings.Name, err)
				end
			end)
			
			function ButtonValue:Set(NewName)
				ButtonTitle.Text = NewName
			end
			
			function ButtonValue:Remove()
				Button:Destroy()
			end
			
			table.insert(Tab.Elements, ButtonValue)
			return ButtonValue
		end
		
		function Tab:CreateToggle(ToggleSettings)
			local Toggle = Instance.new("Frame")
			Toggle.Name = "Toggle"
			Toggle.BackgroundColor3 = SelectedTheme.ElementBackground
			Toggle.BorderSizePixel = 0
			Toggle.Size = UDim2.new(1, 0, 0, 40)
			Toggle.Parent = TabPage
			
			local ToggleCorner = Instance.new("UICorner")
			ToggleCorner.CornerRadius = UDim.new(0, 6)
			ToggleCorner.Parent = Toggle
			
			local ToggleTitle = Instance.new("TextLabel")
			ToggleTitle.Name = "Title"
			ToggleTitle.BackgroundTransparency = 1
			ToggleTitle.Size = UDim2.new(1, -70, 1, 0)
			ToggleTitle.Position = UDim2.new(0, 10, 0, 0)
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
			
			local ToggleStroke = Instance.new("UIStroke")
			ToggleStroke.Color = SelectedTheme.ToggleDisabledStroke
			ToggleStroke.Thickness = 1.5
			ToggleStroke.Parent = ToggleFrame
			
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
			
			local ToggleValue = {
				Type = "Toggle",
				Element = Toggle,
				CurrentValue = ToggleSettings.CurrentValue,
				Callback = ToggleSettings.Callback or function() end
			}
			
			local function UpdateVisual()
				if ToggleValue.CurrentValue then
					Tween(Indicator, {
						Position = UDim2.new(1, -18, 0.5, -8),
						BackgroundColor3 = SelectedTheme.ToggleEnabled
					}, 0.2)
					Tween(IndicatorStroke, {Color = SelectedTheme.ToggleEnabledOuterStroke}, 0.2)
					Tween(ToggleStroke, {Color = SelectedTheme.ToggleEnabledStroke}, 0.2)
				else
					Tween(Indicator, {
						Position = UDim2.new(0, 2, 0.5, -8),
						BackgroundColor3 = SelectedTheme.ToggleDisabled
					}, 0.2)
					Tween(IndicatorStroke, {Color = SelectedTheme.ToggleDisabledOuterStroke}, 0.2)
					Tween(ToggleStroke, {Color = SelectedTheme.ToggleDisabledStroke}, 0.2)
				end
			end
			
			UpdateVisual()
			
			ToggleInteract.MouseEnter:Connect(function()
				Tween(Toggle, {BackgroundColor3 = SelectedTheme.ElementBackgroundHover}, 0.2)
			end)
			
			ToggleInteract.MouseLeave:Connect(function()
				Tween(Toggle, {BackgroundColor3 = SelectedTheme.ElementBackground}, 0.2)
			end)
			
			ToggleInteract.MouseButton1Click:Connect(function()
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
			local Slider = Instance.new("Frame")
			Slider.Name = "Slider"
			Slider.BackgroundColor3 = SelectedTheme.ElementBackground
			Slider.BorderSizePixel = 0
			Slider.Size = UDim2.new(1, 0, 0, 50)
			Slider.Parent = TabPage
			
			local SliderCorner = Instance.new("UICorner")
			SliderCorner.CornerRadius = UDim.new(0, 6)
			SliderCorner.Parent = Slider
			
			local SliderTitle = Instance.new("TextLabel")
			SliderTitle.Name = "Title"
			SliderTitle.BackgroundTransparency = 1
			SliderTitle.Size = UDim2.new(1, -20, 0, 20)
			SliderTitle.Position = UDim2.new(0, 10, 0, 5)
			SliderTitle.Font = Enum.Font.GothamSemibold
			SliderTitle.Text = SliderSettings.Name
			SliderTitle.TextColor3 = SelectedTheme.TextColor
			SliderTitle.TextSize = 13
			SliderTitle.TextXAlignment = Enum.TextXAlignment.Left
			SliderTitle.Parent = Slider
			
			local SliderMain = Instance.new("Frame")
			SliderMain.Name = "Main"
			SliderMain.BackgroundColor3 = SelectedTheme.SliderBackground
			SliderMain.BorderSizePixel = 0
			SliderMain.Position = UDim2.new(0, 10, 0, 28)
			SliderMain.Size = UDim2.new(1, -20, 0, 12)
			SliderMain.Parent = Slider
			
			local SliderMainCorner = Instance.new("UICorner")
			SliderMainCorner.CornerRadius = UDim.new(1, 0)
			SliderMainCorner.Parent = SliderMain
			
			local Progress = Instance.new("Frame")
			Progress.Name = "Progress"
			Progress.BackgroundColor3 = SelectedTheme.SliderProgress
			Progress.BorderSizePixel = 0
			Progress.Size = UDim2.new(0, 0, 1, 0)
			Progress.Parent = SliderMain
			
			local ProgressCorner = Instance.new("UICorner")
			ProgressCorner.CornerRadius = UDim.new(1, 0)
			ProgressCorner.Parent = Progress
			
			local Info = Instance.new("TextLabel")
			Info.Name = "Information"
			Info.BackgroundTransparency = 1
			Info.Position = UDim2.new(1, -50, 0, 5)
			Info.Size = UDim2.new(0, 40, 0, 20)
			Info.Font = Enum.Font.GothamBold
			Info.Text = "50"
			Info.TextColor3 = SelectedTheme.TextColor
			Info.TextSize = 11
			Info.TextXAlignment = Enum.TextXAlignment.Right
			Info.Parent = Slider
			
			local SliderInteract = Instance.new("TextButton")
			SliderInteract.Name = "Interact"
			SliderInteract.BackgroundTransparency = 1
			SliderInteract.Size = UDim2.new(1, 0, 1, 0)
			SliderInteract.Text = ""
			SliderInteract.Parent = SliderMain
			
			SliderSettings.CurrentValue = SliderSettings.CurrentValue or SliderSettings.Range[1]
			SliderSettings.Range = SliderSettings.Range or {0, 100}
			SliderSettings.Increment = SliderSettings.Increment or 1
			
			local Dragging = false
			
			local SliderValue = {
				Type = "Slider",
				Element = Slider,
				CurrentValue = SliderSettings.CurrentValue,
				Range = SliderSettings.Range,
				Increment = SliderSettings.Increment,
				Callback = SliderSettings.Callback or function() end
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
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					Dragging = true
					Tween(Slider, {BackgroundColor3 = SelectedTheme.ElementBackgroundHover}, 0.2)
				end
			end)
			
			SliderInteract.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					Dragging = false
					Tween(Slider, {BackgroundColor3 = SelectedTheme.ElementBackground}, 0.2)
				end
			end)
			
			UserInputService.InputChanged:Connect(function(input)
				if Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
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
			local Dropdown = Instance.new("Frame")
			Dropdown.Name = "Dropdown"
			Dropdown.BackgroundColor3 = SelectedTheme.ElementBackground
			Dropdown.BorderSizePixel = 0
			Dropdown.Size = UDim2.new(1, 0, 0, 40)
			Dropdown.Parent = TabPage
			Dropdown.ClipsDescendants = false
			Dropdown.ZIndex = 10
			
			local DropdownCorner = Instance.new("UICorner")
			DropdownCorner.CornerRadius = UDim.new(0, 6)
			DropdownCorner.Parent = Dropdown
			
			local DropdownTitle = Instance.new("TextLabel")
			DropdownTitle.Name = "Title"
			DropdownTitle.BackgroundTransparency = 1
			DropdownTitle.Size = UDim2.new(1, -20, 0, 20)
			DropdownTitle.Position = UDim2.new(0, 10, 0, 3)
			DropdownTitle.Font = Enum.Font.GothamSemibold
			DropdownTitle.Text = DropdownSettings.Name
			DropdownTitle.TextColor3 = SelectedTheme.TextColor
			DropdownTitle.TextSize = 12
			DropdownTitle.TextXAlignment = Enum.TextXAlignment.Left
			DropdownTitle.Parent = Dropdown
			
			local Selected = Instance.new("TextLabel")
			Selected.Name = "Selected"
			Selected.BackgroundTransparency = 1
			Selected.Position = UDim2.new(0, 10, 0, 20)
			Selected.Size = UDim2.new(1, -40, 0, 17)
			Selected.Font = Enum.Font.Gotham
			Selected.Text = "None"
			Selected.TextColor3 = SelectedTheme.PlaceholderColor
			Selected.TextSize = 11
			Selected.TextXAlignment = Enum.TextXAlignment.Left
			Selected.Parent = Dropdown
			
			local Arrow = Instance.new("TextLabel")
			Arrow.Name = "Arrow"
			Arrow.BackgroundTransparency = 1
			Arrow.Position = UDim2.new(1, -25, 0.5, -8)
			Arrow.Size = UDim2.new(0, 16, 0, 16)
			Arrow.Font = Enum.Font.GothamBold
			Arrow.Text = "▼"
			Arrow.TextColor3 = SelectedTheme.TextColor
			Arrow.TextSize = 10
			Arrow.Parent = Dropdown
			
			local DropdownList = Instance.new("Frame")
			DropdownList.Name = "List"
			DropdownList.BackgroundColor3 = SelectedTheme.SecondaryElementBackground
			DropdownList.BorderSizePixel = 0
			DropdownList.Position = UDim2.new(0, 0, 1, 5)
			DropdownList.Size = UDim2.new(1, 0, 0, 0)
			DropdownList.Visible = false
			DropdownList.ZIndex = 20
			DropdownList.Parent = Dropdown
			
			local ListCorner = Instance.new("UICorner")
			ListCorner.CornerRadius = UDim.new(0, 6)
			ListCorner.Parent = DropdownList
			
			local ListLayout = Instance.new("UIListLayout")
			ListLayout.Padding = UDim.new(0, 2)
			ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
			ListLayout.Parent = DropdownList
			
			local ListPadding = Instance.new("UIPadding")
			ListPadding.PaddingTop = UDim.new(0, 5)
			ListPadding.PaddingBottom = UDim.new(0, 5)
			ListPadding.PaddingLeft = UDim.new(0, 5)
			ListPadding.PaddingRight = UDim.new(0, 5)
			ListPadding.Parent = DropdownList
			
			local DropdownInteract = Instance.new("TextButton")
			DropdownInteract.Name = "Interact"
			DropdownInteract.BackgroundTransparency = 1
			DropdownInteract.Size = UDim2.new(1, 0, 1, 0)
			DropdownInteract.Text = ""
			DropdownInteract.ZIndex = 15
			DropdownInteract.Parent = Dropdown
			
			DropdownSettings.CurrentOption = DropdownSettings.CurrentOption or {}
			DropdownSettings.Options = DropdownSettings.Options or {}
			DropdownSettings.MultipleOptions = DropdownSettings.MultipleOptions or false
			
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
				Callback = DropdownSettings.Callback or function() end
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
					OptionFrame.BackgroundColor3 = table.find(DropdownValue.CurrentOption, option) and SelectedTheme.DropdownSelected or SelectedTheme.DropdownUnselected
					OptionFrame.BorderSizePixel = 0
					OptionFrame.Size = UDim2.new(1, 0, 0, 25)
					OptionFrame.ZIndex = 25
					OptionFrame.Parent = DropdownList
					
					local OptionCorner = Instance.new("UICorner")
					OptionCorner.CornerRadius = UDim.new(0, 4)
					OptionCorner.Parent = OptionFrame
					
					local OptionTitle = Instance.new("TextLabel")
					OptionTitle.Name = "Title"
					OptionTitle.BackgroundTransparency = 1
					OptionTitle.Size = UDim2.new(1, -10, 1, 0)
					OptionTitle.Position = UDim2.new(0, 5, 0, 0)
					OptionTitle.Font = Enum.Font.Gotham
					OptionTitle.Text = option
					OptionTitle.TextColor3 = SelectedTheme.TextColor
					OptionTitle.TextSize = 11
					OptionTitle.TextXAlignment = Enum.TextXAlignment.Left
					OptionTitle.ZIndex = 26
					OptionTitle.Parent = OptionFrame
					
					local OptionInteract = Instance.new("TextButton")
					OptionInteract.Name = "Interact"
					OptionInteract.BackgroundTransparency = 1
					OptionInteract.Size = UDim2.new(1, 0, 1, 0)
					OptionInteract.Text = ""
					OptionInteract.ZIndex = 27
					OptionInteract.Parent = OptionFrame
					
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
						if table.find(DropdownValue.CurrentOption, option) then
							table.remove(DropdownValue.CurrentOption, table.find(DropdownValue.CurrentOption, option))
							Tween(OptionFrame, {BackgroundColor3 = SelectedTheme.DropdownUnselected}, 0.2)
						else
							if not DropdownValue.MultipleOptions then
								table.clear(DropdownValue.CurrentOption)
								for _, optFrame in ipairs(DropdownList:GetChildren()) do
									if optFrame:IsA("Frame") then
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
							Tween(DropdownList, {Size = UDim2.new(1, 0, 0, 0)}, 0.2)
						end
					end)
				end
				
				ListLayout:ApplyLayout()
				task.wait()
				local contentSize = ListLayout.AbsoluteContentSize.Y + 10
				DropdownList.Size = UDim2.new(1, 0, 0, contentSize)
			end
			
			CreateOptions()
			UpdateText()
			
			DropdownInteract.MouseEnter:Connect(function()
				Tween(Dropdown, {BackgroundColor3 = SelectedTheme.ElementBackgroundHover}, 0.2)
			end)
			
			DropdownInteract.MouseLeave:Connect(function()
				Tween(Dropdown, {BackgroundColor3 = SelectedTheme.ElementBackground}, 0.2)
			end)
			
			DropdownInteract.MouseButton1Click:Connect(function()
				IsOpen = not IsOpen
				DropdownList.Visible = IsOpen
				
				if IsOpen then
					Tween(Arrow, {Rotation = 180}, 0.2)
					CreateOptions()
				else
					Tween(Arrow, {Rotation = 0}, 0.2)
					Tween(DropdownList, {Size = UDim2.new(1, 0, 0, 0)}, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, function()
						DropdownList.Visible = false
					end)
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
			
			function DropdownValue:Refresh(NewOptions)
				DropdownValue.Options = NewOptions
				CreateOptions()
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
			local Input = Instance.new("Frame")
			Input.Name = "Input"
			Input.BackgroundColor3 = SelectedTheme.ElementBackground
			Input.BorderSizePixel = 0
			Input.Size = UDim2.new(1, 0, 0, 55)
			Input.Parent = TabPage
			
			local InputCorner = Instance.new("UICorner")
			InputCorner.CornerRadius = UDim.new(0, 6)
			InputCorner.Parent = Input
			
			local InputTitle = Instance.new("TextLabel")
			InputTitle.Name = "Title"
			InputTitle.BackgroundTransparency = 1
			InputTitle.Size = UDim2.new(1, -20, 0, 20)
			InputTitle.Position = UDim2.new(0, 10, 0, 5)
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
			InputFrame.Position = UDim2.new(0, 10, 0, 28)
			InputFrame.Size = UDim2.new(1, -20, 0, 22)
			InputFrame.Parent = Input
			
			local InputFrameCorner = Instance.new("UICorner")
			InputFrameCorner.CornerRadius = UDim.new(0, 4)
			InputFrameCorner.Parent = InputFrame
			
			local InputStroke = Instance.new("UIStroke")
			InputStroke.Color = SelectedTheme.InputStroke
			InputStroke.Thickness = 1
			InputStroke.Parent = InputFrame
			
			local InputBox = Instance.new("TextBox")
			InputBox.Name = "InputBox"
			InputBox.BackgroundTransparency = 1
			InputBox.Size = UDim2.new(1, -10, 1, 0)
			InputBox.Position = UDim2.new(0, 5, 0, 0)
			InputBox.Font = Enum.Font.Gotham
			InputBox.PlaceholderText = InputSettings.Placeholder or "Enter text..."
			InputBox.PlaceholderColor3 = SelectedTheme.PlaceholderColor
			InputBox.Text = InputSettings.CurrentValue or ""
			InputBox.TextColor3 = SelectedTheme.TextColor
			InputBox.TextSize = 11
			InputBox.TextXAlignment = Enum.TextXAlignment.Left
			InputBox.ClearTextOnFocus = false
			InputBox.Parent = InputFrame
			
			InputSettings.CurrentValue = InputSettings.CurrentValue or ""
			
			local InputValue = {
				Type = "Input",
				Element = Input,
				CurrentValue = InputSettings.CurrentValue,
				Callback = InputSettings.Callback or function() end
			}
			
			InputBox.Focused:Connect(function()
				Tween(InputStroke, {Color = SelectedTheme.AccentColor}, 0.2)
			end)
			
			InputBox.FocusLost:Connect(function()
				Tween(InputStroke, {Color = SelectedTheme.InputStroke}, 0.2)
				InputValue.CurrentValue = InputBox.Text
				local success, err = pcall(InputValue.Callback, InputValue.CurrentValue)
				if not success then
					ShowError(InputSettings.Name, err)
				end
				SaveConfiguration()
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
			local Keybind = Instance.new("Frame")
			Keybind.Name = "Keybind"
			Keybind.BackgroundColor3 = SelectedTheme.ElementBackground
			Keybind.BorderSizePixel = 0
			Keybind.Size = UDim2.new(1, 0, 0, 40)
			Keybind.Parent = TabPage
			
			local KeybindCorner = Instance.new("UICorner")
			KeybindCorner.CornerRadius = UDim.new(0, 6)
			KeybindCorner.Parent = Keybind
			
			local KeybindTitle = Instance.new("TextLabel")
			KeybindTitle.Name = "Title"
			KeybindTitle.BackgroundTransparency = 1
			KeybindTitle.Size = UDim2.new(1, -90, 1, 0)
			KeybindTitle.Position = UDim2.new(0, 10, 0, 0)
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
			KeybindFrame.Position = UDim2.new(1, -80, 0.5, -11)
			KeybindFrame.Size = UDim2.new(0, 70, 0, 22)
			KeybindFrame.Parent = Keybind
			
			local KeybindFrameCorner = Instance.new("UICorner")
			KeybindFrameCorner.CornerRadius = UDim.new(0, 4)
			KeybindFrameCorner.Parent = KeybindFrame
			
			local KeybindStroke = Instance.new("UIStroke")
			KeybindStroke.Color = SelectedTheme.InputStroke
			KeybindStroke.Thickness = 1
			KeybindStroke.Parent = KeybindFrame
			
			local KeybindBox = Instance.new("TextButton")
			KeybindBox.Name = "KeybindBox"
			KeybindBox.BackgroundTransparency = 1
			KeybindBox.Size = UDim2.new(1, 0, 1, 0)
			KeybindBox.Font = Enum.Font.GothamBold
			KeybindBox.Text = KeybindSettings.CurrentKeybind or "None"
			KeybindBox.TextColor3 = SelectedTheme.TextColor
			KeybindBox.TextSize = 11
			KeybindBox.Parent = KeybindFrame
			
			KeybindSettings.CurrentKeybind = KeybindSettings.CurrentKeybind or "None"
			
			local CheckingForKey = false
			
			local KeybindValue = {
				Type = "Keybind",
				Element = Keybind,
				CurrentKeybind = KeybindSettings.CurrentKeybind,
				Callback = KeybindSettings.Callback or function() end
			}
			
			KeybindBox.MouseButton1Click:Connect(function()
				CheckingForKey = true
				KeybindBox.Text = "..."
				Tween(KeybindStroke, {Color = SelectedTheme.AccentColor}, 0.2)
			end)
			
			UserInputService.InputBegan:Connect(function(input, processed)
				if CheckingForKey and input.KeyCode ~= Enum.KeyCode.Unknown then
					local NewKey = input.KeyCode.Name
					KeybindBox.Text = NewKey
					KeybindValue.CurrentKeybind = NewKey
					CheckingForKey = false
					Tween(KeybindStroke, {Color = SelectedTheme.InputStroke}, 0.2)
					SaveConfiguration()
				elseif not processed and not CheckingForKey and input.KeyCode.Name == KeybindValue.CurrentKeybind and KeybindValue.CurrentKeybind ~= "None" then
					local success, err = pcall(KeybindValue.Callback, KeybindValue.CurrentKeybind)
					if not success then
						ShowError(KeybindSettings.Name, err)
					end
				end
			end)
			
			function KeybindValue:Set(NewKeybind)
				KeybindBox.Text = NewKeybind
				KeybindValue.CurrentKeybind = NewKeybind
				SaveConfiguration()
			end
			
			function KeybindValue:Get()
				return KeybindValue.CurrentKeybind
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
			local ColorPicker = Instance.new("Frame")
			ColorPicker.Name = "ColorPicker"
			ColorPicker.BackgroundColor3 = SelectedTheme.ElementBackground
			ColorPicker.BorderSizePixel = 0
			ColorPicker.Size = UDim2.new(1, 0, 0, 40)
			ColorPicker.Parent = TabPage
			
			local ColorPickerCorner = Instance.new("UICorner")
			ColorPickerCorner.CornerRadius = UDim.new(0, 6)
			ColorPickerCorner.Parent = ColorPicker
			
			local ColorPickerTitle = Instance.new("TextLabel")
			ColorPickerTitle.Name = "Title"
			ColorPickerTitle.BackgroundTransparency = 1
			ColorPickerTitle.Size = UDim2.new(1, -60, 1, 0)
			ColorPickerTitle.Position = UDim2.new(0, 10, 0, 0)
			ColorPickerTitle.Font = Enum.Font.GothamSemibold
			ColorPickerTitle.Text = ColorPickerSettings.Name
			ColorPickerTitle.TextColor3 = SelectedTheme.TextColor
			ColorPickerTitle.TextSize = 13
			ColorPickerTitle.TextXAlignment = Enum.TextXAlignment.Left
			ColorPickerTitle.Parent = ColorPicker
			
			local CPBackground = Instance.new("Frame")
			CPBackground.Name = "CPBackground"
			CPBackground.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
			CPBackground.BorderSizePixel = 0
			CPBackground.Position = UDim2.new(1, -40, 0.5, -12)
			CPBackground.Size = UDim2.new(0, 30, 0, 24)
			CPBackground.Parent = ColorPicker
			
			local CPBackgroundCorner = Instance.new("UICorner")
			CPBackgroundCorner.CornerRadius = UDim.new(0, 4)
			CPBackgroundCorner.Parent = CPBackground
			
			local CPStroke = Instance.new("UIStroke")
			CPStroke.Color = SelectedTheme.ElementStroke
			CPStroke.Thickness = 1
			CPStroke.Parent = CPBackground
			
			local Display = Instance.new("Frame")
			Display.Name = "Display"
			Display.BackgroundColor3 = ColorPickerSettings.Color or Color3.fromRGB(255, 255, 255)
			Display.BorderSizePixel = 0
			Display.Position = UDim2.new(0, 3, 0, 3)
			Display.Size = UDim2.new(1, -6, 1, -6)
			Display.Parent = CPBackground
			
			local DisplayCorner = Instance.new("UICorner")
			DisplayCorner.CornerRadius = UDim.new(0, 3)
			DisplayCorner.Parent = Display
			
			local ColorPickerInteract = Instance.new("TextButton")
			ColorPickerInteract.Name = "Interact"
			ColorPickerInteract.BackgroundTransparency = 1
			ColorPickerInteract.Size = UDim2.new(1, 0, 1, 0)
			ColorPickerInteract.Text = ""
			ColorPickerInteract.Parent = ColorPicker
			
			ColorPickerSettings.Color = ColorPickerSettings.Color or Color3.fromRGB(255, 255, 255)
			
			local ColorPickerValue = {
				Type = "ColorPicker",
				Element = ColorPicker,
				Color = ColorPickerSettings.Color,
				Callback = ColorPickerSettings.Callback or function() end
			}
			
			ColorPickerInteract.MouseEnter:Connect(function()
				Tween(ColorPicker, {BackgroundColor3 = SelectedTheme.ElementBackgroundHover}, 0.2)
			end)
			
			ColorPickerInteract.MouseLeave:Connect(function()
				Tween(ColorPicker, {BackgroundColor3 = SelectedTheme.ElementBackground}, 0.2)
			end)
			
			ColorPickerInteract.MouseButton1Click:Connect(function()
				local mousePos = UserInputService:GetMouseLocation()
				local pickerPos = ColorPicker.AbsolutePosition
				RippleEffect(ColorPicker, mousePos.X - pickerPos.X, mousePos.Y - pickerPos.Y)
				
				-- Simple color cycling demo (you can implement a full color picker here)
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
			
			function ColorPickerValue:Remove()
				ColorPicker:Destroy()
			end
			
			if ColorPickerSettings.Flag then
				MercuryLibrary.Flags[ColorPickerSettings.Flag] = ColorPickerValue
			end
			
			table.insert(Tab.Elements, ColorPickerValue)
			return ColorPickerValue
		end
		
		return Tab
	end
	
	-- Auto-load configuration
	task.delay(1, function()
		MercuryLibrary:LoadConfiguration()
	end)
	
	table.insert(MercuryLibrary.Windows, Window)
	return Window
end

return MercuryLibrary
