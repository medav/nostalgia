function GM:ForceDermaSkin()
	return "flood_skin"
end

local SKIN={}

SKIN.PrintName          = "Flooc Skin"
SKIN.Author             = "Thor"
SKIN.DermaVersion       = 1

function SKIN:PaintFrame( panel )
 
        local bcolor = Color(0,0,0,64)
		local fcolor = Color(0,0,96,200)
 
       
        surface.SetDrawColor(0,0,0,64)
        surface.DrawRect( 0, 0, panel:GetWide(), panel:GetTall() )
       
        surface.SetDrawColor( 0,0,96,200)
        surface.DrawRect( 4, 4, panel:GetWide()-8, panel:GetTall() -8)
 
end	


derma.DefineSkin( "flood_skin", "Skin to use in Flood", SKIN )

