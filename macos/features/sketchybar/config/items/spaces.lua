local colors = require("colors")
local icons = require("icons")
local settings = require("settings")
local app_icons = require("helpers.app_icons")

local bar_position = 'center'
local spaces = {}

function tableToString(tbl)
    local result = "{"
    local first = true
    for k, v in pairs(tbl) do
        if not first then
            result = result .. ", "
        end
        first = false

        -- Handle key type (string or number)
        if type(k) == "string" then
            result = result .. string.format("[\"%s\"] = ", k)
        else
            result = result .. string.format("[%s] = ", k)
        end

        -- Handle value type (string, number, boolean, or nested table)
        if type(v) == "string" then
            result = result .. string.format("\"%s\"", v)
        elseif type(v) == "number" or type(v) == "boolean" then
            result = result .. tostring(v)
        elseif type(v) == "table" then
            result = result .. tableToString(v) -- Recursively handle nested tables
        else
            result = result .. "nil" -- Handle other types as nil or a placeholder
        end
    end
    result = result .. "}"
    return result
end

local data = {
  displays = {
    {
      current_space = 1,
      number_of_spaces = 1,
    },
    {
      current_space = 1,
      number_of_spaces = 1,
    }
  },
  spaces = {
    {
      display = 1,
    },
  },
  total_number_of_spaces = 1,
  number_of_displays = 1,
}

local reconcile_fn = nil

function update_data()
  sbar.exec("/run/current-system/sw/bin/yabai -m query --spaces", function(spaces, error_code)
    if error_code ~= 0 then
      print("Error querying spaces: " .. tostring(error_code))
    end

    new_data = {}
    new_data.spaces = spaces
    new_data.total_number_of_spaces = #spaces

    displays = {}
    for _, space in ipairs(spaces) do
      local display_index = space.display
      if displays[display_index] == nil then
        displays[display_index] = {
          number_of_spaces = 0,
        }
      end

      displays[display_index].number_of_spaces = displays[display_index].number_of_spaces + 1
      if space["has-focus"] then
        displays[display_index].current_space = space.index
      end
    end
    new_data.displays = displays
    new_data.number_of_displays = #displays

    old_data = data
    data = new_data

    sbar.trigger("update_data_finished")
  end)
end

local spaces = {}

function create_space(space_index, name_suffix)
  local space = sbar.add("space", "new_space." .. space_index .. (name_suffix or ""), {
    space = space_index,
    icon = {
      font = { family = settings.font.numbers },
      highlight_color = 0xffffffff,
      align = "center",
      width = 30,
      string = space_index,
      color = colors.white,
    },
    label = {
      drawing = false,
    },
    position = bar_position,
    drawing = false,
  })

  space:subscribe("mouse.clicked", function(env)
    local op = (env.BUTTON == "right") and "--destroy" or "--focus"
    sbar.exec("/run/current-system/sw/bin/yabai -m space " .. op .. " " .. env.SID)
    if op == "--destroy" then
      display_index = env.DID + 1
      data.total_number_of_spaces = data.total_number_of_spaces - 1
      data.displays[display_index].number_of_spaces = data.displays[display_index].number_of_spaces - 1
      sbar.trigger("update_position", {
        display_index = display_index,
        disable_animations = true,
      })
    end
  end)

  space:subscribe("mouse.exited", function(_)
    space:set({ popup = { drawing = false } })
  end)

  return space
end

local space_highlighters = {}

function create_highlighter(display_index)
  highlighter = sbar.add("item", "space_highlighter." .. display_index, {}, {
    display = display_index,
    width = 22,
    background = {
      color = colors.pink,
      corner_radius = 11,
      height = 22,
      drawing = true,
    },
    padding_left = 0,
    position = 'left',
    drawing = false,
  })
  
  space_highlighters[display_index] = highlighter

  if display_index > 1 then
    sbar.exec("sketchybar --move space_highlighter." .. display_index .. " after space_highlighter." .. (display_index - 1))
  end

  return highlighter
end

local hacks = {}

function create_measurement_hack(display_index)
  hack = sbar.add("item", "measurement_hack." .. display_index, {}, {
    display = display_index,
    width = 0,
    background = {
      height = 1,
      drawing = true,
    },
    padding_left = 0,
    position = 'left',
    drawing = true,
  })
  
  hacks[display_index] = hack

  if display_index > 0 then
    sbar.exec("sketchybar --move measurement_hack." .. display_index .. " before space_highlighter." .. display_index)
  end

  return hack
end

local space_bracket

function create_bracket()
  space_bracket = sbar.add("bracket", "space_bracket", { '/new_space\\..*/' }, {
    blur_radius = 2,
    background = {
      color = colors.background,
      corner_radius = 15,
      border_width = 1,
      border_color = colors.pink,
      height = 30,
      drawing = true,
    },
    position = bar_position,
    drawing = true,
  })
end

create_highlighter(1)
create_measurement_hack(1)
create_highlighter(2)
create_measurement_hack(2)

for i = 1, 10, 1 do
  if spaces[i] == nil then
    spaces[i] = create_space(i)
  end
end

create_bracket()

local space_window_observer = sbar.add("item", {
  drawing = false,
  updates = true,
})

space_window_observer:subscribe("update_data_finished", function(event)
  for display_index, display in ipairs(data.displays) do
    if space_highlighters[display_index] == nil then
      create_highlighter(display_index)
      create_measurement_hack(display_index)
    end

    space_bracket:set({ drawing = true })
    for i = 1, #spaces, 1 do
      spaces[i]:set({ drawing = true })
    end

    sbar.trigger("update_position", {
      display_index = display_index,
    })
  end
end)

function calculate_padding(display_index, number_of_spaces, current_space)
  first_space_on_display = nil
  for _, space in ipairs(data.spaces) do
    if space.display == display_index then
      first_space_on_display = space.index
      break
    end
  end
  if hacks[display_index] == nil then
    create_measurement_hack(display_index)
  end
  display_starting_coordinate = hacks[display_index]:query().bounding_rects["display-" .. display_index].origin[1] - 6
  offset = spaces[first_space_on_display]:query().bounding_rects["display-" .. display_index].origin[1]
  return offset - display_starting_coordinate + 30 * ((current_space - first_space_on_display)) - 2
end

space_window_observer:subscribe("update_position", function(event)
  display_index = tonumber(event.display_index)
  disable_animations = event.disable_animations == "on"

  highlighter = space_highlighters[display_index]
  current_space = data.displays[display_index].current_space 
  number_of_spaces = data.displays[display_index].number_of_spaces

  highlighter_info = highlighter:query()

  if current_space == nil then
    if highlighter_info.geometry.drawing == "on" and highlighter_info.geometry.width ~= 0 and not disable_animations then
      highlighter:set({
        drawing = true,
        background = {
          drawing = true,
        },
        width = 22,
      })
      old_position = highlighter_info.geometry.padding_left
      sbar.animate("tanh", 10, function()
        highlighter:set({
          width = 0,
          padding_left = old_position + 11,
        })
      end)
    else
      highlighter:set({
        background = {
          drawing = false,
        },
        drawing = false,
      })
    end
    return
  end

  position = calculate_padding(display_index, number_of_spaces, current_space)

  if highlighter_info.geometry.drawing == "off" or highlighter_info.geometry.width == 0 then
    if disable_animations then
      highlighter:set({
        drawing = true,
        background = {
          drawing = true,
        },
        width = 22,
        padding_left = position,
      })
    else
      highlighter:set({
        padding_left = position + 11,
        drawing = true,
        background = {
          drawing = true,
        },
        width = 0,
      })
      sbar.animate("tanh", 10, function()
        highlighter:set({
          width = 22,
          padding_left = position,
        })
      end)
    end
    return
  end

  if disable_animations then
    highlighter:set({
      padding_left = position,
      background = {
        drawing = true,
      },
      drawing = true,
      width = 22,
    })
  else
    sbar.animate("tanh", 10, function()
      highlighter:set({
        padding_left = position,
        background = {
          drawing = true,
        },
        drawing = true,
        width = 22,
      })
    end)
  end
end)

space_window_observer:subscribe("space_change", function(env)
  -- DID can be nil
  if env.DID == nil then
    return
  end

  display_index = env.DID + 1
  selected_space = env.INFO["display-" .. display_index]

  if space_highlighters[display_index] == nil then
    create_highlighter(display_index)
  end

  if data == nil or data.displays == nil or data.displays[display_index] == nil then
    return
  end
  
  if data.displays[display_index].current_space ~= selected_space then
    data.displays[display_index].current_space = selected_space
    sbar.trigger("update_position", {
      display_index = display_index,
    })
  end

  update_data()
end)

-- space_window_observer:subscribe("space_windows_change", function(env)
--   local icon_line = ""
--   local no_app = true
  
--   for app, count in pairs(env.INFO.apps) do
--     no_app = false
--     local lookup = app_icons[app]
--     local icon = ((lookup == nil) and app_icons["Default"] or lookup)
--     icon_line = icon_line .. icon
--   end

--   if (no_app) then
--     icon_line = " —"
--   end

--   -- sbar.animate("tanh", 10, function()
--   --   spaces[env.INFO.space]:set({ label = icon_line })
--   -- end)
-- end)

update_data()
