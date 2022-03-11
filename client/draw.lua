


NBNativeMenuS = {}
local DrawsButtons = {}
local DrawsButtonDescriptions = {}
local DrawsButtonIcons = {}
local DrawsButtonDisables = {}
local DrawsButtonOptions = {}
local DrawsButtonIconChangables = {}
local DrawsButtonIconCheckeds = {}
local DrawsMenuSlotSelection = {}
local DrawsTitle = ""
local DrawsSubtitle = ""
local DrawsMaxslot = 7
local DrawsShouldScroll = false
local DrawsisRendering = false
local DrawsSelection = 1
local DrawsShowGlare = false
local DrawsStyle = 1
local rects = {} 
local sprites = {} 
local texts = {} 

local BUTTONS = {} 
local BUTTONARRAYS = {}
local ICONS = {}

local shared_cb_draw = function(INPUT,INPUTCATE,input)
	
	local action = {}
	action["up"] = function()
		local selection = NBNativeMenuS.DrawGetFocusSlot() 
		PlaySound(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
		local newselection = NBNativeMenuS.DrawSetFocusSlot(selection - 1)
      
		return newselection
	end 
	action["down"] = function()
		local selection = NBNativeMenuS.DrawGetFocusSlot() 
		PlaySound(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
		local newselection = NBNativeMenuS.DrawSetFocusSlot(selection + 1)
      
		return newselection
	end 
   action["left"] = function()
      PlaySound(-1, "NAV_LEFT_RIGHT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
      
   end 
   action["right"] = function()
      PlaySound(-1, "NAV_LEFT_RIGHT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
      
   end 
	action["return"] = function()
		local slot =  NBNativeMenuS.DrawGetFocusSlot()
		local changable = NBNativeMenuS.DrawGetButtonIconChangable(slot)
		local checked = NBNativeMenuS.DrawGetButtonIconChecked(slot)
		if changable then 
			NBNativeMenuS.DrawSetButtonIconChecked(slot,not checked)

		end 
		PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
      
		return 1
	end 
	action["back"] = function()
		PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
      
		return 1
	end 
	local t = action[input] and action[input]()
   
   if UpdateRender then UpdateRender() end
   return t 
end

NBMenuSimpleS.KeyContainer.RegisterEntry("SCALEFORM2DNATIVEMENU")
NBMenuSimpleS.KeyContainer.Create("SCALEFORM2DNATIVEMENU","DRAW_SCALEFORM2DNATIVEMENU_KEY",{
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
		{"BACK","JUST_PRESSED",shared_cb_draw,"back"},
		{"UP","JUST_PRESSED",shared_cb_draw,"up"},
		{"DOWN","JUST_PRESSED",shared_cb_draw,"down"},
		{"LEFT","JUST_PRESSED",shared_cb_draw,"left"},
		{"RIGHT","JUST_PRESSED",shared_cb_draw,"right"},
		--{"SPACE","JUST_PRESSED",shared_cb_draw,"return"},
		{"RETURN","JUST_RELEASED",shared_cb_draw,"return"},
		{"UP","PRESSED",shared_cb_draw,"up"},
		{"DOWN","PRESSED",shared_cb_draw,"down"},
		{"LEFT","PRESSED",shared_cb_draw,"left"},
		{"RIGHT","PRESSED",shared_cb_draw,"right"},
		{"LUP_INDEX","JUST_PRESSED",shared_cb_draw,"up"},
		{"LDOWN_INDEX","JUST_PRESSED",shared_cb_draw,"down"},
		{"LLEFT_INDEX","JUST_PRESSED",shared_cb_draw,"left"},
		{"LRIGHT_INDEX","JUST_PRESSED",shared_cb_draw,"right"},
		{"LUP_INDEX","PRESSED",shared_cb_draw,"up"},
		{"LDOWN_INDEX","PRESSED",shared_cb_draw,"down"},
		{"LLEFT_INDEX","PRESSED",shared_cb_draw,"left"},
		{"LRIGHT_INDEX","PRESSED",shared_cb_draw,"right"},
		{"RDOWN_INDEX","JUST_PRESSED",shared_cb_draw,"return"},
		{"RRIGHT_INDEX","JUST_PRESSED",shared_cb_draw,"back"},
	}
})


local menuWidth = 0.240
local titleHeight = 0.085
local buttonHeight = 0.038
local buttonFont = 0
local buttonScale = 0.365
local buttonTextXOffset = 0.005
local buttonTextYOffset = 0.005
local basicx = 0.085
local basicy = 0.096
getmenuWidth = function() 
	return _scale(menuWidth) 
end 
gettitleHeight = function() 
	local th = _scale(titleHeight) 
	return th
end 
getbuttonHeight = function() 
	local n = _scale(buttonHeight) 
	return n
end 
getbuttonScale = function() 
	local n = _scale(buttonScale) 
	return n
end 
local AspectRatio = 1.777778
function _scale(valuetoscale)
	valuetoscale = (valuetoscale * (1.777778 / AspectRatio));
	return valuetoscale;
end
Tasksync.addlooponce("checkAspectRatio",500,function()
	AspectRatio = GetAspectRatio(false)
end)
local getbasicRectDrawingX = function() return (basicx + getmenuWidth() / 2) end 
local getbasicbuttony = function() return (basicy + gettitleHeight() + buttonTextYOffset) end 
local basicfont = "$Font2"
local buttonTransparent = 140
local lastY
local function _ResetRects(y)
	lastY = y
end 
local function _drawMenuRectSubtitle(height, color, offsetY, alpha)
	local y = lastY + (offsetY or 0.0)
	local r,g,b,a = GetHudColour(color)
   --table.insert(rects,DrawRectS(getbasicRectDrawingX(), y + height / 2, getmenuWidth(), height, r, g, b, (alpha or a)))
   DrawRectSF("subtitle",getbasicRectDrawingX(), y + height / 2, getmenuWidth(), height, r, g, b, (alpha or a))
	lastY = y + height 
	return lastY
end
local function _drawMenuRectDesc(height, color, offsetY, alpha)
	local y = lastY + (offsetY or 0.0)
	local r,g,b,a = GetHudColour(color)
   DrawRectSF("rectDesc",getbasicRectDrawingX(), y + height / 2, getmenuWidth(), height, r, g, b, (alpha or a))
	lastY = y + height 
	return lastY
end
local function _drawMenuRectScroll(height, color, offsetY, alpha)
	local y = lastY + (offsetY or 0.0)
	local r,g,b,a = GetHudColour(color)
   DrawRectSF("rectScroll",getbasicRectDrawingX(), y + height / 2, getmenuWidth(), height, r, g, b, (alpha or a))
	lastY = y + height 
	return lastY
end

local function _drawMenuSpriteTitle(sprite, height, color, offsetY, alpha)
	local y = lastY + (offsetY or 0.0)
	local r,g,b,a = GetHudColour(color)
   --table.insert(sprites,DrawSpriteSF("title","CommonMenu", sprite ,getbasicRectDrawingX(),y + height / 2,getmenuWidth(), height,0, r, g, b, (alpha or a)))
   if not IsDrawingSF("title") then 
      DrawSpriteSF("title","CommonMenu", sprite ,getbasicRectDrawingX(),y + height / 2,getmenuWidth(), height,0, r, g, b, (alpha or a))
   end 
	lastY = y + height 
	return lastY
end
local function _drawMenuSpriteButtonBG(sprite, height, color, offsetY, alpha)
	local y = lastY + (offsetY or 0.0)
	local r,g,b,a = GetHudColour(color)
   --table.insert(sprites,DrawSpriteS("CommonMenu", sprite ,getbasicRectDrawingX(),y + height / 2,getmenuWidth(), height,0, r, g, b, (alpha or a)))
   DrawSpriteSF("ButtonBG","CommonMenu", sprite ,getbasicRectDrawingX(),y + height / 2,getmenuWidth(), height,0, r, g, b, (alpha or a))
	lastY = y + height 
	return lastY
end
local function _drawMenuSpriteDesc(sprite, height, color, offsetY, alpha)
	local y = lastY + (offsetY or 0.0)
	local r,g,b,a = GetHudColour(color)
   DrawSpriteSF("spriteDesc","CommonMenu", sprite ,getbasicRectDrawingX(),y + height / 2,getmenuWidth(), height,0, r, g, b, (alpha or a))
	lastY = y + height 
	return lastY
end

local function _drawMenuSpriteHighLight(y, height, color, offsetY, alpha)
	local r,g,b,a = GetHudColour(color)
   local d,n = "CommonMenu", "Gradient_Nav"
   
	DrawSpriteSF("HightLight",d, n ,getbasicRectDrawingX(),y + height / 2,getmenuWidth(),height,0, r,g,b,(alpha or a))
end
local function _drawTextXYButtonArray(n,text,x,y,color,font,scale)
    if not IsDrawingSF("ButtonArray"..n) then 
       t = DrawTextSF("ButtonArray"..n,text, x + buttonTextXOffset, y, scale)
       table.insert(BUTTONARRAYS,"ButtonArray"..n)
    else 
       t = DrawTextSF("ButtonArray"..n,text, x + buttonTextXOffset, y, scale)
    end 
    TextDrawColor(t,GetHudColour(color))
    return t 
end 

local function _drawTextXY(text,x,y,color,font,scale)
    local t = DrawTextS(text,x,y,scale)
    table.insert(texts,t)
    TextDrawColor(t,GetHudColour(color))
    return t 
end 
local function _drawMenuTextSubtitle(text, x, y, font, color, scale)
    local t = DrawTextSF("textSubtitle",text, x + buttonTextXOffset, y, scale)
    TextDrawFont(t,"$Font2")
    TextDrawColor(t,GetHudColour(color))
end
local function _drawMenuTextDesc(text, x, y, font, color, scale)
    local t = DrawTextSF("textDesc",text, x + buttonTextXOffset, y, scale)
    TextDrawFont(t,"$Font2")
    TextDrawColor(t,GetHudColour(color))
end
local function _drawMenuTextButton(n,text, x, y, font, color, scale)
    local t
    if not IsDrawingSF("textButton"..n) then 
       t = DrawTextSF("textButton"..n,text, x + buttonTextXOffset, y, scale)
       table.insert(BUTTONS,"textButton"..n)
    else 
       t = DrawTextSF("textButton"..n,text, x + buttonTextXOffset, y, scale)
    end 
    TextDrawFont(t,"$Font2")
    TextDrawColor(t,GetHudColour(color))
    
end
local function _drawMenuText(text, x, y, font, color, scale)
    _drawTextXY(text, x + buttonTextXOffset, y, color,font,scale)
end
local function _drawMenuTextTitle(text, x, y, font, color, scale)
    local t = DrawTextSF("textTitle",text, x + buttonTextXOffset, y, scale)
    TextDrawFont(t,"$Font2")
    TextDrawColor(t,GetHudColour(color))
    TextDrawShadow(t, 0, 0, 0, 255, 2, 2, 200)
end
local function _drawMenuTextSubtitleRight(text, x, y, font, color, scale)
    local t = DrawTextSF("textSubtitleRight",text, x, y, scale)
    TextDrawFont(t,"$Font2")
    TextDrawColor(t,GetHudColour(color))
    TextDrawWrap(t,basicx, basicx + getmenuWidth() - buttonTextXOffset)
    TextDrawRight(t,true)
end
local function _drawMenuTextArray(text, x, y, width, font, color, scale, rightstyle, leftrighticon,n)
	local styles = {}
	local RIGHT_TEXT_ARRAY,RIGHT_TEXT_ONLY,RIGHT_TEXT_EMPTY = 3,2,1
	styles[RIGHT_TEXT_ARRAY] = function()
		if leftrighticon then 
			_drawTextXYButtonArray(n,text, x + getmenuWidth() - width - (buttonTextXOffset * 3.5), y, color, font, scale)
		else 
			_drawTextXYButtonArray(n,text, x + getmenuWidth() - width - (buttonTextXOffset * 1), y, color, font, scale)
		end 
	end 
	styles[RIGHT_TEXT_ONLY] = function()
		_drawTextXYButtonArray(n,text, x + getmenuWidth() - width - (buttonTextXOffset * 1), y, color, font, scale)
	end 
	styles[RIGHT_TEXT_EMPTY] = function()
      _drawTextXYButtonArray(n,"", x + getmenuWidth() - width - (buttonTextXOffset * 1), y, color, font, scale)
		--_drawTextXY(text, x + getmenuWidth() - width - (buttonTextXOffset * 2.5), y, color, font, scale)
	end 
	styles[rightstyle]()
end 
local function _drawMenuIcon_Right(y,iconName,isDiffIcon,isIconChecked,rightstyle,width,ishighlight,n)
	local styles = {}
	local RIGHT_TEXT_ARRAY,RIGHT_TEXT_ONLY,RIGHT_TEXT_EMPTY = 3,2,1
	local drawedLeftRight = false 
   
	styles[RIGHT_TEXT_EMPTY] = function(iconName,isDiffIcon)
		local height = _scale(0.032)
         local t = DrawSpriteSF("IconRight"..n,"CommonMenu", iconName ,basicx + getmenuWidth() - (buttonTextXOffset * 2.5) + 0.0,y + height / 2, getbuttonHeight()/AspectRatio, getbuttonHeight(),0, GetHudColour((ishighlight and not IconChecked and not isDiffIcon) and 2 or 0))
         
         ICONS[n] = {t}
       
      
      --table.insert(sprites,DrawSpriteS("CommonMenu", iconName ,basicx + getmenuWidth() - (buttonTextXOffset * 2.5) + 0.0,y + height / 2, getbuttonHeight()/AspectRatio, getbuttonHeight(),0, GetHudColour((ishighlight and not IconChecked and not isDiffIcon) and 2 or 0)))
	end 
	styles[RIGHT_TEXT_ONLY] = function(iconName,isDiffIcon)
      
      --if ICONS[n] then for i,v in pairs(ICONS[n]) do DeleteSpriteS(v)  end  end 
      --ICONS[n] = nil
      --[[
         local height = _scale(0.032)

         local t = DrawSpriteSF("IconRight"..n.."$NULL","$NULL", "$NULL" ,basicx + getmenuWidth() - (buttonTextXOffset * 2.5) + 0.0,y + height / 2, getbuttonHeight()/AspectRatio, getbuttonHeight(),0, 0, 0, 0, 0)
         
         ICONS[n] = {t}
       --]]
		--local height = 0.032
		--DrawSpriteS("CommonMenu", iconName ,basicx + getmenuWidth() - (buttonTextXOffset * 4) + buttonTextXOffset * 2,y + height / 2, getbuttonHeight()/AspectRatio, getbuttonHeight(),0, GetHudColour((ishighlight and not IconChecked and not isDiffIcon) and 2 or 0))
	end 
	if width and rightstyle == RIGHT_TEXT_ARRAY then  
		if ishighlight then 
			local height = _scale(0.032)
            
            local t1 = DrawSpriteSF("IconRight"..n.."L"..GetGameTimer(),"CommonMenu", "arrowleft" ,basicx + getmenuWidth() - width - (buttonTextXOffset * 4),y + height / 2, getbuttonHeight()/AspectRatio, getbuttonHeight(),0, GetHudColour((ishighlight and not IconChecked) and 2 or 0))
            
            
          
         --table.insert(sprites,DrawSpriteS("CommonMenu", "arrowleft" ,basicx + getmenuWidth() - width - (buttonTextXOffset * 4),y + height / 2, getbuttonHeight()/AspectRatio, getbuttonHeight(),0, GetHudColour((ishighlight and not IconChecked) and 2 or 0)))
			
            local t2 = DrawSpriteSF("IconRight"..n.."R"..GetGameTimer(),"CommonMenu", "arrowright" ,basicx + getmenuWidth() - (buttonTextXOffset * 2),y + height / 2, getbuttonHeight()/AspectRatio, getbuttonHeight(),0, GetHudColour((ishighlight and not IconChecked) and 2 or 0))
            
            
         ICONS[n] = {t1,t2} 
         --table.insert(sprites,DrawSpriteS("CommonMenu", "arrowright" ,basicx + getmenuWidth() - (buttonTextXOffset * 2),y + height / 2, getbuttonHeight()/AspectRatio, getbuttonHeight(),0, GetHudColour((ishighlight and not IconChecked) and 2 or 0)))
			drawedLeftRight = true 
      else 

         
		end 
	else 
		if iconName then 
			if isIconChecked ~= nil  then 
				iconName = NBNativeMenuS.DrawGetChangedIconNameFromIconNameByChangedState(iconName,isIconChecked)
			end 
			styles[rightstyle](iconName,isDiffIcon)
      else 
         local height = _scale(0.032)
 
         local t = DrawSpriteSF("IconRight"..n.."$NULL","$NULL", "$NULL" ,basicx + getmenuWidth() - (buttonTextXOffset * 2.5) + 0.0,y + height / 2, getbuttonHeight()/AspectRatio, getbuttonHeight(),0, 0, 0, 0, 0)
         ICONS[n] = {t}
		end 
      
	end 
	return drawedLeftRight
end 
local _drawButton = function(y,text,ishighlight,ishovered,righttext, optionselected,IconChecked,isdisbale,iconName,isDiffIcon, n, latetasks)
	local r = {}
	r.x = basicx
	r.y = y
	r.width = getmenuWidth()
	r.height = getbuttonHeight()
	local colours = {
		black = 2,
		white = 0,
		grey = 3
	}
	local colours_back = {
		black = colours.white,
		white = colours.black
	}
	local sprite_colour = ishighlight and colours.white or colours.white
	local sprite_colour = ishovered and colours.grey or sprite_colour
	local text_colour = ishighlight and colours.black or colours.white 
	local text_colour = isdisbale and colours.grey or text_colour
   if ishighlight or ishovered then 
      _drawMenuSpriteHighLight(y ,getbuttonHeight(), sprite_colour, 0.0,ishovered and 180 or 255)
   end 
   table.insert(latetasks,function() 
   _drawMenuTextButton(n,text,basicx,y,buttonFont,text_colour,getbuttonScale(), true)
	
	
	local isRightArray = (righttext and #righttext > 1) 
	local isRightTextOnly = (righttext and #righttext == 1) 
	local width = 0
	local text = righttext and righttext[optionselected] or ""
	local RIGHT_TEXT_ARRAY,RIGHT_TEXT_ONLY,RIGHT_TEXT_EMPTY = 3,2,1
	local rightstyle = isRightArray and RIGHT_TEXT_ARRAY or (isRightTextOnly and RIGHT_TEXT_ONLY) or RIGHT_TEXT_EMPTY 
	if isRightArray or isRightTextOnly then 
		SetTextFont(buttonFont)
		SetTextScale(getbuttonScale(), getbuttonScale())
		BeginTextCommandGetWidth("STRING")
		AddTextComponentSubstringPlayerName(text)
		width = EndTextCommandGetWidth(true)
	end 
	local drawedLeftRight = _drawMenuIcon_Right(y,iconName,isDiffIcon,IconChecked,rightstyle,width,ishighlight,n)
	_drawMenuTextArray(text,basicx,y,width,buttonFont,text_colour,getbuttonScale(),rightstyle,drawedLeftRight,n)
   end)
	return r.x,r.y,r.width,r.height
end 
local _initMenuScroll = function()
   local y = _drawMenuRectScroll(getbuttonHeight(), 140, 0.002, 220)
	DrawSpriteSF("spriteScroll","CommonMenu", "shop_arrows_upANDdown", getbasicRectDrawingX(), y - getbuttonHeight() / 2, 0.032, getbuttonHeight(), 0, GetHudColour(0))
end 
local _setMenuDescription = function(desc)
	if desc then 
		_drawMenuRectDesc(0.0015, 2, 0.0050, 255)
      local y = _drawMenuSpriteDesc("Gradient_Bgd", getbuttonHeight(), 0, 0.0, 255)
		_drawMenuTextDesc(desc,basicx,y-getbuttonHeight() + 0.0025,buttonFont,0,getbuttonScale())
	end 
end 
NBNativeMenuS.DrawSetButtons = function(...)
	if not DrawsButtons then DrawsButtons = {} end 
	DrawsButtons = {...}
	if #DrawsButtons > DrawsMaxslot then DrawsShouldScroll = true 
	else DrawsShouldScroll = false  end 
	if not NBNativeMenuS.DrawGetFocusSlot() then 
		NBNativeMenuS.DrawSetFocusSlot(1)
	end 
end 
NBNativeMenuS.DrawGetButtons = function()
	return DrawsButtons 
end 
NBNativeMenuS.DrawSetButtonDescription = function(slot,description)
	if not DrawsButtonDescriptions then DrawsButtonDescriptions = {} end 
	DrawsButtonDescriptions[slot] = description
end 
NBNativeMenuS.DrawSetButtonOptions = function(slot,...)
	if not DrawsButtonOptions then DrawsButtonOptions = {} end 
	DrawsButtonOptions[slot] = {...}
	if not NBNativeMenuS.DrawGetSlotSelection(slot) then 
		NBNativeMenuS.DrawSetSlotSelection(slot, 1)
	end 
end 
NBNativeMenuS.DrawGetButtonOptions = function(slot)
	local bdo = DrawsButtonOptions
	local bdov = DrawsMenuSlotSelection
	return bdo and bdo[slot],bdov and bdov[slot] or 1
end 
NBNativeMenuS.DrawGetButtonDescription = function(slot)
	local bds = DrawsButtonDescriptions
	return bds and bds[slot]
end 
NBNativeMenuS.DrawSetButtonIcon = function(slot,icon)
	if not DrawsButtonIcons then DrawsButtonIcons = {} end 
	DrawsButtonIcons[slot] = icon
end 
NBNativeMenuS.DrawGetButtonIcon = function(slot)
	local bdicon = DrawsButtonIcons
	return bdicon and bdicon[slot]
end 
NBNativeMenuS.DrawSetButtonIconChangable = function(slot)
	if not DrawsButtonIconChangables then DrawsButtonIconChangables = {} end 
	DrawsButtonIconChangables[slot] = true
	NBNativeMenuS.DrawSetButtonIconChecked(slot,false)
end 
NBNativeMenuS.DrawGetButtonIconChangable = function(slot)
	local bicb = DrawsButtonIconChangables
	return bicb and bicb[slot]
end 
NBNativeMenuS.DrawSetButtonIconChecked = function(slot,bool)
	if not DrawsButtonIconCheckeds then DrawsButtonIconCheckeds = {} end 
	DrawsButtonIconCheckeds[slot] = bool
end 
NBNativeMenuS.DrawGetButtonIconChecked = function(slot)
	local bdictd = DrawsButtonIconCheckeds
	return bdictd and bdictd[slot]
end 
NBNativeMenuS.DrawSetButtonDisable = function(slot,isDisable)
	if not DrawsButtonDisables then DrawsButtonDisables = {} end 
	DrawsButtonDisables[slot] = isDisable
end 
NBNativeMenuS.DrawGetButtonDisable = function(slot)
	local bddsb = DrawsButtonDisables
	return bddsb and bddsb[slot]
end 
NBNativeMenuS.DrawSetSlotSelection = function(slot,selection_x)
	if not DrawsMenuSlotSelection then DrawsMenuSlotSelection = {} end 
	local options = NBNativeMenuS.DrawGetButtonOptions(slot)
	if options then 
		if options and #options >= 1 then 
			if selection_x <= 0 then 
				selection_x = (selection_x-1)%#options+1
			elseif selection_x > #options then 
				selection_x = selection_x%#options
				if selection_x <= 0 then 
					selection_x = (selection_x-1)%#options+1
				end 
			end 
		end 
	else 
		selection_x = 1
	end 
	DrawsMenuSlotSelection[slot] = selection_x 
	return DrawsMenuSlotSelection[slot] 
end 
NBNativeMenuS.DrawGetSlotSelection = function(slot)
	local slotselection = DrawsMenuSlotSelection and DrawsMenuSlotSelection and DrawsMenuSlotSelection[slot]
	return slotselection
end 
NBNativeMenuS.DrawSetFocusSlot = function(y)
	local buttons = NBNativeMenuS.DrawGetButtons()
	--if not x then x = 1 end  
	if not y then y = 1 end 
	if buttons and #buttons >= 1 then  
		if y <= 0 then 
			y = (y-1)%#buttons+1
		elseif y > #buttons then 
			y = y%#buttons
			if y <= 0 then 
				y = (y-1)%#buttons+1
			end 
		end 
	end 
	DrawsSelection = y
	return DrawsSelection
end 
NBNativeMenuS.DrawGetFocusSlot = function()
	local selection = DrawsSelection
	return selection
end 
NBNativeMenuS.DrawEnd = function()
	--Tasksync.deletelooponce("tasksync_loop_drawmenu")
   for i,v in pairs(rects) do 
      DeleteRectS(v)
   end 
   for i,v in pairs(sprites) do 
      DeleteSpriteS(v)
   end 
   for i,v in pairs(texts) do 
      DeleteTextS(v)
   end 
   DeleteSpriteSF("title")
   DeleteRectSF("subtitle")
   DeleteTextSF("textTitle")
   DeleteTextSF("textSubtitle")
   DeleteTextSF("textSubtitleRight")
   
   DeleteSpriteSF("ButtonBG")
   
   
   DeleteSpriteSF("HightLight")
   
   for i,v in pairs(BUTTONS) do 
      DeleteTextSF(v)
   end 
   BUTTONS = {} 
   
   for i,v in pairs(BUTTONARRAYS) do 
      DeleteTextSF(v)
   end 
   BUTTONARRAYS = {} 
   
   for i,v in pairs(ICONS) do 
      for _,c in pairs(v) do 
         DeleteSpriteS(c)
      end 
   end 
   ICONS = {} 
   
   
   DeleteSpriteSF("spriteScroll")
   DeleteRectSF("rectScroll")
   
   DeleteRectSF("rectDesc")
   DeleteTextSF("textDesc")
   DeleteSpriteSF("spriteDesc")
   
   rects = {} 
   sprites = {} 
   texts = {} 
   DrawsisRendering = false 
	NBMenuSimpleS.KeyContainer.SetGroupNamespaceActive("SCALEFORM2DNATIVEMENU","DRAW_SCALEFORM2DNATIVEMENU_KEY",false)
	NBNativeMenuS.DrawShowGlare(false)
   
end 
NBNativeMenuS.DrawShowGlare = function(toshow)
 
	if toshow then  
     DrawPageSF("glare","mp_menu_glare",0.05,0.05,1.0,1.0,0,255,255,255,255)
      
      
	else
      if IsDrawingSF("glare") then 
         DeletePageSF("glare")
         
         
      end 
     
	end 
end 
local handle,thisnamespace
NBNativeMenuS.DrawInit = function(data)
   
      
     
 DrawsMaxslot =  data.maxslot or DrawsMaxslot
 DrawsTitle = data.title or DrawsTitle
 DrawsSubtitle = data.subtitle or DrawsSubtitle
 DrawsShowGlare = data.glare or false 
 PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
     
   
	
end 

NBNativeMenuS.DrawRender = function()
   load(LoadResourceFile("nbk_scaleform_draw2d", 'import'))()
	RequestStreamedTextureDict( "commonmenu" )
	while not HasStreamedTextureDictLoaded("commonmenu") do Wait(0) end
	NBMenuSimpleS.KeyContainer.SetGroupNamespaceActive("SCALEFORM2DNATIVEMENU","DRAW_SCALEFORM2DNATIVEMENU_KEY",true)
	local FN_GetButtons = NBNativeMenuS.DrawGetButtons
	local FN_GetFocusSlot = NBNativeMenuS.DrawGetFocusSlot
	local FN_GetDescription = NBNativeMenuS.DrawGetButtonDescription
	local FN_GetButtonOptions = NBNativeMenuS.DrawGetButtonOptions
	local FN_GetButtonIcon = NBNativeMenuS.DrawGetButtonIcon
	local FN_GetButtonIconChecked = NBNativeMenuS.DrawGetButtonIconChecked
	local FN_GetButtonDisable = NBNativeMenuS.DrawGetButtonDisable
	local FN_GetIconNameFromIconID = NBNativeMenuS.DrawGetIconNameFromIconIDByHighLightSate
   UpdateRender = function(notupdateicon)
      if DrawsisRendering == false  then return end 
      for i,v in pairs(rects) do 
         DeleteRectS(v)
      end 
      for i,v in pairs(sprites) do 
         DeleteSpriteS(v)
      end 
      for i,v in pairs(texts) do 
         DeleteTextS(v)
      end 
      rects = {} 
      sprites = {} 
      texts = {} 
      
      
		local maxslot = DrawsMaxslot
		
		_ResetRects(basicy)
      local latetasks = {}
		_drawMenuSpriteTitle("interaction_bgd",gettitleHeight(), 0, 0.0, 255)
       NBNativeMenuS.DrawShowGlare(DrawsShowGlare)
		local subtitley = _drawMenuRectSubtitle(getbuttonHeight(), 140, 0.0, 220)
		_drawMenuTextTitle(DrawsTitle , basicx, basicy + 0.03 , basicfont,0, 0.5)
		_drawMenuTextSubtitle(DrawsSubtitle , basicx, getbasicbuttony(), buttonFont, 9, getbuttonScale())
		local bts = FN_GetButtons()
		local btsT = #bts
		if btsT > 0 then 
			local isScroll = DrawsShouldScroll
			local selection = FN_GetFocusSlot()
			if isScroll then 
				_drawMenuTextSubtitleRight(selection .. ' / '..btsT, basicx + getmenuWidth(), getbasicbuttony(), buttonFont, 9, getbuttonScale()) 
				_drawMenuSpriteButtonBG("Gradient_Bgd", getbuttonHeight() * maxslot, 0, 0.0, 255)
			else 
				_drawMenuSpriteButtonBG("Gradient_Bgd", getbuttonHeight() * btsT, 0, 0.0, 255)
			end 
			local from, to = 1, maxslot 
			if isScroll and selection > maxslot then 
				from, to = selection-(maxslot-1),selection
			end 
			
			local cx,cy,sw,sh,csx,csy,HoverSlotFound
			local n = 0
         
			for i = from, to, 1 do 
				n = n + 1
				local righttext, optionselected = FN_GetButtonOptions(i)
				local iconid = FN_GetButtonIcon(i)
				local IconChecked = FN_GetButtonIconChecked(i)
				local isdisbale = FN_GetButtonDisable(i)
				local iconName,isDiffIcon
            
				local ishighlight = selection == i
            
            if not notupdateicon then 
               if ICONS[n] then 
               for _,c in pairs(ICONS[n]) do 
                        DeleteSpriteS(c)
                     end 
                end 
            end
            
				if iconid then 
					iconName,isDiffIcon = FN_GetIconNameFromIconID(iconid,(ishighlight))
				end 
				local ishovered = false 
				local text = bts[i]
				local nexty_of_button = getbasicbuttony() + getbuttonHeight() * n
            
				local bx,by,bw,bh = _drawButton(nexty_of_button,text,ishighlight,ishovered,righttext, optionselected,IconChecked,isdisbale,iconName,isDiffIcon,n,latetasks)
           
				
			end 
         if latetasks[1] then 
         for i=1,#latetasks do 
            latetasks[i]()
         end 
      end 
		latetasks = {}
         
			
			
			
			if isScroll then 
				_initMenuScroll()
			end 
			_setMenuDescription(FN_GetDescription(selection))
		end 
		
      
	end
   
   DrawsisRendering = true 
   UpdateRender()
   
   
   --[[
	looponce_newthread("tasksync_loop_drawmenu",1000,function()
      
      --UpdateRender()
   end,function()
		DrawsisRendering = false 
		NBMenuSimpleS.KeyContainer.SetGroupNamespaceActive("SCALEFORM2DNATIVEMENU","DRAW_SCALEFORM2DNATIVEMENU_KEY",false)
		NBNativeMenuS.DrawShowGlare(false)
	end)
   --]]
   
end 
NBNativeMenuS.DrawGetIconNameFromIconIDByHighLightSate = function(iconid, highlighted) --max:61 dont use it in loop/draws
	local icons = {}
	local iconid = (iconid or 0) + 1
	icons = {
--[[0--]]	{"",""},
--[[1--]]	{"shop_NEW_Star","shop_NEW_Star"},
--[[2--]]	{"MP_hostCrown","MP_hostCrown"},
--[[3--]]	{"Shop_Tick_Icon","Shop_Tick_Icon"},
--[[4--]]	{"Shop_Box_TickB","Shop_Box_Tick"},
--[[5--]]	{"Shop_Box_CrossB","Shop_Box_Cross"},
--[[6--]]	{"Shop_Box_BlankB","Shop_Box_Blank"},
--[[7--]]	{"Shop_Clothing_Icon_B","Shop_Clothing_Icon_A"},
--[[8--]]	{"Shop_GunClub_Icon_B","Shop_GunClub_Icon_A"},
--[[9--]]	{"Shop_Tattoos_Icon_B","Shop_Tattoos_Icon_A"},
--[[10--]]	{"Shop_Garage_Icon_B","Shop_Garage_Icon_A"},
--[[11--]]	{"Shop_Garage_Bike_Icon_B","Shop_Garage_Bike_Icon_A"},
--[[12--]]	{"Shop_Barber_Icon_B","Shop_Barber_Icon_A"},
--[[13--]]	{"shop_Lock","shop_Lock"},
--[[14--]]	{"Shop_Ammo_Icon_B","Shop_Ammo_Icon_A"},
--[[15--]]	{"Shop_Armour_Icon_B","Shop_Armour_Icon_A"},
--[[16--]]	{"Shop_Health_Icon_B","Shop_Health_Icon_A"},
--[[17--]]	{"Shop_MakeUp_Icon_B","Shop_MakeUp_Icon_A"},
--[[18--]]	{"MP_SpecItem_Coke","MP_SpecItem_Coke"},
--[[19--]]	{"MP_SpecItem_Heroin","MP_SpecItem_Heroin"},
--[[20--]]	{"MP_SpecItem_Weed","MP_SpecItem_Weed"},
--[[21--]]	{"MP_SpecItem_Meth","MP_SpecItem_Meth"},
--[[22--]]	{"MP_SpecItem_Cash","MP_SpecItem_Cash"},
--[[23--]]	{"arrowleft","arrowleft"},
--[[24--]]	{"arrowright","arrowright"},
--[[25--]]	{"MP_AlertTriangle","MP_AlertTriangle"},
--[[26--]]	{"Shop_Michael_Icon_B","Shop_Michael_Icon_A"},
--[[27--]]	{"Shop_Franklin_Icon_B","Shop_Franklin_Icon_A"},
--[[28--]]	{"Shop_Trevor_Icon_B","Shop_Trevor_Icon_A"},
--[[29--]]	{"SaleIcon","SaleIcon"},
--[[30--]]	{"Shop_Lock_Arena","Shop_Lock_Arena"},
--[[31--]]	{"Card_Suit_Clubs","Card_Suit_Clubs"},
--[[32--]]	{"Card_Suit_Hearts","Card_Suit_Hearts"},
--[[33--]]	{"Card_Suit_Spades","Card_Suit_Spades"},
--[[34--]]	{"Card_Suit_Diamonds","Card_Suit_Diamonds"},
--[[35--]]	{"Shop_Art_Icon_B","Shop_Art_Icon_A"},
--[[36--]]	{"Shop_Chips_A","Shop_Chips_B"}
	}
	return highlighted and icons[iconid][1] or icons[iconid][2],icons[iconid][2] ~= icons[iconid][1] ;
end
NBNativeMenuS.DrawGetChangedIconNameFromIconNameByChangedState = function(iconName,ischecked)
	local icons = {
		[""] = "",
		["Shop_Box_Cross"] = "Shop_Box_Blank",
		["Shop_Box_CrossB"] = "Shop_Box_BlankB",
		["Shop_Box_Tick"] = "Shop_Box_Blank",
		["Shop_Box_TickB"] = "Shop_Box_BlankB"
	}
	return ischecked and iconName or icons[iconName]
end 