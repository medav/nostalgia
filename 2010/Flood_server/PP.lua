AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

MaxProps = 25

function PlayerJoined(pl)
	pl.Props = 0
end
hook.Add("PlayerInitialSpawn", "PlayerJoin", PlayerJoined)

function GM:PlayerSpawnedProp(pl, mdl, ent)
	if pl:IsValid() && ent:IsValid() then
		if pl.Props < MaxProps then
			pl.Props = pl.Props + 1
			ent:SetNetworkedEntity("Owner", pl)
			ent:SetOwner(pl)
		else
			pl:ChatPrint("Max prop limit reached.")
		end
	end
end

function GM:PhysgunPickup(pl, ent)
	SIDY = pl:SteamID()
	if ent:GetNetworkedEntity("Owner") == pl then
		return true
	else
		return false
	end
end

function GM:OnPhysgunReload(wep, pl)
	SIDY = pl:SteamID()
	if pl:IsValid() then
			local tr = util.TraceLine(util.GetPlayerTrace(pl))
			if !tr.Entity:IsValid() || tr.Entity:IsWorld() || tr.Entity:IsPlayer() then return false end
		if tr.Entity:IsValid() then
			if tr.Entity:GetNetworkedEntity("Owner") == pl then
				return
			else
				return false
			end
		end
	end
end

--[[function Punt(pl, ent)
	if pl:IsValid() && ent:IsValid() then
		return false
	end
end
hook.Add("GravGunPunt", "PuntIt", Punt)--]]

function GM:PlayerDisconnected(pl)
	for k, v in pairs(ents.GetAll()) do
		if v:GetNetworkedEntity("Owner") == pl then
				v:Remove()
		end
	end
	for k, v in pairs(player.GetAll()) do
		v:ChatPrint(pl:Nick().." has left the game.")
	end
end

function GM:PlayerSpawnNPC( pl, npc, swep )
	return pl:IsAdmin()
end

function GM:PlayerSpawnSENT( pl, sent )
	return pl:IsAdmin()
end

function GM:PlayerSpawnSWEP( pl, swep )
	return pl:IsAdmin()
end

function GM:PlayerGiveSWEP( pl, class, swep )
	return pl:IsAdmin()
end

function GM:PlayerSpawnEffect( pl, mdl )
	return pl:IsAdmin()
end

function GM:PlayerSpawnVehicle( pl, propid )
	return pl:IsAdmin()
end

function GM:PlayerSpawnProp(pl, mdl)
	return pl:IsAdmin()
end