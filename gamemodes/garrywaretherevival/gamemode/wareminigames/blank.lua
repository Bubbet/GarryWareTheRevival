WARE.Author = ""
WARE.Room = "none"

WARE.Colors = {"green", "red", "blue", "yellow"}
WARE.Rgbcolors = {Color(255,100,0), Color(100,255,0)}
WARE.Contrastcolors = {Color(0,155, 255), Color(155,0,255)}

function WARE:Initialize()
	GAMEMODE:SetWareWindupAndLength(5, 6)
	GAMEMODE:SetPlayersInitialStatus( nil )
	GAMEMODE:DrawInstructions( "Prepare to type!" )

	self.minigametype = math.ceil(math.random(1,2))
	self.pickcolor = self.Colors[math.ceil( math.random(1,self.Colors) ) ]
end

function WARE:StartAction()
	self.colorindex = math.ceil(math.random(1,#self.Rgbcolors))
	
	local textcolor = self.Rgbcolors[self.colorindex]
	local contrastcolor = self.Contrastcolors[self.colorindex]
	local drawtype = nil
	
	if self.minigametype == 1 then 
		drawtype = "Type The Text: "
	else
		drawtype = "Type The Color: "
	end
	
	GAMEMODE:DrawInstructions( drawtype .. self.pickcolor, contrastcolor, textcolor)
end

function WARE:EndAction()	--text, background, foreground/textcolor
	--GAMEMODE:DrawInstructions( "Displayed When Ware Ends", Color(255,255,255,255) , Color(200,200,200,255))
end

function WARE:PlayerSay(ply, text, say)
	if !ply:IsWarePlayer() then
		return false
	end
	
	if self.minigametype == 1 then
		if string.lower(text) == self.pickcolor then
			ply:ApplyWin()
			GAMEMODE:PrintInfoMessage(ply:Name().." Is Gud")
			return false
		else
			ply:ApplyLose()
			GAMEMODE:PrintInfoMessage(ply:Name().." Sucks")
			return false
		end
	else
		local index = nil
		for i,e in pairs(self.Colors) do
			if string.lower(text) == e then index = i end
		end
		if index == self.colorindex then
			ply:ApplyWin()
			GAMEMODE:PrintInfoMessage(ply:Name().." Is Gud")
			return false
		else
			ply:ApplyLose()
			GAMEMODE:PrintInfoMessage(ply:Name().." Sucks")
			return false
		end
		
	--ply The player speaking
	--text The text being said
	--say uhh probably not important so who knows
end
