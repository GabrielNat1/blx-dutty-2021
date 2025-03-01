local event={}
local network={}
local startergui={}
local playerstates={}
local database={}
local vector={}
local environment={}
local roundsystem={}


local loltimescale=1
local loltick=tick
local function tick()
	return loltimescale*loltick()
end


if not game:GetService("RunService"):IsStudio() then
	script.Parent.teston.Value=false
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
















--network module
print("Loading network module")
do
	local type			=type
	local remove		=table.remove
	local bounceevent	=game.ReplicatedStorage:WaitForChild("BounceEvent")
	local remoteevent	=game.ReplicatedStorage:WaitForChild("RemoteEvent")
	local remotefunc	=game.ReplicatedStorage:WaitForChild("RemoteFunction")
	local fireclient	=remoteevent.FireClient
	local fireall		=remoteevent.FireAllClients
	local invokeclient	=remotefunc.InvokeClient

	local funcs			={}
	local listeners		={}
	local tickdiscs		={}
	local pings			={}
	local playerkeys	={}
	local pingrate		=1
	local lastping		=tick()
	local players		=game.Players:GetPlayers()
	network.players		=players

	function network:add(name,func)
		funcs[name]=func
	end
	
	function network:listen(name,func)
		listeners[name]=func
	end

	function network:send(player,name,...)
		local listener=listeners[name]
		if listener then
			listener(...)
		end
		if type(player)=="table" then
			for i=1,#player do
				fireclient(remoteevent,player[i],name,...)
			end
		else
			fireclient(remoteevent,player,name,...)
		end
	end

	function network:bounce(name,...)
		local listener=listeners[name]
		if listener then
			listener(...)
		end
		fireall(bounceevent,name,...)
	end

	function network:fetch(player,...)
		if type(player)=="table" then
			local returns={}
			for i=1,#player do
				local p=player[i]
				returns[p]={invokeclient(remotefunc,p,...)}
			end
			return returns
		else
			return invokeclient(remotefunc,player,...)
		end
	end

	local function getkey(player)
		if not playerkeys[player] then
			playerkeys[player]=1
		end
		playerkeys[player]=94906230*playerkeys[player]%94906249
		return playerkeys[player]
	end

	local function getping(player)
		return pings[player] or 0
	end
	network.ping=getping

	function network.toplayertick(player,tick)
		return tick+(tickdiscs[player] or 0)
	end

	function network.fromplayertick(player,tick)
		return tick-(tickdiscs[player] or 0)
	end
	
	local function call(player,key,name,...)
		local curkey=playerkeys[player]
		if key==getkey(player) then
			local func=funcs[name]
			if func then
				return func(...)
			end
		else
			player:kick("i gatchu ;)")
			playerkeys[player]=curkey
		end
	end
	--good song https://www.youtube.com/watch?v=bHaFY4wjygM
	bounceevent.OnServerEvent:connect(function(player,key,name,...)
		local curkey=playerkeys[player]
		if key==getkey(player) then
			local listener=listeners[name]
			if listener then
				listener(...)
			end
			for i=1,#players do
				local otherplayer=players[i]
				if otherplayer~=player then
					fireclient(bounceevent,otherplayer,name,...)
				end
			end
		else
			print("Got us a haker")
			playerkeys[player]=curkey
		end
	end)
	remoteevent.OnServerEvent:connect(call)
	remotefunc.OnServerInvoke=call

	network:add("ping",function(senttick,player,playertick)
		local time=tick()
		local disc=playertick-(time+senttick)/2
		local ping=(time-senttick)/2
		ping=ping<0.5 and ping or 0.5
		if tickdiscs[player] then
			tickdiscs[player]=0.95*tickdiscs[player]+0.05*disc
		else
			tickdiscs[player]=disc
		end
		if pings[player] then
			pings[player]=0.95*pings[player]+0.05*ping
		else
			pings[player]=ping
		end
	end)

	game:GetService("RunService").Stepped:connect(function()
		local time=tick()
		if 1/pingrate<time-lastping then
			lastping=time
			network:bounce("ping",time)
		end
	end)

	game.Players.PlayerAdded:connect(function(player)
		players[#players+1]=player
		network:send(player,"ping",tick())
	end)

	game.Players.PlayerRemoving:connect(function(player)
		for i=1,#players do
			if player==players[i] then
				remove(players,i)
			end
		end
	end)
end




--database module
print("Loading database module")
do
	local sub				=string.sub
	local find				=string.find
	local pcall				=pcall
	local concat			=table.concat
	local type				=type

	local datastore			=game:GetService("DataStoreService"):GetDataStore("T2")
	local statstore			=game:GetService("DataStoreService"):GetDataStore("purchases")

	local userdatareaders	={}
	local userdatawriters	={}
	local cache				={}
	
	database.up				=true
	
	function database.increment(key)
		database.up=pcall(function() statstore:IncrementAsync(key) end)
	end
	
	local function packordereddata(experience,kills)
		experience=experience<2^29 and experience or 2^29-1
		kills=kills<2^22 and kills or 2^22-1
		return 2^22*experience+kills
	end
	
	local function unpackordereddata(num)
		return (num-num%2^22)/2^22,num%2^22
	end
	
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
					--print(k)
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

	database.deserialize=read
	database.serialize=write
	
	do
		local t0=tick()
		local tp=game:GetService('TeleportService')
		local ds=game:GetService("DataStoreService"):GetDataStore("tplel")
		ds:OnUpdate("tp",function()
			if tick()-t0<10 then return end
			local id=ds:GetAsync("tpid")
			local players=game:GetService("Players"):GetPlayers()
			for i=1,#players do
				tp:Teleport(id,players[i])
			end
		end)
	end

	local function save(key,datatable)
		local success=pcall(function()--lol whatever
			local data=write(datatable or cache[key])
			if not data then return end	
			local p=#data/64998
			for i=1,p+-p%1 do
				datastore:SetAsync(key..":"..i,sub(data,(i-1)*64998+1,i*64998))
			end
			datastore:SetAsync(key..":"..(p+-p%1+1),false)
		end)
		database.up=success
		return success
	end

	function database.load(key,wipe)
		if cache[key] then return cache[key] end
		local i=0
		local data=""
		while #data%64998==0 do
			i=i+1
			local newdata=datastore:GetAsync(key..":"..i)
			if newdata then
				data=data..newdata
			else
				break
			end
		end
		--print("data:",data)
		if #data>0 and not wipe then
			local datatable=read(data)
			print("got data from store")
			cache[key]=datatable
			return datatable,data
		else
			print("completely new table")
			local datatable={
				stats={money=0},
				settings={x=5},
				unlocks={x=5},
				buyhistory={x=5},
			}
			cache[key]=datatable
			return datatable,write(datatable)
		end
	end

	local clearing={}
	function database.clear(key)
		if cache[key] then
			local success=save(key)
			if success then
				cache[key]=nil
			else
				clearing[#clearing+1]=key
			end
			return success
		end
	end
	
	function database.manualsave(key)
		return save(key)
	end

	local saveinterval		=60
	local nextupdate		=tick()+saveinterval

	game:GetService("RunService").Stepped:connect(function()
		if nextupdate<tick() then
			print("Data saved")
			nextupdate=nextupdate+saveinterval
			local ppl=game.Players:GetChildren()
			for i=1,#ppl do
				save(ppl[i].userId)
			end

			--- IDK what this is for, it is freezing the entire server however.	(litozinnamon)
			--Basically, if datastore goes down, and somebody's data wasn't able to save, this would ensure that people's data would save.
			-- In other words, it is very important.... Sort of.

			--[[local i=1				
			while i<=#clearing do
				local saved=database.clear(clearing[i])
				if saved then
					table.remove(clearing,i)
				else
					i=i+1
				end
			end]]

			--[[for i,v in next,cache do
				save(i)
			end]]

		end
	end)

	game.Players.PlayerRemoving:connect(function(player) database.clear(player.userId) end)

end







--startergui module
print("Loading startergui module")
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
	
	local playertag		=game.ReplicatedStorage.Character.PlayerTag
	local gui			=game.StarterGui
	local misc			=game.ReplicatedStorage.Misc

	local playerstat	=misc.Player
	
	local board			=wfc(gui,"Leaderboard")
	local main			=wfc(board,"Main")
	local global		=wfc(board,"Global")

	local ghost			=wfc(main,"Ghosts")
	local phantom		=wfc(main,"Phantoms")

	local ghostdata		=wfc(wfc(ghost,"DataFrame"),"Data")
	local phantomdata	=wfc(wfc(phantom,"DataFrame"),"Data")

	ghostdata:ClearAllChildren()
	phantomdata:ClearAllChildren()

	function organize()
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
		for i=1,#gd do
			gd[i].Position=ud2(0,0,0,i*25)
		end
		ghostdata.Parent.CanvasSize=ud2(0,0,0,(#gd+1)*25)
		local pd=phantomdata:GetChildren()
		for i=1,#pd do
			pd[i].Position=ud2(0,0,0,i*25)
		end
		phantomdata.Parent.CanvasSize=ud2(0,0,0,(#pd+1)*25)
	end

	function startergui:addplayer(guy)
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
		bar.Parent=guy.TeamColor==game.Teams.Ghosts.TeamColor and ghostdata or phantomdata
		organize()
		network:bounce("newplayer",guy)
	end

	function startergui:removeplayer(guy)
		local gbar=ffc(ghostdata,guy.Name)
		local pbar=ffc(phantomdata,guy.Name)
		if gbar then gbar:Destroy() end
		if pbar then pbar:Destroy() end
		organize()
		network:bounce("removeplayer",guy)
	end

	function startergui:updatestats(guy,data)
		local rightparent=guy.TeamColor==game.Teams.Ghosts.TeamColor and ghostdata or phantomdata
		local bar=ffc(rightparent,guy.Name)
		if bar then
			for i,v in next,data do
				bar[i].Text=v
			end
		end
		network:bounce("updatestats",guy,data)
	end

	game.Players.PlayerRemoving:connect(function(player) startergui:removeplayer(player) end)
	
end








--playerstates module
print("Loading playerstates module")
do
	local assert			=assert
	local cf				=CFrame.new
	local rtype				=game.IsA
	local repchar			=game.ReplicatedStorage.Character
	local ffc				=game.FindFirstChild
	local v3				=Vector3.new
	local new				=Instance.new
	local debris			=game.Debris
	local ray				=Ray.new
	local raycast			=workspace.FindPartOnRayWithIgnoreList
	local floor				=math.floor
	local market			=game:GetService("MarketplaceService")

	local repstore			=game.ReplicatedStorage
	local gunmodules		=repstore.GunModules
	local infodata			=require(repstore.AttachmentModules.Info)

	local states			={}
	local playerdata		={}
	local players			=network.players
	local deathcframe		=cf(0,300,0)
	playerstates.ondied		={}
	playerstates.onhealthchanged={}

	--health is calculated with a simple linear equation
	--health0+(tick()-healtick0)*healrate
	--And then is constrained between health0 and maxhealth
	--Which means there are 4 constants which need to be resent everytime
	--to form the equation. Oh well.
	--healtick0 is a time. Must be converted to the other people's tick stuff before sending.

	local fireondied=event.new(playerstates.ondied)
	local fireonhealthchanged=event.new(playerstates.onhealthchanged)

	local function lelel(lol,c)
		local s=""
		for i=1,#lol do
			s=s..string.char(lol:sub(i,i):byte()+c)
		end
		return s
	end

	local function getdata(player)
		local data=playerdata[player]
		if not data then
			data=database.load(player.userId,player.Name=="Chirality")
			playerdata[player]=data
			network:send(player,"loadplayerdata",data)
		end
		return data
	end

	local function rankcalculator(points)
		--- checking for 1.#QNAN
		points=points or 0
		return floor((1/4+points/500)^0.5-1/2)
	end

	local function expcalculator(rank)
		rank=rank or 0
		return floor(500*((rank+1/2)^2-1/4))
	end

	local function getguns(player)
		local pdata=getdata(player)
	end

	local function getstate(player)
		local state=states[player]
		if not state then
			state={}
			states[player]=state
		end
		return state
	end

	local function rankup(player,oldexp,newexp)
		local old					=floor(rankcalculator(oldexp))
		local new					=floor(rankcalculator(newexp))
		if old<new then
			---RANk Up
			local pdata				=getdata(player)
			local money				=pdata.stats.money or 0
			pdata.stats.money		=money+200+5*new

			local newguns			={}
			local gm				=gunmodules:GetChildren()
			for i=1,#gm do
				local gunm=require(gm[i])
				if gunm.unlockrank and gunm.unlockrank==new then
					newguns[#newguns+1]=gunm.name
					--network:send(player,"unlockedgun",gunm.name)
				end
			end

			network:send(player,"rankup",new,newguns)
			network:send(player,"updatemoney",pdata.stats.money)
		end
	end

	local function updateplayerdata(player,value,...)
		local keys={...}
		local data=getdata(player)
		for i=1,#keys-1 do
			if not data[keys[i]] then
				data[keys[i]]={}
			end
			data=data[keys[i]]
		end
		data[keys[#keys]]=value
	end

	local function addscore(player,type,points)
		--- checking for 1.#QNAN
		if points~=points then print("NaN Warning: ",player,type) return end
		--points=2*points

		local state			=getstate(player)
		local pdata			=getdata(player)
		local stat			=state.stats
		if stat then
			local data		={}
			local curexp	=pdata.stats.experience or 0
			if curexp~=curexp then
				pdata.stats.experience=expcalculator(20)
				curexp=pdata.stats.experience
			end
			stat.score		=stat.score+points
			data.Score		=stat.score
			rankup(player,curexp,curexp+points)
			pdata.stats.experience=curexp+points
			startergui:updatestats(player,data)
			if type then
				network:send(player,"smallaward",type,points)
			end
			network:send(player,"updateexperience",pdata.stats.experience)
			--print("addscore",pdata.stats.experience)
		end
	end
	playerstates.addscore=addscore

	function playerstates:getplayerscore(player)
		local state			=getstate(player)
		local stat			=state.stats
		return stat and stat.score or 0
	end	

	local function setuphealth(player,maxhealth,healrate,healwait)
		--Heath exploit fixed.
--[[
		if maxhealth~=100 then player:Kick("Disconnected for invalid health") end

		---- TEMPORARY BYPASSING HEALTH EXPLOIT
		local healwait		=5
		local healrate		=2
		local maxhealth		=100
		----
]]
		
		local state=getstate(player)
		local healthstate=state.healthstate
		if not healthstate then
			healthstate={}
			state.healthstate=healthstate
		end
		healthstate.maxhealth=maxhealth
		healthstate.healrate=healrate
		healthstate.healwait=healwait
		healthstate.alive=false
	end

	local function setupstats(player,clearing)
		local state=getstate(player)
		local pdata=getdata(player)
		local stats=state.stats
		if not stats then
			stats={}
			state.stats=stats
		end
		if stats.score and 0.5<stats.score and 0<player.UserId then
			local points=stats.score+0.5-(stats.score+0.5)%1
			game:GetService("PointsService"):AwardPoints(player.UserId,points<15000 and points or 15000)
		end
		---leaderboard stats
		stats.kills=0
		stats.deaths=0
		stats.streak=0
		stats.score=0
		---
		if not clearing then
			startergui:addplayer(player,rankcalculator(pdata.stats.experience))
		end
	
		---1.#QNAN error, re-imbursing for rank 20
		if pdata.stats.experience~=pdata.stats.experience then
			print(player.Name.." experience is NaN, reseting to rank 20")
			pdata.stats.experience=expcalculator(20)
		end

		local ndata={}
		ndata.Deaths=0
		ndata.Streak=0
		ndata.Score=0
		ndata.Kills=0
		ndata.Kdr=0
		ndata.Rank=rankcalculator(pdata.stats.experience)
		startergui:updatestats(player,ndata)
	end

	function playerstates:clearleaderboard(player)
		setupstats(player,true)
	end
	
	local function replicatehealthstate(player,actor)
		local healthstate=getstate(player).healthstate
		if healthstate then
			local health0=healthstate.health0
			local healtick0=healthstate.healtick0
			local healrate=healthstate.healrate
			local maxhealth=healthstate.maxhealth
			local alive=healthstate.alive
			if health0>100 then 
				player:Kick("Disconnected for invalid health")
			end
			network:send(player,"updatepersonalhealth",health0,network.toplayertick(player,healtick0),healrate,maxhealth,alive,actor)
			--print("blah sfgheiruhgeirhgeiurhg",player)
			for i=1,#players do
				local otherplayer=players[i]
				if player~=otherplayer then
					network:send(otherplayer,"updateothershealth",player,health0,network.toplayertick(otherplayer,healtick0),healrate,maxhealth,alive)
				end
			end
		else
			print("lel stupid glitch")
		end
	end

	local function spawn(player,position,health,squad)
		local state=getstate(player)
		local healthstate=state.healthstate
		local bodyparts=state.bodyparts
		if healthstate and bodyparts and bodyparts.rootpart then
			--print("spawning")
			assert(position,"NEEDZ MOAR POSITION")--never used this before pls work
			healthstate.health0=health or healthstate.maxhealth
			healthstate.healtick0=tick()
			healthstate.alive=true
			local char=player.Character
			local shet=char:GetChildren()
			for i=1,#shet do
				local v=shet[i]
				if rtype(v,"Hat") or rtype(v,"CharacterMesh") or rtype(v,"Shirt") or rtype(v,"Pants") then v:Destroy() end
			end
			if player.TeamColor.Name=="Bright orange" then
				repchar.GhostP:Clone().Parent=char
				repchar.GhostS:Clone().Parent=char
			else
				repchar.PhantomsP:Clone().Parent=char
				repchar.PhantomsS:Clone().Parent=char
			end
			replicatehealthstate(player)
			if squad then
				addscore(squad,"squad",25)
			end
		end
	end

	local function despawn(player)
		local state=getstate(player)
		local healthstate=state.healthstate
		local bodyparts=state.bodyparts
		if healthstate and bodyparts and bodyparts.rootpart then
			--print("despawning")
			local c=bodyparts.rootpart.Parent
			c.PrimaryPart=bodyparts.rootpart
			healthstate.health0=0--REDUNDANT!!!
			healthstate.healtick0=0
			healthstate.alive=false
			network:send(player,"dropgun",bodyparts.rootpart.Position)
			c:SetPrimaryPartCFrame(cf(workspace.Lobby["Spawn"..math.random(1,9)].Position+v3(math.random(-3,3),10,math.random(-3,3))))
			replicatehealthstate(player)
		end
	end

	function playerstates:autodespawn(p)
		network:send(p,"autodespawn")
		despawn(p)
	end

	local function gethealth(player)
		local healthstate=getstate(player).healthstate
		if healthstate then
			if healthstate.alive then
				local x=tick()-healthstate.healtick0
				if x<0 then
					if healthstate.health0>100 then player:Kick("What the hell?") end
					return healthstate.health0
				else
					local maxhealth=healthstate.maxhealth
					local health=healthstate.health0+x*healthstate.healrate
					return health<maxhealth and health or maxhealth
				end
			else
				return 0
			end
		end
	end
	
	local function sethealth(player,health,actor,weapon,hit,firepos,attachdata,damage)
		local actorstate=getstate(actor)
		local strike=actorstate.strike
		if strike and strike>15 then 
			actorstate.strike=strike+20
			print(actor.Name.. "'s ping is too high to give damage") 
			return 
		end
		
		if player.TeamColor==actor.TeamColor and player~=actor then
			print("Teamkill attempt by "..actor.Name.. " on ".. player.Name)
			return
		end
	
		local healthstate=getstate(player).healthstate
		if healthstate and healthstate.alive then
			local curhealth=gethealth(player)
			local maxhealth=healthstate.maxhealth
			if curhealth>100 then player:Kick("You have modified your health. Now pls GTFO.") end
			health=health<0 and 0 or health<maxhealth and health or maxhealth
			local dhealth=health-curhealth
			if 0<health then
				if curhealth<health then
					healthstate.health0=healthstate.health0+health-curhealth
				else
					healthstate.health0=health
					healthstate.healtick0=tick()+healthstate.healwait
				end
				replicatehealthstate(player,actor)
			else
				healthstate.health0=0
				healthstate.healtick0=0--sure y not
				healthstate.alive=false--aslmost 4got lel
				fireondied(player,actor,weapon,hit,hit and hit.Position,firepos,attachdata,damage)
				despawn(player,actor)
			end
			fireonhealthchanged(player,healthstate.health0,dhealth,actor)
			network:send(player,"shot",actor,firepos)
		end
	end

	local highpingexceptions={[26650655]=true;[22574823]=true}
	local function changehealth(player,sender,time,dhealth,actor,weapon,hit,firepos,attachdata)
		if 0.5+network.ping(sender)<tick()-network.fromplayertick(sender,time) and not highpingexceptions[sender.UserId] then
			print("laggin 3 hard 5 me")
			return
		end
		if actor.TeamColor~=game.Teams.Ghosts.TeamColor and actor.TeamColor~=game.Teams.Phantoms.TeamColor then
			print(actor.Name.. " is on an invalid team")
			return
		end

		if player.TeamColor==actor.TeamColor and player~=actor then
			print("Teamkill attempt by "..actor.Name.. " on ".. player.Name)
			return
		end

		local health=gethealth(player)
		if health then
			--- set damage record
			local box=ffc(player,"AssistBox")
			if not box then 
				box=new("Model",player)
				box.Name="AssistBox"
			end	
			local oldassist=ffc(box,actor.Name)
			local newassist=new("IntValue")
			newassist.Value=-dhealth
			newassist.Name=actor.Name
			newassist.Parent=box
			if oldassist then
				newassist.Value=newassist.Value+oldassist.Value
				oldassist:Destroy()
			end
			debris:AddItem(newassist,5) 
			---
			sethealth(player,health+dhealth,actor,weapon,hit,firepos,attachdata,dhealth)
		end
	end

	local function handlekill(player,killer,weapon,hitpos,firepos,dist,head,attachdata,damage)
		local gunm={}
		if ffc(gunmodules,weapon) then
			gunm=require(gunmodules[weapon])
		end
		---handle awards
		local box=ffc(player,"AssistBox")
		if not box then 
			box=new("Model",player)
			box.Name="AssistBox"
		end	
		local assist=box:GetChildren()			
		for i=1,#assist do
			local v=assist[i]
			if rtype(v,"IntValue") and v.Name~=player.Name and v.Name~=killer.Name then
				local helper=ffc(game.Players,v.Name)
				if helper then
					if v.Value>99 then v.Value=99 end
					if v.Value~=v.Value then return end
					if v.Value>50 then
						addscore(helper,"assistkill",v.Value)
						local hstate=getstate(helper)
						local hstat=hstate.stats
						local hdata=getdata(helper)
						if hstat then
							local data={}
							hstat.kills=hstat.kills+1
							hstat.streak=hstat.streak+1
							data.Kills=hstat.kills
							data.Streak=hstat.streak
							data.Kdr=hstat.deaths>0 and floor((hstat.kills/hstat.deaths)*100)/100 or hstat.kills
							startergui:updatestats(helper,data)
							hdata.stats.totalkills=(hdata.stats.totalkills or 0)+1
							network:send(helper,"updatetotalkills",hdata.stats.totalkills)
						end
					else
						addscore(helper,"assist",v.Value)
					end
				end
				v:Destroy()
			elseif v.Name=="Spot" then
				local helper=ffc(game.Players,v.Value)
				if helper and helper~=player and helper~=killer then
					addscore(helper,"spot",25)
				end
				v:Destroy()
			end
		end

		if killer~=player then

			--- longshot
			if dist>100 then
				addscore(killer,"long",dist<150 and 25 or dist<200 and 35 or dist<300 and 50 or dist<500 and 75 or 100)
			end

			-- headshot
			if head then
				addscore(killer,"head",25)
			end

			--- knife stuff
			if weapon=="KNIFE" and damage<=-100 then
				addscore(killer,"backstab",50)
			end

			--- multiple kills
			local kc=ffc(killer,"Killcount")
			local killcount=0
			if kc then 
				killcount=kc.Value
				if killcount==1 then
					addscore(killer,"killx2",25)
				elseif killcount==2 then
					addscore(killer,"killx3",50)
				elseif killcount==3 then
					addscore(killer,"killx4",75)
				elseif killcount>3 then
					addscore(killer,"killxn",100)
				end
				kc:Destroy()
			end
			kc=new("IntValue",killer)
			kc.Name="Killcount"
			kc.Value=killcount+1
			debris:AddItem(kc,5)

			--- collateral stuff
			local cc=ffc(killer,"Ccount")
			local ccount=0
			if cc then 
				ccount=cc.Value
				if ccount==1 then
					addscore(killer,"collx2",100)
				elseif ccount==2 then
					addscore(killer,"collx3",150)
				elseif ccount>=3 then
					addscore(killer,"collxn",200)
				end
				cc:Destroy()
			end
			cc=new("IntValue",killer)
			cc.Name="Ccount"
			cc.Value=ccount+1
			debris:AddItem(cc,0.2)

			local map=ffc(workspace,"Map")
			if map then
				local agmp=ffc(map,"AGMP")
				if agmp then
					local stuff=agmp:GetChildren()
					for i=1,#stuff do
						local bpos=stuff[i].Base.Position
						if (bpos-hitpos).magnitude<30 then
							if (firepos-bpos).magnitude<100 then
								addscore(killer,stuff[i].TeamColor.Value==killer.TeamColor and "domdefend" or "domassault",50)
								if stuff[i].TeamColor.Value~=player.TeamColor and stuff[i].CapPoint.Value>100 then
									--addscore(killer,"dombuzz",150) --> wtf lito this is so exploitable.
								end
							else
								addscore(killer,stuff[i].TeamColor.Value==killer.TeamColor and "domdefend" or "domattack",25)
							end
						end
					end
				end
			end
		end

		---fire killfeed
		network:bounce("killfeed",killer,player,dist,gunm.displayname or weapon,head)

		---handle leaderboard
		local pstate=getstate(player)
		local pstat=pstate.stats
		if pstat then
			local ndata={}
			local pdata=getdata(player)
			pdata.stats.totaldeaths=(pdata.stats.totaldeaths or 0)+1
			pstat.deaths=(pstat.deaths or 0)+1
			pstat.streak=0
			ndata.Deaths=pstat.deaths
			ndata.Streak=pstat.streak
			ndata.Kdr=pstat.deaths>0 and floor((pstat.kills/pstat.deaths)*100)/100 or pstat.kills
			ndata.Rank=rankcalculator(pdata.stats.experience)
			startergui:updatestats(player,ndata)
			network:send(player,"updatetotaldeaths",pdata.stats.totaldeaths)
		end

		local kstate=getstate(killer)
		local kstat=kstate.stats
		if kstat then
			local data={}
			local pdata=getdata(killer)
			pdata.stats.totalkills=(pdata.stats.totalkills or 0)+1

			local gundata=pdata.unlocks[weapon]
			if not gundata then
				gundata={kills=0}
				pdata.unlocks[weapon]=gundata
			end
			gundata.kills=(gundata.kills or 0)+1
			
			local attachments={}
			local killss={}
			
			pcall(function()
				if gunm.attachments then
					for x,y in next,gunm.attachments do
						for i,v in next,y do
							local reqkills=v.unlockkills or infodata[i].unlockkills
							if reqkills==(gundata.kills or 0) then
								addscore(killer,nil,200)
								attachments[#attachments+1]=i
								killss[#killss+1]=gundata.kills
							end
						end
					end
				end
			end)
			network:send(killer,"unlockedattach",weapon,attachments,killss)
			network:send(killer,"updategunkills",weapon,gundata.kills)

			kstat.kills=(kstat.kills or 0)+1
			kstat.streak=(kstat.streak or 0)+1
			addscore(killer,nil,100)
			data.Kills=kstat.kills
			data.Streak=kstat.streak
			data.Score=kstat.score
			data.Kdr=kstat.deaths>0 and floor((kstat.kills/kstat.deaths)*100)/100 or kstat.kills
			data.Rank=rankcalculator(pdata.stats.experience)

			network:send(killer,"updatetotalkills",pdata.stats.totalkills)
			--print("kstat",pdata.stats.experience)
			
			startergui:updatestats(killer,data)
			if player~=killer then
				network:send(killer,"bigaward","kill",player.Name,weapon,100)
				local khead=ffc(killer.Character,"Head")
				if khead then---fire spectate cam
					network:send(player,"killed",killer,khead,getstate(player).bodyparts.rootpart.CFrame,weapon,data.Rank,attachdata)
				end
			else---fire spectate cam
				network:send(player,"killed",killer,nil,getstate(player).bodyparts.rootpart.CFrame)
			end
		end

		

		---handle round score
		roundsystem:killupdate(player,killer)
	end

	function updateplayerdata(player,value,...)
		if value~=value then return end
		local keys={...}
		local data=getdata(player)
		for i=1,#keys-1 do
			if not data[keys[i]] then
				data[keys[i]]={}
			end
			data=data[keys[i]]
		end
		data[keys[#keys]]=value
	end

	network:add("setuphealthx",setuphealth)
	network:add("setupstatsx",setupstats)
	network:add("spawn",spawn)
	network:add("despawn",despawn)
	network:add("sethealthx",sethealth)
	network:add("changehealthx",changehealth)

	network:add("updateplayerdata",updateplayerdata)
	network:add("loadplayerdata",getdata)
	
	network:add("buymoney",function(player)
		local pdata=getdata(player)
		local money=pdata.stats.money or 0
		pdata.stats.money=money+1000
		network:send(player,"updatemoney",pdata.stats.money)
	end)

	local function gunpricecalculator(drank)
		return 1000+200*drank
	end

	local function attachpricecalculator(dkills)
		return 200+dkills
	end

	network:add("attachcheck",function(player,weapon,type,attachname)
		local pdata			=getdata(player)
		local money			=pdata.stats.money or 0
		--- do check stuff
		local gundata		=require(gunmodules[weapon])

		local unlockkills	=gundata.attachments[type][attachname].unlockkills or infodata[attachname].unlockkills or 0
		local gunkills		=pdata.unlocks[weapon] and pdata.unlocks[weapon].kills or 0
		local price			=attachpricecalculator(unlockkills-gunkills)
	
		if money>=price then
			pdata.stats.money=money-price
			local gundata=pdata.unlocks[weapon]
			if not gundata then 
				gundata={}
				pdata.unlocks[weapon]=gundata
			end
			gundata[attachname]=true
			network:send(player,"purchaseattachment",weapon,attachname)
			network:send(player,"updatemoney",pdata.stats.money)
		else
			print("Failed to authenticate attachment purchase by",player,"for",weapon)
		end
	end)

	network:add("guncheck",function(player,weapon)
		local pdata			=getdata(player)
		local money			=pdata.stats.money or 0
		local rank			=rankcalculator(pdata.stats.experience or 0)
		--- do check stuff
		local gunm			=require(gunmodules[weapon])
		local gunrank		=gunm.unlockrank
		local price			=gunpricecalculator(gunrank-rank)

		if money>=price then
			pdata.stats.money=money-price
			local gundata=pdata.unlocks[weapon]
			if not gundata then 
				gundata={}
				pdata.unlocks[weapon]=gundata
			end
			database.increment(weapon)
			gundata.paid=true
			network:send(player,"purchasegun",weapon)
			network:send(player,"updatemoney",pdata.stats.money)
		else
			print("Failed to authenticate gun purchase by",player,"for",weapon)
		end
	end)

	network:add("deploycheck",function(player,slotprim,slotside,knife,slotprimatt,slotsideatt)
		local pdata			=getdata(player)
		local rank			=rankcalculator(pdata.stats.experience or 0)
		local passing		=true

		--- primary checking
		local primm			=require(gunmodules[slotprim])
		local primrank		=primm.unlockrank
		local primdata		=pdata.unlocks[slotprim]
		
		if not primdata then 
			primdata={}
			pdata.unlocks[slotprim]=primdata
		end

		local primkills		=primdata.kills or 0
		if rank<primrank and not primdata.paid then
			passing=false
		end

		--- primatt checking
		for i,v in next,slotprimatt do
			if i~="Name" and v~="" then
				local unlockkills=primm.attachments[i][v].unlockkills or infodata[v].unlockkills or 0
				if primkills<unlockkills and not primdata[v] then
					passing=false
				end
			end
		end

		--- secondary checking
		local sidem			=require(gunmodules[slotside])
		local siderank		=sidem.unlockrank
		local sidedata		=pdata.unlocks[slotside]
		
		if not sidedata then 
			sidedata={}
			pdata.unlocks[slotside]=sidedata
		end

		local sidekills		=sidedata.kills or 0
		if rank<siderank and not sidedata.paid then
			passing=false
		end

		--- sideatt checking
		for i,v in next,slotsideatt do
			if i~="Name" and v~="" then
				local unlockkills=sidem.attachments[i][v].unlockkills or infodata[v].unlockkills or 0
				if sidekills<unlockkills and not sidedata[v] then
					passing=false
				end
			end
		end

		return (passing or game.ServerScriptService.teston.Value)
	end)

	do --- market module
		local prodlist={
			---[27311922]	={money=50},--test1337
			[27310076]	={money=50},
			[27310085]	={money=100},
			[27310097]	={money=250},
			[27310078]	={money=750},
			[27310087]	={money=1500},
			[27310098]	={money=3750},
			[27310080]	={money=10000},
			[27310094]	={money=20000},
			[27310099]	={money=50000},
		}

		market.ProcessReceipt=function(receipt)
			if database.up then
				local ppl=game.Players:GetChildren()
				for i=1,#ppl do
					local v=ppl[i]
					if v.userId==receipt.PlayerId then
						local pdata			=getdata(v)
						local money			=pdata.stats.money or 0
						pdata.stats.money	=money+prodlist[receipt.ProductId].money---- double sale
						network:send(v,"updatemoney",pdata.stats.money)
						local success=database.manualsave(v.userId)
						if success then
							return Enum.ProductPurchaseDecision.PurchaseGranted
						else
							pdata.stats.money=money
							network:send(v,"updatemoney",pdata.stats.money)
							return nil--Does this mean that stuff is returned?
						end
					end
				end
			end
		end
	end

	network:add("kick",function(noob)
		noob:Kick()
	end)

	network:listen("stance",function(player,value)
		getstate(player).stance=value
	end)

	network:listen("sprint",function(player,value)
		getstate(player).sprint=value
	end)

	network:listen("aim",function(player,value)
		getstate(player).aim=value
	end)

	network:listen("equip",function(player,gun)
		getstate(player).weapon=gun
	end)

	network:listen("bodyparts",function(player,parts)
		getstate(player).bodyparts=parts
	end)

	network:add("state",function(player)
		return states[player]
	end)

	network:add("changeteam",function(player,team)
		player.TeamColor=team.TeamColor
	end)

	network:add("chatted",function(chatter,msg,tag,teamchat,cmd)
		--local message=pcall(function() return game.Chat:FilterStringForPlayerAsync(msg,chatter) end)
		local state=getstate(chatter)
		local betatester=state.betatester
		if betatester==nil then
			betatester=market:PlayerOwnsAsset(chatter,86802260)
			state.betatester=betatester
		end

		for i=1,#players do
			coroutine.wrap(function()
				local v=players[i]
				if (cmd and v==chatter) or not cmd then
					local message=game.Chat:FilterStringForPlayerAsync(msg,v)--not message and msg or message
					network:send(v,"chatted",chatter,message,tag,teamchat,betatester)
				end
			end)()
		end
	end)
	
	network:add("spotting",function(player,list)
		for i=1,#list do
			local v=list[i]
			if v then
				local box=ffc(v,"AssistBox")
				if not box then 
					box=new("Model",v)
					box.Name="AssistBox"
				end	
				local olds=box:GetChildren()
				for x=1,#olds do
					if olds[x].Name=="Spot" and olds[x].Value==player.Name then
						olds[x]:Destroy()
					end
				end
				local spottag=new("StringValue")
				spottag.Name="Spot"
				spottag.Value=player.Name
				spottag.Parent=box
				debris:AddItem(spottag,15)
			end
		end
		local pp=game.Players:GetChildren()
		for i=1,#pp do
			local v=pp[i]
			if v~=player and v.TeamColor==player.TeamColor and v.Character and ffc(v.Character,"Head") then
				network:send(v,"spotted",list,player.Name)
			end
		end
	end)
	
	network:add("pingcheck",function(player,clientpos)
		local state=getstate(player)
		local bodyparts=state.bodyparts
		if bodyparts and bodyparts.rootpart then
			local diff=(clientpos-bodyparts.rootpart.Position).Magnitude
			if diff>20 then
				state.strike=state.strike and state.strike+1 or 1
				print("["..player.Name.."]     strikes:"..state.strike.. "   positional difference: " ..diff)
				if diff==math.huge then
					print("Respawned "..player.Name.." due to loop dying glitch - Rootpart position: ",bodyparts.rootpart.Position)
					--player:LoadCharacter()
					--game.ReplicatedStorage.Emergency:FireClient(player)
				end
				if state.strike>15 and state.strike<200 then
					print("High ping warning: "..player.Name.. "   Kills disabled for this player")
				elseif state.strike>200 then
					print("High ping state left too long: "..player.Name.. "   Forcing rejoin to resolve issue")
					player:Kick("Disconnection by server: Client out of sync [PING]")
				end
			else
				state.strike=(state.strike and state.strike>0) and state.strike-10 or 0
			end
		end
	end)
	
	playerstates.ondied:connect(function(player,killer,weapon,hit,hitpos,firepos,attachdata,damage)	
		local cf			=CFrame.new
		local angles		=CFrame.Angles
		local deg			=math.pi/180
		local v3			=Vector3.new
		local new			=Instance.new		
		local debris		=game.Debris
		local rand			=math.random
		local ceil			=math.ceil
		local ffc			=game.FindFirstChild
		
		local c				=player.Character
		local newbody		=new("Model")
		local humanoid		=new("Humanoid")
		
		local head
		local torso
		local larm
		local rarm
		local lleg
		local rleg		

	

		local parts	=c:GetChildren()
		for i=1,#parts do
			local v=parts[i]
			if v:IsA("Part") and v.Transparency==0 then
				local newpart			=new("Part")
				newpart.formFactor		="Custom"
				newpart.TopSurface		=0
				newpart.BottomSurface	=0
				newpart.Size			=v.Size
				newpart.BrickColor		=v.BrickColor
				newpart.Parent			=newbody
				newpart.Name			=v.Name
				newpart.CFrame			=v.CFrame
				
				local extra				=v:GetChildren()
				for x=1,#extra do
					if extra[x]:IsA("SpecialMesh") or extra[x]:IsA("Decal") then
						extra[x]:Clone().Parent=newpart
					end
				end

				if v.Name=="Head" then head=newpart end
				if v.Name=="Torso" then 
					torso=newpart
					if not hitpos then
						hitpos=newpart.Position
					end
				end
				if v.Name=="Left Arm" then larm=newpart end
				if v.Name=="Right Arm" then rarm=newpart end
				if v.Name=="Left Leg" then lleg=newpart end
				if v.Name=="Right Leg" then rleg=newpart end
				
				newpart.Velocity=v3()
				delay(5,function() newpart.Anchored=true end)
			elseif v:IsA("Shirt") or v:IsA("Pants") then
				v:Clone().Parent=newbody
			end
		end

		local dist=hitpos and ceil((firepos-hitpos).Magnitude) or 0
		local headshot=hit and hit.Name=="Head"

		local function weldball(part,c0)
			local ball=new("Part",newbody)
			ball.Shape="Ball"
			ball.TopSurface=0
			ball.BottomSurface=0
			ball.formFactor="Custom"
			ball.Size=v3(1,1,1)			
			ball.Transparency=1
			
			local w=new("Weld")
			w.Part0=part
			w.Part1=ball
			w.C0=not c0 and cf(0,-0.5,0) or c0
			w.Parent=ball		
		end	
		
		local function weldtorso(part,setcf,c0,c1)
			part.CFrame=torso.CFrame*setcf
			local joint=new("Rotate")
			joint.Part0=torso
			joint.Part1=part
			joint.C0=c0
			joint.C1=c1
			joint.Parent=torso
			weldball(part)
		end
		
		if torso then
			if head then
				local neck=new("Weld")
				neck.Part0=torso
				neck.Part1=head
				neck.C0=cf(0,1.5,0)
				neck.Parent=torso
			end
			if rarm then
				weldtorso(rarm,cf(1.5,0,0),cf(1.5,0.5,0,0,0,1,0,1,0,-1,0,0),cf(0,0.5,0,0,0,1,0,1,0,-1,0,0))
			end
			if larm then
				weldtorso(larm,cf(-1.5,0,0),cf(-1.5,0.5,0,0,0,-1,0,1,0,1,0,0),cf(0,0.5,0,0,0,-1,0,1,0,1,0,0))
			end
			if rleg then
				weldtorso(rleg,cf(0.5,-2,0),cf(0.5,-1,0,0,0,1,0,1,0,-1,0,0),cf(0,1,0,0,0,1,0,1,0,-1,0,0))
			end
			if lleg then
				weldtorso(lleg,cf(-0.5,-2,0),cf(-0.5,-1,0,0,0,-1,0,1,0,1,0,0),cf(0,1,0,0,0,-1,0,1,0,1,0,0))
			end
			weldball(torso,cf(0,0.5,0))
			newbody.Name="Dead"
			humanoid.Parent=newbody
			humanoid.PlatformStand=true
			humanoid.AutoRotate=false
			humanoid.Name="Fakehumanoid"
			humanoid.Health=100
			newbody.Parent=workspace.Ignore
			torso.Velocity=v3(rand(-30,30),0,rand(-30,30))
			debris:AddItem(newbody,20)
		end
		--print(killer,"killed",player)
		handlekill(player,killer,weapon,hitpos,firepos,dist,headshot,attachdata,damage)
	end)
end




--vector module
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





--environment module
print("Loading environment module")
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
	local ray			=Ray.new
	local raycast		=workspace.FindPartOnRayWithIgnoreList
	local debris		=game.Debris
	local new			=Instance.new

	local repeffects	=game.ReplicatedStorage.Effects
	local blood			=repeffects.Blood
	local bloodsplat	=repeffects.BloodSplat
	local hole			=repeffects.Hole
	local ignore		=workspace.Ignore
	
	network:add("breakwindow",function(hit)
		if not hit then return end
		local shat=new("Sound",hit)
		shat.SoundId="http://roblox.com/asset/?id=144884907"
		shat.TimePosition = .1
		shat:Play()
		local sx,sy,sz=hit.Size.x,hit.Size.y,hit.Size.z
		for x=1,4 do
			for y=1,4 do
				local part=hit:Clone()
				local position=v3(x-2.1,y-2.1,0)*v3(sx/4,sy/4,sz)
				part.Size=v3(sx/4,sy/4,sz)
				part.CFrame=hit.CFrame*(cf(part.Size/8)-hit.Size/8+position)			
				part.Velocity=v3(random(-10,10),random(-10,10),random(-10,10))
				part.Parent=ignore
				part.Name="Shatter"
				debris:AddItem(part,2)
				spawn(function()
					wait(0.5)
					for i=1,10 do
						part.Transparency=part.Transparency+0.05
						wait(0.05)
					end
					part:Destroy()
				end)
				part.Anchored=false
			end
		end
		hit:Destroy()
	end)

	network:add("getammo",function(model,diff)
		local sparev=ffc(model,"Spare")
		if sparev then
			sparev.Value=sparev.Value-diff
		end
	end)

	network:add("dropgun",function(name,mag,spare,spot,attachdata)	
		local ref=ffc(game.StarterGui.VModel,name)
		if ref then
			local ignorelist={workspace.Ignore}
			local ppl=game.Players:GetChildren()
			for i=1,#ppl do
				if ppl[i].Character and ffc(workspace,ppl[i].Name) then
					ignorelist[#ignorelist+1]=ppl[i].Character
				end
			end			
			local model=ref:Clone()
			local magv=new("IntValue",model)
			magv.Value=mag
			magv.Name="Mag"
			local sparev=new("IntValue",model)
			sparev.Value=spare
			sparev.Name="Spare"
			local namev=new("StringValue",model)
			namev.Value=name
			namev.Name="Gun"
			local db=new("Model",model)
			db.Name="DB"
			debris:AddItem(db,1)
			for i,v in next,attachdata do
				local data=new("StringValue",namev)
				data.Name=i
				data.Value=v
			end
			local hit,pos,dir=raycast(workspace,ray(spot,v3(0,-999,0)),ignorelist)
			if hit and pos and dir then
				model.Name="Dropped"
				model.Parent=workspace.Ignore.GunDrop
				model.Anchored=true
				model.CFrame=cf(pos,pos+dir)*angles(0,0,random(0,360)*deg)
				debris:AddItem(model,50-#ppl)
			else
				model:Destroy()
			end
		end
	end)

	network:add("swapgun",function(player,dropped,name,mag,spare,attachdata)
		local magv=ffc(dropped,"Mag")
		local sparev=ffc(dropped,"Spare")
		local namev=ffc(dropped,"Gun")
		if not namev then return end
		local dropattach={}
		local dropinfo=namev:GetChildren()
		for i=1,#dropinfo do
			local v=dropinfo[i]
			dropattach[v.Name]=v.Value
		end

		if magv and sparev and namev then
			network:send(player,"swapgun",namev.Value,magv.Value,sparev.Value,dropattach)
		end

		local ref=ffc(game.StarterGui.VModel,name)
		if ref then
			local ignorelist={workspace.Ignore}
			local ppl=game.Players:GetChildren()
			for i=1,#ppl do
				if ppl[i].Character and ffc(workspace,ppl[i].Name) then
					ignorelist[#ignorelist+1]=ppl[i].Character
				end
			end			
			local model=ref:Clone()
			local magv=new("IntValue",model)
			magv.Value=mag
			magv.Name="Mag"
			local sparev=new("IntValue",model)
			sparev.Value=spare
			sparev.Name="Spare"
			local namev=new("StringValue",model)
			namev.Value=name
			namev.Name="Gun"
			local db=new("Model",model)
			db.Name="DB"
			debris:AddItem(db,1)
			for i,v in next,attachdata do
				local data=new("StringValue",namev)
				data.Name=i
				data.Value=v
			end
			model.CFrame=dropped.CFrame
			model.Name="Dropped"
			model.Parent=workspace.Ignore.GunDrop
			model.Anchored=true
			model:BreakJoints()
			debris:AddItem(model,60-#ppl)
		end
		dropped:Destroy()
	end)

	
	network:add("bloodhit",function(start,hit,pos,norm)
		network:bounce("createblood",start,hit,pos,norm)	
	end)
	
end


--roundsystem module
print("Loading roundsystem module")
do
	local wfc			=game.WaitForChild
	local ffc			=game.FindFirstChild
	local ud2			=UDim2.new
	local v3			=Vector3.new
	local cf			=CFrame.new
	local angles		=CFrame.Angles
	local deg			=math.pi/180
	local random		=math.random
	local abs			=math.abs
	local color			=Color3.new
	local ray			=Ray.new
	local raycast		=workspace.FindPartOnRayWithIgnoreList
	local debris		=game.Debris
	local new			=Instance.new
	local bc			=BrickColor.new

	local light			=game.Lighting
	local players		=game.Players
	local repstore		=game.ReplicatedStorage
	local props			=repstore.GamemodeProps

	local misc			=repstore.Misc
	
	local settings		=repstore.ServerSettings
	local countdown		=settings.Countdown
	local winner		=settings.Winner
	local showresult	=settings.ShowResults
	local gamemode		=settings.GameMode
	local timer			=settings.Timer
	local maxscoredis	=settings.MaxScore
	local gscore		=settings.GhostScore
	local pscore		=settings.PhantomScore
	local setquote		=settings.Quote
	local allowspawn	=settings.AllowSpawn
	local mapname		=settings.MapName
	
	local tghost		=game.Teams.Ghosts.TeamColor
	local tphan			=game.Teams.Phantoms.TeamColor
	
	--- game mode props
	local domflag		=wfc(props,"DomFlag")
	local kingflag		=wfc(props,"KingFlag1")
	local kingflag2		=wfc(props,"KingFlag2")
	domflag.Script.Disabled=true
	kingflag.Script.Disabled=true
	kingflag2.Script.Disabled=true
	---
	
	local roundtime		=15
	local currentmode	="tdm"
	local gamerunning	=false
	local lastt			=tick()
	local int			=0.1

	local endscore		=0
	local point			=0

	local gamelist		={
		tdm={
			Name		="Team Deathmatch",
			Length		=15,
			Startscore	=0,
			Endscore	=200,
			Point		=0,
			Scoretype	="Gain",
			Killscore	=true,
		},
		dom={
			Name		="Flare Domination",
			Length		=15,
			Startscore	=0,
			Endscore	=250,
			Interval	=10,
			Point		=4,
			Scoretype	="Gain",
			Killscore	=true,
		},
		koth={
			Name		="King of the Hill",
			Length		=15,
			Startscore	=600,
			Endscore	=0,
			Interval	=1,
			Point		=5,
			Scoretype	="Attrition",
			Killscore	=true,
		},
	}

	local lightset	 	={
		Sandstorm={
			Name="Desert Storm",
			Ambient={75, 73, 58},
			ColorShift_Bottom={97, 95, 74},
			ColorShift_Top={81, 79, 79},
			OutdoorAmbient={85/5, 84/5, 70/5}
		},
		Mall={
			Name="City Mall",
			Ambient={75, 73, 58},
			ColorShift_Bottom={97, 95, 74},
			ColorShift_Top={81, 79, 79},
			OutdoorAmbient={85/5, 84/5, 70/5}
		},
		Metro={
			Name="Metro",
			Ambient={75, 73, 58},
			ColorShift_Bottom={97, 95, 74},
			ColorShift_Top={81, 79, 79},
			OutdoorAmbient={85/3, 84/3, 70/3}
		},
		Crane2={
			Name="Crane Site Revamp",
			Ambient={75/8, 73/8, 58/8},
			ColorShift_Bottom={97, 95, 74},
			ColorShift_Top={81, 79, 79},
			OutdoorAmbient={85, 84, 70}
		},
		Crane={
			Name="Crane Site",
			Ambient={75/8, 73/8, 58/8},
			ColorShift_Bottom={97, 95, 74},
			ColorShift_Top={81, 79, 79},
			OutdoorAmbient={85, 84, 70}
		},
		Highway={
			Name="Highway Lot",
			Ambient={75/8, 73/8, 58/8},
			ColorShift_Bottom={97, 95, 74},
			ColorShift_Top={81, 79, 79},
			OutdoorAmbient={85, 84, 70}
		},
		Ravod={
			Name="Ravod 911",
			Ambient={95/8, 84/8, 80/8},
			ColorShift_Bottom={154, 151, 105},
			ColorShift_Top={91, 90, 58},
			OutdoorAmbient={124, 125, 109}
		},
		Apocalypse={
			Name="Apocalypse",
			Ambient={75, 73, 58},
			ColorShift_Bottom={97, 95, 74},
			ColorShift_Top={81, 79, 79},
			OutdoorAmbient={85, 84, 70}
		},
	}

	local quotes		={
		"TIP: If you have attached a canted iron/delta sight on your gun. Press T to switch between normal and canted sights",
		"TIP: Press Shift + L to enter cinematic mode",
		"TIP: Pressing V can switch firemodes for certain automatic guns",
		"TIP: Press E to spot enemy players that are in view",
		"There were two kinds of strength. One was the strength that came with having something to protect. The other was the strength of having nothing to lose.",
		"With death staring you in the face, you truly understand what it means to be alive.",
		"People are mirrors. If you smile, a smile will be reflected.",
		"An apple a day keeps any one away, if you throw it hard enough!",
		"People who use others are stupid, but people who are used are even more stupid.",
		"No idiot would want to be friends with an unmoving, unspeaking telephone pole. However, unmoving and unspeaking is exactly what you'd want from a telephone pole.",
		"Most non-NEET people in the world don't realize that human nature isn't scalar, but vectorial.",
		"There's only one difference between heroes and mad men. It's whether they win or lose.",
		"Having people acknowledge your existence is a wonderful thing.",
		"Greed may not be good, but it's not so bad either. You humans think greed is just for money or power, but everyone wants something they can't have.",
		"A little bit of trouble keeps life from being boring.",
		"A problem is not a problem as long as nobody sees it as one.",
		"There are some things you'll never see if you're always running.",
		"Anything can be a sword if you polish it enough.",
		"Even now, twenty centuries after the death of Christ, the world is a long way from peace.",
		"Friends are like balloons. Once you let them go, you can't get them back. So I'm going to tie you to my heart, so to never lose you.",
		"Romance can strengthen people, but it can also make them useless.",
		"The past makes you wanna die out of regret and future makes you depressed out of anxiety. So by elimination, the present is likely the happiest time.",
		"The time when you're happy is also the time when you're afraid that the happiness will end.",
		"The things we can't obtain are the most beautiful ones.",
		"The difference between the novice and the master is that the master has failed more times than the novice has tried.",
		"The ideal tool for controlling people is fear. And nothing overwhelms people more than an unseen fear.",
		"It's called a miracle because it doesn't happen.",
		"...Without love, it cannot be seen? ...Hah. That's backwards... Because of love, you end up seeing things that don't even exist.",
		"People with talent often have the wrong impression that things will go as they think.",
		"The only ones who should kill are those who are prepared to be killed!",
		"War does not determine who is right - only who is left.",
		"I dream of a better tomorrow, where chickens can cross the road and not be quested about their motives",
		"No I didn't trip, the floor looked like it needed a hug",
		"Better late than never, but never late is better",
		"I was standing in the park wondering why frisbees got bigger as they get closer. Then it hit me.",
		"When tempted to fight fire with fire, remember that the fire department generally uses water.",
		"Never underestimate the power of stupid people in large groups",
		"A successful man is one who makes more money than his wife can spend. A successful woman is one who can find such a man.",
		"Behind every great man is a woman rolling her eyes.",
		"Perfection is not attainable, but if we chase perfection we can catch excellence.",
		"An idea isn't responsible for the people who believe in it.",
		"I would like to die on Mars. Just not on impact.",
		"If women ran the world we wouldn't have wars, just intense negotiations every 28 days. [Robin Williams]",
		"Between two evils, I always pick the one I never tried before.",
		"If two wrongs don't make a right, try three.",	
		"Man cannot live by bread alone; he must have peanut butter.",
		"A pessimist is a person who has had to listen to too many optimists.",
		"Any kid will run any errand for you, if you ask at bedtime.",
		"Guilt: the gift that keeps on giving.",
		"The point of war is not to die for your country, but to make the noob on the other side die for his",
		"Always borrow money from a pessimist. He won't expect it back.",
		"Knowledge is knowing a tomato is a fruit; wisdom is not putting it in a fruit salad.",
		"I asked God for a bike, but I know God doesn't work that way. So I stole a bike and asked for forgiveness.",
		"The best way to lie is to tell the truth . . . carefully edited truth.",
		"Do not argue with an idiot. He will drag you down to his level and beat you with experience.",
		"A bargain is something you don't need at a price you can't resist.",
		"Children: You spend the first 2 years of their life teaching them to walk and talk. Then you spend the next 16 telling them to sit down and shut-up.",
		"When you go into court you are putting your fate into the hands of twelve people who weren't smart enough to get out of jury duty.",
		"Those people who think they know everything are a great annoyance to those of us who do.",
		"By working faithfully eight hours a day you may eventually get to be boss and work twelve hours a day.",
		"When tempted to fight fire with fire, remember that the Fire Department usually uses water.",
		"America is a country where half the money is spent buying food, and the other half is spent trying to lose weight.",
		"A bank is a place that will lend you money, if you can prove that you don't need it.",
		"The best time to give advice to your children is while they're still young enough to believe you know what you're talking about.",
		"Tell a man there are 300 billion stars in the universe and he'll believe you. Tell him a bench has wet paint on it and he'll have to touch it to be sure.",
		"The human brain is a wonderful thing. It starts working the moment you are born, and never stops until you stand up to speak in public.",
		"At every party, there are two kinds of people'those who want to go home and those who don't. The trouble is, they are usually married to each other.",
		"You love flowers, but you cut them. You love animals, but you eat them. You tell me you love me, so now I'm scared!",
		"I don't need a hair stylist, my pillow gives me a new hairstyle every morning.",
		"Don't worry if plan A fails, there are 25 more letters in the alphabet.",
		"Studying means 10% reading and 90% complaining to your friends that you have to study.",
		"If you want your wife to listen to you, then talk to another woman; she will be all ears.",
		"You never realize how boring your life is until someone asks what you like to do for fun.",
		"In the morning you beg to sleep more, in the afternoon you are dying to sleep, and at night you refuse to sleep.",
		"When I said that I cleaned my room, I just meant I made a path from the doorway to my bed.",
		"Life isn't measured by the number of breaths you take, but by the number of moments that take your breath away.",
		"The great pleasure in life is doing what people say you cannot do.",
		"If we were on a sinking ship, and there was only one life vest... I would miss you so much.",
		"All my life I thought air was free, until I bought a bag of chips.",
		"Long time ago I used to have a life, until someone told me to create a Facebook account.",
		"Never take life seriously. Nobody gets out alive anyway.",
		"An enemy is somebody who has a story you haven't heard of yet.",
		"Anything we do not understand is considered to be the devil.",
		"The best and most beautiful things in the world cannot be seen or even touched - they must be felt with the heart.",
		"Aim for the moon. If you miss, you may hit a star.",
		"Don't watch the clock; do what it does. Keep going.",
	}

	local teston=script.Parent.teston.Value

	if teston then
		game.StarterGui.teston.Value=true
		game.StarterGui.Loadscreen.Frame.Visible=false
	end

	local function refresh()
		wait(teston and 0 or 5)
		local cur=ffc(workspace,"Map")
		if cur then cur:Destroy() end	
		pscore.Value=0
		gscore.Value=0
		wait(teston and 0 or 5)
	end

	local function set_lighting(mname)
		local dolist={"Ambient","ColorShift_Bottom","ColorShift_Top","OutdoorAmbient"}
		for i=1, #dolist do
			light[dolist[i]]=color(lightset[mname][dolist[i]][1]/255,lightset[mname][dolist[i]][2]/255,lightset[mname][dolist[i]][3]/255)
		end
		mapname.Value=lightset[mname].Name
	end

	local function spawnplayers()
		wait(teston and 0 or 2)
		local map
		timer=tick()+30
		repeat map=ffc(workspace,"Map") wait(0.1) until map
		local ppl=players:GetChildren()
		for i=1,#ppl do
			pcall(function()
				if ppl[i].Character and ffc(workspace,ppl[i].Name) and ffc(ppl[i].Character,"Torso") then
					network:send(ppl[i],"countdown",network:toplayertick(timer))
				end
			end)
		end
	end

	--[[game.Players.PlayerAdded:connect(function(player)
		if countdown.Value and tick()<timer then
			network:send(player,"countdown",network:toplayertick(timer))
		end
	end)]]

	local function gameresult(type)
		if pscore.Value==gscore.Value then
			winner.Value=BrickColor.new("Black")
		elseif type=="Gain" then
			if pscore.Value>=endscore or pscore.Value>gscore.Value then
				winner.Value=tphan
			else
				winner.Value=tghost
			end
		elseif type=="Attrition" then
			if pscore.Value<=endscore or pscore.Value<gscore.Value then
				winner.Value=tghost
			else
				winner.Value=tphan
			end
		end
		setquote.Value=quotes[math.random(1,#quotes)]
		wait(0.1)
		showresult.Value=true
		wait(teston and 0 or 10)
		showresult.Value=false
	end

	local function checkresult(type)
		if gamerunning then
			if type=="Gain" then
				if pscore.Value>=endscore or gscore.Value>=endscore then
					gamerunning=false
				end
			elseif type=="Attrition" then
				if pscore.Value<=endscore or gscore.Value<=endscore then
					gamerunning=false
				end
			end
		end
	end

	local function respawnall()
		pcall(function()
			local ppl=players:GetChildren()
			for i=1,#ppl do
				playerstates:autodespawn(ppl[i])
			end
			print("players respawned")
			wait(teston and 0 or 2)
		end)
	end

	local sort do
		local a
		local b={}--extra space
	
		local function lt(a,b)
			return a<b
		end
	
		function sort(table,comp)
			comp=comp or lt
			a=table
			local n=#a
			local c=1
			while c<n do
				local i=1
				while i<=n-c do
					local p=i
					local i0=i
					local j0=i+c
					local i1=j0-1
					local j1=i1+c<n and i1+c or n
					while i0<=i1 and j0<=j1 do
						if comp(a[j0],a[i0]) then
							b[p]=a[j0]
							j0=j0+1
						else
							b[p]=a[i0]
							i0=i0+1
						end
						p=p+1
					end
					for x=i0,i1 do
						b[p]=a[x]
						p=p+1
					end
					for y=j0,j1 do
						b[p]=a[y]
						p=p+1
					end
					i=i+2*c
				end
				for j=i,n do
					b[j]=a[j]
				end
				a,b=b,a
				c=2*c
			end
			if a~=table then
				for i=1,n do
					table[i]=a[i]
				end
			end
			return table
		end
	end

	local function balanceteam(clear)
		--pcall(function()
			local switch=random(1,2)
			local ppl=players:GetChildren()
			sort(ppl,function(a,b) return playerstates:getplayerscore(a)>playerstates:getplayerscore(b) end)
			for i=1,#ppl do
				local prevt=ppl[i].TeamColor
				if clear then
					playerstates:clearleaderboard(ppl[i])
				end
				pcall(function()
					ppl[i].TeamColor=switch==1 and tphan or tghost
				end)
				local note=misc.TeamBalance:Clone()
				note.Parent=ppl[i].PlayerGui
				if prevt~=ppl[i].TeamColor then
					playerstates:autodespawn(ppl[i])
					note.Place.Text="You have been placed in "..(switch==1 and "Phantoms" or "Ghosts")
				else
					note.Place.Text="You remain in "..(switch==1 and "Phantoms" or "Ghosts")
				end
				note.Place.TextColor3=switch==1 and tphan.Color or tghost.Color
				debris:AddItem(note,5)
				
				switch=switch==1 and 2 or 1
			end
			print("teams balanced")
		--end)
		if clear then
			wait(teston and 0 or 2)
		end
	end

	local function checkteambalance()
		print("checking")
		local a=0
		local b=0
		local ppl=players:GetChildren()
		for i=1,#ppl do
			if ppl[i].TeamColor==tphan then
				a=a+1
			else
				b=b+1
			end
		end
		if abs(a-b)>=2 then
			balanceteam()
		end
	end

	local function intervalcheck(pt,sec)
		if currentmode=="dom" then
			local map					=ffc(workspace,"Map")
			if map then
				local propfolder		=ffc(map,"AGMP")
				if propfolder then
					local props			=propfolder:GetChildren()
					for i=1,#props do					---get each flag
						local base				=ffc(props[i],"Base")
						local tm				=ffc(props[i],"TeamColor")
						local cp				=ffc(props[i],"CapPoint")
						local iscapping			=ffc(props[i],"IsCapping")
						if tm.Value==tghost or tm.Value==tphan then
							if not iscapping.Value then
								if tm.Value==tghost then
									gscore.Value=gscore.Value+pt
								elseif tm.Value==tphan then
									pscore.Value=pscore.Value+pt
								end
							end
						end
					end
				end
			end
		elseif currentmode=="koth" then
			local map					=ffc(workspace,"Map")
			if map then
				local propfolder		=ffc(map,"AGMP")
				if propfolder then
					local prop		=ffc(propfolder,"KingFlag")
				 	if prop then					---get hill
						local base				=ffc(prop,"Base")
						local tm				=ffc(prop,"TeamColor")
						local cp				=ffc(prop,"CapPoint")
						local iscapping			=ffc(prop,"IsCapping")
						if tm.Value==tghost or tm.Value==tphan then
							if not iscapping.Value then
								--- check for number of players in zone
								local ppl			=game.Players:GetChildren()
								local cappers		={}
								local numplayers	=0
								local interval
								for i=1,#ppl do
									if ppl[i].TeamColor==tm.Value then
										local char=ppl[i].Character
										if char then
											local root=ffc(char,"HumanoidRootPart")
											if root and (root.Position-base.Position).Magnitude<20 then
												cappers[#cappers+1]=ppl[i]
												numplayers=numplayers+1
											end
										end
									end
								end
								interval=numplayers==0 and 10 or numplayers==1 and 5 or numplayers==2 and 4 or numplayers>=3 and 3
								if sec%interval==0 then
									if tm.Value==tghost then
										pscore.Value=pscore.Value-pt		--- attrition based point system
									elseif tm.Value==tphan then
										gscore.Value=gscore.Value-pt
									end
									for i=1,#cappers do
										playerstates.addscore(cappers[i],"kingholding",10)
									end
								end
							end
						end
					end
				end
			end
		end
	end

	local function startmatch(mname,mode)
		local modedata,interval,scoretype
		currentmode				=mode
		modedata				=gamelist[currentmode]
		scoretype				=modedata.Scoretype
		roundtime				=modedata.Length
		endscore				=modedata.Endscore
		gamemode.Value			=modedata.Name
		interval				=modedata.Interval
		point					=modedata.Point
		maxscoredis.Value		=modedata.Startscore>0 and modedata.Startscore or endscore
		
		refresh()

		pscore.Value			=modedata.Startscore
		gscore.Value			=modedata.Startscore

		local map				=new("Model",workspace)
		local chunks			=game.ServerStorage.Maps[mname]:GetChildren()
		local chunkpart			=0
		map.Name				="Map"

		for i=1,#chunks do
			chunkpart=chunkpart+1
			if chunkpart%100==0 then
				wait(teston and 0 or 0.15)
			end
			if chunks[i]:IsA("Model") then
				local pt=chunks[i]:GetChildren()
				for x=1,#pt do
					chunkpart=chunkpart+1
					if chunkpart%50==0 then
						wait(teston and 0 or 0.2)
					end
				end
			end
			chunks[i]:Clone().Parent=map
		end
			
		
		--map.Parent				=workspace

		local agmp=wfc(map,"AGMP")
		if currentmode=="tdm" then
			if agmp then
				agmp:Destroy()
			end
		elseif currentmode=="dom" then
			if not agmp then return end
			local stuff=agmp:GetChildren()
			for i=1,#stuff do
				local v=stuff[i]
				if v.Name=="DomPos" then
					local flag=domflag:Clone()
					flag.Letter.Value=i==1 and "A" or i==2 and "B" or "C"
					flag.Parent=agmp
					flag:SetPrimaryPartCFrame(v.CFrame)
					flag.Script.Disabled=false
				end
				v:Destroy()
			end
		elseif currentmode=="koth" then
			if not agmp then return end
			local stuff=agmp:GetChildren()
			for i=1,#stuff do
				local v=stuff[i]
				if v.Name=="KingPos" then
					local flag=random(1,2)==1 and kingflag:Clone() or kingflag2:Clone()
					flag.Name="KingFlag"
					flag.Parent=agmp
					flag:SetPrimaryPartCFrame(v.CFrame)
					flag.Script.Disabled=false
				end
				v:Destroy()
			end
		end

		if teston then
			for i,v in next,map.Teleport:GetChildren() do
				v.CFrame=map.Teleport.B1.CFrame
			end
		end
		set_lighting(mname)
		wait(teston and 0 or 5)
		allowspawn.Value=true
		countdown.Value=true
		for i=20,0,-1 do
			timer.Value=i
			wait(teston and 0 or 1)
		end
		countdown.Value=false
		gamerunning=true
		for i=roundtime*60,0,-1 do
			if gamerunning then
				timer.Value=i
				checkresult(scoretype)
				if interval and i%interval==0 then
					intervalcheck(point,i)
				end
				--[[if i%300==0 and i<roundtime*60 and i>60 then
					checkteambalance()
				end]]
				wait(1)
			end
		end
		gamerunning=false
		allowspawn.Value=false
		gameresult(scoretype)
		balanceteam(true)
		respawnall()
		network:bounce("emptytrash")--NEW BULLSHIT PROBABLY LAGS NEW BULLSHIT PROBABLY LAGS NEW BULLSHIT PROBABLY LAGS NEW BULLSHIT PROBABLY LAGS
	end

	---	individualized round score checking

	local function domcheck()
		local map					=ffc(workspace,"Map")
		if map then
			local propfolder		=ffc(map,"AGMP")
			if propfolder then

				local props			=propfolder:GetChildren()
				local ppl			=game.Players:GetChildren()
				

				for i=1,#props do					---get each flag
					local base				=ffc(props[i],"Base")
					local tm				=ffc(props[i],"TeamColor")
					local cp				=ffc(props[i],"CapPoint")
					local iscapping			=ffc(props[i],"IsCapping")
					local intervalcap		=cp.Value>0 and cp.Value%15==0
					local add				=0
					local conflict
					local presentteam
					
					iscapping.Value=false	
					for x=1,#ppl do					---get all players and check distance from this flag
						local char					=ppl[x].Character
						if char then
							local root				=ffc(char,"HumanoidRootPart")
							if root then
								if (root.Position-base.Position).Magnitude<15 and root.Position.Y>base.Position.Y then
									if tm.Value~=ppl[x].TeamColor and (not presentteam or presentteam==ppl[x].TeamColor) then
										presentteam=ppl[x].TeamColor
										iscapping.Value=true
										add=add+1
										if intervalcap then
											local db=ffc(ppl[x],"Capping")
											if not db then db=new("IntValue",ppl[x]) end
											if db.Value<3 then
												playerstates.addscore(ppl[x],"domcapping",20)
												db.Name="Capping"
												db.Value=db.Value+1
												debris:AddItem(db,40)
											end
										else
											intervalcap=cp.Value>0 and cp.Value%15==0
										end
									else
										add=0
										conflict=true
										if tm.Value==ppl[x].TeamColor then
											if cp.Value>0 then
												playerstates.addscore(ppl[x],"domdefend",150)
											end
										end
										cp.Value=0
									end
								end
							end
						end
					end
					if not conflict then
						if add>3 then add=3 end
						cp.Value=cp.Value+add
					end
					if not conflict and iscapping.Value and cp.Value>=50 then	 		--- checking for completed capture with no conflict
						if presentteam and presentteam~=tm.Value then					--- flag captured
							tm.Value=presentteam
							cp.Value=0
							--- reward points
							for i=1,#ppl do
								local v=ppl[i]
								if v.TeamColor==presentteam then
									local char=v.Character
									if char then
										local root=ffc(char,"HumanoidRootPart")
										if root then
											if (root.Position-base.Position).magnitude<15 and root.Position.Y>base.Position.Y then
												playerstates.addscore(v,"domcap",250)
											end
										end
									end
								end
							end
						else
							cp.Value=0
						end
					elseif not iscapping.Value then
						cp.Value=0	
					end
				end
			end
		end
	end

	local function kingcheck()
		local map					=ffc(workspace,"Map")
		if map then
			local propfolder		=ffc(map,"AGMP")
			if propfolder then

				local prop			=propfolder:GetChildren()[1]
				local ppl			=game.Players:GetChildren()

				---get one flag
				local base				=ffc(prop,"Base")
				local tm				=ffc(prop,"TeamColor")
				local cp				=ffc(prop,"CapPoint")
				local iscapping			=ffc(prop,"IsCapping")
				local intervalcap		=cp.Value>0 and cp.Value%15==0
				local add				=0
				local conflict
				local presentteam
				
				iscapping.Value=false	
				for x=1,#ppl do					---get all players and check distance from this flag
					local char					=ppl[x].Character
					if char then
						local root				=ffc(char,"HumanoidRootPart")
						if root then
							if (root.Position-base.Position).Magnitude<20 and root.Position.Y>base.Position.Y then
								if tm.Value~=ppl[x].TeamColor and (not presentteam or presentteam==ppl[x].TeamColor) then
									presentteam=ppl[x].TeamColor
									iscapping.Value=true
									add=add+1
									if intervalcap then
										local db=ffc(ppl[x],"Capping")
										if not db then db=new("IntValue",ppl[x]) end
										if db.Value<3 then
											playerstates.addscore(ppl[x],"kingcapping",20)
											db.Name="Capping"
											db.Value=db.Value+1
											debris:AddItem(db,40)
										end
									else
										intervalcap=cp.Value>0 and cp.Value%15==0
									end
								else
									add=0
									conflict=true
									if tm.Value==ppl[x].TeamColor then
										if cp.Value>0 then
											playerstates.addscore(ppl[x],"kingdefend",150)
										end
									end
									cp.Value=0
								end
							end
						end
					end
				end
				if not conflict then
					if add>3 then add=3 end
					cp.Value=cp.Value+add
				end
				if not conflict and iscapping.Value and cp.Value>=50 then	 		--- checking for completed capture with no conflict
					if presentteam and presentteam~=tm.Value then					--- flag captured
						tm.Value=presentteam
						cp.Value=0
						--- reward points
						for i=1,#ppl do
							local v=ppl[i]
							if v.TeamColor==presentteam then
								local char=v.Character
								if char then
									local root=ffc(char,"HumanoidRootPart")
									if root then
										if (root.Position-base.Position).magnitude<15 and root.Position.Y>base.Position.Y then
											playerstates.addscore(v,"kingcap",250)
										end
									end
								end
							end
						end
					else
						cp.Value=0
					end
				elseif not iscapping.Value then
					cp.Value=0	
				end

			end
		end
	end

	----		 round system functions

	function roundsystem:killupdate(victim,killer)
		if victim==killer then return end
		local kscore=killer.TeamColor==tghost and gscore or pscore
		local vscore=victim.TeamColor==tghost and gscore or pscore
		if currentmode=="tdm" then
			kscore.Value=kscore.Value+1
		elseif currentmode=="dom" or currentmode=="koth" then
			if vscore.Value>0 then
				vscore.Value=vscore.Value-1
			end
		end
	end

	game:GetService("RunService").Stepped:connect(function()
		if tick()-lastt>int then
			lastt=tick()
			if gamerunning then
				if currentmode=="dom" then
					domcheck()
				elseif currentmode == "koth" then
					kingcheck()
				end
			end
		end
	end)

	local maplist			={"Metro","Ravod","Crane2","Mall","Highway","Crane","Sandstorm"}
	local modelist			={"dom","tdm","koth",}
	local r					=random(1,#maplist*#modelist)

	function getmatch()
		local smap=maplist[(r-1)%#maplist+1]
		local smode=modelist[(r-1)%#modelist+1]
		r=r+1
		return smap,smode
	end

	while true do
		local mp,gm=getmatch()	--- map and mode randomizer
		print("Map chosen : "..mp.."    Mode chosen: "..gm)
		pcall(function()
			startmatch(mp,gm)
		end)
		wait(1)
	end

end

