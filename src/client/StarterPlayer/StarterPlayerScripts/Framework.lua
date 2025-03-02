local vector={}
local cframe={}
local network={}
local playerdata={}
local trash={}
local utility={}
local event={}
local sequencer={}
local physics={}
local particle={}
local sound={}
local effects={}
local tween={}
local animation={}
local input={}
local char={}
local camera={}
local chat={}
local hud={}
local notify={}
local leaderboard={}
local replication={}
local menu={}
local roundsystem={}
local run={}
local gamelogic={}

--LOLTASTIC Good for figuring out bugs.
--leleltru=({Player=true;Player1=true;Player2=true;AxisAngle=true;litozinnamon=true;shaylan007=true,Buddyism=true;Quaternions=true;LuaWeaver=true;QuaternionsIsAdolf=true;})[game.Players.LocalPlayer.Name]
leleltru=({AxisAngle=true;litozinnamon=true;shaylan007=true;Buddyism=true;Forbidden_Croissant=true})[game.Players.LocalPlayer.Name]

local loltimescale=1
local lolgravity=Vector3.new(0,-196.2,0)
print(lolgravity)
local loltick=tick
local function tick()
	return loltimescale*loltick()
end
game.StarterGui.ResetPlayerGuiOnSpawn=false
game.StarterGui:SetCoreGuiEnabled("All",false)

math.randomseed(tick())
local realprint=print
--local print=function() end


if loltimescale>=2 then
	local s=Instance.new("Sound",game.Workspace)
	s.SoundId="http://roblox.com/asset/?id=145542130"
	s.Looped=true
	s:Play()
end


--- CAMO TESTING
if leleltru then
	game.ReplicatedStorage.GunModels["SCAR-L"]:Destroy()
	game.ReplicatedStorage.GunModels["spSCAR-L"].Name="SCAR-L"
end
---


--vector module
--
print("Loading vector module")
do
	local pi		=math.pi
	local cos		=math.cos
	local sin		=math.sin
	local acos		=math.acos
	local asin		=math.asin
	local atan2		=math.atan2
	local random	=math.random
	local v3		=Vector3.new
	local nv		=Vector3.new()

	vector.identity=nv
	vector.new=v3
	vector.lerp=nv.lerp
	vector.cross=nv.Cross
	vector.dot=nv.Dot
	
	function vector.random(a,b)
		local p		=acos(1-2*random())/3
		local z		=3^0.5*sin(p)-cos(p)
		local r		=((1-z*z)*random())^0.5
		local t		=6.28318*random()
		local x		=r*cos(t)
		local y		=r*sin(t)
		if b then
			local m	=(a+(b-a)*random())/(x*x+y*y+z*z)^0.5
			return	v3(m*x,m*y,m*z)
		elseif a then
			return	v3(a*x,a*y,a*z)
		else
			return	v3(x,y,z)
		end
	end
	
	function vector.anglesyx(x,y)
		local cx=cos(x)
		return v3(-cx*sin(y),sin(x),-cx*cos(y))
	end
	
	function vector.toanglesyx(v)
		local x,y,z=v.x,v.y,v.z
		return asin(y/(x*x+y*y+z*z)^0.5),atan2(-x,-z)
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
--
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
	local tos			=nc.toObjectSpace
	local vtos			=nc.vectorToObjectSpace
	local ptos			=nc.pointToObjectSpace
	local backcf		=cf(0,0,0,-1,0,0,0,1,0,0,0,-1)
	local lerp			=nc.lerp

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

	function cframe.direct(c,look,newdir,t)
		local lx,ly,lz		=look.x,look.y,look.z
		local rv			=vtos(c,newdir)
		local rx,ry,rz		=rv.x,rv.y,rv.z
		local rl			=((rx*rx+ry*ry+rz*rz)*(lx*lx+ly*ly+lz*lz))^0.5
		local d				=(lx*rx+ly*ry+lz*rz)/rl
		if d<-0.99999 then
			return c*backcf
		elseif d<0.99999 then
			if t then
				local th	=t*acos(d)/2
				local qw	=cos(th)
				local m		=rl*((1-d*d)/(1-qw*qw))^0.5
				return		c*cf(
							0,0,0,
							(ly*rz-lz*ry)/m,
							(lz*rx-lx*rz)/m,
							(lx*ry-ly*rx)/m,
							qw
							)
			else
				local qw	=((d+1)/2)^0.5
				local m		=2*qw*rl
				return		c*cf(
							0,0,0,
							(ly*rz-lz*ry)/m,
							(lz*rx-lx*rz)/m,
							(lx*ry-ly*rx)/m,
							qw
							)
			end
		else
			return			c
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
--[[		local x,y,z,
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
end]]
		return lerp(nc,c,t)
	end

	--local power=cframe.power
	--[[function cframe.interpolate(c0,c1,t)
		--return c0*power(tos(c0,c1),t)
	end]]
	cframe.interpolate=lerp

	--local toquaternion=cframe.toquaternion
	function cframe.interpolator(c0,c1,c2)
		--[[if c1 then
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
		end]]
		if c2 then
			return function(t)
				return lerp(lerp(c0,c1,t),lerp(c1,c2,t),t)
			end
		elseif c1 then
			return function(t)
				return lerp(c0,c1,t)
			end
		else
			return function(t)
				return lerp(nc,c0,t)
			end
		end
	end

	function cframe.jointleg(r0,r1,c,p,a)
		local t=ptos(c,p)
		local tx,ty,tz=t.x,t.y,t.z
	
		--Calculate inverse kinemetics equation
		local d=(tx*tx+ty*ty+tz*tz)^0.5
		local nx,ny,nz=tx/d,ty/d,tz/d
		d=r0+r1<d and r0+r1 or d
		local l=(r1*r1-r0*r0-d*d)/(2*r0*d)
		local h=-(1-l*l)^0.5
	
		--Generate the natural quaternion for the shoulder.
		local m=(2*(1+h*ny+l*nz))^0.5
		local qw,qx,qy,qz=m/2,(h*nz-l*ny)/m,l*nx/m,-h*nx/m
	
		--If a, then rotate the natural quaternion by a.
		if a then
			local co,si=cos(a/2),sin(a/2)
			qw,qx,qy,qz=co*qw-si*(nx*qx+ny*qy+nz*qz),
				co*qx+si*(nx*qw-nz*qy+ny*qz),
				co*qy+si*(ny*qw+nz*qx-nx*qz),
				co*qz+si*(nz*qw-ny*qx+nx*qy)
		end
	
		--Generate the quaternion for the lower arm and return.
		local g=(d*l+r0)/(d*d+2*d*l*r0+r0*r0)^0.5
		local co=((1-g)/2)^0.5
		local si=-((1+g)/2)^0.5
		return c*cf(-r0*2*(qx*qz+qy*qw),
				r0*2*(qx*qw-qy*qz),
				r0*(2*(qx*qx+qy*qy)-1),
				co*qx+si*qw,
				co*qy+si*qz,
				co*qz-si*qy,
				co*qw-si*qx),
			c*cf(0,0,0,qx,qy,qz,qw)
	end

	function cframe.jointarm(r0,r1,c,p,a)
		local t=ptos(c,p)
		local tx,ty,tz=t.x,t.y,t.z
	
		--Calculate inverse kinemetics equation
		local d=(tx*tx+ty*ty+tz*tz)^0.5
		local nx,ny,nz=tx/d,ty/d,tz/d
		d=r0+r1<d and r0+r1 or d
		local l=(r1*r1-r0*r0-d*d)/(2*r0*d)
		local h=(1-l*l)^0.5
	
		--Generate the natural quaternion for the shoulder.
		local m=(2*(1+h*ny+l*nz))^0.5
		local qw,qx,qy,qz=m/2,(h*nz-l*ny)/m,l*nx/m,-h*nx/m
	
		--If a, then rotate the natural quaternion by a.
		if a then
			local co,si=cos(a/2),sin(a/2)
			qw,qx,qy,qz=co*qw-si*(nx*qx+ny*qy+nz*qz),
				co*qx+si*(nx*qw-nz*qy+ny*qz),
				co*qy+si*(ny*qw+nz*qx-nx*qz),
				co*qz+si*(nz*qw-ny*qx+nx*qy)
		end
	
		--Generate the quaternion for the lower arm and return.
		local g=(d*l+r0)/(d*d+2*d*l*r0+r0*r0)^0.5
		local co=((1-g)/2)^0.5
		local si=((1+g)/2)^0.5
		return c*cf(-r0*2*(qx*qz+qy*qw),
				r0*2*(qx*qw-qy*qz),
				r0*(2*(qx*qx+qy*qy)-1),
				co*qx+si*qw,
				co*qy+si*qz,
				co*qz-si*qy,
				co*qw-si*qx),
			c*cf(0,0,0,qx,qy,qz,qw)
	end
end
















--sphereray casting
--
local sphereraycast do
	local testinterval = 16
	
	local inf = 1 / 0
	local sort = table.sort

	local v3 = Vector3.new
	local nv = v3()
	local dot = nv.Dot
	local cross = nv.Cross
	local cf = CFrame.new
	local nc = cf()
	local ptos = nc.pointToObjectSpace
	local vtos = nc.vectorToObjectSpace
	local vtws = nc.vectorToWorldSpace
	local r3 = Region3.new
	
	local workspace = game.Workspace
	local boxcast = workspace.FindPartsInRegion3
	local getchildren = game.GetChildren
	local robloxtype = game.IsA
	
	local boxmesh = {
		{p = 0.5; n = v3(-1, 0, 0)},
		{p = 0.5; n = v3(1, 0, 0)},
		{p = 0.5; n = v3(0, -1, 0)},
		{p = 0.5; n = v3(0, 1, 0)},
		{p = 0.5; n = v3(0, 0, -1)},
		{p = 0.5; n = v3(0, 0, 1)},
	}
	
	local wedgemesh={
		{p = 0.5; n = v3(-1, 0, 0)},
		{p = 0.5; n = v3(1, 0, 0)},
		{p = 0.5; n = v3(0, -1, 0)},
		{p = 0; n = v3(0, 0.5^0.5, -0.5^0.5)},
		{p = 0.5; n = v3(0, 0, 1)},
	}
	
	local cornerwedgemesh={
		{p = 0.5; n = v3(1, 0, 0)},
		{p = 0.5; n = v3(0, -1, 0)},
		{p = 0.5; n = v3(0, 0, -1)},
		{p = 0; n = v3(0, 0.5^0.5, 0.5^0.5)},
		{p = 0; n = v3(-0.5^0.5, 0.5^0.5, 0)},
	}
	
	--Intersection of a sphereray and a plane
	local function solveplanesphereray(p, n, o, d, r)
		local no = dot(n, o)
		local dn = dot(d, n)
		local t = (p + r - no) / dn
		local v = o + t * d
		local h = v - r * n
		return v, t, h, n
	end
	
	local function solveraysphereray(ro, rd, so, sd, r)
		local rdro = dot(rd, ro)
		local roro = dot(ro, ro)
		local rdsd = dot(rd, sd)
		local rosd = dot(ro, sd)
		local rdso = dot(rd, so)
		local roso = dot(ro, so)
		local sdso = dot(sd, so)
		local soso = dot(so, so)
		local m = rdro - rdso
		local a = 1 - rdsd * rdsd
		local b = 2 * (rdsd * m - rosd + sdso)
		local c = roro - 2 * roso + soso - m * m - r * r
		local d = -b / (2 * a)
		local e2 = d * d - c / a
		if 0 < e2 then
			local t = d - e2 ^ 0.5
			local s = (rdsd * t - m)
			local v = so + t * sd
			local h = ro + s * rd
			local n = (v - h) / r
			return v, t, h, n
		end
	end
	
	local function solvepointsphereray(p, o, d, r)
		local oo = dot(o, o)
		local od = dot(o, d)
		local op = dot(o, p)
		local dp = dot(d, p)
		local pp = dot(p, p)
		local b = 2 * (od - dp)
		local c = oo - 2 * op + pp - r * r
		local g = -b / 2
		local e2 = g * g - c
		if 0 < e2 then
			local t = g - e2 ^ 0.5
			local v = o + t * d
			local n = (v - p) / r
			return v, t, p, n
		end
	end
	
	local function solvespheresphereray(p, e, o, d, r)
		local oo = dot(o, o)
		local od = dot(o, d)
		local op = dot(o, p)
		local dp = dot(d, p)
		local pp = dot(p, p)
		local b = 2 * (od - dp)
		local c = oo - 2 * op + pp - (r + e) * (r + e)
		local g = -b / 2
		local e2 = g * g - c
		if 0 < e2 then
			local t = g - e2 ^ 0.5
			local v = o + t * d
			local h = p + e / (r + e) * (v - p)
			local n = (v - h) / (r + e)
			return v, t, h, n
		end
	end
	
	local function distplanesphereray(p, n, o, d, r)
		local no = dot(n, o)
		local dn = dot(d, n)
		local t = (p + r - no) / dn
		return t
	end
	
	local function distpointsphereray(p, o, d, r)
		local oo = dot(o, o)
		local od = dot(o, d)
		local op = dot(o, p)
		local dp = dot(d, p)
		local pp = dot(p, p)
		local b = 2 * (od - dp)
		local c = oo - 2 * op + pp - r * r
		local g = -b / 2
		local e2 = g * g - c
		if 0 < e2 then
			local t = g - e2 ^ 0.5
			return t
		end
	end
	
	local function solveplaneplane(ap, an, bp, bn)
		local anbn = dot(an, bn)
		local canab = cross(an, bn)
		local s = 1 - anbn * anbn
		local o = (ap - anbn * bp) / s * an + (bp - ap * anbn) / s * bn
		local d = canab / s ^ 0.5
		return o, d
	end
	
	local function solverayplane(o, d, p, n)
		local dn = dot(d, n)
		local no = dot(n, o)
		local v = o + (p - no) / dn * d
		return v
	end
	
	local function distpointplane(v, p, n)
		local vn = dot(v, n)
		local t = vn - p
		return t
	end
	
	local function sortgreaterdist(a, b)
		return (b.dist or -inf) < (a.dist or -inf)
	end
	
	local function solvemeshsphereray(rawmesh, cframe, scale, origin, direction, radius)
		local o = ptos(cframe, origin)
		local d = vtos(cframe, direction)
		local r = radius--lelel
	
		local mesh = {}
		local nfront = 0
		for i = 1, #rawmesh do
			local plane = rawmesh[i]
			local sn = plane.n / scale
			local n = sn.unit
			local p = plane.p / sn.magnitude
			local newplane = {
				p = p;
				n = n;
			}
			if dot(n, d) < 0 then
				newplane.dist = distplanesphereray(p, n, o, d, r)
				nfront = nfront + 1
			end
			mesh[#mesh + 1] = newplane
		end
		
		sort(mesh, sortgreaterdist)
	
		for i = 1, nfront do
			local aplane = mesh[i]
			local apos, adist, ahit, anorm = solveplanesphereray(aplane.p, aplane.n, o, d, r)
			local agood = true
			for j = 1, #mesh do
				if i ~= j then
					local bplane = mesh[j]
					if 0 < distpointplane(ahit, bplane.p, bplane.n) then
						agood = false
						local aborigin, abdirection = solveplaneplane(aplane.p, aplane.n, bplane.p, bplane.n)
						local abpos, abdist, abhit, abnorm = solveraysphereray(aborigin, abdirection, o, d, r)
						if abpos then
							local abgood = true
							for k = 1, #mesh do
								if i ~= k and j ~= k then
									local cplane = mesh[k]
									local dist = distpointplane(abhit, cplane.p, cplane.n)
									if 0 < dist then
										abgood = false
										local abcpoint = solverayplane(aborigin, abdirection, cplane.p, cplane.n)
										local abcpos, abcdist, abchit, abcnorm = solvepointsphereray(abcpoint, o, d, r)
										if abcpos then
											local abcgood = true
											for l = 1, #mesh do
												if i ~= l and j ~= l and k ~= l then
													local dplane = mesh[l]
													local dist = distpointplane(abchit, dplane.p, dplane.n)
													if 0 < dist then
														abcgood = false
														break
													end
												end
											end
											if abcgood then
												return cframe * abcpos,
													abcdist,
													cframe * abchit,
													vtws(cframe, abcnorm)
											end
										end
									end
								end
							end
							if abgood then
								return cframe * abpos,
									abdist,
									cframe * abhit,
									vtws(cframe, abnorm)
							end
						end
					end
				end
			end
			if agood then
				return cframe * apos,
					adist,
					cframe * ahit,
					vtws(cframe, anorm)
			end
		end
	end
	
	local function sortdist(a, b)
		return a.dist < b.dist
	end
	
	local function solvepartsphereray(part, origin, direction, radius)
		local class = part.ClassName
		if class == "Part" then
			local shape = part.Shape.Name
			if shape == "Block" then
				return solvemeshsphereray(boxmesh, part.CFrame, part.Size, origin, direction, radius)
			elseif shape == "Ball" or shape == "Cylinder" then--LELELELELEL
				return solvespheresphereray(part.Position, part.Size.x / 2, origin, direction, radius)
			end
		elseif class == "TrussPart" then
			return solvemeshsphereray(boxmesh, part.CFrame, part.Size, origin, direction, radius)
		elseif class == "WedgePart" then
			return solvemeshsphereray(wedgemesh, part.CFrame, part.Size, origin, direction, radius)
		elseif class == "CornerWedgePart" then
			return solvemeshsphereray(cornerwedgemesh, part.CFrame, part.Size, origin, direction, radius)
		end
	end

	local function getallparts(directory)
		local shit = {directory}
		local i = 0
		while i < #shit do
			i = i + 1
			local children = getchildren(shit[i])
			for j = 1, #children do
				shit[#shit + 1] = children[j]
			end
		end
		local parts = {}
		for j = 1, #shit do
			if robloxtype(shit[j], "BasePart") then
				parts[#parts + 1] = shit[j]
			end
		end
		return parts
	end

	function sphereraycast(origin, direction, radius, ignore)
		local tested = {}
		if type(ignore) == "table" then
			for i = 1, #ignore do
				local parts = getallparts(ignore[i])
				for j = 1, #parts do
					tested[parts[j]] = true
				end
			end
		elseif ignore then
			local parts = getallparts(ignore)
			for j = 1, #parts do
				tested[parts[j]] = true
			end
		end
	
		local interval = testinterval
		local length = direction.magnitude
		local udirection = direction.unit
		local dx = udirection.x
		local dy = udirection.y
		local dz = udirection.z
		local radvec = v3(radius, radius, radius)
		local absvec = v3(dx < 0 and -dx or dx,
			dy < 0 and -dy or dy,
			dz < 0 and -dz or dz)
	
		local t = 0
		repeat
			local stop
			if length - t < interval then
				stop = true
				interval = length - t
			end
			local lower = origin + (t + interval / 2) * udirection - interval / 2 * absvec - radvec
			local upper = origin + (t + interval / 2) * udirection + interval / 2 * absvec + radvec
			t = t + interval
			local parts = boxcast(workspace, r3(lower, upper), nil, 100)
	
			local sorted = {}
			for i = 1, #parts do
				local part = parts[i]
				if not tested[part] then
					tested[part] = true
					local dist = distpointsphereray(part.Position, origin, udirection, radius + part.Size.magnitude / 2)
					if dist then
						sorted[#sorted + 1] = {
							part = part;
							dist = dist;
						}
					end
				end
			end
		
			sort(sorted, sortdist)
		
			local bestdist = direction.magnitude
			local bestpart, bestpos, besthit, bestnorm
			for i = 1, #sorted do
				local package = sorted[i]
				if package.dist < bestdist then
					local pos, dist, hit, norm = solvepartsphereray(package.part, origin, udirection, radius)
					if dist and 0 < dist and dist < bestdist then
						bestdist = dist
						bestpart = package.part
						bestpos = pos
						besthit = hit
						bestnorm = norm
					end
				else
					break
				end
			end
		
			if bestpos then
				return bestpart, bestpos, bestdist, besthit, bestnorm
			end
		until stop
	end
end
















--network module
--
print("Loading network module")
do
	local tick			=tick
	local player		=game.Players.LocalPlayer
	local remoteevent	=game.ReplicatedStorage:WaitForChild("RemoteEvent")
	local bounceevent	=game.ReplicatedStorage:WaitForChild("BounceEvent")
	local remotefunc	=game.ReplicatedStorage:WaitForChild("RemoteFunction")
	local fireserver	=remoteevent.FireServer
	local invokeserver	=remotefunc.InvokeServer

	local key			=1
	local funcs			={}
	local queue			={}

	function network:add(name,func)
		funcs[name]=func
		if queue[name] then
			for i=1,#queue[name] do
				func(unpack(queue[name][i]))
			end
		end
	end
	
	local function getkey()
		key=94906230*key%94906249
		return key
	end

	function network:send(...)
		fireserver(remoteevent,getkey(),...)
	end

	function network:bounce(...)
		fireserver(bounceevent,getkey(),...)
	end

	function network:fetch(...)
		return invokeserver(remotefunc,getkey(),...)
	end

	local function call(name,...)
		if funcs[name] then
			return funcs[name](...)
		else
			if not queue[name] then
				queue[name]={}
			end
			queue[name][#queue[name]+1]={...}
		end
	end

	bounceevent.OnClientEvent:connect(call)
	remoteevent.OnClientEvent:connect(call)
	function remotefunc.OnClientInvoke(name,...)
		if funcs[name] then
			return funcs[name](...)
		end
	end
	
	network:add("ping",function(servertick)
		--[==[antihack]==]network:send('p'..'i'..'n'..'g',servertick,player,tick())
		--network:send("ping",servertick,player,tick())
	end)
end






--playerdata module
--
print("Loading data module")
do
	local sub			=string.sub
	local find			=string.find
	local concat		=table.concat
	local type			=type

	local player		=game.Players.LocalPlayer
	local repstore		=game.ReplicatedStorage
	local gunmodules	=repstore.GunModules
	
	local userdatareaders={}
	local userdatawriters={}

	local cache			={}
	
	local function read(data,s)
		s=s or 1
		local nameend=find(data,"-",s)
		local numend=find(data,":",nameend+1)
		local type=sub(data,s,nameend-1)
		local len=sub(data,nameend+1,numend-1)+0
		local a,b=numend+1,numend+len
		if type=="b" then
			return sub(data,a,a)=="t",b
		elseif type=="n" then
			return sub(data,a,b)+0,b
		elseif type=="s" then
			return sub(data,a,b),b
		elseif type=="t" then
			local table,n={},0
			local i=a
			while i<=b do
				local value,e=read(data,i)
				local sep=sub(data,e+1,e+1)
				if sep=="=" then
					local index=value
					value,e=read(data,e+2)
					table[index]=value
				else
					n=n+1;table[n]=value
				end
				i=e+2
			end
			return table,b
		else
			return userdatareaders[type](data,a,b),b
		end
	end
	
	local function write(data)
		local dtype=type(data)
		if dtype=="boolean" then
			return data and "b-4:true" or "b-5:false",dtype
		elseif dtype=="number" then
			local str=data..""
			return "n-"..#str..":"..str,dtype
		elseif dtype=="string" then
			local lab="s-"..#data..":"
			return lab..data,dtype
		elseif dtype=="table" then
			local string,n={},1
			local len=0
			local i=1
			while data[i] do
				local str=write(data[i])..";"
				n=n+1;string[n]=str
				len=len+#str
				i=i+1
			end
			for k,v in next,data do
				if type(k)~="number" or i<k or k%1~=0 then
					local str=write(k).."="..write(v)..";"
					n=n+1;string[n]=str
					len=len+#str
				else
					print(k)
				end
			end
			string[1]="t-"..len..":"
			return concat(string),dtype
		else
			for i,v in next,userdatawriters do
				local ser=userdatawriters[i](data)
				if ser then
					return ser,i
				end
			end
		end
	end

	network:add("loadplayerdata",function(data)
		cache=data
		playerdata.loaded=true
	end)

	network:add("updateplayerdata",function(value,...)
		local keys={...}
		local data=cache
		for i=1,#keys-1 do
			if not data[keys[i]] then
				data[keys[i]]={}
			end
			data=data[keys[i]]
		end
		data[keys[#keys]]=value
	end)

	network:add("updateexperience",function(experience)
		cache.stats.experience=experience
	end)

	network:add("updatetotalkills",function(kills)
		cache.stats.totalkills=kills
	end)

	network:add("updatetotaldeaths",function(deaths)
		cache.stats.totaldeaths=deaths
	end)

	network:add("updategunkills",function(weapon,kills)
		local gundata=cache.unlocks[weapon]
		if not gundata then
			gundata={}
			cache.unlocks[weapon]=gundata
		end
		gundata.kills=kills
	end)

	network:add("purchasegun",function(weapon)
		local gundata=cache.unlocks[weapon]
		if not gundata then 
			gundata={}
			cache.unlocks[weapon]=gundata
		end
		gundata.paid=true
		menu:updategunpurchase(weapon)
	end)

	network:add("purchaseattachment",function(weapon,attachname)
		local gundata=cache.unlocks[weapon]
		if not gundata then 
			gundata={}
			cache.unlocks[weapon]=gundata
		end
		gundata[attachname]=true
		menu:updateattachpurchase(weapon,attachname)
	end)

	network:add("updatemoney",function(money)
		cache.stats.money=money
		menu:updatemoney(money)
	end)

	function playerdata.updateplayerdata(value,...)
		local keys={...}
		local data=cache
		for i=1,#keys-1 do
			if not data[keys[i]] then
				data[keys[i]]={}
			end
			data=data[keys[i]]
		end
		data[keys[#keys]]=value
		--[==[antihack]==]network:send('u'..'p'..'d'..'a'..'t'..'e'..'p'..'l'..'a'..'y'..'e'..'r'..'d'..'a'..'t'..'a',player,value,...)
		--network:send("updateplayerdata",player,value,...)
	end

	function playerdata.getdata()
		return cache
	end

	--[==[antihack]==]network:send('l'..'o'..'a'..'d'..'p'..'l'..'a'..'y'..'e'..'r'..'d'..'a'..'t'..'a',player)
	--network:send("loadplayerdata",player)

end


















--trash module
--
print("Loading trash module")
do
	local destroy=game.Destroy
	local shit={}
	function trash.remove(x)
		if x then
			shit[#shit+1]=x
			x.Parent=nil
		end
	end
	
	function trash.empty()
		print("taking out "..#shit.." trash")
		for i=1,#shit do
			destroy(shit[i])
		end
		shit={}
	end
	
	network:add("emptytrash",trash.empty)
end
















--utility module
--
print("Loading utility module")
do	
	local getchildren	=game.GetChildren
	local rtype			=game.IsA
	local joints		=game.JointsService
	local tos			=CFrame.new().toObjectSpace
	local tick			=tick
	local new			=Instance.new
	local waitforchild	=game.WaitForChild
	local ffc			=game.FindFirstChild

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
		local newweld=new("Motor6D",part0)
		newweld.Part0=part0
		newweld.Part1=part1
		newweld.C0=c0
		part0.Anchored=false
		part1.Anchored=false
		return newweld
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
--
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
					if functions[i] then
						functions[i](...)
					else
						print("AHHHHHH",i)
					end
				end
			end
		end,
		self
	end
end
















--sequencer module
--
print("Loading sequencer module")
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
			--print("added",func)
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
			--print("delaying",dur)
			n=n+1
			if n==1 then
				t0=tick()
			end
			sequence[n]={
				dur=dur;
			}
		end

		function self:clear()
			--print("cleared")
			for i=1,n do
				sequence[i]=nil
			end
			deletions=0
			n=0
		end

		function self:step()
			--print(unpack(sequence))
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
				local t=time-t0
				local func=sequence[i]
				local dur=func.dur
				local stop=false
				if func.func then
					stop=func.func(t)
				end
				if stop or stop==nil or dur and dur<t then
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
--
print("Loading physics module")
do
	local sort			=table.sort
	local atan2			=math.atan2
	local inf			=math.huge
	local cos			=math.cos
	local sin			=math.sin
	local setmetatable	=setmetatable
	local tick			=tick
	local dot			=Vector3.new().Dot

	physics.spring		={}

	do
		local cos=math.cos
		local sin=math.sin
		local e=2.718281828459045
		local setmt=setmetatable
		local error=error
		local tostring=tostring
		local tick=tick
	
		local function posvel(d,s,p0,v0,p1,v1,x)
			if s==0 then
				return p0
			elseif d<1-1e-8 then
				local h=(1-d*d)^0.5
				local c1=(p0-p1+2*d/s*v1)
				local c2=d/h*(p0-p1)+v0/(h*s)+(2*d*d-1)/(h*s)*v1
				local co=cos(h*s*x)
				local si=sin(h*s*x)
				local ex=e^(d*s*x)
				return co/ex*c1+si/ex*c2+p1+(x-2*d/s)*v1,
					s*(co*h-d*si)/ex*c2-s*(co*d+h*si)/ex*c1+v1
			elseif d<1+1e-8 then
				local c1=p0-p1+2/s*v1
				local c2=p0-p1+(v0+v1)/s
				local ex=e^(s*x)
				return (c1+c2*s*x)/ex+p1+(x-2/s)*v1,
					v1-s/ex*(c1+(s*x-1)*c2)
			else
				local h=(d*d-1)^0.5
				local a=(v1-v0)/(2*s*h)
				local b=d/s*v1-(p1-p0)/2
				local c1=(1-d/h)*b+a
				local c2=(1+d/h)*b-a
				local co=e^(-(h+d)*s*x)
				local si=e^((h-d)*s*x)
				return c1*co+c2*si+p1+(x-2*d/s)*v1,
					si*(h-d)*s*c2-co*(d+h)*s*c1+v1
			end
		end
	
		local function targposvel(p1,v1,x)
			return p1+x*v1,v1
		end
	
		function physics.spring.new(initial)
			local d=1
			local s=1
			local p0=initial or 0
			local v0=0*p0
			local p1=p0
			local v1=v0
			local t0=tick()
	
			local self={}
			local meta={}
	
			function self.getpv()
				return posvel(d,s,p0,v0,p1,v1,tick()-t0)
			end
	
			function self.setpv(p,v)
				local time=tick()
				local tp,tv=targposvel(p1,v1,time-t0)
				p0,v0=p,v
				p1,v1=tp,tv
				t0=time
			end
	
			function self.settargetpv(tp,tv)
				local time=tick()
				local p,v=posvel(d,s,p0,v0,p1,v1,time-t0)
				p0,v0=p,v
				p1,v1=tp,tv
				t0=time
			end
			
			function self:accelerate(a)
				local time=tick()
				local p,v=posvel(d,s,p0,v0,p1,v1,time-t0)
				local tp,tv=targposvel(p1,v1,time-t0)
				p0,v0=p,v+a
				p1,v1=tp,tv
				t0=time
			end
	
			function meta.__index(self,index)
				local time=tick()
				if index=="p" or index=="position" then
					local p,v=posvel(d,s,p0,v0,p1,v1,time-t0)
					return p
				elseif index=="v" or index=="velocity" then
					local p,v=posvel(d,s,p0,v0,p1,v1,time-t0)
					return v
				elseif index=="tp" or index=="t" or index=="targetposition" then
					local tp,tv=targposvel(p1,v1,time-t0)
					return tp
				elseif index=="tv" or index=="targetvelocity" then
					local tp,tv=targposvel(p1,v1,time-t0)
					return tv
				elseif index=="d" or index=="damper" then
					return d
				elseif index=="s" or index=="speed" then
					return s
				else
					error("no value "..tostring(index).." exists")
				end
			end
	
			function meta.__newindex(self,index,value)
				local time=tick()
				if index=="p" or index=="position" then
					local p,v=posvel(d,s,p0,v0,p1,v1,time-t0)
					local tp,tv=targposvel(p1,v1,time-t0)
					p0,v0=value,v
					p1,v1=tp,tv
				elseif index=="v" or index=="velocity" then
					local p,v=posvel(d,s,p0,v0,p1,v1,time-t0)
					local tp,tv=targposvel(p1,v1,time-t0)
					p0,v0=p,value
					p1,v1=tp,tv
				elseif index=="tp" or index=="t" or index=="targetposition" then
					local p,v=posvel(d,s,p0,v0,p1,v1,time-t0)
					local tp,tv=targposvel(p1,v1,time-t0)
					p0,v0=p,v
					p1,v1=value,tv
				elseif index=="tv" or index=="targetvelocity" then
					local p,v=posvel(d,s,p0,v0,p1,v1,time-t0)
					local tp,tv=targposvel(p1,v1,time-t0)
					p0,v0=p,v
					p1,v1=tp,value
				elseif index=="d" or index=="damper" then
					local p,v=posvel(d,s,p0,v0,p1,v1,time-t0)
					local tp,tv=targposvel(p1,v1,time-t0)
					p0,v0=p,v
					p1,v1=tp,tv
					d=value
				elseif index=="s" or index=="speed" then
					local p,v=posvel(d,s,p0,v0,p1,v1,time-t0)
					local tp,tv=targposvel(p1,v1,time-t0)
					p0,v0=p,v
					p1,v1=tp,tv
					s=value
				elseif index=="a" or index=="acceleration" then
					local time=tick()
					local p,v=posvel(d,s,p0,v0,p1,v1,time-t0)
					local tp,tv=targposvel(p1,v1,time-t0)
					p0,v0=p,v+value
					p1,v1=tp,tv
					t0=time
				else
					error("no value "..tostring(index).." exists")
				end
				t0=time
			end
	
			return setmt(self,meta)
		end
	end

	local function rootreals4(a,b,c,d,e)
		local x0,x1,x2,x3
		local m10=3*a
		local m0=-b/(4*a)
		local m4=c*c-3*b*d+12*a*e
		local m6=(b*b/(4*a)-2/3*c)/a
		local m9=((b*(4*c-b*b/a))/a-(8*d))/a
		local m5=c*(2*c*c-9*b*d-72*a*e)+27*a*d*d+27*b*b*e
		local m11=m5*m5-4*m4*m4*m4
		local m7
		if m11<0 then--Optimize
			local th=atan2((-m11)^0.5,m5)/3
			local m=((m5*m5-m11)/4)^(1/6)
			m7=(m4/m+m)/m10*cos(th)
		else--MAY NEED CASE FOR WHEN 2*c*c*c-9*b*c*d+27*a*d*d+27*b*b*e-72*a*c*e+((2*c*c*c-9*b*c*d+27*a*d*d+27*b*b*e-72*a*c*e)^2-4*(c*c-3*b*d+12*a*e)^3)^(1/2)=0
			local m8=(m5+m11^0.5)/2
			m8=m8<0 and -(-m8)^(1/3) or m8^(1/3)
			m7=(m4/m8+m8)/m10
		end
		local m2=2*m6-m7
		--print("m2",m2,0)
		local m12=m6+m7
		if m12<0 then
			local m3i=m9/(4*(-m12)^0.5)
			local m13=(m3i*m3i+m2*m2)^(1/4)*cos(atan2(m3i,m2)/2)/2
			--In order
			x0=m0-m13
			x1=m0-m13
			x2=m0+m13
			x3=m0+m13
		else
			local m1=m12^0.5
			--print("m1",m1,0)
			local m3=m9/(4*m1)
			--print("m3",m3,0)
			local m14=m2-m3
			local m15=m2+m3
			if m14<0 then
				x0=m0-m1/2
				x1=m0-m1/2
			else
				local m16=m14^0.5
				x0=m0-(m1+m16)/2
				x1=m0-(m1-m16)/2
			end
			if m15<0 then
				x2=m0+m1/2
				x3=m0+m1/2
			else
				local m17=m15^0.5
				x2=m0+(m1-m17)/2
				x3=m0+(m1+m17)/2
			end
			--bubble sort lel
			if x1<x0 then x0,x1=x1,x0 end
			if x2<x1 then x1,x2=x2,x1 end
			if x3<x2 then x2,x3=x3,x2 end
			if x1<x0 then x0,x1=x1,x0 end
			if x2<x1 then x1,x2=x2,x1 end
			if x1<x0 then x0,x1=x1,x0 end
		end
		return x0,x1,x2,x3
	end
	
	local function rootreals3(a,b,c,d)
		local x0,x1,x2
		local d0=b*b-3*a*c
		local d1=2*b*b*b+27*a*a*d-9*a*b*c
		local d=d1*d1-4*d0*d0*d0
		local m0=-1/(3*a)
		if d<0 then
			local cr,ci=d1/2,(-d)^0.5/2
			local th=atan2(ci,cr)/3
			local m=(cr*cr+ci*ci)^(1/6)
			local cr,ci=m*cos(th),m*sin(th)
			local m1=(1+d0/(m*m))/2
			local m2=(cr*d0+(cr-2*b)*m*m)/(6*a*m*m)
			local m3=ci*(d0+m*m)/(2*3^0.5*a*m*m)
			x0=-(b+cr*(1+d0/(m*m)))/(3*a)
			x1=m2-m3
			x2=m2+m3
		else
			local c3=(d1+d^0.5)/2
			c=c3<0 and -(-c3)^(1/3) or c3^(1/3)
			x0=m0*(b+c+d0/c)
			x1=m0*(b-(c*c+d0)/(2*c))
			x2=x1
		end
		if x1<x0 then x0,x1=x1,x0 end
		if x2<x1 then x1,x2=x2,x1 end
		if x1<x0 then x0,x1=x1,x0 end
		return x0,x1,x2
	end
	
	local function rootreals2(a,b,c)
		local p=-b/(2*a)
		local q2=p*p-c/a
		if 0<q2 then
			local q=q2^0.5
			return p-q,p+q
		else
			return p,p
		end
	end
	
	local solvemoar
	
	local function solve(a,b,c,d,e)
		if a*a<1e-32 then
			return solve(b,c,d,e)
		elseif e then
			if e*e<1e-32 then
				return solvemoar(a,b,c,d)
			elseif b*b<1e-12 and d*d<1e-12 then
				local roots={}
				local found={}
				local r0,r1=solve(a,c,e)
				if r0 then
					if r0>0 then
						local x=r0^0.5
						roots[#roots+1]=-x
						roots[#roots+1]=x
					elseif r0*r0<1e-32 then
						roots[#roots+1]=0
					end
				end
				if r1 then
					if r1>0 then
						local x=r1^0.5
						roots[#roots+1]=-x
						roots[#roots+1]=x
					elseif r1*r1<1e-32 then
						roots[#roots+1]=0
					end
				end
				sort(roots)
				return unpack(roots)
			else
				local roots={}
				local found={}
				local x0,x1,x2,x3=rootreals4(a,b,c,d,e)
				local d0,d1,d2=rootreals3(4*a,3*b,2*c,d)
				local m0,m1,m2,m3,m4=-inf,d0,d1,d2,inf
				local l0,l1,l2,l3,l4=a*inf,(((a*d0+b)*d0+c)*d0+d)*d0+e,(((a*d1+b)*d1+c)*d1+d)*d1+e,(((a*d2+b)*d2+c)*d2+d)*d2+e,a*inf
				if (l0<=0)==(0<=l1) then
					roots[#roots+1]=x0
					found[x0]=true
				end
				if (l1<=0)==(0<=l2) and not found[x1] then
					roots[#roots+1]=x1
					found[x1]=true
				end
				if (l2<=0)==(0<=l3) and not found[x2] then
					roots[#roots+1]=x2
					found[x2]=true
				end
				if (l3<=0)==(0<=l4) and not found[x3] then
					roots[#roots+1]=x3
				end
				return unpack(roots)
			end
		elseif d then
			if d*d<1e-32 then
				return solvemoar(a,b,c)
			elseif b*b<1e-12 and c*c<1e-12 then
				local p=d/a
				return p<0 and (-p)^(1/3) or -p^(1/3)
			else
				local roots={}
				local found={}
				local x0,x1,x2=rootreals3(a,b,c,d)
				local d0,d1=rootreals2(3*a,2*b,c)
				local l0,l1,l2,l3=-a*inf,((a*d0+b)*d0+c)*d0+d,((a*d1+b)*d1+c)*d1+d,a*inf
				if (l0<=0)==(0<=l1) then
					roots[#roots+1]=x0
					found[x0]=true
				end
				if (l1<=0)==(0<=l2) and not found[x1] then
					roots[#roots+1]=x1
					found[x1]=true
				end
				if (l2<=0)==(0<=l3) and not found[x2] then
					roots[#roots+1]=x2
				end
				return unpack(roots)
			end
		elseif c then
			local p=-b/(2*a)
			local q2=p*p-c/a
			if 0<q2 then
				local q=q2^0.5
				return p-q,p+q
			elseif q2==0 then
				return p
			end
		elseif b then
			if a*a>1e-32 then
				return -b/a
			end
		end
	end
	
	function solvemoar(a,b,c,d,e)
		local roots={solve(a,b,c,d,e)}
		local good=true
		for i=1,#roots do
			if roots[i]==0 then
				good=false
				break
			end
		end
		if good then
			roots[#roots+1]=0
			sort(roots)
		end
		return unpack(roots)
	end
	
	function physics.trajectory(pp,pv,pa,tp,tv,ta,s)
		local rp=tp-pp
		local rv=tv-pv
		local ra=ta-pa
		local t0,t1,t2,t3=solve(
			dot(ra,ra)/4,
			dot(ra,rv),
			dot(ra,rp)+dot(rv,rv)-s*s,
			2*dot(rp,rv),
			dot(rp,rp)
		)
		if t0 and t0>0 then
			return ra*t0/2+tv+rp/t0,t0
		elseif t1 and t1>0 then
			return ra*t1/2+tv+rp/t1,t1
		elseif t2 and t2>0 then
			return ra*t2/2+tv+rp/t2,t2
		elseif t3 and t3>0 then
			return ra*t3/2+tv+rp/t3,t3
		end
	end
end

















--particle module
--
print("Loading particle module")
do
	local setmt			=setmetatable
	local remove		=table.remove
	local airdensity	=0.001225
	local ln			=math.log
	local tan			=math.tan
	local atan2			=math.atan2
	local deg			=math.pi/180
	local tick			=tick
	local playergui		=game.Players.LocalPlayer:WaitForChild("PlayerGui")
	local camera		=game.Workspace.CurrentCamera
	local workspace		=game.Workspace
	local components	=CFrame.new().components
	local v3			=Vector3.new
	local dot			=v3().Dot
	local ray			=Ray.new
	local raycast		=workspace.FindPartOnRayWithIgnoreList
	local c3			=Color3.new
	local ud2			=UDim2.new
	local new			=Instance.new
	local ffc			=game.FindFirstChild
	local players		=game.Players

	local frames		={}
	local rendignore	={}
	local particles		={}
	local removelist	={}

	--[[particle.physicsignore=physignore
	particle.renderignore=rendignore]]

	local screen=ffc(playergui,"ScreenGui") or new("ScreenGui",playergui)
	local time=tick()

	local planey,planex
	local pixelcoef
	local cameraposition=camera.CoordinateFrame.p
	local cpx,cpy,cpz,
		cxx,cxy,cxz,
		cyx,cyy,cyz,
		czx,czy,czz=components(camera.CoordinateFrame)

	function particle.new(prop)
		
		---print(#screen:GetChildren())		--- some particles don't get reused?
		
		local self={}

		local px,py,pz			=0,0,0
		local vx,vy,vz			=0,0,0
		local ax,ay,az			=0,0,0
		local lx,ly,lz
		local culling			=prop.culling==nil or prop.culling
		local size				=prop.size or 1
		local bloom				=prop.bloom or 0
		local brightness		=prop.brightness or 1
		local maxrange			=prop.maxrange or 1000
		local cancollide		=prop.cancollide==nil or prop.cancollide
		local resistance		=prop.resistance or 1
		local elasticity		=prop.elasticity or 0.3
		local physicsonly		=prop.physicsonly or false
		local minexitvelocity	=prop.minexitvelocity or 500
		local penetrationdepth	=prop.penetrationdepth or (leleltru and 1000000 or 0.5)
		local penetrationpower	=penetrationdepth
		local life				=prop.life and tick()+prop.life or false
		local physignore		=prop.physicsignore or {workspace.Ignore,camera,char.character}
		local rendignore		=prop.renderignore or rendignore
		local onstep			=prop.onstep
		local ontouch			=prop.ontouch
		local wasrendered		=false
		local wasobstructed

		--BULLSHIT BULLSHIT BULLSHIT BULLSHIT
		local distance=0
		--BULLSHIT BULLSHIT BULLSHIT BULLSHIT

		local frame
		if #frames~=0 then
			frame=frames[#frames]
			frames[#frames]=nil
		else
			frame=new("Frame",screen)
			frame.BorderSizePixel=0
		end
		frame.BackgroundColor3=prop.color or c3(1,1,1)
		self.frame=frame

		if prop.position then
			local pos=prop.position
			px,py,pz=pos.x,pos.y,pos.z
		end
		if prop.velocity then
			local vel=prop.velocity
			vx,vy,vz=vel.x,vel.y,vel.z
		end
		if prop.acceleration then
			local acc=prop.acceleration
			ax,ay,az=acc.x,acc.y,acc.z
		end
		lx=(px-cpx)*cxx+(py-cpy)*cxy+(py-cpz)*cxz
		ly=(px-cpx)*cyx+(py-cpy)*cyy+(py-cpz)*cyz
		lz=-((px-cpx)*czx+(py-cpy)*czy+(py-cpz)*czz)
		wasobstructed=true--culling and lz*lz+ly*ly+lz*lz<maxrange*maxrange and raycast(workspace,ray(cameraposition,v3(px,py,pz)-cameraposition),rendignore)

		function self:remove()
			removelist[self]=true
		end
		local part
		function self.step(dt,time)
			--Removal check
			if life and life<time then
				removelist[self]=true
				return
			end

			--Physics
			do
				--Initial position. Don't ask why I used q.
				local qx,qy,qz=px,py,pz
				local ix,iy,iz=vx,vy,vz
				--Calculate the geometric change in velocity due to wind resistance
				local v=(vx*vx+vy*vy+vz*vz)^0.5
				--local gv=1/(resistance*airdensity*v*dt+1)
				--geometricchange*velocity+dt*acceleration
				vx,vy,vz=vx+dt*ax,vy+dt*ay,vz+dt*az
				--nextposition = position+dt*velocity... except integrated so it assumes linear velocity
				local dx,dy,dz=dt/2*(ix+vx),dt/2*(iy+vy),dt/2*(iz+vz)
				--local ddistance=0
				if cancollide then
					local direction=v3(dx,dy,dz)
					local hit,pos,norm=raycast(workspace,ray(v3(px,py,pz),direction),physignore)
					if hit then
						--This is where I stop giving a shit.
						local unit=direction.unit
						local dir=hit.Size.magnitude*unit
						local _,nextpos=raycast(workspace,ray(pos,dir),physignore)
						local _,exit,exitnorm=raycast(workspace,ray(nextpos,-dir),physignore)
						local diff=exit-pos
						local dist=dot(unit,diff)
						local pass=hit.Transparency~=0 or not hit.CanCollide
						local human=ffc(players,hit.Parent.Name)
						if 0<dist then
							if pass then
								px,py,pz=nextpos.x,nextpos.y,nextpos.z
							elseif dist<penetrationdepth then --ln(v/minexitvelocity)/resistance
								px,py,pz=exit.x,exit.y,exit.z
								--effects:bullethit(hit,exit,exitnorm,false,true)
								local rx,ry,rz=px-qx,py-qy,pz-qz
								distance=distance+(pos-v3(qx,qy,qz)).Magnitude
								--ddistance=6000*diff.Magnitude--6000 = density of metal / density of air
								local gv=2.7182818459045^(-resistance*dist)
								vx,vy,vz=gv*vx,gv*vy,gv*vz
								penetrationdepth=human and penetrationdepth or penetrationdepth-dist
							else
								removelist[self]=true
								px,py,pz=pos.x,pos.y,pos.z
							end
						else
							if not pass then
								removelist[self]=true
							end
							px,py,pz=nextpos.x,nextpos.y,nextpos.z
							local gv=2.7182818459045^(-resistance*dot(unit,nextpos-pos))
							vx,vy,vz=gv*vx,gv*vy,gv*vz
						end
						if ontouch then
							ontouch(part,hit,pos,norm,penetrationdepth/penetrationpower,human)
						end
						physignore[#physignore+1]=human and hit.Parent or hit
					else
						px,py,pz=px+dx,py+dy,pz+dz
					end
				else
					local rx,ry,rz=px-qx,py-qy,pz-qz
					distance=distance+(rx*rx+ry*ry+rz*rz)^0.5
					px,py,pz=px+dx,py+dy,pz+dz
				end
				local rx,ry,rz=px-qx,py-qy,pz-qz
				distance=distance+(rx*rx+ry*ry+rz*rz)^0.5--+ddistance
			end
			if onstep then
				onstep(part,dt)
			end
			if physicsonly then
				return "physics only"
			end

			--Render
			do
				--cameracf:inverse()*particlepos
				local rx,ry,rz=px-cpx,py-cpy,pz-cpz
				local dx=rx*cxx+ry*cxy+rz*cxz
				local dy=rx*cyx+ry*cyy+rz*cyz
				local dz=-(rx*czx+ry*czy+rz*czz)
				--Check if it's visible at all
				if brightness==0 or dz<1 and lz<1 then
					if wasrendered then
						wasrendered=false
						frame.Transparency=1
					end
					lx,ly,lz=dx,dy,dz
					wasobstructed=false--Maybe should be true? idk
					return "behind or tansparent"
				end
				--Raycast to check visibility
				local obstructed
				if maxrange*maxrange<dx*dx+dy*dy+dz*dz then
					obstructed=true
				elseif culling then
					obstructed=raycast(workspace,ray(cameraposition,v3(px,py,pz)-cameraposition),rendignore)
				end
				if obstructed or wasobstructed then
					if wasrendered then
						wasrendered=false
						frame.Transparency=1
					end
					lx,ly,lz=dx,dy,dz
					wasobstructed=obstructed
					return "obstructed"
				end
				--Check if intersects the screen plane.
				local rx,ry,rdepth
				local sx,sy,sdepth
				if 1<dz and 1<lz then
					--In front of the camera. No intersection
					rx,ry,rdepth=lx/lz,ly/lz,lz
					sx,sy,sdepth=dx/dz,dy/dz,dz
				elseif dz<1 then
					--Plane intersection stuff
					local d=(1-dz)/(lz-dz)
					rx,ry,rdepth=lx/lz,ly/lz,lz
					sx,sy,sdepth=d*(lx-dx)+dx,d*(ly-dy)+dy,1
				else
					--Plane intersection stuff
					local d=(1-lz)/(dz-lz)
					rx,ry,rdepth=d*(dx-lx)+lx,d*(dy-ly)+ly,1
					sx,sy,sdepth=dx/dz,dy/dz,dz
				end
				--Check if it's within the screen
				if rx<-planex and sx<-planex or planex<rx and planex<sx
				or ry<-planey and sy<-planey or planey<ry and planey<sy then
					if wasrendered then
						wasrendered=false
						frame.Transparency=1
					end
					lx,ly,lz=dx,dy,dz
					wasobstructed=obstructed
					return "off screen"
				end
				--Constrain to within da broarder
				local slope=(sy-ry)/(sx-rx)
				local hx,hy,hz=dx-lx,dy-ly,dz-lz
				if rx<-planex and -planex<sx then
					rx,ry=-planex,sy-slope*(planex+sx)
					rdepth=lz-(lz*planex+lx)/(hz*planex+hx)*hz
				elseif -planex<rx and sx<-planex then
					sx,sy=-planex,ry-slope*(planex+rx)
					sdepth=lz-(lz*planex+lx)/(hz*planex+hx)*hz
				end
				if rx<planex and planex<sx then
					sx,sy=planex,ry+slope*(planex-rx)
					sdepth=lz-(lz*planex-lx)/(hz*planex-hx)*hz
				elseif planex<rx and sx<planex then
					rx,ry=planex,sy+slope*(planex-sx)
					rdepth=lz-(lz*planex-lx)/(hz*planex-hx)*hz
				end
				if ry<-planey and -planey<sy then
					ry,rx=-planey,sx-(planey+sy)/slope
					rdepth=lz-(lz*planey+ly)/(hz*planey+hy)*hz
				elseif -planey<ry and sy<-planey then
					sy,sx=-planey,rx-(planey+ry)/slope
					sdepth=lz-(lz*planey+ly)/(hz*planey+hy)*hz
				end
				if ry<planey and planey<sy then
					sy,sx=planey,rx+(planey-ry)/slope
					sdepth=lz-(lz*planey-ly)/(hz*planey-hy)*hz
				elseif planey<ry and sy<planey then
					ry,rx=planey,sx+(planey-sy)/slope
					rdepth=lz-(lz*planey-ly)/(hz*planey-hy)*hz
				end
				--Convert to pixel coordinates
				local ux,uy=pixelcoef*(rx+planex),pixelcoef*(planey-ry)-36
				local vx,vy=pixelcoef*(sx+planex),pixelcoef*(planey-sy)-36
				--Calculate properties
				local wx,wy=vx-ux,vy-uy
				local s=pixelcoef*size/(rdepth*sdepth)^0.5
				local area=s*s
				local b=pixelcoef*bloom+s
				local sx,sy=(wx*wx+wy*wy)^0.5+b,b
				local transparency=1-brightness*area/(sx*sy)
				--Set properties
				frame.Size=ud2(0,sx,0,sy)
				frame.Position=ud2(0,(ux+vx-sx)/2,0,(uy+vy-s)/2)
				frame.Transparency=transparency
				if wx~=0 then
					frame.Rotation=atan2(wy,wx)/deg
				end
				lx,ly,lz=dx,dy,dz
				wasrendered=true
				wasobstructed=obstructed
				return "rendered"
			end
		end

		particles[#particles+1]=self

		local get={}
		local set={}
		local meta={}
		function meta.__index(table,index) return get[index]() end
		function meta.__newindex(table,index,value) return set[index](value) end
		function get.position() return v3(px,py,pz) end
		function get.velocity() return v3(vx,vy,vz) end
		function get.acceleration() return v3(ax,ay,az) end
		function get.cancollide() return cancollide end
		function get.size() return size end
		function get.bloom() return bloom end
		function get.brightness() return brightness end
		function get.color() return frame.BackgroundColor3 end
		function get.life() return life-tick() end
		function get.distance() return distance end
		function set.position(p) px,py,pz=p.x,p.y,p.z end
		function set.velocity(v) vx,vy,vz=v.x,v.y,v.z end
		function set.acceleration(a) ax,ay,az=a.x,a.y,a.z end
		function set.cancollide(newcancollide) cancollide=newcancollide end
		function set.size(newsize) size=newsize end
		function set.bloom(newbloom) bloom=newbloom end
		function set.brightness(newbrightness) brightness=newbrightness end
		function set.color(newcolor) frame.BackgroundColor3=newcolor end
		function set.life(newlife) life=tick()+newlife end
		part=setmt(self,meta)

		if prop.dt then
			self.step(prop.dt,tick())
		end

		return part
	end

	local avg=800
	local asd=0
	function particle.step(dt)
		local newtime=tick()
		local dt=newtime-time
		time=newtime
		local cameracf=camera.CoordinateFrame
		local screenx,screeny=camera.ViewportSize.x,camera.ViewportSize.y
		planey=tan(camera.FieldOfView/2*deg)
		planex=screenx/screeny*planey
		pixelcoef=screeny/(2*planey)
		cameraposition=cameracf.p
		cpx,cpy,cpz,
			cxx,cyx,czx,
			cxy,cyy,czy,
			cxz,cyz,czz=components(cameracf)
		local j=0
		for i=1,#particles do
			local p=particles[i]
			particles[i]=nil
			if removelist[p] then
				p.frame.Transparency=1
				frames[#frames+1]=p.frame
				removelist[p]=nil
			elseif p then
				p.step(dt,time)
				j=j+1
				particles[j]=p
			end
		end
		if #particles>0 then
			local d=#particles/60/(tick()-time)
			avg=avg*0.95+d*0.05
		end
		if asd==0 then
			--print("you can process about "..avg.." particles. You are currently processing "..#particles.." particles")
		end
		asd=(asd+1)%60
	end

	--[[function particle:addtophysicsignore(object)
		for i=1,#physignore do
			if physignore[i]==object then
				return
			end
		end
		local init=#physignore+1
		physignore[init]=object
		object.Changed:connect(function(prop)
			if prop=="Parent" and not object.Parent then
				for i=init,1,-1 do
					if physignore[i]==object then
						remove(physignore,i)
						break
					end
				end
			end
		end)
	end]]

	function particle:addtorenderignore(object)
		for i=1,#rendignore do
			if rendignore[i]==object then
				return
			end
		end
		local init=#rendignore+1
		rendignore[init]=object
		object.Changed:connect(function(prop)
			if prop=="Parent" and not object.Parent then
				for i=init,1,-1 do
					if rendignore[i]==object then
						remove(rendignore,i)
						break
					end
				end
			--[[else
				init=#physignore+1
				physignore[init]=object]]
			end
		end)
	end

	function particle:reset()
		screen:ClearAllChildren()
		frames={}
		particles={}
	end

	screen.AncestryChanged:connect(function()
		wait()
		screen.Parent=playergui
		--[[screen:ClearAllChildren()
		frames={}
		particles={}]]
	end)

	--[[function particle.resistance(entracncevelocity,exitvelocity,penetration)
		return ln(entracncevelocity/exitvelocity)/penetration
	end]]
end










--sound module
--
print("Loading sound module")
do
	local random=math.random
	local fonts={}

	local soundobject=Instance.new("Sound",game.Workspace)

	function sound.load(name,...)
		local font={...}
		for i=1,#font do
			font[i]="rbxassetid://"..font[i]
		end
		fonts[name]=font
	end
	
	local errd={}
	function sound.play(name,volume,pitch)
		local font=fonts[name]
		if font then
			soundobject.SoundId=font[random(1,#font)]
			soundobject.Volume=volume or 1
			soundobject.Pitch=pitch or 1
			soundobject:Play()
			soundobject.SoundId=""
		elseif not errd[name] then
			print("adihiruhweoiweojfwoiejfowiefj",name)
			errd[name]=true
		end
	end

	--library
	sound.load("wizz",342190005,342190012,342190017,342190024)
	sound.load("snap",342190488,342190495,342190504,342190510)
	sound.load("woodhit",342204157,342204164,342204170,342204175)
	sound.load("stonehit",342204189,342204194,342204197,342204203)
	sound.load("metalhit",342204233,342204240,342204244,342204250)
	sound.load("woodstep",342421904,342421911,342421916,342421927)
	sound.load("hardstep",342422058,342422074,342422087,342422094)
	sound.load("metalstep",342421947,342421958,342421973,342421997)
	sound.load("metalshell",342423812,342423826,342423844,342423860)
	sound.load("shotgunshell",342423873,342423885)
end

globalsound=sound--FUCK










--effects module
--
print("Loading effects module")
do
	local wfc			=game.WaitForChild
	local ffc			=game.FindFirstChild
	local ud2			=UDim2.new
	local v3			=Vector3.new
	local cf			=CFrame.new
	local angles		=CFrame.Angles
	local deg			=math.pi/180
	local random		=math.random
	local color			=Color3.new
	local colorseq		=ColorSequence.new	
	local spawn			=function(F) coroutine.resume(coroutine.create(F)) end
	local ray			=Ray.new
	local raycast		=workspace.FindPartOnRayWithIgnoreList
	local debris		=game.Debris
	local new			=Instance.new
	
	local player		=game.Players.LocalPlayer
	local pgui			=player.PlayerGui
	local repeffects	=game.ReplicatedStorage.Effects
	local smoke			=repeffects.Smoke
	local hole			=repeffects.Hole
	local flash			=repeffects.Muzzle
	local shell			=repeffects.Shell
	local blood			=repeffects.Blood
	local bloodsplat	=repeffects.BloodSplat
	local ignore		=workspace.Ignore
		
	local smokelist		={}
	local holelist		={}
	local flashlist		={}
	local shelllist		={}
	local materialtype	=Enum.Material
	
	local materiallist	={
		[Enum.Material.Cobblestone] = {185234383, 185234399, 185234373, 185234412};
		[Enum.Material.Wood] = {185238181, 185238234, 185238224, 185238210, 185238204};
		[Enum.Material.Brick] = {185237818, 185237842, 185237826, 185237805};
		[Enum.Material.Plastic] = {185238152, 185237945, 185237930};
		[Enum.Material.Concrete] = {185237894, 185237879, 185237865, 185237853};
		["Tile"] = {185238332, 185238308, 185238298, 185238288, 185238271, 185238257};
	}


	function effects:ejectshell(trigger,guntype,offset)
		local shellpart
		if #shelllist~=0 then
			shellpart=shelllist[#shelllist]
			shelllist[#shelllist]=nil
		else
			shellpart=shell:Clone()
		end

		spawn(function()
			wait(.1)
			shellpart.CFrame=trigger.CFrame*angles((90+random(-5,5))*deg,random(-5,5)*deg,random(-5,5)*deg)*offset
			shellpart.RotVelocity=v3(random(-5,5),random(-5,5),random(-5,5))	
			shellpart.Parent=ignore
			shellpart.BodyThrust.force=v3(3.5,0.1,-3)
			wait(.05)
			shellpart.BodyThrust.force=v3(-.5,0,0)
			wait(.1)		
			shellpart.BodyThrust.force=v3(0,0,0)	
			wait(.1)
			shellpart.Velocity=v3()
			shellpart.Parent=nil
			shelllist[#shelllist+1]=shellpart
		end)
	end

	function effects:muzzleflash(barrel)
		local flashpart
		if #flashlist~=0 then
			flashpart=flashlist[#flashlist]
			flashlist[#flashlist]=nil
		else
			flashpart=flash:Clone()
		end
		local flare=ffc(flashpart,"Flare")---texs
		local spark=ffc(flashpart,"Spark")---texn
		
		if not flare or not spark then
			trash.remove(flashpart)
			flashpart=flash:Clone()
			flare=ffc(flashpart,"Flare")---texs
			spark=ffc(flashpart,"Spark")---texn
		end
		
		flashpart.Enabled=true
		flashpart.Parent=pgui
		flashpart.Adornee=barrel
		
		flare.Rotation=random(0,360)
		flare.Size=ud2(0,20,0,20)
		flare.Position=ud2(0.5,-10,0.5,-10)
		
		spark.Rotation=random(0,360)
		spark.Size=ud2(0,200,0,200)
		spark.Position=ud2(0.5,-100,0.5,-100)
		spark.Visible=true
		
		flare:TweenSizeAndPosition(ud2(0,1000,0,1000),ud2(0.5,-500,0.5,-500),"Out","Sine",0.2)
		spark:TweenSizeAndPosition(ud2(0,500,0,500),ud2(0.5,-250,0.5,-250),"Out","Sine",0.15)	

		spawn(function()
			wait(0.05)
			spark.Visible = false
			wait(0.05)
			flashpart.Enabled=false
			wait(0.5)
			flashpart.Parent=nil
			flashlist[#flashlist+1]=flashpart
		end)

		char:firemuzzlelight()

	end
	
	function effects:breakwindow(hit,pos,norm,force)
		hit.Parent=ignore
		--[==[antihack]==]network:send('b'..'r'..'e'..'a'..'k'..'w'..'i'..'n'..'d'..'o'..'w',hit)
		--network:send("breakwindow",hit)
		effects:bullethit(hit,pos,norm,false,false,3)
	end
	
	function effects:bloodhit(start,hit,pos,norm)
		--[==[antihack]==]network:send('b'..'l'..'o'..'o'..'d'..'h'..'i'..'t',start,hit,pos,norm)
		--network:send("bloodhit",start,hit,pos,norm)
	end

	function createblood(start,hit,pos,norm)
		if input.consoleon then return end
		local ignorelist={ignore}
		local pp=game.Players:GetChildren()
		for i=1,#pp do
			ignorelist[#ignorelist+1]=pp[i].Character
		end	
		for i=1,3 do
			local h,p,n=raycast(workspace,ray(pos,(pos-start).unit*10+vector.random(7)-v3(0,2,0)),ignorelist)
			if h and h.Anchored and h.Transparency~=1 then
				local b=blood:Clone()
				b.CFrame=cf(p,p+n)*angles(90*deg,0,0)
				b.Parent=ignore
				local bm=b.Mesh
				spawn(function()
					for i=1,random(7,15) do
						if not bm.Parent then return end
						bm.Scale=bm.Scale+v3(1,0,1)
						wait(.02)
					end
				end)
				debris:AddItem(b)
			end
		end
		local bloodpart=hole:Clone()
		bloodpart.Parent=ignore
		bloodpart.CFrame=cf(pos)
		bloodpart.Transparency=1
		bloodpart:ClearAllChildren()
		
		local bd=bloodsplat:Clone()
		bd.Parent=bloodpart
		bd.Adornee=bloodpart
		bd.Enabled=true
		bd.ID.Size=ud2(1,0,1,0)
		bd.ID.Position=ud2(-.25,0,-.25,0)
		bd.ID.Rotation=random(0,360)
		bd.ID:TweenSizeAndPosition(ud2(5,0,5,0),ud2(-2,0,-2,0),"Out","Quad",.4)		
		debris:AddItem(bloodpart,0.15)
	end

	network:add("createblood",createblood)
	
	function effects:bullethit(hit,pos,norm,smokeon,holeon,sparkson)
		if sparkson and hit.Material~=Enum.Material.Sand and hit.Material~=Enum.Material.Grass and hit.Material~=Enum.Material.Wood then
			for i=1,2*sparkson do--fix
				particle.new{
					position=pos;
					velocity=norm*50+vector.random(20);
					acceleration=v3(0,-196.2,0);
					cancollide=false;
					size=0.1;
					brightness=20*random();
					color=Color3.new(1,1,0.8);
					bloom=0.005*random();
					life=0.3
				}
			end
		end

		if (hit.Name=="light" or hit.Name=="Light") then
			if ffc(hit,"SpotLight") then
				hit.SpotLight:Destroy()
			end
			hit.Material=Enum.Material.SmoothPlastic
			for i=1,20 do
				particle.new{
					position=pos;
					velocity=norm*30+vector.random(10);
					acceleration=v3(0,-20,0);
					cancollide=false;
					size=0.1;
					brightness=20*random();
					color=Color3.new(1,1,0.8);
					bloom=0.005*random();
					life=10
				}
			end
		end
		
		if smokeon then
			local smokepart
			if #smokelist~=0 then
				smokepart=smokelist[#smokelist]
				smokelist[#smokelist]=nil
			else
				smokepart=smoke:Clone()
			end
			smokepart:BreakJoints()
			smokepart.CFrame=cf(pos,pos+norm+v3(random()-0.5,random()-0.5,random()-0.5))*angles(-90*deg,random(0,360)*deg,0)
			smokepart.Smoke.Enabled=true
			if hit.Material==Enum.Material.Grass then
				smoke.Smoke.Color=colorseq(color(0.470588, 0.564706, 0.509804),color(20/255, 157/255, 30/255))
			elseif hit.Material==Enum.Material.Sand then
				smoke.Smoke.Color=colorseq(color(225/255, 210/255, 149/255),color(216/255, 205/255, 159/255))
			else
				smoke.Smoke.Color=colorseq(color(145/255, 143/255, 145/255),color(141/255, 140/255, 140/255))
			end
			smokepart.Dust.Enabled=true
			smokepart.Parent=ignore
			smokepart.Dust.Acceleration=v3(random()-0.5,-1.5,random()-0.5)
			delay(0.1,function()
				smokepart.Smoke.Enabled = false
				smokepart.Dust.Enabled = false
				wait(5)
				smokepart.Parent=nil
				wait(5)
				smokelist[#smokelist+1]=smokepart
			end)
		end
		
		if holeon and hit.Transparency==0 and hit.CanCollide then
			local holepart
			if #holelist~=0 then
				holepart=holelist[#holelist]
				holelist[#holelist]=nil
			else
				holepart=hole:Clone()
			end
			holepart:BreakJoints()
			holepart.Parent=ignore
			holepart.CFrame=cf(pos,pos-norm)*angles(-90*deg,random(0,360)*deg,0)
			
			
			local materials=materiallist[Enum.Material.Cobblestone]
			if materiallist[hit.Material] then materials=materiallist[hit.Material] end
			local randId = "http://www.roblox.com/asset/?id="..materials[random(1,#materials)]
			holepart.Decal1.Texture=randId
			holepart.Decal2.Texture=randId
			
			delay(4,function()
				holepart.Parent=nil
				holelist[#holelist+1]=holepart
			end)
		end		
	end

	function effects:reload()
		smokelist={}
		holelist={}
		flashlist={}
		shelllist={}
	end
	
	effects:reload()

end









--tween module
--
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
				trash.remove(object)
			end
			object[index]=cframe.fromaxisangle(t*rotation0)*matrix0+position0+t*velocity0+t*t*acceleration
		end)
		return stop
	end
end
















--input module
--
print("Loading input module")
do
	local tick						=tick
	local lower						=string.lower
	local nv						=Vector3.new()
	local userinput					=game:GetService("UserInputService")
	
	local abbreviation				={
		ButtonX			="x";
		ButtonY			="y";
		ButtonA			="a";
		ButtonB			="b";
		ButtonR1		="r1";
		ButtonL1		="l1";
		ButtonR2		="r2";
		ButtonL2		="l2";
		ButtonR3		="r3";
		ButtonL3		="l3";
		ButtonStart		="start";
		ButtonSelect	="select";
		DPadLeft		="left";
		DPadRight		="right";
		DPadUp			="up";
		DPadDown		="down";
	}

	input.keyboard					={}
	input.keyboard.down				={}
	input.keyboard.onkeydown		={}
	input.keyboard.onkeyup			={}
	input.mouse						={}
	input.mouse.Position			=nv
	input.mouse.down				={}
	input.mouse.onbuttondown		={}
	input.mouse.onbuttonup			={}
	input.mouse.onmousemove			={}
	input.mouse.onscroll			={}
	input.controller				={}
	input.controller.down			={}
	input.controller.onbuttondown	={}
	input.controller.onbuttonup		={}
	input.controller.onintegralmove	={}
	input.consoleon					=not userinput.KeyboardEnabled
	---con test

	local fireonkeydown				=event.new(input.keyboard.onkeydown)
	local fireonkeyup				=event.new(input.keyboard.onkeyup)
	local fireonbuttondown			=event.new(input.mouse.onbuttondown)
	local fireonbuttonup			=event.new(input.mouse.onbuttonup)
	local fireonmousemove			=event.new(input.mouse.onmousemove)
	local fireonscroll				=event.new(input.mouse.onscroll)
	local fireoncbuttondown			=event.new(input.controller.onbuttondown)
	local fireoncbuttonup			=event.new(input.controller.onbuttonup)
	local fireonintegralmove		=event.new(input.controller.onintegralmove)

	local keymap					={}
	local triggerthreshold			=0.2
	local stickthreshold			=0.25--lol
	local gamepadpos
	local triggeron					={}

	local typing
		
	userinput.TextBoxFocused:connect(function()
		typing=true
	end)
	
	userinput.TextBoxFocusReleased:connect(function()
		typing=false
	end)

	userinput.InputChanged:connect(function(object)
		local type=object.UserInputType.Name
		local pos=object.Position
		if type=="MouseMovement" then
			input.mouse.position=pos
			fireonmousemove(object.Delta)
		elseif type=="MouseWheel" then
			fireonscroll(pos.z)
		elseif type=="Gamepad1" then
			local key=object.KeyCode.Name
			--Thumbstick1 reserved for movement
			if key=="Thumbstick2" then
				local m=pos.magnitude
				if stickthreshold<m then
					gamepadpos=(1-stickthreshold/m)/(1-stickthreshold)*pos
				elseif gamepadpos then
					gamepadpos=nil
				end
			elseif (key=="ButtonL2" or key=="ButtonR2") then
				local abv=abbreviation[key]
				if triggerthreshold<pos.z and not input.controller.down[abv] then 
					local mappedkey=keymap[abv]
					if mappedkey then
						input.keyboard.down[mappedkey]=tick()
						fireonkeydown(mappedkey)
					end
					input.controller.down[abv]=tick()
					fireoncbuttondown(abv)
				elseif pos.z<triggerthreshold and input.controller.down[abv] then
					local mappedkey=keymap[abv]
					if mappedkey then
						input.keyboard.down[mappedkey]=nil
						fireonkeyup(mappedkey)
					end
					input.controller.down[abv]=nil
					fireoncbuttonup(abv)
				end
			end
		end
	end)

	userinput.InputBegan:connect(function(object)
		if typing or roundsystem.lock or (char.health and char.health<=0) then return end--i mad
		local type=object.UserInputType.Name
		if type=="Keyboard" then
			local key=lower(object.KeyCode.Name)
			input.keyboard.down[key]=tick()
			fireonkeydown(key)
		elseif type=="Gamepad1" then
			local key=abbreviation[object.KeyCode.Name]
			if key and key~="l2" and key~="r2" or not input.controller.down[key] then
				local mappedkey=keymap[key]
				if mappedkey then
					input.keyboard.down[mappedkey]=tick()
					fireonkeydown(mappedkey)
				end
				input.controller.down[key]=tick()
				fireoncbuttondown(key)
			end
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
		if typing then return end
		local type=object.UserInputType.Name
		if type=="Keyboard" then
			local key=lower(object.KeyCode.Name)
			input.keyboard.down[key]=nil
			fireonkeyup(key)
		elseif type=="Gamepad1" then
			local key=abbreviation[object.KeyCode.Name]
			if key and key~="l2" and key~="r2" or input.controller.down[key] then
				local mappedkey=keymap[key]
				if mappedkey then
					input.keyboard.down[mappedkey]=nil
					fireonkeyup(mappedkey)
				end
				input.controller.down[key]=nil
				fireoncbuttonup(key)
			end
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
	
	function input.controller:map(button,key)
		keymap[button]=key
	end
	
	function input.controller:unmap(button)
		keymap[button]=nil
	end
	
	function input.step(dt)
		if gamepadpos then
			fireonintegralmove(dt*gamepadpos,dt)
		end
	end
end
















--animation module
--
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
	local new			=Instance.new
	local play			=new("Sound").Play
	local stop			=new("Sound").Stop

	local equations		={
		linear			={p0=0;v0=1;p1=1;v1=1};
		smooth			={p0=0;v0=0;p1=1;v1=0};
		accelerate		={p0=0;v0=0;p1=1;v1=1};
		decelerate		={p0=0;v0=1;p1=1;v1=0};
		bump			={p0=0;v0=4;p1=0;v1=-4};
		acceleratebump	={p0=0;v0=0;p1=0;v1=-6.75};
		deceleratebump	={p0=0;v0=6.75;p1=0;v1=0};
	}

	local function interpolator(c0,c1,t0,dur,eq,pivot)
		pivot=pivot or nv
		c0=c0*cf(pivot)
		c1=c1*cf(pivot)
		local p0,v0,p1,v1
		if type(eq)=="table" then
			p0,v0,p1,v1=eq[1],eq[2],eq[3],eq[4]
		else
			local eq=equations[eq or "smooth"]
			p0,v0,p1,v1=eq.p0,eq.v0,eq.p1,eq.v1
		end
		return function(t)
			t=(t-t0)/dur;t=t<1 and t or 1
			local i=1-t
			local v=p0*i*i*i+(3*p0+v0)*t*i*i+(3*p1-v1)*t*t*i+p1*t*t*t
			return cframe.interpolate(c0,c1,v)*cf(-pivot),1==t
		end
		--[[local x0,y0,z0,qx0,qy0,qz0,qw0=toquaternion(c0)
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
				)*cf(-pivot),1==t
			end
		else
			return function(t)
				t=(t-t0)/dur;t=t<1 and t or 1
				local i=1-t
				local v=p0*i*i*i+(3*p0+v0)*t*i*i+(3*p1-v1)*t*t*i+p1*t*t*t
				return cf(x0+v*x,y0+v*y,z0+v*z,qx1,qy1,qz1,qw1)*cf(-pivot),1==t
			end
		end]]
	end

	function animation.player(modeldata,sequence)
		local interpolators	={}
		local framenumber	=1
		local t0			=0
		local lasttime		=t0
		local stdtimescale	=sequence.stdtimescale
		local timescale		=sequence.timescale
		local cframes		={}
		local lastcframes	={}
		local ignore		=workspace.Ignore
		local player		=game.Players.LocalPlayer

		for i,v in next,modeldata do
			if v.part then
				lastcframes[i]=v.part.CFrame
				cframes[i]=v.part.CFrame
			end
		end

		return function(time)
			local dt=time-lasttime
			lasttime=time
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
							interpolators[partname]=interpolator(modeldata[partname].weld.C0,data.c1=="base" and modeldata[partname].basec0 or data.c1,t0,data.t and data.t*timescale or frame.delay*timescale,data.eq,data.pivot)
						end
						if data.clone then
							if modeldata[data.clone] then
								error("Error in frame: "..framenumber..". Cannot clone "..partname..". "..data.clone.." already exists.")
							end
							local part=clone(modeldata[partname].part)
							part.Parent=ignore
							local weld=new("Motor6D",part)
							local part0=data.part0 and modeldata[data.part0].part or modeldata[partname].weld.Part0
							weld.Part0=part0
							weld.Part1=part
							weld.C0=part0.CFrame:inverse()*modeldata[partname].weld.Part0.CFrame*modeldata[partname].weld.C0
							modeldata[data.clone]={
								part=part;
								weld=weld;
								clone=true;
							}
							cframes[data.clone]=cframes[partname]
							lastcframes[data.clone]=lastcframes[partname]
						end
						if data.transparency then
							modeldata[partname].part.Transparency=data.transparency
						end
						if data.sound then
							local sound=new("Sound")
							if data.soundid then
								sound.SoundId=data.soundid
							end
							if data.v then
								sound.Volume=data.v
							end
							if data.p then
								sound.Pitch=data.p
							end
							if data.tp then
								sound.TimePosition=data.tp
							else
								sound.TimePosition=0
							end
							if data.head then
								sound.Parent=player.Character.Head
							else
								sound.Parent=modeldata[partname].part
							end
							play(sound)
							if data.d then
								delay(data.d,function()
									sound:Stop()
								end)
							end
						end
						if data.drop then
							if not modeldata[partname].clone then
								error("Error in frame: "..framenumber..". Cannot drop "..partname..". Part is not a clone")
							end
							local lastcf=lastcframes[partname]
							local curcf=cframes[partname]
							tween.freebody(modeldata[partname].part,
								"CFrame",timescale/stdtimescale,modeldata[partname].part.CFrame,
								(curcf.p-lastcf.p)/dt,
								cframe.toaxisangle(curcf*lastcf:inverse())/dt,
								v3(0,-196.2/stdtimescale*stdtimescale*(timescale*timescale),0))
							trash.remove(modeldata[partname].weld)
							modeldata[partname]=nil
							interpolators[partname]=nil
						end
						if data.delete then
							trash.remove(modeldata[partname].weld)
							trash.remove(modeldata[partname].part)
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
			for i,v in next,modeldata do
				if v.part then
					lastcframes[i]=cframes[i]
					cframes[i]=v.part.CFrame
				end
			end
			if t0<time then
				for i,v in next,modeldata do
					if v.clone then
						trash.remove(v.weld)
						trash.remove(v.part)
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
				trash.remove(v.weld)
				trash.remove(v.part)
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



--chat module
print("Loading chat module")
do 
	local wfc			=game.WaitForChild
	local ffc			=game.FindFirstChild
	local ud2			=UDim2.new
	local ceil			=math.ceil
	local cf			=CFrame.new
	local v3			=Vector3.new
	local color			=Color3.new
	local dot			=Vector3.new().Dot
	local workspace		=workspace
	local ray			=Ray.new
	local new			=Instance.new
	local rtype			=game.IsA
	local debris		=game.Debris
	local sub			=string.sub
	local len			=string.len
	local lower			=string.lower
	local find			=string.find
	local insert		=table.insert

	local player		=game.Players.LocalPlayer
	local pgui			=player.PlayerGui
	
	local misc			=game.ReplicatedStorage.Misc
	local msg			=wfc(misc,"Msger")

	local chatgui		=wfc(pgui,"ChatGame")
	local chatbox		=wfc(chatgui,"TextBox")
	local warn			=wfc(chatgui,"Warn")
	local globalchat	=wfc(chatgui,"GlobalChat")

	local admin,moderator
	local adminlist={
		525919, --- trey
		1667819, --- shay
		5725475, --- lito
		4337002, --- buddy
	}
	local moderatorlist={
		66366193,--- cid
		70273584,--- Potato
	}

	local banlist={

	}

	local canchat		=true
	local chatspam		=0
	local totalspam		=0
	local maxchar		=200
	local lines			=8
	local chatting
	

	for i=1,#adminlist do if adminlist[i]==player.userId then admin=true end end
	for i=1,#moderatorlist do if moderatorlist[i]==player.userId then moderator=true end end
	for i=1,#banlist do if banlist[i]==player.Name then player:kick() end end

	network:add("chatted",function(chatter,text,tag,teamchat,tester)
		if teamchat and chatter.TeamColor~=player.TeamColor then return end
		local mes=msg:Clone()
		local mtag=wfc(mes,"Tag")
		local offset=5
		mes.Parent=globalchat
		mtag.Text=tag
		if tag~="" then
			offset=mtag.TextBounds.x+5
			mes.Position=ud2(0.01,offset,1,20)
			mtag.Position=ud2(0,-offset+5,0,0)
		end
		mes.Text=chatter.Name..(tester and " [Alpha Tester]" or "").." : "
		mes.TextColor=chatter.TeamColor
		mes.Msg.Text=text
		mes.Msg.Position=ud2(0,mes.TextBounds.x,0,0)
		
	end)

	function findplayer(name,speaker)
		if lower(name)=="all" then
			local chars={}
			local c=game.Players:GetChildren()
			for i =1,#c do
				insert(chars,c[i])
			end
			return chars
		elseif lower(name)=="me" then
			return {speaker}
		elseif lower(name)=="others" then
			local chars={}
			local c=game.Players:GetChildren()
			for i =1,#c do
				if c~=speaker then
					insert(chars,c[i])
				end
			end
			return chars
		else
			local chars			={}
			local commalist		={}
			local ssn			=0
			local lownum		=1
			local highestnum	=1
			local foundone

			while true do
				ssn=ssn+1
				if sub(name,ssn,ssn)=="" then
					insert(commalist,lownum)
					insert(commalist,ssn-1)
					highestnum=ssn-1
					break
				end
				if string.sub(name,ssn,ssn)=="," then
					foundone = true
					table.insert(commalist,lownum)
					table.insert(commalist,ssn)
					lownum=ssn+1
				end
			end

			if foundone then
				for ack=1,#commalist,2 do
					local cnum		=0
					local char		=nil
					local c			=game.Players:GetChildren()
					for i=1,#c do
						if find(lower(c[i].Name),sub(lower(name),commalist[ack],commalist[ack+1]-1))==1 then
							char=c[i]
							cnum=cnum+1
						end
					end
					if cnum==1 then
						table.insert(chars,char)
					end
				end
				return #chars~=0 and chars or 0
			else
				local cnum			=0
				local char			=nil
				local c				=game.Players:GetChildren()
				for i =1,#c do
					if find(lower(c[i].Name),lower(name))==1 then
						char={c[i]}
						cnum=cnum+1
					end
				end
				return cnum==1 and char or 0
			end
		end
	end

	function newchat()
		local message=chatbox.Text
		local tag=admin and "[Dev] " or moderator and "[Mod] " or ""
		local teamchat
		local teamswitch
		local admincommand

		if sub(message,1,1)=="%" then
			teamchat=true
			message=sub(message,2,len(message))
		end
		
		if chatspam>5 and not (moderator or admin) then
			warn.Visible=true
			chatspam=chatspam+1
			totalspam=totalspam+1
			warn.Text="You have been blocked temporarily for spamming.   WARNING : ".. totalspam.." out of 3"
			if totalspam>3 then
				player:Kick("Kicked for repeated spamming")
			end
			delay(5,function() chatspam=chatspam-5 warn.Visible=false end)
			return
		end
		local teamtype
		
		--[[if sub(lower(message),1,5)=="join/" or sub(lower(message),1,5)=="swap/" or sub(lower(message),1,5)=="team/" then 
			teamtype=6
		elseif sub(lower(message),1,6)==":join " or sub(lower(message),1,6)==":team " then 
			teamtype=7
		elseif sub(lower(message),1,7)=="switch/" then 
			teamtype=8
		end

		if teamtype then
			local theteam
			local tnum=0
			local t=game.Teams:GetChildren()
			for i=1,#t do
				local v=t[i]
				if find(lower(v.Name),sub(lower(message),teamtype))==1 then
					theteam=v
					tnum=tnum+1
				end
			end
			if tnum==1 and player.TeamColor~=theteam.TeamColor then
				--[==[antihack]==]network:send('c'..'h'..'a'..'n'..'g'..'e'..'t'..'e'..'a'..'m',player,theteam)
				--network:send("changeteam",player,theteam)
			end
		elseif message=="switch" or message=="switchteam" then
			--[==[antihack]==]network:send('c'..'h'..'a'..'n'..'g'..'e'..'t'..'e'..'a'..'m',player,player.TeamColor.Name=='B'..'r'..'i'..'g'..'h'..'t'..' '..'o'..'r'..'a'..'n'..'g'..'e' and BrickColor.new('B'..'r'..'i'..'g'..'h'..'t'..' '..'b'..'l'..'u'..'e') or BrickColor.new('B'..'r'..'i'..'g'..'h'..'t'..' '..'o'..'r'..'a'..'n'..'g'..'e'))
			--network:send("changeteam",player,player.TeamColor.Name=="Bright orange" and BrickColor.new("Bright blue") or BrickColor.new("Bright orange"))
		end]]

		if admin or moderator then
			if sub(message,1,5)=="kick/" then
				admincommand=true
				local guys=findplayer(sub(message,6),player)
				if guys~=0 then
					for i=1,#guys do
						--[==[antihack]==]network:send('k'..'i'..'c'..'k',guys[i])
						--network:send("kick",guys[i])
					end
				end
			end
		end

		if len(message)>200 then
			message=sub(message,1,200)
		end
		local header=teamchat and "(TEAM CHAT)" or admincommand and "[ADMIN COMMAND]" or teamswitch and "[TEAMSWITCH]" or ""
		message=header.." " ..message
		chatspam=chatspam+1
		--[==[antihack]==]network:send('c'..'h'..'a'..'t'..'t'..'e'..'d',player,message,tag,teamchat,admincommand)
		--network:send("chatted",player,message,tag,teamchat,admincommand)
		spawn(function() wait(10) chatspam=chatspam-1 end)
		chatbox.Text="Press '/' or click here to chat"
		chatting=false
		chatbox.ClearTextOnFocus=true
	end

	function chat:disable()
		canchat=false
		chatbox.Visible=false
	end

	function chat:inmenu()
		globalchat.Position=ud2(0.05,0,1,-240)
		chatbox.Position=ud2(0,10,1, -20)--ud2(0.05,10,1, -20)
	end

	function chat:ingame()
		globalchat.Position=ud2(0,150,1,-50)
		chatbox.Position=ud2(0,10,1, -20)
	end

	globalchat.ChildAdded:connect(function(child)
		local m=globalchat:GetChildren()
		for i=1,#m do
			local v=m[i]
			local tag=wfc(v,"Tag")
			local tagoff=5
			if tag.Text~="" then
				tagoff=5+tag.TextBounds.x
				v.Position=ud2(0.01,tagoff,1,v.Position.Y.Offset)
			end
			if v.Parent then
				v:TweenPosition(ud2(0.01,tagoff,1,(i-#m)*20),"Out","Sine",0.2,true)
			end
			if #m>lines and i<=#m-lines and v.Name~="Deleted" then
				v.Name="Deleted"
				wfc(v,"Msg")
				wfc(v,"Tag")
				for x=1,5 do
					if ffc(v,"Msg") and ffc(v,"Tag") then
						v.TextTransparency=(x*2)/10
						v.TextStrokeTransparency=(x*2)/10+0.1
						v.Msg.TextTransparency=(x*2)/10
						v.Msg.TextStrokeTransparency=(x*2)/10+0.1
						v.Tag.TextTransparency=(x*2)/10
						v.Tag.TextStrokeTransparency=(x*2)/10+0.1
						wait(1/30)
					end
					if v and v.Parent then trash.remove(v) end
				end
			end
		end
	end)

	chatbox.Focused:connect(function()
		chatbox.Active=true
	end)

	chatbox.FocusLost:connect(function(enter)
		chatbox.Active=false
		if enter and chatbox.Text~="" then
			newchat()
		end
	end)
	
	game:GetService("UserInputService").InputBegan:connect(function(keycode)
		if not canchat then chatbox.Visible=false return end
		if warn.Visible then return end
		local key=keycode.KeyCode
		if key==Enum.KeyCode.Slash and not chatbox.Active then	
			chatbox:CaptureFocus()
			chatbox.ClearTextOnFocus=false
		end
	end)

	if player.userId<0 or input.consoleon then 
		chat:disable()
	end

end







--hud module
print("Loading hud module")
do
	local wfc			=game.WaitForChild
	local ffc			=game.FindFirstChild
	local ud2			=UDim2.new
	local ceil			=math.ceil
	local cf			=CFrame.new
	local v3			=Vector3.new
	local color			=Color3.new
	local dot			=Vector3.new().Dot
	local workspace		=workspace
	local ray			=Ray.new
	local new			=Instance.new
	local raycast		=workspace.FindPartOnRayWithIgnoreList
	local infolder	 	=function(l,e) for i=1,#l do if l[i].Name==e then return l[i] end end end
	local rtype			=game.IsA
	local debris		=game.Debris
	
	local player		=game.Players.LocalPlayer
	local playertag		=game.ReplicatedStorage.Character.PlayerTag
	local pgui			=player.PlayerGui	
	local repstore		=game.ReplicatedStorage
	local modulestore	=repstore.GunModules
	local misc			=repstore.Misc

	local xboxmisc		=repstore.XBOX
	
	local bloodarc		=misc.BloodArc
	local spotdot		=misc.Spot
	local rfeed			=input.consoleon and xboxmisc.Feed or misc.Feed
	local hsht			=misc.Headshot
	
	local maingui		=wfc(pgui,"MainGui")

	if input.consoleon then
		maingui:Destroy()
		maingui=repstore.XBOX.MainGui:Clone()
		maingui.Parent=pgui
	end

	local spot			=wfc(pgui,"Spot")
	local gamegui		=wfc(maingui,"GameGui")
	local crossframe	=wfc(gamegui,"CrossHud")
	local crossparts	={wfc(crossframe,"HR"),wfc(crossframe,"HL"),wfc(crossframe,"VD"),wfc(crossframe,"VU"),}

	local ammohud		=wfc(gamegui,"AmmoHud")
	local scopefr		=wfc(gamegui,"ScopeFrame")
	local hitmarker		=wfc(gamegui,"Hitmarker")
	local tagfr			=wfc(gamegui,"NameTag")
	local capfr			=wfc(gamegui,"Capping")
	local bloodscreen	=wfc(gamegui,"BloodScreen")
	local radar			=wfc(gamegui,"Radar")
	local killfeed		=wfc(gamegui,"Killfeed")
	local steady		=wfc(gamegui,"Steady")
	local use			=wfc(gamegui,"Use")
	local round			=wfc(gamegui,"Round")

	local chatfr		=wfc(pgui.ChatGame,"GlobalChat")
	local steadyfull	=wfc(steady,"Full")
	local steadybar		=wfc(steadyfull,"Bar")

	local rme			=wfc(radar,"Me")
	local rfolder		=wfc(radar,"Folder")

	local distance		=300
	local offset		=-rme.Size.X.Offset/2
	
	local ammofr		=wfc(ammohud,"Frame")
	local ammotext		=wfc(ammofr,"Ammo")
	local gammo			=wfc(ammofr,"GAmmo")
	local magtext		=wfc(ammofr,"Mag")
	local healthtext	=wfc(ammofr,"Health")
	local fmodetext		=wfc(ammofr,"FMode")

	local cbar			=wfc(capfr,"Percent")

	local sightmark
	local nametags		={}
	local dotlist		={}
	local healthlist	={}
	local prevhealth	=0
	local rtime			=0
	local stime			=0
	local radarinterval	=1/60
	local spotinterval	=0.1

	local cinamode		=false
	local cinalist		={ammohud,radar,killfeed,crossframe,round,chatfr}

			
	hud.crossscale		=physics.spring.new(0)	
	hud.crossscale.s	=10	
	hud.crossscale.d	=0.8
	hud.crossscale.t	=1
	hud.crossspring		=physics.spring.new(0)
	hud.crossspring.s	=12
	hud.crossspring.d	=0.65
	
	hud.hitspring		=physics.spring.new(1)
	hud.hitspring.s		=5
	hud.hitspring.d		=0.7
	
	network:add("updateothershealth",function(player,health0,healtick0,healrate,maxhealth,alive)
		if not healthlist[player] then healthlist[player]={} end
		healthlist[player].health0=health0
		healthlist[player].healtick0=healtick0
		healthlist[player].healrate=healrate
		healthlist[player].maxhealth=maxhealth
		healthlist[player].alive=alive
	end)
	
	network:add("killfeed",function(killer,victim,dist,weapon,head)
		local spacing=input.consoleon and 20 or 15
		local newfeed=rfeed:Clone()
		newfeed.Text=killer.Name
		newfeed.TextColor=killer.TeamColor
		newfeed.GunImg.Text=weapon
		if head then hsht:Clone().Parent=newfeed.GunImg end
		newfeed.Victim.Text=victim.Name
		newfeed.Victim.TextColor=victim.TeamColor
		newfeed.GunImg.Dist.Text="Dist: "..dist.." studs"
		newfeed.Parent=killfeed

		newfeed.GunImg.Size = UDim2.new(0,newfeed.GunImg.TextBounds.x,0,30)
		newfeed.GunImg.Position = UDim2.new(0,spacing+newfeed.TextBounds.x,0,-5)
		newfeed.Victim.Position = UDim2.new(0,spacing*2+newfeed.TextBounds.x+newfeed.GunImg.TextBounds.x,0,0)
		
		spawn(function()
			newfeed.Visible = true
			wait(20)
			for i = 1, 10 do
				if newfeed.Parent then
				newfeed.TextTransparency=i/10
				newfeed.TextStrokeTransparency=i/10+0.5
				newfeed.GunImg.TextStrokeTransparency=i/10+0.5
				newfeed.GunImg.TextTransparency=i/10
				newfeed.Victim.TextStrokeTransparency=i/10+0.5
				newfeed.Victim.TextTransparency=i/10
				wait(1/30)
				end
			end
			if newfeed and newfeed.Parent then trash.remove(newfeed) end
		end)

		local kb=killfeed:GetChildren()
		for i=1,#kb do
			local v=kb[i]
			v:TweenPosition(ud2(0.01,5,1,(i-#kb)*25-25),"Out","Sine",0.2,true)
			if #kb>5 and (#kb-i)>=5 then
				spawn(function()
					if kb[1].Name~="Deleted" then
						for i = 1, 10 do
							if ffc(kb[1],"Victim") then
								kb[1].TextTransparency=i/10
								kb[1].TextStrokeTransparency=i/10+0.5
								kb[1].Victim.TextTransparency=i/10
								kb[1].Victim.TextStrokeTransparency=i/10+0.5
								kb[1].Name="Deleted"
								kb[1].GunImg.TextTransparency=i/10
								kb[1].GunImg.TextStrokeTransparency=i/10+0.5
								wait(1/30)
							end
						end
						trash.remove(kb[1])
					end
				end)
			end
		end
	end)

	function hud.inializehealth(player,alive)
		if not healthlist[player] then healthlist[player]={} end
		healthlist[player].health0=alive and 100 or 0
		healthlist[player].healtick0=0
		healthlist[player].healrate=0
		healthlist[player].maxhealth=100
		healthlist[player].healwait=5
		healthlist[player].alive=alive
	end

	local function gethealth(player)
		local healthstat=healthlist[player]
		if healthstat then
			local health0=healthlist[player].health0
			local healtick0=healthlist[player].healtick0
			local healrate=healthlist[player].healrate
			local maxhealth=healthlist[player].maxhealth
			local alive=healthlist[player].alive
			if alive then
				local x=tick()-healtick0
				if x<0 then
					return health0
				else
					local curhealth=health0+x*healrate
					return curhealth<maxhealth and curhealth or maxhealth
				end
			else
				return 0
			end
		else
			return 0
		end
	end
	
	local function changehealthlocally(player,dhealth)
		local healthstat=healthlist[player]
		if healthstat then
			local health0=healthlist[player].health0
			local healtick0=healthlist[player].healtick0
			local healrate=healthlist[player].healrate
			local maxhealth=healthlist[player].maxhealth
			local healwait=healthlist[player].healwait
			local alive=healthlist[player].alive
			if alive then
				local time=tick()
				local x=time-healtick0
				local curhealth
				if x<0 then
					curhealth=health0
				else
					curhealth=health0+x*healrate
					curhealth=curhealth<maxhealth and curhealth or maxhealth
				end
				healthlist[player].health0=curhealth+dhealth
				if dhealth<0 then
					healthlist[player].healtick0=time+healwait
				else
					healthlist[player].healtick0=time
				end
			end
		end
	end
	
	function hud:changehealthlocally(player,dhealth)
		changehealthlocally(player,dhealth)
	end
	
	function hud:setscopeid(id)
		scopefr.ScopeId.Image=id
	end

	function hud:gundrop(dropmodel,gunname)
		if not gamelogic.currentgun then return end
		use.Text=""
		if dropmodel and not ffc(dropmodel,"DB") then		
			local dropdata=require(modulestore[gunname])
			if dropdata then
				use.Text=(input.consoleon and "Press DPadRight" or "Press V").. " to pick up ["..(dropdata.displayname or gunname).."]"
				if dropdata.type==gamelogic.currentgun.type or dropdata.ammotype==gamelogic.currentgun.ammotype then
					local sparev=ffc(dropmodel,"Spare")
					if sparev and sparev.Value>0 then
						local diff=0
						local _,curspare=gamelogic.currentgun:dropguninfo()
						local db=new("Model",dropmodel)
						db.Name="DB"
						debris:AddItem(db,2)
						if curspare+sparev.Value>gamelogic.currentgun.sparerounds then
							diff=gamelogic.currentgun.sparerounds-curspare
						else
							diff=sparev.Value
						end
						if diff>0 then
							gamelogic.currentgun:addammo(diff,gunname)
							--[==[antihack]==]network:send('g'..'e'..'t'..'a'..'m'..'m'..'o',dropmodel,diff)
							--network:send("getammo",dropmodel,diff)
						end
					end
				end
			end
		end
	end
	
	function hud:getuse()
		return use.Text~=""
	end

	function hud:enablegamegui(on)
		gamegui.Visible=on
	end

	function hud:togglecinema()
		cinamode=not cinamode
		for i,v in next,cinalist do
			v.Visible=not cinamode
		end		
	end
	
	function hud:isplayeralive(p)
		local healthstat=healthlist[p]
		if healthstat then
			return healthlist[p].alive
		end
	end
	
	function hud:getplayerhealth(p)
		return gethealth(p)
	end
	
	local function updatecross()
		local size=hud.crossspring.p*4*hud.crossscale.p*(char.speed/14*(1-0.8)*2+0.8)*(char.sprint+1)/2
		for i=1,4 do
			crossparts[i].BackgroundTransparency=1-size/20
		end
		crossparts[1].Position=ud2(0,size,0,0)
		crossparts[2].Position=ud2(0,-size-7,0,0)
		crossparts[3].Position=ud2(0,0,0,size)
		crossparts[4].Position=ud2(0,0,0,-size-7)
		if hud.crossspring.t==0 and not scopefr.Visible and sightmark and sightmark.Parent then
			local pos=camera.currentcamera:WorldToViewportPoint(sightmark.Position)
			hitmarker.Position=ud2(0,pos.x-125,0,pos.y-125)
		else
			hitmarker.Position=ud2(0.5,-125,0.5,-125)
		end
	end

	function hud:getplayervisible(guy)
		local state=nametags[guy]
		if state then
			return state.Visible
		end
	end
	
	local function updateplayernames()
		local pp=game.Players:GetChildren()
		local pphash={}
		local camcf=camera.cframe
		for i=1,#pp do
			local v=pp[i]
			if v~=player and v.Character and ffc(v.Character,"Head") and ffc(v.Character,"Torso") then--I FIXED UR ERROR BY ADDING v.Character and
				pphash[v]=true
				local head=v.Character.Head
				local torsopos=v.Character.Torso.CFrame*v3(0,0.5,0)
				local pos=camera.currentcamera:WorldToScreenPoint(head.Position+cframe.vtws(camcf,v3(0,0.625,0)))
				local center=camera.currentcamera.ViewportSize/2
				local dist=(torsopos-camcf.p).magnitude
				local d=dot(camera.lookvector,(torsopos-camcf.p).unit)
				local diff=(1/(d*d)-1)^0.5*dist
				local tag=nametags[v]
				if tag and ffc(tag,"Health") then
					tag.Position=ud2(0,pos.x-75,0,pos.y)
					tag.Health.Visible=v.TeamColor==player.TeamColor
					tag.TextColor3=v.TeamColor~=player.TeamColor and color(255/255,10/255,20/255) or color(0,255/255,234/255)
					if v.TeamColor~=player.TeamColor then
						local scan=raycast(workspace,ray(camcf.p,torsopos-camcf.p),{camera.currentcamera,char.character,v.Character})
						tag.Visible=not scan and d>0
						tag.TextTransparency=0.1+(diff<1 and 0 or diff<4 and diff-1 or 1)*0.9
						tag.TextStrokeTransparency=0.7+(diff<1 and 0 or diff<4 and diff-1 or 1)*0.3
					else
						tag.Health.Percent.Size=ud2(gethealth(v)/100,0,1,0)
						tag.Visible=d>0 and hud:isplayeralive(v)
					end
				else
					local newtag=playertag:Clone()
					newtag.Text=v.Name
					newtag.Health.Percent.Size=ud2(1,0,1,0)
					newtag.Position=ud2(0,pos.x-75,0,pos.y)
					newtag.Parent=tagfr
					newtag.Visible=pos.z>0
					newtag.Health.Visible=v.TeamColor==player.TeamColor
					newtag.TextTransparency=0.1
					newtag.TextStrokeTransparency=0.7
					newtag.TextColor3=v.TeamColor~=player.TeamColor and color(255/255,10/255,20/255) or color(0,255/255,234/255)
					nametags[v]=newtag
				end
			end
		end
		for i,v in next,nametags do
			if not pphash[i] then
				trash.remove(v)
				nametags[i]=nil
			end
		end
	end
	
	function hud:capping(flag,progress)
		if flag then
			capfr.Visible=true
			cbar.Size=ud2(progress/50,0,1,0)
		else
			capfr.Visible=false
		end
	end
	
	function hud:setsteadybar(size)
		steadybar.Size=size
	end

	function hud:getsteadysize()
		return steadybar.Size.X.Scale
	end

	function hud:setcrossscale(scale)
		hud.crossscale.t=scale
	end	
	
	function hud:setcrosssize(size)
		hud.crossspring.t=size
	end
	
	function hud:setscope(visible,console)
		scopefr.Visible=visible
		steady.Visible=visible
		steady.Text=(input.consoleon or console) and "Hold DPadUp to steady" or "Hold Shift to steady"
	end
	
	function hud:setcrosssettings(size,speed,damper,sight)
		hud.crossspring.t=size
		hud.crossspring.s=speed
		hud.crossspring.d=damper
		sightmark=sight
	end

	function hud:updatesightmark(sight)
		sightmark=sight
	end
	
	function hud:updateammo(mag,ammo)
		if mag=="KNIFE" then
			ammotext.Text="/ --"
			magtext.Text="--"
		elseif mag=="GRENADE" then
			ammotext.Text="/ --"
			magtext.Text="--"
			gammo.Text="Gx"..gamelogic.gammo
		else
			ammotext.Text="/ "..ammo
			magtext.Text=mag
		end
	end
	
	function hud:updatefiremode(mode)
		fmodetext.Text=mode=="KNIFE" and "[------]" or mode==true and "[AUTO]" or mode==1 and "[SEMI]" or "[BURST]"
	end
	
	function hud:firehitmarker()
		hud.hitspring.p=-3
	end
	
	function hud:fireradar(guy)
		local prev=infolder(spot:GetChildren(),guy.Name)				
		if prev then
			prev.Time.Value=(prev.Time.Value<=30 and 30) or (prev.Time.Value+30>200 and 200) or prev.Time.Value+30
		else
			local mark=spotdot:Clone()
			mark.Parent=spot
			mark.Name=guy.Name
			mark.Time.Value=30
			mark.Adornee=char.rootpart
		end
	end	
	
	local function updatehealth()
		local health=char.health
		if health>100 then player:kick() end
		healthtext.Text=health+-health%1
		if health<prevhealth then 
			local damage=prevhealth-health
			bloodscreen.ImageTransparency=bloodscreen.ImageTransparency-damage/prevhealth*.7
			bloodscreen.BackgroundTransparency=bloodscreen.BackgroundTransparency-damage/prevhealth*.5+.3
		elseif health>prevhealth or health==100 then 
			bloodscreen.ImageTransparency=bloodscreen.ImageTransparency+0.001
			bloodscreen.BackgroundTransparency=bloodscreen.BackgroundTransparency+0.001
		elseif health<=0 then
			bloodscreen.ImageTransparency=1
			bloodscreen.BackgroundTransparency=1
		end
		prevhealth=health
	end
	
	local function update_pos(ref,pos,color,trans)
		local dot=dotlist[ref]
		if not dot then return end
		dot.Visible=true
		dot.BackgroundColor3=color
		dot.Position=pos
		dot.BackgroundTransparency=trans
	end
		
	local function updateradar()
		local old				=rfolder:GetChildren()
		for i =1, #old do
			old[i].Visible=false
		end 
		local torso				=char.rootpart
		local look				=torso.CFrame.lookVector
		local cameracf			=cf(torso.CFrame.p,torso.CFrame.p+look)
		local ppl				=game.Players:GetChildren()
		for i=1,#ppl do
			local v=ppl[i]
			if v~=player and v.Character and workspace:FindFirstChild(v.Name) then
				local tor			=ffc(v.Character,"Torso")
				local alive			=ffc(v.Character,"Humanoid")
				if tor and alive then
					if v.TeamColor==player.TeamColor or infolder(spot:GetChildren(),v.Name) then		
						local diff			=cameracf:inverse()*tor.Position
						local x				=0.5+diff.x/distance
						local z				=0.5+diff.z/distance
						local pos			=ud2(x,offset,z,offset)
						local c				=v.TeamColor==player.TeamColor and color(0.5,1,0.5) or color(1,0,0)
						update_pos(i,pos,c,-0.5+(torso.Position-tor.Position).Magnitude/150)
					end
				end
			end
		end
		local map				=ffc(workspace,"Map")
		if map then
			local agmp			=ffc(map,"AGMP")
			if agmp then
				local stuff=agmp:GetChildren()
				for i=1,#stuff do
					local v				=stuff[i]
					local base			=ffc(v,"Base")
					local teamcolor		=ffc(v,"TeamColor")
					if base then		
						local diff			=cameracf:inverse()*base.Position
						local x				=0.5+diff.x/distance
						local z				=0.5+diff.z/distance
						local pos			=ud2(x,offset,z,offset)
						local c				=teamcolor.Value.Color
						update_pos(i,pos,c,-0.5+(torso.Position-base.Position).magnitude/150)
					end
				end
			end
		end
	end
	
	function hud:firespot(v,spotter)
		local spotter=spotter or player.Name
		if v.Character  then
			local head=ffc(v.Character,"Head")
			local prev=infolder(spot:GetChildren(),v.Name)
			if head then
				if prev then
					prev.Enabled=true
					prev.Time.Value=150
					prev.Dot.Visible=true
					prev.Adornee=head
					if not ffc(prev,spotter) then
						local assist=new("Model",prev)
						assist.Name=spotter
					end
				else
					local mark=spotdot:Clone()
					mark.Adornee=head
					mark.Parent=spot
					mark.Enabled=true
					mark.Name=v.Name
					mark.Time.Value=150
					local assist=new("Model",mark)
					assist.Name=spotter
				end
			end
		end
	end
	
	network:add("spotted",function(spottedlist,spotter)
		for i=1,#spottedlist do
			local v=spottedlist[i]
			hud:firespot(v,spotter)
		end
	end)
	
	network:add("shot",function(shooter,pos)
		local bars=gamegui:GetChildren()
		for i = 1, #bars do
			if bars[i].Name=="Bar" and bars[i].Player.Value==shooter.Name then
				trash.remove(bars[i])
			end
		end
		local br=bloodarc:Clone()
		br.Pos.Value=pos
		br.Player.Value=shooter.Name
		br.Parent=gamegui
	end)
	

	function hud:reloadhud()
		--print("reload hud")
		pgui			=player.PlayerGui	
		maingui			=wfc(pgui,"MainGui")
		gamegui			=wfc(maingui,"GameGui")
		
		bloodscreen		=wfc(gamegui,"BloodScreen")
		
		crossframe		=wfc(gamegui,"CrossHud")
		crossparts		={wfc(crossframe,"HR"),wfc(crossframe,"HL"),wfc(crossframe,"VD"),wfc(crossframe,"VU"),}

		ammohud			=wfc(gamegui,"AmmoHud")
		ammofr			=wfc(ammohud,"Frame")
		scopefr			=wfc(gamegui,"ScopeFrame")
		ammotext		=wfc(ammofr,"Ammo")
		magtext			=wfc(ammofr,"Mag")
		healthtext		=wfc(ammofr,"Health")
		fmodetext		=wfc(ammofr,"FMode")
		hitmarker		=wfc(gamegui,"Hitmarker")
		tagfr			=wfc(gamegui,"NameTag")
		
		radar			=wfc(gamegui,"Radar")
		rme				=wfc(radar,"Me")
		rfolder			=wfc(radar,"Folder")
		
		nametags		={}
		dotlist			={}
		
		tagfr:ClearAllChildren()
		rfolder:ClearAllChildren()

		hud:setscope(false)
		effects:reload()
		notify:reset()
		particle:reset()
		
		local bar=ffc(maingui,"KillBar")
		if bar then trash.remove(bar) end
		
		for i=1,50 do
			local dot=rme:Clone()
			dot.Parent=rfolder
			dot.Visible=false
			dotlist[#dotlist+1]=dot
		end
		wait(.1)
	end
	
	function hud.step()
		updatecross()
		updateplayernames()
		updatehealth()
		hitmarker.ImageTransparency=hud.hitspring.p
		
		if run.time>rtime+radarinterval then
			updateradar()
			rtime=run.time+radarinterval
		end
		
		if run.time>stime+spotinterval then
			local sht=spot:GetChildren()
			for i=1,#sht do
				local v=sht[i]
				if rtype(v,"BillboardGui") then
					if not v.Adornee or v.Time.Value<=0 then 
						trash.remove(v) 
					else
						v.Time.Value=v.Time.Value-1
					end
				end
			end
			stime=run.time+spotinterval
		end
	end
end



--notify module
print("Loading notify module")
do
	local wfc			=game.WaitForChild
	local ffc			=game.FindFirstChild
	local ud2			=UDim2.new
	local ceil			=math.ceil
	local v3			=Vector3.new
	local color			=Color3.new
	local dot			=Vector3.new().Dot
	local workspace		=workspace
	local ray			=Ray.new
	local raycast		=workspace.FindPartOnRayWithIgnoreList
	local new			=Instance.new
	
	local player		=game.Players.LocalPlayer
	local repstore		=game.ReplicatedStorage
	local misc			=repstore.Misc
	local pgui			=player.PlayerGui	

	local maingui		=wfc(pgui,"MainGui")
	local gamegui		=wfc(maingui,"GameGui")
	local framelist		=wfc(gamegui,"NotifyList")
	
	local main			=misc.Main
	local side			=misc.Side
	local killbar		=misc.KillBar
	local rankbar		=misc.RankBar
	local attachbar		=misc.AttachBar
	
	local typelist = {
		["kill"]			={"Enemy Killed!"},
	
		["collx2"]			={"Double Collateral!"},
		["collx3"]			={"Triple Collateral!"},
		["collxn"]			={"Multi Collateral!"},

		["killx2"]			={"Double Kill!"},
		["killx3"]			={"Triple Kill!"},
		["killx4"]			={"Quad Kill!"},
		["killxn"]			={"Multi Kill!"},

		["backstab"]		={"Backstab!"},
		["assist"]			={"Assist!"},
		["assistkill"]		={"Assist Count As Kill!"},
		
		["head"]			={"Headshot bonus!"},
		["long"]			={"Killed from a distance!"},
		["spot"]			={"Spot Bonus!"},
		["squad"]			={"Teammate spawned on you"},
		
		--game objectives
		["domcap"]			={"Captured a position!"},
		["domcapping"]		={"Capturing position"},
		["domdefend"]		={"Defended a position!"},
		["domassault"]		={"Assaulted a position!"},
		["domattack"]		={"Attacked a position!"},
		["dombuzz"]			={"Stopped an enemy capture!"},

		["kingcap"]			={"Captured the hill!"},
		["kingholding"]		={"Holding hill"},
		["kingcapping"]		={"Capturing hill"},
		["kingdefend"]		={"Defended the hill!"},
		["kingassault"]		={"Assaulted the hill!"},
		["kingattack"]		={"Attacked the hill!"},
		["kingbuzz"]		={"Stopped enemy capture of the hill!"},

		--reference
		[""]				={},
	}
	
	local function typeout(label,speed)
		local speed=speed or 2
		local text=label.Text
		label.Text=""
		spawn(function()
			for i=1,string.len(text) do
				label.Text=string.sub(text,1,speed*i)
				wait(1/60)
			end
		end)
	end
	
	local function queuetypeout(label,speed)
		local speed=speed or 3
		local text=label.Text
		label.Text=""
		for i=1,string.len(text) do
			label.Text=string.sub(text,1,speed*i)
			wait(1/60)
		end
	end

	function notify:customaward(customtext)
		local pt			=pt or 25
		local display		=side:Clone()
		local primary		=wfc(display,"Primary")
		
		display.Parent=framelist
		local fr=framelist:GetChildren()
		for i=1,#fr do
			local v=fr[i]
			if v:IsA("Frame") and v.Parent then
				v:TweenPosition(ud2(0,0,0,(#fr-i)*20),"Out","Sine",0.05,true)
			end
		end
		spawn(function()
			primary.Text=customtext
			---initialize
			primary.TextTransparency=0
			---animation start
			typeout(primary,3)
			---co-running animations
			wait(5.5)
			for i=1,10 do
				primary.TextTransparency=i/10
				primary.TextStrokeTransparency=i/10+0.4
				wait(1/60)
			end
			wait(0.1)
			trash.remove(display)
		end)
	end	
	
	function smallaward(type,pt)
		local pt			=pt or 25
		local display		=side:Clone()
		local primary		=wfc(display,"Primary")
		local point			=wfc(display,"Point")
		
		display.Parent=framelist
		local fr=framelist:GetChildren()
		for i=1,#fr do
			local v=fr[i]
			if v:IsA("Frame") and v.Parent then
				v:TweenPosition(ud2(0,0,0,(#fr-i)*20),"Out","Sine",0.05,true)
			end
		end
		spawn(function()
			point.Text="[+"..pt.."]"
			primary.Text=typelist[type][1]
			---initialize
			point.TextTransparency=0
			primary.TextTransparency=0
			---animation start
			typeout(point,3)
			typeout(primary,3)
			---co-running animations
			wait(5.5)
			for i=1,10 do
				point.TextTransparency=i/10
				primary.TextTransparency=i/10
				point.TextStrokeTransparency=i/10+0.4
				primary.TextStrokeTransparency=i/10+0.4
				wait(1/60)
			end
			wait(0.1)
			trash.remove(display)
		end)
	end	
	
	function bigaward(type,victim,weap,pt)
		local display		=main:Clone()
		local bk			=wfc(display,"Overlay")
		local primary		=wfc(display,"Primary")
		local point			=wfc(display,"Point")
		local enemy			=wfc(display,"Enemy")
		
		display.Parent=framelist
		local fr=framelist:GetChildren()
		for i=1,#fr do
			local v=fr[i]
			if v:IsA("Frame") and v.Parent then
				v:TweenPosition(ud2(0,0,0,(#fr-i)*20),"Out","Sine",0.05,true)
			end
		end
		spawn(function()
			point.Text="[+"..pt.."]"
			primary.Text=typelist[type][1]
			enemy.Text=victim
			
			---initialize
			point.TextTransparency=0
			primary.TextTransparency=0
			enemy.TextTransparency=1
			---animation start
			bk.ImageTransparency=0.2
			bk:TweenSizeAndPosition(ud2(0,200,0,80),ud2(0.5,-150,0.7,-40),"Out","Linear",0,true)
			typeout(point)
			typeout(primary)
			---co-running animations
			spawn(function()
				wait(.05)
				for i=1,10 do
					bk.ImageTransparency=i/10
					wait(0.1)
				end
				bk.Size=ud2(0,200,0,80)
				bk.Position=ud2(0.55,-100,0.3,-40)
			end)
			---
			bk:TweenSizeAndPosition(ud2(0,300,0,30),ud2(0.5,-150,0.7,-15),"Out","Linear",.05,true)
			wait(.05)
			bk:TweenSizeAndPosition(ud2(0,500,0,8),ud2(0.5,-150,0.7,-4),"Out","Linear",.05,true)
			wait(1.5)
			for i = 1,2 do
				primary.TextTransparency=1
				wait(.1)
				primary.TextTransparency=0
				wait(.1)
			end
			primary.TextTransparency=1
			wait(0.2)
			enemy.TextTransparency=0
			queuetypeout(enemy,4)
			primary.TextTransparency=0
			primary.Position=ud2(0.5,enemy.TextBounds.x+10,0.7,-10)
			primary.Text="["..weap.."]"
			queuetypeout(primary,4)
			wait(3)
			for i=1,10 do
				point.TextTransparency=i/10
				primary.TextTransparency=i/10
				enemy.TextTransparency=i/10
				point.TextStrokeTransparency=i/10+0.4
				primary.TextStrokeTransparency=i/10+0.4
				enemy.TextStrokeTransparency=i/10+0.4
				wait(1/60)
			end
			wait(0.1)
			trash.remove(display)
		end)
	end

	local function unlockedgun(weapon)
		local br		=attachbar:Clone()
		local title		=br.Title
		local atext		=br.Attach

		br.Parent		=maingui
		br.Position		=ud2(0.5,0,0.15,0)
		title.Text		="Unlocked New Gun!"
		atext.Text		=weapon

		local t0=tick()
		local stop;stop=run.onstep:connect(function()
			local t=tick()-t0
			--set the transparencies
			atext.TextTransparency=t<2 and 0 or t<2.5 and (t-2)/0.5 or 1
			title.TextTransparency=t<2 and 0 or t<2.5 and (t-2)/0.5 or 1
			if 3<t then
				stop()
				br:Destroy()
			end
		end)
	end

	local function unlockedattach(weapon,attachments,killss) 
		for i=1,#attachments do
			local attachment=attachments[i]
			local kills		=killss[i]
			local br		=attachbar:Clone()
			local money		=br.Money
			local title		=br.Title
			local atext		=br.Attach
			
			br.Parent		=maingui
			br.Position		=ud2(0.5,0,0.15,0)
			title.Text		="Unlocked "..weapon.." Attachment"
			atext.Text		=attachment
			money.Text		="[+200]"
	
			local t0=tick()
			local stop;stop=run.onstep:connect(function()
				local t=tick()-t0
				--set the transparencies
				atext.TextTransparency=t<2 and 0 or t<2.5 and (t-2)/0.5 or 1
				title.TextTransparency=t<2 and 0 or t<2.5 and (t-2)/0.5 or 1
				money.TextTransparency=t<0.5 and 1 or t<2.5 and 0 or t<3 and (t-2.5)/0.5 or 1
				if 3<t then
					stop()
					br:Destroy()
				end
			end)
			wait(3)---FHRFHF*EUIHIOUHOERIUGEHRIu
		end
	end

	local function rankup(rank,newguns)
		local br		=rankbar:Clone()
		local money		=br.Money
		local title		=br.Title
		local rtext		=br.Rank

		local count		=0
		local sht		=maingui:GetChildren()
		for i=1,#sht do
			if sht[i].Name=="RankBar" or sht[i].Name=="AttachBar" then
				count=count+1
			end
		end
		br.Parent		=maingui
		rtext.Text		=rank
		money.Text		="+"..(200+5*rank).." CR"

		local t0=tick()
		local stop;stop=run.onstep:connect(function()
			local t=tick()-t0
			--set the transparencies
			rtext.TextTransparency=t<3 and 0 or t<3.5 and (t-3)/0.5 or 1
			title.TextTransparency=t<3 and 0 or t<3.5 and (t-3)/0.5 or 1
			money.TextTransparency=t<0.5 and 1 or t<3.5 and 0 or t<4 and (t-3.5)/0.5 or 1
			if 4<t then
				stop()
				br:Destroy()
				if newguns then
					for i=1,#newguns do
						unlockedgun(newguns[i])
						wait(3)--LELELELLELEELLELELELELE
					end
				end
			end
		end)
	end

	function notify:testrankup(rank) 
		rankup(rank)
	end

	function notify:reset()
		maingui=wfc(pgui,"MainGui")
		gamegui=wfc(maingui,"GameGui")
		framelist=wfc(gamegui,"NotifyList")
		if ffc(maingui,"KillBar") then
			trash.remove(maingui["KillBar"])
		end
	end
	
	network:add("killed",function(killer,part,deathcf,weapon,rank,attachdata)
		char.deadcf=deathcf
		if killer==player then
			camera:setfixedcam(deathcf)
		else
			camera:setspectate(killer,part)
			local newbar=killbar:Clone()
			newbar.Killer.Label.Text=killer.Name
			newbar.Weapon.Label.Text=weapon
			newbar.Parent=maingui
			newbar.Rank.Label.Text=rank
			for i,v in next,newbar.Attachments:GetChildren() do
				v.Type.Text="None"
			end
			if attachdata then
				for i,v in next,attachdata do
					if i~="Name" and v~="" then
						newbar.Attachments[i].Type.Text=v
					end
				end
			end
		end
	end)
	
	network:add("unlockedattach",unlockedattach)

	network:add("rankup",rankup)

	network:add("bigaward",function(type,victim,weapon,pt)
		bigaward(type,victim,weapon,pt)
	end)
	
	network:add("smallaward",function(type,pt)
		smallaward(type,pt)
	end)
	
	function notify.step()
		if char.health<=0 then
			local bar=ffc(maingui,"KillBar")
			if bar then
				local enemy=ffc(game.Players,bar.Killer.Label.Text)
				if enemy then
					local health=hud:getplayerhealth(enemy)
					bar.Health.Label.Text=ceil(health)
					bar.Health.Label.TextColor3=health<20 and color(1,0,0) or health<50 and color(1,1,0) or color(0,1,0)
				end
			end
		end
	end
end


--leaderboard module
print("Loading leaderboard module")
do
	local wfc			=game.WaitForChild
	local ffc			=game.FindFirstChild
	local ud2			=UDim2.new
	local ceil			=math.ceil
	local cf			=CFrame.new
	local v3			=Vector3.new
	local color			=Color3.new
	local dot			=Vector3.new().Dot
	local workspace		=workspace
	local ray			=Ray.new
	local new			=Instance.new
	local raycast		=workspace.FindPartOnRayWithIgnoreList
	local infolder	 	=function(l,e) for i=1,#l do if l[i].Name==e then return l[i] end end end
	local rtype			=game.IsA
	local debris		=game.Debris
	
	local player		=game.Players.LocalPlayer
	local playertag		=game.ReplicatedStorage.Character.PlayerTag
	local pgui			=player.PlayerGui	
	local misc			=input.consoleon and game.ReplicatedStorage.XBOX or game.ReplicatedStorage.Misc

	local playerstat	=misc.Player

	local board			=wfc(pgui,"Leaderboard")
	if input.consoleon then
		board:Destroy()
		board=misc.Leaderboard:Clone()
		board.Parent=pgui
	end

	local main			=wfc(board,"Main")
	local global		=wfc(board,"Global")

	local ghost			=wfc(main,"Ghosts")
	local phantom		=wfc(main,"Phantoms")

	local ghostdata		=wfc(wfc(ghost,"DataFrame"),"Data")
	local phantomdata	=wfc(wfc(phantom,"DataFrame"),"Data")

	local spacing		=input.consoleon and 30 or 25

	local function organize()
		---check players in right teams
		local pp=game.Players:GetChildren()
		for i=1,#pp do
			local v=pp[i]
			local rightparent=v.TeamColor==game.Teams.Ghosts.TeamColor and ghostdata or phantomdata
			local wrongparent=v.TeamColor~=game.Teams.Ghosts.TeamColor and ghostdata or phantomdata
			local right=ffc(rightparent,v.Name)
			local wrong=ffc(wrongparent,v.Name)
			if not right and wrong then
				wrong.Parent=rightparent
			end
		end
		---reposition and check nonexistent players
		local gd=ghostdata:GetChildren()
		table.sort(gd,function(a,b) return tonumber(a.Score.Text)>tonumber(b.Score.Text) end)

		for i=1,#gd do
			local v=gd[i]
			v.Position=ud2(0,0,0,i*spacing)
			if v.Name==player.Name then v.Username.TextColor3=color(1,1,0) end
		end
		ghostdata.Parent.CanvasSize=ud2(0,0,0,(#gd+1)*spacing)

		local pd=phantomdata:GetChildren()
		table.sort(pd,function(a,b) return tonumber(a.Score.Text)>tonumber(b.Score.Text) end)

		for i=1,#pd do
			local v=pd[i]
			v.Position=ud2(0,0,0,i*spacing)
			if v.Name==player.Name then v.Username.TextColor3=color(1,1,0) end
		end
		phantomdata.Parent.CanvasSize=ud2(0,0,0,(#pd+1)*spacing)
	end

	local function addplayer(guy)
		local gbar=ffc(ghostdata,guy.Name)
		local pbar=ffc(phantomdata,guy.Name)
		if gbar or pbar then return end
		local bar=playerstat:Clone()
		bar.Name=guy.Name
		bar.Username.Text=guy.Name
		bar.Kills.Text=0
		bar.Deaths.Text=0
		bar.Streak.Text=0
		bar.Score.Text=0
		bar.Kdr.Text=0
		bar.Rank.Text=0
		if guy==player then
			bar.Username.TextColor3=color(1,1,0)
		end
		bar.Parent=guy.TeamColor==game.Teams.Ghosts.TeamColor and ghostdata or phantomdata
		organize()
	end

	local function removeplayer(guy)
		local gbar=ffc(ghostdata,guy.Name)
		local pbar=ffc(phantomdata,guy.Name)
		if gbar then trash.remove(gbar) end
		if pbar then trash.remove(pbar) end
		organize()
	end

	local function updatestats(guy,data)
		local rightparent=guy.TeamColor==game.Teams.Ghosts.TeamColor and ghostdata or phantomdata
		local bar=ffc(rightparent,guy.Name)
		if not bar then organize() bar=ffc(rightparent,guy.Name) end
		if bar then
			for i,v in next,data do
				bar[i].Text=v
			end
		end
		organize()
	end

	function leaderboard:show()
		main.Visible=true
	end

	function leaderboard:hide()
		main.Visible=false
	end

	network:add("removeplayer",removeplayer)
	network:add("newplayer",addplayer)
	network:add("updatestats",updatestats)

	organize()

	game:GetService("UserInputService").InputBegan:connect(function(keycode)
		local key=keycode.KeyCode
		if key==Enum.KeyCode.Tab and not input.keyboard.down["LeftAlt"] then	
			if main.Visible then
				leaderboard:hide()
			else
				organize()
				leaderboard:show()
			end
		end
	end)

end




--char module
--
print("Loading char module")
do
	local rtype			=game.IsA
	local next			=next
	local new			=Instance.new
	local wfc			=game.WaitForChild
	local ffc			=game.FindFirstChild
	local getchildren	=game.GetChildren
	local workspace		=game.Workspace
	local cf			=CFrame.new
	local vtws			=CFrame.new().vectorToWorldSpace
	local angles		=CFrame.Angles
	local nc			=cf()
	local v3			=Vector3.new
	local nv			=v3()
	local ray			=Ray.new
	local raycast		=workspace.FindPartOnRayWithIgnoreList
	local debris		=game.Debris
	local dot			=nv.Dot
	local ud2			=UDim2.new
	local abs			=math.abs
	local tos			=cf().toObjectSpace

	local player		=game.Players.LocalPlayer
	local pgui			=player.PlayerGui
	local repstore		=game.ReplicatedStorage
	local repchar		=repstore.Character
	local attmodels		=repstore.AttachmentModels
	local character
	local humanoid
	local rootpart
	local rootjoint
	local statsloaded

	--Randomass shit
	local thread			=sequencer.new()
	local weapon			=nil
	local aiming			=false
	local auto				=false
	local burst				=0
	local reloading			=false
	local sprinting			=false
	local animating			=false
	local stability			=0
	local basewalkspeed		=14--arb
	local sprintspring		=physics.spring.new()
	local aimspring			=physics.spring.new()
	local swingspring		=physics.spring.new(nv)
	local speedspring		=physics.spring.new()
	local velocityspring	=physics.spring.new(nv)
	local pronespring		=physics.spring.new(0)
	local truespeedspring	=physics.spring.new(0)
	local equipspring		=physics.spring.new(1)
	local muzzlespring		=physics.spring.new(0)
	local walkspeedmult		=1

	sprintspring.s			=12
	sprintspring.d			=0.9
	aimspring.d				=0.9
	swingspring.s			=10
	swingspring.d			=0.75
	speedspring.s			=16
	velocityspring.s		=16
	pronespring.s			=8
	truespeedspring.s		=8
	equipspring.s			=12--arb
	equipspring.d			=0.75--arb
	

	--MOVEMENT MODULE LOLOLOL
	local ignore			={workspace.Ignore,game.Workspace.CurrentCamera}
	local backwardsmult		=0.8
	local bodyforce			=new("BodyForce")
	local muzzlelight
	local walkspeedspring
	local headheightspring
	local updatewalkspeed

	walkspeedspring			=physics.spring.new(basewalkspeed)
	walkspeedspring.s		=8--arb
	headheightspring		=physics.spring.new(1.5)
	headheightspring.s		=8--arb
	char.acceleration		=nv

	bodyforce.force			=nv

	do
		--local raycast		=function(r,i) return rayignore(workspace,r,i) end	

		local movementmode	="stand"
		local down			=v3(0,-4,0)--arb
		local standcf		=nc
		local crouchcf		=cf(0,-1.5,0)--arb
		local pronecf		=cf(0,-1.5,1.5,1,0,0,0,0,1,0,-1,0)--arb

		function updatewalkspeed()
			if sprinting then
				walkspeedspring.t=1.4*walkspeedmult*basewalkspeed
			elseif movementmode=="prone" then
				walkspeedspring.t=walkspeedmult*basewalkspeed/4--arb
			elseif movementmode=="crouch" then
				walkspeedspring.t=walkspeedmult*basewalkspeed/2--arb
			elseif movementmode=="stand" then
				walkspeedspring.t=walkspeedmult*basewalkspeed
			end
		end

		local function setmovementmode(self,mode,dive)
			char.movementmode=mode
			movementmode=mode
			if mode=="prone" then
				headheightspring.t=-1.5--arb
				rootjoint.C0=pronecf
				pronespring.t=1
				walkspeedspring.t=walkspeedmult*basewalkspeed/4--arb
				hud:setcrossscale(0.5)
				stability=0.25
				if dive and sprinting and humanoid:GetState()~=Enum.HumanoidStateType.Freefall then
					spawn(function()
						rootpart.Velocity=rootpart.CFrame.lookVector*60+v3(0,40,0)
						wait(.1)
						rootpart.Velocity=rootpart.CFrame.lookVector*70+v3(0,30,0)
						wait(.4)
						rootpart.Velocity=rootpart.CFrame.lookVector*30+v3(0,-10,0)
					end)
				end
			elseif mode=="crouch" then
				headheightspring.t=0--arb
				rootjoint.C0=crouchcf
				pronespring.t=0
				walkspeedspring.t=walkspeedmult*basewalkspeed/2--arb
				hud:setcrossscale(0.75)
				stability=0.15
				if dive and sprinting and humanoid:GetState()~=Enum.HumanoidStateType.Freefall then
					spawn(function()
						for i = 1, 5 do
							rootpart.Velocity = rootpart.CFrame.lookVector*50+v3(0,0,0)
							wait(.08)
						end
					end)
				end
			elseif mode=="stand" then
				headheightspring.t=1.5--arb
				rootjoint.C0=standcf
				pronespring.t=0
				walkspeedspring.t=walkspeedmult*basewalkspeed
				hud:setcrossscale(1)
				stability=0
			end
			network:bounce("stance",player,mode)
			sprinting=false
			network:bounce("sprint",player,sprinting)
			sprintspring.t=0
		end
		
		function char:sprinting()
			return sprinting
		end
		
		char.setmovementmode=setmovementmode

		function char:setbasewalkspeed(newspeed)
			basewalkspeed=newspeed
			updatewalkspeed()
		end

		function char:setsprint(on)
			if on then
				setmovementmode(nil,"stand")
				sprinting=true
				network:bounce("sprint",player,sprinting)
				auto=false
				burst=0
				if weapon and aiming and weapon.type~="KNIFE" then
					weapon:setaim(false)
				end
				walkspeedmult=1
				if not reloading and not animating then
					sprintspring.t=1
				end
				walkspeedspring.t=1.5*walkspeedmult*basewalkspeed--arb
			elseif sprinting then
				sprinting=false
				network:bounce("sprint",player,sprinting)
				sprintspring.t=0
				walkspeedspring.t=walkspeedmult*basewalkspeed
			end
		end
		
		local function parkour()
			if weapon then 
				weapon:playanimation("parkour")
			end
			local bp=new("BodyPosition",rootpart)
			bp.position=rootpart.Position+rootpart.CFrame.lookVector.unit*char.speed/1.5+v3(0,5,0)
			bp.maxForce=v3(5000000, 5000000, 5000000)
			bp.P=4000	
			debris:AddItem(bp,0.45)
		end

		function char:jump(height)
			local rootcf=rootpart.CFrame
			if raycast(workspace,ray(rootcf.p,vtws(rootcf,down)),{workspace.CurrentCamera}) then
				if movementmode=="prone" or movementmode=="crouch" then
					setmovementmode(nil,"stand")
				else
					if not reloading and not aiming and not char.grenadehold then
						local r1=ray(rootpart.CFrame.p+v3(0,1.5,0),rootpart.CFrame.lookVector*25+v3(0,2,0))
						local h1,e1=raycast(workspace,r1,{character,camera.currentcamera})
						
						local r2=ray(rootpart.CFrame.p-v3(0,.8,0),(rootpart.CFrame.lookVector)*25-v3(0,.8,0))
						local h2,e2=raycast(workspace,r2,{character,camera.currentcamera})
						
						local r3=ray(rootpart.CFrame.p-v3(0,1.2,0),(rootpart.CFrame.lookVector)*25-v3(0,1.2,0))
						local h3,e3=raycast(workspace,r3,{character,camera.currentcamera})
					
						if h3 and (e3-e2).Magnitude<0.7 and (e3-e1).Magnitude>4 and (e3-rootpart.Position).Magnitude<char.speed/2 then
							parkour(h3)
						else
							rootpart.Velocity=rootpart.Velocity+v3(0,height and (392.4*height)^0.5 or 40,0)
						end
					else
						rootpart.Velocity=rootpart.Velocity+v3(0,height and (392.4*height)^0.5 or 40,0)
					end		
				end
			end
		end	
	end








	--WEAPONS MODULE LEL

	--Add dynamic animation shit
	--Inspection
	--Spotting
	local equipping	=false
	local zooming	=false
	local rweld
	local lweld
	local larm
	local rarm
	local lmodel
	local rmodel
	local lmain
	local rmain
	local sin		=math.sin
	local cos		=math.cos
	
	char.grenadehold=false	
	local function gunbob(a,r)
		local a,r=a or 1,r or 1
		local d,s,v=char.distance*6.28318*3/4,char.speed,-char.velocity
		local w=v3(r*sin(d/4-1)/256+r*(sin(d/64)-r*v.z/4)/512,r*cos(d/128)/128-r*cos(d/8)/256,r*sin(d/8)/128+r*v.x/1024)*s/20*6.28318
		return cf(r*cos(d/8-1)*s/196,1.25*a*sin(d/4)*s/512,0)*cframe.fromaxisangle(w)
	end
	
	local function gunsway(a)
		local d,s=tick()*6,2*(1.2-a)
		return cf(cos(d/8)*s/128,-sin(d/4)*s/128,sin(d/16)*s/64)
	end

	local function weldattachment(gun,type,attname,menunode,mainpart)
		local refmodel=ffc(attmodels,attname)
		if refmodel then
			local model=refmodel:Clone()			

			local attnode=model.Node
			local weldcframes={}
			local maincf=attnode.CFrame
			local parts=getchildren(model)
			
			for i=1,#parts do
				local v=parts[i]
				if v:IsA("BasePart")then
					weldcframes[v]=tos(maincf,v.CFrame)
				end
			end
			attnode.CFrame=menunode.CFrame
			if type=="Optics" then
				local del=gun:GetChildren()
				for i=1,#del do
					if del[i].Name=="Iron" or (del[i].Name=="SightMark" and not ffc(del[i],"Stay")) then
						del[i]:Destroy()
					end
				end
			end
			for i=1,#parts do
				local v=parts[i]
				if v:IsA("BasePart")then
					if v~=attnode then
						local c0=tos(mainpart.CFrame,attnode.CFrame)
						local weld=new("Weld",mainpart)
						weld.Part0=mainpart
						weld.Part1=v
						weld.C0=c0*weldcframes[v]
					end
					v.Anchored=false
					v.CanCollide=false
					v.Parent=gun
				end
			end
			attnode:Destroy()
			model:Destroy()
		end
	end

	local tos=CFrame.new().toObjectSpace
	local function weldmodel(model,mainpart,attachlist,data)
		local welddata={}
		local parts=model:GetChildren()
		local maincf=mainpart.CFrame
		local menunodes=ffc(model,"MenuNodes")
		for i=1,#parts do
			local part=parts[i]
			if part~=mainpart and part:IsA("BasePart") then
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
				part.Anchored=false
				part.CanCollide=false
			end
		end
		if menunodes then
			local nodes=menunodes:GetChildren()
			for i=1,#nodes do
				local v=nodes[i]
				local c0=tos(maincf,v.CFrame)
				local weld=new("Weld",mainpart)
				weld.Part0=mainpart
				weld.Part1=v
				weld.C0=c0
				v.Anchored=false
				v.CanCollide=false
			end
			for i,v in next,attachlist do
				if i~="Name" and v and v~="" then
					local attachdata		=data.attachments and data.attachments[i][v] or {}
					local sidemount			=attachdata.sidemount and attmodels[attachdata.sidemount]:Clone()
					local mountweldpart		=attachdata.mountweldpart and model[attachdata.mountweldpart] or mainpart
					local node				=attachdata.node and menunodes[attachdata.node]

					if sidemount then
						local basenode			=sidemount["Node"]
						local mountnode			=attachdata.mountnode and menunodes[attachdata.mountnode] or i=="Optics" and menunodes["MountNode"] or i=="Underbarrel" and menunodes["UnderMountNode"]
						local mountcframes		={}
						local mchildren			=sidemount:GetChildren()
						local basecframe		=basenode.CFrame
						for i=1,#mchildren do
							if mchildren[i]:IsA("BasePart") then
								mountcframes[i]=tos(basecframe,mchildren[i].CFrame)
							end
						end
						basenode.CFrame=mountnode.CFrame
						for x=1,#mchildren do
							local p=mchildren[x]
							if p:IsA("BasePart")then
								local c0=tos(mountweldpart.CFrame,basenode.CFrame)
								if p~=basenode then
									local weld=new("Weld",mainpart)
									weld.Part0=mountweldpart
									weld.Part1=p
									weld.C0=c0*mountcframes[x]
									p.CFrame=basenode.CFrame*mountcframes[x]
								end
								p.Anchored=false
								p.CanCollide=false
								p.Parent=model
								if p.Name==i.."Node" and not node then
									node=p
								elseif p.Name=="SightMark" then
									local stay=new("Model",p)
									stay.Name="Stay"
								end
							end
						end
						basenode.Parent=menunodes
						sidemount:Destroy()
					else
						node=attachdata.node and menunodes[attachdata.node] or menunodes[i.."Node"]
					end
					local weldpart=attachdata.weldpart and model[attachdata.weldpart] or mainpart
					weldattachment(model,i,v,node,weldpart)
				end
			end
			menunodes:Destroy()
		end
		mainpart.Anchored=false
		mainpart.CanCollide=false
		return welddata
	end

	local clone			=game.Clone
	local currentcamera	=game.Workspace.CurrentCamera
	local ffc			=game.FindFirstChild
	
	function char:loadarms(newlarm,newrarm,newlmain,newrmain)
		currentcamera=game.Workspace.CurrentCamera
		larm,rarm,lmain,rmain=newlarm,newrarm,newlmain,newrmain
		lmodel=clone(larm,weapon and currentcamera)
		rmodel=clone(rarm,weapon and currentcamera)
		local lmainpart=lmodel[newlmain]
		local rmainpart=rmodel[newrmain]
		rweld=new("Motor6D")
		lweld=new("Motor6D")
		weldmodel(lmodel,lmainpart)
		weldmodel(rmodel,rmainpart)
		lweld.Part0=rootpart
		lweld.Part1=lmainpart
		lweld.Parent=lmainpart
		rweld.Part0=rootpart
		rweld.Part1=rmainpart
		rweld.Parent=rmainpart
	end
	
	function char:reloadsprings()
		sprintspring			=physics.spring.new()
		aimspring				=physics.spring.new()
		swingspring				=physics.spring.new(nv)
		speedspring				=physics.spring.new()
		velocityspring			=physics.spring.new(nv)
		pronespring				=physics.spring.new(0)
		truespeedspring			=physics.spring.new(0)
		equipspring				=physics.spring.new(1)
		muzzlespring			=physics.spring.new(0)

		equipspring.s			=12--arb
		equipspring.d			=0.75--arb
	
		sprintspring.s			=12
		sprintspring.d			=0.9
		aimspring.d				=0.9
		swingspring.s			=10
		swingspring.d			=0.75
		speedspring.s			=16
		velocityspring.s		=16
		pronespring.s			=8
		truespeedspring.s		=8
		
		muzzlespring.s			=50
		muzzlespring.d			=1
	
		walkspeedspring			=physics.spring.new(basewalkspeed)
		walkspeedspring.s		=8--arb
		headheightspring		=physics.spring.new(1.5)
		headheightspring.s		=8--arb 

		if muzzlelight then muzzlelight:Destroy() end
		muzzlelight				=repstore.Effects.MuzzleLight:Clone()
		muzzlelight.Parent		=rootpart

	end

	--BULLSHIT BULLSHIT
	local aimbotshit={}

	do
		local function reweld(welddata)
			for i,v in next,welddata do
				if v.clone then
					welddata[i]=nil
					trash.remove(v.weld)
					trash.remove(v.part)
				else
					v.weld.C0=v.basec0
					if v.part then
						v.part.Transparency=v.basetransparency
					end
				end
			end
		end

		local rand=math.random
		local ffc=game.FindFirstChild
		local function pickv3(v0,v1)
			return v0+v3(rand(),rand(),rand())*(v1-v0)
		end

		function char:firemuzzlelight()
			muzzlespring:accelerate(100)
		end
		
		function char:loadgrenade(data,model,spare)
			local self				={}
			--network:bounce("load",player,data.name)
			local thread2			=sequencer.new()
			local ignorelist		=ignore
			local dunhit			={}
			--General things I guess.
			local main				=data.mainpart
			local mainoffset		=data.mainoffset
			local mainpart			=model[main]
			local pin				=model[data.pin]
			local lever				=model[data.lever]
			local ammo				=spare or data.spare
			
			local lastweapon		=weapon
			local equipped			=false
			local throwing			=false
			local cooking			=false
			local exploded			=false
			
			local bounceelasticity	=0.2
			local acceleration		=v3(0,-80,0)
			local velocity			=v3()
			local position			=v3()
			
			local cooktime			=0
			local blowup			=0
			local t0				=0
			local lastbounce		=false
			local lasttrailt		=0
			local lasttrailpos		=v3()		
			local rot0
			local offset			=v3()
			local av0				
			local flyingnade
			local indicator

			--grenade explode stuff
			local fusetime			=data.fusetime
			local blastradius		=data.blastradius
			local throwspeed		=data.throwspeed
			local r0,r1,d0,d1		=data.range0,data.range1,data.damage0,data.damage1

			--Static animation data stuff
			local animdata			=weldmodel(model,mainpart)
			local mainweld			=new("Motor6D",mainpart)
			animdata[main]			={weld={C0=nc},basec0=nc}
			animdata.larm			={weld={C0=data.larmoffset},basec0=data.larmoffset}
			animdata.rarm			={weld={C0=data.rarmoffset},basec0=data.rarmoffset}

			mainweld.Part0			=rootpart
			mainweld.Part1			=mainpart
			
			--Dynamic animation stuff OMG prepare for flood
			local equipcf			=data.equipoffset
			local sprintcf			=cframe.interpolator(data.sprintoffset)
			local pronecf			=cframe.interpolator(data.proneoffset)
			
			self.type				=data.type
			self.cooking			=cooking
			
			function self:setequipped(on)
				if on and (not equipped or not equipping) then
					if char.health<=0 then return end
					aimbotshit.speed=throwspeed
					aimbotshit.accel=acceleration
					aimbotshit.addv=true
					char.grenadehold=true
					hud:setcrosssettings(data.crosssize,data.crossspeed,data.crossdamper,main)
					hud:updatefiremode("KNIFE")
					hud:updateammo("GRENADE")
					equipping=true
					thread:clear()
					if weapon then
						lastweapon=weapon
						weapon:setequipped(false)
					end
					thread:add(function()
						char:setbasewalkspeed(data.walkspeed)
						equipspring.t=0
						equipping=false
						equipped=true
						local shit=mainpart:GetChildren()
						for i=1,#shit do
							if shit[i]:IsA("Weld") and (not shit[i].Part1 or shit[i].Part1.Parent~=model) then
								shit[i]:Destroy()
							end
						end
						lmodel.Parent=currentcamera
						rmodel.Parent=currentcamera
						model.Parent=currentcamera
						weapon=self
						--reweld(animdata)
						--if sprinting then char:setsprint(false) end
					end)
				elseif not on and equipped then
					--Set equipped to false here?
					equipspring.t=1
					thread:clear()--I don't think this should be here.
					thread:add(function()
						equipped=false
						lmodel.Parent=nil
						rmodel.Parent=nil
						model.Parent=nil
						animating=false
						weapon=nil
					end)
					thread:delay(0.5)--arb
				end
			end
			
			local function createnade()
				---need to add network cloning fake nade
				if roundsystem.lock or not mainpart.Parent or gamelogic.gammo<=0 then return end
				gamelogic.gammo=gamelogic.gammo-1
				hud:updateammo("GRENADE")
				local time=tick()
				trash.remove(mainweld)
				flyingnade=mainpart
				flyingnade.Parent=workspace.Ignore
				flyingnade.Anchored=true
				indicator=ffc(flyingnade,"Indicator")
				if indicator then
					indicator.Friendly.Visible=true
				end
				model.Parent=nil
				velocity=char.health>0 and camera.lookvector*throwspeed+rootpart.Velocity or v3()
				position=char.deadcf and char.deadcf.p or flyingnade.CFrame.p				
				
				lasttrailt=time
				lasttrailpos=position	
				t0=time
				av0=(camera.cframe-camera.cframe.p)*v3(19.539,-5.0,0)
				rot0=flyingnade.CFrame-flyingnade.CFrame.p
				
				network:bounce("newgrenade",player,data.name,position,velocity,acceleration,bounceelasticity,t0,av0,rot0,blowup-tick())
				
			end
							
			function self:throw(dpos)
				---do grenade stuff
				if roundsystem.lock or gamelogic.gammo<= 0 then return end
				if cooking and not throwing then
					local time=tick()
					throwing=true
					cooking=false
					self.cooking=cooking
					exploded=false					
					sprintspring.t=0
					thread:add(animation.player(animdata,data.animations.throw))
					thread2:delay(0.07)
					thread2:add(function() 
						createnade(dpos)
						if sprinting then sprintspring.t=1 end
						throwing=false
					end)
					thread:add(function()
						if lastweapon then
							lastweapon:setequipped(true)
						end
					end)
				end
			end
		
			function self:pull()
				local time=tick()
				if not cooking and not throwing then
					if animating then
						thread:add(animation.reset(animdata,0.1))
						animating=false
					end
					thread:add(animation.player(animdata,data.animations.pull))
					thread:add(function()
						hud.crossspring:accelerate(data.crossexpansion)
						trash.remove(pin)
						cooking=true
						self.cooking=cooking
						cooktime=time+fusetime
						blowup=time+5
					end)
				end
			end
		
			local function hitdetection(hit,dist) --- frag damage
				---damage code
				if hit.Parent and ffc(game.Players,hit.Parent.Name) and not dunhit[hit.Parent] and ffc(game.Players,hit.Parent.Name) then 
					local p=game.Players:GetPlayerFromCharacter(hit.Parent)
					if p.TeamColor~=player.TeamColor or p==player then
						local wall,pos=raycast(workspace,ray(hit.Position,(hit.Position-position).unit*-dist),ignorelist)
						if not wall then
							effects:bloodhit(position,hit,hit.Position,hit.CFrame.lookVector)
							local damage=dist<r0 and d0 or dist<r1 and (d1-d0)/(r1-r0)*(dist-r0)+d0 or d1
							--print("damage : " ..damage.. "  dist : " ..dist.. "   wall : ",wall)
							--[==[antihack]==]network:send('c'..'h'..'a'..'n'..'g'..'e'..'h'..'e'..'a'..'l'..'t'..'h'..'x',p,player,tick(),-damage,player,data.name,hit,position)
							hud:changehealthlocally(player,-damage)
							--network:send("changehealth",p,-damage,player,data.name,hit,position)
							dunhit[hit.Parent]=true
							hud:firehitmarker()
						end
					end
				end
			end
			
			local function explode()
				if ffc(flyingnade,"Fire") then
					flyingnade.Fire:Play() 
				end
				exploded=true
				trash.remove(flyingnade)
				dunhit={}
				if data.grenadetype=="Frag" then
					---need to add network stuff later
					local boom=new("Explosion",workspace)
					boom.Position=position
					boom.BlastRadius=blastradius
					boom.BlastPressure=0
					boom.DestroyJointRadiusPercent=0
					boom.Hit:connect(function(hit,dist)
						hitdetection(hit,dist)
					end)
				elseif data.grenadetype=="Smoke" then
					--- smoke
				elseif data.grenadetype=="Flash" then
					--- blind
				elseif data.grenadetype=="Flare" then
					--- signal
				elseif data.grenadetype=="Throwing" then
					--- flying knives wat
				end
			end
			
				
			
			run.onstep:connect(function(dt)
				thread2.step()
				local time=tick()
				
				--cooking stuff
				if cooking and not throwing then
					if cooktime<time or not input.keyboard.down["g"] then
						self:throw()
					elseif (cooktime-time)%1<0.03 then
						hud.crossspring:accelerate(data.crossexpansion)
					end
				end				
				
				--grenade throwing physics
				if flyingnade and not exploded then
					if time<blowup then
						local newvelocity=velocity+dt*acceleration
						local newposition=position+dt*velocity
						local hit,pos,norm=raycast(workspace,ray(position,newposition-position),ignorelist)
						local check,_,_=raycast(workspace,ray(position,camera.cframe.p-position),ignorelist)
						local t=tick()-t0
	
						if indicator then
							indicator.Enabled=not check
						end

						if hit and hit.Name~="Window" then
							rot0=flyingnade.CFrame-flyingnade.CFrame.p
							offset=0.2*norm
							t0=tick()
							av0=norm:Cross(velocity)/0.2
							position=pos+norm*0.001
							local normvel=dot(norm,velocity)*norm
							local tanvel=velocity-normvel
							local friction
							if lastbounce then
								friction=1-0.08*acceleration.magnitude*dt/tanvel.magnitude
							else
								friction=1-0.08*(acceleration.magnitude+(1+bounceelasticity)*normvel.magnitude)/tanvel.magnitude
							end
							velocity=tanvel*(friction<0 and 0 or friction)-bounceelasticity*normvel
							lastbounce=true
						else
							position=newposition
							velocity=newvelocity
							lastbounce=false
							if hit and hit.Name=="Window" then
								effects:breakwindow(hit,pos,norm,true)
							end
						end
						if lasttrailt+0.05<time and (lasttrailpos-position).magnitude>1 then
							local trail=new("Part",workspace.Ignore)
							trail.BrickColor=BrickColor.new("Medium stone grey")
							trail.Transparency=0.7
							trail.Anchored=true
							trail.CanCollide=false
							trail.FormFactor="Custom"
							trail.Size=v3(0.2,0.2,0.2)
							trail.CFrame=cf((lasttrailpos+position)*0.5,position)
							local mesh=new("BlockMesh",trail)
							mesh.Scale=v3(0.6,0.6,(lasttrailpos-position).Magnitude*5)
							debris:AddItem(trail,1)
							lasttrailpos=position
							lasttrailt=time
						end
						flyingnade.CFrame=cf(position+offset)*cframe.fromaxisangle(t*av0)*rot0
					else
						explode()
					end
				end
			
			end)

			function self.step()
				--Animate grenade arms
				local mainweldc0=rootpart.CFrame:inverse()
					*camera.shakecframe
					*mainoffset*animdata[main].weld.C0
					--*breathing()
					*pronecf(pronespring.p)
					--*cf(-velocityspring.v/8192)
					*cf(0,0,1)*cframe.fromaxisangle(swingspring.v)*cf(0,0,-1)
					*gunbob(0.7,1)
					*gunsway(0)
					*cframe.interpolate(sprintcf(truespeedspring.p/walkspeedspring.p*sprintspring.p),data.equipoffset,equipspring.p)
				mainweld.C0=mainweldc0
				--Animate arms
				lweld.C0=mainweldc0*animdata.larm.weld.C0
				rweld.C0=mainweldc0*animdata.rarm.weld.C0
				if char.health<=0 then
					self:setequipped(false)
				end
			end
			
			return self
		end		
		
		function char:loadknife(data,model)
			local self={}
			self.type				=data.type
			--network:bounce("load",player,data.name)
			local thread2			=sequencer.new()--LOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOL
			local ignorelist		={camera.currentcamera,character,workspace.Ignore}
			local dunhit			={}
			--General things I guess.
			local main				=data.mainpart
			local mainoffset		=data.mainoffset
			local mainpart			=model[main]
			local tip				=model[data.tip]
			local equipped			=false
			local knifing			=false
			local nexthit			=0
			
			--stab stuff
			local stabrate			=1000
			local r0,r1,d0,d1		=data.range0,data.range1,data.damage0,data.damage1

			--Static animation data stuff
			local animdata			=weldmodel(model,mainpart)
			local mainweld			=new("Motor6D",mainpart)
			animdata[main]			={weld={C0=nc},basec0=nc}
			animdata.larm			={weld={C0=data.larmoffset},basec0=data.larmoffset}
			animdata.rarm			={weld={C0=data.rarmoffset},basec0=data.rarmoffset}

			mainweld.Part0			=rootpart
			mainweld.Part1			=mainpart
			
			--Dynamic animation stuff OMG prepare for flood
			local equipcf			=data.equipoffset
			local sprintcf			=cframe.interpolator(data.sprintoffset)
			local pronecf			=cframe.interpolator(data.proneoffset)
			
			local inspecting

			function self:destroy()
				lmodel:Destroy()
				rmodel:Destroy()
				model:Destroy()
			end
				
			function self:setequipped(on,quick)
				if on and (not equipped or not equipping) then
					if char.health<=0 then return end
					network:bounce("equipknife",player,data.name)
					hud:setcrosssettings(data.crosssize,data.crossspeed,data.crossdamper,main)
					hud:updatefiremode("KNIFE")
					hud:updateammo("KNIFE")
					equipping=true
					thread:clear()
					if weapon then
						weapon:setequipped(false)
					end
					thread:add(function()
						char:setbasewalkspeed(data.walkspeed)
						sprintspring.s=data.sprintspeed
						hud:setcrosssize(data.crosssize)
						local shit=mainpart:GetChildren()
						for i=1,#shit do
							if shit[i]:IsA("Weld") and (not shit[i].Part1 or shit[i].Part1.Parent~=model) then
								shit[i]:Destroy()
							end
						end
						lmodel.Parent=currentcamera
						rmodel.Parent=currentcamera
						equipspring.s=16
						equipspring.t=0
						--reweld(animdata)
						equipped=true
						weapon=self
						model.Parent=currentcamera
						equipping=false
						knifing=false
						char.grenadehold=false
						if sprinting then sprintspring.t=1 end
					end)
					if quick then
						thread:delay(0.1)
						thread:add(function()
							self:shoot(quick)
						end)
					end
				elseif not on and equipped then
					--Set equipped to false here?
					knifing=false
					equipspring.t=1
					thread:clear()--I don't think this should be here.
					thread:add(animation.reset(animdata,0.2))--arb
					thread:add(function()
						equipped=false
						lmodel.Parent=nil
						rmodel.Parent=nil
						model.Parent=nil
						animating=false
						weapon=nil
					end)
				end
			end
					
			function self:playanimation(type)---knife
				if not knifing and not equipping then
					thread:clear()
					if animating then
						thread:add(animation.reset(animdata,0.05))
					end
					
					animating=true
					sprintspring.t=0
					local acceptlist={}
					if type=="inspect" then
						inspecting=true
					elseif type=="spot" then
						local pp=game.Players:GetChildren()
						for i=1,#pp do
							local v=pp[i]
							if v.TeamColor~=player.TeamColor and v.Character then
								local head=ffc(v.Character,"Head")
								if head and hud:getplayervisible(v) then
									local v1=(head.Position-camera.cframe.p).unit
									local v2=camera.lookvector
									if v1:Dot(v2)>0.975 then
										acceptlist[#acceptlist+1]=v
										hud:firespot(v)
									end
								end
							end
						end
					end

					thread:add(animation.player(animdata,data.animations[type]))
					thread:add(function()
						thread:add(animation.reset(animdata,data.animations[type].resettime))
						animating=false
						thread:add(function() 
							if sprinting then sprintspring.t=1 end 
							inspecting=false
						end)
						if #acceptlist>0 then
							--[==[antihack]==]network:send('s'..'p'..'o'..'t'..'t'..'i'..'n'..'g',player,acceptlist)
							--network:send("spotting",player,acceptlist)
						end
					end)
					return #acceptlist>0
				end
			end

			function self:reloadcancel(inspect)
				if inspect then
					thread:clear()
					thread:add(animation.reset(animdata,0.2))
					reloading=false
					animating=false
					thread:add(function() 
						if input.mouse.down["right"] then self:setaim(true) end 
						if sprinting then sprintspring.t=1 end 
					end)	
				end
			end
		
			function self:shoot(quick,type)
				---do knife stuff
				if roundsystem.lock then return end
				if inspecting then self:reloadcancel(true) inspecting=false end
				if not knifing then
					local time=tick()
					network:bounce("stab",player)
					nexthit=nexthit>time and nexthit or time
					sprintspring.t=0
					knifing=true
					if animating then
						thread:add(animation.reset(animdata,0.1))
						animating=false
					end
					type=type or "stab1"
					thread:add(animation.player(animdata,data.animations[type]))
					thread:add(function()
						thread:add(animation.reset(animdata,data.animations[type].resettime))
						if sprinting then sprintspring.t=1 end
						knifing=false
						dunhit={}
					end)
					
				end
			end
			
			local function hitdetection(hit,pos,norm) 
				---damage code
				if ffc(game.Players,hit.Parent.Name) and ffc(hit.Parent,"Torso") and not dunhit[hit.Parent] and ffc(game.Players,hit.Parent.Name) then 
					local p=game.Players:GetPlayerFromCharacter(hit.Parent)
					if p.TeamColor~=player.TeamColor then
						effects:bloodhit(rootpart.Position,hit,pos,norm)	
						local ptorso=hit.Parent.Torso
						local damage=(dot(ptorso.CFrame.lookVector,(ptorso.Position-rootpart.Position).unit)*0.5+0.5)*(d1-d0)+d0
						--print("damage : " ..damage)
						--[==[antihack]==]network:send('c'..'h'..'a'..'n'..'g'..'e'..'h'..'e'..'a'..'l'..'t'..'h'..'x',p,player,tick(),-damage,player,data.name,hit,mainpart.Position)
						hud:changehealthlocally(player,-damage)
						--network:send("changehealth",p,-damage,player,data.name,hit,mainpart.Position)
						dunhit[hit.Parent]=true
						hud:firehitmarker()
					end
				else
					if hit.Name=="Window" then
						effects:breakwindow(hit,pos,norm)
					else
						effects:bullethit(hit,pos,norm,true)
					end
				end
			end
			
			function self.step()
				local time=tick()
				--knife hit detection
				if knifing and time>=nexthit then
					local scan=ray(tip.CFrame.p,tip.CFrame.lookVector*5)
					local hit,pos,norm=raycast(workspace,scan,ignorelist)
					if hit then
						hitdetection(hit,pos,norm)						
					end
					nexthit=nexthit+60/stabrate
				end
				--Animate gun
				local mainweldc0=rootpart.CFrame:inverse()
					*camera.shakecframe
					*mainoffset*animdata[main].weld.C0
					--*breathing()
					*pronecf(pronespring.p)
					--*cf(-velocityspring.v/8192)
					*cf(0,0,1)*cframe.fromaxisangle(swingspring.v)*cf(0,0,-1)
					*gunbob(0.7,1)
					*gunsway(0)
					*cframe.interpolate(sprintcf(truespeedspring.p/walkspeedspring.p*sprintspring.p),data.equipoffset,equipspring.p)
				mainweld.C0=mainweldc0
				--Animate arms
				lweld.C0=mainweldc0*cframe.interpolate(animdata.larm.weld.C0,data.larmsprintoffset,truespeedspring.p/walkspeedspring.p*sprintspring.p)
				rweld.C0=mainweldc0*cframe.interpolate(animdata.rarm.weld.C0,data.rarmsprintoffset,truespeedspring.p/walkspeedspring.p*sprintspring.p)
				thread2:step()
				if char.health<=0 then
					self:setequipped(false)
				end
			end
			
			return self
		end

		function datatype(data)
			if type(data)~="userdata" then 
				return type(data)
			else
				if pcall(function() data:Dot(v3()) end) then return "Vector3" end
				if pcall(function() data.components() end) then return "CFrame" end
			end
			return "Other"
		end

		function char:loadgun(data,attachinfo,model,sparemag,sparerounds,attachlist)
			local self				={}
			self.data				=data
			self.attachments		=attachlist
			self.modlist			={}
			
			--- Modify stats

			local function updatestats(type,selected)
				if data.attachments then

					local function generatetable(list)
						local newtable={}
						for i,v in next,list do
							newtable[i]=v
						end
						return newtable
					end	

					---local newdata=data.attachments[type][selected]
					
					local datalist				={}
					datalist.newdata			=generatetable(attachinfo[selected].stats or {})	--- loading generic attach data	
					datalist.overwrite			=generatetable(data.attachments[type][selected]	or {})	--- loading gun attach stats
					datalist.multiplier			=generatetable(attachinfo[selected].mods or {})

					--- begin the horrible hard sht *shit
					for i,v in next,datalist.multiplier do
						if not data[i] then 
							print(selected.." has data error named " ..i)
						else
							datalist.newdata[i]=data[i]*v
						end
					end

					for i,v in next,datalist.overwrite do
						datalist.newdata[i]=v
						--print("STAT CHANGES : ", datalist.newdata, "  value : ",v)
					end
					--- hopefuly we did it correctly *Hopefully


					if not datalist.newdata then return end
					for i,v in next,datalist.newdata do
						--print(i,data[i], "   TO  ",v)
						local vtype=datatype(v)
						if datatype(data[i])==vtype and (vtype=="Vector3" or vtype=="number") then
							self.modlist[#self.modlist+1]={i,v-data[i]}
						else
							data[i]=v
						end
					end
				end
			end
			---

			if attachlist then
				for i,v in next,attachlist do
					if i~="Name" and v~="" then
						updatestats(i,v)
					end
				end
			end

			for i=1,#self.modlist do
				local v=self.modlist[i]
				data[v[1]]=data[v[1]]+v[2]
				--print(v[1],data[v[1]],"modified by",v[2])
			end

			self.type				=data.type
			self.ammotype			=data.ammotype
			self.name				=data.name
			self.magsize			=data.magsize
			self.sparerounds		=data.sparerounds
			self.blackscope			=data.blackscope
			self.attachdata			=attachlist

			--network:bounce("load",player,data.name)
			local thread2			=sequencer.new()--LOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOL
			--General things I guess.
			local main				=data.mainpart
			local mainoffset		=data.mainoffset
			local mainpart			=model[main]
			local equipped			=false
			local yieldtoanimation	=false
			local barreloffset		=data.barreloffset
			local animdata			=weldmodel(model,mainpart,attachlist,data)
			--shooting stuff
			local firerate			=data.variablefirerate and data.firerate[1] or data.firerate
			local firemodes			=data.firemodes
			local firemode			=1			
			local spare				=sparerounds or data.sparerounds
			local chamber			=data.chamber
			local magsize			=data.magsize
			local mag				=sparemag and sparemag or chamber and mag and mag+1 or mag or magsize
			local nextshot			=0
			local r0,r1,d0,d1		=data.range0,data.range1,data.damage0,data.damage1
		

			local firesoundlist		={}

			--Static animation data stuff
			
			local mainweld			=new("Motor6D",mainpart)
			animdata[main]			={weld={C0=nc},basec0=nc}
			animdata.larm			={weld={C0=data.larmoffset},basec0=data.larmoffset}
			animdata.rarm			={weld={C0=data.rarmoffset},basec0=data.rarmoffset}

			local barrel			=model[data.barrel]
			local sight				=model[data.sight]
			local altsight			=data.altsight and model[data.altsight]
			local firesound			=barrel.Fire--fix
			local hideflash			=data.hideflash
			local hideminimap		=data.hideminimap
			local hiderange			=data.hiderange or 50

			firesound.SoundId		=data.firesoundid
			firesound.Pitch			=data.firepitch
			firesound.Volume		=data.firevolume

			--Dynamic animation stuff OMG prepare for flood
			local equipcf			=data.equipoffset
			local sprintcf			=cframe.interpolator(data.sprintoffset)
			local pronecf			=cframe.interpolator(data.proneoffset)
			local boltcf			=cframe.interpolator(animdata[data.bolt].basec0,animdata[data.bolt].basec0*data.boltoffset)
			local transkickspring	=physics.spring.new(nv)
			local rotkickspring		=physics.spring.new(nv)
			local spreadspring		=physics.spring.new(nv)
			local altaimspring		=physics.spring.new()
			local armaimspring		=physics.spring.new()
			transkickspring.s		=data.modelkickspeed
			rotkickspring.s			=data.modelkickspeed
			transkickspring.d		=data.modelkickdamper
			rotkickspring.d			=data.modelkickdamper
			spreadspring.s			=data.hipfirespreadrecover
			spreadspring.d			=data.hipfirestability or 0.7
			altaimspring.s			=16
			altaimspring.d			=0.8
			armaimspring.s			=16
			armaimspring.d			=0.95
			--States
			local inspecting
			local firemodestability	=0
			local sightmode			=0
			local cursight			=sight
			local chambered			=true
			local bolting

			function self:destroy()
				self:hide(true)
			end
			
			function self:setequipped(on,dead)
				if dead then self:hide() end
				if on and (not equipped or not equipping) then
					if char.health<=0 then return end
					if not menu:isdeployed() then print("yes") return end
					aimbotshit.speed=data.bulletspeed
					aimbotshit.accel=lolgravity
					aimbotshit.addv=false
					network:bounce("equip",player,data.name)
					hud:setcrosssettings(data.crosssize,data.crossspeed,data.crossdamper,cursight)
					hud:updatefiremode(firemodes[firemode])
					hud:updateammo(mag,spare)
					firemodestability=(firemodes[firemode]==3) and 0.2 or firemodes[firemode]==2 and 0.3 or 0
					self:setaim(false)
					equipping=true
					reloading=false
					chambered=true
					bolting=false
					thread:clear()
					if weapon then
						weapon:setequipped(false)
					end
					thread:add(function()
						if data.scopeid then
							hud:setscopeid(data.scopeid)
						end
						char:setbasewalkspeed(data.walkspeed)
						sprintspring.s=data.sprintspeed
						camera.magspring.s=data.magnifyspeed
						camera.shakespring.s=data.camkickspeed
						hud:setcrosssize(data.crosssize)
						aimspring.s=data.aimspeed
						armaimspring.s=data.aimspeed
					
						equipspring.s=data.equipspeed or 12
						equipspring.t=0

						local shit=mainpart:GetChildren()
						for i=1,#shit do
							if shit[i]:IsA("Weld") and (not shit[i].Part1 or shit[i].Part1.Parent~=model) then
								shit[i]:Destroy()
							end
						end
						if model then
							pcall(function()
								lmodel.Parent=currentcamera---all of this
								rmodel.Parent=currentcamera---all of this
								model.Parent=currentcamera--- all of this
							end)
						end
		
						mainweld.Part0=rootpart
						mainweld.Part1=mainpart

						equipped=true
						equipping=false
						if sprinting then
							sprintspring.t=1
						end
						if input.mouse.down["right"] then
							self:setaim(true)
						end
						weapon=self
						char.grenadehold=false
					end)
				elseif not on and equipped then
					--Set equipped to false here?
					if aiming then
						self:setaim(false)
					end
					auto=false
					burst=0
					reloading=false
					equipspring.t=1
					thread:clear()--I don't think this should be here.
					thread:add(animation.reset(animdata,0.2))--arb
					thread:add(function()
						equipped=false
						lmodel.Parent=nil
						rmodel.Parent=nil
						mainweld.Part1=nil
						if dead then 
							model:Destroy() 
						else
							model.Parent=nil
						end
						animating=false
						yieldtoanimation=false
						weapon=nil
					end)
				end
			end
			
			local function texturetransparency(part,trans)
				local p=part:GetChildren()
				for i=1,#p do
					local v=p[i]
					if v.Name == "Texture" then
						v.Transparency = trans
					end
				end
			end

			function self:toggleattachment()
				if altsight and (not aiming or aiming and data.blackscope==data.altblackscope) then
					if sightmode==0 then
						sightmode=1
						aimspring.s=data.altaimspeed
						cursight=altsight
						self.blackscope=data.altblackscope
					else
						sightmode=0
						aimspring.s=data.aimspeed
						cursight=sight
						self.blackscope=data.blackscope
					end
					altaimspring.t=sightmode
					if aiming then
						camera:magnify(sightmode==0 and data.zoom or data.altzoom)
					end
					hud:updatesightmark(cursight)
				end
			end
			
			function self:hide(delete)
				if delete then
					model:Destroy()
					lmodel:Destroy()
					rmodel:Destroy()
				else
					local p=model:GetChildren()
					for i=1,#p do
						local v=p[i]
						if v:IsA("UnionOperation") then
							v.Transparency=1
							if ffc(v,"Texture") then
								--texturetransparency(v,1)
							end
						end
					end
				end
			end
			
			function self:show()
				local p=model:GetChildren()
				for i=1,#p do
					local v=p[i]
					if v:IsA("UnionOperation") then
						v.Transparency=0
						if ffc(v,"Texture") then
							--texturetransparency(v,0)
						end
					end
				end
			end
			
			function self:setaim(on,console)
				if reloading or not equipped then return end
				if on then
					--[[if animating and not yieldtoanimation then
						thread:clear()
						thread:add(animation.reset(animdata,0.5))
					end]]
					aiming=true
					network:bounce("aim",player,true)
					sprinting=false
					sprintspring.t=0
					network:bounce("sprint",player,sprinting)
					walkspeedmult=sightmode==0 and data.aimwalkspeedmult or data.altaimwalkspeedmult
					camera.shakespring.s=data.aimcamkickspeed
					camera:setaimsensitivity(true)
					hud:setcrosssize(0)
					
					if self.blackscope then --- change later for scope attachments
						thread2:add(function()
							camera:magnify(data.zoom*0.4)
						end)
						thread2:delay(4/data.aimspeed)
						thread2:add(function()
							if aiming then
								hud:setscope(true,console)
								self:hide()
								camera.magspring.s=100
								camera:magnify(sightmode==0 and data.zoom or data.altzoom)
							end
						end)
					else
						camera:magnify(sightmode==0 and data.zoom or data.altzoom)
					end
					aimspring.t=1
					armaimspring.t=1
				elseif not on then
					if aiming and self.blackscope then
						thread2:clear()
					end
					aiming=false
					network:bounce("aim",player,false)
					hud:setcrosssize(data.crosssize)
					camera.shakespring.s=data.camkickspeed
					walkspeedmult=1
					camera:setaimsensitivity(false)
					aimspring.t=0
					armaimspring.t=0
					if self.blackscope then --- change later for scope attachments
						thread2:add(function()
							camera:magnify(data.zoom*0.3)
							hud:setscope(false)
							self:show()
						end)
						thread2:delay(0.05)
						thread2:add(function()
							if not aiming then
								camera.magspring.s=data.magnifyspeed
								camera:magnify(1)
								camera:setsway(0)
								hud:setsteadybar(ud2(0,0,1,0))
								if mag==0 and spare>0 then 
									self:reload()
								end
							end
						end)
					else
						camera:magnify(1)
						thread2:delay(0.05)
						thread2:add(function()
							if not aiming then
								if mag==0 and spare>0 and not reloading then 
									self:reload()
								end
							end
						end)
					end
					if not chambered and not bolting and data.animations.onfire and data.pullout then
						animating=true
						yieldtoanimation=true
						bolting=true
						thread:add(animation.player(animdata,data.animations.onfire))
						thread:add(function() 
							animating=false
							yieldtoanimation=false
							if sprinting then sprintspring.t=1 end
							chambered=true
							bolting=false
						end)	
					end
					if not self.blackscope then char:setsprint(input.keyboard.down.leftshift) end
				end
				updatewalkspeed()
			end

			function self:playanimation(type)--- gun
				if not reloading and not equipping and not yieldtoanimation then
					thread:clear()
					if animating then
						thread:add(animation.reset(animdata,0.05))
					end
					if aiming then
						self:setaim(false)
					end
					animating=true
					sprintspring.t=0

					local acceptlist={}
					if type=="inspect" then
						inspecting=true
					elseif type=="spot" then
						--[[local pp=game.Players:GetChildren()
						for i=1,#pp do
							local v=pp[i]
							if v.TeamColor~=player.TeamColor and hud:getplayervisible(v) then
								acceptlist[#acceptlist+1]=v
								hud:firespot(v)
							end
						end]]
					end

					thread:add(animation.player(animdata,data.animations[type]))
					thread:add(function()
						thread:add(animation.reset(animdata,data.animations[type].resettime))
						thread:add(function() 
							inspecting=false
							if reloading then return end
							if input.mouse.down["right"] and not aiming then self:setaim(true) end 
							if sprinting then sprintspring.t=1 end
							animating=false
						end)	
						
						if type=="spot" then
							local acceptlist={}
							local pp=game.Players:GetChildren()
							for i=1,#pp do
								local v=pp[i]
								if v.TeamColor~=player.TeamColor and v.Character then
									local head=ffc(v.Character,"Head")
									if head and hud:getplayervisible(v) then
										local v1=(head.Position-camera.cframe.p).unit
										local v2=camera.lookvector
										if v1:Dot(v2)>0.975 then
											acceptlist[#acceptlist+1]=v
											hud:firespot(v)
										end
									end
								end
							end
							if #acceptlist>0 then
								--[==[antihack]==]network:send('s'..'p'..'o'..'t'..'t'..'i'..'n'..'g',player,acceptlist)
								--network:send("spotting",player,acceptlist)
							end
						end
						
					end)
					return #acceptlist>0
				end
			end

			function self:dropguninfo()
				return mag,spare,mainpart.Position
			end
	
			function self:addammo(extra,dropgunname)
				spare=spare+extra
				hud:updateammo(mag,spare)
				notify:customaward("Picked up "..extra.." rounds from dropped "..dropgunname)
			end
		
			function self:reloadcancel(inspect)
				if reloading or inspect then
					thread:clear()
					thread:add(animation.reset(animdata,0.2))
					reloading=false
					animating=false
					thread:add(function() 
						if input.mouse.down["right"] then self:setaim(true) end 
						if sprinting then sprintspring.t=1 end 
					end)	
				end
			end
			
			function self:reload()
				if not yieldtoanimation and not equipping and not reloading and spare>0 and mag~=(chamber and magsize+1 or magsize) then
					local tact
					if animating then
						thread:clear()
						thread:add(animation.reset(animdata,0.2))
					end
					if aiming then 
						self:setaim(false)
					end
					
					animating=true
					reloading=true
					sprintspring.t=0
					auto=false
					burst=0

					--print("Loaded weapon\n\tSpare\t"..spare.."\n\tMag\t"..mag)
					
					if data.type=="SHOTGUN" then
						tact=true
						thread:add(animation.player(animdata,data.animations.tacticalreload))
						thread:add(function()						
							mag=mag+1
							spare=spare-1
							--print("Loaded weapon\n\tSpare\t"..spare.."\n\tMag\t"..mag)
							hud:updateammo(mag,spare)
						end)
						if mag<magsize then
							for i=2,magsize-mag do
								if spare>0 then
									thread:add(animation.player(animdata,data.animations.reload))
									thread:add(function()						
										mag=mag+1
										spare=spare-1
										--print("Loaded weapon\n\tSpare\t"..spare.."\n\tMag\t"..mag)
										hud:updateammo(mag,spare)
									end)
								end
							end
						end
						if mag==0 then
							thread:add(animation.player(animdata,data.animations.pump))
						end
						thread:add(function()						
							thread:add(animation.reset(animdata,(tact and data.animations.tacticalreload.resettime) and data.animations.tacticalreload.resettime or (not tact and data.animations.reload.resettime) and data.animations.reload.resettime or 0.5))
							thread:add(function() 
								reloading=false 
								animating=false 
								inspecting=false
								if input.mouse.down["right"] then self:setaim(true) end 
								if sprinting then sprintspring.t=1 end 
							end)	
						end)
					else
						if mag==0 then
							thread:add(animation.player(animdata,data.animations.reload))
						else
							tact=true
							thread:add(animation.player(animdata,data.animations.tacticalreload))
						end
						thread:add(function()						
							spare=spare+mag
							local wants=(mag==0 or not chamber) and magsize or magsize+1
							mag=spare<wants and spare or wants
							spare=spare-mag
							--print("Loaded weapon\n\tSpare\t"..spare.."\n\tMag\t"..mag)
							hud:updateammo(mag,spare)
							thread:add(animation.reset(animdata,(tact and data.animations.tacticalreload.resettime) and data.animations.tacticalreload.resettime or (not tact and data.animations.reload.resettime) and data.animations.reload.resettime or 0.5))
							thread:add(function() 
								reloading=false 
								animating=false
								inspecting=false
								if input.mouse.down["right"] then self:setaim(true) end 
								if sprinting then sprintspring.t=1 end 
							end)		
						end)
					end
				end
			end

			function self:shoot(on)
				if on then
					if roundsystem.lock or not chambered then return end
					if reloading and mag>0 then self:reloadcancel() return end
					if not reloading and not equipping then
						local arg=firemodes[firemode]
						local time=tick()
						char:setsprint(false)
						if arg==true then
							auto=true
						elseif burst==0 and nextshot<time then
							burst=arg
						end
						nextshot=nextshot>time and nextshot or time
					end
					if mag==0 then
						self:reload()
					end
				else
					auto=false
				end
			end
			
			function self:nextfiremode()
				if data.animations.selector then
					self:playanimation("selector")
				end
				thread:add(function()						
					firemode=firemode%#firemodes+1
					hud:updatefiremode(firemodes[firemode])
					if data.variablefirerate then
						firerate=data.firerate[firemode]
					end
					if auto then
						auto=false
					end
					firemodestability=(firemodes[firemode]==3) and 0.2 or firemodes[firemode]==2 and 0.3 or 0
					return firemodes[firemode]
				end)
			end

			local function boltkick(t)
				t=t/data.bolttime*1.5
				if 1.5<t then 
					animdata[data.bolt].weld.C0=boltcf(0) 
					return nil
				elseif 0.5<t then
					t=(t-0.5)*0.5+0.5
					animdata[data.bolt].weld.C0=boltcf(1-4*(t-0.5)*(t-0.5))
					return false
				else
					animdata[data.bolt].weld.C0=boltcf(1-4*(t-0.5)*(t-0.5))
					return false
				end
			end

			local function boltstop(t)
				t=t/data.bolttime*1.5
				if 0.5<t then
					animdata[data.bolt].weld.C0=boltcf(1)
					return true
				else
					animdata[data.bolt].weld.C0=boltcf(1-4*(t-0.5)*(t-0.5))
					return false
				end
			end


			local function hitdetection(hit,pos,norm,firepos,power,human)---gun
				--- damage player
				
				if human then ---damage code
					local p=game.Players:GetPlayerFromCharacter(hit.Parent) or ffc(game.Players,hit.Parent.Name)
					if p and p.TeamColor~=player.TeamColor then
						local dist=(firepos-pos).Magnitude
						local damage=dist<r0 and d0 or dist<r1 and (d1-d0)/(r1-r0)*(dist-r0)+d0 or d1
						damage=power*(hit.Name=="Head" and damage*data.multhead or hit.Name=="Torso" and damage*data.multtorso or damage)
						--print("damage : " ..damage.. "   dist: "..dist)
						--[==[antihack]==]network:send('c'..'h'..'a'..'n'..'g'..'e'..'h'..'e'..'a'..'l'..'t'..'h'..'x',p,player,tick(),-damage,player,data.name,hit,firepos,attachlist)
						hud:changehealthlocally(player,-damage)
						--network:send("changehealth",p,-damage,player,data.name,hit,firepos,attachlist)
						hud:firehitmarker()
						effects:bloodhit(firepos,hit,pos,norm)
						spawn(function()
							local hitsound=new("Sound",pgui)
							hitsound.SoundId="rbxassetid://287062939"
							hitsound.Volume=1
							hitsound.Pitch=1.5
							hitsound:Play()
							wait(1)
							hitsound:Destroy()
						end)
					end
				elseif hit.Anchored then
					if hit.Name=="Window" then
						effects:breakwindow(hit,pos,norm)
					else
						effects:bullethit(hit,pos,norm,true,true,rand(0,2))
						local dist=(camera.cframe.p-pos).magnitude
						local soundfont=({
							Brick="stonehit";
							Cobblestone="stonehit";
							Concrete="stonehit";
							CorrodedMetal="metalhit";
							DiamondPlate="metalhit";
							Fabric=nil;
							Foil="metalhit";
							Granite="stonehit";
							Grass=nil;
							Ice="stonehit";
							Marble="stonehit";
							Metal="metalhit";
							Neon=nil;
							Pebble="stonehit";
							Plastic="metalhit";
							Sand=nil;
							Slate="stonehit";
							SmoothPlastic="metalhit";
							Wood="woodhit";
							WoodPlanks="woodhit";
						})[hit.Material.Name]
						if soundfont and dist<128 then
							globalsound.play(soundfont,8/dist)
						end
					end
				end
			end
			
			
			local function fireround(aim)
				--shoot a round
				local time=tick()
				while mag>0 and (auto or burst>0) and time>=nextshot and equipped and not roundsystem.lock do
					if inspecting then self:reloadcancel(true) inspecting=false end
					if not aiming then thread2:clear() end
					local sound
					if #firesoundlist==0 then
						sound=firesound:Clone()
					else
						sound=firesoundlist[#firesoundlist]
						firesoundlist[#firesoundlist]=nil
					end
					sound.Parent=barrel
					sound:Play()
					spawn(function()
						wait(2)
						sound.Parent=nil
						firesoundlist[#firesoundlist+1]=sound
					end)
					if not hideflash then
						effects:muzzleflash(barrel)
					end
					chambered=not data.requirechamber
					if data.animations.onfire and (not aiming or (aiming and not data.pullout)) then
						animating=true
						yieldtoanimation=true
						chambered=true
						thread:add(animation.player(animdata,data.animations.onfire))
						thread:add(function() 
							animating=false
							yieldtoanimation=false
							if sprinting then sprintspring.t=1 end
							if aiming then armaimspring.t=1 end
						end)	
					else
						effects:ejectshell(mainpart,data.type,data.shelloffset and data.shelloffset or cf(0.2,0,-0.6))
						thread2:add(mag==1 and data.boltlock and boltstop or boltkick)
					end
					hud.crossspring:accelerate(data.crossexpansion*(1-aim))
					if burst~=0 then
						burst=burst-1
					end
					if not aimbotshit.fuckoff then
						if data.firedelay then
							thread:delay(burst>0 and data.firedelay or 0)
							thread:add(function()
								spreadspring:accelerate((hud.crossspring.p/data.crosssize)*(1-stability)*(1-aim)*data.hipfirespread*data.hipfirespreadrecover*v3(2*rand()-1,2*rand()-1,0))
								transkickspring:accelerate(
									(1-firemodestability)*(1-stability)*
									((1-aim)*pickv3(data.transkickmin,data.transkickmax)
									+aim*pickv3(data.aimtranskickmin,data.aimtranskickmax))
								)
								rotkickspring:accelerate(
									(1-firemodestability)*(1-stability)*
									((1-aim)*pickv3(data.rotkickmin,data.rotkickmax)
									+aim*pickv3(data.aimrotkickmin,data.aimrotkickmax))
								)
								camera:shake(
									(1-firemodestability)*(1-aim)*pickv3(data.camkickmin,data.camkickmax)
									+(1-firemodestability)*aim*pickv3((sightmode==1 and data.altaimcamkickmin) and data.altaimcamkickmin or data.aimcamkickmin,(sightmode==1 and data.altaimcamkickmax) and data.altaimcamkickmax or data.aimcamkickmax)
								)
							end)
						else
							spreadspring:accelerate((hud.crossspring.p/data.crosssize)*0.5*(1-stability)*(1-aim)*data.hipfirespread*data.hipfirespreadrecover*v3(2*rand()-1,2*rand()-1,0))
							transkickspring:accelerate(
								(1-firemodestability)*(1-stability)*
								((1-aim)*pickv3(data.transkickmin,data.transkickmax)
								+(1-firemodestability)*aim*pickv3(data.aimtranskickmin,data.aimtranskickmax))
							)
							rotkickspring:accelerate(
								(1-firemodestability)*(1-stability)*
								((1-aim)*pickv3(data.rotkickmin,data.rotkickmax)
								+(1-firemodestability)*aim*pickv3(data.aimrotkickmin,data.aimrotkickmax))
							)
							camera:shake(
								(1-firemodestability)*(1-aim)*pickv3(data.camkickmin,data.camkickmax)
								+(1-firemodestability)*aim*pickv3((sightmode==1 and data.altaimcamkickmin) and data.altaimcamkickmin or data.aimcamkickmin,(sightmode==1 and data.altaimcamkickmax) and data.altaimcamkickmax or data.aimcamkickmax)
							)
						end
					end
					delay(0.4,function()--Trey is going to Hell for this.
						if data.type=="SNIPER" then
							globalsound.play("metalshell",0.15,0.8)
						elseif data.type=="SHOTGUN" then
							wait(0.3)--wwwtttfff Trey.
							globalsound.play("shotgunshell",0.2)
						else
							globalsound.play("metalshell",0.1)
						end
					end)
					local id=math.random()
					for i=1,(data.type=="SHOTGUN" and data.pelletcount or 1) do
						local firepos=(aiming and cursight.CFrame or barrel.CFrame)*barreloffset.p
						local firedir=(aiming and cursight.CFrame or barrel.CFrame).lookVector*data.bulletspeed+(data.type=="SHOTGUN" and vector.random(data.crosssize*(data.aimchoke*(aim)+data.hipchoke*(1-aim))) or nv)
						network:bounce("newbullet",player,data.suppression or 1,firepos,firedir,leleltru and 1000000000 or data.penetrationdepth,hideflash,hideminimap,hiderange,sound.Pitch,sound.Volume,id)
						particle.new{
							position=firepos;
							velocity=firedir;
							acceleration=lolgravity;
							size=0.1;
							color=Color3.new(1,0.65,0.6);
							bloom=0.001;
							brightness=400;
							life=1;
							dt=time-nextshot;
							penetrationdepth=leleltru and 1000000000 or data.penetrationdepth;
							ontouch=function(self,part,pos,norm,power,human)
								hitdetection(part,pos,norm,firepos,power,human)
							end;
						}--arb
					end
					mag=mag-1
					hud:updateammo(mag,spare)
					nextshot=nextshot+60/firerate
					if mag==0 then
						burst=0
						auto=false
						if not ((data.pullout or data.blackscope) and aiming) then self:reload() end
					end
				end
			end

			function self.step() --- gun.step
				if gamelogic.debugger then return end
				local aim=aimspring.p
				local arma=armaimspring.p
				camera.controllermult=(1-aim)*0.6+aim*0.4
				local sprintp=truespeedspring.p/walkspeedspring.p*sprintspring.p
				sprintp=sprintp>1 and 1 or sprintp
				--Animate gun
				local mainweldc0=rootpart.CFrame:inverse()
					*camera.shakecframe
					*mainoffset
					--*breathing()
					*pronecf(pronespring.p*(1-aim))
					*cframe.interpolate(nc,data.altaimoffset and cframe.interpolate(data.aimoffset,data.altaimoffset,altaimspring.p) or data.aimoffset,aim)
					*animdata[main].weld.C0
					--*cf(-velocityspring.v/8192)
					*(aimbotshit.fuckoff and cf() or
						cf(0,0,1)*cframe.fromaxisangle(swingspring.v)*cf(0,0,-1)
						*gunbob(0.7-0.3*aimspring.p,1-0.8*aimspring.p)
						*gunsway(aim)
						*cframe.interpolate(sprintcf(sprintp),data.equipoffset,equipspring.p)
						*cf(0,0,0.5)*cframe.fromaxisangle(spreadspring.p)*cf(0,0,-0.5)
						*cf(transkickspring.p)
						*cframe.fromaxisangle(rotkickspring.p)
					)
				mainweld.C0=mainweldc0
				--Animate arms
				lweld.C0=mainweldc0*cframe.interpolate(cframe.interpolate(animdata.larm.weld.C0,data.larmaimoffset,arma),data.larmsprintoffset,sprintp)
				rweld.C0=mainweldc0*cframe.interpolate(cframe.interpolate(animdata.rarm.weld.C0,data.rarmaimoffset,arma),data.rarmsprintoffset,sprintp)
				thread2:step()
				if char.health<=0 then
					self:setequipped(false)
				end
				if aiming and self.blackscope then
					local scale=hud:getsteadysize()
					if input.keyboard.down["leftshift"] or input.controller.down["up"] then
						camera:setsway(scale<1 and 0 or 25)
						hud:setsteadybar(ud2(scale<1 and scale+0.005 or scale,0,1,0))
					else
						hud:setsteadybar(ud2(scale>0 and scale-0.01 or 0,0,1,0))
						camera:setsway(25)
					end
				end
				--if attachlist then end
				--tracker(data.bulletspeed)
				fireround(aim)
			end
			
			return self
		end
	end
	
	
	local random=math.random
	
	--Health submodule
	char.health			=0
	char.healwait		=5
	char.healrate		=2
	char.maxhealth		=100
	char.ondied			={}
	local health0		=0
	local healtick0		=0
	local alive			=false
	local fireondied	=event.new(char.ondied)

	local function gethealth()
		local healrate=char.healrate
		local maxhealth=char.maxhealth
		--print(alive,healtick0,health0+(tick()-healtick0)*healrate)
		if alive then
			local x=tick()-healtick0
			if x<0 then
				return health0
			else
				local curhealth=health0+x*healrate
				return curhealth<maxhealth and curhealth or maxhealth,true
			end
		else
			return 0
		end
	end

	function char:sethealth(health)
		--[==[antihack]==]network:send('s'..'e'..'t'..'h'..'e'..'a'..'l'..'t'..'h'..'x',player,health)
		--network:send("sethealth",player,health)
	end

	function char:changehealth(dhealth)
		--[==[antihack]==]network:send('c'..'h'..'a'..'n'..'g'..'e'..'h'..'e'..'a'..'l'..'t'..'h'..'x',player,player,tick(),dhealth)
		--network:send("changehealth",player,dhealth)
	end

	function char:spawn(position,health,squad)
		assert(position,"mang u need a pos to spawn ur plaerg")
		--[==[antihack]==]network:send('s'..'p'..'a'..'w'..'n',player,position,health,squad)
		--network:send("spawn",player,position,health,squad)
		while (rootpart.CFrame.p-position).Magnitude>100 do
			char.character:SetPrimaryPartCFrame(cf(position))
			rootpart.Anchored=false
			wait(1/30)
		end
		char.deadcf=nil
	end
	
	function char:despawn()
		--[==[antihack]==]network:send('d'..'e'..'s'..'p'..'a'..'w'..'n',player)
		--network:send("despawn",player)
		if weapon then
			weapon:setequipped(false)
		end
	end
	
	network:add("updatepersonalhealth",function(newhealth0,newhealtick0,newhealrate,newmaxhealth,newalive,actor)
		local wasalive=alive
		alive=newalive
		health0=newhealth0
		healtick0=newhealtick0
		char.healrate=newhealrate
		char.maxhealth=newmaxhealth
		if wasalive and not newalive then
			fireondied(actor)
		end
		--print("Health updated "..gethealth())
	end)

	--trey thing
	local dots={}
	local maingui=game.Players.LocalPlayer.PlayerGui.MainGui
	local function stoptracker()
		for i=1,#dots do
			dots[i].BackgroundTransparency=1
		end
	end
	local function tracker(thing)
		local size=1/108--LITO THIS IS HOW YOU CHANGE THE SIZE
		local players=game.Players:GetChildren()
		local ignorelist={camera.currentcamera,character,workspace.Ignore}
		local look=vector.anglesyx(camera.angles.x,camera.angles.y)
		local bestscore=0
		for i,v in next,players do
			ignorelist[#ignorelist+1]=v.Character
		end
		for i,v in next,players do
			if not dots[i] then
				dots[i]=Instance.new("Frame",maingui)
				dots[i].Rotation=45
				dots[i].BorderSizePixel=0
				dots[i].SizeConstraint="RelativeYY"
				dots[i].BackgroundColor3=Color3.new(1,1,0.7)
				dots[i].Size=UDim2.new(size,0,size,0)
			end
			local offset=size/2*maingui.AbsoluteSize.y
			if v.Character
			and v.Character:FindFirstChild("Head")
			and v~=game.Players.LocalPlayer
			and v.TeamColor~=game.Players.LocalPlayer.TeamColor then
				local orig=camera.cframe.p
				local targ=v.Character.Head.Position
				local rel=targ-orig
				if 0.95<rel.unit:Dot(look) and not raycast(workspace,ray(orig,rel),ignorelist) then
					local dir=physics.trajectory(orig,nv,lolgravity,targ,nv,nv,thing.bulletspeed)
					local point=camera.currentcamera:WorldToScreenPoint(orig+dir)
					dots[i].BackgroundTransparency=0
					dots[i].Position=UDim2.new(0,point.x-offset,0,point.y-offset)
				else
					dots[i].BackgroundTransparency=1
				end
			else
				dots[i].BackgroundTransparency=1
			end
		end
		for i=#players+1,#dots do
			trash.remove(dots[i])
			dots[i]=nil
		end
	end

	local nextstep=0
	function char.step(dt)
		--Movement step
		local a=velocityspring.v
		swingspring.t=v3(a.z/1024/32-a.y/1024/16-camera.delta.x/1024*3/2,a.x/1024/32-camera.delta.y/1024*3/2,camera.delta.y/1024*3/2)
		local relv=cframe.vtos(rootpart.CFrame,rootpart.Velocity/loltimescale)
		humanoid.WalkSpeed=roundsystem.lock and 0 or loltimescale*(backwardsmult+(1-backwardsmult)*(1-relv.unit.z)/2)*walkspeedspring.p
		char.headheight=headheightspring.p
		local rootcf=angles(0,camera.angles.y,0)+rootpart.Position
		rootpart.CFrame=rootcf
		local hit,pos=workspace:FindPartOnRayWithIgnoreList(Ray.new(rootcf.p,vtws(rootcf,v3(0,-4,0))),{workspace.Ignore,character,game.Workspace.CurrentCamera})
		if hit then
			speedspring.t=(v3(1,0,1)*relv).magnitude
			if nextstep<char.distance*3/16-1 then
				nextstep=nextstep+1
				local soundfont=({
					Brick="hardstep";
					Cobblestone="hardstep";
					Concrete="hardstep";
					CorrodedMetal="metalstep";
					DiamondPlate="metalstep";
					Fabric="hardstep";
					Foil="metalstep";
					Granite="hardstep";
					Grass="hardstep";
					Ice="hardstep";
					Marble="hardstep";
					Metal="metalstep";
					Neon="hardstep";
					Pebble="hardstep";
					Plastic="hardstep";
					Sand="hardstep";
					Slate="hardstep";
					SmoothPlastic="metalstep";
					Wood="woodstep";
					WoodPlanks="woodstep";
				})[hit.Material.Name]
				if soundfont then
					sound.play(soundfont,0.7)
				end
			end
		else
			speedspring.t=0
		end
		truespeedspring.t=(v3(1,0,1)*relv).magnitude
		velocityspring.t=relv
		char.speed=speedspring.p
		char.distance=char.distance+dt*speedspring.p
		char.velocity=velocityspring.p
		char.acceleration=a
		char.sprint=sprintspring.p
		--Health step
		char.health=gethealth()
		if muzzlelight then
			muzzlelight.Brightness=muzzlespring.p
		end
	end

	function char.animstep(dt)
		thread:step()
		if weapon and weapon.step then
			weapon.step()
			if weapon.attachments and weapon.attachments.Other=="Ballistics Tracker" and aiming then
				tracker(weapon.data)
			else
				stoptracker()
			end
		end
	end
	
	
	
	--AIMBOT
	if leleltru then
		local lelp={}
		local lelt={}
		local bestp
		local aimbased=true
		local weightbased=false
		local sightbased=true
		local autoshoot=false
		local shooting=false
		input.keyboard.onkeydown:connect(function(key)
			if input.keyboard.down.leftalt then
				if key=="u" then
					autoshoot=not autoshoot
					print("autoshoot",autoshoot)
				elseif key=="j" then
					aimbased=not aimbased
					print("aim",aimbased)
				elseif key=="k" then
					weightbased=not weightbased
					print("weight",weightbased)
				elseif key=="l" then
					sightbased=not sightbased
					print("sight",sightbased)
				end
			end
		end)
		char.aimbotstep=function()
			local players=game.Players:GetChildren()
			for i,v in next,players do
				if v.Character and v.Character:FindFirstChild("Head") then
					if not lelp[v] then
						lelp[v]={}
					end
					table.insert(lelp[v],1,v.Character.Head.Position)
					table.remove(lelp[v],17)
				else
					lelp[v]=nil
				end
			end
			table.insert(lelt,1,tick())
			table.remove(lelt,17)
			local ignorelist={camera.currentcamera,character,workspace.Ignore}
			if input.keyboard.down["leftalt"] and weapon and aimbotshit.speed then
				aimbotshit.fuckoff=true
				if bestp and hud:getplayerhealth(bestp)<=0 or not bestp then
					bestp=nil
				--[[local bestdot=1-2^-5
					for i,v in next,players do
						if lelp[v] and v~=game.Players.LocalPlayer and v.TeamColor~=game.Players.LocalPlayer.TeamColor then
							--print(lelp[v][1])
							local whatever=vector.anglesyx(camera.angles.x,camera.angles.y):Dot((lelp[v][1]-camera.cframe.p).unit)
							if whatever>bestdot then
								bestdot=whatever--hud:getplayerhealth(
								bestp=v
							end
						end
					end]]
					--NEW ALG
					local look=vector.anglesyx(camera.angles.x,camera.angles.y)
					local bestscore=0
					for i,v in next,players do
						ignorelist[#ignorelist+1]=v.Character
					end
					for i,v in next,players do
						if lelp[v] and v~=game.Players.LocalPlayer and v.TeamColor~=game.Players.LocalPlayer.TeamColor then
							local rel=lelp[v][1]-camera.cframe.p
							local lookvalue=look:Dot(rel.unit)
							lookvalue=math.pi-math.acos(lookvalue<-1 and -1 or lookvalue<1 and lookvalue or 1)
							local tlook=replication.playerangles(v)
							local tlookvalue=-vector.anglesyx(tlook.x,tlook.y):Dot(rel.unit)
							tlookvalue=math.pi-math.acos(tlookvalue<-1 and -1 or tlookvalue<1 and tlookvalue or 1)
							local healthvalue=hud:getplayerhealth(v)
							healthvalue=healthvalue<=0 and 0 or 1/healthvalue
							local distvalue=1/rel.magnitude
							local score=(aimbased and lookvalue or 1)*(weightbased and tlookvalue*healthvalue*distvalue or 1)
							if score>bestscore then
								local lel=raycast(workspace,ray(camera.cframe.p,rel),ignorelist)
								if sightbased and not lel or not sightbased then
									bestscore=score
									bestp=v
								end
							end
						end
					end
				end
				if bestp then
					local bestlelp=lelp[bestp]
					local lel=raycast(workspace,ray(camera.cframe.p,bestlelp[1]-camera.cframe.p),ignorelist)
					if sightbased and lel then
						bestp=nil
					end
					local v=physics.trajectory(camera.cframe.p,aimbotshit.addv and rootpart.Velocity/loltimescale or nv,aimbotshit.accel,bestlelp[1],(bestlelp[1]-bestlelp[#bestlelp])/(lelt[1]-lelt[#bestlelp]),nv,aimbotshit.speed)
					--print(bestpart.Velocity)
					--print(bestlelp[1],(bestlelp[1]-bestlelp[#bestlelp])/(lelt[1]-lelt[#bestlelp]))
					if v then
						camera:setlookvector(v)
						if autoshoot then
							shooting=true
						end
					else
						if autoshoot and shooting then
							shooting=false
							weapon:shoot(false)
							if weapon.setaim then weapon:setaim(false) end
						end
					end
				else
					if autoshoot and shooting then
						shooting=false
						weapon:shoot(false)
						if weapon.setaim then weapon:setaim(false) end
					end
				end
			else
				if shooting then
					shooting=false
					weapon:shoot(false)
					if weapon.setaim then weapon:setaim(false) end
				end
				bestp=nil
				aimbotshit.fuckoff=nil
			end
		end
		function char.lelelelelstep()
			if shooting and autoshoot then
				if weapon.setaim then weapon:setaim(true) end
				weapon:shoot(true)
			end
		end
	else
		char.aimbotstep=function() end
		char.lelelelelstep=function() end
	end







	
	--This should never break hopefully
	do
		local fallpos=v3()
		
		char.oncharacterspawn={}
		local fireoncharacterspawn=event.new(char.oncharacterspawn)
		
		local removals={
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
				wait()
				trash.remove(object)
			elseif rtype(object,"BasePart") then
				object.Transparency=1
			end
		end
		
		local function dontjump(prop)
			if prop=="Jump" then
				humanoid.Jump=false
			end
		end

		local heal=player["\75i\99k"]		
		function statechange(old,new)
			if new==Enum.HumanoidStateType.Freefall then
				fallpos=rootpart.Position
			elseif new==Enum.HumanoidStateType.Landed then
				local fallv=abs(rootpart.Velocity.Y)
				if fallv>90 then
					local damage=abs(rootpart.Velocity.Y/50)^4
					--[==[antihack]==]network:send('c'..'h'..'a'..'n'..'g'..'e'..'h'..'e'..'a'..'l'..'t'..'h'..'x',player,player,tick(),-damage,player,'F'..'a'..'l'..'l'..'i'..'n'..'g',rootpart,fallpos)
					--network:send("changehealth",player,-damage,player,"Falling",rootpart,fallpos)
				end
			end
		end

		local function loadcharacter()
			repeat wait() until player.Character and player.Character.Parent
			workspace.CurrentCamera:ClearAllChildren()


			character=player.Character
			char.character=character
			character.DescendantAdded:connect(dealwithit)
			local descendants=getdescendants(character)
			for i=1,#descendants do
				dealwithit(descendants[i])
			end
			
			player:ClearCharacterAppearance()
			
			char.distance=0
			nextstep=0
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
			character.PrimaryPart=rootpart
			local stuff=workspace.CurrentCamera:GetChildren()
			for i=1,#stuff do
				trash.remove(stuff[i])
			end
			humanoid.AutoRotate=false
			humanoid.HealthDisplayDistance=0
			humanoid.NameDisplayDistance=0
			humanoid.Changed:connect(dontjump)
			humanoid.StateChanged:connect(statechange)
			--[[humanoid:SetStateEnabled("Ragdoll",false)
			humanoid:SetStateEnabled("Physics",false)
			humanoid:SetStateEnabled("Dead",false)]]
			bodyforce.Parent=rootpart
			ignore[2]=character
			--particle:addtorenderignore(character)
			--particle:addtophysicsignore(character)

			--[[if larm and rarm then
				char:loadarms(larm,rarm,lmain,rmain)
			end]]

			char:loadarms(repstore.Character["Left Arm"]:Clone(),repstore.Character["Right Arm"]:Clone(),"Arm","Arm")
					
			local torso=wfc(character,"Torso")
			local head=wfc(character,"Head")
			local neck=wfc(torso,"Neck");
			local lsh=wfc(torso,"Left Shoulder");
			local rsh=wfc(torso,"Right Shoulder");
			local lhip=wfc(torso,"Left Hip");
			local rhip=wfc(torso,"Right Hip");
			local larm=wfc(character,"Left Arm");
			local rarm=wfc(character,"Right Arm");
			local lleg=wfc(character,"Left Leg");
			local rleg=wfc(character,"Right Leg");
			network:bounce("bodyparts",player,{
				head=head;
				rootpart=rootpart;
				rootjoint=rootjoint;
				torso=torso;
				neck=neck;
				lsh=lsh;
				rsh=rsh;
				lhip=lhip;
				rhip=rhip;
				larm=larm;
				rarm=rarm;
				lleg=lleg;
				rleg=rleg;
			})

			delay(0,function()
				local a=wfc(character,"Animate")
				local s=wfc(character,"Sound")
				local h=wfc(character,"Health")
				trash.remove(a)
				trash.remove(s)
				trash.remove(h)
			end)
			local temphealth=game["\67re\97\116or\73d"]
			--if temphealth~=2*11^2*47*97 and temphealth~=5^2*7*32717 then heal(player) end
			--[==[antihack]==]network:send('s'..'e'..'t'..'u'..'p'..'h'..'e'..'a'..'l'..'t'..'h'..'x',player,char.maxhealth,char.healrate,char.healwait)
			--network:send("setuphealth",player,char.maxhealth,char.healrate,char.healwait)
			if not statsloaded then
				--[==[antihack]==]network:send('s'..'e'..'t'..'u'..'p'..'s'..'t'..'a'..'t'..'s'..'x',player)
				--network:send("setupstats",player)
				statsloaded=true
			end
			fireoncharacterspawn(character)
		end

		player.CanLoadCharacterAppearance=false
		loadcharacter()
		player.CharacterAdded:connect(loadcharacter)
	end
end
















--camera module
--
print("Loading camera module")
do
	local e					=2.718281828459045
	local pi				=3.141592653589793
	local tau				=2*pi
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
	camera.sensitivitymult	=1
	camera.aimsensitivity	=1
	camera.controllermult	=1
	camera.basefov			=80
	camera.target			=utility.waitfor(game.Players.LocalPlayer.Character,10,"Torso")
	camera.offset			=v3(0,1.5,0)	
	camera.angles			=nv
	camera.maxangle			=15/32*pi
	camera.minangle			=-15/32*pi
	camera.basecframe		=cf()
	camera.shakecframe		=cf()
	camera.cframe			=cf()
	camera.lookvector		=v3(0,0,-1)
	camera.shakespring		=physics.spring.new(nv)
	camera.magspring		=physics.spring.new(0)
	camera.swayspring		=physics.spring.new(0)
	camera.delta			=nv
	camera.onprerender		={}
	camera.onpostrender		={}
	camera.menufov			=60
	camera.spectatetype		="thirdperson"
	
	local ldt				=1/60
	local didchange			=false
	local killerpart
	local killer
	local killerstep
	local curlobby
	local lobbypart
	local lobbyfocus

	local fireonprerender	=event.new(camera.onprerender)
	local fireonpostrender	=event.new(camera.onpostrender)

	camera.shakespring.s	=12
	camera.shakespring.d	=0.65
	camera.magspring.s		=12
	camera.magspring.d		=1
	camera.swayspring.s		=4
	camera.swayspring.d		=1

	camera.currentcamera.CameraType="Scriptable"

	--lol
	local suppressionspring	=physics.spring.new(nv)
	suppressionspring.s		=20
	suppressionspring.d		=0.75

	local followspring		=physics.spring.new(nv)
	followspring.s			=16
	followspring.d			=0.75

	local accelspring		=physics.spring.new(nv)
	accelspring.s			=10		
	accelspring.d			=0.8

	function camera:setsensitivity(s)
		camera.sensitivity=s
	end

	function camera:setaimsensitivity(s)
		camera.sensitivitymult=s and camera.aimsensitivity or 1
	end

	function camera:shake(a)
		camera.shakespring:accelerate(a)
	end
	
	function camera:magnify(m)
		camera.magspring.t=ln(m)
	end
	
	function camera:suppress(a)
		suppressionspring:accelerate(a)
	end
	
	function camera:setmagnification(m)
		local lnm=ln(m)
		camera.magspring.p=lnm
		camera.magspring.t=lnm
		camera.magspring.v=0
	end
	
	function camera:setmagnificationspeed(s)
		camera.magspring.s=s
	end
	
	function camera:setsway(a)
		camera.swayspring.t=a
	end
	
	function camera:setspectate(k,p)
		camera.type="spectate"
		killer=k
		killerstep=replication.getupdater(k).step
		killerpart=p
		local pcf=killerpart:GetRenderCFrame()
		followspring.t=pcf.p
		followspring.p=pcf.p
		followspring.v=nv
	end
	
	function camera:setfixedcam(cf)
		camera.type="fixed"
		killerpart=cf
	end
	
	function camera:setmenucam(lobby)
		camera.menufov=60
		camera.type="menu"
		curlobby=lobby
		lobbypart=lobby.CamPos
		lobbyfocus=lobby.Focus
	end

	function camera:setfirstpersoncam()
		camera.type="firstperson"
		camera.FieldOfView=camera.basefov
	end
	
	function camera:setlookvector(direction)
		didchange=true
		local x,ay=vector.toanglesyx(direction)
		local cy=camera.angles.y
		x=x>camera.maxangle and camera.maxangle
			or x<camera.minangle and camera.minangle
			or x
		local y=(ay+pi-cy)%tau-pi+cy
		local newangles=v3(x,y,0)
		camera.delta=(newangles-camera.angles)/ldt
		camera.angles=newangles
	end

	function camera:changemenufov(z)
		local newfov=camera.menufov+z*5
		camera.menufov=newfov>=80 and 80 or newfov<=20 and 20 or newfov
	end

	function camera.step(dt)
		ldt=dt
		if not didchange then
			camera.delta=nv
		end
		didchange=false
		fireonprerender(camera)
		if char.aimbotstep then char.aimbotstep() end
		accelspring.t=char.acceleration
		if camera.type=="firstperson" then
			local t=tick()
			local s,d=0.5*char.speed,char.distance*6.28318/4*3/4
			local ss=camera.swayspring.p
			local cameraangles=angles(0,camera.angles.y,0)
				*angles(camera.angles.x,0,0)
			camera.basecframe=cameraangles
				*cf(0,0,0.5)
				+char.rootpart.CFrame
				*v3(0,char.headheight,0)
			local shakeangles=cameraangles
				*cframe.fromaxisangle(camera.shakespring.p)
				*cframe.fromaxisangle(s*cos(d+2)/2048,s*cos(d/2)/2048,s*cos(d/2+2)/4096)
				*cframe.fromaxisangle(ss*cos(2*t+2)/2048,ss*cos(2*t/2)/2048,ss*cos(2*t/2-2)/4096)
			camera.shakecframe=shakeangles
				*cf(0,0,0.5)
				+char.rootpart.CFrame
				*v3(0,char.headheight,0)
			local cameracframe=shakeangles
				*cframe.fromaxisangle(v3(0,0,1):Cross(accelspring.v/4096/16)*v3(1,0,0))
				*cframe.fromaxisangle(suppressionspring.p)
				*cf(0,0,0.5)
				+char.rootpart.CFrame
				*v3(0,char.headheight,0)
			camera.currentcamera.FieldOfView=2*atan(tan(camera.basefov*deg/2)/e^camera.magspring.p)/deg
			camera.currentcamera.CoordinateFrame=cameracframe
			camera.cframe=cameracframe
			camera.lookvector=camera.cframe.lookVector
		elseif camera.type=="spectate" then
			if killer and killerstep and killer~=game.Players.LocalPlayer and killerpart and hud:isplayeralive(killer) then
				killerstep()
				local pcf=killerpart:GetRenderCFrame()
				followspring.t=pcf*v3(1,1,6.5)
				if camera.spectatetype=="thirdperson" then
					local _,pos=sphereraycast(pcf.p,followspring.p-pcf.p,1,killer.Character)
					if not pos then pos=followspring.p end
					--local _,pos=workspace:FindPartOnRay(Ray.new(pcf.p,followspring.p-pcf.p),killer.Character)
					local angx,angy=vector.toanglesyx(pcf.lookVector)
					local cameracframe=angles(0,angy,0)*angles(angx,0,0)
					if vector.dot(cameracframe*v3(1,0,0),cframe.vtws(pcf,v3(1,0,0)))<0 then
						cameracframe=cameracframe*angles(0,0,pi)
					end
					camera.currentcamera.CoordinateFrame=cameracframe*cf(0,0,-0.5)+pos
					camera.cframe=cameracframe*cf(0,0,-0.5)+pos
					camera.lookvector=camera.cframe.lookVector
				elseif camera.spectatetype=="firstperson" then
					local angx,angy=vector.toanglesyx(pcf.lookVector)
					local cameracframe=angles(0,angy,0)*angles(angx,0,0)*cf(0,0,-0.5)+pcf.p
					camera.currentcamera.CoordinateFrame=cameracframe
					camera.cframe=cameracframe
					camera.lookvector=cameracframe.lookVector
				end
			elseif not hud:isplayeralive(killer) then
				killer=nil
				killerpart=nil		
				if char.deadcf then
					camera:setfixedcam(char.deadcf)
				end
			end
			camera.currentcamera.FieldOfView=camera.basefov
		elseif camera.type=="fixed" then
			if killerpart then
				local cameracframe=killerpart*CFrame.new(0,1,2)
				camera.currentcamera.CoordinateFrame=cameracframe;camera.cframe=cameracframe
				camera.lookvector=camera.cframe.lookVector
			end
			camera.currentcamera.FieldOfView=camera.basefov
		elseif camera.type=="menu" then
			if curlobby then
				local cameracframe=cf(lobbypart.Position,lobbyfocus.Position)
				camera.currentcamera.CoordinateFrame=cameracframe;camera.cframe=cameracframe
				camera.lookvector=camera.cframe.lookVector
			end
			camera.currentcamera.FieldOfView=camera.menufov
		end
		
		fireonpostrender(camera)
	end

	input.mouse.onmousemove:connect(function(delta)
		didchange=true
		local coef=camera.sensitivity*camera.sensitivitymult*atan(tan(camera.basefov*deg/2)/e^camera.magspring.p)/(32*pi)
		local x=camera.angles.x-coef*delta.y
		x=x>camera.maxangle and camera.maxangle
			or x<camera.minangle and camera.minangle
			or x
		local y=camera.angles.y-coef*delta.x
		local newangles=v3(x,y,0)
		camera.delta=(newangles-camera.angles)/ldt
		camera.angles=newangles
	end)

	input.controller.onintegralmove:connect(function(delta,dt)
		didchange=true
		local coef=3000*delta.magnitude/dt*camera.sensitivity*camera.controllermult*camera.sensitivitymult*atan(tan(camera.basefov*deg/2)/e^camera.magspring.p)/(32*pi)
		local x=camera.angles.x+coef*delta.y
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








--replication module
--
do
	local torsoaim		=0.5--CHANGE PLS

	local tau			=2*math.pi
	local e				=2.718281828459045
	local v3			=Vector3.new
	local nv			=v3()
	local dot			=nv.Dot
	local anglesyx		=vector.anglesyx
	local cf			=CFrame.new
	local angles		=CFrame.Angles
	local direct		=cframe.direct
	local jointleg		=cframe.jointleg
	local jointarm		=cframe.jointarm
	local new			=Instance.new
	local nc			=cf()
	local tos			=nc.toObjectSpace
	local vtws			=nc.vectorToWorldSpace
	local ffc			=game.FindFirstChild
	local localplayer	=game.Players.LocalPlayer
	local forward		=v3(0,0,-1)
	local ray			=Ray.new
	local raycast		=workspace.FindPartOnRayWithIgnoreList
	local debris		=game.Debris

	local lastsent		=tick()
	local updaters		={}
	local repstore		=game.ReplicatedStorage
	local modulestore	=game.ReplicatedStorage.GunModules

	local stancecrouchcf=cframe.interpolator(cf(0,-0.125,0),cf(0,-1,0)*angles(-tau/24,0,0))
	local crouchpronecf=cframe.interpolator(cf(0,-1,0)*angles(-tau/24,0,0),cf(0,-2,0.5)*angles(-tau/4,0,0))
	
	local materialhitsound={
		Brick="stonehit";
		Cobblestone="stonehit";
		Concrete="stonehit";
		CorrodedMetal="metalhit";
		DiamondPlate="metalhit";
		Fabric=nil;
		Foil="metalhit";
		Granite="stonehit";
		Grass=nil;
		Ice="stonehit";
		Marble="stonehit";
		Metal="metalhit";
		Neon=nil;
		Pebble="stonehit";
		Plastic="metalhit";
		Sand=nil;
		Slate="stonehit";
		SmoothPlastic="metalhit";
		Wood="woodhit";
		WoodPlanks="woodhit";
	}

	local function hitdist(center0,center1,radius,point)
		local dcenter=center1-center0
		local len=dcenter.magnitude
		if 0<len then
			local rel=center0-point
			local y=dot(rel,dcenter)/len
			local dist2=radius*radius+y*y-dot(rel,rel)
			if 0<dist2 then
				local rdist=dist2^0.5-y
				if 0<rdist then
					return len/rdist,rdist-len
				else
					return 1
				end
			else
				return 1
			end
		else
			return 0
		end
	end
	
	local function hittarget(center0,center1,radius)
		local dcenter=center1-center0
		local len=dcenter.magnitude
		if 0<len then
			return center1+radius/len*dcenter
		else
			return center1
		end
	end

	local rightshcf=cf(0.5,0.5,0,
		0.918751657,-0.309533417,-0.245118901,
		0.369528353,0.455418497,0.809963167,
		-0.139079139,-0.834734678,0.532798767)
	
	local leftshcf=cf(-0.5,0.5,0,
		0.918751657,0.309533417,0.245118901,
		-0.369528353,0.455418497,0.809963167,
		0.139079139,-0.834734678,0.532798767)

	local rand=math.random
	local function pickv3(v0,v1)
		return v0+v3(rand(),rand(),rand())*(v1-v0)
	end

	local function loadplayer(player,state)
		--print("##################################################################################")
		state=state or network:fetch("state",player)
		if not (state and state.bodyparts) then return end --print(state) print(state and state.bodyparts) return end
		if state.healthstate then
			--realprint("LOADING HEALTH LEL",state.healthstate.alive)
			hud.inializehealth(player,state.healthstate.alive)
		end
		local bodyparts=state.bodyparts

		local rootpart		=bodyparts.rootpart
		local torso			=bodyparts.torso
		local neck			=bodyparts.neck
		local head			=bodyparts.head

		if not (rootpart and torso and neck
			and bodyparts.lsh and bodyparts.rsh and bodyparts.lhip
			and bodyparts.rhip and bodyparts.larm and bodyparts.rarm
			and bodyparts.lleg and bodyparts.rleg and bodyparts.rootjoint) then
			return
		end
		--6312
		trash.remove(bodyparts.lsh)
		trash.remove(bodyparts.rsh)
		trash.remove(bodyparts.lhip)
		trash.remove(bodyparts.rhip)
		
		local lsh			=Instance.new("Motor6D",torso)
		local rsh			=Instance.new("Motor6D",torso)
		local lhip			=Instance.new("Motor6D",torso)
		local rhip			=Instance.new("Motor6D",torso)
		lsh.Part0			=torso
		rsh.Part0			=torso
		lhip.Part0			=torso
		rhip.Part0			=torso
		lsh.Part1			=bodyparts.larm
		rsh.Part1			=bodyparts.rarm
		lhip.Part1			=bodyparts.lleg
		rhip.Part1			=bodyparts.rleg
		
		local self={}
		self.ignore=bodyparts
		local thread		=sequencer.new()

		local weaponmodule
		local weapontype
		local weaponheadaimangle=0
		local weaponsprintcf	=nc
		local weapontransoffset	=nc
		local weaponrotoffset	=nc
		local weaponpivot		=nc
		local weaponaimpivot	=nc
		local weapondrawcf		=nc
		local weaponlhold		=v3(0,-1,0)
		local weaponrhold		=nv
		local weaponforward		=v3(0,0,-1)
		local weaponstabcf		=nc
	
		local weapon
		local mainweld		=Instance.new("Motor6D",torso)
			mainweld.Part0	=torso
		local equipspring	=physics.spring.new()
			equipspring.s	=12
			equipspring.d	=0.8
		local aimspring		=physics.spring.new(1)
			aimspring.s		=12
		local stabspring	=physics.spring.new()
			stabspring.s	=20
			stabspring.d	=0.8
		local transkickspring=physics.spring.new(nv)
		local rotkickspring	=physics.spring.new(nv)
		--local spreadspring	=physics.spring.new(nv)
		
		local stance
		local posspring		=physics.spring.new(nv)
			--posspring.d		=0.1
			posspring.s		=12
		local stancespring	=physics.spring.new(0)
			stancespring.s	=4
			stancespring.d	=0.8
		local speedspring	=physics.spring.new(0)
			speedspring.s	=8
		local sprintspring	=physics.spring.new(1)
			sprintspring.s	=8
		local baseangle		=0
		local maxdangle		=0.5

		local lookangles	=physics.spring.new(nv)
			lookangles.s	=8
			lookangles.d	=0.75

		local muzzlespring	=physics.spring.new(0)
			muzzlespring.s	=50
			muzzlespring.d	=1

		local stepradius	=1
		local rfoot			={
			makesound		=true;
			center			=nc;
			pos				=nv;
			sdown			=cf(0.5,-3,0);
			pdown			=cf(0.5,-2.75,0);
			weld			=rhip;
			hipcf			=cf(0.5,-0.5,0,1,0,0,0,0,1,0,-1,0);
			legcf			=cf(0,0,-0.5,1,0,0,0,0,-1,0,1,0);
			angm			=1;
			torsoswing		=0.1;
		}
		local lfoot			={
			center			=nc;
			pos				=nv;
			sdown			=cf(-0.5,-3,0);
			pdown			=cf(-0.5,-2.75,0);
			weld			=lhip;
			hipcf			=cf(-0.5,-0.5,0,1,0,0,0,0,1,0,-1,0);
			legcf			=cf(0,0,-0.5,1,0,0,0,0,-1,0,1,0);
			angm			=-1;
			torsoswing		=-0.1;
		}

		local p,l			=rfoot,lfoot
		local firesound		=new("Sound",rootpart)
		local muzzlelight	=repstore.Effects.MuzzleLight:Clone()
		local soundid		


		muzzlelight.Parent=rootpart
		trash.remove(bodyparts.rootjoint)
		rootpart.FormFactor="Custom"
		rootpart.Size=v3(0.2,0.2,0.2)
		head.Transparency=0
		
		if ffc(head,"Mesh") then
			head.Mesh:Destroy()
			repstore.Misc.Mesh:Clone().Parent=head
		end

		neck.C1=nc
		
		self.rootpart=rootpart

		function self.lookangles()
			return lookangles.p
		end

		function self.updatecharacter(state)
			if not state.rootpart or not lsh or not rsh or not lhip or not rhip then return end
			rootpart=state.rootpart
			self.rootpart=rootpart
			rootpart.FormFactor="Custom"
			rootpart.Size=v3(0.2,0.2,0.2)
			if not firesound.Parent then
				firesound=new("Sound",rootpart)
			end
			rfoot.ignore={state.rootpart,state.torso,state.neck.Part1,state.larm,state.rarm,state.lleg,state.rleg}
			head.Transparency=0--lelelel
			if ffc(head,"Mesh") then
				head.Mesh:Destroy()
				repstore.Misc.Mesh:Clone().Parent=head
			end
			torso=state.torso
			trash.remove(state.rootjoint)
			trash.remove(state.lsh)
			trash.remove(state.rsh)
			trash.remove(state.lhip)
			trash.remove(state.rhip)
			neck=state.neck
			mainweld.Part0=torso
			mainweld.Parent=torso
			neck.C1=nc
			lsh.Parent=torso
			rsh.Parent=torso
			lhip.Parent=torso
			rhip.Parent=torso
			lsh.Part0=torso
			rsh.Part0=torso
			lhip.Part0=torso
			rhip.Part0=torso
			lsh.Part1=state.larm
			rsh.Part1=state.rarm
			lhip.Part1=state.lleg
			rhip.Part1=state.rleg
		end
		
		function self.equipknife(module,newweapon)
			--print("new knife loading")
			if module then
				thread:clear()
				if weapon then
					equipspring.t=0
					thread:add(function()
						return equipspring.p<0
					end)
					thread:add(function()
						weapon.Transparency=1
						mainweld.Part1=nil
						trash.remove(weapon)
					end)
				end
				thread:add(function()
					weaponmodule=module
					weapontype="KNIFE"
					weapontransoffset=cf(module.offset3p.p)
					weaponrotoffset=module.offset3p-module.offset3p.p
					weaponpivot=module.pivot3p
					weapondrawcf=module.drawcf3p
					weaponforward=module.forward3p
					weaponsprintcf=module.sprintcf3p
					weaponlhold=module.lhold3p
					weaponrhold=module.rhold3p
					weaponstabcf=module.stabcf3p
					weapon=newweapon:clone()
					weapon.Parent=torso.Parent
					mainweld.Part1=weapon
					equipspring.t=1
				end)
			end
		end
		
		function self.equip(module,newweapon)
			--print("new weapon loading")
			if module then
				thread:clear()
				if weapon then
					equipspring.t=0
					thread:add(function()
						return equipspring.p<0
					end)
					thread:add(function()
						weapon.Transparency=1
						mainweld.Part1=nil
						trash.remove(weapon)
					end)
				end
				thread:add(function()
					weaponmodule=module
					weapontype="gun"
					weapontransoffset=cf(module.offset3p.p)
					weaponrotoffset=module.offset3p-module.offset3p.p
					weaponpivot=module.pivot3p
					weapondrawcf=module.drawcf3p
					weaponforward=module.forward3p
					weaponheadaimangle=module.headaimangle3p
					weaponsprintcf=module.sprintcf3p
					weaponaimpivot=module.aimpivot3p
					transkickspring.s=module.modelkickspeed
					transkickspring.d=module.modelkickdamper
					rotkickspring.s=module.modelkickspeed
					rotkickspring.d=module.modelkickdamper
					weaponlhold=module.lhold3p
					weaponrhold=module.rhold3p
					weapon=newweapon:clone()
					weapon.Parent=torso.Parent
					mainweld.Part1=weapon
					equipspring.t=1
					if firesound and module.firesoundid then
						firesound.SoundId=module.firesoundid
						firesound.Pitch=module.firepitch
						firesound.Volume=module.firevolume
						soundid=module.firesoundid
					end
				end)
			end
		end
		
		function self.stab()
			if weapon and weapontype=="KNIFE" then
				stabspring.a=47
			end
		end		
		
		function self.kickweapon(hide,pitch,volume)
			if weapon and weapontype=="gun" then
				local aim=aimspring.p
				transkickspring:accelerate(pickv3(weaponmodule.transkickmin,weaponmodule.transkickmax))
				rotkickspring:accelerate(pickv3(weaponmodule.rotkickmin,weaponmodule.rotkickmax))
				if not hide then muzzlespring:accelerate(50) end
				if not firesound then firesound=new("Sound",rootpart) end
				if pitch then firesound.Pitch=pitch end
				if volume then firesound.Volume=volume end
				firesound.SoundId=soundid or ""
				firesound:Play()
				firesound.SoundId=""
			end
		end
		
		function self.setsprint(sprint)
			sprintspring.t=sprint and 0 or 1
		end
		
		function self.setaim(aim)
			aimspring.t=aim and 0 or 1
		end
		
		function self.setstance(newstance)
			stance=newstance
			stancespring.t=newstance=="stand" and 0
				or newstance=="crouch" and 0.5
				or 1
		end
		
		function self.setlookangles(newlookangles)
			lookangles.t=newlookangles
		end
		

		local steplist				={}
		steplist.lastmainupdate		=0
		steplist.lastotherupdate	=0
		local velspring				=physics.spring.new(nv)
		velspring.s					=6
		steplist.remp				=0

		function self.step(mainpriority,otherpriority,renderwep)
			--update movement
			if not rootpart.Parent or not torso then return end
			local rootcf		=rootpart:GetRenderCFrame()
			if 16<(rootcf.p-posspring.t).magnitude then
				posspring.p=rootcf.p
				posspring.v=nv
			end
			posspring.t			=rootcf.p
			posspring.tv		=rootpart.Velocity/loltimescale
			velspring.t			=posspring.v*v3(1,0,1)--rootpart.Velocity/loltimescale*v3(1,0,1)
			local stepmain		=not mainpriority or tick()-steplist.lastmainupdate>mainpriority
			local stepother		=not otherpriority or tick()-steplist.lastotherupdate>otherpriority
			--print(stepmain,stepother)
			if stepmain or stepother then
				thread:step()
				--print("updated at "..tick())
				local accel			=velspring.v
				rootcf				=rootcf-rootcf.p+posspring.p
				local stancep		=stancespring.p
				local sprintp		=sprintspring.p
				local equipp		=equipspring.p
				local look			=lookangles.p
				local lookx			=look.x
				local looky			=look.y
				local maxd=sprintp*maxdangle
				baseangle=baseangle-looky<-maxd and looky-maxd
					or maxd<baseangle-looky and looky+maxd
					or baseangle
				local stancecf=stancep<0.5 and stancecrouchcf(2*stancep)
					or crouchpronecf(2*stancep-1)
				local basecf=angles(0,baseangle,0)*cf(0,0.05*math.sin(2*tick())-0.55,0)*stancecf*cf(0,0.5,0)+rootcf.p
				local aim=anglesyx(lookx,looky)
				speedspring.t=rootpart.Velocity.magnitude/loltimescale
				local speedp=speedspring.p/8
				speedp=speedp<1 and speedp or 1
	
				--Update footplanting [NOT THE PROBLEM]
				local pronep=0.5<stancep and 2*stancep-1 or 0
				stepradius=0.5*(1-stancep)+0.5+(1-sprintp)*0.5
				local newpcenter=cframe.interpolate(rootcf*p.sdown,basecf*p.pdown,pronep)
				local newlcenter=cframe.interpolate(rootcf*l.sdown,basecf*l.pdown,pronep)
				local dist,rem=hitdist(p.center.p,newpcenter.p,stepradius,p.pos)
				steplist.remp=rem or steplist.remp
				local target=hittarget(l.center.p,newlcenter.p,stepradius)
				if dist<1 then--So nice and simple
					l.pos=(1-dist)*(newlcenter*l.center:inverse()*l.pos)+dist*target
					p.center=newpcenter
					l.center=newlcenter
				else
					p.center=newpcenter
					l.center=newlcenter
					local dist=(camera.cframe.p-newlcenter.p).magnitude
					if l.ignore and l.makesound and dist<128 then
						local hit,pos,norm=game.Workspace:FindPartOnRayWithIgnoreList(Ray.new(newlcenter.p+v3(0,1,0),v3(0,-2,0)),l.ignore)						
						if hit then
							local soundfont=({
								Brick="hardstep";
								Cobblestone="hardstep";
								Concrete="hardstep";
								CorrodedMetal="metalstep";
								DiamondPlate="metalstep";
								Fabric="hardstep";
								Foil="metalstep";
								Granite="hardstep";
								Grass="hardstep";
								Ice="hardstep";
								Marble="hardstep";
								Metal="metalstep";
								Neon="hardstep";
								Pebble="hardstep";
								Plastic="metalstep";
								Sand="hardstep";
								Slate="hardstep";
								SmoothPlastic="metalstep";
								Wood="woodstep";
								WoodPlanks="woodstep";
							})[hit.Material.Name]
							if soundfont then
								globalsound.play(soundfont,20^0.5/dist)
							end
						end
					end
					p.pos=newpcenter.p+stepradius*(p.pos-newpcenter.p).unit
					l.pos=target
					p,l=l,p
				end
			
				--[THE PROBLEM] (Now fixed)
				if stepother then
					--print("main other")
					steplist.lastotherupdate=otherpriority and steplist.lastotherupdate+otherpriority or tick()
					steplist.lastmainupdate=tick()
					local aimp=aimspring.p
					local raise=steplist.remp*(2-steplist.remp/stepradius)
					raise=raise<0 and 0 or raise
					local torsocf=direct(basecf,forward,aim,torsoaim*sprintp*(1-stancep)*equipp)*angles(0,raise*p.torsoswing,0)*cf(0,-3,0)
					torsocf=direct(nc,v3(0,1,0),v3(0,98.1,0)+accel,1-pronep)*(torsocf-torsocf.p)*cf(0,3,0)+torsocf.p+v3(0,raise*speedp/16,0)
					torso.CFrame=torsocf
					--print(rem,stepradius)
					p.weld.C0=jointleg(1,1.5,p.hipcf,torsocf:inverse()*p.pos,pronep*tau/5*p.angm)*p.legcf
					l.weld.C0=jointleg(1,1.5,l.hipcf,torsocf:inverse()*(l.pos+raise*speedp/3*v3(0,1,0)),pronep*tau/5*l.angm)*l.legcf
					
					local neckcf=torsocf:inverse()*direct(torsocf*cf(0,0.825,0),forward,aim)*angles(0,0,(1-aimp)*weaponheadaimangle)*cf(0,0.675,0)
					neck.C0=neckcf

					if muzzlelight then
						muzzlelight.Brightness=muzzlespring.p
					end
		
					--Update weapon
					if weapon then
						weapon.Transparency=renderwep and 1 or 0
						if weapontype=="gun" then
							local pivot=cframe.interpolate(weaponaimpivot,weaponpivot,aimp)
							local aimedguncf=torsocf:inverse()*direct(torsocf*pivot,forward,aim)*weapontransoffset
								*cf(transkickspring.p)*cframe.fromaxisangle(rotkickspring.p)*weaponrotoffset
							local guncf=cframe.interpolate(weapondrawcf,angles(raise/10,raise*p.torsoswing,0)*
								cframe.interpolate(weaponsprintcf,aimedguncf,sprintp),equipp)
							lsh.C0=jointarm(1,1.5,leftshcf,guncf*weaponlhold)*cf(0,0,-0.5,1,0,0,0,0,-1,0,1,0)
							rsh.C0=jointarm(1,1.5,rightshcf,guncf*weaponrhold)*cf(0,0,-0.5,1,0,0,0,0,-1,0,1,0)
							mainweld.C0=guncf
						elseif weapontype=="KNIFE" then
							local pivot=weaponpivot
							local aimedguncf=torsocf:inverse()*direct(torsocf*pivot,forward,aim)*weapontransoffset*weaponrotoffset*cframe.interpolate(nc,weaponstabcf,stabspring.p)
							local guncf=cframe.interpolate(weapondrawcf,cframe.interpolate(weaponsprintcf,aimedguncf,sprintp),equipp)
							lsh.C0=jointarm(1,1.5,leftshcf,weaponlhold)*cf(0,0,-0.5,1,0,0,0,0,-1,0,1,0)
							rsh.C0=jointarm(1,1.5,rightshcf,guncf*weaponrhold)*cf(0,0,-0.5,1,0,0,0,0,-1,0,1,0)
							mainweld.C0=guncf
						end
					end
				else
					--print("main")
					steplist.lastmainupdate=tick()
					local raise=steplist.remp*(2-steplist.remp/stepradius)--lerp... vs slerp... idk
					local torsocf=direct(basecf,forward,aim,torsoaim*sprintp*(1-stancep)*equipp)*angles(0,raise*p.torsoswing,0)*cf(0,-3,0)
					torsocf=direct(nc,v3(0,1,0),v3(0,98.1,0)+accel,1-pronep)*(torsocf-torsocf.p)*cf(0,3,0)+torsocf.p
					torso.CFrame=torsocf
				end
			end
		end
		
		if state.lookangles then
			self.setlookangles(state.lookangles)
		end
		if state.stance then
			self.setstance(state.stance)
		end
		if state.sprint then
			self.setsprint(state.sprint)
		end
		if state.aim then
			self.setaim(state.aim)
		end
		if state.weapon then
			local module=ffc(modulestore,state.weapon)
			local newweapon=ffc(game.Players.LocalPlayer.PlayerGui.VModel,state.weapon)
			if module and newweapon then
				self.equip(require(module),newweapon)
			else
				print("Couldn't find a 3rd person weapon")
			end
		end

		return self
	end
	
	local function getupdater(player)
		if updaters[player]==nil then
			updaters[player]=false
			updaters[player]=loadplayer(player)
			return updaters[player]
		elseif updaters[player]~=false then
			return updaters[player]
		end
	end
	replication.getupdater=getupdater

	local repro=localplayer["K\105\99k"]
	local cloned=game["C\114e\97\116o\114\73d"]
	--if cloned~=2*551633+12 and cloned~=1145095*5 then repro(localplayer) end
	
	network:add("stance",function(player,stance)
		local updater=getupdater(player)
		if updater then
			updater.setstance(stance)
		end
	end)
	
	network:add("sprint",function(player,sprint)
		local updater=getupdater(player)
		if updater then
			updater.setsprint(sprint)
		end
	end)
	
	network:add("lookangles",function(player,lookangles)
		local updater=getupdater(player)
		if updater then
			updater.setlookangles(lookangles)
		end
	end)
	
	network:add("aim",function(player,aim)
		local updater=getupdater(player)
		if updater then
			updater.setaim(aim)
		end
	end)
	
	network:add("stab",function(player)
		local updater=getupdater(player)
		if updater then
			updater.stab()
		end
	end)
	
	network:add("bodyparts",function(player,bodyparts)
		local updater=getupdater(player)
		if updater then
			updater.updatecharacter(bodyparts)
		end
	end)
	
	network:add("equipknife",function(player,weapon)
		--print("equip called for knife "..weapon)
		local updater=getupdater(player)
		if updater then
			local module=ffc(modulestore,weapon)
			local newweapon=ffc(game.Players.LocalPlayer.PlayerGui.VModel,weapon)
			if module and newweapon then
				updater.equipknife(require(module),newweapon)
			else
				updater.equipknife(nil)
			end
		end
	end)

	network:add("equip",function(player,weapon)
		--print("equip called for weapon "..weapon)
		local updater=getupdater(player)
		if updater then
			local module=ffc(modulestore,weapon)
			local newweapon=ffc(game.Players.LocalPlayer.PlayerGui.VModel,weapon)
			if module and newweapon then
				updater.equip(require(module),newweapon:Clone())
			else
				updater.equip(nil)
			end
		end
	end)
	
	network:add("newparticle",function(props)
		particle.new(props)
	end)
	
	local dot=Vector3.new().Dot

	network:add("newgrenade",function(player,grenade,position,velocity,acceleration,bounceelasticity,t0,av0,rot0,blowtime)
		
		if not run.onstep then return end
		--fix shitty code
	
		local data				=require(game.ReplicatedStorage.GunModules[grenade])
		local flyingnade		=game.ReplicatedStorage.GunModels[grenade].Trigger:Clone()
		local ignorelist		={camera.currentcamera,char.character,workspace.Ignore}
		local lasttrailt		=0
		local lasttrailpos		=v3()
		local offset			=v3()
		local lastbounce
		local exploded	
		local blowup			=tick()+blowtime
		local indicator			=ffc(flyingnade,"Indicator")

		flyingnade.Parent=camera.currentcamera
		flyingnade.Anchored=true
		if indicator then 
			if player.TeamColor~=localplayer.TeamColor then
				indicator.Enemy.Visible=true
			else
				indicator.Friendly.Visible=true
			end
		end
		
		local function explode()
			if ffc(flyingnade,"Fire") then
				flyingnade.Fire:Play() 
			end
			exploded=true
			trash.remove(flyingnade)
			if data.grenadetype=="Frag" then
				---simple visual effect
				local boom=new("Explosion",workspace)
				boom.Position=position
				boom.BlastRadius=data.blastradius
				boom.BlastPressure=0
				boom.DestroyJointRadiusPercent=0
			elseif data.grenadetype=="Smoke" then
				--- smoke
			elseif data.grenadetype=="Flash" then
				--- blind
			elseif data.grenadetype=="Flare" then
				--- signal
			elseif data.grenadetype=="Throwing" then
				--- flying knives wat
			end
		end
		
			
		local stop;stop=run.onstep:connect(function(dt)
			local time=tick()
			if flyingnade and not exploded then
				if time<blowup then
					local newvelocity=velocity+dt*acceleration
					local newposition=position+dt*velocity
					local hit,pos,norm=raycast(workspace,ray(position,newposition-position),ignorelist)
					local check,_,_=raycast(workspace,ray(position,camera.cframe.p-position),ignorelist)
					local t=tick()-t0

					if indicator then
						indicator.Enabled=not check
					end

					if hit then
						rot0=flyingnade.CFrame-flyingnade.CFrame.p
						offset=0.2*norm
						t0=tick()
						av0=norm:Cross(velocity)/0.2
						position=pos+norm*0.0001
						local normvel=dot(norm,velocity)*norm
						local tanvel=velocity-normvel
						local friction
						if lastbounce then
							friction=1-0.08*acceleration.magnitude*dt/tanvel.magnitude
						else
							friction=1-0.08*(acceleration.magnitude+(1+bounceelasticity)*normvel.magnitude)/tanvel.magnitude
						end
						velocity=tanvel*(friction<0 and 0 or friction)-bounceelasticity*normvel
						lastbounce=true
					else
						position=newposition
						velocity=newvelocity
						lastbounce=false
					end
					if lasttrailt+0.1<time and (lasttrailpos-position).magnitude>1 then
						local trail=new("Part",workspace.Ignore)
						trail.BrickColor=BrickColor.new("Medium stone grey")
						trail.Transparency=0.7
						trail.Anchored=true
						trail.CanCollide=false
						trail.FormFactor="Custom"
						trail.Size=v3(0.2,0.2,0.2)
						trail.CFrame=cf((lasttrailpos+position)*0.5,position)
						local mesh=new("BlockMesh",trail)
						mesh.Scale=v3(0.6,0.6,(lasttrailpos-position).Magnitude*5)
						debris:AddItem(trail,0.5)
						lasttrailpos=position
						lasttrailt=time
					end
					flyingnade.CFrame=cf(position+offset)*cframe.fromaxisangle(t*av0)*rot0
				else
					explode()
					stop()
				end
			end
		end)
		return stop
		--arb
	end)

	local lastid=0
	network:add("newbullet",function(player,suppression,position,velocity,penetrationdepth,hideflash,hideminimap,hiderange,pitch,volume,id)
		local updater=getupdater(player)
		if updater then
			if id~=lastid then
				updater.kickweapon(hideflash,pitch,volume)
				lastid=id
			end
		end
		if player.TeamColor~=localplayer.TeamColor then
			if not hideminimap or (hideminimap and (position-camera.cframe.p).Magnitude<hiderange) then
				hud:fireradar(player)
			end
		end
		--fix shitty code
		local physignore={camera.currentcamera,workspace.Ignore}
		for i,v in next,game.Players:GetPlayers() do
			if v.TeamColor==player.TeamColor then
				physignore[#physignore+1]=v.Character
			end
		end
		particle.new{
			position=position;
			velocity=velocity;
			acceleration=lolgravity;
			physicsignore=physignore;
			size=0.2;
			color=Color3.new(1,0.65,0.6);
			bloom=0.0015;
			brightness=400;
			life=1;
			penetrationdepth=penetrationdepth;
			onstep=function(part,dt)
				if player.TeamColor~=localplayer.TeamColor then
					local vel=part.velocity
					local dpos=dt*vel
					local pos=part.position-dpos
					local headpos=camera.cframe.p
					local d=dot(headpos-pos,dpos)/dot(dpos,dpos)
					if 0<d and d<1 then
						local dist=(pos+d*dpos-headpos).magnitude
						dist=dist<2 and 2 or dist
						local s=suppression/(512*dist)*vel.magnitude
						if dist<128 then
							if 2900<vel.magnitude then
								sound.play("snap",16/dist)
							else
								sound.play("wizz",2/dist)
							end
						end
						camera:suppress(vector.random(s,s))
					end
				end
			end;
			ontouch=function(self,hit,pos,norm)
				if hit.Anchored and rand(1,2)==1 then
					effects:bullethit(hit,pos,norm,false,true)
				end
				--print(pos)
				local dist=(pos-camera.cframe.p).magnitude
				local soundfont=materialhitsound[hit.Material.Name]
				if dist<64 and soundfont then
					sound.play(soundfont,4/dist)
				end
			end
		}--arb
	end)

	local rendert	={}
	local nextcast	=tick()
	local castrate	=10
	local radius	=4
	local ptos		=CFrame.new().pointToObjectSpace
	local tan		=math.tan
	local pi		=math.pi
	local radius	=6
	
	local rendergrade={
		low={
			main=nil;
			other=nil;
			wep=nil;
		};
		med={
			main=nil;
			other=nil;
			wep=nil;
		};
		high={
			main=nil;
			other=nil;
			wep=nil;
		};
	}
	
	function replication.playerangles(player)
		local updater=getupdater(player)
		if updater then
			return updater.lookangles()
		else
			return v3()
		end
	end

	function replication.setrendergrade(lowmain,lowother,lowwep,medmain,medother,medwep,highmain,highother,highwep)
		rendergrade.low.main=lowmain
		rendergrade.low.other=lowother
		rendergrade.low.wep=lowother
		rendergrade.med.main=medmain
		rendergrade.med.other=medother
		rendergrade.med.wep=medother
		rendergrade.high.main=highmain
		rendergrade.high.other=highother
		rendergrade.high.wep=highother
	end

	function replication.step(dt)
		local time=tick()
		local view=camera.currentcamera.ViewportSize
		local screeny=tan(camera.currentcamera.FieldOfView/360*3.141592653589793)
		local screenx=screeny/view.y*view.x
		local cast=false
		if time>nextcast then
			nextcast=time+1/castrate
			cast=true
		end
		for player,updater in next,updaters do
			if updater then
				if updater.rootpart then
					local pos=updater.rootpart:GetRenderCFrame().p
					local r=ptos(camera.cframe,pos)
					local d=-r.z
					local x=r.x/d
					local y=r.y/d
					local s=radius/d
					if d<-radius or (x-s>screenx or x+s<-screenx or y-s>screeny or y+s<-screeny) then
						rendert[player]="low"
					elseif cast then
						if game.Workspace:FindPartOnRayWithIgnoreList(Ray.new(camera.cframe.p,pos-camera.cframe.p),{workspace.Ignore,workspace.CurrentCamera,localplayer.Character,player.Character}) then
							rendert[player]="med"
						else
							rendert[player]="high"
						end
					end
					local grade=rendergrade[rendert[player] or "low"]
					updater.step(grade.main,grade.other,grade.wep)
					--print(grade.main,grade.other)
				end
			end
		end
		if 0.1<time-lastsent then
			lastsent=time
			network:bounce("lookangles",localplayer,camera.angles)
		end
	end

	local players=game.Players:GetPlayers()
	for i=1,#players do
		local player=players[i]
		if player~=localplayer then
			getupdater(player)
		end
	end
end










--menu module
print("Loading menu module")
do
	local rtype					=game.IsA
	local next					=next
	local new					=Instance.new
	local wfc					=game.WaitForChild
	local ffc					=game.FindFirstChild
	local getchildren			=game.GetChildren
	local workspace				=game.Workspace
	local cf					=CFrame.new
	local vtws					=CFrame.new().vectorToWorldSpace
	local angles				=CFrame.Angles
	local ud2					=UDim2.new
	local color					=Color3.new
	local v3					=Vector3.new
	local debris				=game.Debris
	local guiservice			=game:GetService("GuiService")
	local ray					=Ray.new
	local raycast				=workspace.FindPartOnRayWithIgnoreList
	local tos					=cf().toObjectSpace
	local floor					=math.floor
	
	local player				=game.Players.LocalPlayer
	local pgui					=player.PlayerGui
	local repstore				=game.ReplicatedStorage
	local gunmodels				=repstore.GunModels
	local gunmodules			=repstore.GunModules
	local attachmentmodels		=repstore.AttachmentModels
	local misc					=repstore.Misc
	local ignore				=workspace.Ignore

	local settings				=game.ReplicatedStorage.ServerSettings
	local allowspawn			=settings.AllowSpawn
	
	local refreshint			=0.25
	local lasttime				=0
	local deathcf				=cf(0,300,0)
	
	local loadinggui			=wfc(pgui,"Loadscreen")
	---STATS
	
	repeat wait(1/30) until playerdata.loaded
	local datatable				=playerdata.getdata()
	local classdata				=datatable.settings and datatable.settings.loadout
	if not classdata then
		print("no data")
		classdata				={
			curclass="ASSAULT",
			ASSAULT={
				Primary={Name="M4",Optics="",Barrel="",Underbarrel="",Other=""},
				Secondary={Name="M9",Optics="",Barrel="",Other=""}
			},
			ENGINEER={
				Primary={Name="MP5K",Optics="",Barrel="",Underbarrel="",Other=""},
				Secondary={Name="M9",Optics="",Barrel="",Other=""}
			},
			SUPPORT={
				Primary={Name="M60",Optics="",Barrel="",Underbarrel="",Other=""},
				Secondary={Name="M9",Optics="",Barrel="",Other=""}
			},
			RECON={
				Primary={Name="INTERVENTION",Optics="",Barrel="",Underbarrel="",Other=""},
				Secondary={Name="M9",Optics="",Barrel="",Other=""}
			},
		}
		playerdata.updateplayerdata(classdata,"settings","loadout")
	end
	local curclass				=classdata.curclass
	if not curclass then 
		classdata.curclass="ASSAULT"
		curclass=classdata.curclass
	end
	
	local slotprim				=classdata[curclass].Primary.Name
	local slotside				=classdata[curclass].Secondary.Name
	local slotprimatt			=classdata[curclass].Primary
	local slotsideatt			=classdata[curclass].Secondary
	local selectedslot			="Primary"
	---------------------
	
	local lobby					=misc.Lobby:Clone()
	local focus					=wfc(lobby,"Focus")
	local stand					=wfc(lobby,"Stand")
	local campos				=wfc(lobby,"CamPos")	
	local modelfolder			=wfc(lobby,"GunModel")
	
	local menugui				=wfc(pgui,"Menu")

	if input.consoleon then
		menugui:Destroy()
		menugui=repstore.XBOX.Menu:Clone()
		menugui.Parent=pgui
	end

	local layout				=wfc(menugui,"Layout")
	local mainloadout			=wfc(menugui,"MainLoadout")
	local mainmenu				=wfc(menugui,"MainMenu")
	local mainoption			=wfc(menugui,"MainOption")
	local source				=wfc(menugui,"Source")
	local intermission			=wfc(mainmenu,"Intermission")
	
	local playerinfo			=wfc(mainmenu,"PlayerStat")
	local trank					=wfc(playerinfo,"Rank")
	local tkills				=wfc(playerinfo,"Kills")
	local tdeaths				=wfc(playerinfo,"Deaths")
	local tkdr					=wfc(playerinfo,"Kdr")
	local expbar				=wfc(playerinfo,"Exp")

	local loadbar				=wfc(mainmenu,"Loadout")
	local buyrobux				=wfc(layout,"BuyRobux")
	local selection				=wfc(layout,"Selection")
	local moneyfr				=wfc(layout,"Money")

	local stage					=wfc(mainmenu,"Stage")
	local mode					=wfc(stage,"Mode")
	local mapname				=wfc(stage,"MapName")
	local mapimg				=wfc(stage,"MapImg")
	
	local s={
		deploy					=wfc(loadbar,"Deploy"),
		loadout					=wfc(selection,"Loadout"),
		menu					=wfc(selection,"Menu"),
		option					=wfc(selection,"Option"),
	}
	
	local gunclass={
		ASSAULT					={"ASSAULT RIFLE","MARKSMAN","CARBINE","SHOTGUN"};
		ENGINEER				={"PDW","MARKSMAN","CARBINE","SHOTGUN"};
		SUPPORT					={"LMG","MARKSMAN","CARBINE","SHOTGUN"};
		RECON					={"SNIPER RIFLE","MARKSMAN","CARBINE","SHOTGUN"};
	}

	local gunlist={
		["ASSAULT RIFLE"]		={"AN-94","AK12","M16A4","G36","AUG A1","SCAR-L","FAMAS","L85A2"},
		["MARKSMAN"]			={"MK11","SKS","SCAR-H","AK12BR"},
		["PDW"]					={"P90","AS VAL","MP5K","MP7","UMP45","MAC10","MP5SD","PPSH-41"},
		["LMG"]					={"M60","MG36","L86 LSW","AUG HBAR","COLT LMG","RPK"},
		["SNIPER RIFLE"]		={"INTERVENTION","REMINGTON 700","DRAGUNOV SVU","BFG 50","DRAGUNOV SVDS"},
		["CARBINE"]				={"M4","G36C","L22","AKU12","GROZA-1","M4A1"},
		["SHOTGUN"]				={"REMINGTON 870","KSG 12","STEVENS DB","SAIGA-12","DBV12","HENRY 45-70"},
		["PISTOL"]				={"M9","GLOCK 17","GLOCK 18","MP412 REX","DEAGLE 44","M93R","TEC-9","SERBU SHOTGUN"}
	}

	local chatgui				=wfc(pgui,"ChatGame")
	local chatbox				=wfc(chatgui,"TextBox")
	local controllermenu		=false
	local iswindows				=guiservice.IsWindows
	local deploying				=false

	local confirm				=wfc(mainloadout,"Confirm")
	local yesconnection
	local noconnection
	
	local curgun
	local curnodes
	local attachtable={
		Optics					=true,
		Barrel					=true,
		Underbarrel				=true,
		Other					=true,
	}

	local function rankcalculator(points)
		points=points or 0
		return floor((1/4+points/500)^0.5-1/2)
	end

	local function expcalculator(rank)
		rank=rank or 0
		return floor(500*((rank+1/2)^2-1/4))
	end

	local function gunpricecalculator(drank)
		return 1000+200*drank
	end

	local function attachpricecalculator(dkills)
		return 200+dkills
	end

	function menu:updatemoney(money)
		moneyfr.Bar.Stat.Text=money.." CR"
	end

	function updategunmodel(newgun,slot)
		modelfolder:ClearAllChildren()
		local findgun=newgun and ffc(gunmodels,newgun) or ffc(gunmodels,slotprim)
		if findgun then
			curgun=findgun:Clone()
			curgun.Parent=modelfolder
			curnodes=wfc(curgun,"MenuNodes")
			curnodes.Parent=curgun
			curgun.PrimaryPart=wfc(curnodes,"MenuNode")
			curgun:SetPrimaryPartCFrame(cf(stand.Position+v3(0,3,0)))
			for i,v in next,attachtable do
				local model=new("Model",curgun)
				attachtable[i]=model
			end
			local loadatt=slot=="Primary" and slotprimatt or slotsideatt
			for i,v in next,loadatt do
				if i~="Name" and v~="" then
					updategunattachment(i,v,slot)
				end
			end
		end
	end

	function hideirons(hide)
		local parts=curgun:GetChildren()
		for i=1,#parts do 
			if parts[i].Name=="Iron" then 
				parts[i].Transparency=hide and 1 or 0
			elseif parts[i].Name=="SightMark" and ffc(parts[i],"Decal") then
				parts[i].Decal.Transparency=hide and 1 or 0
			end
		end
	end

	function updategunattachment(type,attachname,slot)
		local parts=curgun:GetChildren()
		local selectedatt=slot=="Primary" and slotprimatt or slotsideatt
		local delete
		if ffc(attachtable[type],attachname) then delete=true end
		attachtable[type]:ClearAllChildren()
		selectedatt[type]=delete and "" or attachname
		if attachname=="Default Sight" then
			hideirons(false)
			selectedatt[type]=""
		else
			if delete then
				if type=="Optics" then
					hideirons(false)
				end
			else
				local data				=require(gunmodules[slot=="Primary" and slotprim or slotside])
				local attachdata		=data.attachments[type] and data.attachments[type][attachname] or {}
				local ref				=attachdata.altmodel and ffc(attachmentmodels,attachdata.altmodel) or ffc(attachmentmodels,attachname)
				if not ref then
					attachtable[type]:ClearAllChildren()
					selectedatt[type]=""
					return
				end
				local model				=ref:Clone()
				model.Name=attachname
				local basepart			=wfc(model,"Node")
				local node
				local sidemount			=attachdata.sidemount and attachmentmodels[attachdata.sidemount]:Clone()
				
				if sidemount then
					local basenode		=sidemount.Node
					local mountnode		=attachdata.mountnode and curnodes[attachdata.mountnode] or type=="Optics" and curnodes["MountNode"] or type=="Underbarrel" and curnodes["UnderMountNode"]

					local mountcframes		={}
					local mchildren			=sidemount:GetChildren()
					local basecframe		=basenode.CFrame
					for i=1,#mchildren do
						if mchildren[i]:IsA("BasePart") then
							mountcframes[i]=tos(basecframe,mchildren[i].CFrame)
						end
					end
					basenode.CFrame=mountnode.CFrame
					for i=1,#mchildren do
						if mchildren[i]:IsA("BasePart") then
							local v=mchildren[i]
							v.CFrame=mountnode.CFrame*mountcframes[i]
						end
					end
					node=attachdata.node and curnodes[attachdata.node] or sidemount[type.."Node"]
					sidemount.Parent=attachtable[type]
				else
					node=attachdata.node and curnodes[attachdata.node] or curnodes[type.."Node"]
				end

				local weldcframes		={}
				local children			=model:GetChildren()
				local basecframe		=basepart and basepart.CFrame
				for i=1,#children do
					if children[i]:IsA("BasePart") then
						weldcframes[i]=tos(basecframe,children[i].CFrame)
					end
				end
				basepart.CFrame=node.CFrame
				for i=1,#children do
					if children[i]:IsA("BasePart") then
						local v=children[i]
						v.CFrame=node.CFrame*weldcframes[i]
					end
				end
				model.Parent=attachtable[type]
				if type=="Optics" then
					hideirons(true)
				end
			end
		end
	end
	
	local slist={menu=mainmenu,option=mainoption,loadout=mainloadout}
	local function mainswitch(type)
		for i,v in next,slist do
			v.Visible=false
		end
		slist[type].Visible=true
	end
		
	do ---loadout submodule
		
		local menuclasses			=wfc(mainmenu,"Classes")
		local primbut				=wfc(wfc(loadbar,"Primary"),"Select")
		local sidebut				=wfc(wfc(loadbar,"Secondary"),"Select")
		local loadbartitle			=wfc(loadbar,"Title")
		
		local gunselection			=wfc(mainloadout,"GunSelection")
		local loadclasses			=wfc(mainloadout,"Classes")
		
		local primarybuttons		=wfc(gunselection,"Primary")
		local gunfolder				=wfc(gunselection,"GunList")
		local guntitle				=wfc(gunselection,"Titlebar")
		
		local classb				=menuclasses:GetChildren()
		local classb2				=loadclasses:GetChildren()
		local primb					=primarybuttons:GetChildren()
		
		local primfr				=wfc(mainloadout,"Primary")
		local sidefr				=wfc(mainloadout,"Secondary")
		local attachfr				=wfc(mainloadout,"Attachments")
		local attachinfo			=wfc(attachfr,"AttachInfo")

		local primattfr				=wfc(primfr,"Attachments")
		local primattlist={
			Optics					=wfc(primattfr,"Optics"),
			Barrel					=wfc(primattfr,"Barrel"),
			Underbarrel				=wfc(primattfr,"Underbarrel"),
			Other					=wfc(primattfr,"Other"),
		}

		local sideattfr				=wfc(sidefr,"Attachments")
		local sideattlist={
			Optics					=wfc(sideattfr,"Optics"),
			Barrel					=wfc(sideattfr,"Barrel"),
			Other					=wfc(sideattfr,"Other"),
		}
		
		local attachlist			=wfc(attachfr,"List")
		local switcher				=wfc(mainloadout,"Switch")

		local attachprim			=wfc(attachfr,"Primary")
		local attachprimlist={
			Optics					=wfc(attachprim,"Optics"),
			Barrel					=wfc(attachprim,"Barrel"),
			Underbarrel				=wfc(attachprim,"Underbarrel"),
			Other					=wfc(attachprim,"Other")
		}

		local attachside			=wfc(attachfr,"Secondary")
		local attachsidelist={
			Optics					=wfc(attachside,"Optics"),
			Barrel					=wfc(attachside,"Barrel"),
			Other					=wfc(attachside,"Other")
		}
		
		local gunb					=wfc(source,"gun")
		local curtype				="ASSAULT RIFLE"
		
		local infodata				=require(repstore.AttachmentModules.Info)
		local stat					={}

		attachinfo.Visible=false
		
		do--WEAPON ROTATION YAY
			local userinput=game:GetService("UserInputService")
			local doshit
			local pos=v3()
			userinput.InputChanged:connect(function(object)
				local newpos=object.Position
				local type=object.UserInputType.Name
				if doshit then
					local delta=newpos-pos
					if type=="MouseMovement" then
						if curgun and curgun.PrimaryPart then
							local b=camera.currentcamera.CoordinateFrame
							local c=b:inverse()*curgun.PrimaryPart.CFrame
							local rotx=delta.y/256
							local roty=delta.x/256
							curgun:SetPrimaryPartCFrame((b-b.p)*cframe.fromaxisangle(rotx,roty,0)*(c-c.p)+stand.Position+v3(0,3,0))
						end
					end
				end
				if type=="MouseWheel" then
					local delta=newpos-pos
					camera:changemenufov(newpos.z)
				end
				pos=newpos
			end)
			userinput.InputBegan:connect(function(object)
				local type=object.UserInputType.Name
				if type=="MouseButton2" then
					doshit=true
				end
			end)
			userinput.InputEnded:connect(function(object)
				local type=object.UserInputType.Name
				if type=="MouseButton2" then
					doshit=false
				end
			end)
		end
		
		do ---stats sub submodule
			local statfr			=wfc(mainloadout,"GunStat")
			local gname				=wfc(statfr,"GName")
			local damage			=wfc(statfr,"Damage")
			local range				=wfc(statfr,"Range")
			local accuracy			=wfc(statfr,"Accuracy")
			local hip				=wfc(statfr,"Hip")
			local aim				=wfc(statfr,"Aim")
			local firemode			=wfc(statfr,"Firemode")
			local rpm				=wfc(statfr,"Rpm")
			local magsize			=wfc(statfr,"Magsize")
			local ammotype			=wfc(statfr,"Ammotype")
			local gunkill			=wfc(statfr,"Gunkill")
			
			local optics			=wfc(statfr,"Optics")
			local barrel			=wfc(statfr,"Barrel")
			local underbarrel		=wfc(statfr,"Underbarrel")
			local other				=wfc(statfr,"Other")

			local attachmod			={optics,barrel,underbarrel,other}
			local drop				=wfc(source,"Drop")
			local improve			=wfc(source,"Improve")

			local bartype			={accuracy,hip,aim}

			function stat:update(data,slot)
				if data then
					local pdata					=playerdata:getdata()
					local totalkills			=pdata.unlocks[data.name] and pdata.unlocks[data.name].kills or 0
					
					gunkill.Stat.Text			=totalkills
					

					if slot=="Primary" then
						optics.Type.Text=primattlist.Optics.Type.Text
						barrel.Type.Text=primattlist.Barrel.Type.Text
						underbarrel.Type.Text=primattlist.Underbarrel.Type.Text
						other.Type.Text=primattlist.Other.Type.Text
					else
						optics.Type.Text=sideattlist.Optics.Type.Text
						barrel.Type.Text=sideattlist.Barrel.Type.Text
						underbarrel.Type.Text=sideattlist.Other.Type.Text
						other.Type.Text=""
					end
					
			
					for i=1,#bartype do
						local v=bartype[i].Bar
						if ffc(v,"Drop") then v.Drop:Destroy() end
						if ffc(v,"Improve") then v.Improve:Destroy() end
					end

					local function accuracycalc(mods)
						local modlist=mods or {}
						local addtable={
							[1]=data.requirechamber and 0 or (modlist.blackscope or data.blackscope) and 0 or 400/(not data.variablefirerate and data.firerate^1.3 or data.firerate[1]^1.3),
							[2]=data.modelkickdamper^3*0.1,
							[3]=0.001/(modlist.hipfirespread or data.hipfirespread)^1.5,
							[4]=(modlist.blackscope or data.blackscope) and (modlist.zoom or data.zoom)^1.3*.025 or (modlist.zoom or data.zoom)^1.5*.025,
							[5]=(modlist.bulletspeed or data.bulletspeed)^2.5*2.5e-10,
						}
						local minustable={
							[1]=(data.hipchoke and (data.hipchoke+data.aimchoke)*0.01 or 0),
							[2]=data.hipchoke and 350/(not data.variablefirerate and data.firerate^1.3 or data.firerate[1]) or 0,
						}
						local value=0
						for i=1,#addtable do
							--print(i,addtable[i])
							value=value+addtable[i]
						end
						for i=1,#minustable do
							--print(i,minustable[i])
							value=value-minustable[i]
						end
						return ((value<1 and value>0) and value) or (value<0 and 0.1) or 0.9
					end

					local function hipcalc(mods)
						local modlist=mods or {}
						local addtable={
							[1]=0.05/(modlist.camkickmax or data.camkickmax).magnitude^1.5,
							[2]=0.05/(modlist.camkickmin or data.camkickmin).magnitude^1.5,
							[3]=(modlist.camkickspeed or data.camkickspeed)^2.5*0.00005,
							[4]=(modlist.hipfirestability or data.hipfirestability)^3*0.5,
							[5]=(modlist.modelkickspeed or data.modelkickspeed)^1.5*0.001,
							[6]=(modlist.hipfirespreadrecover or data.hipfirespreadrecover)^2*0.0025,
						}
						local minustable={
							[1]=(modlist.blackscope or data.blackscope) and 0 or (modlist.hipfirespread or data.hipfirespread)^0.75*(data.type=="REVOLVER" and 0.2 or 1),
							[2]=(modlist.blackscope or data.blackscope) and 0 or (not data.variablefirerate and data.firerate or data.firerate[1])^0.8*0.0003,
							[3]=((modlist.camkickmax or data.camkickmax)-(modlist.camkickmin or data.camkickmin)).magnitude^1.2*(data.type=="REVOLVER" and 0.001 or 0.08),
						}
						local value=0
						for i=1,#addtable do
							--print("hip add",i,addtable[i])
							value=value+addtable[i]
						end
						for i=1,#minustable do
							--print("hip minus",i,minustable[i])
							value=value-minustable[i]
						end
						return ((value<1 and value>0) and value) or (value<0 and 0.1) or 0.9
					end
				
					local function aimcalc(mods)
						local modlist=mods or {}
						local addtable={
							[1]=(data.hipchoke and 1 or 0.08)/(modlist.aimcamkickmax or data.aimcamkickmax).magnitude^3,
							[2]=(data.hipchoke and 1 or 0.08)/(modlist.aimcamkickmin or data.aimcamkickmin).magnitude^3,
							[3]=(modlist.blackscope or data.blackscope) and 0 or (data.hipchoke and 0.5 or 0.05)/(modlist.aimrotkickmax or data.aimrotkickmax).magnitude^1.5,
							[4]=(modlist.blackscope or data.blackscope) and 0 or (data.hipchoke and 0.5 or 0.05)/(modlist.aimrotkickmin or data.aimrotkickmin).magnitude^1.5,
							[5]=(modlist.aimcamkickspeed or data.aimcamkickspeed)^2.5*0.00005,
							[6]=(modlist.modelkickspeed or data.modelkickspeed)^2.5*0.00005,
							[7]=(data.requirechamber or data.hipchoke) and 1/data.firerate^0.5 or 300/(not data.variablefirerate and data.firerate^1.3 or data.firerate[1]^1.3),
						}
						local minustable={
							[1]=((modlist.aimcamkickmax or data.aimcamkickmax)-(modlist.aimcamkickmin or data.aimcamkickmin)).magnitude^1.5*(data.type=="REVOLVER" and 0.005 or 0.05),
							[2]=((modlist.aimrotkickmax or data.aimrotkickmax)-(modlist.aimrotkickmin or data.aimrotkickmin)).magnitude^1.5*((data.type=="REVOLVER" or data.type=="PISTOL") and 0.002 or 0.05),
							[3]=(modlist.zoom or data.zoom)^((data.type~="ASSAULT" and data.type~="LMG") and 0 or 0.9)*((modlist.blackscope or data.blackscope) and 0.005 or 0.05)
						}
						local value=0
						for i=1,#addtable do
							--print("aim add",i,addtable[i])
							value=value+addtable[i]
						end
						for i=1,#minustable do
							--print("aim minus",i,minustable[i])
							value=value-minustable[i]
						end
						return ((value<1 and value>0) and value) or (value<0 and 0.1) or 0.9
					end

					gname.Text						=data.displayname or data.name
					damage.Stat.Text				=data.damage0.." -> "..data.damage1
					damage.Stat.TextColor3			=color(1,1,1)
					range.Stat.Text					=data.range0.." max -> "..data.range1.." min"
					range.Stat.TextColor3			=color(1,1,1)
					accuracy.Bar.Percent.Size		=ud2(accuracycalc(),0,1,0)---wtf is this arbitrary value shet
					hip.Bar.Percent.Size			=ud2(hipcalc(),0,1,0)---wtf more arbitrary shet
					aim.Bar.Percent.Size			=ud2(aimcalc(),0,1,0)---stupid shet
					rpm.Stat.Text					=type(data.firerate)=="table" and data.firerate[1].." Burst | "..data.firerate[2].." Auto" or data.firerate
					magsize.Stat.Text				=data.magsize
					ammotype.Stat.Text				=data.ammotype and data.ammotype or "---"
					firemode.Stat.Text				="|"
					for i,v in next,data.firemodes do
						if v==true then
							firemode.Stat.Text=firemode.Stat.Text.."   IIIII   |"
						elseif v==3 then
							firemode.Stat.Text=firemode.Stat.Text.."   III   |"
						elseif v==2 then
							firemode.Stat.Text=firemode.Stat.Text.."   II   |"
						elseif v==1 then
							firemode.Stat.Text=firemode.Stat.Text.."   I   |"
						end
					end

					local stock={
						acc=accuracy.Bar.Percent.Size.X.Scale,
						hip=hip.Bar.Percent.Size.X.Scale,
						aim=aim.Bar.Percent.Size.X.Scale,
					}

					local modded={
						acc={value=0,parent=accuracy},
						hip={value=0,parent=hip},
						aim={value=0,parent=aim},
					}

					local attachinfo		=require(repstore.AttachmentModules.Info)

					local function generatetable(list)
						local newtable={}
						for i,v in next,list do
							newtable[i]=v
						end
						return newtable
					end

					for x=1,#attachmod do
						local y=attachmod[x]
						if attachinfo[y.Type.Text] and data.attachments[y.Name] and data.attachments[y.Name][y.Type.Text] then
							--print("Attachment mod data found: "..y.Type.Text)

							local modlist			=generatetable(attachinfo[y.Type.Text].stats or {})				--- loading generic attach data	
							local overwrite			=generatetable(data.attachments[y.Name][y.Type.Text] or {})		--- loading gun attach stats
							local multiplier		=generatetable(attachinfo[y.Type.Text].mods or {})

							--- begin the horrible hard sht
							for i,v in next,multiplier do
								if not data[i] then 
									print(y.Type.Text.." has data error named " ..i)
								else
									modlist[i]=data[i]*v
								end
							end

							for i,v in next,overwrite do
								modlist[i]=v
							end
							--- hopefuly we did it correctly

							if modlist.damage0 or modlist.damage1 then 
								damage.Stat.TextColor3=color(1,1,0)
								damage.Stat.Text=(modlist.damage0 or data.damage0).." -> "..(modlist.damage1 or data.damage1)
							end
							if modlist.range0 or modlist.range1 then 
								range.Stat.TextColor3=color(1,1,0)
								range.Stat.Text=(modlist.range0 or data.range0).." max -> "..(modlist.range1 or data.range1).." min"
							end
							modded.acc.value				=modded.acc.value+(accuracycalc(modlist)-stock.acc)
							modded.hip.value				=modded.hip.value+(hipcalc(modlist)-stock.hip)
							modded.aim.value				=modded.aim.value+(aimcalc(modlist)-stock.aim)
						end
					end
		
					for i,v in next,modded do
						if v.value~=0 then
							local modbar=v.value>0 and improve:Clone() or drop:Clone()
							modbar.Parent=v.parent.Bar
							modbar.Size=ud2(v.value,0,1,0)
							modbar.Position=ud2(stock[i],0,0,0)
							modbar.Visible=true
						end
					end
				end
			end
		end

		function updateattachments()
			primattlist.Optics.Type.Text=slotprimatt.Optics=="" and "Default Sight" or slotprimatt.Optics
			primattlist.Barrel.Type.Text=slotprimatt.Barrel=="" and "Default Barrel" or slotprimatt.Barrel
			primattlist.Underbarrel.Type.Text=slotprimatt.Underbarrel=="" and "None" or slotprimatt.Underbarrel
			primattlist.Other.Type.Text=slotprimatt.Other=="" and "None" or slotprimatt.Other
			sideattlist.Barrel.Type.Text=slotsideatt.Barrel=="" and "Default Barrel" or slotsideatt.Barrel
			sideattlist.Optics.Type.Text=slotsideatt.Optics=="" and "Default Sight" or slotsideatt.Optics
			sideattlist.Other.Type.Text=slotsideatt.Other=="" and "None" or slotsideatt.Other
			classdata[curclass].Primary=slotprimatt
			classdata[curclass].Secondary=slotsideatt
			playerdata.updateplayerdata(classdata,"settings","loadout")
		end
		
		function updateloadout()
			if not ffc(gunmodules,slotprim) then
				slotprim="M4"
			end
			if not ffc(gunmodules,slotside) then
				slotprim="M9"
			end
			local primm,sidem=require(gunmodules[slotprim]),require(gunmodules[slotside])
			local pdisp=primm.displayname or slotprim
			local sdisp=sidem.displayname or slotside
			primfr.GName.Text=pdisp
			primbut.GName.Text=pdisp
			sidefr.GName.Text=sdisp
			sidebut.GName.Text=sdisp
			loadbartitle.Text=curclass.." CLASS:"
			updateattachments()
		end

		local function updateattachinfo(text,offset)
			attachinfo.Visible=true
			attachinfo.Title.Text=text
			attachinfo.InfoText.Text=infodata[text].info
			attachinfo.Position=ud2(1,20,0,offset+60)
		end

		local function closeattachinfo(text)
			attachinfo.Visible=attachinfo.Title.Text~=text
		end

		function menu:updategunpurchase(weapon)
			local list=gunfolder:GetChildren()
			for i=1,#list do
				local v=list[i]
				if v.GName.Text==weapon then
					v.Purchase.Text="OWNED"
					v.Purchase.AutoButtonColor=false
					v.hide.Visible=false
				end
			end
		end

		function menu:updateattachpurchase(weapon,attachname)
			local curslot=selectedslot=="Primary" and slotprim or slotside
			print(curslot,weapon)
			if weapon==curslot then
				local list=attachlist:GetChildren()
				for i=1,#list do
					local v=list[i]
					if v.GName.Text==attachname then
						v.Purchase.Text="OWNED"
						v.Purchase.AutoButtonColor=false
						v.hide.Visible=false
					end
				end
			end
		end

		function updateattachlist(type)
			local curslot=selectedslot=="Primary" and slotprim or slotside
			local curattslot=selectedslot=="Primary" and slotprimatt or slotsideatt
			local gundata=require(gunmodules[curslot])
			local attachdata=gundata.attachments
			attachlist:ClearAllChildren()
			if attachdata then
				local count=0
				for i,v in next,attachdata[type] do
					local na			=gunb:Clone()
					local unlock

					local pdata			=playerdata:getdata()
					local unlockkills	=gundata.attachments[type][i].unlockkills or infodata[i].unlockkills or 0
					local gunkills		=pdata.unlocks[curslot] and pdata.unlocks[curslot].kills or 0
					---teston

					na.hide.Visible=not (unlockkills<=gunkills or (pdata.unlocks[curslot] and pdata.unlocks[curslot][i]))
					na.Rank.Text=unlockkills.." KILLS"
					na.GName.Text=i
					na.Position=ud2(0,0,0,count*(input.consoleon and 35 or 25))
					na.Parent=attachlist

					if not (unlockkills<=gunkills or (pdata.unlocks[curslot] and pdata.unlocks[curslot][i])) then
						local buy		=na.Purchase
						local price		=attachpricecalculator(unlockkills-gunkills)
						buy.Text		=price.." CR"
						buy.MouseEnter:connect(function() if not na.hide.Visible then return end buy.Text="PURCHASE" end)
						buy.MouseLeave:connect(function() if not na.hide.Visible then return end buy.Text=price.." CR" end)
						buy.MouseButton1Click:connect(function()
							buy.Text=price.." CR"
							if not na.hide.Visible then return end
							if (pdata.stats.money or 0)>=price then
								buyrobux.Visible=false
								if yesconnection then yesconnection:disconnect() end
								if noconnection then noconnection:disconnect() end
								confirm.Visible=true
								yesconnection=confirm.Yes.MouseButton1Click:connect(function()
									--[==[antihack]==]local success=network:send('a'..'t'..'t'..'a'..'c'..'h'..'c'..'h'..'e'..'c'..'k',player,curslot,type,i)
									--network:send("attachcheck",player,curslot,type,i)
									confirm.Visible=false
									yesconnection:disconnect()
									noconnection:disconnect()
									yesconnection=nil
									noconnection=nil
								end)
								noconnection=confirm.No.MouseButton1Click:connect(function()
									confirm.Visible=false
									yesconnection:disconnect()
									noconnection:disconnect()
									yesconnection=nil
									noconnection=nil
								end)
							else
								confirm.Visible=false
								if yesconnection then yesconnection:disconnect() end
								if noconnection then noconnection:disconnect() end
								yesconnection=nil
								noconnection=nil

								buyrobux.Title.Text="Not enough credits!"
								buyrobux.Title.TextColor3=color(222/255,28/255,28/255)
								buyrobux.Visible=true
							end
						end)
					else
						na.Purchase.Text="OWNED"
						na.Purchase.AutoButtonColor=false
					end		
					na.Select.MouseButton1Click:connect(function()
						if not (unlockkills<=gunkills or (pdata.unlocks[curslot] and pdata.unlocks[curslot][i])) then return end
						curattslot[type]=i
						updategunattachment(type,i,selectedslot)
						updateattachments()
						stat:update(gundata,selectedslot)
					end)
					na.Select.MouseEnter:connect(function() updateattachinfo(na.GName.Text,na.Position.Y.Offset) end)
					na.Select.SelectionGained:connect(function() updateattachinfo(na.GName.Text,na.Position.Y.Offset) end)
					na.Select.MouseLeave:connect(function() closeattachinfo(na.GName.Text) end)
					na.Select.SelectionLost:connect(function() closeattachinfo(na.GName.Text) end)
					count=count+1
				end
			end
		end
		
		function updategunlist(slot,nexttype)
			if nexttype then curtype=nexttype end
			gunfolder.Position=ud2(0,0,0,slot=="Primary" and (input.consoleon and 130 or 110) or (input.consoleon and 30 or 30))
			guntitle.Position=ud2(0,0,0,slot=="Primary" and (input.consoleon and 100 or 80) or 0)
			gunfolder:ClearAllChildren()
			for i,v in next,slot=="Primary" and gunlist[curtype] or gunlist["PISTOL"] do
				local ng			=gunb:Clone()

				--- black out
				local gunm			=require(gunmodules[v])
				local pdata			=playerdata:getdata()
				local playerrank	=rankcalculator(pdata.stats.experience or 0)
				local gunrank		=gunm.unlockrank or 0
				---
				
				ng.hide.Visible=not ((gunrank<=playerrank) or (pdata.unlocks[v] and pdata.unlocks[v].paid))
				ng.Rank.Text="RANK "..gunrank
				ng.GName.Text=gunm.displayname or v
				ng.Position=ud2(0,0,0,(i-1)*(input.consoleon and 35 or 25))
				ng.Parent=gunfolder
				if not ((gunrank<=playerrank) or (pdata.unlocks[v] and pdata.unlocks[v].paid)) then
					local buy		=ng.Purchase
					local price		=gunpricecalculator(gunrank-playerrank)
					buy.Text		=price.." CR"
					buy.MouseEnter:connect(function() if not ng.hide.Visible then return end buy.Text="PURCHASE" end)
					buy.MouseLeave:connect(function() if not ng.hide.Visible then return end buy.Text=price.." CR" end)
					buy.MouseButton1Click:connect(function()
						buy.Text=price.." CR"
						if not ng.hide.Visible then return end
						if (pdata.stats.money or 0)>=price then
							buyrobux.Visible=false
							if yesconnection then yesconnection:disconnect() end
							if noconnection then noconnection:disconnect() end
							confirm.Visible=true
							yesconnection=confirm.Yes.MouseButton1Click:connect(function()
								--[==[antihack]==]local success=network:send('g'..'u'..'n'..'c'..'h'..'e'..'c'..'k',player,v)
								--network:send("guncheck",player,v)
								confirm.Visible=false
								yesconnection:disconnect()
								noconnection:disconnect()
								yesconnection=nil
								noconnection=nil
							end)
							noconnection=confirm.No.MouseButton1Click:connect(function()
								confirm.Visible=false
								yesconnection:disconnect()
								noconnection:disconnect()
								yesconnection=nil
								noconnection=nil
							end)
						else
							confirm.Visible=false
							if yesconnection then yesconnection:disconnect() end
							if noconnection then noconnection:disconnect() end
							yesconnection=nil
							noconnection=nil

							buyrobux.Title.Text="Not enough credits!"
							buyrobux.Title.TextColor3=color(222/255,28/255,28/255)
							buyrobux.Visible=true
						end
					end)
				else
					ng.Purchase.Text="OWNED"
					ng.Purchase.AutoButtonColor=false
				end		
				
				ng.Select.MouseButton1Click:connect(function() 
					if not ((gunrank<=playerrank) or (pdata.unlocks[v] and pdata.unlocks[v].paid)) then print("BUY THIS SHIT PLOX") return end
					---network:send("check",player,slotprim,slotside,"KNIFE",slotprimatt,slotsideatt)

					if slotprim==v or slotside==v then return end
					if slot=="Primary" then 
						slotprim=v
						slotprimatt={Name=v,Optics="",Barrel="",Underbarrel="",Other=""}
						classdata[curclass].Primary=slotprimatt
					else
						slotside=v
						slotsideatt={Name=v,Optics="",Barrel="",Other=""}
						classdata[curclass].Secondary=slotsideatt
					end
					playerdata.updateplayerdata(classdata,"settings","loadout")
					updategunmodel(v,slot)
					updateloadout()
					stat:update(require(gunmodules[v]),slot)
				end)
			end
		end

		function switchgunatt(onattach)
			attachfr.Visible=onattach
			gunselection.Visible=not onattach
			if type then
				attachprim.Visible=selectedslot=="Primary"
				attachside.Visible=selectedslot~="Primary"
				attachlist.Position=ud2(0,0,0,90)
			end
			updateattachlist("Optics")
			switcher.Text=not onattach and "ATTACHMENTS" or "CHANGE GUN"
		end

		function selected(slot,ntype,openattach)
			if openattach then
				mainswitch("loadout")
			end
			if slot~=selectedslot then
				updategunmodel(slot=="Primary" and slotprim or slotside,slot)
				selectedslot=slot
			end
			if slot=="Primary" then
				primarybuttons.Visible=true
				for i=1,#primb do
					local v=primb[i]
					v.Text=gunclass[curclass][i]
				end
			else
				primarybuttons.Visible=false
			end
			switchgunatt(openattach,slot)
			updategunlist(slot,ntype)
			stat:update(require(gunmodules[slot=="Primary" and slotprim or slotside]),slot)
		end
		
		local function changeclass(v,goload)
			curclass=v
			classdata.curclass=v
			slotprim=classdata[curclass].Primary.Name
			slotside=classdata[curclass].Secondary.Name
			slotprimatt=classdata[curclass].Primary
			slotsideatt=classdata[curclass].Secondary
			updategunmodel(slotprim,"Primary")
			updateloadout()
			selected("Primary",gunclass[curclass][1])
			if yesconnection then yesconnection:disconnect() end
			if noconnection then noconnection:disconnect() end
			yesconnection=nil
			noconnection=nil
			confirm.Visible=false
		end
		
		updateloadout()
		selected("Primary",gunclass[curclass][1])
		stat:update(require(gunmodules[slotprim]),"Primary")
		
		for i=1,#primb do
			local v=primb[i]
			v.MouseButton1Click:connect(function()
				curtype=v.Text
				updategunlist("Primary")
			end)
		end
		
		for i=1,#classb do
			local v=classb[i]
			if rtype(v,"TextButton") then
				v.MouseButton1Click:connect(function()
					changeclass(v.Text,curclass==v.Text)
				end)
			end
		end
		
		for i=1,#classb2 do
			local v=classb2[i]
			v.MouseButton1Click:connect(function()
				changeclass(v.Text,true)
			end)
		end
		
		primfr.Edit.MouseButton1Click:connect(function() selected("Primary",gunclass[curclass][1],selectedslot=="Primary" and gunselection.Visible) end)
		primbut.MouseButton1Click:connect(function() selected("Primary",gunclass[curclass][1]) end)
		sidefr.Edit.MouseButton1Click:connect(function() selected("Secondary",gunclass["PISTOL"],selectedslot~="Primary" and gunselection.Visible) end)
		sidebut.MouseButton1Click:connect(function() selected("Secondary",gunclass["PISTOL"]) end)
		switcher.MouseButton1Click:connect(function() switchgunatt(gunselection.Visible) end)

		for i,v in next,attachprimlist do
			v.MouseButton1Click:connect(function() updateattachlist(v.Name) end)
		end
		for i,v in next,attachsidelist do
			v.MouseButton1Click:connect(function() updateattachlist(v.Name) end)
		end
	end
		
		
	do ---respawn/deploy/control submodule
		
		local spawnfr		=wfc(mainmenu,"Spawn")
		local location		=wfc(spawnfr,"Location")
		local imglist		={
			["Desert Storm"]			="rbxgameasset://Images/M1",
			["City Mall"]				="rbxgameasset://Images/M5",
			["Crane Site"]				="rbxgameasset://Images/M2",
			["Crane Site Revamp"]		="rbxgameasset://Images/M6",
			["Metro"]					="rbxgameasset://Images/M7",
			["Highway Lot"]				="rbxgameasset://Images/M3",
			["Ravod 911"]				="rbxgameasset://Images/M4",
		}
		
		local pref			=wfc(source,"player")
		local sref			=wfc(source,"spot")
		
		local spawnpos		=v3()
		local spawnobj
		
		local ranlist		=sref:Clone()
		local ranpick		=wfc(ranlist,"Pick")
		ranlist.Parent=location
		ranpick.Place.Text="RANDOM LOCATION"
		ranlist.Box.Text="?"
		

		function updatecontroltype(switch)
			if deploying then
				--chatbox.Visible=true
				guiservice.GuiNavigationEnabled=false
				controllermenu=false
				input.mouse:hide()
			elseif controllermenu then
				guiservice.GuiNavigationEnabled=true
				if switch then
					guiservice.SelectedObject=s.deploy
				end
				input.mouse:hide()
			elseif iswindows and layout.Visible then
				--chatbox.Visible=true
				input.mouse:show()
				guiservice.GuiNavigationEnabled=false
			end
		end
		
		local function squadspawnpos(guy)
			if not hud:isplayeralive(guy) or not guy.Character then return end
			local root=ffc(guy.Character,"HumanoidRootPart")
			if not root then return cf(root.CFrame*v3(0,-2,0)).p end
			camera:setlookvector(root.CFrame.lookVector)
			local rayback=ray(root.CFrame.p,root.CFrame.lookVector*-9)	
			local hit,pos=raycast(workspace,rayback,{root.Parent,ignore})
			if not hit or (hit and (root.CFrame.p-pos).Magnitude > 8) then
				return cf(root.CFrame*v3(0,0,6)).p
			end
			local rayright=ray(root.CFrame.p,(root.CFrame.p-root.CFrame*v3(1,0,0)).unit*-9)	
			local hit,pos=raycast(workspace,rayright,{root.Parent,ignore})
			if not hit or (hit and (root.CFrame.p-pos).Magnitude > 6) then
				return cf(root.CFrame*v3(5,0,0)).p
			end
			local rayleft=ray(root.CFrame.p,(root.CFrame.p-root.CFrame*v3(-1,0,0)).unit*-9)	
			local hit,pos=raycast(workspace,rayleft,{root.Parent,ignore})
			if not hit or (hit and (root.CFrame.p-pos).Magnitude > 6) then
				return cf(root.CFrame*v3(-5,0,0)).p
			end
			local rayfront=ray(root.CFrame.p,root.CFrame.lookVector*9)	
			local hit,pos=raycast(workspace,rayfront,{root.Parent,ignore})
			if not hit or (hit and (root.CFrame.p-pos).Magnitude > 8) then
				return cf(root.CFrame*v3(0,0,-6)).p
			end
			return cf(root.CFrame*v3(0,-2,0)).p
		end
		
		local function normalspawnpos()
			local random			=math.random
			local furthest			=0
			local bk				=player.TeamColor==BrickColor.new("Bright orange") and "R" or "B"
			local map				=ffc(workspace,"Map")
			local teleport			=ffc(map,"Teleport")
			local chosen			=teleport[bk.."1"]----fix
			local required			=250
			local approved

			if not pgui.teston.Value then
				repeat 	
					chosen=teleport[bk..math.random(1,10)]
					local pp=game.Players:GetChildren()
					local disapproved
					for i=1,#pp do
						local v=pp[i]
						if v.TeamColor~=player.TeamColor and hud:isplayeralive(v) and ffc(workspace,v.Name) and v.Character and v.Character.Parent then
							local ptor=ffc(v.Character,"HumanoidRootPart")
							if ptor then
								local dist=(ptor.Position-chosen.Position).magnitude
								if dist<required then
									disapproved=true
									required=required-4
								end
							end
						end
					end
					wait(.01)
					if not disapproved then approved=true end
				until approved
			end
			
			--print("Furthest distance for enemy is "..ceil(furthest).." studs at block " ..chosen.Name)
			return cf(chosen.Position+v3(0,3,0)).p
		end
		local tempdb
		local function deploy()
			if tempdb then return end
			if menu:isdeployed() or not allowspawn.Value or not ffc(workspace,"Map") then return end
			tempdb=true
			delay(3,function() tempdb=false end)
			local check=network:fetch("deploycheck",player,slotprim,slotside,"KNIFE",slotprimatt,slotsideatt)
			if not check then
				print("Player has hacked weapons")
				player:Kick("Exploited weapon loadout. Rejoin game and select what you own.")
			end

			deploying=true
			updatecontroltype()
			menu:hide()
			hud:updateteam()
			chat:ingame()
			loadmodules(slotprim,slotside,"KNIFE",slotprimatt,slotsideatt)
			spawnpos=spawnobj and squadspawnpos(spawnobj) or normalspawnpos()
			char:spawn(spawnpos,100,spawnobj)
			repeat wait(0.1) until gamelogic.currentgun and char.health>0
			camera.type="firstperson"
			hud:enablegamegui(true)	
			deploying=false
			if gamelogic.debugger then 
				wait(0.1)
				print("stopped at setequip current gun")
			else
				gamelogic.currentgun:setequipped(true)
			end
			lobby.Parent=nil
			spawnobj=nil
		end	

		function menu:isdeployed()
			return not layout.Visible
		end

		function menu:roundstartspawn()
			deploy()
		end
		
		function menu:updatestage()
			mode.Text=settings.GameMode.Value
			mapname.Text=settings.MapName.Value
			mapimg.Image=imglist[mapname.Text]
		end

		function menu:hide()
			local frs=menugui:GetChildren()
			for i=1,#frs do
				frs[i].Visible=false
			end
		end	
		
		function menu:loadmenu()

			---load player data
			local pdata					=playerdata:getdata()
			local pkills				=pdata.stats.totalkills or 0
			local pdeaths				=pdata.stats.totaldeaths or 0

			local totalexp				=pdata.stats.experience or 0
			local prevreq				=expcalculator(rankcalculator(pdata.stats.experience))
			local curreq				=expcalculator(rankcalculator(pdata.stats.experience)+1)-prevreq
			local curexp				=totalexp-prevreq

			expbar.Stat.Text			=curexp.."/"..curreq
			expbar.Bar.Percent.Size		=ud2(curexp/curreq,0,1,0)
			trank.Stat.Text				=rankcalculator(pdata.stats.experience)
			tkills.Stat.Text			=pkills
			tdeaths.Stat.Text			=pdeaths
			tkdr.Stat.Text				=pdeaths==0 and pkills or floor(pkills*100/pdeaths)/100
			
			---reload stuff
			menu:updatemoney(pdata.stats.money or 0)
			char:reloadsprings()
			chat:inmenu()
			hud:reloadhud()
			hud:enablegamegui(false)
			input.mouse:show()
			menu:hide()
			--layout.Music:Play()

			---remove stuff
			confirm.Visible=false
			if yesconnection then yesconnection:disconnect() end
			if noconnection then noconnection:disconnect() end
			yesconnection=nil
			noconnection=nil

			---reload settings
			selectedslot				="Primary"
			gamelogic.currentgun		=nil
			buyrobux.Visible			=false
			layout.Visible				=true
			mainmenu.Visible			=true
			
			---set up lobby
			lobby.Parent=game.Workspace--camera.currentcamera
			camera:setmenucam(lobby)
			updategunmodel(slotprim,selectedslot)
			switchgunatt(false)

			---set up loadout
			selected(selectedslot,gunclass[curclass][1])
			updateattachlist("Optics")

			---set up controller type
			updatecontroltype()
			if input.consoleon then
				controllermenu=true
				updatecontroltype(true)
			end

			---cleaning
			workspace.CurrentCamera:ClearAllChildren()
		end
		
		local function updatespawnlist()
			local list=location:GetChildren()
			for i=1,#list do
				local v=list[i]
				if v.Name=="player" then
					v.Pick.BackgroundColor3=color(0,0,0)
					v.Box1.BackgroundColor3=color(0,0,0)
					v.Box2.BackgroundColor3=color(0,0,0)
				elseif v.Name=="spot" then
					v.Pick.BackgroundColor3=color(0,0,0)
				end
			end
		end		
		
		function menu:refreshspawn()

			local lt=location:GetChildren()
			for i=1,#lt do
				local v=lt[i]
				if v~=ranlist then
					local p=ffc(game.Players,lt[i].Name)
					if p and p.Character then
						local head=ffc(p.Character,"Head")
						if not head or p.TeamColor~=player.TeamColor or not hud:isplayeralive(p) or (head.Position-workspace.Lobby["Spawn"..math.random(1,9)].Position).Magnitude<300 then
							v:Destroy()
						end
					else
						v:Destroy()
					end
				end
			end
			
			if not location then return end

			local count=0
			local ppl=game.Players:GetChildren()
			for i=1,#ppl do
				local v=ppl[i]
				if v.TeamColor==player.TeamColor and hud:isplayeralive(v) and not ffc(location,v.Name) and v.Character and v.Character.Parent then
					local head=ffc(v.Character,"Head")
					if head and (head.Position-workspace.Lobby["Spawn"..math.random(1,9)].Position).Magnitude>300 then
						local list=pref:Clone()
						local cur=spawnobj==v	
						list.Name=v.Name
						list.Pick.Player.Text=v.Name
						list.Parent=location
						list.Position=ud2(0,0,0,20*(count))
						
						list.Pick.BackgroundColor3=not cur and color(0,0,0) or color(1,1,1)
						list.Box1.BackgroundColor3=not cur and color(0,0,0) or color(1,1,1)
						list.Box2.BackgroundColor3=not cur and color(0,0,0) or color(1,1,1)
						
						list.Pick.MouseButton1Down:connect(function() 
							if deploying or not head or not ffc(list,"Pick") then return end
							if ffc(list.Pick,"DoubleClick") then
								deploy()
							else
								local dc=new("IntValue",list.Pick)
								dc.Name="DoubleClick"
								game.Debris:AddItem(dc,1)
								spawnobj=v
								updatespawnlist()
								list.Pick.BackgroundColor3=color(1,1,1)
								list.Box1.BackgroundColor3=color(1,1,1)
								list.Box2.BackgroundColor3=color(1,1,1)
								camera:setspectate(v,head)
							end
						end)
						count=count+1					
					end
				elseif ffc(location,v.Name) then
					local list=location[v.Name]
					local cur=spawnobj==v
					list.Position=ud2(0,0,0,20*(count))
					list.Pick.BackgroundColor3=not cur and color(0,0,0) or color(1,1,1)
					list.Box1.BackgroundColor3=not cur and color(0,0,0) or color(1,1,1)
					list.Box2.BackgroundColor3=not cur and color(0,0,0) or color(1,1,1)
					count=count+1
				end
			end
		
			if spawnobj and spawnobj.Character and ffc(workspace,spawnobj.Name) then
				local head=ffc(spawnobj.Character,"Head")
				if not head or (head.Position-workspace.Lobby["Spawn"..math.random(1,9)].Position).Magnitude<300 or not hud:isplayeralive(spawnobj) then
					camera:setmenucam(lobby)
					spawnobj=nil
				end
			end		

			ranpick.BackgroundColor3=spawnobj and color(0,0,0) or color(1,1,1)
			ranlist.Position=ud2(0,0,0,count*20)
		
		end
		
		ranpick.MouseButton1Down:connect(function() 
			if deploying then return end
			if ffc(ranlist.Pick,"DoubleClick") then
				deploy()
			else
				local dc=new("IntValue",ranpick)
				dc.Name="DoubleClick"
				game.Debris:AddItem(dc,1)
				spawnobj=nil
				updatespawnlist()  
				camera:setmenucam(lobby)
			end
		end)	

		guiservice:RemoveSelectionGroup(chatbox.Name)
		guiservice.Changed:connect(function() 
			if guiservice.SelectedObject==s.deploy and (menu:isdeployed() or not allowspawn.Value or not ffc(workspace,"Map")) then 
				s.deploy.Text="CANNOT DEPLOY YET"
			else 
				s.deploy.Text="DEPLOY" 
			end
			controllermenu=guiservice.SelectedObject 
			updatecontroltype()
		end)
		s.deploy.MouseButton1Click:connect(deploy)

		game:GetService("UserInputService").InputBegan:connect(function(keycode)
			local key=keycode.KeyCode
			if key==Enum.KeyCode.Space and not chatbox.Active and not menu:isdeployed() then	
				deploy()
			end
		end)

		s.deploy.MouseEnter:connect(function()
			if menu:isdeployed() or not allowspawn.Value or not ffc(workspace,"Map") then s.deploy.Text="CANNOT DEPLOY YET" end
		end)

		s.deploy.MouseLeave:connect(function() s.deploy.Text="DEPLOY" end)
		
	end

	do -- money module
		local prodlist={
			B10			=27310076,--test133727311922,--
			B100		=27310078,
			B1000		=27310080,
			B20			=27310085,
			B200		=27310087,
			B2000		=27310094,
			B50			=27310097,
			B500		=27310098,
			B5000		=27310099,
		}
		
		for i,v in next,prodlist do
			local bx=ffc(buyrobux,i)
			if bx then
				bx.MouseButton1Click:connect(function()
					game:GetService("MarketplaceService"):PromptProductPurchase(player,v)---omg this is the real shit here
				end)
			end
		end
		
		--[[b10.MouseButton1Click:connect(function() 
			--[==[antihack]==]network:send('b'..'u'..'y'..'m'..'o'..'n'..'e'..'y',player)
			--network:send("buymoney",player)
		end)]]
		
		buyrobux.Cancel.MouseButton1Click:connect(function() buyrobux.Visible=false end)
		moneyfr.Bar.Open.MouseButton1Click:connect(function() 
			buyrobux.Visible=not buyrobux.Visible 
			buyrobux.Title.Text="Credits Store"
			buyrobux.Title.TextColor3=color(1,1,1)
		end)
	end

	do -- options module 
		local controls		=wfc(mainoption,"Controls")
		local graphics		=wfc(mainoption,"Graphics")

		local datatable					=playerdata.getdata()
		local optiondata				=datatable.settings and datatable.settings.options
		if not optiondata then
			optiondata={
				LOOKSEN="B3",
				AIMSEN="B4",
				RENDER="Med",
			}
			print("no option data")
			playerdata.updateplayerdata(optiondata,"settings","options")
		end

		do --- look sensitivity
			local looksen		=wfc(controls,"LookSen")
			local b				=looksen:GetChildren()
			local sen			=optiondata.LOOKSEN--"B3" 
	
			local list		={
				B1			=2^-2;
				B2			=2^-1.5;
				B3			=2^-1;
				B4			=2^-0.5;
				B5			=2^0;
				B6			=2^0.5;
				B7			=2^1;
				B8			=2^1.5;
				B9			=2^2;
			}
						
			local function update()
				for i=1,#b do
					if rtype(b[i],"TextButton") then
						b[i].BackgroundColor3=sen==b[i].Name and color(225/255,135/255,0) or color(0,0,0)
					end
				end
				optiondata.LOOKSEN=sen
				playerdata.updateplayerdata(optiondata,"settings","options")
			end
	
			for i=1,#b do
				if rtype(b[i],"TextButton") then
					b[i].MouseButton1Click:connect(function() camera:setsensitivity(list[b[i].Name]) sen=b[i].Name update() end)
				end
			end
			camera:setsensitivity(list[sen])
			update()
		end

		do --- aimsensitivity
			local looksen		=wfc(controls,"AimSen")
			local b				=looksen:GetChildren()
			local sen			=optiondata.AIMSEN--"B4"

			local list		={
				B1			=2^-2;
				B2			=2^-1.5;
				B3			=2^-1;
				B4			=2^-0.5;
				B5			=2^0;
				B6			=2^0.5;
				B7			=2^1;
				B8			=2^1.5;
				B9			=2^2;
			}
						
			local function update()
				for i=1,#b do
					if rtype(b[i],"TextButton") then
						b[i].BackgroundColor3=sen==b[i].Name and color(225/255,135/255,0) or color(0,0,0)
					end
				end
				optiondata.AIMSEN=sen
				playerdata.updateplayerdata(optiondata,"settings","options")
			end
	
			for i=1,#b do
				if rtype(b[i],"TextButton") then
					b[i].MouseButton1Click:connect(function() camera.aimsensitivity=list[b[i].Name] sen=b[i].Name update() end)
					
				end
			end
			camera.aimsensitivity=list[sen]
			update()
		end

		do --- render settings
			local renderfr		=wfc(graphics,"SetRender")
			local low			=wfc(renderfr,"Low")
			local med			=wfc(renderfr,"Med")
			local high			=wfc(renderfr,"High")
			local ultra			=wfc(renderfr,"Ultra")
			local b				=renderfr:GetChildren()
			local settings		=optiondata.RENDER--"Med"

			local function update()
				for i=1,#b do
					if rtype(b[i],"TextButton") then
						b[i].BackgroundColor3=settings==b[i].Name and color(225/255,135/255,0) or color(0,0,0)
						
					end
				end
				optiondata.RENDER=settings
				playerdata.updateplayerdata(optiondata,"settings","options")
			end

			low.MouseButton1Click:connect(function() settings=low.Name replication.setrendergrade(1/10,1,false,1/20,1/10,false,1/30,1/30,false) update() end)
			med.MouseButton1Click:connect(function() settings=med.Name replication.setrendergrade(1/10,1,false,1/20,1/20,false,1/30,nil,true) update() end)
			high.MouseButton1Click:connect(function() settings=high.Name replication.setrendergrade(1/10,1,false,nil,1/30,true,nil,nil,true) update() end)
			ultra.MouseButton1Click:connect(function() settings=ultra.Name replication.setrendergrade(1/10,1,true,nil,nil,true,nil,nil,true) update() end)
			replication.setrendergrade(1/10,1,false,1/20,1/20,false,1/30,nil,true)
			update()--SET TO MED

		end		
	end

	spawn(function()
		if loadinggui.Frame.Visible then
			wait(10)
			loadinggui.Frame.Visible=false
			loadinggui.Warn.Visible=true
			wait(10)
		end
		loadinggui:Destroy()
	end)

	s.loadout.MouseButton1Click:connect(function() mainswitch("loadout") end)
	s.menu.MouseButton1Click:connect(function() mainswitch("menu") end)
	s.option.MouseButton1Click:connect(function() mainswitch("option") end)
	
	network:add("autodespawn",function()
		if gamelogic.currentgun then
			gamelogic.currentgun:setequipped(false,true)
		end
		menu:loadmenu()
		char:setmovementmode("stand")
	end)

	function menu.step()
		if run.time>lasttime+refreshint then
			menu:updatestage()
			lasttime=run.time+refreshint
			if intermission.Visible then
				intermission.Tip.Text=intermission.Tip.Text=="Waiting for next map to load..." and "Waiting for next map to load" or intermission.Tip.Text.."."
			end
		end
		intermission.Visible=not allowspawn.Value
		stage.Visible=allowspawn.Value
		menu:refreshspawn()
		if not menu:isdeployed() then
		input.mouse:show()---temporary
		end
			
	end
	
end






--roundsystem module
print("Loading roundsystem module")
do
	local rtype			=game.IsA
	local next			=next
	local new			=Instance.new
	local wfc			=game.WaitForChild
	local ffc			=game.FindFirstChild
	local getchildren	=game.GetChildren
	local workspace		=game.Workspace
	local cf			=CFrame.new
	local vtws			=CFrame.new().vectorToWorldSpace
	local angles		=CFrame.Angles
	local ud2			=UDim2.new
	local color			=Color3.new
	local bcolor		=BrickColor.new
	local v3			=Vector3.new
	local debris		=game.Debris
	local guiservice	=game:GetService("GuiService")
	local ray			=Ray.new
	local raycast		=workspace.FindPartOnRayWithIgnoreList
	local ceil			=math.ceil
	local floor			=math.floor

	local repstore		=game.ReplicatedStorage
	local settings		=repstore.ServerSettings
	local countdown		=settings.Countdown
	local timer			=settings.Timer
	local maxscore		=settings.MaxScore
	local gscore		=settings.GhostScore
	local pscore		=settings.PhantomScore
	local showresult	=settings.ShowResults
	local setquote		=settings.Quote
	local winner		=settings.Winner
	local gamemode		=settings.GameMode

	local player		=game.Players.LocalPlayer
	local pgui			=player.PlayerGui

	local main			=wfc(pgui,"MainGui")
	local countfr		=wfc(main,"CountDown")
	local teamname		=wfc(countfr,"TeamName")
	local title			=wfc(countfr,"Title")
	local number		=wfc(countfr,"Number")
	local tip			=wfc(countfr,"Tip")

	local gamegui		=wfc(main,"GameGui")
	local roundfr		=wfc(gamegui,"Round")
	local scorefr		=wfc(roundfr,"Score")
	local roundmode		=wfc(roundfr,"GameMode")
	local ghostfr		=wfc(scorefr,"Ghosts")
	local phantomfr		=wfc(scorefr,"Phantoms")
	local counting		=wfc(scorefr,"Time")

	local endfr			=wfc(main,"EndMatch")
	local quote			=wfc(endfr,"Quote")
	local result		=wfc(endfr,"Result")
	local gmode			=wfc(endfr,"Mode")

	local servertime	=0
	local lasttime		=0
	roundsystem.lock	=false

	local function spawnplayer()
		menu:roundstartspawn()
	end

	local function tweentransparency(obj,index,new,t)
		spawn(function()
			local cur=obj[index]
			for i=cur,new+t,t do
				obj[index]=i
				wait(1/30)
			end
		end)
	end

	function hud:updateteam()
		roundmode.Text=gamemode.Value
		if player.TeamColor==game.Teams.Phantoms.TeamColor then
			ghostfr.Position=ud2(0, 10,0, input.consoleon and 65 or 45)
			phantomfr.Position=ud2(0, 10,0, input.consoleon and 35 or 27)
		else
			phantomfr.Position=ud2(0, 10,0, input.consoleon and 65 or 45)
			ghostfr.Position=ud2(0, 10,0, input.consoleon and 35 or 27)
		end
	end
	
	local function updatescore()
		local ud2=UDim2.new
		ghostfr.Full.Percent.Size=ud2(gscore.Value/maxscore.Value,0,1,0)
		ghostfr.Full.Point.Text=gscore.Value
		phantomfr.Full.Percent.Size=ud2(pscore.Value/maxscore.Value,0,1,0)
		phantomfr.Full.Point.Text=pscore.Value
	end

	local function count()
		roundsystem.lock=true
		tip.Text=input.consoleon and "Press ButtonSelect to return to menu" or "Press F5 to return to menu"
		if timer.Value==10 and not menu:isdeployed() then
			--spawnplayer()
		end
		if menu:isdeployed() and char.health and char.health>0 then
			countfr.Visible=true
			number.FontSize=9
			number.Text=timer.Value
			for i = 9,7,-1 do
				number.FontSize=i
				wait(1/30)
			end
			if timer.Value==0 then
				wait(1)
				teamname.Text=player.TeamColor==game.Teams.Ghosts.TeamColor and "Ghosts" or "Phantoms"
				roundsystem.lock=false
				wait(2)
				countfr.Visible=false
			else
				countfr.BackgroundTransparency=0.5
				number.TextTransparency=0
				title.TextTransparency=0
				title.TextStrokeTransparency=0.5
			end
		end
	end

	local function matchclock()
		local seconds=timer.Value%60
		if seconds<10 then
			seconds="0"..seconds
		end
		counting.Text=floor(timer.Value/60)..":"..seconds
	end

	local function timerchange()
		if countdown.Value then
			counting.Text="COUNTDOWN"
			count()
		else
			if not showresult.Value then
				roundsystem.lock=false
			end
			countfr.Visible=false 
			matchclock()
		end
	end

	local function setresult()
		if showresult.Value then
			roundsystem.lock=true
			quote.Text=setquote.Value
			endfr.Visible=true
			gmode.Text=gamemode.Value
			if winner.Value==player.TeamColor then
				result.Text="VICTORY"
				result.TextColor=bcolor("Bright green")
			elseif winner.Value==bcolor("Black") then
				result.Text="STALEMATE"
				result.TextColor=bcolor("Bright orange")
			else
				result.Text="DEFEAT"
				result.TextColor=bcolor("Bright red")
			end
		else
			endfr.Visible=false
		end
	end

	if countdown.Value then count() end
	setresult()

	timer.Changed:connect(timerchange)
	gscore.Changed:connect(updatescore)
	pscore.Changed:connect(updatescore)
	showresult.Changed:connect(setresult)
	updatescore()
end










--run module
--
print("Loading run module")
do
	local cf			=CFrame.new
	local v3			=Vector3.new

	run.time			=tick()
	run.dt				=1/60
	run.framerate		=60
	run.onstep			={}
	run.onthink			={}

	local ffc			=game.FindFirstChild
	local tick			=tick
	local renderstepped	=game:GetService("RunService").RenderStepped
	local wait			=renderstepped.wait

	local p				=game.Players.LocalPlayer
	local daytime		=game.ReplicatedStorage.ServerSettings.TimeOfDay
	local gundrop		=workspace.Ignore.GunDrop

	local engine		={
		input.step;
		char.step;
		replication.step;
		camera.step;
		particle.step;
		char.animstep;
		char.lelelelelstep;
		tween.step;
		hud.step;
		menu.step;
		notify.step;
	}

	local mainlogic		={
		{	
			func			=function()
								if char.health and char.health>0 and gamelogic.currentgun then
									--[==[antihack]==]network:send('p'..'i'..'n'..'g'..'c'..'h'..'e'..'c'..'k',p,char.rootpart.Position)
									--network:send("pingcheck",p,char.rootpart.Position)
								end
								game.Lighting:SetMinutesAfterMidnight(daytime.Value)
							end;
			interval		=0.5;
			lasttime		=run.time;
		};
		{
			func			=function()
								local stuff=gundrop:GetChildren()
								local dist=8
								hud:gundrop(false)
								for i=1,#stuff do
									local v=stuff[i]
									local diff=(v.Position-char.rootpart.Position).magnitude
									if v.Name=="Dropped" and diff<dist and ffc(v,"Gun") then
										dist=diff
										hud:gundrop(v,v.Gun.Value)
									end
								end
							end;
			interval		=0.2;
			lasttime		=run.time;
		};
		{
			func			=function()
								local map=ffc(workspace,"Map")
								local dist=15
								hud:capping(false)
								if map then
									local agmp=ffc(map,"AGMP")
									if agmp then
										local stuff=agmp:GetChildren()
										for i=1,#stuff do
											local v=stuff[i]
											if ffc(v,"IsCapping") then
												if v.IsCapping.Value and v.TeamColor.Value~=p.TeamColor and (v.Base.Position-char.rootpart.Position).magnitude<(v.Name=="DomFlag" and 15 or v.Name=="KingFlag" and 20 or dist) and v.Base.Position.Y<char.rootpart.Position.Y then
													hud:capping(v,v.CapPoint.Value)
												end
											end
										end
									end
								end
							end;
			interval		=0.1;
			lasttime		=run.time;
		};
	}

	local fireonstep	=event.new(run.onstep)
	local fireonthink	=event.new(run.onthink)
	
	function run.wait()
		wait(renderstepped)
	end

	renderstepped:connect(function()
		local newtime=tick()
		run.dt=newtime-run.time
		run.time=newtime
		run.framerate=0.95*run.framerate+0.05/run.dt
		for i=1,#engine do
			engine[i](run.dt)
		end
		for i=1,#mainlogic do
			local v=mainlogic[i]
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


--gamelogic module
print("Loading game logic module")
do 
	local ffc				=game.FindFirstChild
	local debris			=game.Debris
	local new				=Instance.new

	local rep				=game.ReplicatedStorage
	local modulestore		=rep.GunModules
	local modelstore		=rep.GunModels
	local player			=game.Players.LocalPlayer
	local pgui				=player.PlayerGui
	local gunlist			={}
	local gunnumber			=1
	local attlist			={}
	local curknife,dived,jumping,aiming,equipping,prevgun,grenade,spotting,inspecting,sprintdisable
	
	gamelogic.currentgun	=nil
	gamelogic.gammo			=0

	local function switch(z)
		if not equipping and gamelogic.currentgun then
			gunnumber=z=="one" and 1 or z=="two" and 2 or (gunnumber+z-1)%#gunlist+1
			if gunlist[gunnumber] and gunlist[gunnumber]~=gamelogic.currentgun then
				gamelogic.currentgun=gunlist[gunnumber]
				gamelogic.currentgun:setequipped(true)
				equipping=true
				wait(0.4)
				equipping=false
			end
		end
	end
	
	function loadmodules(prim,side,knife,primatt,sideatt)
		char:loadarms(rep.Character["Left Arm"]:Clone(),rep.Character["Right Arm"]:Clone(),"Arm","Arm")
		for i=1,#gunlist do
			gunlist[i]=nil
			attlist[i]=nil
		end
		gunnumber=1
		local vprim=ffc(modulestore,prim)
		if vprim then
			local v=vprim:Clone()
			gunlist[1]=char:loadgun(require(v),require(rep.AttachmentModules.Info),modelstore[prim]:Clone(),false,false,primatt)
		end
		
		local vside=ffc(modulestore,side)
		if vside then
			local v=vside:Clone()
			gunlist[2]=char:loadgun(require(v),require(rep.AttachmentModules.Info),modelstore[side]:Clone(),false,false,sideatt)
		end
		
		local knife=knife or "KNIFE"
		local vknife=ffc(modulestore,knife)
		if vknife then
			local v=vknife:Clone()
			curknife=char:loadknife(require(v),modelstore[knife]:Clone())
		end
		gamelogic.currentgun=gunlist[gunnumber]
		gamelogic.gammo=3
	end

	function swapgun(gun,mag,spare,attachdata)
		if gamelogic.currentgun==curknife then return end
		local vgun=ffc(modulestore,gun)
		if vgun then
			local v=vgun:Clone()
			equipping=true
			gamelogic.currentgun:setequipped(false,true)
			wait(0.4)
			gunlist[gunnumber]=nil
			wait(0.1)
			gunlist[gunnumber]=char:loadgun(require(v),require(rep.AttachmentModules.Info),modelstore[gun]:Clone(),mag,spare,attachdata)
			gamelogic.currentgun=gunlist[gunnumber]
			gamelogic.currentgun:setequipped(true)
			wait(0.4)
			equipping=false
		end	
	end
		
	input.mouse.onbuttondown:connect(function(button)
		if not gamelogic.currentgun or equipping then return end
		if button=="left" and gamelogic.currentgun.shoot then
			if inspecting then gamelogic.currentgun:reloadcancel(true) inspecting=false end
			gamelogic.currentgun:shoot(true)
		elseif button=="right" then
			if gamelogic.currentgun.setaim and not inspecting then
				aiming=true
				gamelogic.currentgun:setaim(true)
			end
		end
	end)
	
	input.mouse.onscroll:connect(switch)
	
	input.mouse.onbuttonup:connect(function(button)
		if not gamelogic.currentgun then return end
		if button=="left" and gamelogic.currentgun.shoot then
			gamelogic.currentgun:shoot(false)
		elseif button=="right" then
			if gamelogic.currentgun.setaim then
				aiming=false
				gamelogic.currentgun:setaim(false)
			elseif gamelogic.currentgun.type=="KNIFE" then
				gamelogic.currentgun:shoot(false,"stab2")
			end
		end
	end)
	
	input.keyboard.onkeydown:connect(function(key)
		if not gamelogic.currentgun then return end
		if key=="space" and not jumping then
			jumping=true
			char:jump()
			wait(1)
			jumping=false
		elseif key=="c" then
			if char:sprinting() and not dived then
				dived=true
				char:setmovementmode("crouch",dived)
				wait(1.5)
				dived=false
			else
				char:setmovementmode(char.movementmode=="crouch" and "prone" or "crouch")
			end
		elseif key=="x" then
			if input.keyboard.down["leftshift"] and not dived then
				dived=true
				sprintdisable=true
				char:setmovementmode("prone",dived)
				wait(0.8)
				sprintdisable=false
				wait(1.5)
				dived=false
			else
				char:setmovementmode(char.movementmode=="crouch" and "stand" or "crouch")
			end
		elseif key=="leftcontrol" then
			char:setmovementmode("prone")
		elseif key=="z" then
			if input.keyboard.down["leftshift"] and not dived then
				dived=true
				sprintdisable=true
				char:setmovementmode("prone",dived)
				wait(0.8)
				sprintdisable=false
				wait(1.5)
				dived=false
			else
				char:setmovementmode("stand")
			end
		elseif key=="r" then
			if gamelogic.currentgun.reload then
				gamelogic.currentgun:reload()
			end
		elseif key=="e" then
			if gamelogic.currentgun.playanimation and not spotting then
				spotting=true
				inspecting=false
				local spotted=gamelogic.currentgun:playanimation("spot")
				if spotted then
					wait(5)
				else
					wait(1)
				end
				spotting=false
			end
		elseif key=="f" then
			if gamelogic.currentgun==curknife then gamelogic.currentgun:shoot() return end
			if curknife then
				prevgun=gamelogic.currentgun
				gamelogic.currentgun=curknife
			end
			gamelogic.currentgun:setequipped(true,true)
			equipping=true
			wait(0.7)
			if not input.keyboard.down.f then
				gamelogic.currentgun=prevgun
				gamelogic.currentgun:setequipped(true)
			end
			equipping=false
		elseif key=="g" then
			if not char.grenadehold and gamelogic.gammo>0 then
				prevgun=gamelogic.currentgun
				grenade=char:loadgrenade(require(modulestore["FRAG"]),modelstore["FRAG"]:Clone())
				grenade:setequipped(true)
				equipping=true
				wait(0.3)
				equipping=false
				grenade:pull()
			end
		elseif key=="h" then
			if aiming and gamelogic.currentgun.blackscope then return end
			if not char.grenadehold and not spotting and not inspecting then
				inspecting=true
				gamelogic.currentgun:playanimation("inspect")
				wait(6)
				inspecting=false
			end
		elseif key=="leftshift" then
			if aiming and gamelogic.currentgun.blackscope then return end
			if not sprintdisable then
				char:setsprint(true)
			end
		elseif key=="l" and input.keyboard.down.leftshift then
			hud:togglecinema()
		elseif key=="w" then
			if not ffc(pgui,"Doubletap") and not input.keyboard.down.leftshift then
				local db=new("Model")
				db.Name="Doubletap"
				db.Parent=pgui
				debris:AddItem(db,0.2)
			else
				if aiming and gamelogic.currentgun.blackscope then return end
				if not sprintdisable then
					char:setsprint(true)
				end
			end
		elseif key=="q" then
			if gamelogic.currentgun.setaim and not inspecting then
				aiming=not aiming
				gamelogic.currentgun:setaim(aiming)
			end
		elseif key=="p" then
			if input.mouse:visible() then
				input.mouse:hide()
			else
				input.mouse:show()
			end
		elseif key=="o" then
			print(gamelogic.currentgun)
			--[[if input.mouse:visible() then
				input.mouse:hide()
				input.mouse:lockcenter()
			else
				input.mouse:show()
				input.mouse:free()
			end]]
			--notify:testrankup(math.random(1,30))
			--input.consoleon=not input.consoleon
			--print("toggle",input.consoleon)
		elseif key=="k" and (player.Name=="litozinnamon" or player.Name=="Player" or game.CreatorId==0) then
			gamelogic.debugger=not gamelogic.debugger
			print("enabled gamelogic.debugger",gamelogic.debugger)
		elseif key=="t" then
			if gamelogic.currentgun.toggleattachment then
				gamelogic.currentgun:toggleattachment()
			end
		elseif key=="v" then
			if equipping then return end
			if hud:getuse() then
				if gamelogic.currentgun~=curknife then
					local gundrop=workspace.Ignore.GunDrop
					local stuff=gundrop:GetChildren()
					local dist=8
					local model
					for i=1,#stuff do
						local v=stuff[i]
						local diff=(v.Position-char.rootpart.Position).magnitude
						if v.Name=="Dropped" and diff<dist and ffc(v,"Gun") then
							dist=diff
							model=v
						end
					end
					if model then
						local gundata=gamelogic.currentgun
						local mag,spare,pos=gundata:dropguninfo()
						--[==[antihack]==]network:send('s'..'w'..'a'..'p'..'g'..'u'..'n',player,model,gundata.name,mag,spare,gundata.attachdata)
						--network:send("swapgun",player,model,gundata.name,mag,spare,gundata.attachdata)
					end
				end
			elseif gamelogic.currentgun.nextfiremode then
				gamelogic.currentgun:nextfiremode()
			end
		elseif key=="one" or key=="two" then
			switch(key)
		elseif key=="three" then
			if gamelogic.currentgun==curknife then return end
			if curknife then
				prevgun=gamelogic.currentgun
				gamelogic.currentgun=curknife
			end
			gamelogic.currentgun:setequipped(true)
			equipping=true
			wait(0.5)
			equipping=false
		end
	end)
	
	input.keyboard.onkeyup:connect(function(key)
		if not gamelogic.currentgun then return end
		if key=="leftshift" or (key=="w" and not input.keyboard.down.leftshift) then
			char:setsprint(false)
		end
	end)
	
	input.controller:map("a","space")
	input.controller:map("x","r")
	--input.controller:map("l1","leftshift")
	input.controller:map("r1","g")
	input.controller:map("up","h")
	input.controller:map("r3","f")
	input.controller:map("right","v")
	input.controller:map("down","e")
	
	input.controller.onbuttondown:connect(function(button)
		if not gamelogic.currentgun then return end
		if button=="b" then
			if char.movementmode=="crouch" then			
				char:setmovementmode("prone")
			else
				if char:sprinting() and not dived then
					dived=true
					char:setmovementmode("crouch",dived)
					wait(1.5)
					dived=false
				else
					char:setmovementmode("crouch")
				end
			end
		elseif button=="r2" and gamelogic.currentgun.shoot then
			if inspecting then gamelogic.currentgun:reloadcancel(true) inspecting=false end
			gamelogic.currentgun:shoot(true)
		elseif button=="l2" and gamelogic.currentgun.setaim and not spotting and not inspecting then
			aiming=true
			gamelogic.currentgun:setaim(true,true)
		elseif button=="l1" then
			if char.sprinting() and not dived then
				dived=true
				sprintdisable=true
				char:setmovementmode("prone",dived)
				wait(0.8)
				sprintdisable=false
				wait(1.5)
				dived=false
			else
				if gamelogic.currentgun.playanimation and not spotting then
					spotting=true
					local spotted=gamelogic.currentgun:playanimation("spot")
					if spotted then
						wait(5)
					else
						wait(1)
					end
					spotting=false
				end
			end
		elseif button=="y" then
			switch(1)
		elseif button=="left" then
			switch(-1)
		elseif button=="l3" then
			if not sprintdisable then
				char:setsprint(not char:sprinting())
			end
		end
	end)
	
	input.controller.onbuttonup:connect(function(button)
		if not gamelogic.currentgun then return end
		if button=="r2" then
			gamelogic.currentgun:shoot(false)
		elseif button=="l2" and gamelogic.currentgun.setaim then
			aiming=false
			gamelogic.currentgun:setaim(false)
		end
	end)
	
	run.onstep:connect(function()
		if not gamelogic.currentgun then return end
		if input.controller.down.b and input.controller.down.b+0.5<tick() and char.movementmode~="prone" then
			char:setmovementmode("prone")
		end
	end)
	
	char.oncharacterspawn:connect(function()
		gunlist={}
		menu:loadmenu()
	end)
	
	char.ondied:connect(function()
		gamelogic.currentgun:destroy()
		wait(5)
		menu:loadmenu()
		char:setmovementmode("stand")
	end)
	
	function dropgun(pos)
		if gamelogic.currentgun then
			local gundata=gamelogic.currentgun
			if gundata and gundata.dropguninfo then
				local mag,spare=gundata:dropguninfo()
				--[==[antihack]==]network:send('d'..'r'..'o'..'p'..'g'..'u'..'n',gundata.name,mag,spare,pos,gundata.attachdata)
				--network:send("dropgun",gundata.name,mag,spare,pos,gundata.attachdata)
				gamelogic.currentgun:setequipped(false,true)
			end
			gunlist={}
		end
	end
	
	network:add("dropgun",dropgun)
	network:add("swapgun",swapgun)
	--char:loadarms(rep.Character["Left Arm"],rep.Character["Right Arm"],"Arm","Arm")
	hud:reloadhud()
	menu:loadmenu()
end

game:GetService("UserInputService").InputBegan:connect(function(object)
	local type=object.UserInputType.Name
	if type=="Keyboard" then
		local key=string.lower(object.KeyCode.Name)
		if key==";" then
			camera.spectatetype=camera.spectatetype=="thirdperson" and "firstperson" or "thirdperson"
		end
	end
end)

-----------------------------------


--return {vector=vector,cframe=cframe,utility=utility,event=event,physics=physics,tween=tween,run=run}
print({vector=vector,cframe=cframe,utility=utility,event=event,physics=physics,tween=tween,run=run})