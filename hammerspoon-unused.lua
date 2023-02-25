hs.loadSpoon("ShiftIt")
spoon.ShiftIt:bindHotkeys({
  left = {{ 'ctrl', 'alt', 'cmd' }, 'left' },
  right = {{ 'ctrl', 'alt', 'cmd' }, 'right' },
  maximum = {{ 'ctrl', 'alt', 'cmd' }, 'm' },
})


-- Tells me whether or not the machine running Hammerspoon is
-- my work machine or not
function isWorkMachine()
  local allNames = hs.host.names()
  for i=1,#allNames do
    if allNames[i]:match('^cawl') then
      return true
    end
  end
  return false
end

-- The goal here is to bind mash+0 and mash+9 to the grander layouts
-- but there's a quick difference depending on whether or not I happen
-- to be on my work machine or not
if isWorkMachine() then
  hs.hotkey.bind(mash, '0', function() runLayout(layouts.work) end)
  hs.hotkey.bind(mash, '9', function() runLayout(layouts.alternatework) end)
else
  hs.hotkey.bind(mash, '0', function() runLayout(layouts.coding) end)
  hs.hotkey.bind(mash, '9', function() runLayout(layouts.alternatecoding) end)
end
hs.hotkey.bind(mash, '8', function() runLayout(layouts.writing) end)

-------------------------------------------------------------------
-- Vim Mode
--
-- Not sure I like this one... but I'm still trying it out.
-------------------------------------------------------------------

-- vim = hs.loadSpoon('VimMode')
-- 
-- hs.hotkey.bind({'ctrl'}, ';', function()
--   vim:enter()
-- end)

-- There is a 'layout' plugin but it was more difficult for me to
-- understand than it was for me to just write my own, so this is
-- my definitions for defining the layouts for all of the apps
-- that I tend to use.
layouts = {
  alternatecoding = {
    -- { name = 'VimR',              unit = units.left30 },
    { name = 'Firefox',           app = 'Firefox.app',           unit = units.left70 },
    { name = 'MacVim',            app = 'MacVim.app',            unit = units.left30 },
    { name = 'iTerm2',            app = 'iTerm.app',             unit = units.right70 }
  },
  alternatework = {
    -- { name = 'VimR',              unit = units.left30,  screen = 'Thunderbolt Display' },
    { name = 'Firefox',           app = 'Firefox.app',           unit = units.left70,  screen = 'Thunderbolt Display' },
    { name = 'MacVim',            app = 'MacVim.app',            unit = units.left30,  screen = 'Thunderbolt Display' },
    { name = 'iTerm2',            app = 'iTerm.app',             unit = units.right70, screen = 'Thunderbolt Display' },
    { name = 'Slack',             app = 'Slack.app',             unit = units.bot87,   screen = 'Color LCD' },
    { name = 'Microsoft Outlook', app = 'Microsoft Outlook.app', unit = units.maximum, screen = 'Color LCD' },
    { name = 'WhatsApp',          app = 'WhatsApp.app',          unit = units.center,  screen = 'Color LCD' },
    { name = 'Signal',            app = 'Signal.app',            unit = units.center,  screen = 'Color LCD' },
    { name = 'Google Chrome',     app = 'Google Chrome.app',     unit = units.right70, screen = 'Color LCD' }
  },
  coding = {
    -- { name = 'VimR',    unit = units.left70 },
    { name = 'Firefox',           app = 'Firefox.app',           unit = units.left70 },
    { name = 'MacVim',            app = 'MacVim.app',            unit = units.left70 },
    { name = 'iTerm2',            app = 'iTerm2.app',            unit = units.right30 }
  },
  -- I'll use 'work' as my example. If I want to position the windows of
  -- all of these applications, then I simply specify 'layouts.work' and 
  -- then the layout engine will move all of the windows for these apps to
  -- the right monitor and in the right position on that monitor.
  work = {
    -- { name = 'VimR',              unit = units.left70,  screen = 'Thunderbolt Display' },
    { name = 'Firefox',           app = 'Firefox.app',            unit = units.left70,  screen = 'Thunderbolt Display' },
    { name = 'MacVim',            app = 'MacVim.app',             unit = units.left70,  screen = 'Thunderbolt Display' },
    { name = 'iTerm2',            app = 'iTerm.app',              unit = units.right30, screen = 'Thunderbolt Display' },
    { name = 'Slack',             app = 'Slack.app',              unit = units.bot87,   screen = 'Color LCD' },
    { name = 'Microsoft Outlook', app = 'Microsoft Outlook.app',  unit = units.maximum, screen = 'Color LCD' },
    { name = 'WhatsApp',          app = 'WhatsApp.app',           unit = units.center,  screen = 'Color LCD' },
    { name = 'Signal',            app = 'Signal.app',             unit = units.center,  screen = 'Color LCD' },
    { name = 'Google Chrome',     app = 'Google Chrome.app',      unit = units.right70, screen = 'Color LCD' }
  },
  writing = {
    -- { name = 'VimR',    unit = units.left70 },
    { name = 'Firefox',           app = 'Firefox.app',            unit = units.left70 },
    { name = 'MacVim',            app = 'MacVim.app',             unit = units.left70 },
    { name = 'iTerm2',            app = 'iTerm.app',              unit = units.right30 },
    { name = 'Skim',              app = 'Skim.app',               unit = units.right70top80 }
  }
}

-------------------------------------------------------------------
-- Key Remapper
--
-- Doesn't work.
-------------------------------------------------------------------

-- local function pressFn(mods, key)
-- 	if key == nil then
-- 		key = mods
-- 		mods = {}
-- 	end
-- 
-- 	return function() hs.eventtap.keyStroke(mods, key, 1000) end
-- end
-- 
-- local function remap(mods, key, pressFn)
-- 	hs.hotkey.bind(mods, key, pressFn, nil, pressFn)	
-- end