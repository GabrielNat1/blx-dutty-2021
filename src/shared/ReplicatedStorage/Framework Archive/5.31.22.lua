--[[
	
---TO DO
-replicate health
-camera animations
-load gun
-load knife
-firing

---ANIMATION
-transparency
-cloning
-dropping
-tweening/cancelling
-sounds


]]


workspace.CurrentCamera:ClearAllChildren()

wait(1)
local vector={}
local cframe={}
local utility={}
local event={}
local physics={}
local tween={}
local animation={}
local input={}
local localchar={}
local camera={}
local run={}


--vector module
print("Loading vector module")
do
	local pi		=math.pi
	local cos		=math.cos
	local sin		=math.sin
	local acos		=math.acos
	local random	=math.random
	local v3		=Vector3.new
	local nv		=Vector3.new()

	vector.identity=nv
	vector.new=v3
	
	function vector.random()
		local y=acos(1-2*random())/3
		local z=3^0.5*sin(y)-cos(y)
		local r=((1-z*z)*random())^0.5
		local t=6.28318*random()
		return v3(r*cos(t),r*sin(t),z)
	end
	
	function vector.slerp(v0,v1,t)
		local x0,y0,z0		=v0.x,v0.y,v0.z
		local x1,y1,z1		=v1.x,v1.y,v1.z
		local m0			=(x0*x0+y0*y0+z0*z0)^0.5
		local m1			=(x1*x1+y1*y1+z1*z1)^0.5
		local co			=(x0*x1+y0*y1+z0*z1)/(m0*m1)
		if co<-0.9999 then
			local px,py,pz	=0,0,0
			local x2,y2,z2	=x0*x0,y0*y0,z0*z0
			if x2<y2 then
				if x2<z2 then
					px		=1
				else
					pz		=1
				end
			else
				if y2<z2 then
					py		=1
				else
					pz		=1
				end
			end
			local th		=acos((x0*px+y0*py+z0*pz)/m0)
			local r			=pi/th*t
			local s			=((1-t)*m0+t*m1)/sin(th)
			local s0		=s/m0*sin((1-r)*th)
			local s1		=s/m1*sin(r*th)
			return			v3(
							s0*x0+s1*px,
							s0*y0+s1*py,
							s0*z0+s1*pz
							)
		elseif co<0.9999 then
			local th		=acos(co)
			local s			=((1-t)*m0+t*m1)/(1-co*co)^0.5
			local s0		=s/m0*sin((1-t)*th)
			local s1		=s/m1*sin(t*th)
			return			v3(
							s0*x0+s1*x1,
							s0*y0+s1*y1,
							s0*z0+s1*z1
							)
		elseif 1e-4<m0 or 1e-4<m1 then
			if m0<m1 then
				return		((1-t)*m0/m1+t)*v1
			else
				return		((1-t)+t*m1/m0)*v0
			end
		else
			return			nv
		end
	end
	
end

--cframe module
print("Loading cframe module")
do
	local pi			=math.pi
	local halfpi		=pi/2
	local cos			=math.cos
	local sin			=math.sin
	local acos			=math.acos
	local v3			=Vector3.new
	local nv			=v3()
	local cf			=CFrame.new
	local nc			=cf()
	local components	=nc.components
	local ldiv			=nc.toObjectSpace
	local vtos			=nc.vectorToObjectSpace
	local backcf		=cf(0,0,0,-1,0,0,0,1,0,0,0,-1)

	cframe.identity		=nc
	cframe.new			=cf
	cframe.tos			=nc.toObjectSpace
	cframe.vtos			=nc.vectorToObjectSpace
	cframe.ptos			=nc.pointToObjectSpace
	

	function cframe.fromaxisangle(x,y,z)
		if not y then
			x,y,z=x.x,x.y,x.z
		end
		local m=(x*x+y*y+z*z)^0.5
		if m>1e-5 then
			local si=sin(m/2)/m
			return cf(0,0,0,si*x,si*y,si*z,cos(m/2))
		else
			return nc
		end
	end
	
	function cframe.toaxisangle(c)
		local _,_,_,
			xx,yx,zx,
			xy,yy,zy,
			xz,yz,zz=components(c)
		local co=(xx+yy+zz-1)/2
		if co<-0.9999 then
			local x=xx+yx+zx+1
			local y=xy+yy+zy+1
			local z=xz+yz+zz+1
			local m=pi*(x*x+y*y+z*z)^-0.5
			return v3(m*x,m*y,m*z)
		elseif co<0.9999 then
			local x=yz-zy
			local y=zx-xz
			local z=xy-yx
			local m=acos(co)*(x*x+y*y+z*z)^-0.5
			return v3(m*x,m*y,m*z)
		else
			return nv
		end
	end
	
	function cframe.direct(c,look,newdir)
		local lx,ly,lz	=look.x,look.y,look.z
		local rv		=vtos(c,newdir)
		local rx,ry,rz	=rv.x,rv.y,rv.z
		local rl		=((rx*rx+ry*ry+rz*rz)*(lx*lx+ly*ly+lz*lz))^0.5
		local d			=(lx*rx+ly*ry+lz*rz)/rl
		if d>-0.99999 then
			local qw	=((d+1)/2)^0.5
			local m		=2*qw*rl
			return		c*cf(
						0,0,0,
						(ly*rz-lz*ry)/m,
						(lz*rx-lx*rz)/m,
						(lx*ry-ly*rx)/m,
						qw
						)  
		else 
			return c*backcf
		end
	end

	function cframe.interpolate(c0,c1,t)
		local x, y, z,
			xx,yx,zx,
			xy,yy,zy,
			xz,yz,zz	=components(ldiv(c0,c1))
	
		local tr=		xx+yy+zz
		if tr>2.99999 then
			return		c0*cf(t*x,t*y,t*z)
		elseif tr>-0.99999 then
			local m=	2*(tr+1)^0.5
			local qw=	m/4
			local th=	acos(qw)
			local s=	(1-qw*qw)^0.5
			local c=	sin(th*t)/s
			return		c0*cf(
						t*x,t*y,t*z,
						c*(yz-zy)/m,
						c*(zx-xz)/m,
						c*(xy-yx)/m,
						c*qw+sin(th*(1-t))/s
						)
		else
			local qx=	xx+yx+zx+1
			local qy=	xy+yy+zy+1
			local qz=	xz+yz+zz+1
			local c=	sin(halfpi*t)/(qx*qx+qy*qy+qz*qz)^0.5
			return		c0*cf(
						t*x,t*y,t*z,
						c*qx,
						c*qy,
						c*qz,
						sin(halfpi*(1-t))
						)
		end
	end
end

--utility module
print("Loading utility module")
do	
	local getchildren	=game.GetChildren
	local rtype			=game.IsA
	local joints		=game.JointsService
	local tos			=CFrame.new().toObjectSpace
	local tick			=tick
	local new			=Instance.new
	local waitforchild	=game.WaitForChild

	function utility.arraytohash(table,hashfunc)
		local newtable={}
		for i=1,#table do
			newtable[hashfunc(table[i])]=table[i]
		end
		return newtable
	end

	function utility.waitfor(object,timeout,...)
		local indices={...}
		local index=object
		local quit=tick()+(timeout or 10)
		for i=1,#indices do
			if index.WaitForChild then
			index=waitforchild(index,indices[i])
			else
				local newindex repeat
					run.wait()
					newindex=index[indices[i]]
				until newindex or tick()>quit
				index=newindex
			end
			if tick()>quit then return end
		end
		return index
	end
	
	function utility.getdescendents(object,type)
		type=type or "Instance"
		local descendents=getchildren(object)
		local i=0
		while i<#descendents do
			i=i+1
			local children=getchildren(descendents[i])
			for j=1,#children do
				descendents[#descendents+1]=children[j]
			end
		end
		local newdescendents={}
		for i=1,#descendents do
			if rtype(descendents[i],type) then
				newdescendents[#newdescendents+1]=descendents[i]
			end
		end
		return newdescendents
	end
	
	function utility.weld(part0,part1,c0)
		c0=c0 or tos(part0.CFrame,part1.CFrame)
		local newweld=new("Weld",joints)
		newweld.Part0=part0
		newweld.Part1=part1
		newweld.C0=c0
		return newweld
	end
	
	function utility.weldmodel(model,basepart)
		local weldcframes={}
		local children=utility.getdescendents(model,"BasePart")
		basepart=basepart or children[1]
		local welds=children
		welds[0]=basepart
		local basecframe=basepart and basepart.CFrame
		for i=1,#children do
			weldcframes[i]=tos(basecframe,children[i].CFrame)
		end
		for i=1,#children do
			local newweld=new("Weld",joints)
			newweld.Part0=basepart
			newweld.Part1=children[i]
			newweld.C0=weldcframes[i]
			welds[i]=newweld
		end
		return welds
	end
	
	local function removevalue(array,removals)
		local removelist={}
		for i=1,#removals do
			removelist[removals[i]]=true
		end
		local j=1
		for i=1,#array do
			local v=array[i]
			array[i]=nil
			if not removelist[v] then
				array[j]=v
				j=j+1
			end
		end
		return array
	end
end

--event module
print("Loading event module")
do
	function event.new(eventtable)
		local self=eventtable or {}

		local removelist		={}
		local functions			={}
		local pendingdeletion	=false

		function self:connect(func)
			functions[#functions+1]=func

			return function()
				removelist[func]=true
				pendingdeletion=true
			end
		end

		return function(...)
			if pendingdeletion then
				pendingdeletion=false
				local j=1
				for i=1,#functions do
					local f=functions[i]
					functions[i]=nil
					if removelist[f] then
						removelist[f]=nil
					else
						f(...)
						functions[j]=f
						j=j+1
					end
				end
			else
				for i=1,#functions do
					functions[i](...)
				end
			end
		end,
	end
end

--physics module
print("Loading physics module")
do
	physics.spring={}

	local cos			=math.cos
	local sin			=math.sin
	local setmetatable	=setmetatable
	local tick			=tick

	function physics.spring.new(initial)
		local t0	=tick()						--tick0
		local p0	=initial or 0				--position0
		local v0	=initial and 0*initial or 0	--velocity0
		local t		=initial or 0				--target
		local d		=1							--damper [0,1]
		local s		=1							--speed [0,infinity]

		local function positionvelocity(tick)
			local x			=tick-t0
			local c0		=p0-t
			if s==0 then
				return		p0,0
			elseif d<1 then
				local c		=(1-d*d)^0.5
				local c1	=(v0/s+d*c0)/c
				local co	=cos(c*s*x)
				local si	=sin(c*s*x)
				local e		=2.718281828459045^(d*s*x)
				return		t+(c0*co+c1*si)/e,
							s*((c*c1-d*c0)*co-(c*c0+d*c1)*si)/e
			else
				local c1	=v0/s+c0
				local e		=2.718281828459045^(s*x)
				return		t+(c0+c1*s*x)/e,
							s*(c1-c0-c1*s*x)/e
			end
		end

		return setmetatable({
			accelerate=function(_,acceleration)
				local time=tick()
				local p,v=positionvelocity(time)
				p0=p
				v0=v+acceleration
				t0=time
			end;
		},{
			__index=function(_,index)
				if index=="value" or index=="position" or index=="p" then
					local p,v=positionvelocity(tick())
					return p
				elseif index=="velocity" or index=="v" then
					local p,v=positionvelocity(tick())
					return v
				elseif index=="target" or index=="t" then
					return t
				elseif index=="damper" or index=="d" then
					return d
				elseif index=="speed" or index=="s" then
					return s
				else
					error(index.." is not a valid member of spring")
				end
			end;
			__newindex=function(_,index,value)
				local time=tick()
				if index=="value" or index=="position" or index=="p" then
					local p,v=positionvelocity(time)
					p0,v0=value,v
				elseif index=="velocity" or index=="v" then
					local p,v=positionvelocity(time)
					p0,v0=p,value
				elseif index=="target" or index=="t" then
					p0,v0=positionvelocity(time)
					t=value
				elseif index=="damper" or index=="d" then
					p0,v0=positionvelocity(time)
					d=value<0 and 0 or value<1 and value or 1
				elseif index=="speed" or index=="s" then
					p0,v0=positionvelocity(time)
					s=value<0 and 0 or value
				else
					error(index.." is not a valid member of spring")
				end
				t0=time
			end;
		})
	end
end


--- Tween module
do
	local type			=type
	local halfpi		=math.pi/2
	local acos			=math.acos
	local sin			=math.sin
	local cf			=CFrame.new
	local tos			=cf().toObjectSpace
	local components	=cf().components
	local tick			=tick
	
	local updater		={}
	tween.step			=event.new(updater)
	local tweendata		={}
	local equations		={
		linear			={p0=0;v0=1;p1=1;v1=1};
		smooth			={p0=0;v0=0;p1=1;v1=0};
		accelerate		={p0=0;v0=0;p1=1;v1=1};
		decelerate		={p0=0;v0=1;p1=1;v1=0};
		bump			={p0=0;v0=4;p1=0;v1=-4};
		acceleratebump	={p0=0;v0=0;p1=0;v1=-6.75};
		deceleratebump	={p0=0;v0=6.75;p1=0;v1=0};
	}
	
	local function qpow(x,y,z,qw,qx,qy,qz,th,s,t)
		if th>0.00001 then
			local s1=sin(th*t)/s
			return cf(
				t*x,t*y,t*z,
				s1*qx,
				s1*qy,
				s1*qz,
				sin(th*(1-t))/s+s1*qw
			)
		else
			return cf(t*x,t*y,t*z)
		end
	end
	
	local function calculatestuff(object,index,equation,nextcframe)
		local lastcframe=object[index]
		local x,y,z,
			xx,yx,zx,
			xy,yy,zy,
			xz,yz,zz	=components(tos(lastcframe,nextcframe))
		local p0,v0,p1,v1
		if type(equation)=="table" then
			p0			=equation[1]
			v0			=equation[2]
			p1			=equation[3]
			v1			=equation[4]
		else
			local eq	=equations[equation]
			p0,v0,p1,v1	=eq.p0,eq.v0,eq.p1,eq.v1
		end

		local qw,qx,qy,qz
		local th
		local s
		local tr		=xx+yy+zz
		if tr>2.99999 then
			qw,qx,qy,qz	=1,0,0,0
			th			=0
			s			=0
		elseif tr>-0.99999 then
			local m		=2*(tr+1)^0.5
			qw,qx,qy,qz	=m/4,(yz-zy)/m,(zx-xz)/m,(xy-yx)/m
			th			=acos(qw)
			s			=(1-qw*qw)^0.5
		else
			qx,qy,qz	=xx+yx+zx+1,xy+yy+zy+1,xz+yz+zz+1
			local m		=(qx*qx+qy*qy+qz*qz)^0.5
			qw,qx,qy,qz	=0,qx/m,qy/m,qz/m
			th			=halfpi
			s			=1
		end
		local t0=tick()
		return lastcframe,p0,v0,p1,v1,x,y,z,qw,qx,qy,qz,th,s,t0
	end	
	
	function tween.playsequence(object,index,queue,current)
		if tweendata[object] then
			tweendata[object]()
		end
		current=current or 1
		local prop=queue[current]
		local time=prop.time or prop[1]
		local equation=prop.equation or prop[2]
		local nextcframe=prop.nextcframe or prop[3]
		local onfinished=prop.onfinish or prop[4]
		local lastcframe,p0,v0,p1,v1,x,y,z,qw,qx,qy,qz,th,s,t0=calculatestuff(object,index,equation,nextcframe)
		local stop;stop=updater:connect(function()
			local u=(tick()-t0)/time
			local v=1-u
			if u>1 then
				object[index]=lastcframe*qpow(x,y,z,qw,qx,qy,qz,th,s,p1)
				stop()
				if onfinished then onfinished() end
				if current<#queue then
					tween.playsequence(object,index,queue,current+1)
				end
			else
				local t=p0*v*v*v+(3*p0+v0)*u*v*v+(3*p1-v1)*u*u*v+p1*u*u*u
				object[index]=lastcframe*qpow(x,y,z,qw,qx,qy,qz,th,s,t)
			end
		end)
		tweendata[object]=stop
		return function()
			if tweendata[object] then
				tweendata[object]()
			end
		end
	end
	
	function tween.tweencframe(object,index,time,equation,nextcframe,onfinished)
		if tweendata[object] then
			tweendata[object]()
		end
		local lastcframe,p0,v0,p1,v1,x,y,z,qw,qx,qy,qz,th,s,t0=calculatestuff(object,index,equation,nextcframe)
		local stop;stop=updater:connect(function()
			local u=(tick()-t0)/time
			local v=1-u
			if u>1 then
				object[index]=lastcframe*qpow(x,y,z,qw,qx,qy,qz,th,s,p1)
				stop()
				tweendata[object]=nil
				if onfinished then onfinished() end
			else
				local t=p0*v*v*v+(3*p0+v0)*u*v*v+(3*p1-v1)*u*u*v+p1*u*u*u
				object[index]=lastcframe*qpow(x,y,z,qw,qx,qy,qz,th,s,t)
			end
		end)
		tweendata[object]=stop
		return function()
			if tweendata[object] then
				tweendata[object]()
			end
		end
	end
	
	function tween.freebody(object,index,life,cframe0,velocity0,rotation0,acceleration)
		local position0=cframe0.p
		local matrix0=cframe0-position0
		local tick0=tick()
		local stop;stop=updater:connect(function()
			local t=tick()-tick0
			if life and t>life then
				stop()
				object:Destroy()
			end
			object[index]=cframe.fromaxisangle(t*rotation0)*matrix0+position0+t*velocity0+t*t*acceleration
		end)
		return stop
	end
end

--animation module
print("Loading animation module")
do
	local next			=next	
	local tick			=tick
	local v3			=vector.new
	local nv			=v3()
	local inverse		=CFrame.new().inverse
	local clone			=game.Clone
	
	local updater		={}
	local fireupdater	=event.new(updater)
	local gravity		=v3(0,-150,0)
	
	
	function animation.play(parts,welds,sequence)
		local cframes		={}
		local nextframetick	=tick()
		local framenumber	=0
		for i,part in next,parts do
			cframes[i]=part.CFrame
		end
		local stop;stop=updater:connect(function(dt)
			if framenumber~=#sequence and nextframetick<tick() then
				framenumber=framenumber+1
				local frame=sequence[framenumber]
				nextframetick=nextframetick+frame.delay
				for i=1,#frame do
					local data=frame[i]
					local partname=data.part
					local part=parts[partname]
					local weld=welds[partname]
					if data.transparency then
						part.Transparency=data.transparency
					end
					if data.drop then
						local newpart=clone(part)
						newpart.Parent=camera.currentcamera
						local rot0=cframe.toaxisangle(part.CFrame*inverse(cframes[partname]))/dt
						tween.freebody(newpart,"CFrame",data.t,part.CFrame,(part.Position-cframes[partname].p)/dt+(data.velocity or nv),rot0,gravity)
					end
					if data.c0 then
						weld.C0=data.c0
					end
					if data.c1 then
						tween.tweencframe(weld,"C0",data.t,data.eq or "smooth",data.c1)
					end
				end
			end
			for i,part in next,parts do
				cframes[i]=part.CFrame
			end
		end)
	end
	
	function animation.step(dt)
		fireupdater(dt)
	end

	
	
end

--input module
print("Loading input module")
do
	input.keyboard				={}
	input.keyboard.down			={}
	input.keyboard.onkeydown	={}
	input.keyboard.onkeyup		={}
	input.mouse					={}
	input.mouse.delta			=Vector3.new()
	input.mouse.Position		=Vector3.new()
	input.mouse.down			={}
	input.mouse.onbuttondown	={}
	input.mouse.onbuttonup		={}
	input.mouse.onmousemove		={}

	local lower					=string.lower
	local tick					=tick
	local userinput				=game:GetService("UserInputService")

	local fireonkeydown			=event.new(input.keyboard.onkeydown)
	local fireonkeyup			=event.new(input.keyboard.onkeyup)
	local fireonbuttondown		=event.new(input.mouse.onbuttondown)
	local fireonbuttonup		=event.new(input.mouse.onbuttonup)
	local fireonmousemove		=event.new(input.mouse.onmousemove)

	userinput.InputChanged:connect(function(object)
		input.mouse.delta=object.Delta
		input.mouse.position=object.Position
		fireonmousemove(input.mouse.position,input.mouse.delta)
	end)

	userinput.InputBegan:connect(function(object)
		local type=object.UserInputType.Name
		if type=="Keyboard" then
			local key=lower(object.KeyCode.Name)
			input.keyboard.down[key]=tick()
			fireonkeydown(key)
		elseif type=="MouseButton1" then
			input.mouse.down.left=tick()
			fireonbuttondown("left")
		elseif type=="MouseButton2" then
			input.mouse.down.right=tick()
			fireonbuttondown("right")
		elseif type=="MouseButton3" then
			input.mouse.down.middle=tick()
			fireonbuttondown("middle")
		end
	end)

	userinput.InputEnded:connect(function(object)
		local type=object.UserInputType.Name
		if type=="Keyboard" then
			local key=lower(object.KeyCode.Name)
			input.keyboard.down[key]=nil
			fireonkeyup(key)
		elseif type=="MouseButton1" then
			input.mouse.down.left=nil
			fireonbuttonup("left")
		elseif type=="MouseButton2" then
			input.mouse.down.right=nil
			fireonbuttonup("right")
		elseif type=="MouseButton3" then
			input.mouse.down.middle=nil
			fireonbuttonup("middle")
		end
	end)

	function input.mouse:hide()
		userinput.MouseIconEnabled=false
	end

	function input.mouse:show()
		userinput.MouseIconEnabled=true
	end

	function input.mouse:lockcenter()
		userinput.MouseBehavior="LockCenter"
	end

	function input.mouse:free()
		userinput.MouseBehavior="Default"
	end

	function input.mouse:lock()
		userinput.MouseBehavior="LockCurrentPosition"
	end
end

--localchar module
print("Loading localchar module")
do
	localchar.jumpheight		=5
	localchar.player			=game.Players.LocalPlayer
	localchar.maxhealth			=100
	localchar.health			=localchar.maxhealth
	localchar.recoveryrate		=2
	localchar.recoverywait		=4

	local next					=next
	local random				=math.random
	local pi					=math.pi
	local clone					=game.Clone
	local v3					=Vector3.new
	local new					=Instance.new
	local cf					=CFrame.new
	local angles				=CFrame.Angles
	local deg					=pi/180
	
	local guns					={}
	local equipped				=nil
	local player				=localchar.player
	local joints				=game.JointsService
	local repstore				=game.ReplicatedStorage
	local vectorspring			=physics.spring.new(vector.identity)
	local scalarspring			=physics.spring.new()
	local walkspring			=physics.spring.new(16)
	local stancespring			=physics.spring.new(0)
	local lastdamaged			=0
	local curstance				="stand"
	local standcf				=cframe.identity
	local crouchcf				=cframe.new(0,-1.5,0)
	local pronecf				=cframe.new(0,-2.75,0)*angles(-math.pi/2,0,0)
	local bodyforce				=new("BodyForce")
	local larm					=repstore.Character["Left Arm"]:Clone()
	local rarm					=repstore.Character["Right Arm"]:Clone()
	local groundnorm			=v3(0,1,0)
	local lweld
	local rweld

	
	vectorspring.s				=16
	scalarspring.s				=16
	walkspring.s				=8
	stancespring.s				=8
	stancespring.d				=0.75
	utility.weldmodel(larm,larm.Arm)
	utility.weldmodel(rarm,rarm.Arm)
	larm.Parent=workspace.CurrentCamera
	rarm.Parent=workspace.CurrentCamera		
	
	function localchar:setspeed(s)
		walkspring.t=s
	end
	
	function localchar:setstance(s)
		curstance=s
		stancespring.t=s=="stand" and 0 or s=="crouch" and 1 or s=="prone" and 3
	end
	
	function localchar:getstance()
		return curstance
	end
	
	function localchar:sethealth(h)
		if h<0 then
			lastdamaged=tick()
		end
		localchar.health=localchar.health+h
		if localchar.health>localchar.maxhealth then
			localchar.health=localchar.maxhealth		
		end
	end
	
	function localchar:jump()
		local ray=Ray.new(localchar.rootpart.CFrame*v3(0,-2.5,0),v3(0,-1,0))
		if workspace:FindPartOnRay(ray,localchar.character) then
			bodyforce.force=v3(0,10,0)
			localchar.rootpart.Velocity=localchar.rootpart.Velocity+v3(0,(392.4*localchar.jumpheight)^0.5,0)
			bodyforce.force=v3(0,0,0)
		end
	end
	
	local function getname(object)
		return object.Name
	end
	
	local function getpart1name(object)
		return object.Part1.Name
	end

	function localchar:loadgun(gundata)
		local self={}
		local model				=clone(gundata.model)		
		local active			=false
		local gunweld			=new("Weld",joints)
		local parts				=utility.arraytohash(utility.getdescendants(model,"BasePart"),getname)
		local welds				=utility.arraytohash(utility.weldmodel(model,model[gundata.base]),getpart1name)
		local fakewelds			={}
		
		for i,v in next,welds do
			fakewelds[i]={C0=v.C0}
		end
		
		function self:equip()
			model.Parent=camera.currentcamera
			active=true
		end
		
		function self:unequip()
			model.Parent=nil
			active=false
		end
		
		function self.step(dt)
			for i,v in next,fakewelds do
				welds[i]=fakewelds[i]
			end
		end

		--[[
		
		
		
		function self:fire(_,n)
			if active then
				local time=tick()
				nextshot=nextshot>time and nextshot or time
				if n then
					if burst==0 then
						burst=n
					end
				else
					auto=true
				end
			end
		end

		function self:stop()
			auto=false
		end

		function self:load(newrounds)
			rounds=newrounds
			self.rounds=newrounds
		end
		
		self.disconnect=camera.onpostrender:connect(function()
			local time=tick()
			while rounds>0 and (auto or burst>0) and time>=nextshot do
				burst=burst-1
				rounds=rounds-1
				self.rounds=rounds
				nextshot=nextshot+60/firerate
				camera:shake(v3(kickupmin+kickuprange*random(),kickleft+kickrange*random(),kickroll))
				rotationspring:accelerate(v3(modelkickup,0,0))
				positionspring:accelerate(v3(0,0,modelkickback))
				kickroll=-kickroll
			end
			if rounds==0 then
				burst=0
			end
			gunweld.C0=cframe.tos(
				localchar.rootpart.CFrame,
				camera.cframe*offset0
				*cframe.new(positionspring.p)
				*cframe.fromaxisangle(rotationspring.p)
				*offset1
			)
		end)
		
		return self]]
	end

	function localchar.step(dt)
		local stance=stancespring.p/3
		local movement=vectorspring.p
		localchar.speed=scalarspring.p
		localchar.distance=localchar.distance+dt*localchar.speed
		localchar.velocity=movement
		scalarspring.t=movement.magnitude
		vectorspring.t=localchar.rootpart.Velocity*v3(1,0,1)
		localchar.rootpart.CFrame=angles(0,camera.angles.y,0)+localchar.rootpart.Position
		local _,_,norm=workspace:FindPartOnRay(Ray.new(localchar.rootpart.CFrame*v3(0,-2.5,0),v3(0,-10,0)),localchar.character)
		norm=norm.Magnitude<0.001 and v3(0,1,0) or norm
		groundnorm=vector.slerp(groundnorm,norm,2*dt)
		local flushcf=cframe.direct(pronecf,v3(0,0,1),cframe.vtos(localchar.rootpart.CFrame,groundnorm))+v3(0,0.5/groundnorm.y,0)
		localchar.humanoid.WalkSpeed=walkspring.p
		localchar.rootjoint.C0=cframe.interpolate(cframe.interpolate(standcf,crouchcf,stance),cframe.interpolate(crouchcf,flushcf,stance),stance)
		if tick()>lastdamaged+localchar.recoverywait and localchar.health<localchar.maxhealth then
			localchar.health=localchar.health+dt*localchar.recoveryrate
			if localchar.health>localchar.maxhealth then
				localchar.health=localchar.maxhealth		
			end
		end
	end
	local rd=math.rad
	function localchar.steppostcamera(dt)
		if not equipped then
			lweld.C0=localchar.rootpart.CFrame:inverse()*camera.cframe*cf(-0.8,-0.9,-1)*angles(rd(90),rd(-90),0)
			rweld.C0=localchar.rootpart.CFrame:inverse()*camera.cframe*cf(0.8,-0.9,-1)*angles(rd(90),rd(90),0)
		end
	end
	
	local function characterupdater(character)
		for i=1,#guns do
			guns[i].disconnect()
		end
		localchar.character=character
		localchar.humanoid=utility.waitfor(character,1,"Humanoid")
		localchar.rootpart=utility.waitfor(character,1,"HumanoidRootPart")
		localchar.rootjoint=utility.waitfor(localchar.rootpart,1,"RootJoint")
		bodyforce.Parent=localchar.rootpart
		localchar.rootjoint.C1=cframe.identity
		localchar.torso=utility.waitfor(character,1,"Torso")
		localchar.head=utility.waitfor(character,1,"Head")
		localchar.distance=0
		localchar.velocity=vector.identity
		localchar.speed=0
		local bodyparts=utility.getdescendents(character,"BasePart")
		for i=1,#bodyparts do
			bodyparts[i].Transparency=0
		end
		local hats=utility.getdescendents(character,"Hat")
		for i=1,#hats do
			hats[i].Handle.Transparency=1
		end
		local sc=utility.getdescendents(character,"Script")
		for i=1,#sc do
			sc[i]:Destroy()
		end
		local lsc=utility.getdescendents(character,"LocalScript")
		for i=1,#lsc do
			lsc[i]:Destroy()
		end	
		localchar.humanoid:ClearAllChildren()
		localchar.humanoid.AutoRotate=false
		localchar.humanoid.Changed:connect(function()
			if localchar.humanoid.Jump then
				localchar.humanoid.Jump = false
			end
		end)
		lweld=utility.weld(localchar.rootpart,larm.Arm,cf(-1,.5,0)*angles(rd(60),0,0))
		rweld=utility.weld(localchar.rootpart,rarm.Arm,cf(1,.5,0)*angles(rd(60),0,0))
	end
	
	player.CharacterAdded:connect(characterupdater)
	
	characterupdater(game.Players.LocalPlayer.Character)
end

--camera module
print("Loading camera module")
do
	local e					=2.718281828459045
	local pi				=3.141592653589793
	local ln				=math.log
	local cos				=math.cos
	local tick				=tick
	local v3				=Vector3.new
	local cf				=CFrame.new
	local angles			=CFrame.Angles
	local nv				=v3()
	local tan				=math.tan
	local atan				=math.atan
	local deg				=pi/180
	
	camera.currentcamera	=game.Workspace.CurrentCamera
	camera.type				="firstperson"
	camera.sensitivity		=1
	camera.basefov			=80
	camera.target			=utility.waitfor(game.Players.LocalPlayer.Character,10,"Torso")
	camera.offset			=Vector3.new(0,1.5,0)	
	camera.angles			=Vector3.new()
	camera.maxangle			=15/32*pi
	camera.minangle			=-15/32*pi
	camera.cframe			=CFrame.new()
	camera.lookvector		=Vector3.new(0,0,-1)
	camera.shakespring		=physics.spring.new(Vector3.new())
	camera.magspring		=physics.spring.new(0)
	camera.onprerender		={}
	camera.onpostrender		={}	

	local recover			=false
	local fireonprerender	=event.new(camera.onprerender)
	local fireonpostrender	=event.new(camera.onpostrender)

	camera.shakespring.s	=12
	camera.shakespring.d	=0.65
	camera.magspring.s		=8
	camera.magspring.d		=1
	camera.currentcamera.CameraType="Scriptable"


	function camera:shake(a)
		camera.shakespring:accelerate(a)
	end
	
	function camera:magnify(m)
		camera.magspring.t=ln(m)
	end
	
	function camera:setmag(m)
		camera.magspring.p=ln(m)
		camera.magspring.t=ln(m)
	end

	function camera.step(dt)
		fireonprerender(camera)
		camera.currentcamera.FieldOfView=2*atan(tan(camera.basefov*deg/2)/e^camera.magspring.p)/deg
		if camera.type=="firstperson" then
			local s,d=localchar.speed,localchar.distance
			camera.cframe=angles(0,camera.angles.y,0)
				*angles(camera.angles.x,0,0)
				*cframe.fromaxisangle(camera.shakespring.p)
				*cframe.fromaxisangle(s*cos(d+2)/2048,s*cos(d/2)/2048,s*cos(d/2+2)/8192)
				*cf(0,0,0.5)
				+camera.target.CFrame
				*camera.offset
			camera.lookvector=camera.cframe.lookVector
			camera.currentcamera.CoordinateFrame=camera.cframe
		elseif camera.type=="spectate" then
		else
		end
		fireonpostrender(camera)
	end

	input.mouse.onmousemove:connect(function(_,delta)
		local coef=camera.sensitivity*atan(tan(camera.basefov*deg/2)/e^camera.magspring.p)/(32*pi)
		local x=camera.angles.x-coef*delta.y
		x=x>camera.maxangle and camera.maxangle
			or x<camera.minangle and camera.minangle
			or x
		local y=camera.angles.y-coef*delta.x
		camera.angles=v3(x,y,0)
	end)
	
	game.Players.LocalPlayer.CharacterAdded:connect(function(character)
		camera.target=character:WaitForChild("Torso")
	end)
end

--run module
print("Loading run module")
do
	run.time			=tick()
	run.dt				=1/60
	run.framerate		=60
	run.onstep			={}
	run.onthink			={}

	local tick			=tick
	local renderstepped	=game:GetService("RunService").RenderStepped
	local wait			=renderstepped.wait

	local engine		={
		localchar.step;
		camera.step;
		localchar.steppostcamera;
		animation.step;
		tween.step;
	}
	local gamelogic		={
		--[[{func=function() print("lol") end;
		interval=2;
		lasttime=run.time;};]]
	}
	local fireonstep	=event.new(run.onstep)
	local fireonthink	=event.new(run.onthink)
	
	function run.wait()
		wait(renderstepped)
	end

	renderstepped:connect(function()
		run.dt=tick()-run.time
		run.time=run.time+run.dt
		run.framerate=0.95*run.framerate+0.05/run.dt
		for i=1,#engine do
			engine[i](run.dt)
		end
		for i=1,#gamelogic do
			local v=gamelogic[i]
			if run.time>v.lasttime+v.interval then
				v.func(run.dt)
				v.lasttime=v.lasttime+v.interval
			end
		end
		fireonstep(run.dt)
	end)

	game:GetService("RunService").Stepped:connect(function()
		fireonthink()
	end)
end
input.mouse:lockcenter()


---------TESTING CENTER-----------
local crap=workspace:GetChildren()
for i=1,#crap do
	if crap[i].Name=="Delete" then
		crap[i]:Destroy()
	end
end
localchar:loadgun(require(game.ReplicatedStorage.GunModules.MP7))

localchar.humanoid.StateChanged:connect(function(old,new)
	if old~=Enum.HumanoidStateType.Swimming and new==Enum.HumanoidStateType.Swimming then
		localchar:setspeed(16)
		localchar:setstance("stand")
	end
end)
local flash=Instance.new("SpotLight",localchar.head)
flash.Angle=90
flash.Brightness=100
flash.Range=20
flash.Enabled=false
--flash.Color=Color3.new(137/255, 255/255, 73/255)
flash.Shadows=true
input.keyboard.onkeydown:connect(function(key) 
	if key == "f5" then
		game.ReplicatedStorage.Events.Respawn:FireServer()
	elseif key == "c" then
		if localchar.humanoid:GetState()==Enum.HumanoidStateType.Swimming then return end
		localchar:setspeed(localchar:getstance()=="crouch" and 2 or 8)
		localchar:setstance(localchar:getstance()=="crouch" and "prone" or "crouch")
	elseif key == "x" then
		localchar:setspeed(16)
		localchar:setstance("stand")
	elseif key == "f" then
		local p = Instance.new("Part",workspace)
		p.Anchored=true
		p.CanCollide=false
		p.CFrame=camera.cframe*cframe.new(0,0,-1)
		p.Name="Delete"
		local v=(camera.cframe-camera.cframe.p)*vector.new(0,0,-50)
		local r=10*vector.random()
		local stop;stop=run.onstep:connect(function(dt)
			v=v+vector.new(0,-dt*32,0)
			p.CFrame=p.CFrame*cframe.fromaxisangle(dt*r)+dt*v
			if p.Position.y<0 then
				stop()
				p:Destroy()
			end
		end)
	elseif key == "e" then
		if flash.Enabled then
			flash.Enabled=false
		else
			flash.Enabled=true
		end
	elseif key == "leftcontrol" then
		if localchar.humanoid:GetState()==Enum.HumanoidStateType.Swimming then return end
		localchar:setspeed(3)
		localchar:setstance("prone")
	elseif key == "leftshift" then
		localchar:setspeed(24)
		localchar:setstance("stand")
	elseif key == "space" then
		if localchar:getstance()=="crouch" or localchar:getstance()=="prone" then
			localchar:setspeed(16)
			localchar:setstance("stand")
		else
			localchar:jump()
		end
	elseif key == "g" then
		print(localchar.humanoid:GetState())
	end
end)
input.keyboard.onkeyup:connect(function(key) 
	if key == "leftshift" then
		localchar:setspeed(16)
	end
end)
input.mouse.onbuttondown:connect(function(type)
	if type == "right" then
		camera:magnify(12)
	elseif type == "left" then
		
		local p = Instance.new("Part",workspace)
		p.Anchored=true
		p.CanCollide=false
		p.formFactor="Custom"
		p.BrickColor=BrickColor.new("Bright yellow")
		p.Size=Vector3.new(0.2,0.2,3)
		p.CFrame=camera.cframe*cframe.new(0.7,-0.8,-1)
		p.Name="Delete"
		local bm=Instance.new("BlockMesh",p)
		bm.Scale=Vector3.new(0.5,0.5,3)
		local v=(camera.cframe-camera.cframe.p)*vector.new(0,0,-400)
		local r=vector.new(-0.05,0,0)
		local stop;stop=run.onstep:connect(function(dt)
			v=v+vector.new(0,-dt*32,0)
			p.CFrame=p.CFrame*cframe.fromaxisangle(dt*r)+dt*v
			if p.Position.y<0 then
				stop()
				p:Destroy()
			end
		end)
		
		camera:shake(vector.new(1,math.random()-.5,math.random()-.5))
	end
end)
input.mouse.onbuttonup:connect(function(type)
	if type == "right" then
		camera:magnify(1)
	end
end)
-----------------------------------



return {vector=vector,cframe=cframe,utility=utility,event=event,physics=physics,tween=tween,run=run}