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

function anim:check_done(name,fremove)
	for k,v in ipairs(self.done) do
		if v.type==name then 
			if fremove then table.remove(self.done,k) end
			return true
		end
	end
	return false
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

function anim:think()
	for k,v in ipairs(self.actives) do
		if anim.show_anims then
			draw.SimpleText("animation: " .. v.type  .. ", ".. tostring(v.wait).. ", "  .. tostring(v.mwait) .. ", " .. k, "maze_font2", 1,14*k+200, Color(255,255,255,self.a),0,0)
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
			table.remove(self.actives,k)
		end
		if !(v.wait) then 
			v:think()
			v:draw()
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