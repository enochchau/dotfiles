StatMenu = hs.menubar.new()
CpuTitle = "init"
local statMenuInterval = 3
FontFamily = "Hack Nerd Font"
FontStyle = { name = FontFamily, size = 12 }
IconStyle = { name = FontFamily, size = 14 }

-- show cpu usage in menu bar
local function getCpuTitle(cpuUsage)
	local activeUsage = cpuUsage.overall.active
	local fmt = string.format("%.2f%% ", activeUsage)
	local styled = hs.styledtext.new(fmt, { font = FontStyle })
	local styledIcon = hs.styledtext.new("", { font = IconStyle })
	return styled .. styledIcon
end

local function refreshStats()
	local cpuUsage = hs.host.cpuUsage()
	CpuTitle = getCpuTitle(cpuUsage)
	StatMenu:setTitle(CpuTitle)
end

refreshStats()
StatMenuTimer = hs.timer.new(statMenuInterval, refreshStats)
StatMenuTimer:start()

-- Auto refresh Hammerspoon config on change
local function reloadConfig(files)
	local doReload = false
	for _, file in pairs(files) do
		if file:sub(-4) == ".lua" then
			doReload = true
		end
	end
	if doReload then
		hs.reload()
	end
end

ConfigWatcher = hs.pathwatcher.new(
	os.getenv("HOME") .. "/.hammerspoon/",
	reloadConfig
)
ConfigWatcher:start()
hs.alert.show("Hammerspoon Started")
