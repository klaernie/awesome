local io = io
local math = math
local naughty = naughty
local beautiful = beautiful
local pairs = pairs
local require = require

module("widget_fun")


-- Battery (based on http://awesome.naquadah.org/wiki/Gigamo_Battery_Widget)

local limits = {{25, 5},
          {12, 3},
          { 7, 1},
            {0}}

function getnextlim (num)
    for ind, pair in pairs(limits) do
        lim = pair[1]; step = pair[2]; nextlim = limits[ind+1][1] or 0
        if num > nextlim then
            repeat
                lim = lim - step
            until num > lim
            if lim < nextlim then
                lim = nextlim
            end
            return lim
        end
    end
end


function batclosure ()
    local nextlim = limits[1][1]
    return function (_, args)
        local prefix = "⚡"
        local state, charge = args[1], args[2]
        if not charge then return end
        if state == "-" then
            dirsign = "↓"
            prefix = "Bat:"
            if charge <= nextlim then
                naughty.notify({title = "⚡ Warning! ⚡",
                                text = "Battery has reached critial level ( ⚡ "..charge.."%)!",
                                timeout = 7,
                                position = "bottom_right",
                                fg = beautiful.fg_focus,
                                bg = beautiful.bg_focus
                               })
                nextlim = getnextlim(charge)
            end
        elseif state == "+" then
            dirsign = "↑"
            nextlim = limits[1][1]
        else
            dirsign = ""
        end
        if dir ~= 0 then charge = charge.."%" end
        return " "..prefix.." "..dirsign..charge..dirsign.." "
    end
end

function watch_temp (thermowidget, args)
    local temp = args[1]
    if temp > 87 then
        naughty.notify({title = "Systemvärmgång!",
                        text = "Temperatur utgick till ("..temp.."°C)!",
                        timeout = 3,
                        position = "bottom_left",
                        fg = beautiful.fg_focus,
                        bg = beautiful.bg_focus
                       })
    end
    return " "..temp.."°C "
end

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
