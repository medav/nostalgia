include("shared.lua")

--------------------------
--
-- i am replacing the spawn menu with a store,
-- and perk selection.
--
-- will consist of buying perks with points ,
-- protection from suprises, settings for HUD
-- and help/about
--
--------------------------



function create_store_button(cmd,name,desc,cost,width)
	local button=vgui.Create("DPanel")
	button:SetParent(menu.ST)
	button:SetSize(width,64)
	button.label1=vgui.Create("DLabel")
	button.label1:SetParent(button)
	button.label1:SetPos(32,8)
	button.label1:SetFont("Trebuchet24")
	button.label1:SetText(name)
	button.label1:SizeToContents()
	
	button.label2=vgui.Create("DLabel")
	button.label2:SetParent(button)
	button.label2:SetPos(32,32)
	button.label2:SetFont("Trebuchet18")
	button.label2:SetText(desc)
	button.label2:SizeToContents()
	
	button.button=vgui.Create("DButton")
	button.button:SetParent(button)
	button.button:SetPos(3/4*width,4)
	button.button:SetSize(width/4-32,52)
	button.button:SetText("Buy: $" .. cost)
	button.button.Paint=function()
		local w,h=button.button:GetSize()
		draw.RoundedBox(4,0,0,w,h,Color(0,0,0,128))
		if LocalPlayer():GetNWBool(cmd) then
			draw.RoundedBox(4,0,0,w,h,Color(0,255,0,128))
		end
		draw.RoundedBox(4,4,4,w-8,h-8,Color(0,0,0,128))
	end
	
	button.button2=vgui.Create("DButton")
	button.button2:SetParent(button)
	button.button2:SetPos(width/2+width/8,16)
	button.button2:SetSize(width/8-32,36)
	button.button2:SetText("Toggle")
	button.button2.Paint=function()
		local w,h=button.button2:GetSize()
		draw.RoundedBox(4,0,0,w,h,Color(0,0,0,128))
		if LocalPlayer():GetNWBool(cmd .. "T") then
			draw.RoundedBox(4,0,0,w,h,Color(0,255,0,128))
		end
		draw.RoundedBox(4,4,4,w-8,h-8,Color(0,0,0,128))
	end
	
	button.button2.DoClick=function()
		RunConsoleCommand("gmm_toggle_perk",cmd)
	end
	
	button.button.DoClick=function()
		if string.find(cmd,"gs") then
			RunConsoleCommand("gmm_purchase_protection",cmd)
		else
			RunConsoleCommand("gmm_purchase_perk",cmd)
		end
	end
	
	button.Paint=function()
		local w,h=button:GetSize()
		draw.RoundedBox(4,0,0,w,h,Color(0,0,96,128))
	end
	return button
end



function create_store_separator(name,width)
	local sep=vgui.Create("DPanel")
	sep:SetParent(menu.ST)
	sep:SetSize(width,32)
	
	sep.Paint=function()
		local w,h=sep:GetSize()
		draw.RoundedBox(4,0,0,w,h,Color(0,0,96,255))
		draw.RoundedBox(4,0,12,w,h-24,Color(64,64,64,128))
		draw.SimpleText(name,"Trebuchet24",w/2,4,Color(255,255,255,255),1)
	end
	
	return sep
end


function setup_store()
	local s1=create_store_separator("Perks",menu.ST:GetWide()-16)
	menu.ST:AddItem(s1)
	for k,v in pairs(gmm_perks) do
		local button=create_store_button(k,v.storename,v.desc,v.cost,menu.ST:GetWide()-16)
		menu.ST:AddItem(button)
	end
	local s1=create_store_separator("Protection",menu.ST:GetWide()-16)
	menu.ST:AddItem(s1)
	for k,v in pairs(gmm_protection) do
		local button=create_store_button(k,v.storename,v.desc,v.cost,menu.ST:GetWide()-16)
		menu.ST:AddItem(button)
	end
	local s1=create_store_separator("",menu.ST:GetWide()-16)
	menu.ST:AddItem(s1)
end

function setup_settings()
	menu.SG:SetPadding(16)
	menu.uText2=vgui.Create("DLabel")
	menu.uText2:SetParent(menu.SG)
	menu.uText2:SetText("Under Construction")
	menu.uText2:SizeToContents()
	menu.SG:AddItem(menu.uText2)
end

hook.Add("Initialize","Setup_Maze_Menu",function()
	menu=vgui.Create("DFrame")
	menu:SetPos(ScrW()/2-384,ScrH()/2-256)
	menu:SetSize(768,512)
	menu:SetVisible(false)
	menu:InvalidateLayout(true,false)
	menu:SetTitle("")
	menu:ShowCloseButton(false)
	menu:SetPos(ScrW()/2-384,ScrH()/2-256)
	menu:SetSize(768,512)
	menu:SetDraggable( false )
	menu.Paint=function() end
	
	menu.ps=vgui.Create("DPropertySheet")
	menu.ps:SetParent( menu )
	menu.ps:SetPos( 8,0)
	menu.ps:SetSize(752,502)
	x,y=menu.ps:GetPos()
	
	
	-------------------------------
	----Store Tab------------------
	menu.ST=vgui.Create("DPanelList")
	menu.ST:SetParent(menu.ps)
	menu.ST:SetPos(0,0)
	menu.ST:SetSize(748,498)
	menu.ST:SetPadding(8)
	menu.ST:SetSpacing(4)
	menu.ST:EnableVerticalScrollbar(true)
	setup_store()
	-------------------------------
	----Settings-------------------
	menu.SG=vgui.Create("DPanelList")
	menu.SG:SetParent(menu.ps)
	menu.SG:SetPos( 0,0)
	menu.SG:SetSize(748,498)
	setup_settings()
	-------------------------------
	----Help-----------------------
	menu.HP=vgui.Create("DPanelList")
	menu.HP:SetParent(menu.ps)
	menu.HP:SetPos( 0,0)
	menu.HP:SetSize(748,498)
	menu.HP:SetPadding(16)

	menu.hText=vgui.Create("DLabel")
	menu.hText:SetParent(menu.HP)
	menu.hText:SetText("\
Welcome to Garry's Mod Maze, created by Thor.\
\n\n	Playing is simple, wait for the round to start, and then find your way through the maze.\n\
	Collect the grapes (not added yet.) or finish the maze to earn points. Buy perks with the points you earn.\n\
	Be careful, many suprises await you in the maze!\
\n\nGood Luck!\
")
	menu.hText:SizeToContents()
	menu.HP:AddItem(menu.hText)
	-------------------------------
	-------------------------------

	menu.ps:AddSheet("Store", menu.ST, "gui/silkicons/user", false, false, "Buy Stuff")
	menu.ps:AddSheet("Settings", menu.SG, "gui/silkicons/wrench", false, false, "Settings")
	menu.ps:AddSheet("About", menu.HP, "gui/silkicons/world", false, false, "HELLLPPPP!!!")
end)


function GM:OnSpawnMenuOpen() 
	
	if menu && menu:IsValid() then
		menu:SetVisible(true)
	end
	gui.EnableScreenClicker(true)
	RestoreCursorPosition()
end

function GM:OnSpawnMenuClose() 
	menu:SetVisible(false)
	RememberCursorPosition()
	gui.EnableScreenClicker(false)
end

-----------------------------------------------------------------------------------------------
-------		This it the maze 'skin' to be used.									-----------
-----------------------------------------------------------------------------------------------
local SKIN={}

function SKIN:PaintTab( panel )
		local col={Color(128,128,128,64),Color(0,0,128,255)}

        draw.RoundedBox( 4, 0, 0, panel:GetWide(), panel:GetTall() + 8, self.colTabShadow )
       
        if ( panel:GetPropertySheet():GetActiveTab() == panel ) then
                draw.RoundedBox( 4, 1, 0, panel:GetWide()-2, panel:GetTall() + 8, col[2] )
        else
                draw.RoundedBox( 4, 0, 0, panel:GetWide()-1, panel:GetTall() + 8, col[1] )
        end
       
end

function SKIN:PaintPropertySheet( panel )
		local col={Color(0,0,0,200),Color(0,0,128,255)}
        local ActiveTab = panel:GetActiveTab()
        local Offset = 0
        if ( ActiveTab ) then Offset = ActiveTab:GetTall() end
       
        draw.RoundedBox( 4,0, Offset, panel:GetWide(), panel:GetTall()-Offset, col[1] )
		--draw.RoundedBox( 4, 2, Offset+2, panel:GetWide()-4, panel:GetTall()-Offset-4, col[2] )
       
end

function SKIN:PaintPanelList( panel )
		local col={Color(0,0,0,128),Color(0,0,128,100)}
        if ( panel.m_bBackground ) then
                draw.RoundedBox( 4, 0, 0, panel:GetWide(), panel:GetTall(), col[2] )
        end
 
end

function SKIN:PaintCollapsibleCategory( panel )
       
        draw.RoundedBox( 4, 0, 0, panel:GetWide(), panel:GetTall(), Color(128,128,128,200) )
       
end

function SKIN:PaintListView( panel )
 
        if ( panel.m_bBackground ) then
                surface.SetDrawColor( 255,255,255, 128 )
                panel:DrawFilledRect()
        end
       
end

function SKIN:PaintVScrollBar( panel )

end

function SKIN:PaintScrollBarGrip( panel )
    draw.RoundedBox(4,0,0,panel:GetWide(),panel:GetTall(),Color(0,0,96,200))
end

function SKIN:PaintButton( panel )
 
        local w, h = panel:GetSize()
 
        if ( panel.m_bBackground ) then
       
                local col = self.control_color
               
                if ( panel:GetDisabled() ) then
                        col = self.control_color_dark
                elseif ( panel.Depressed || panel:GetSelected() ) then
                        col = self.control_color_active
                elseif ( panel.Hovered ) then
                        col = self.control_color_highlight
                end
               
                surface.SetDrawColor( 0,0,96,200 )
                panel:DrawFilledRect()
       
        end
 
end

derma.DefineSkin( "Maze_Default", "gm_maze skin", SKIN )

 function GM:ForceDermaSkin()
	return "Maze_Default"
 end
 -----------------------------------------------------------------------------------------------
 -----------------------------------------------------------------------------------------------
 -----------------------------------------------------------------------------------------------
