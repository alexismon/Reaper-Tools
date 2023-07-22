--[[
    Script Name: Track Renamer Lite
    Description: This will copy the name of the first selected track and 
    copy it to the rest, the prompt will ask to either confirm or change 
    the first track name. Handy with "Track Numbering" script
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

function renameSelectedTracks()
    local trackCount = reaper.CountSelectedTracks(0)

    -- No selected track
    if trackCount == 0 then return end

    local firstTrack = reaper.GetSelectedTrack(0, 0)
    local _, firstTrackName = reaper.GetSetMediaTrackInfo_String(firstTrack, 'P_NAME', '', false)

    -- Show input dialog with the first track name as the default
    local retval, newTrackName = reaper.GetUserInputs("Rename selected tracks", 1, "New Track Name:", firstTrackName)
    
    -- If user clicked "Continue" (retval == true), rename all selected tracks
    if retval then
        for i=0, trackCount-1 do
            local track = reaper.GetSelectedTrack(0, i)
            reaper.GetSetMediaTrackInfo_String(track, 'P_NAME', newTrackName, true)
        end
    end
end

renameSelectedTracks()

