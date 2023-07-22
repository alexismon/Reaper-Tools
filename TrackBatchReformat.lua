--[[
    Script Name: Track Batch Reformat
    Description: Gives some options to reformat the selected tracks name
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

function titlecase(str)
    return str:gsub("(%a+)", function(n) return n:sub(1, 1):upper()..n:sub(2):lower() end)
end

function all_upper(str)
    return str:upper()
end

function all_lower(str)
    return str:lower()
end

function format_tracks(format_func)
    local count = reaper.CountSelectedTracks(0)
    for i = 0, count-1 do
        local track = reaper.GetSelectedTrack(0, i)
        local _, name = reaper.GetSetMediaTrackInfo_String(track, 'P_NAME', '', false)
        local new_name = format_func(name)
        reaper.GetSetMediaTrackInfo_String(track, 'P_NAME', new_name, true)
    end
end

while true do
    local ret, user_input = reaper.GetUserInputs("Select an option", 3, "Title Case (0/1=off/on),Upper Case (0/1=off/on),Lower Case (0/1=off/on)", "0,0,0")
    if ret then
        local title_case, upper_case, lower_case = user_input:match("([^,]+),([^,]+),([^,]+)")
        title_case = tonumber(title_case)
        upper_case = tonumber(upper_case)
        lower_case = tonumber(lower_case)
        
        local sum = title_case + upper_case + lower_case
        if sum == 1 then
            if title_case == 1 then
                format_tracks(titlecase)
            elseif upper_case == 1 then
                format_tracks(all_upper)
            elseif lower_case == 1 then
                format_tracks(all_lower)
            end
            break
        elseif sum == 0 then
            reaper.ShowMessageBox("No option selected. Please try again.", "Error", 0)
        else
            reaper.ShowMessageBox("Multiple options selected. Please select only one option.", "Error", 0)
        end
    else
        break
    end
end

