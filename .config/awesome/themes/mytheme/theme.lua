--[[

     Powerarrow Dark Awesome WM theme
     github.com/lcpz

--]]

local gears = require("gears")
local lain  = require("lain")
local awful = require("awful")
local wibox = require("wibox")
local dpi   = require("beautiful.xresources").apply_dpi
local naughty = require("naughty")

local os = os
local my_table = awful.util.table or gears.table -- 4.{0,1} compatibility

local theme                                     = {}
theme.dir                                       = os.getenv("HOME") .. "/.config/awesome/themes/mytheme"
theme.wallpaper                                 = theme.dir .. "/wall.jpg"
theme.font                                      = "Font Awesome 5 Free 10"
theme.fg_normal                                 = "#DDDDFF"
theme.fg_focus                                  = "#bd93f9"
theme.fg_urgent                                 = "#CC9393"
theme.bg_normal                                 = "#1A1A1A"
theme.bg_focus                                  = "#313131"
theme.bg_urgent                                 = "#1A1A1A"
theme.border_width                              = dpi(2)
theme.border_normal                             = "#3F3F3F"
theme.border_focus                              = "#bd93f9"
theme.border_marked                             = "#CC9393"
theme.tasklist_bg_focus                         = "#1A1A1A"
theme.titlebar_bg_focus                         = theme.bg_focus
theme.titlebar_bg_normal                        = theme.bg_normal
theme.titlebar_fg_focus                         = theme.fg_focus
theme.menu_height                               = dpi(16)
theme.menu_width                                = dpi(140)
theme.menu_submenu_icon                         = theme.dir .. "/icons/submenu.png"
theme.taglist_squares_sel                       = theme.dir .. "/icons/square_sel.png"
theme.taglist_squares_unsel                     = theme.dir .. "/icons/square_unsel.png"
theme.layout_tile                               = theme.dir .. "/icons/tile.png"
theme.layout_tileleft                           = theme.dir .. "/icons/tileleft.png"
theme.layout_tilebottom                         = theme.dir .. "/icons/tilebottom.png"
theme.layout_tiletop                            = theme.dir .. "/icons/tiletop.png"
theme.layout_fairv                              = theme.dir .. "/icons/fairv.png"
theme.layout_fairh                              = theme.dir .. "/icons/fairh.png"
theme.layout_spiral                             = theme.dir .. "/icons/spiral.png"
theme.layout_dwindle                            = theme.dir .. "/icons/dwindle.png"
theme.layout_max                                = theme.dir .. "/icons/max.png"
theme.layout_fullscreen                         = theme.dir .. "/icons/fullscreen.png"
theme.layout_magnifier                          = theme.dir .. "/icons/magnifier.png"
theme.layout_floating                           = theme.dir .. "/icons/floating.png"
theme.widget_ac                                 = theme.dir .. "/icons/ac.png"
theme.widget_battery                            = theme.dir .. "/icons/battery.png"
theme.widget_battery_low                        = theme.dir .. "/icons/battery_low.png"
theme.widget_battery_empty                      = theme.dir .. "/icons/battery_empty.png"
theme.widget_mem                                = theme.dir .. "/icons/mem.png"
theme.widget_cpu                                = theme.dir .. "/icons/cpu.png"
theme.widget_temp                               = theme.dir .. "/icons/temp.png"
theme.widget_net                                = theme.dir .. "/icons/net.png"
theme.widget_hdd                                = theme.dir .. "/icons/hdd.png"
theme.widget_music                              = theme.dir .. "/icons/note.png"
theme.widget_music_on                           = theme.dir .. "/icons/note_on.png"
theme.widget_vol                                = theme.dir .. "/icons/vol.png"
theme.widget_vol_low                            = theme.dir .. "/icons/vol_low.png"
theme.widget_vol_no                             = theme.dir .. "/icons/vol_no.png"
theme.widget_vol_mute                           = theme.dir .. "/icons/vol_mute.png"
theme.widget_mail                               = theme.dir .. "/icons/mail.png"
theme.widget_mail_on                            = theme.dir .. "/icons/mail_on.png"
theme.tasklist_plain_task_name                  = True
theme.tasklist_disable_icon                     = False
theme.useless_gap                               = dpi(10)
theme.titlebar_close_button_focus               = theme.dir .. "/icons/titlebar/close_focus.png"
theme.titlebar_close_button_normal              = theme.dir .. "/icons/titlebar/close_normal.png"
theme.titlebar_ontop_button_focus_active        = theme.dir .. "/icons/titlebar/ontop_focus_active.png"
theme.titlebar_ontop_button_normal_active       = theme.dir .. "/icons/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_inactive      = theme.dir .. "/icons/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_inactive     = theme.dir .. "/icons/titlebar/ontop_normal_inactive.png"
theme.titlebar_sticky_button_focus_active       = theme.dir .. "/icons/titlebar/sticky_focus_active.png"
theme.titlebar_sticky_button_normal_active      = theme.dir .. "/icons/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_inactive     = theme.dir .. "/icons/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_inactive    = theme.dir .. "/icons/titlebar/sticky_normal_inactive.png"
theme.titlebar_floating_button_focus_active     = theme.dir .. "/icons/titlebar/floating_focus_active.png"
theme.titlebar_floating_button_normal_active    = theme.dir .. "/icons/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_inactive   = theme.dir .. "/icons/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_inactive  = theme.dir .. "/icons/titlebar/floating_normal_inactive.png"
theme.titlebar_maximized_button_focus_active    = theme.dir .. "/icons/titlebar/maximized_focus_active.png"
theme.titlebar_maximized_button_normal_active   = theme.dir .. "/icons/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_inactive  = theme.dir .. "/icons/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_inactive = theme.dir .. "/icons/titlebar/maximized_normal_inactive.png"

local markup = lain.util.markup
local separators = lain.util.separators

-- Textclock
-- local clockicon = wibox.widget.imagebox(theme.widget_clock)
-- local clock = awful.widget.watch(
--     "date +'%A %d %B %Y, %R'", 60,
--     function(widget, stdout)
--         widget:set_markup(" " .. markup.font(theme.font, stdout))
--     end
-- )

local status = awful.widget.watch(
    os.getenv("HOME") .. "/.local/share/scripts/statusBar.sh -all", 5,
    function(widget, stdout)
        widget:set_markup(" " .. markup.font(theme.font, stdout))
    end
)

-- status:buttons(
--     awful.button({ }, 1, function() showRatesPopup() end)
-- )

-- function showRatesPopup()   
--     naughty.notify(
--         {
--             title = "Achtung!", 
--             text = "You're idling", 
--             timeout = 10
--         }
--     )
-- end

-- local button = wibox.widget{
--     markup = 'This <i>is</i> a <b>textbox</b>!!!',
--     align  = 'center',
--     valign = 'center',
--     widget = wibox.widget.textbox
-- }
-- button:buttons(
--     awful.button({ }, 1, function() showRatesPopup() end)
-- )
-- button:connect_signal("mouse::enter", function()
--     -- Hm, no idea how to get the wibox from this signal's arguments...
--     -- local w = mouse.current_wibox
--     button:set_markup("mouse:enter")
-- end)
-- button:connect_signal("mouse::leave", function()
--     local w = mouse.current_wibox
--     button:set_markup("mouse:leave")
-- end)












-- local test123_text = wibox.widget.textbox()
-- test123_text:set_markup("dwadwad")
-- test123_text:set_align("center")

-- local test123 = wibox.widget{
--     {
--         -- {
--         --     markup = "<b>Hello World!</b>",
--         --     align  = "center",
--         --     widget = wibox.widget.textbox
--         -- },
--         test123_text,
--         bg     = "#ff0000",
--         widget = wibox.container.background,
--     },
--     width    = 300,
--     strategy = "min",
--     layout   = wibox.layout.constraint
-- }
-- local current_clock;
-- test123:buttons(
--     my_table.join(
--         awful.button({ }, 2, 
--             function() 
--                 current_clock = os.clock()
--                 test123Timer:start() 
--             end
--         ),
--         awful.button({ }, 1, function() test123:set_width(test123:get_width() - 10) end),
--         awful.button({ }, 3, function() test123_text:set_markup("1212121") end)
--     )
-- )


-- test123Timer = lain.util.mstimer {
--     timeout   = 1,
--     call_now  = false,
--     autostart = false,
--     callback  = function()
--         -- test123:set_width(test123:get_width() - 10) 
--         -- test123Timer:stop();
--         test123_text:set_markup("timer on" .. os.clock())  
--         if current_clock < os.clock() - 10 then
--             test123Timer:stop()
--             test123_text:set_markup("end")
--         end
--     end
-- }












-- local mybatterybar = wibox.widget {
--     {
--         min_value    = 0,
--         max_value    = 100,
--         value        = 0,
--         paddings     = 1,
--         border_width = 1,
--         forced_width = 50,
--         border_color = "#0000ff",
--         id           = "mypb",
--         widget       = wibox.widget.progressbar,
--     },
--     {
--         id           = "mytb",
--         text         = "100%",
--         widget       = wibox.widget.textbox,
--     },
--     layout      = wibox.layout.stack,
--     set_battery = function(self, val)
--         self.mytb.text  = tonumber(val).."%"
--         self.mypb.value = tonumber(val)
--     end,
-- }

-- gears.timer {
--     timeout   = 10,
--     call_now  = true,
--     autostart = true,
--     callback  = function()
--         -- You should read it from `/sys/class/power_supply/` (on Linux)
--         -- instead of spawning a shell. This is only an example.
--         awful.spawn.easy_async(
--             "pamixer --get-volume",
--             function(out)
--                 mybatterybar.battery = out
--             end
--         )
--     end
-- }










-- Separators
local spr     = wibox.widget.textbox(' ')
local arrl_dl = separators.arrow_left(theme.bg_focus, "alpha")
local arrl_ld = separators.arrow_left("alpha", theme.bg_focus)

function theme.at_screen_connect(s)
    -- Quake application
    s.quake = lain.util.quake({ app = awful.util.terminal })

    -- If wallpaper is a function, call it with the screen
    local wallpaper = theme.wallpaper
    if type(wallpaper) == "function" then
        wallpaper = wallpaper(s)
    end
    gears.wallpaper.maximized(wallpaper, s, true)

    -- Tags
    awful.tag(awful.util.tagnames, s, awful.layout.layouts)

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(my_table.join(
                           awful.button({}, 1, function () awful.layout.inc( 1) end),
                           awful.button({}, 2, function () awful.layout.set( awful.layout.layouts[1] ) end),
                           awful.button({}, 3, function () awful.layout.inc(-1) end),
                           awful.button({}, 4, function () awful.layout.inc( 1) end),
                           awful.button({}, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, awful.util.taglist_buttons)

    -- Create a tasklist widget
     s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, awful.util.tasklist_buttons)

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s, height = dpi(18), bg = theme.bg_normal, fg = theme.fg_normal })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            --spr,
            s.mytaglist,
            s.mypromptbox,
            spr,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            -- button,
            -- mybatterybar,
            -- test123,
            status,
            separators.arrow_left("#3B4252", "black"),
            wibox.container.background(s.mylayoutbox, black),
        },
    }
end

return theme
