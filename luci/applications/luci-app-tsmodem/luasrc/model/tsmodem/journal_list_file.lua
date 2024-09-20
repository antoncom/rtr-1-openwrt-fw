-- luci.model.tsmodem.journal_list.lua
local util = require "luci.util"
local json = require "luci.jsonc"

local journal_list = {}

-- Function to fetch journal entries (similar to the read_saved_items function)
function journal_list:fetch()
    local journal_entries = {}
    local output_file = "/etc/output.txt" -- Adjust this to your file path

    -- Open and read the file line by line
    local file, err = io.open(output_file, "r")
    if file then
        for line in file:lines() do
            local parsed_entry = json.parse(line)
            if parsed_entry then
                table.insert(journal_entries, parsed_entry)
            end
        end
        file:close()
    else
        -- Log or handle the error appropriately
        log.error("Failed to open journal file: " .. (err or "unknown error"))
    end

    return journal_entries
end

-- Optional: Render journal elements (if you want to provide additional CSS, validation, etc.)
function journal_list:render(what)
    if what == "cssfile" then
        return [[<link rel="stylesheet" href="/css/journal.css" />]]
    elseif what == "validator" then
        -- You can return custom validators if needed
        return ""
    elseif what == "widgetfile" then
        -- Return a widget file if necessary
        return ""
    end
end

return journal_list
