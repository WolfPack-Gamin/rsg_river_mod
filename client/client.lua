local WaterTypes = {
    [1] = { ["name"] = "Sea of Coronado", ["waterhash"] = -247856387, ["watertype"] = "lake" },
    [2] = { ["name"] = "San Luis River", ["waterhash"] = -1504425495, ["watertype"] = "river" },
    [3] = { ["name"] = "Lake Don Julio", ["waterhash"] = -1369817450, ["watertype"] = "lake" },
    [4] = { ["name"] = "Flat Iron Lake", ["waterhash"] = -1356490953, ["watertype"] = "lake" },
    [5] = { ["name"] = "Upper Montana River", ["waterhash"] = -1781130443, ["watertype"] = "river" },
    [6] = { ["name"] = "Owanjila", ["waterhash"] = -1300497193, ["watertype"] = "river" },
    [7] = { ["name"] = "HawkEye Creek", ["waterhash"] = -1276586360, ["watertype"] = "river" },
    [8] = { ["name"] = "Little Creek River", ["waterhash"] = -1410384421, ["watertype"] = "river" },
    [9] = { ["name"] = "Dakota River", ["waterhash"] = 370072007, ["watertype"] = "river" },
    [10] = { ["name"] = "Beartooth Beck", ["waterhash"] = 650214731, ["watertype"] = "river" },
    [11] = { ["name"] = "Lake Isabella", ["waterhash"] = 592454541, ["watertype"] = "lake" },
    [12] = { ["name"] = "Cattail Pond", ["waterhash"] = -804804953, ["watertype"] = "lake" },
    [13] = { ["name"] = "Deadboot Creek", ["waterhash"] = 1245451421, ["watertype"] = "river" },
    [14] = { ["name"] = "Spider Gorge", ["waterhash"] = -218679770, ["watertype"] = "river" },
    [15] = { ["name"] = "O'Creagh's Run", ["waterhash"] = -1817904483, ["watertype"] = "lake" },
    [16] = { ["name"] = "Moonstone Pond", ["waterhash"] = -811730579, ["watertype"] = "lake" },
    [17] = { ["name"] = "Roanoke Valley", ["waterhash"] = -1229593481, ["watertype"] = "river" },
    [18] = { ["name"] = "Elysian Pool", ["waterhash"] = -105598602, ["watertype"] = "lake" },
    [19] = { ["name"] = "Heartland Overflow", ["waterhash"] = 1755369577, ["watertype"] = "swamp" },
    [20] = { ["name"] = "Lagras", ["waterhash"] = -557290573, ["watertype"] = "swamp" },
    [21] = { ["name"] = "Lannahechee River", ["waterhash"] = -2040708515, ["watertype"] = "river" },
    [22] = { ["name"] = "Dakota River", ["waterhash"] = 370072007, ["watertype"] = "river" },
    [23] = { ["name"] = "Random1", ["waterhash"] = 231313522, ["watertype"] = "river" },
    [24] = { ["name"] = "Random2", ["waterhash"] = 2005774838, ["watertype"] = "river" },
    [25] = { ["name"] = "Random3", ["waterhash"] = -1287619521, ["watertype"] = "river" },
    [26] = { ["name"] = "Random4", ["waterhash"] = -1308233316, ["watertype"] = "river" },
    [27] = { ["name"] = "Random5", ["waterhash"] = -196675805, ["watertype"] = "river" },
}

local prompts = GetRandomIntInRange(0, 0xffffff)

function PromptSetup()
    local str = _U("prompt")
    drink = PromptRegisterBegin()
    PromptSetControlAction(drink, Config.Key)
    str = CreateVarString(10, 'LITERAL_STRING', str)
    PromptSetText(drink, str)
    PromptSetEnabled(drink, true)
    PromptSetVisible(drink, true)
    PromptSetHoldMode(drink, 1000)
    PromptSetGroup(drink, prompts)
    PromptSetPriority(drink, 3)
    PromptSetUrgentPulsingEnabled(drink, true)
    PromptRegisterEnd(drink)
end

Citizen.CreateThread(function()
    PromptSetup()

    while true do
        Citizen.Wait(0)
        local player = PlayerPedId()
        local coords = GetEntityCoords(player)
        local Water = GetWaterMapZoneAtCoords(coords.x + 3, coords.y + 3, coords.z)
        local dead = IsEntityDead(player)

        if not dead then
            for k, v in pairs(WaterTypes) do
                if Water == WaterTypes[k]["waterhash"] then
                    if IsPedOnFoot(player) then
                        if IsEntityInWater(player) then
                            local label = CreateVarString(10, 'LITERAL_STRING', "Water")
                            PromptSetActiveGroupThisFrame(prompts, label)
                            if PromptHasHoldModeCompleted(drink) then
                                TriggerEvent('DrinkWater')
                            end
                        end
                    end
                end
            end
        end
    end
end)

AddEventHandler('DrinkWater', function()
    local player = PlayerPedId()
    local Animations = exports.vorp_animations.initiate()
    Animations.playAnimation('riverwash', 4000)
    Wait(4000)
    TriggerEvent("vorpmetabolism:changeValue", "Thirst", 500)
    ClearPedTasks(player)
end)
