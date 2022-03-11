--copy to other script
CreateThread(function() 
   load(LoadResourceFile("nbk_scaleform_simplemenu", 'import'))()
	local menu = CreateSimpleMenuS("namespace","test",{
         glare = true,
         title = "negbookglare",
         subtitle = "hello",
         maxslot = 6,
         buttons  = {
            {name="Spawn A Vehicle",description="hello",actions={"osiris","adder","turismor"}},
            {name="Suicide",description="Suicide",crossed = true},
            {name="Cat",description="hell312o",options={"$3000"},icon = 5},
            {name="Race",description="hell312o",disable = true,icon = 13},
            {name="Some Disabled",description="Disabled",disable = true},
            {name="Fruits",description="hell312o",options={"apple","banana","hamburger"}},
            {name="Close Menu",description="Close your menu"},
         }
      })
      
      menu:On('open',function(...)
         print("open!?",...)
      end)
      menu:On('select',function(currentdata,menu_)
         print("submit?",json.encode(currentdata))
         
      end)
      menu:On('back',function(currentdata,menu)
         print("cancel",json.encode(currentdata))
         menu.close()
      end)
      menu:On('change',function(currentdata,menu)
         
         --print("example,change",currentdata.slot,currentdata.data)
      end)
      menu:OpenWith("F1","Open the menu1")
      menu:OpenWithHolding("M",500,"Open the menu1")
      menu:OpenWithHolding("SELECT_INDEX",500,"Open the menu1 delay","PAD_DIGITALBUTTON")
      menu:Button(1,function(options,selected)
         local vehname = options[selected]
         local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 8.0, 0.5))
         if vehname == nil then vehname = "adder" end
         vehiclehash = GetHashKey(vehname)
         RequestModel(vehiclehash)
         while not HasModelLoaded(vehiclehash)  do Wait(100) end 
         local veh = GetVehiclePedIsIn(PlayerPedId())
         local speed = GetEntitySpeed(PlayerPedId())
         if DoesEntityExist(veh) then 
            DeleteEntity(veh)
         end 
         local vehicle = CreateVehicle(vehiclehash, x, y, z, GetEntityHeading(PlayerPedId()), 1, 0)
         SetVehicleEngineOn(vehicle, true, true, false)
         SetVehicleForwardSpeed(vehicle, speed)
         SetPedIntoVehicle(PlayerPedId(), vehicle, -1);
      end)
      menu:Button(2,function() -- no options and no actions cb nothing 
         SetEntityHealth(PlayerPedId(),0)
      end)
      menu:Button(7,function(options,selected,menu)
         menu.close()
      end)
end)
