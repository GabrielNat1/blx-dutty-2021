local vector={}
local cframe={}
local network={}
local utility={}
local event={}
local sequencer={}
local physics={}
local tween={}
local animation={}
local input={}
local char={}
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
	vector.lerp=nv.lerp
	
	function vector.random(a,b)
		local p		=acos(1-2*random())/3
		local z		=3^0.5*sin(p)-cos(p)
		local r		=((1-z*z)*random())^0.5
		local t		=6.28318*random()
		local x		=r*cos(t)
		local y		=r*sin(t)
		if a and b then
			local m	=(a+(b-a)*random())/(x*x+y*y+z*z)^0.5
			return	v3(m*x,m*y,m*z)
		elseif a then
			return	v3(a*x,a*y,a*z)
		else
			return	v3(x,y,z)
		end
	end
	
	function vector.slerp(v0,v1,t)
		local x0,y0,z0		=v0.x,v0.y,v0.z
		local x1,y1,z1		=v1.x,v1.y,v1.z
		local m0			=(x0*x0+y0*y0+z0*z0)^0.5
		local m1			=(x1*x1+y1*y1+z1*z1)^0.5
		local co			=(x0*x1+y0*y1+z0*z1)/(m0*m1)
		if co<-0.99999 then
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
		elseif co<0.99999 then
			local th		=acos(co)
			local s			=((1-t)*m0+t*m1)/(1-co*co)^0.5
			local s0		=s/m0*sin((1-t)*th)
			local s1		=s/m1*sin(t*th)
			return			v3(
							s0*x0+s1*x1,
							s0*y0+s1*y1,
							s0*z0+s1*z1
							)
		elseif 1e-5<m0 or 1e-5<m1 then
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
local cframe={} do
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
	local tos			=nc.toObjectSpace
	local vtos			=nc.vectorToObjectSpace
	local backcf		=cf(0,0,0,-1,0,0,0,1,0,0,0,-1)

	cframe.identity		=nc
	cframe.new			=cf
	cframe.vtws			=nc.vectorToWorldSpace
	cframe.tos			=nc.toObjectSpace
	cframe.ptos			=nc.pointToObjectSpace
	cframe.vtos			=nc.vectorToObjectSpace
	

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
		if co<-0.99999 then
			local x=xx+yx+zx+1
			local y=xy+yy+zy+1
			local z=xz+yz+zz+1
			local m=pi*(x*x+y*y+z*z)^-0.5
			return v3(m*x,m*y,m*z)
		elseif co<0.99999 then
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

	function cframe.toquaternion(c)
		local x,y,z,
			xx,yx,zx,
			xy,yy,zy,
			xz,yz,zz	=components(c)
		local tr		=xx+yy+zz
		if tr>2.99999 then
			return		x,y,z,0,0,0,1
		elseif tr>-0.99999 then
			local m		=2*(tr+1)^0.5
			return		x,y,z,
						(yz-zy)/m,
						(zx-xz)/m,
						(xy-yx)/m,
						m/4
		else
			local qx	=xx+yx+zx+1
			local qy	=xy+yy+zy+1
			local qz	=xz+yz+zz+1
			local m		=(qx*qx+qy*qy+qz*qz)^0.5
			return		x,y,z,qx/m,qy/m,qz/m,0
		end
	end
	
	function cframe.power(c,t)
		local x,y,z,
			xx,yx,zx,
			xy,yy,zy,
			xz,yz,zz	=components(c)
		local tr		=xx+yy+zz
		if tr>2.99999 then
			return		cf(t*x,t*y,t*z)
		elseif tr>-0.99999 then
			local m		=2*(tr+1)^0.5
			local qw	=m/4
			local th	=acos(qw)
			local s		=(1-qw*qw)^0.5
			local c		=sin(th*t)/s
			return		cf(
						t*x,t*y,t*z,
						c*(yz-zy)/m,
						c*(zx-xz)/m,
						c*(xy-yx)/m,
						c*qw+sin(th*(1-t))/s
						)
		else
			local qx	=xx+yx+zx+1
			local qy	=xy+yy+zy+1
			local qz	=xz+yz+zz+1
			local c		=sin(halfpi*t)/(qx*qx+qy*qy+qz*qz)^0.5
			return		cf(
						t*x,t*y,t*z,
						c*qx,
						c*qy,
						c*qz,
						sin(halfpi*(1-t))
						)
		end
	end

	local power=cframe.power
	function cframe.interpolate(c0,c1,t)
		return c0*power(tos(c0,c1),t)
	end

	local toquaternion=cframe.toquaternion
	function cframe.interpolator(c0,c1)
		if c1 then
			local x0,y0,z0,qx0,qy0,qz0,qw0=toquaternion(c0)
			local x1,y1,z1,qx1,qy1,qz1,qw1=toquaternion(c1)
			local x,y,z=x1-x0,y1-y0,z1-z0
			local c=qx0*qx1+qy0*qy1+qz0*qz1+qw0*qw1
			if c<0 then
				qx0,qy0,qz0,qw0=-qx0,-qy0,-qz0,-qw0
			end
			if c<0.9999 then
				local s=(1-c*c)^0.5
				local th=acos(c)
				return function(t)
					local s0=sin(th*(1-t))/s
					local s1=sin(th*t)/s
					return cf(
						x0+t*x,
						y0+t*y,
						z0+t*z,
						s0*qx0+s1*qx1,
						s0*qy0+s1*qy1,
						s0*qz0+s1*qz1,
						s0*qw0+s1*qw1
					)
				end
			else
				return function(t)
					return cf(x0+t*x,y0+t*y,z0+t*z,qx1,qy1,qz1,qw1)
				end
			end
		else
			local x,y,z,qx,qy,qz,qw=cframe.toquaternion(c0)
			if qw<0.9999 then
				local s=(1-qw*qw)^0.5
				local th=acos(qw)
				return function(t)
					local s1=sin(th*t)/s
					return cf(
						t*x,
						t*y,
						t*z,
						s1*qx,
						s1*qy,
						s1*qz,
						sin(th*(1-t))/s+s1*qw
					)
				end
			else
				return function(t)
					return cf(t*x,t*y,t*z,qx,qy,qz,qw)
				end
			end
		end
	end
end
















--network module
print("Loading network module")
do
	local remoteevent	=game.ReplicatedStorage:WaitForChild("RemoteEvent")
	local remotefunc	=game.ReplicatedStorage:WaitForChild("RemoteFunction")
	local fireserver	=remoteevent.FireServer
	local invokeserver	=remotefunc.InvokeServer

	local funcs={}

	function network:add(name,func)
		funcs[name]=func
	end

	function network:send(...)
		fireserver(remoteevent,...)
	end

	function network:fetch(...)
		return invokeserver(remotefunc,...)
	end
	
	local function call(name,...)
		return funcs[name](...)
	end

	remoteevent.OnClientEvent:connect(call)
	remotefunc.OnClientInvoke=call
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
	
	function utility.getdescendants(object,type)
		type=type or "Instance"
		local descendants=getchildren(object)
		local i=0
		while i<#descendants do
			i=i+1
			local children=getchildren(descendants[i])
			for j=1,#children do
				descendants[#descendants+1]=children[j]
			end
		end
		local newdescendants={}
		for i=1,#descendants do
			if rtype(descendants[i],type) then
				newdescendants[#newdescendants+1]=descendants[i]
			end
		end
		return newdescendants
	end
	
	function utility.weld(part0,part1,c0)
		c0=c0 or tos(part0.CFrame,part1.CFrame)
		local newweld=new("Weld",part0)
		newweld.Part0=part0
		newweld.Part1=part1
		newweld.C0=c0
		return newweld
	end
	
	function utility.weldmodel(model,basepart)
		local weldcframes={}
		local children=model:GetChildren()--utility.getdescendants(model,"BasePart")
		basepart=basepart-- or children[1]
		local welds={}
		welds[0]=basepart
		local basecframe=basepart and basepart.CFrame
		for i=1,#children do
			if children[i]:IsA("BasePart") then
				weldcframes[i]=tos(basecframe,children[i].CFrame)
			end
		end
		for i=1,#children do
			if children[i]:IsA("BasePart") then
				local newweld=new("Weld",basepart)
				newweld.Part0=basepart
				newweld.Part1=children[i]
				newweld.C0=weldcframes[i]
				welds[i]=newweld
				children[i].Anchored=false
			end
		end
		basepart.Anchored=false
		return welds
	end
	
	function utility.removevalue(array,removals)
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
		self
	end
end
















--sequence module
print("Loading sequence module")
do
	local tick		=tick
	local type		=type
	local remove	=table.remove

	function sequencer.new()
		local self={}

		local t0
		local sequence	={}
		local n			=0
		local deletions	=0

		function self:add(func,dur)
			n=n+1
			if n==1 then
				t0=tick()
			end
			sequence[n]={
				func=func;
				dur=dur;
			}
		end

		function self:delay(dur)
			n=n+1
			if n==1 then
				t0=tick()
			end
			sequence[n]={
				dur=dur;
			}
		end

		function self:clear()
			for i=1,n do
				sequence[i]=nil
			end
			n=0
		end

		function self:step()
			local time=tick()
			if deletions~=0 then
				for i=deletions+1,n do
					sequence[i-deletions]=sequence[i]
				end
				for i=n-deletions+1,n do
					sequence[i]=nil
				end
				n=n-deletions
				deletions=0
			end
			for i=1,n do
				local d=time-t0
				local func=sequence[i]
				local dur=func.dur
				local stop=false
				if func.func then
					stop=func.func(d)
				end
				if stop or stop==nil or dur and dur<d then
					t0=time
					deletions=deletions+1
				else
					break
				end
			end
		end

		return self
	end
end
















--physics module
print("Loading physics module")
do
	local cos			=math.cos
	local sin			=math.sin
	local setmetatable	=setmetatable
	local tick			=tick

	physics.spring		={}

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
					error(index.." is not a valid member of spring",0)
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
					error(index.." is not a valid member of spring",0)
				end
				t0=time
			end;
		})
	end
end

















--tween module
print("Loading tween module")
do
	local type			=type
	local halfpi		=math.pi/2
	local acos			=math.acos
	local sin			=math.sin
	local cf			=CFrame.new
	local tos			=cf().toObjectSpace
	local components	=cf().components
	local tick			=tick

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

	local updater		={}
	tween.step			=event.new(updater)

	function tween.tweencframe(object,index,time,equation,nextcframe)
		if tweendata[object] then
			tweendata[object]()
		end
		local t0=tick()
		local p0,v0,p1,v1
		if type(equation)=="table" then
			p0=equation[1]
			v0=equation[2]
			p1=equation[3]
			v1=equation[4]
		else
			local eq=equations[equation]
			p0,v0,p1,v1=eq.p0,eq.v0,eq.p1,eq.v1
		end
		local interpolator=cframe.interpolator(object[index],nextcframe)
		local stop;stop=updater:connect(function()
			local u=(tick()-t0)/time
			if u>1 then
				object[index]=interpolator(p1)
				stop()
				tweendata[object]=nil
			else
				local v=1-u
				local t=p0*v*v*v+(3*p0+v0)*u*v*v+(3*p1-v1)*u*u*v+p1*u*u*u
				object[index]=interpolator(t)
			end
		end)
		tweendata[object]=stop
		return stop
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
















--input module
print("Loading input module")
do
	local tick					=tick
	local lower					=string.lower
	local userinput				=game:GetService("UserInputService")

	input.keyboard				={}
	input.keyboard.down			={}
	input.keyboard.onkeydown	={}
	input.keyboard.onkeyup		={}
	input.mouse					={}
	input.mouse.Position		=Vector3.new()
	input.mouse.down			={}
	input.mouse.onbuttondown	={}
	input.mouse.onbuttonup		={}
	input.mouse.onmousemove		={}
	input.mouse.onscroll		={}

	local fireonkeydown			=event.new(input.keyboard.onkeydown)
	local fireonkeyup			=event.new(input.keyboard.onkeyup)
	local fireonbuttondown		=event.new(input.mouse.onbuttondown)
	local fireonbuttonup		=event.new(input.mouse.onbuttonup)
	local fireonmousemove		=event.new(input.mouse.onmousemove)
	local fireonscroll			=event.new(input.mouse.onscroll)

	userinput.InputChanged:connect(function(object)
		local position=object.Position;input.mouse.position=position
		local delta=object.Delta
		if 0<delta.magnitude then
			fireonmousemove(input.mouse.position,object.Delta)
		end
		if position.z~=0 then
			fireonscroll(position.z)
		end
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
	
	function input.mouse.visible()
		return userinput.MouseIconEnabled
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
















--animation module
print("Loading animation module")
do
	local sin			=math.sin
	local acos			=math.acos
	local type			=type
	local next			=next	
	local tick			=tick
	local cf			=CFrame.new
	local v3			=vector.new
	local nv			=v3()
	local inverse		=CFrame.new().inverse
	local tos			=CFrame.new().toObjectSpace
	local toquaternion	=cframe.toquaternion
	local clone			=game.Clone
	local joints		=game.JointsService
	local new			=Instance.new

	local equations		={
		linear			={p0=0;v0=1;p1=1;v1=1};
		smooth			={p0=0;v0=0;p1=1;v1=0};
		accelerate		={p0=0;v0=0;p1=1;v1=1};
		decelerate		={p0=0;v0=1;p1=1;v1=0};
		bump			={p0=0;v0=4;p1=0;v1=-4};
		acceleratebump	={p0=0;v0=0;p1=0;v1=-6.75};
		deceleratebump	={p0=0;v0=6.75;p1=0;v1=0};
	}

	local function interpolator(c0,c1,t0,dur,eq)
		local p0,v0,p1,v1
		if type(eq)=="table" then
			p0,v0,p1,v1=eq[1],eq[2],eq[3],eq[4]
		else
			local eq=equations[eq or "smooth"]
			p0,v0,p1,v1=eq.p0,eq.v0,eq.p1,eq.v1
		end
		local x0,y0,z0,qx0,qy0,qz0,qw0=toquaternion(c0)
		local x1,y1,z1,qx1,qy1,qz1,qw1=toquaternion(c1)
		local x,y,z=x1-x0,y1-y0,z1-z0
		local c=qx0*qx1+qy0*qy1+qz0*qz1+qw0*qw1
		if c<0 then
			qx0,qy0,qz0,qw0=-qx0,-qy0,-qz0,-qw0
		end
		if c<0.99999 then
			local s=(1-c*c)^0.5
			local th=acos(c)
			return function(t)
				t=(t-t0)/dur;t=t<1 and t or 1
				local i=1-t
				local v=p0*i*i*i+(3*p0+v0)*t*i*i+(3*p1-v1)*t*t*i+p1*t*t*t
				local s0=sin(th*(1-v))/s
				local s1=sin(th*v)/s
				return cf(
					x0+v*x,
					y0+v*y,
					z0+v*z,
					s0*qx0+s1*qx1,
					s0*qy0+s1*qy1,
					s0*qz0+s1*qz1,
					s0*qw0+s1*qw1
				),1==t,t
			end
		else
			return function(t)
				t=(t-t0)/dur;t=t<1 and t or 1
				local i=1-t
				local v=p0*i*i*i+(3*p0+v0)*t*i*i+(3*p1-v1)*t*t*i+p1*t*t*t
				return cf(x0+v*x,y0+v*y,z0+v*z,qx1,qy1,qz1,qw1),1==t,t
			end
		end
	end

	function animation.player(modeldata,sequence)
		local interpolators	={}
		local framenumber	=1
		local t0			=0
		local timescale		=sequence.timescale

		return function(time)
			for i=framenumber,#sequence do
				local frame=sequence[i]
				if t0<time then
					for i=1,#frame do
						local data=frame[i]
						local partname=data.part
						if not modeldata[partname] then
							error("Error in frame: "..framenumber..". "..partname.. " is not in modeldata")
						end
						if data.c0 then
							interpolators[partname]=nil
							modeldata[partname].weld.C0=data.c0=="base" and modeldata[partname].basec0 or data.c0
						end
						if data.c1 then
							interpolators[partname]=interpolator(modeldata[partname].weld.C0,data.c1=="base" and modeldata[partname].basec0 or data.c1,t0,data.t*timescale or frame.delay,data.eq)
						end
						if data.clone then
							if modeldata[data.clone] then
								error("Error in frame: "..framenumber..". Cannot clone "..partname..". "..data.clone.." already exists.")
							end
							local part=clone(modeldata[partname].part)
							part.Parent=workspace.CurrentCamera
							local weld=new("Weld",part)
							weld.Part0=data.part0 and modeldata[data.part0].part or modeldata[partname].weld.Part0
							weld.Part1=part
							weld.C0=weld.Part0.CFrame:inverse()*modeldata[partname].weld.Part0.CFrame*modeldata[partname].weld.C0					
							modeldata[data.clone]={
								part=part;
								weld=weld;
								clone=true;
							}
						end
						if data.transparency then
							modeldata[partname].part.Transparency=data.transparency
						end
						if data.drop then
							modeldata[partname].weld.Parent=nil
							tween.freebody(modeldata[partname].part,"CFrame",1,modeldata[partname].part.CFrame,nv,nv,Vector3.new(0,-32/(timescale*timescale),0))
							modeldata[partname]=nil
							interpolators[partname]=nil
						end
						if data.delete then
							modeldata[partname].weld.Parent=nil
							modeldata[partname].part.Parent=nil
							modeldata[partname]=nil
							interpolators[partname]=nil
						end
					end
					t0=t0+frame.delay*timescale
					framenumber=framenumber+1
				else
					break
				end
			end
			for i,v in next,interpolators do
				local newcf,stop,t=v(time)
				modeldata[i].weld.C0=newcf
				if stop then
					interpolators[i]=nil
				end
				
			end
			if t0<time then
				for i,v in next,modeldata do
					if v.clone then
						v.weld.Parent=nil
						v.part.Parent=nil
						modeldata[i]=nil
					end
				end
			end
			return t0<time
		end
	end

	function animation.reset(modeldata,t)
		local interpolators={}
		for i,v in next,modeldata do
			if v.clone then
				modeldata[i]=nil
				v.weld.Parent=nil
				v.part.Parent=nil
			else
				if v.part then
					v.part.Transparency=v.basetransparency
				end
				interpolators[i]=interpolator(v.weld.C0,v.basec0,0,t or 1)
			end
		end
		return function(time)
			for i,v in next,interpolators do
				local newcf,stop=v(time)
				modeldata[i].weld.C0=newcf
			end
			return t<time
		end
	end
end
















--char module
print("Loading char module")
do
	local rtype			=game.IsA
	local next			=next
	local new			=Instance.new
	local wfc			=game.WaitForChild
	local getchildren	=game.GetChildren
	local workspace		=game.Workspace
	local cf			=CFrame.new
	local vtws			=CFrame.new().vectorToWorldSpace
	local angles		=CFrame.Angles
	local nc			=cf()
	local v3			=Vector3.new
	local nv			=v3()

	local player=game.Players.LocalPlayer
	local character
	local humanoid
	local rootpart
	local rootjoint



	--Randomass shit
	local aiming			=false
	local shooting			=false
	local reloading			=false
	local sprinting			=false
	local sprintspring		=physics.spring.new()
	local aimspring			=physics.spring.new()
	local swingspring		=physics.spring.new(nv)
	local speedspring		=physics.spring.new()
	local velocityspring	=physics.spring.new(nv)
	local walkspeedmult		=1
	sprintspring.s			=12
	sprintspring.d			=0.9
	aimspring.d				=0.9
	swingspring.s			=10
	swingspring.d			=0.75
	speedspring.s			=12
	velocityspring.s		=12




	--MOVEMENT MODULE LOLOLOL
	local ignore			={workspace.CurrentCamera}
	local bodyforce			=new("BodyForce")
	local walkspeedspring
	local headheightspring
	local updatewalkspeed

	bodyforce.force			=nv

	do
		local ray			=Ray.new
		local raycast		=workspace.FindPartOnRayWithIgnoreList

		local movementmode	="stand"
		local basewalkspeed	=12--arb
		local down			=v3(0,-4,0)--arb
		local standcf		=nc
		local crouchcf		=cf(0,-1.5,0)--arb
		local pronecf		=cf(0,-2,1.5,1,0,0,0,0,1,0,-1,0)--arb
		walkspeedspring		=physics.spring.new(basewalkspeed)
		walkspeedspring.s	=8--arb
		headheightspring	=physics.spring.new(1.5)
		headheightspring.s	=8--arb

		function updatewalkspeed()
			if sprinting then
				walkspeedspring.t=1.5*walkspeedmult*basewalkspeed
			elseif movementmode=="prone" then
				walkspeedspring.t=walkspeedmult*basewalkspeed/4--arb
			elseif movementmode=="crouch" then
				walkspeedspring.t=walkspeedmult*basewalkspeed/2--arb
			elseif movementmode=="stand" then
				walkspeedspring.t=walkspeedmult*basewalkspeed
			end
		end

		local function setmovementmode(self,mode)
			char.movementmode=mode
			movementmode=mode
			if mode=="prone" then
				headheightspring.t=-2--arb
				rootjoint.C0=pronecf
				walkspeedspring.t=walkspeedmult*basewalkspeed/4--arb
			elseif mode=="crouch" then
				headheightspring.t=0--arb
				rootjoint.C0=crouchcf
				walkspeedspring.t=walkspeedmult*basewalkspeed/2--arb
			elseif mode=="stand" then
				headheightspring.t=1.5--arb
				rootjoint.C0=standcf
				walkspeedspring.t=walkspeedmult*basewalkspeed
			end
			sprinting=false
			sprintspring.t=0
		end
		char.setmovementmode=setmovementmode

		function char:setsprint(on)
			if on then
				setmovementmode(nil,"stand")
				sprinting=true
				shooting=false
				aiming=false
				walkspeedmult=1
				aimspring.t=0
				camera:magnify(1)
				if not reloading then
					sprintspring.t=1
				end
				walkspeedspring.t=1.5*walkspeedmult*basewalkspeed--arb
			elseif sprinting then
				sprinting=false
				sprintspring.t=0
				walkspeedspring.t=walkspeedmult*basewalkspeed
			end
		end

		function char:jump(height)
			local rootcf=rootpart.CFrame
			if raycast(workspace,ray(rootcf.p,vtws(rootcf,down)),ignore) then
				if movementmode=="prone" or movementmode=="crouch" then
					setmovementmode(nil,"stand")
				else
					rootpart.Velocity=rootpart.Velocity+v3(0,height and (392.4*height)^0.5 or 40,0)
				end
			end
		end
	end








	--WEAPONS MODULE LEL

	--Add dynamic animation shit
	--Inspection
	--Spotting
	local weps=0
	local weapon	=nil
	local equipping	=false
	local thread	=sequencer.new()
	local rweld		=new("Weld")
	local lweld		=new("Weld")
	local larm
	local rarm
	local lmodel
	local rmodel
	local lmain
	local rmain
	local sin=math.sin
	local cos=math.cos
	
	local function gunbob(a,r)
		local a,r=a or 1,r or 1
		local d,s,v=char.distance*6.28318,char.speed,-char.velocity
		local w=v3(r*sin(d/4-1)/256+r*(sin(d/64)-r*v.z/4)/512,r*cos(d/128)/128-r*cos(d/8)/256,r*sin(d/8)/128+r*v.x/1024)*s/20*6.28318
		return cf(r*cos(d/8-1)*s/196,1.25*a*sin(d/4)*s/512,0)*cframe.fromaxisangle(w)
	end

	local tos=CFrame.new().toObjectSpace
	local function weldmodel(model,mainpart)
		local welddata={}
		local parts=getchildren(model)
		local maincf=mainpart.CFrame
		for i=1,#parts do
			local part=parts[i]
			if part~=mainpart then
				local name=part.Name
				local c0=tos(maincf,part.CFrame)
				local weld=new("Weld",mainpart)
				weld.Part0=mainpart
				weld.Part1=part
				weld.C0=c0
				welddata[name]={
					part=part;
					weld=weld;
					basec0=c0;
					basetransparency=part.Transparency;
				}
			end
		end
		return welddata
	end

	local clone			=game.Clone
	local currentcamera	=game.Workspace.CurrentCamera
	function char:loadarms(newlarm,newrarm,newlmain,newrmain)
		larm,rarm,lmain,rmain=newlarm,newrarm,newlmain,newrmain
		lmodel=clone(larm,weapon and currentcamera)
		rmodel=clone(rarm,weapon and currentcamera)
		local lmainpart=lmodel[newlmain]
		local rmainpart=rmodel[newrmain]
		weldmodel(lmodel,lmainpart)
		weldmodel(rmodel,rmainpart)
		lweld.Part0=rootpart
		lweld.Part1=lmainpart
		lweld.Parent=lmainpart
		rweld.Part0=rootpart
		rweld.Part1=rmainpart
		rweld.Parent=rmainpart
	end

	do
		local equipspring		=physics.spring.new(1)
		equipspring.s			=12--arb
		equipspring.d			=0.75--arb

		local function reweld(welddata)
			for i,v in next,welddata do
				if v.clone then
					welddata[i]=nil
					v.weld.Parent=nil
					v.part.Parent=nil
				else
					v.weld.C0=v.basec0
					if v.part then
						v.part.Transparency=v.basetransparency
					end
				end
			end
		end

		local rand=math.random
		local function pickv3(v0,v1)
			return v0+v3(rand(),rand(),rand())*(v1-v0)
		end

		function char:loadgun(data,model,mag,chambered,sparerounds)
			local self={}
			weps=weps+1
			local name=weps
			--General things I guess.
			local main				=data.mainpart
			local mainoffset		=data.mainoffset
			local mainpart			=model[main]
			local equipped			=false
			
			--shooting stuff
			local firerate			=data.firerate
			local spare				=sparerounds or data.sparerounds
			local chamber			=data.chamber
			local magsize			=data.magsize
			local mag				=chamber and mag and mag+1 or mag or magsize
			local nextshot

			--Static animation data stuff
			local animating			=false
			local animdata			=weldmodel(model,mainpart)
			local mainweld			=new("Weld",mainpart)
			animdata[main]			={weld={C0=nc},basec0=nc}
			animdata.larm			={weld={C0=data.larmoffset},basec0=data.larmoffset}
			animdata.rarm			={weld={C0=data.rarmoffset},basec0=data.rarmoffset}

			mainweld.Part0			=rootpart
			mainweld.Part1			=mainpart
			
			--Dynamic animation stuff OMG prepare for flood
			local kickmultiplier	=1
			local equipcf			=data.equipoffset
			local sprintcf			=cframe.interpolator(data.sprintoffset)
			local aimcf				=cframe.interpolator(data.aimoffset)
			local transkickspring	=physics.spring.new(nv)
			local rotkickspring		=physics.spring.new(nv)
			transkickspring.s		=data.modelkickspeed
			rotkickspring.s			=data.modelkickspeed
			transkickspring.d		=data.modelkickdamper
			rotkickspring.d			=data.modelkickdamper

			--[[function updateshooting()
				local coef=data.modelkickspeed/data.modelrecoverspeed
				if not shooting then
					transkickspring.s=data.modelrecoverspeed
					rotkickspring.s=data.modelrecoverspeed
					transkickspring.v=transkickspring.v/coef
					rotkickspring.v=rotkickspring.v/coef
				else
					transkickspring.s=data.modelkickspeed
					rotkickspring.s=data.modelkickspeed
					transkickspring.v=transkickspring.v*coef
					rotkickspring.v=rotkickspring.v*coef
				end
			end]]
			
			function self:setequipped(on)
				if on and (not equipped or not equipping) then
					print("Equipping weapon",name)
					equipping=true
					thread:clear()
					if weapon then
						weapon:setequipped(false)
					end
					thread:add(function()
						camera.shakespring.s=data.camkickspeed
						aimspring.s=data.aimspeed
						lmodel.Parent=currentcamera
						rmodel.Parent=currentcamera
						equipspring.t=0
						reweld(animdata)
						equipped=true
						weapon=self
						model.Parent=currentcamera
						equipping=false
						print("Equipped weapon",name)
					end)
				elseif not on and equipped then
					--Set equipped to false here?
					print("Unequipping weapon",name)
					shooting=false
					reloading=false
					equipspring.t=1
					thread:clear()
					thread:add(animation.reset(animdata,0.25))--arb
					thread:add(function()
						equipped=false
						lmodel.Parent=nil
						rmodel.Parent=nil
						model.Parent=nil
						animating=false
						weapon=nil
						print("Unequipped weapon",name)
					end)
				end
			end
			
			function self:setaim(on)
				aiming=on
				if aiming and not reloading and equipped then
					camera:magnify(data.zoom)
					aimspring.t=1
					sprinting=false
					sprintspring.t=0
					walkspeedmult=data.aimwalkspeedmult
				elseif not aiming then
					camera:magnify(1)
					aimspring.t=0
					walkspeedmult=1
				end
				updatewalkspeed()
			end
			
			function self:reload()
				if not reloading and spare~=0 and mag~=(chamber and magsize+1 or magsize) then
					animating=true
					reloading=true
					shooting=false
					aiming=false

					sprintspring.t=0
					aimspring.t=0
					camera:magnify(1)
					walkspeedmult=1
					updatewalkspeed()

					thread:clear()
					if animating then
						thread:add(animation.reset(animdata,0.25))
					end
					print("Loaded weapon\n\tSpare\t"..spare.."\n\tMag\t"..mag)
					if mag==0 then
						thread:add(animation.player(animdata,data.animations.reload))
					else
						thread:add(animation.player(animdata,data.animations.tacticalreload))
					end
					thread:add(function()
						reloading=false
						if sprinting then
							sprintspring.t=1
						end
						thread:add(animation.reset(animdata,0.5))
						spare=spare+mag
						mag=(mag==0 or not chamber) and (spare<magsize and spare or magsize)
							or (spare<magsize and spare+1 or magsize+1)
						spare=spare-mag
						print("Loaded weapon\n\tSpare\t"..spare.."\n\tMag\t"..mag)
					end)
				end
			end

			function self:shoot(arg)
				if not reloading and not shooting or shooting==true and not equipping then
					sprinting=false
					sprintspring.t=0
					shooting=arg
				end
				if shooting then
					kickmultiplier=data.aimkickmult
				else
					kickmultiplier=1
				end
			end

			function self.step()
				--shoot a round
				local time=tick()
				if not shooting then
					nextshot=tick()
				end
				while shooting and 0<mag and nextshot<time do
					--shooty
					transkickspring:accelerate(kickmultiplier*pickv3(data.transkickmin,data.transkickmax))
					rotkickspring:accelerate(kickmultiplier*pickv3(data.rotkickmin,data.rotkickmax))
					camera:shake(pickv3(data.camkickmin,data.camkickmax))
					nextshot=nextshot+60/firerate
					mag=mag-1
					if mag==0 then
						shooting=false
					elseif shooting~=true then
						if shooting==1 then
							shooting=false
						else
							shooting=shooting-1
						end
					end
				end
				--Animate gun
				local mainweldc0=rootpart.CFrame:inverse()
					*workspace.CurrentCamera.CoordinateFrame--opti
					*mainoffset
					*aimcf(aimspring.p)*animdata[main].weld.C0
					--*cf(-velocityspring.v/8192)
					*cf(0,0,1)*cframe.fromaxisangle(swingspring.v)*cf(0,0,-1)
					*gunbob(1-0.5*aimspring.p,1.5-1.2*aimspring.p)
					*cframe.interpolate(sprintcf(sprintspring.p),data.equipoffset,equipspring.p)
					*cf(transkickspring.p)
					*cframe.fromaxisangle(rotkickspring.p)
				mainweld.C0=mainweldc0
				--Animate arms
				lweld.C0=mainweldc0*cframe.interpolate(cframe.interpolate(animdata.larm.weld.C0,data.larmaimoffset,aimspring.p),data.larmsprintoffset,sprintspring.p)
				rweld.C0=mainweldc0*cframe.interpolate(cframe.interpolate(animdata.rarm.weld.C0,data.rarmaimoffset,aimspring.p),data.rarmsprintoffset,sprintspring.p)
			end
			
			return self
		end
	end









	function char.step(dt)
		--Movement step
		local a=velocityspring.v
		swingspring.t=v3(a.z/1024/32-a.y/1024/16-camera.delta.x/1024,a.x/1024/32-camera.delta.y/1024,camera.delta.y/1024)
		humanoid.WalkSpeed=walkspeedspring.p
		char.headheight=headheightspring.p
		rootpart.CFrame=angles(0,camera.angles.y,0)+rootpart.Position
		speedspring.t=(v3(1,0,1)*rootpart.Velocity).magnitude
		velocityspring.t=cframe.vtos(rootpart.CFrame,rootpart.Velocity)
		char.distance=char.distance+dt*speedspring.p
		char.speed=speedspring.p
		char.velocity=velocityspring.p
	end

	function char.animstep(dt)
		thread:step()
		if weapon then
			weapon.step()
		end
	end








	--This should never break hopefully
	do
		local destroy=game.Destroy
		char.onspawn={}
		local fireonspawn=event.new(char.onspawn)
		
		local removals={
			face=true;
			Sound=true;
			Health=true;
			Animate=true;
			Animator=true;
			ForceField=true;
		}

		local function getdescendants(object,descendants)
			descendants=descendants or {}
			local children=getchildren(object)
			for i=1,#children do
				local child=children[i]
				descendants[#descendants+1]=child
				getdescendants(child,descendants)
			end
			return descendants
		end

		local function dealwithit(object)
			if rtype(object,"Script") then
				object.Disabled=true
			elseif removals[object.Name] then
				wait()--Fuck you.
				destroy(object)
			elseif rtype(object,"BasePart") then
				object.Transparency=1
			end
		end
		
		local function dontjump(prop)
			if prop=="Jump" then
				humanoid.Jump=false
			end
		end

		local function loadcharacter()
			repeat wait() until player.Character and player.Character.Parent
			character=player.Character
			character.ChildAdded:connect(dealwithit)
			local descendants=getdescendants(character)
			for i=1,#descendants do
				dealwithit(descendants[i])
			end
			
			player:ClearCharacterAppearance()
			
			char.distance=0
			char.velocity=nv
			char.speed=0
			velocityspring.t=nv
			velocityspring.p=nv
			speedspring.t=0
			speedspring.p=0
			
			humanoid=wfc(character,"Humanoid");char.humanoid=humanoid
			rootpart=wfc(character,"HumanoidRootPart");char.rootpart=rootpart
			rootjoint=wfc(rootpart,"RootJoint")
			rootjoint.C0=nc
			rootjoint.C1=nc
			workspace.CurrentCamera:ClearAllChildren()
			humanoid.AutoRotate=false
			humanoid.Changed:connect(dontjump)
			bodyforce.Parent=rootpart
			ignore[2]=character
			if larm and rarm then
				char:loadarms(larm,rarm,lmain,rmain)
			end
			fireonspawn()
		end

		player.CanLoadCharacterAppearance=false
		loadcharacter()
		player.CharacterAdded:connect(loadcharacter)
	end
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
	camera.sensitivity		=0.5
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
	camera.delta			=nv
	camera.onprerender		={}
	camera.onpostrender		={}
	local ldt				=1/60

	local fireonprerender	=event.new(camera.onprerender)
	local fireonpostrender	=event.new(camera.onpostrender)

	camera.shakespring.s	=12
	camera.shakespring.d	=0.65
	camera.magspring.s		=12
	camera.magspring.d		=1
	camera.currentcamera.CameraType="Scriptable"

	function camera:shake(a)
		camera.shakespring:accelerate(a)
	end
	
	function camera:magnify(m)
		camera.magspring.t=ln(m)
	end
	
	function camera:setmagnification(m)
		local lnm=ln(m)
		camera.magspring.p=lnm
		camera.magspring.t=lnm
	end
	
	function camera:setmagnificationspeed(s)
		camera.magspring.s=s
	end

	function camera.step(dt)
		ldt=dt
		fireonprerender(camera)
		camera.currentcamera.FieldOfView=2*atan(tan(camera.basefov*deg/2)/e^camera.magspring.p)/deg
		if camera.type=="firstperson" then
			local s,d=3/2*char.speed,char.distance*6.28318/4
			local cameracframe=angles(0,camera.angles.y,0)
				*angles(camera.angles.x,0,0)
				*cframe.fromaxisangle(camera.shakespring.p)
				*cframe.fromaxisangle(s*cos(d+2)/2048,s*cos(d/2)/2048,s*cos(d/2+2)/8192)
				*cf(0,0,0.5)
				+char.rootpart.CFrame
				*v3(0,char.headheight,0)
			camera.lookvector=cameracframe.lookVector
			camera.currentcamera.CoordinateFrame=cameracframe;camera.cframe=cameracframe
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
		local newangles=v3(x,y,0)
		camera.delta=(newangles-camera.angles)/ldt
		camera.angles=newangles
	end)

	input.mouse:hide()
	input.mouse:lockcenter()
	game.Players.LocalPlayer.CharacterAdded:connect(function()
		wait()--God damn
		input.mouse:hide()
		input.mouse:lockcenter()
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
		char.step;
		camera.step;
		char.animstep;
		tween.step;
		--char.steppostcamera;
	}
	local gamelogic		={
		{func=function() end;
		interval=2;
		lasttime=run.time;};
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


---------TESTING CENTER-----------

--[[local gunm=Instance.new("Model")
Instance.new("Part",gunm)

local gun=char:loadgun{
	model=gunm;
	mainpart="Part";
	mainoffset=CFrame.new(1,-1,-2);
	equipoffset=CFrame.new(1,-2,-1);
	animations={
		testanim={
			{
				delay=1;
				{
					part="Part";
					c1=CFrame.new(0,1,0);
					eq="smooth";
					d=0.5;
				},
			},
			{
				delay=1;
				{
					part="Part";
					c1=CFrame.new(0,0,0);
					eq="smooth";
					d=0.5;
				},
			},
		};
	};
}]]
wait(1)
local rep=game.ReplicatedStorage
char:loadarms(rep.Character["Left Arm"],rep.Character["Right Arm"],"Arm","Arm")

local player=game.Players.LocalPlayer
local gunms=player.PlayerGui.GModel:GetChildren()
local modules=player.PlayerGui.GModule:GetChildren()
local g1=char:loadgun(require(modules[1]),gunms[1])
local g2=char:loadgun(require(modules[2]),gunms[2])
local aiming
local gun=g1
gun:setequipped(true)

input.mouse.onbuttondown:connect(function(button)
	if button=="left" then
		gun:shoot(true)
	elseif button=="right" then
		gun:setaim(true)
	end
end)

input.mouse.onscroll:connect(function(z)
	gun=gun==g1 and g2 or g1
	gun:setequipped(true)
end)

input.mouse.onbuttonup:connect(function(button)
	if button=="left" then
		gun:shoot(false)
	elseif button=="right" then
		gun:setaim(false)
	end
end)

input.keyboard.onkeydown:connect(function(key)
	print(key)
	if key=="space" then
		char:jump()
	elseif key=="c" then
		char:setmovementmode("crouch")
	elseif key=="leftcontrol" then
		char:setmovementmode("prone")
	elseif key=="z" then
		char:setmovementmode("stand")
	elseif key=="r" then
		gun:reload()
	elseif key=="leftshift" then
		char:setsprint(true)
	elseif key=="one" then
		gun=g2
		gun:setequipped(true)
		gun=g1
		gun:setequipped(true)
	elseif key=="two" then
		gun=g2
		gun:setequipped(true)
	elseif key=="q" then
		aiming=not aiming
		gun:setaim(aiming)
	end
end)
input.keyboard.onkeyup:connect(function(key)
	if key=="leftshift" then
		char:setsprint(false)
	end
end)
char.onspawn:connect(function()
	gunms=player.PlayerGui.GModel:GetChildren()
	modules=player.PlayerGui.GModule:GetChildren()
	g1=char:loadgun(require(modules[1]),gunms[1])
	g2=char:loadgun(require(modules[2]),gunms[2])
	gun=g1
	gun:setequipped(true)
end)


-----------------------------------



return --{vector=vector,cframe=cframe,utility=utility,event=event,physics=physics,tween=tween,run=run}