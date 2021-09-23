Inventory = exports.vorp_inventory:vorp_inventoryApi()

local VorpCore = {}

TriggerEvent("getCore",function(core)
    VorpCore = core
end)

data = {}

function RandomItem()
	local Items = {
		"goldbar",
		"lockpick"
	  }
	return Items[math.random(#Items)]
  end
  
  function RandomNumber()
	  return math.random(1,2)
  end

TriggerEvent("vorp_inventory:getData",function(call)
    data = call
end)
 
RegisterServerEvent("scf_storerobbery:reward")
AddEventHandler("scf_storerobbery:reward", function(type)
    local _source = source
    local User = VorpCore.getUser(_source) 
    local Character = User.getUsedCharacter
    local r = math.random(1,10)
    if(type == "clinic") then
        if r < 3 then 
            Inventory.addItem(_source, "hairpin", math.random(1,2))
            TriggerClientEvent("vorp:Tip", _source, 'You got some hair pins', 5000)
        else
            Inventory.addItem(_source, "consumable_ginseng", math.random(1,2))
            TriggerClientEvent("vorp:Tip", _source, 'You got some ginseng', 5000)
        end
    else
        if r < 3 then
            local amount = RandomNumber()
            Inventory.addItem(_source, "paper_clip", amount)
            TriggerClientEvent("vorp:Tip", _source, 'You got '..amount..'x paper clip', 5000)
        else
            local amount = RandomNumber()
            Inventory.addItem(_source, "goldbar", amount)
            TriggerClientEvent("vorp:Tip", _source, 'You got '..amount..'x Goldbar', 5000)
        end
    end
  
end)


RegisterServerEvent('scf_storerobbery:lockpick')
AddEventHandler('scf_storerobbery:lockpick', function()
    local _source = source
    local User = VorpCore.getUser(_source) 
    local Character = User.getUsedCharacter 
    --TriggerClientEvent("scf_storerobbery:StartRobbing", _source)   
    TriggerServerEvent('scf_storerobbery:policecheck')
end)
 

RegisterNetEvent("scf_storerobbery:policenotify")
AddEventHandler("scf_storerobbery:policenotify", function(players, coords)
    for each, player in ipairs(players) do
        local Character = VorpCore.getUser(player).getUsedCharacter
        if Character ~= nil then

			if Character.job == 'police' then
				TriggerClientEvent("scf_storerobbery:witness", player, coords)
			end
        end
    end
end)

RegisterServerEvent("scf_storerobbery:policecheck")
AddEventHandler("scf_storerobbery:policecheck", function(players,type)
    local _source = source
    local Sceriffi = 0
    for k,v in pairs(players) do
        local User = VorpCore.getUser(v)
        local Character = User.getUsedCharacter
        if Character.job == "police" then 
            Sceriffi = Sceriffi + 1
            
        end

        
    end

    if Sceriffi >= 1 then
        TriggerClientEvent('scf_storerobbery:StartRobbing', _source,type)
    else
        TriggerClientEvent("vorp:Tip", _source, 'There arent enough Sheriffs', 5000)
    end

end)