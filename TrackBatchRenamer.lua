--[[
    Script Name: Track Batch Renamer
    Description: Batch rename the selected tracks
    Author: Alexis Mondragon Tayabas
    Creation Date: 2023-07-22
    License: GNU General Public License v3.0

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program. If not, see <http://www.gnu.org/licenses/>.
--]]

-- This function escapes all special characters in a Lua pattern
local function escapePattern(pattern)
    local escapedPattern = pattern:gsub("([%(%)%.%%%+%-%*%?%[%^%$])", "%%%1")
    return escapedPattern
end

local function renameTracks(clear, defaultText, prefix, suffix, find, useWildcards, replace, numbering, separator)
    local trackCount = reaper.CountSelectedTracks(0)

    for i=0, trackCount-1 do
        local track = reaper.GetSelectedTrack(0, i)
        local _, trackName = reaper.GetSetMediaTrackInfo_String(track, 'P_NAME', '', false)

        if clear == "1" then
            trackName = defaultText
        end

        if find ~= "" then
            local escapedFind = find
            if useWildcards ~= "1" then
                escapedFind = escapePattern(find)
            end
            trackName = trackName:gsub(escapedFind, replace or '')
        end

        local newName = prefix .. trackName .. suffix

        if numbering == "1" then
            newName = newName .. separator .. tostring(i+1)
        end

        reaper.GetSetMediaTrackInfo_String(track, 'P_NAME', newName, true)
    end
end

local function showInputDialog()
    local _, lastInputs = reaper.GetProjExtState(0, "MyScript", "Inputs")
    local defaults = lastInputs or ''
    local ret, userInput = reaper.GetUserInputs('Auto-Rename Tracks', 9, 'Clear (0 : off, 1 : on),Default Text:,Prefix:,Suffix:,Find:,Use Wildcards (0 : off, 1 : on),Replace:,Num (0 : off, 1 : on),Separator:,', defaults)

    if not ret then return end

    reaper.SetProjExtState(0, "MyScript", "Inputs", userInput)

    local inputs = {}

    -- Split userInput by comma
    local i = 1
    for input in string.gmatch(userInput, '([^,]*),') do
        inputs[i] = input
        i = i + 1
    end
    -- Capture last field after the last comma
    inputs[i] = userInput:match(".*,(.*)")

    renameTracks(inputs[1] or '0', inputs[2] or '', inputs[3] or '', inputs[4] or '', inputs[5] or '', inputs[6] or '0', inputs[7] or '', inputs[8] or '0', inputs[9] or '')
end

showInputDialog()
