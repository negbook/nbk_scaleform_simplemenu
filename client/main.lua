
local MenuStyle = "scaleform2dnativemenu"

local CurrentMenuInfo = {}
local getCurrentFocused = function()
	return CurrentMenuInfo;
end 
local shared_cb = function(INPUT,INPUTCATE,input)
	
	local action = {}
   
	action["up"] = function()
		local slot = NBNativeMenuS.DrawGetFocusSlot() 
		--PlaySound(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
		--local newselection = selection --NBNativeMenuS.DrawSetFocusSlot(selection - 1)
		local focused = getCurrentFocused()
		if not focused then return end 
		local menu = NBMenuSimpleS.GetCreated(MenuStyle, focused.namespace, focused.name)
		local currentdata = {
			slot = slot,
			data = menu.data.buttons[slot]
		}
		menu:Call("on","change",currentdata)
		menu:updateData(menu.data)
      
		return slot
	end 
	action["down"] = function()
		local slot = NBNativeMenuS.DrawGetFocusSlot() 
		--PlaySound(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
		--local slot = selection --NBNativeMenuS.DrawSetFocusSlot(selection + 1)
		local focused = getCurrentFocused()
		if not focused then return end 
		local menu = NBMenuSimpleS.GetCreated(MenuStyle, focused.namespace, focused.name)
		local currentdata = {
			slot = slot,
			data = menu.data.buttons[slot]
		}
		menu:Call("on","change",currentdata)
		menu:updateData(menu.data)
      
		return slot
	end 
	action["left"] = function()
		local slot =  NBNativeMenuS.DrawGetFocusSlot()
		local _slotselection = NBNativeMenuS.DrawGetSlotSelection(slot) 
		
		local isoptions = NBNativeMenuS.DrawGetButtonOptions(slot)
		
		if isoptions then
			local slotselection = NBNativeMenuS.DrawSetSlotSelection(slot,_slotselection - 1)
			local focused = getCurrentFocused()
			if not focused then return end 
			local menu = NBMenuSimpleS.GetCreated(MenuStyle, focused.namespace, focused.name)
			local currentdata = {
				slot = slot,
				data = menu.data.buttons[slot],
				slotselection = slotselection
			}
			menu:Call("on","change",currentdata)
			menu:updateData(menu.data)
         if UpdateRender then UpdateRender() end
			return slotselection
		end 
	end 
	action["right"] = function()
		local slot =  NBNativeMenuS.DrawGetFocusSlot()
		local _slotselection = NBNativeMenuS.DrawGetSlotSelection(slot) 
		
		local isoptions = NBNativeMenuS.DrawGetButtonOptions(slot)
		if isoptions then
			local slotselection = NBNativeMenuS.DrawSetSlotSelection(slot,_slotselection + 1)
			local focused = getCurrentFocused()
			if not focused then return end 
			local menu = NBMenuSimpleS.GetCreated(MenuStyle, focused.namespace, focused.name)
			local currentdata = {
				slot = slot,
				data = menu.data.buttons[slot],
				slotselection = slotselection
			}
			menu:Call("on","change",currentdata)
			menu:updateData(menu.data)
         if UpdateRender then UpdateRender() end
			return slotselection
		end
	end 

	action["return"] = function()
		--PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
		local slot =  NBNativeMenuS.DrawGetFocusSlot()
		local slotselection = NBNativeMenuS.DrawGetSlotSelection(slot) 
		local focused = getCurrentFocused()
		if not focused then return end 
		local menu = NBMenuSimpleS.GetCreated(MenuStyle, focused.namespace, focused.name)
		if not menu.data.buttons[slot].disable then 
			local options = menu.data.buttons[slot].options
			local actionoptions = menu.data.buttons[slot].actions
			local crossed = menu.data.buttons[slot].crossed
			local ticked = menu.data.buttons[slot].ticked
		
			if crossed~= nil then menu.data.buttons[slot].crossed = not menu.data.buttons[slot].crossed end 
			if ticked~= nil then menu.data.buttons[slot].ticked = not menu.data.buttons[slot].ticked end 
			if options and not actionoptions then 
				action["right"]()
			else 
				local currentdata = {
					slot = slot,
					data = menu.data.buttons[slot],
					slotselection = slotselection
				}
				menu:Call("on","select",currentdata,menu)
				menu:Call("button",tostring(slot),options or actionoptions,slotselection,menu)
			end 
		end 
		menu:updateData(menu.data)
      if UpdateRender then UpdateRender() end
		return 1
	end 
	action["back"] = function()
		--PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
		local slot =  NBNativeMenuS.DrawGetFocusSlot()
		local slotselection = NBNativeMenuS.DrawGetSlotSelection(slot) 
		local focused = getCurrentFocused()
		if not focused then return end 
		local menu = NBMenuSimpleS.GetCreated(MenuStyle, focused.namespace, focused.name)
		local currentdata = {
			slot = slot,
			data = menu.data.buttons[slot],
			slotselection = slotselection
		}
		menu:Call("on","back",currentdata,menu)
      if UpdateRender then UpdateRender() end
		return 1
	end 
	local t = action[input] and action[input]()
   
   return t 
end

NBMenuSimpleS.KeyContainer.RegisterEntry("SCALEFORM2DNATIVEMENU")
NBMenuSimpleS.KeyContainer.Create("SCALEFORM2DNATIVEMENU","SCALEFORM2DNATIVEMENU_MAIN_KEY",{
	keys = {
		--{"TAB"},
		{"BACK"},
		--{"SPACE"},
		{"ESCAPE"},
		{"RETURN"},
		{"UP"},
		{"DOWN"},
		{"LEFT"},
		{"RIGHT"},
		{"LUP_INDEX","PAD_DIGITALBUTTON"},
		{"LDOWN_INDEX","PAD_DIGITALBUTTON"},
		{"LLEFT_INDEX","PAD_DIGITALBUTTON"},
		{"LRIGHT_INDEX","PAD_DIGITALBUTTON"},
		{"RDOWN_INDEX","PAD_DIGITALBUTTON"},
		{"RRIGHT_INDEX","PAD_DIGITALBUTTON"},
	},
	cbs = {
		{"BACK","JUST_PRESSED",shared_cb,"back"},
		{"UP","JUST_PRESSED",shared_cb,"up"},
		{"DOWN","JUST_PRESSED",shared_cb,"down"},
		{"LEFT","JUST_PRESSED",shared_cb,"left"},
		{"RIGHT","JUST_PRESSED",shared_cb,"right"},
		--{"SPACE","JUST_PRESSED",shared_cb,"return"},
		{"RETURN","JUST_RELEASED",shared_cb,"return"},
		{"UP","PRESSED",shared_cb,"up"},
		{"DOWN","PRESSED",shared_cb,"down"},
		{"LEFT","PRESSED",shared_cb,"left"},
		{"RIGHT","PRESSED",shared_cb,"right"},

		{"LUP_INDEX","JUST_PRESSED",shared_cb,"up"},
		{"LDOWN_INDEX","JUST_PRESSED",shared_cb,"down"},
		{"LLEFT_INDEX","JUST_PRESSED",shared_cb,"left"},
		{"LRIGHT_INDEX","JUST_PRESSED",shared_cb,"right"},
		{"LUP_INDEX","PRESSED",shared_cb,"up"},
		{"LDOWN_INDEX","PRESSED",shared_cb,"down"},
		{"LLEFT_INDEX","PRESSED",shared_cb,"left"},
		{"LRIGHT_INDEX","PRESSED",shared_cb,"right"},
		{"RDOWN_INDEX","JUST_PRESSED",shared_cb,"return"},
		{"RRIGHT_INDEX","JUST_PRESSED",shared_cb,"back"},
	}
})

local oldselection,newselection 
local openMenu = function(namespace, name, data)
	NBMenuSimpleS.KeyContainer.SetGroupNamespaceActive("SCALEFORM2DNATIVEMENU","SCALEFORM2DNATIVEMENU_MAIN_KEY",true)
	NBNativeMenuS.DrawInit( data )
	local buttonnames = {} 
	for i=1,#data.buttons do 
		local v = data.buttons[i]
		table.insert(buttonnames,v.name)
	end
	NBNativeMenuS.DrawSetButtons(table.unpack(buttonnames))
	for i=1,#data.buttons do 
		local v = data.buttons[i]
		if v.description then 
			NBNativeMenuS.DrawSetButtonDescription(i,v.description)
		end 
		if v.options or v.actions then 
			local opt = v.options or v.actions
			NBNativeMenuS.DrawSetButtonOptions(i,table.unpack(opt))
			--if v.selected then NBNativeMenuS.DrawSetSlotSelection(i,v.selected) end
		end 
		
		if v.ticked ~= nil then 
			local iconstyle = 4
			NBNativeMenuS.DrawSetButtonIcon(i,iconstyle)
			local icon,hasHighlight = NBNativeMenuS.DrawGetIconNameFromIconIDByHighLightSate(iconstyle)
			NBNativeMenuS.DrawSetButtonIconChangable(i)
			NBNativeMenuS.DrawSetButtonIconChecked(i,v.ticked)
		elseif v.crossed ~= nil then 
			local iconstyle = 5
			NBNativeMenuS.DrawSetButtonIcon(i,iconstyle)
			local icon,hasHighlight = NBNativeMenuS.DrawGetIconNameFromIconIDByHighLightSate(iconstyle)
			NBNativeMenuS.DrawSetButtonIconChangable(i)
			NBNativeMenuS.DrawSetButtonIconChecked(i,v.crossed)
		
		elseif v.icon then 
			NBNativeMenuS.DrawSetButtonIcon(i,v.icon)
		end 
		if v.disable then 
			NBNativeMenuS.DrawSetButtonDisable(i, v.disable)
		end 
		if v.righttext then 
			NBNativeMenuS.DrawSetButtonOptions(i,v.righttext)
		end 
	end 
	--NBNativeMenuS.DrawSetSelection(data.selected.y,data.selected.x)
   NBNativeMenuS.DrawRender()
	CurrentMenuInfo = {namespace=namespace,name=name}
end
local closeMenu = function(namespace, name)
	NBMenuSimpleS.KeyContainer.SetGroupNamespaceActive("SCALEFORM2DNATIVEMENU","SCALEFORM2DNATIVEMENU_MAIN_KEY",false)
	NBNativeMenuS.DrawEnd()
	if CurrentMenuInfo and CurrentMenuInfo.namespace == namespace and  CurrentMenuInfo.name == name then 
		CurrentMenuInfo = nil 
	end 
end

NBMenuSimpleS.RegisterEntry(MenuStyle, openMenu, closeMenu)


CreateSimpleMenuS = function(...)
   local namespace,name,data = ...
   return NBMenuSimpleS.Create(MenuStyle,namespace,name,data) 
end 

exports('CreateSimpleMenuS',CreateSimpleMenuS)	