AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

function SaveCash(pl)
	local CashFile = "FloodCashLogs/" .. string.Replace(pl:SteamID(),":","_") .. ".txt"
	if pl.Allow then
		file.Write(CashFile, tonumber(pl:GetNWInt("Cash")))
		pl:ChatPrint("Profile Saved!")
	end
end

function SaveGame(pl, cmd, arg)
	if pl:IsAdmin() then
		for k, v in pairs(player.GetAll()) do
			SaveCash(v)
			v:ChatPrint("Game Saved!")
		end
	end
end
concommand.Add("SaveGame", SaveGame)

function PlayerLeft(pl)
	SaveCash(pl)
end
hook.Add("PlayerDisconnected", "PlayerDisconnect", PlayerLeft)

function ServerDown()
	for k, v in pairs(player.GetAll()) do
		SaveCash(v)
	end
end
hook.Add("ShutDown", "ServerShutDown", ServerDown)