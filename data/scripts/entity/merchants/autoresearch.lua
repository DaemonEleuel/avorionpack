package.path = package.path .. ";data/scripts/entity/merchants/?.lua;"
package.path = package.path .. ";data/scripts/lib/?.lua;"
package.path = package.path .. ";configs/?.lua;"

local a={[-1]={"Petty",112,112,122,RarityType.Petty},[0]={"Common",255,255,255,RarityType.Common},[1]={"Uncommon",0,208,0,RarityType.Uncommon},[2]={"Rare",0,112,221,RarityType.Rare},[3]={"Exceptional",255,192,64,RarityType.Exceptional},[4]={"Exotic",255,64,16,RarityType.Exotic},[5]={"Legendary",122,0,204,RarityType.Legendary}}
local b={}
local c={}
local d={}
local e={}
local f={}
local g={}
local h=false

function editUI(i)createColors()
	local j=getResolution()
	local k=vec2(800,600)
		required:hide()
		optional:hide()
		results:hide()
		button:hide()
	local l=UIVerticalMultiSplitter(i.top,10,10,2)
	local m=UIHorizontalSplitter(l:partition(0),10,10,0.5)
		m.padding=6;
	local n=m.top;
		n.width=220;
		required=window:createSelection(n,3)
	local n=m.bottom;n.width=150;
		optional=window:createSelection(n,2)
	
	for o,p in pairs({required,optional}) do
		p.dropIntoEnabled=1;
		p.entriesSelectable=0;
		p.onReceivedFunction="onRequiredReceived"
		p.onDroppedFunction="onRequiredDropped"
		p.onClickedFunction="onRequiredClicked"
	end;
		l.padding=10;
	local q=UIOrganizer(l:partition(1))
		q.marginTop=5;
	local n=l:partition(1)
		n.width=90;
		n.height=90;
		results=window:createSelection(n,1)
		results.entriesSelectable=0;
		results.dropIntoEnabled=0;
		results.dragFromEnabled=0;
		q:placeElementTop(results)
		q.marginBottom=35;
		button=window:createButton(Rect(),"Research"%_t,"onClickAutoResearch")
		button.width=200;
		button.height=40;
		q:placeElementBottom(button)
		q.marginBottom=0;
		cbAutoResearch=window:createCheckBox(Rect(),"Automatic"%_t,"toggleAutoResearch")
		q:placeElementBottom(cbAutoResearch)
	local r=UIOrganizer(l:partition(2))
	local s=window:createLabel(vec2(),"AutoResearch Settings"%_t,14)
		s.width=l:partition(2).width;
		s.centered=true;
		r:placeElementTop(s)
	local t=UIVerticalMultiSplitter(l:partition(2),10,10,2)
	local u=UIOrganizer(t:partition(0))
	local v=UIOrganizer(t:partition(1))
	local w=UIOrganizer(t:partition(2))
		u.marginTop=10;
		v.marginTop=10;
		w.marginTop=10;
	local x=window:createLabel(vec2(),"Rarity"%_t,11)
		x.width=t:partition(0).width;
		x.centered=true;
		u:placeElementTop(x)
	local y=window:createLabel(vec2(),"Upgrades"%_t,11)
		y.width=t:partition(1).width;
		y.centered=true;
		v:placeElementTop(y)
	local z=window:createLabel(vec2(),"Turrets"%_t,11)
		z.width=t:partition(2).width;
		z.centered=true;
		w:placeElementTop(z)
		u.marginLeft=60;
		u.marginTop=30;
		v.marginTop=30;
		w.marginTop=30;
	for A=-1,5 do
		local B=window:createLabel(vec2(),a[A][1]%_t,12)
		local C=window:createCheckBox(Rect(),"","")
		local D=window:createCheckBox(Rect(),"","")
		local E=u.marginTop+25;
			B.width=l:partition(2).width/2;
			B.color=b[A]
			u:placeElementTop(B)
			v:placeElementTop(C)
			w:placeElementTop(D)
			C.width=t:partition(2).width/1.6;
			D.width=t:partition(2).width/1.5;
			c[A]=C;
			d[A]=D;
			u.marginTop=E;
			v.marginTop=E;
			w.marginTop=E
	end;
	d[-1]:hide()
	c[-1].checked=true;
	d[0].checked=true
end;

function onClickAutoResearch()
	if not cbAutoResearch.checked then onClickResearch() return	end;
	
	autoresearch_on()
	
	local F={c,d}
	local G=0;
	
	for A=-1,5 do
		local C=c[A]
		local D=d[A]
		if C.checked then
			G=G+1
		end;
		if D.checked then
			G=G+1
		end
	end;
	
	if G==0 then displayChatMessage("You did not select any Rarity types to research!"%_t,Entity().title,1);autoresearch_off(); return end;
	
	updateInventory()
	
	for A=-1,5 do
		local H=a[A][5]
		if c[H].checked then
			local I=getUpgradesByRarity(H)
			local count = 0
			if H==-1 then count = SSPetty; end;
			if H==0 then count = SSCommon; end;
			if H==1 then count = SSUncommon; end;
			if H==2 then count = SSRare; end;
			if H==3 then count = SSExceptional; end;
			if H==4 then count = SSExotic; end;
			if H==5 then count = SSLegendary; end;
			if#I>0 then
				local J={}
				for o,K in ipairs(I) do
					if not string.find(K.item.script,"teleporterkey")then
						local L=getUpgradesFromSelection(I,K.item.script)
						if#L>0 then
							if#L>=count then
								local M=#L;
								local N={}
								for A=1,count do
									if L[A]~=nil then
										table.insert(N,L[A])
									end
								end;
								startAutoResearch(N)
							end
						end
					end
				end
			end
		end
	end;
	for A=0,5 do
		local H=a[A][5]
		if d[H].checked then
			local O=getTurretsByRarity(H)
			local count = 0
			if H==0 then count = TCommon; end;
			if H==1 then count = TUncommon; end;
			if H==2 then count = TRare; end;
			if H==3 then count = TExceptional; end;
			if H==4 then count = TExotic; end;
			if H==5 then count = TLegendary; end;
			if#O>0 then
				local J={}
				for o,K in ipairs(O) do
					local P=getTurretsFromSelection(O,K.item.itemType,K.item.material,K.item.weaponPrefix,K.item.numWeapons)
					if#P>=count then
						local M=#P
						local N={}
						for A=1,count do
							if P[A]~=nil then
								table.insert(N,P[A])
							end
						end
					startAutoResearch(N)
					end
				end
			end
		end
	end;
	autoresearch_off()
end;

function autoresearch_on()
	if not h then
		h=true;
		window.showCloseButton=false;
		window.closeableWithEscape=false;
		window:hide()window:show()button.onPressedFunction="onResearchRunning"
	end;
end;

function autoresearch_off()
	if h then
		h=false;
		window.showCloseButton=true;
		window.closeableWithEscape=true;
		window:hide()
		window:show()
		button.onPressedFunction="onClickAutoResearch"onShowWindow()
	end
end;

function receivedResult()
	onClickAutoResearch()
end;

function researchFailed()
	if h then
		print("Failed")
		h=false;
		window.showCloseButton=true;
		window.closeableWithEscape=true;
		window:hide()
		window:show()
		button.onPressedFunction="onClickAutoResearch"onShowWindow()
	end
end;

function updateInventory()
	e={}
	f={}
	local player = Player()
    local ship = player.craft
    local alliance = player.alliance
	if alliance and ship.factionIndex == player.allianceIndex then
		inv = Alliance():getInventory():getItems();
        local Q=Alliance()
    else
		inv = Player():getInventory():getItems();
        local Q=Player()
    end
	for R,S in pairs(inv) do
		local K=SellableInventoryItem(S.item,R,Q)
		local T=S.item.itemType;
		local U=K.rarity.value;
		local N=S.amount;
		if T==InventoryItemType.SystemUpgrade and c[U].checked then
			table.insert(e,K)
		elseif T==InventoryItemType.Turret or itempType==InventoryItemType.TurretTemplate and d[U].checked then
			if S.item.stackable then
				for i=0,S.amount do
					table.insert(f,K)
				end
			else
				table.insert(f,K)
			end
		end
	end
	table.sort(e,SortSellableInventoryItems)
end;

function getUpgradesByRarity(V)
	local M=#e;
	local W={}
	for A=M,1,-1 do
		if e[A].rarity.value==V then
			table.insert(W,e[A])
		end
	end;
	return W
end;

function getUpgradesFromSelection(W,X)
	local M=#W;
	local Y={}
	for A=M,1,-1 do
		if W[A].item.script==X then
			table.insert(Y,W[A])
		end
	end;
	return Y
end;

function getTurretsByRarity(V)
	--V is just the rarity level, 1 to 5
	local M=#f;
	local W={}
	for A=M,1,-1 do
		if f[A].rarity.value==V then
			table.insert(W,f[A])
		end
	end;
	return W
end;

function getTurretsFromSelection(W,T,Z,_,a0)
	local M=#W;
	local Y={}
	for A=M,1,-1 do
		--change it to use single,double,triple and quad turrets of the same type in a single research process
		if TBarrelMerge then
			if W[A].item.itemType==T and W[A].item.material==Z and W[A].item.weaponPrefix==_ and W[A].item.numWeapons==a0 then
				table.insert(Y,W[A])
			end
		else
			if W[A].item.itemType==T and W[A].item.material==Z and W[A].item.weaponPrefix==_ then
				table.insert(Y,W[A])
			end
		end
		--
	end;
	return Y
end;

function startAutoResearch(a1)
    local a2 = {}

	for o,K in pairs(a1) do
		local a3=a2[K.index]or 0;
		a3=a3+1;
		a2[K.index]=a3
	end;
	if not checkRarities(a1)then
		displayChatMessage("AutoResearch: rarities too far apart!"%_t,Entity().title,1)
		return
	end;
	invokeServerFunction("research",a2)
end;

function moveToSelection(a1)
	for o,K in ipairs(a1) do
		local a4=getSelectionItem(K)
		onInventoryClicked(inventory.index,a4[1].x,a4[1].y,a4[2],2)
	end
end;

function toggleAutoResearch()
	for o,p in pairs({required,optional}) do
		p.dropIntoEnabled=not cbAutoResearch.checked;
		button.active=true;
		if cbAutoResearch.checked then
			p.onReceivedFunction="onAutoEnabledTryInteract"
			p.onDroppedFunction="onAutoEnabledTryInteract"
			p.onClickedFunction="onAutoEnabledTryInteract"
			local W=Selection(p.index)
			local K;
			for a5,a6 in pairs(W:getItems()) do
				K=W:getItem(a5)moveItem(K,W,inventory,a5,nil)
			end
		else
			p.onReceivedFunction="onRequiredReceived"
			p.onDroppedFunction="onRequiredDropped"
			p.onClickedFunction="onRequiredClicked"
		end
	end;
	
	if cbAutoResearch.checked then
		inventory.onClickedFunction="onAutoEnabledTryInteract"
	else
		inventory.onClickedFunction="onInventoryClicked"
		refreshButton()
	end
end;

function onAutoEnabledTryInteract()
	displayChatMessage("Turn off Automatic to use these manually again!"%_t,Entity().title,1)
end;

function onResearchRunning()
	displayChatMessage("Research is currently running please wait!"%_t,Entity().title,3)
end;

function createColors()
	for A=-1,5 do
		local a7=Color()
		a7.r=a[A][2]/255;
		a7.g=a[A][3]/255;
		a7.b=a[A][4]/255;
		a7.a=255/255;
		b[A]=a7
	end
end