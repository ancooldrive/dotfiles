---------------------------------------------------------------------------
--- mstimer objects and functions.
--
-- @usage
--    -- Create a widget and update its content using the output of a shell
--    -- command every 10 seconds:
--    local mybatterybar = wibox.widget {
--        {
--            min_value    = 0,
--            max_value    = 100,
--            value        = 0,
--            paddings     = 1,
--            border_width = 1,
--            forced_width = 50,
--            border_color = "#0000ff",
--            id           = "mypb",
--            widget       = wibox.widget.progressbar,
--        },
--        {
--            id           = "mytb",
--            text         = "100%",
--            widget       = wibox.widget.textbox,
--        },
--        layout      = wibox.layout.stack,
--        set_battery = function(self, val)
--            self.mytb.text  = tonumber(val).."%"
--            self.mypb.value = tonumber(val)
--        end,
--    }
--
--    gears.mstimer {
--        timeout   = 10,
--        call_now  = true,
--        autostart = true,
--        callback  = function()
--            -- You should read it from `/sys/class/power_supply/` (on Linux)
--            -- instead of spawning a shell. This is only an example.
--            awful.spawn.easy_async(
--                {"sh", "-c", "acpi | sed -n 's/^.*, \([0-9]*\)%/\1/p'"},
--                function(out)
--                    mybatterybar.battery = out
--                end
--            )
--        end
--    }
--
-- @author Uli Schlachter
-- @copyright 2014 Uli Schlachter
-- @classmod gears.mstimer
---------------------------------------------------------------------------

local capi = { awesome = awesome }
local ipairs = ipairs
local pairs = pairs
local setmetatable = setmetatable
local table = table
local tonumber = tonumber
local traceback = debug.traceback
local unpack = unpack or table.unpack -- luacheck: globals unpack (compatibility with Lua 5.1)
local glib = require("lgi").GLib
local object = require("gears.object")
local protected_call = require("gears.protected_call")

--- mstimer objects. This type of object is useful when triggering events repeatedly.
-- The mstimer will emit the "timeout" signal every N seconds, N being the timeout
-- value. Note that a started mstimer will not be garbage collected. Call `:stop`
-- to enable garbage collection.
-- @tfield number timeout Interval in seconds to emit the timeout signal.
--   Can be any value, including floating point ones (e.g. 1.5 seconds).
-- @tfield boolean started Read-only boolean field indicating if the mstimer has been
--   started.
-- @table mstimer

--- When the mstimer is started.
-- @signal start

--- When the mstimer is stopped.
-- @signal stop

--- When the mstimer had a timeout event.
-- @signal timeout

local mstimer = { mt = {} }

--- Start the mstimer.
function mstimer:start()
    if self.data.source_id ~= nil then
        print(traceback("mstimer already started"))
        return
    end
    self.data.source_id = glib.timeout_add(glib.PRIORITY_DEFAULT, self.data.timeout * 1, function()
        protected_call(self.emit_signal, self, "timeout")
        return true
    end)
    self:emit_signal("start")
end

--- Stop the mstimer.
function mstimer:stop()
    if self.data.source_id == nil then
        print(traceback("mstimer not started"))
        return
    end
    glib.source_remove(self.data.source_id)
    self.data.source_id = nil
    self:emit_signal("stop")
end

--- Restart the mstimer.
-- This is equivalent to stopping the mstimer if it is running and then starting
-- it.
function mstimer:again()
    if self.data.source_id ~= nil then
        self:stop()
    end
    self:start()
end

--- The mstimer is started.
-- @property started
-- @param boolean

--- The mstimer timeout value.
-- **Signal:** property::timeout
-- @property timeout
-- @param number

local mstimer_instance_mt = {
    __index = function(self, property)
        if property == "timeout" then
            return self.data.timeout
        elseif property == "started" then
            return self.data.source_id ~= nil
        end

        return mstimer[property]
    end,

    __newindex = function(self, property, value)
        if property == "timeout" then
            self.data.timeout = tonumber(value)
            self:emit_signal("property::timeout")
        end
    end
}

--- Create a new mstimer object.
-- @tparam table args Arguments.
-- @tparam number args.timeout Timeout in seconds (e.g. 1.5).
-- @tparam[opt=false] boolean args.autostart Automatically start the mstimer.
-- @tparam[opt=false] boolean args.call_now Call the callback at mstimer creation.
-- @tparam[opt=nil] function args.callback Callback function to connect to the
--  "timeout" signal.
-- @tparam[opt=false] boolean args.single_shot Run only once then stop.
-- @treturn mstimer
-- @function gears.mstimer
function mstimer.new(args)
    args = args or {}
    local ret = object()

    ret.data = { timeout = 0 } --TODO v5 rename to ._private
    setmetatable(ret, mstimer_instance_mt)

    for k, v in pairs(args) do
        ret[k] = v
    end

    if args.autostart then
        ret:start()
    end

    if args.callback then
        if args.call_now then
            args.callback()
        end
        ret:connect_signal("timeout", args.callback)
    end

    if args.single_shot then
        ret:connect_signal("timeout", function() ret:stop() end)
    end

    return ret
end

--- Create a timeout for calling some callback function.
-- When the callback function returns true, it will be called again after the
-- same timeout. If false is returned, no more calls will be done. If the
-- callback function causes an error, no more calls are done.
-- @tparam number timeout Timeout in seconds (e.g. 1.5).
-- @tparam function callback Function to run.
-- @treturn mstimer The mstimer object that was set up.
-- @function gears.mstimer.start_new
-- @see gears.mstimer.weak_start_new
function mstimer.start_new(timeout, callback)
    local t = mstimer.new({ timeout = timeout })
    t:connect_signal("timeout", function()
        local cont = protected_call(callback)
        if not cont then
            t:stop()
        end
    end)
    t:start()
    return t
end

--- Create a timeout for calling some callback function.
-- This function is almost identical to `gears.mstimer.start_new`. The only difference
-- is that this does not prevent the callback function from being garbage
-- collected. After the callback function was collected, the mstimer returned
-- will automatically be stopped.
-- @tparam number timeout Timeout in seconds (e.g. 1.5).
-- @tparam function callback Function to start.
-- @treturn mstimer The mstimer object that was set up.
-- @function gears.mstimer.weak_start_new
-- @see gears.mstimer.start_new
function mstimer.weak_start_new(timeout, callback)
    local indirection = setmetatable({}, { __mode = "v" })
    indirection.callback = callback
    return mstimer.start_new(timeout, function()
        local cb = indirection.callback
        if cb then
            return cb()
        end
    end)
end

local delayed_calls = {}
capi.awesome.connect_signal("refresh", function()
    for _, callback in ipairs(delayed_calls) do
        protected_call(unpack(callback))
    end
    delayed_calls = {}
end)

--- Call the given function at the end of the current main loop iteration
-- @tparam function callback The function that should be called
-- @param ... Arguments to the callback function
-- @function gears.mstimer.delayed_call
function mstimer.delayed_call(callback, ...)
    assert(type(callback) == "function", "callback must be a function, got: " .. type(callback))
    table.insert(delayed_calls, { callback, ... })
end

function mstimer.mt.__call(_, ...)
    return mstimer.new(...)
end

return setmetatable(mstimer, mstimer.mt)

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
