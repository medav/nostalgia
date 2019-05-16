include('shared.lua')

--------------------------
--
-- This is a module i designed to handle multi-stage animations with ease,
-- im not sure if there is a better way to do all of it, but this is the solution
-- i came up with to provide the HUD and the rest of the client side with 
-- smooth and fluid design
--
--------------------------



anim={anims={},actives={},done={}}


/*---------------------------------
--   animations
----------------------------------*/
player_win={}
function player_win:setup(args)
	self.type="player win"
	if args[1]=="You" then
		self.txt=args[1] .. " have finished!"
	else
		self.txt="Player: " .. args[1] .. " has finished!"
	end
	self.x=100
	self.y=ScrH()/2
	self.a=1
	self.frame=1
	self.done=false
	self.stage=1
end
function player_win:think()
	self.frame=self.frame+1
	if self.stage==1 then
		self.x=self.x+8
		self.a=(self.frame^2)/2
		if self.a>255 then self.a=255 end
		if self.x>=(ScrW()-(#(self.txt)*12))/2 then self.stage=2 end
		return
	elseif self.stage==2 then
		//hold for a few frames
		if self.frame>160 then 
			self.frameout=48
			self.stage=3 
		end
	else
		self.y=self.y+2
		self.frameout=self.frameout-1
		self.a=(self.frameout^2)/2
		if self.a==0 then self.done=true end
		if self.a>255 then self.a=255 end
	end
end
function player_win:draw()
		draw.SimpleText(self.txt, font, self.x, self.y, Color(255,255,255,self.a),0,0)
end
function player_win:set_wait(wait)
	self.wait=wait
end
player_win.mwait=true
player_win.wait=false
anim.anims["player win"]=player_win
/*---------------------------------
----------------------------------*/
mazetime={}
function mazetime:setup(args)
	self.type="mazetime"
	self.txt="Maze Time!"
	self.x=100
	self.y=ScrH()/2-36
	self.a=1
	self.frame=1
	self.done=false
	self.stage=1
end
function mazetime:think()
	self.frame=self.frame+1
	if self.stage==1 then
		self.x=self.x+8
		self.a=(self.frame^2)/2
		if self.a>255 then self.a=255 end
		if self.x>=(ScrW()-(#(self.txt)*12))/2 then self.stage=2 end
		return
	elseif self.stage==2 then
		//hold for a few frames
		if self.frame>160 then 
			self.frameout=48
			self.stage=3 
		end
	else
		self.y=self.y+2
		self.frameout=self.frameout-1
		self.a=(self.frameout^2)/2
		if self.a==0 then self.done=true end
		if self.a>255 then self.a=255 end
	end
end
function mazetime:draw()
		draw.SimpleText(self.txt, font, self.x+2, self.y+2, Color(0,0,0,self.a),0,0)
		draw.SimpleText(self.txt, font, self.x, self.y, Color(math.random(0,255),math.random(0,255),math.random(0,255),self.a),0,0)
end
function mazetime:set_wait(wait)
	self.wait=wait
end
mazetime.mwait=false
mazetime.wait=false
anim.anims["mazetime"]=mazetime
/*---------------------------------
----------------------------------*/
box_anim={}
function box_anim:setup(args)
	self.type="box anim"
	self.x=args[1] or 1
	self.y=args[2] or 1
	self.w=args[3] or 350
	self.h=args[4] or 50
	self.destw=args[5] or 300
	self.a=args[6] or 255
	self.otxt=args[7] or "Null String"
	self.ntxt=args[8] or "Null String"
	if self.w<=self.destw then
		self.sign=1
	elseif self.w>self.destw then
		self.sign=-1
	end
	self.frame=1
	self.done=false
	self.stage=1
end
function box_anim:think()
	
	self.frame=self.frame+1
	if self.stage==1 then
		self.a=self.a-4
		if self.a<=0 then
			self.a=0
			self.stage=2
		end
	elseif self.stage==2 then
		self.w=self.w+2*self.sign
		if self.sign==1 then
			if self.w>=self.destw then self.stage=3 end
		else
			if self.w<=self.destw then self.stage=3 end
		end
	elseif self.stage==3 then
		self.a=self.a+4
		if self.a>=255 then
			self.a=255
			self.done=true
		end
	end
	
end
function box_anim:draw()
		draw.RoundedBox(4, self.x-4, self.y-4, self.w+8, self.h+8, g_bcolor)
		draw.RoundedBox(4, self.x, self.y, self.w, self.h, g_fcolor)
		if self.stage==1 then
			draw.SimpleText(self.otxt, font, 16, ScrH()-38, Color(255,255,255,self.a),0,0)
		elseif self.stage==3 then
			draw.SimpleText(self.ntxt, font, 16, ScrH()-38, Color(255,255,255,self.a),0,0)
		end
		
end
function box_anim:set_wait(wait)
	self.wait=wait
end
box_anim.mwait=true
box_anim.wait=false
box_anim.throw_done=true
anim.anims["box anim"]=box_anim
/*---------------------------------
----------------------------------*/
inform={}
function inform:setup(args)
	--{"text"}
	self.type="inform"
	self.txt=args[1] or "Null String"
	self.x=ScrW()
	self.tw=(#self.txt)*8 -- multiplyer, subject to change
	self.w=512
	self.y=ScrH()/2-128
	self.h=36
	self.frame=1
	self.done=false
	self.stage=1
end
function inform:think()
	
	self.frame=self.frame+1
	if self.stage==1 then
		local s=(self.tw-self.frame)/12
		if s<0 then s=1 end
		self.x=self.x-s
		if self.x<=ScrW()-(self.tw+16) then
			self.x=ScrW()-(self.tw+16)
			self.stage=2
			self.frame=0
		end
		self.w2=ScrW()-self.x
	elseif self.stage==2 then
		if self.frame>180 then --for most computers this should be about 3 seconds (60hz refresh)
			self.stage=3
			self.frame=0
			self.w2=ScrW()-self.x
		end
	elseif self.stage==3 then
		self.w2=ScrW()-512
		local s=(self.tw-self.frame)/12
		if s<0 then s=1 end
		self.x=self.x+s
		if self.x>=ScrW() then
			self.x=ScrW()
			self.done=true
			self.stage=4
		end
	end
	
end
function inform:draw()
	draw.RoundedBox(4, self.x, self.y, self.w, self.h, g_bcolor)
	draw.RoundedBox(4, self.x+4, self.y+4, self.w-8, self.h-8, g_fcolor)
	if self.stage<3 then
		draw.SimpleText(self.txt, "Trebuchet18", self.x+math.floor(self.w2/2), self.y+8, Color(255,255,255,255),1,0)
	end
end
function inform:set_wait(wait)
	self.wait=wait
end
inform.mwait=true
inform.wait=false
inform.throw_done=false
anim.anims["inform"]=inform
/*---------------------------------
----------------------------------*/


function should_wait(name)
	if table.Count(anim.actives)==0 then return false end
	for k,v in ipairs(anim.actives) do
		if v.type==name then return (true && anim.anims[name].mwait) end
	end
	return false
end


function anim:setup(name,args)
	local t=table.Copy(anim.anims[name])
	t:setup(args)
	t.wait=should_wait(name)
		
	
	table.insert(self.actives,t)
end

function anim:exists(name)
	local res=false
	for k,v in ipairs(self.actives) do
		if v.type==name then 
			res=true
		end
	end
	return res
end

function anim:check_done(name,fremove)
	for k,v in ipairs(self.done) do
		if v==name then 
			if fremove then table.remove(self.done,k) end
			return true
		end
	end
	return false
end

function anim:think()
	for k,v in ipairs(self.actives) do
		if anim.show_anims then
			draw.SimpleText("animation: " .. v.type  .. ", ".. tostring(v.done).. ", "  .. tostring(v.wait) .. ", " .. k, "Trebuchet18", 1,18*k+200, Color(255,255,255,self.a),0,0)
		end
		if v.done then
			for k2,v2 in ipairs(self.actives) do
				if v2.type==v.type then 
					self.actives[k2].wait=false
				end
			end
			if v.throw_done then
				table.insert(self.done,v.type)
			end
			v.remove=true
		end
		if !(v.wait) then 
			v:think()
			v:draw()
		end
		
	end
	for k,v in ipairs(self.actives) do
		if v.remove then
			table.remove(self.actives,k)
		end
	end
	
end
concommand.Add("show_animation_info",function()
	anim.show_anims=true
end)
concommand.Add("hide_animation_info",function()
	anim.show_anims=false
end)
concommand.Add("clear_animations",function()
	anim.actives={}
	anim.done={}
end)