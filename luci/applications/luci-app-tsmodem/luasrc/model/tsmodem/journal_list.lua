--local leveldb = require 'lualeveldb'
local json = require "cjson"

local journal_list = {}

-- Initialize LevelDB options
--local opt = leveldb.options()
--opt.createIfMissing = true
--opt.errorIfExists = false

-- Open the LevelDB database
--local db_path = "/etc/leveldb/output.db" -- Database path
--local db = leveldb.open(opt, db_path)

-- if not leveldb.check(db) then
--     error("Failed to open LevelDB database")
-- end

-- Function to fetch journal entries from LevelDB
function journal_list:fetch()
    local journal_entries = {}
    
    --[[-- Iterate through all keys in the database
    local it = db:iterator()
    -- it:seek("journal_") -- Optionally seek to a specific prefix if needed
    it:seekToFirst()

    while it:valid() do
        local key = it:key()
        local value = it:value()
        
        -- Parse the JSON stored in LevelDB
        local parsed_entry = json.decode(value)
        if parsed_entry then
            table.insert(journal_entries, parsed_entry)
        end

        it:next()
    end

    it:del()--]]

    return journal_entries
end

-- Optional: Render journal elements (if you want to provide additional CSS, validation, etc.)
function journal_list:render(what)
    -- if what == "cssfile" then
    --     return [[<link rel="stylesheet" href="/css/journal.css" />]]
    -- elseif what == "validator" then
    --     -- You can return custom validators if needed
    --     return ""
    -- elseif what == "widgetfile" then
    --     -- Return a widget file if necessary
    --     return ""
    -- end
end

-- Close the database connection when done
function journal_list:close()
    --leveldb.close(db)
end

return journal_list
