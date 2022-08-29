local inspect = hs.inspect

local SpeechHistory={}

SpeechHistory.name="Speech History"
SpeechHistory.version=1.0
SpeechHistory.author="Mikolaj Holysz <miki123211@gmail.com>"
SpeechHistory.license="MIT"

local history = {}
local lastPhrase = ""
local index = 0
-- If we're reading a history item right now, we don't want to append that same item to the history again.
local historyLocked = false
local lockTimer

local lastPhraseScript = [[
global spokenPhrase

tell application "VoiceOver"
	set spokenPhrase to the content of the last phrase
end tell

spokenPhrase
]]

local function checkLastPhrase()
    success, result, output = hs.osascript.applescript(lastPhraseScript)
    if not success then
        print(inspect(output))
        return
    end

    if result == lastPhrase or result:match("^%s*$") then
        return
    end

    if not historyLocked then
        table.insert(history, result)
    end

    lastPhrase = result
end

local speakScript = [[
tell application "VoiceOver"
	output "MESSAGE"
end tell
]]

local function speak(text)
    -- We can't pass the supplied message to string.gsub directly,
    -- because gsub uses '%' characters in the replacement string for capture groups
    -- and we can't guarantee that our message doesn't contain any of those.

    local script = speakScript:gsub("MESSAGE", function ()
        return text
    end)

    success, _, output = hs.osascript.applescript(script)
    if not success then
        print(inspect(output))
    end

    -- We don't want the phrase that we just read to be appended to the history buffer again.
    historyLocked = true
    if lockedTimer then
        lockedTimer:stop()
    end

    lockedTimer = hs.timer.doAfter(0.5, function()
        historyLocked = false
    end)
end

local function prevItem()
    if index == 1 then
        return
    end

    index = index - 1
    speak(history[index])
end

local function nextItem()
    if index == #history then
        return
    end

    index = index + 1
    print(inspect(history[index]))
    speak(history[index])
end

local function firstItem()
    index = 1
    speak(history[index])
end

local function lastItem()
    index = #history
    speak(history[index])
end

local timer = hs.timer.doEvery(0.1, checkLastPhrase)
local prevHotkey = hs.hotkey.new("ctrl-shift", "f11", prevItem)
local nextHotkey = hs.hotkey.new("ctrl-shift", "f12", nextItem)
local firstHotkey = hs.hotkey.new("ctrl-shift-cmd", "f11", firstItem)
local lastHotkey = hs.hotkey.new("ctrl-shift-cmd", "f12", lastItem)

function SpeechHistory.init()
end

function SpeechHistory.start()
    timer:start()
    prevHotkey:enable()
    nextHotkey:enable()
    firstHotkey:enable()
    lastHotkey:enable()
end

function SpeechHistory.stop()
    timer:stop()
    prevHotkey:disable()
    nextHotkey:disable()
    firstHotkey:disable()
    lastHotkey:disable()
end

return SpeechHistory