-------------------------------------------------------------------
-- Globals
-------------------------------------------------------------------
hs.window.animationDuration = 0

-------------------------------------------------------------------
-- Events
--
-- I just use this to explore some possibilities, but have never 
-- actually done anything with it, so all it does "for real" is 
-- return false
-------------------------------------------------------------------
theEventTap = hs.eventtap.new({ hs.eventtap.event.types.keyDown }, function(e)
  if e:getKeyCode() == 105 then
    print("Received keydown event: " .. e:getKeyCode())
    hs.caffeinate.startScreensaver()
    return true
  else
    return false
  end
end)
theEventTap:start()


-------------------------------------------------------------------
-- Window Layouts
-------------------------------------------------------------------

-- These are just convenient names for layouts. We can use numbers
-- between 0 and 1 for defining 'percentages' of screen real estate
-- so 'right30' is the window on the right of the screen where the
-- vertical split (x-axis) starts at 70% of the screen from the
-- left, and is 30% wide.
--
-- And so on...
units = {
  right30       = { x = 0.70, y = 0.00, w = 0.30, h = 1.00 },
  right50       = { x = 0.50, y = 0.00, w = 0.50, h = 1.00 },
  right70       = { x = 0.30, y = 0.00, w = 0.70, h = 1.00 },
  left70        = { x = 0.00, y = 0.00, w = 0.70, h = 1.00 },
  left50        = { x = 0.00, y = 0.00, w = 0.50, h = 1.00 },
  left30        = { x = 0.00, y = 0.00, w = 0.30, h = 1.00 },
  top50         = { x = 0.00, y = 0.00, w = 1.00, h = 0.50 },
  bot50         = { x = 0.00, y = 0.50, w = 1.00, h = 0.50 },
  bot80         = { x = 0.00, y = 0.20, w = 1.00, h = 0.80 },
  bot87         = { x = 0.00, y = 0.20, w = 1.00, h = 0.87 },
  bot90         = { x = 0.00, y = 0.20, w = 1.00, h = 0.90 },
  upright30     = { x = 0.70, y = 0.00, w = 0.30, h = 0.50 },
  botright30    = { x = 0.70, y = 0.50, w = 0.30, h = 0.50 },
  upleft70      = { x = 0.00, y = 0.00, w = 0.70, h = 0.50 },
  botleft70     = { x = 0.00, y = 0.50, w = 0.70, h = 0.50 },
  right70top80  = { x = 0.70, y = 0.00, w = 0.30, h = 0.80 },
  maximum       = { x = 0.00, y = 0.00, w = 1.00, h = 1.00 },
  center        = { x = 0.20, y = 0.10, w = 0.60, h = 0.80 }
}



-- Takes a layout definition (e.g. 'layouts.work') and iterates through
-- each application definition, laying it out as speccified
function runLayout(layout)
  for i = 1,#layout do
    local t = layout[i]
    local theapp = hs.application.get(t.name)
    if win == nil then
      hs.application.open(t.app)
      theapp = hs.application.get(t.name)
    end
    local win = theapp:mainWindow()
    local screen = nil
    if t.screen ~= nil then
      screen = hs.screen.find(t.screen)
    end
    win:move(t.unit, screen, true)
  end
end

function changeHeight(window, deltaPx)
  f = window:frame()
  window:move({x = f.x, y = f.y, w = f.w, h = f.h + deltaPx}, nil, true)
end

-- All of the mappings for moving the window of the 'current' application
-- to the right spot. Tries to map 'vim' keys as much as possible, but
-- deviates to a 'visual' representation when that's not possible.
mash = { 'option', 'ctrl', 'cmd' }
hs.hotkey.bind(mash, 'l', function() hs.window.focusedWindow():move(units.right30,    nil, true) end)
hs.hotkey.bind(mash, 'h', function() hs.window.focusedWindow():move(units.left70,     nil, true) end)
hs.hotkey.bind(mash, 'k', function() hs.window.focusedWindow():move(units.top50,      nil, true) end)
hs.hotkey.bind(mash, 'j', function() hs.window.focusedWindow():move(units.bot50,      nil, true) end)
hs.hotkey.bind(mash, ']', function() hs.window.focusedWindow():move(units.upright30,  nil, true) end)
hs.hotkey.bind(mash, '[', function() hs.window.focusedWindow():move(units.upleft70,   nil, true) end)
hs.hotkey.bind(mash, ';', function() hs.window.focusedWindow():move(units.botleft70,  nil, true) end)
hs.hotkey.bind(mash, "'", function() hs.window.focusedWindow():move(units.botright30, nil, true) end)
hs.hotkey.bind(mash, 'm', function() hs.window.focusedWindow():move(units.maximum,    nil, true) end)
hs.hotkey.bind(mash, 'left', function() hs.window.focusedWindow():move(units.left50,    nil, true) end)
hs.hotkey.bind(mash, 'right', function() hs.window.focusedWindow():move(units.right50,    nil, true) end)
hs.hotkey.bind(mash, 'u', function() changeHeight(hs.window.focusedWindow(), -150) end)
hs.hotkey.bind(mash, 'n', function() changeHeight(hs.window.focusedWindow(), 150) end)
-- https://stackoverflow.com/a/58662204
hs.hotkey.bind(mash, 's', function()
  -- get the focused window
  local win = hs.window.focusedWindow()
  -- get the screen where the focused window is displayed, a.k.a. current screen
  local screen = win:screen()
  -- compute the unitRect of the focused window relative to the current screen
  -- and move the window to the next screen setting the same unitRect
  win:move(win:frame():toUnitRect(screen:frame()), screen:next(), true, 0)
end)



-------------------------------------------------------------------
-- Deep Work
--
-- Some functions that will disable notifications for a specified
-- number of minutes, setting a timer that will enable them once
-- it completes
-------------------------------------------------------------------

deepWorkTimer = nil

function enableDoNotDisturb()
  local dt = os.date("!%Y-%m-%d %H:%M:%S +000")
  local output, status, typ, rc = hs.execute("defaults -currentHost write ~/Library/Preferences/ByHost/com.apple.notificationcenterui doNotDisturb -boolean true")
  if rc == 0 then
    local output, status, typ, rc = hs.execute("defaults -currentHost write ~/Library/Preferences/ByHost/com.apple.notificationcenterui doNotDisturbDate -date '" .. dt .. "'")
    if rc == 0 then
      local output, status, typ, rc = hs.execute("killall NotificationCenter")
      return output, status, typ, rc
    else
      return output, status, typ, rc
    end
  else
    return output, status, typ, rc
  end
end

function disableDoNotDisturb()
  local output, status, typ, rc = hs.execute("defaults -currentHost write ~/Library/Preferences/ByHost/com.apple.notificationcenterui doNotDisturb -boolean false")
  if rc == 0 then
    local output, status, typ, rc = hs.execute("killall NotificationCenter")
    return output, status, typ, rc
  else
    return output, status, typ, rc
  end
end

function displayAlertDialog(msg)
  local screen = hs.screen.mainScreen():currentMode()
  local width = screen["w"]
  hs.dialog.alert((width / 2) - 80, 25, function() end, msg)
end

function resumeNotifications()
  if deepWorkTimer ~= nil and deepWorkTimer:running() then
    deepWorkTimer:stop()
  end
  deepWorkTimer = nil
  local output, status, typ, rc = disableDoNotDisturb()
  if rc ~= 0 then
    displayAlertDialog("Failed to start notifications: " .. output)
  end
end

function stopNotifcations(minutes)
  local output, status, typ, rc = enableDoNotDisturb()
  if rc ~= 0 then
    displayAlertDialog("Failed to stop notifications: " .. output)
  else
    deepWorkTimer = hs.timer.doAfter(minutes * 60, function() resumeNotifications(); displayAlertDialog("Deep Work has ended"); return 0 end)
  end
end

function interrogateDeepWorkTimer()
  if deepWorkTimer == nil then
    displayAlertDialog("Deep Work timer isn't running")
  else
    local secs = math.floor(deepWorkTimer:nextTrigger() % 60)
    local mins = math.floor(deepWorkTimer:nextTrigger() / 60)
    displayAlertDialog(string.format("There is %02d:%02d left for deep work", mins, secs))
  end
end

function deepwork()
  resumeNotifications()
  local code, mins = hs.dialog.textPrompt("How many minutes for deep work?", "", "90", "OK", "Cancel")
  if code == "OK" then
    local minNumber = tonumber(mins)
    if minNumber == nil then
      displayAlertDialog(string.format("'%s' is not a valid number of minutes", mins))
    else
      stopNotifcations(minNumber)
    end
  end
end

-------------------------------------------------------------------
-- Launcher
--
-- This is the awesome. The other stuff is all cool, but this is the
-- thing I love the most because it reduces the amount of time I
-- spend with the mouse, and is far more deterministic than trying
-- to use cmd+tab.
--
-- The idea here is to have a MODE-BASED app launching and app
-- switching system. Traditional Mac philosophy (and Emacs :D)
-- would have us contort our hands into crazy combinations of keys
-- to manipulate the state of the machine, which is a serious pain
-- in the ass. Using Hammerspoon we can avoid that.
--
-- * ctrl+space gets us into "launch mode"
-- * In "launch mode" the keyboard changes so that each key can now
--   have a new meaning. For example, the 'v' key is now responsible
--   for either launching or switching to VimR
-- * You can then map whatever you like to whatever function you'd
--   like to invoke.
--
-- It's just a big pile of awesome.
-------------------------------------------------------------------

-- We need to store the reference to the alert window
appLauncherAlertWindow = nil

-- This is the key mode handle
launchMode = hs.hotkey.modal.new({}, nil, '')

-- Leaves the launch mode, returning the keyboard to its normal
-- state, and closes the alert window, if it's showing
function leaveMode()
  if appLauncherAlertWindow ~= nil then
    hs.alert.closeSpecific(appLauncherAlertWindow, 0)
    appLauncherAlertWindow = nil
  end
  launchMode:exit()
end

-- So simple, so awesome.
function switchToApp(app)
  hs.application.open(app)
  leaveMode()
end

-- Enters launch mode. The bulk of this is geared toward
-- showing a big ugly window that can't be ignored; the
-- keyboard is now in launch mode.
hs.hotkey.bind({ 'ctrl', 'cmd' }, 'space', function()
  launchMode:enter()
  appLauncherAlertWindow = hs.alert.show('App Launcher Mode', {
    strokeColor = hs.drawing.color.x11.orangered,
    fillColor = hs.drawing.color.x11.cyan,
    textColor = hs.drawing.color.x11.black,
    strokeWidth = 20,
    radius = 30,
    textSize = 128,
    fadeInDuration = 0,
    atScreenEdge = 2
  }, 'infinite')
end)

-- When in launch mode, hitting ctrl+space again leaves it
launchMode:bind({ 'ctrl' }, 'space', function() leaveMode() end)

-- Mapped keys
launchMode:bind({}, 'c',  function() switchToApp('Google Chrome.app') end)
--launchMode:bind({}, 'd',  function() leaveMode(); deepwork() end)
--launchMode:bind({"shift"}, 'd',  function() leaveMode(); interrogateDeepWorkTimer() end)
launchMode:bind({}, 'i',  function() switchToApp('Signal.app') end)
launchMode:bind({}, 'q',  function() switchToApp('Quip.app') end)
launchMode:bind({}, 's',  function() switchToApp('Slack.app') end)
launchMode:bind({}, 't',  function() switchToApp('iTerm.app') end)
launchMode:bind({}, 'v',  function() switchToApp('VS Code.app') end)
launchMode:bind({}, 'w',  function() switchToApp('WhatsApp.app') end)
launchMode:bind({}, 'z',  function() switchToApp('zoom.us.app') end)
launchMode:bind({}, '`',  function() hs.reload(); leaveMode() end)

-- Unmapped keys
launchMode:bind({}, 'a',  function() leaveMode() end)
launchMode:bind({}, 'b',  function() leaveMode() end)


launchMode:bind({}, 'e',  function() leaveMode() end)


launchMode:bind({}, 'h',  function() leaveMode() end)

launchMode:bind({}, 'j',  function() leaveMode() end)



launchMode:bind({}, 'n',  function() leaveMode() end)





launchMode:bind({}, 'u',  function() leaveMode() end)


launchMode:bind({}, 'x',  function() leaveMode() end)
launchMode:bind({}, 'y',  function() leaveMode() end)

launchMode:bind({}, '1',  function() leaveMode() end)
launchMode:bind({}, '2',  function() leaveMode() end)
launchMode:bind({}, '3',  function() leaveMode() end)
launchMode:bind({}, '4',  function() leaveMode() end)
launchMode:bind({}, '5',  function() leaveMode() end)
launchMode:bind({}, '6',  function() leaveMode() end)
launchMode:bind({}, '7',  function() leaveMode() end)
launchMode:bind({}, '8',  function() leaveMode() end)
launchMode:bind({}, '9',  function() leaveMode() end)
launchMode:bind({}, '0',  function() leaveMode() end)
launchMode:bind({}, '-',  function() leaveMode() end)
launchMode:bind({}, '=',  function() leaveMode() end)
launchMode:bind({}, '[',  function() leaveMode() end)
launchMode:bind({}, ']',  function() leaveMode() end)
launchMode:bind({}, '\\', function() leaveMode() end)
launchMode:bind({}, ';',  function() leaveMode() end)
launchMode:bind({}, "'",  function() leaveMode() end)
launchMode:bind({}, ',',  function() leaveMode() end)
launchMode:bind({}, '.',  function() leaveMode() end)
launchMode:bind({}, '/',  function() leaveMode() end)

function showTodo(s)
  hs.alert.show(s, {
      strokeWidth = 0,
      radius = 0,
      textSize = 36,
      fadeInDuration = 0,
      fadeOutDuration = 0,
      atScreenEdge = 2
    }, 'infinite')
end

currentTodo = nil
-- Workaround for focus bug
-- https://github.com/Hammerspoon/hammerspoon/issues/3218#issuecomment-1135075699
hs.application.get("Hammerspoon"):activate()
hs.hotkey.bind(mash, 'd', function()
  yesButton = 'TODO'
  noButton = 'Cancel'
  button, entry = hs.dialog.textPrompt('TODO:', '', '', yesButton, noButton)
  if button == yesButton and entry ~= '' then
    if currentTodo ~= nil then
      hs.alert.closeAll()
    end
    showTodo(entry)
    currentTodo = {
      prevTodo = currentTodo,
      s = entry
    }
  end
end)

hs.hotkey.bind(mash, 'f', function()
  hs.alert.closeAll()
  if currentTodo ~= nil then
    currentTodo = currentTodo.prevTodo
  end
  if currentTodo ~= nil then
    showTodo(currentTodo.s)
  end
end)



--hs.loadSpoon("ShiftIt")
--spoon.ShiftIt:bindHotkeys({
--  left = {{ 'ctrl', 'alt', 'cmd' }, 'left' },
--  right = {{ 'ctrl', 'alt', 'cmd' }, 'right' },
--  maximum = {{ 'ctrl', 'alt', 'cmd' }, 'm' },
--})