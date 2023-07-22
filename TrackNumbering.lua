--[[
    Script Name: Track Numbering
    Description: Add a numbering suffix to selected tracks
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

function enumerateTracks()
    local trackCount = reaper.CountSelectedTracks(0)
    local lasTrackName = ""
    local counter = 1

    for i=0, trackCount-1 do
        local track = reaper.GetSelectedTrack(0, i)
        local _, trackName = reaper.GetSetMediaTrackInfo_String(track, 'P_NAME', '', false)

        -- Strip off trailing "_#" followed by any amount of numbers if exist, else consider whole name
        local baseName = trackName:match("^(.-)%_%d+$") or trackName

        local itemCount = reaper.CountTrackMediaItems(track)
        
        if baseName ~= lasTrackName then
            counter = 1
        end

        if itemCount > 0 then
            local newName = baseName .. "_" .. string.format("%02d", counter)
            reaper.GetSetMediaTrackInfo_String(track, 'P_NAME', newName, true)
            counter = counter + 1
        else
            local newName = baseName
            reaper.GetSetMediaTrackInfo_String(track, 'P_NAME', newName, true)
        end

        lasTrackName = baseName
    end
end

enumerateTracks()

