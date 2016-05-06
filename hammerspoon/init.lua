-----------------
-- DEFINITIONS -- 
-----------------
local application = require "hs.application"
local window = require "hs.window"
local hotkey = require "hs.hotkey"
local keycodes = require "hs.keycodes"
local fnutils = require "hs.fnutils"
local alert = require "hs.alert"
local screen = require "hs.screen"
local grid = require "hs.grid"
local hints = require "hs.hints"
local appfinder = require "hs.appfinder"
local applescript = require "hs.applescript"

window.animationDuration = 0.0

local modalKey = {"alt"}

-------------------------
-- BASIC FUNCTIONALITY --
-------------------------
local hotkeys = {}

function createHotkeys()
	for key, fun in pairs(definitions) do 
		local mod = modalKey

		local hk = hotkey.new(modalKey, string.sub(key,1,1), fun)
		table.insert(hotkeys, hk)
		hk:enable()
	end
end

-- Grid Setup
grid.GRIDWIDTH 	= 12
grid.GRIDHEIGHT = 8
grid.MARGINX = 6
grid.MARGINY = 6 
local gw = grid.GRIDWIDTH
local gh = grid.GRIDHEIGHT

local gridset = function(frame)
	return function()
		local win = window.focusedWindow()
		if win then
			grid.set(win, frame, win:screen())
		else
			alert.show("No focused window.")
		end
	end
end

function pushRight()
	local win = window.focusedWindow()
	local s = grid.get(win)
	if (s.x + s.w) == gw then 
		grid.resizeWindowThinner(win)
	end
	grid.pushWindowRight(win)
end

function pushLeft()
	local win = window.focusedWindow()
	local s = grid.get(win)
	if s.x == 0.0 then 
		grid.resizeWindowThinner(win)
	else 
		grid.pushWindowLeft(win)
	end
end
 
function pushUp()
	local win = window.focusedWindow()
	local s = grid.get(win)
	if s.y == 0.0 then 
	 grid.resizeWindowShorter(win)
	else 
	 grid.pushWindowUp(win)
	end
end

function pushDown()
	 local win = window.focusedWindow()
	 local s = grid.get(win)
	 if (s.y + s.h)  == gh then 
		 grid.resizeWindowShorter(win)
	 end
	 grid.pushWindowDown(win)
end

function maxHeight()
	local win = window.focusedWindow()
	local s = grid.get(win)
	s.y = 0.0
	s.h = gh
	grid.set(win, s, win:screen())
end

local goleft = {x = 0, y = 0, w = gw/2, h = gh}
local goright = {x = gw/2, y = 0, w = gw/2, h = gh}
local tile = 4
local bigright = {x = tile, y = 0, w = (gw-tile), h = gh}
local smallleft = {x = 0, y = 0, w = tile, h = gh}

-- Definitions
definitions = {

	l = pushRight,
	h = pushLeft,
	k = pushUp,
	j = pushDown,

	o = grid.resizeWindowTaller,
	i = grid.resizeWindowShorter,
	u = grid.resizeWindowThinner,
	p = grid.resizeWindowWider,

	["["] = gridset(goleft),
	["]"] = gridset(goright),
	["\\"] = gridset(bigright),
	["'"] = gridset(smallleft),

	m = maxHeight,

	-- g = function() hints.windowHints(nil, nil, true) end,
	g = function() hs.hints.windowHints(hs.window.focusedWindow():application():allWindows(), nil, true) end,

	["9"] = hs.reload

}

-----------------------
-- AUXILARY TUTORIAL --
-----------------------

-- Finder to top
function applicationWatcher(appName, eventType, appObject)
    if (eventType == hs.application.watcher.activated) then
        if (appName == "Finder") then
            -- Bring all Finder windows forward when one gets activated
            appObject:selectMenuItem({"Window", "Bring All to Front"})
        end
    end
end

-- Caffeine
local caffeine = hs.menubar.new()
function setCaffeineDisplay(state)
    if state then
        caffeine:setTitle("🌞")
    else
        caffeine:setTitle("🌚")
    end
end

function caffeineClicked()
    setCaffeineDisplay(hs.caffeinate.toggle("displayIdle"))
end

if caffeine then
    caffeine:setClickCallback(caffeineClicked)
    setCaffeineDisplay(hs.caffeinate.get("displayIdle"))
end

-- Cycle through safari fake browsers
function cycle_safari_agents()
    hs.application.launchOrFocus("Safari")
    local safari = hs.appfinder.appFromName("Safari")

    local str_default = {"Develop", "User Agent", "Default (Automatically Chosen)"}
    local str_ie10 = {"Develop", "User Agent", "Internet Explorer 10"}
    local str_chrome = {"Develop", "User Agent", "Google Chrome — Windows"}

    local default = safari:findMenuItem(str_default)
    local ie10 = safari:findMenuItem(str_ie10)
    local chrome = safari:findMenuItem(str_chrome)

    if (default and default["ticked"]) then
        safari:selectMenuItem(str_ie10)
        hs.alert.show("IE10")
    end
    if (ie10 and ie10["ticked"]) then
        safari:selectMenuItem(str_chrome)
        hs.alert.show("Chrome")
    end
    if (chrome and chrome["ticked"]) then
        safari:selectMenuItem(str_default)
        hs.alert.show("Safari")
    end
end
hs.hotkey.bind({"cmd", "alt", "ctrl"}, '7', cycle_safari_agents)

function reloadConfig()
    if configFileWatcher ~= nil then
        configFileWatcher:stop()
        configFileWatcher = nil
    end

    hs.reload()
end

function init()
	createHotkeys()

	configFileWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig)
	configFileWatcher:start()
	hs.application.watcher.new(applicationWatcher):start()

	-- hs.notify.new({title="Hammerspoon", informativeText="Config file reloaded"}):send()
	alert.show("Hammerspoon at your service!")
end

init()


-- local modalKey = {"alt"}

-- local resizeMappings = {
--   h={x=0, y=0, w=0.5, h=1},
--   j={x=0, y=0.5, w=1, h=0.5},
--   k={x=0, y=0, w=1, h=0.5},
--   l={x=0.5, y=0, w=0.5, h=1},
--   m={x=0, y=0, w=1, h=1},
--   u={x=0, y=0, w=0.33, h=1},
--   i={x=0.33, y=0, w=0.33, h=1},
--   o={x=0.66, y=0, w=0.33, h=1},
--   x={x=0.04, y=0.04, w=0.92, h=0.92}

-- }

-- for key in pairs(resizeMappings) do
--   hs.hotkey.bind(modalKey, key, function()
--     local win = hs.window.focusedWindow()
--     if win then win:moveToUnit(resizeMappings[key]) end
--   end)
-- end

-- hs.hotkey.bind(modalKey, "r", function()
--   hs.reload()
-- end)

-- local focusKeys = {
--   s='Safari',
--   c='Google Chrome',
--   -- b='Google Chrome Canary',
--   d='Slack',
--   f='iTerm',
--   n='Spotify',
--   e='Simulator',
--   t='Messages',
--   -- y='Screenhero',
--   -- a="Atom",
--   -- x="Xcode",
--   -- v="Visual Studio Code"
-- }

-- for key in pairs(focusKeys) do
--   hs.hotkey.bind(modalKey, key, function()
--     hs.application.launchOrFocus(focusKeys[key])
--   end)
-- end
