
NBMenuSimpleS = {}
local CreatedMenus = {}
local OpenedMenus = {}
local RegisteredEntrys = {}


NBMenuSimpleS.KeyContainer = Tasksync.KeyContainer
NBMenuSimpleS.KeyContainer.RegisterEntry("NBMenuSimpleS_Main")


NBMenuSimpleS.RegisterEntry = function(style, open, close)
   
	RegisteredEntrys[style] = {
		open   = open,
		close  = close
	}
end
NBMenuSimpleS.OpenWiths = {} 

NBMenuSimpleS.Create = function(style, namespace, name, data)
   
	local menu = {}
	local existedmenu = NBMenuSimpleS.GetCreated(style, namespace, name)
	if existedmenu then 
		-- take edit on the old menu instead create new one 
		menu = existedmenu
	else 
		table.insert(CreatedMenus, menu)
	end 
	menu.style      = style
	menu.namespace = namespace
	menu.name      = name
	menu.data      = data
	menu.data._style = style
	menu.data._namespace = namespace
	menu.data._name = name
	menu.close = function()
		if RegisteredEntrys[style] and RegisteredEntrys[style].close then RegisteredEntrys[style].close(namespace, name) end 
		NBMenuSimpleS.Close(style, namespace, name, true)
	end
	menu.open = function() 
		if not NBMenuSimpleS.IsOpened(menu.style,menu.namespace,menu.name) then 
			if #OpenedMenus > 0 then 
				OpenedMenus[#OpenedMenus].close()
			end 
			table.insert(OpenedMenus, menu)
		end 
		if RegisteredEntrys[style] and RegisteredEntrys[style].open then RegisteredEntrys[style].open(namespace, name, menu.data) end
	end 
	menu.refresh = function()
		if menu.open then menu.open() end
	end
	menu.updateData = function(self,data)
		NBMenuSimpleS.UpdateCreatedData(self.style,self.namespace,self.name,data)
		NBMenuSimpleS.UpdateOpenedData(self.style,self.namespace,self.name,data)
	end
	menu.On = function(self,style,fn) -- :
		local style = string.lower(style)
		menu["on"..style] = fn
	end 
	menu.Button = function(self,slot,fn) -- :
		menu["button"..tostring(slot)] = fn 
	end 
	menu.Call = function(self,calltype,value,...) -- :
		local calltype = string.lower(calltype)
		local value = string.lower(value)
		return menu[calltype..value] and menu[calltype..value](...)
	end 
	menu.OpenWith = function(self,key,description,inputcate) -- :
		if not NBMenuSimpleS.OpenWiths[key] then NBMenuSimpleS.OpenWiths[key] = {} end 
        NBMenuSimpleS.KeyContainer.Create("NBMenuSimpleS_Main","NBMenuSimpleS_Main_"..key,{
            keys = {
                {key,inputcate}
            },
            cbs = {
                {key,"JUST_PRESSED",function(inputkey,outputcbtype,outputlinked) 
                
                if outputcbtype == "JUST_PRESSED" and inputkey == key then 
                    if NBMenuSimpleS.GetCreated(style, namespace, name) then 
                        NBMenuSimpleS.GetCreated(style, namespace, name).open()
                    end 
                end 
			end , "fuck"},
            }

            
        })
        NBMenuSimpleS.KeyContainer.SetGroupNamespaceActive("NBMenuSimpleS_Main","NBMenuSimpleS_Main_"..key,true)
		
		
	end 
	menu.OpenWithHolding = function(self,key,delay,description,inputcate) -- :
		if not NBMenuSimpleS.OpenWiths[key] then NBMenuSimpleS.OpenWiths[key] = {} end 
        NBMenuSimpleS.KeyContainer.Create("NBMenuSimpleS_Main","NBMenuSimpleS_Main_holding"..key,{
            keys = {
                {key,inputcate}
            },
            cbs = {
                {key,"JUST_HOLDED",function(inputkey,outputcbtype,outputlinked) 
                    if outputcbtype == "JUST_HOLDED" and inputkey == key then 
                        if NBMenuSimpleS.GetCreated(style, namespace, name) then 
                            NBMenuSimpleS.GetCreated(style, namespace, name).open()
                        end 
                    end 
                end}
            }
        })
        NBMenuSimpleS.KeyContainer.SetGroupNamespaceActive("NBMenuSimpleS_Main","NBMenuSimpleS_Main_holding"..key,true)
	end 
	

	return menu
end
NBMenuSimpleS.New = NBMenuSimpleS.Create
local _return_ = function(_M_, style, namespace, name, isdelete, isclose)
	for i=1, #_M_, 1 do
		if _M_[i] then
			if _M_[i].style == style and _M_[i].namespace == namespace and _M_[i].name == name then
				if isclose then _M_[i].close() end 
				if isdelete then table.remove(_M_,i); return end 
				return _M_[i]
			end
		end
	end
end 
local _delete_local = function(_M_, style, namespace, name, iscloseNeeded)
	_return_(_M_, style, namespace, name, true, iscloseNeeded)
end 

NBMenuSimpleS.GetCreated = function(style, namespace, name)
	return _return_(CreatedMenus,style, namespace, name)
end
NBMenuSimpleS.GetCreatedMenus = function()
	return CreatedMenus
end
NBMenuSimpleS.IsCreated = function(style, namespace, name)
	return NBMenuSimpleS.GetCreated(style, namespace, name) ~= nil
end
NBMenuSimpleS.UpdateCreatedData = function(style, namespace, name, data)
	local menu,slot = _return_(CreatedMenus,style, namespace, name, false, false )
	if menu then 
		menu.data = data
	end 
end
NBMenuSimpleS.Remove = function(style, namespace, name)
	_delete_local(CreatedMenus,style, namespace, name)
end
NBMenuSimpleS.GetOpened = function(style, namespace, name)
	return _return_(OpenedMenus,style, namespace, name)
end
NBMenuSimpleS.GetOpenedMenus = function()
	return OpenedMenus
end
NBMenuSimpleS.IsOpened = function(style, namespace, name)
	return NBMenuSimpleS.GetOpened(style, namespace, name) ~= nil
end
NBMenuSimpleS.UpdateOpenedData = function(style, namespace, name, data)
	local menu = _return_(OpenedMenus,style, namespace, name, false, false )
	if menu then 
		menu.data = data
	end 
end
NBMenuSimpleS.Close = function(style, namespace, name, DontClose)
	_delete_local(OpenedMenus,style, namespace, name, not DontClose)
end
NBMenuSimpleS.CloseAll = function()
	for i=1, #OpenedMenus, 1 do
		if OpenedMenus[i] then
			OpenedMenus[i].close()
			OpenedMenus[i] = nil
		end
	end
end