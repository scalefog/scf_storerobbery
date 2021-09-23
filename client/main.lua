StartRobbing = {}
local storeRobbing = false
local cooldown = 0
local test = false
local hour = GetClockHours()
local minute = GetClockMinutes()
local locations = {
	{store="Valetine",type= "store", x=-325.24401, y=803.5880, z=117.8816},
	{store="Saint Denis",type= "store", x=2822.6672, y=-1319.2395, z=46.7556},
    {store="Clinic",type="clinic", x=-288.9689, y=804.4608, z=119.3858}
}
RegisterNetEvent("scf_storerobbery:witness")
AddEventHandler("scf_storerobbery:witness", function(coords)
--	print('store name '..tostring(alert))
	TriggerEvent("vorp:TipBottom", 'Telegram of Robbery in Progress', 15000)
	local blip = Citizen.InvokeNative(0x45f13b7e0a15c880, -1282792512, coords.x, coords.y, coords.z, 50.0)
	Wait(90000)--Time till notify blips dispears, 1 min
	RemoveBlip(blip)
end)

RegisterNetEvent('scf_storerobbery:StartRobbing')
AddEventHandler('scf_storerobbery:StartRobbing', function(type)	
    local ped = PlayerPedId()
	local coords = GetEntityCoords(ped)
	if cooldown == 0 then 
		if storeRobbing == false then
			
            TaskStartScenarioInPlace(PlayerPedId(), GetHashKey('WORLD_HUMAN_CROUCH_INSPECT'), -1, true, false, false, false)
			storeRobbing = true
			TriggerServerEvent("scf_storerobbery:policenotify", GetPlayers(), coords)
		   --TriggerEvent("redemrp_notification:start", "You have started to rob this bank!", 5)
		   exports['progressBars']:startUI(65000, "You're robbing the store")
            Citizen.Wait(65000)
            ClearPedTasksImmediately(PlayerPedId())
			ClearPedSecondaryTask(PlayerPedId())
			storeRobbing = false
			TriggerServerEvent("scf_storerobbery:reward",type) -- add gold/money
			RunCooldown()
		end
	else
		TriggerEvent("vorp:TipBottom", "Nothing to steal", 6000)
	end
end)


function DrawTxt(str, x, y, w, h, col1, col2, col3, a, center)
	local str = CreateVarString(10, "LITERAL_STRING", str)
	SetTextScale(w, h)
	SetTextColor(math.floor(col1), math.floor(col2), math.floor(col3), math.floor(a))
	SetTextCentre(center)
	SetTextDropshadow(1, 0, 0, 0, 255)
	Citizen.InvokeNative(0xADA9255D, 1)
	DisplayText(str, x, y)
end
 
 


Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(500)
        for _, info in pairs(locations) do 
            local playerPos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.0, 0.0)
            local dist = GetDistanceBetweenCoords(playerPos, info.x, info.y, info.z, true)
            while dist < 1 do
                Citizen.Wait(0)
                
                playerPos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.0, 0.0)
                dist = GetDistanceBetweenCoords(playerPos, info.x, info.y, info.z, true)
				DrawTxt("Press Enter to Rob", 0.5, 0.9, 0.5, 0.5, 255, 255, 255, 255, true)
				if IsControlJustReleased(0, 0xC7B5340A) then		
						TriggerServerEvent("scf_storerobbery:policecheck",GetPlayers(),info.type)
				end
		end
	end
    end
end)


-- Get players
function GetPlayers()
    local players = {}

    for i = 0, 31 do
        if NetworkIsPlayerActive(i) then
            table.insert(players, GetPlayerServerId(i))
        end
    end

    return players
end
-- Cooldown
function RunCooldown()
    cooldown = 1800000        
    while cooldown > 0 do
        Wait(0)
        cooldown = cooldown - 1
    end
end