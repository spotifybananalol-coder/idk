local P=game:GetService("Players");local LP=P.LocalPlayer
local pg=LP:WaitForChild("PlayerGui")
local imp={}
local function who(s)
	if type(s)=="string"then
		for _,p in ipairs(P:GetPlayers())do if p.Name==s or p.DisplayName==s then return p end end
	end
	if typeof(s)=="Instance"then return s end
end
local function sc(ct,d)
	if d>10 then return end
	for _,c in ipairs(ct:GetChildren())do
		if c.ClassName=="RemoteEvent"and c.Name=="OnKillRemote"then
			c.OnClientEvent:Connect(function(...)
				local a={...};local k=who(a[1]);local v=who(a[2])
				if k and v then imp[k.UserId]=true end
			end)
		end
		sc(c,d+1)
	end
end
sc(game,0)

-- reset each round: states appears at round start
LP.ChildAdded:Connect(function(c)
	if c.Name=="states" then imp={} end
end)

local Gui=Instance.new("ScreenGui",pg)
local Box=Instance.new("Frame",Gui)
Box.Size=UDim2.new(0,300,0,300);Box.Position=UDim2.new(1,-310,0,10)
Box.BackgroundColor3=Color3.fromRGB(8,8,8);Box.BackgroundTransparency=0.15;Box.BorderSizePixel=0
local list=Instance.new("TextLabel",Box)
list.Size=UDim2.new(1,-10,0,300);list.Position=UDim2.new(0,5,0,5)
list.BackgroundTransparency=1;list.TextColor3=Color3.fromRGB(255,255,255)
list.TextXAlignment=Enum.TextXAlignment.Left;list.TextYAlignment=Enum.TextYAlignment.Top
list.Font=Enum.Font.Gotham;list.TextSize=13

while true do
	local out=""
	for _,p in ipairs(P:GetPlayers())do
		local tag=imp[p.UserId]and"  [KILLER?]"or""
		out=out..p.Name..tag.."\n"
	end
	out=out.."killers: "..(next(imp) and "detected" or "none yet")
	list.Text=out
	wait(1)
end
