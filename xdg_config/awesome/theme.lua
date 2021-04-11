-------------------
-- awesome theme --
-------------------

local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()

-- base16 color theme: ocean
-- base00 - Default Background
-- base01 - Lighter Background (Used for status bars, line number and folding marks)
-- base02 - Selection Background
-- base03 - Comments, Invisibles, Line Highlighting
-- base04 - Dark Foreground (Used for status bars)
-- base05 - Default Foreground, Caret, Delimiters, Operators
-- base06 - Light Foreground (Not often used)
-- base07 - Light Background (Not often used)
-- base08 - Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted
-- base09 - Integers, Boolean, Constants, XML Attributes, Markup Link Url
-- base0A - Classes, Markup Bold, Search Text Background
-- base0B - Strings, Inherited Class, Markup Code, Diff Inserted
-- base0C - Support, Regular Expressions, Escape Characters, Markup Quotes
-- base0D - Functions, Methods, Attribute IDs, Headings
-- base0E - Keywords, Storage, Selector, Markup Italic, Diff Changed
-- base0F - Deprecated, Opening/Closing Embedded Language Tags

local colours = {}
colours.base00 = "#2b303b"
colours.base01 = "#343d46"
colours.base02 = "#4f5b66"
colours.base03 = "#65737e"
colours.base04 = "#a7adba"
colours.base05 = "#c0c5ce"
colours.base06 = "#dfe1e8"
colours.base07 = "#eff1f5"
colours.base08 = "#bf616a"
colours.base09 = "#d08770"
colours.base0A = "#ebcb8b"
colours.base0B = "#a3be8c"
colours.base0C = "#96b5b4"
colours.base0D = "#8fa1b3"
colours.base0E = "#b48ead"
colours.base0F = "#ab7967"


local theme = {}

theme.font          = "Play 9"

theme.bg_normal     = colours.base00
theme.bg_focus      = colours.base02
theme.bg_urgent     = colours.base0A
theme.bg_minimize   = theme.bg_normal
theme.bg_systray    = theme.bg_normal

theme.fg_normal     = colours.base04
theme.fg_focus      = colours.base05
theme.fg_urgent     = theme.fg_focus
theme.fg_minimize   = theme.fg_normal

theme.useless_gap   = dpi(0)
theme.border_width  = dpi(1)
theme.border_normal = theme.bg_normal
theme.border_focus  = theme.bg_focus
theme.border_marked = colours.base01

-- -- Disable the tasklist client titles.
-- theme.tasklist_disable_task_name = true
-- -- Disable the extra tasklist client property notification icons.
-- theme.tasklist_plain_task_name = true

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- prompt_[fg|bg|fg_cursor|bg_cursor|font]
-- hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|label_bg|label_fg|group_margin|font|description_font]
-- Example:
--theme.taglist_bg_focus = "#ff0000"

-- Generate taglist squares:
local taglist_square_size = dpi(0)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(
    taglist_square_size, theme.fg_normal
)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
    taglist_square_size, theme.fg_normal
)

-- Variables set for theming notifications:
-- notification_font
-- notification_[bg|fg]
-- notification_[width|height|margin]
-- notification_[border_color|border_width|shape|opacity]

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
-- theme.menu_submenu_icon = themes_path.."default/submenu.png"
theme.menu_height = dpi(15)
theme.menu_width  = dpi(100)

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

theme.wibar_height = dpi(25)
theme.taglist_empty_tag_opacity = 0.3

-- Define the image to load
-- local icon_window_close = "/usr/share/icons/Adwaita/16x16/ui/window-close-symbolic.symbolic.png"
local icon_directory = "/usr/share/icons/Papirus-Dark/16x16/actions/"
local icon_window_close = icon_directory.."window-close.svg"
theme.titlebar_close_button_normal = icon_window_close
theme.titlebar_close_button_focus = icon_window_close

local icon_window_maximize = icon_directory.."window-maximize.svg"
theme.titlebar_maximized_button_normal_inactive = icon_window_maximize
theme.titlebar_maximized_button_focus_inactive  = icon_window_maximize
theme.titlebar_maximized_button_normal_active = icon_window_maximize
theme.titlebar_maximized_button_focus_active  = icon_window_maximize

theme.wallpaper = themes_path.."default/background.png"

-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(
    theme.menu_height, theme.bg_focus, theme.fg_focus
)

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

return theme
