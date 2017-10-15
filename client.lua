--[[Proxy/Tunnel]]--

vRPjailer = {}
Tunnel.bindInterface("vrp_court",vRPcourt)
Proxy.addInterface("vrp_court",vRPcourt)
vRP = Proxy.getInterface("vRP")

--[[Local/Global]]--
--Coded by Albo1125.

local cJ = false
local eJE = false


local hwaycop = GetHashKey("s_m_y_hwaycop_01") --Add on ped
local cop = GetHashKey("s_m_y_cop_01")
local sheriff = GetHashKey("s_m_y_sheriff_01")
local fsheriff = GetHashKey("s_f_y_sheriff_01")
local fcop = GetHashKey("s_f_y_cop_01")
local ranger = GetHashKey("s_m_y_ranger_01")

 
function jail_drawTxt(x,y ,width,height,scale, text, r,g,b,a, outline)
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    if(outline)then
            SetTextOutline()
        end
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end
--MySQL.createCommand("vRP/set_jailtime","UPDATE vrp_users SET jail = @jail_time WHERE id = @user_id")

RegisterNetEvent("JP")
AddEventHandler("JP", function(jT)
	print("jp function")
	if cJ == true then
		return
	end
	local pP = GetPlayerPed(-1)
	if DoesEntityExist(pP) then
		
		Citizen.CreateThread(function()
			local playerOldLoc = GetEntityCoords(pP, true)
			SetEntityCoords(pP, 1677.233, 2658.618, 45.216)
			cJ = true
			eJE = false
			while jT > 0 and not eJE do
				pP = GetPlayerPed(-1)
				RemoveAllPedWeapons(pP, true)
				SetEntityInvincible(pP, true)
				if IsPedInAnyVehicle(pP, false) then
					ClearPedTasksImmediately(pP)
				end
				if jT % 60 == 0 then
					jTmin = jT / 60
					--user_id = vRP.getUserId({pP})
					jail_drawTxt(0.66, 1.44, 1.0,1.0,0.4, "You have ~r~" .. jTmin .. "~w~ minutes remaining in jail", 255, 255, 255, 255)
					TriggerEvent('chatMessage', 'SYSTEM', { 0, 0, 0 }, jTmin .." more minutes until release.")
					--vrp.setJailTime(pP, jTmin)
					TriggerServerEvent("court:setJailTime", GetPlayerName(PlayerId()), jTmin)
					--MySQL.query("vRP/set_jailtime", {user_id = user_id, jail_time = jTmin})
				end
				Citizen.Wait(500)
				local pL = GetEntityCoords(pP, true)
				local D = Vdist(1677.233, 2658.618, 45.216, pL['x'], pL['y'], pL['z'])
				if D > 90 then
					SetEntityCoords(pP, 1677.233, 2658.618, 45.216)
					if D > 100 then
						jT = jT + 60
						if jT > 1500 then
							jT = 1500
						end
						TriggerEvent('chatMessage', 'JUDGE', { 0, 0, 0 }, "Your jail time was extended for an unlawful escape attempt.")
					end
				end
				jT = jT - 0.5
			end
			TriggerServerEvent('chatMessageEntered', "SYSTEM", { 0, 0, 0 }, GetPlayerName(PlayerId()) .." was released from jail.")
			--user_id = vRP.getUserId({pP})
			--MySQL.query("vRP/set_jailtime", {user_id = user_id, jail_time = 0})
			SetEntityCoords(pP, 1855.807, 2601.949, 45.323)
			cJ = false
			SetEntityInvincible(pP, false)
		end)
	end
end)

RegisterNetEvent("UnJP")
AddEventHandler("UnJP", function()
	eJE = true
end)


RegisterNetEvent("DP")
AddEventHandler("DP", function()
	print("dp function")
	if cJ == true then
		return
	end
end)

RegisterNetEvent("TP")
AddEventHandler("TP", function(tP)
	print("tp function")
	local pP = GetPlayerPed(-1)
	if DoesEntityExist(pP) then
		Citizen.CreateThread(function()
			TriggerServerEvent('chatMessageEntered', "SYSTEM", { 0, 0, 0 }, GetPlayerName(PlayerId()) .." was charged $"..tP..".")
		end)
	end
end)


RegisterNetEvent("TPFail")
AddEventHandler("TPFail", function(tP)
	print("tpfail function")
	local pP = GetPlayerPed(-1)
	if DoesEntityExist(pP) then
		Citizen.CreateThread(function()
			TriggerServerEvent('chatMessageEntered', "SYSTEM", { 0, 0, 0 }, GetPlayerName(PlayerId()) .." was not charged $"..tP..". They do not have the money")
		end)
	end
end)

