WARE.Author = "Brutal Yoshi"
WARE.Colors = {"green" , "red" , "yellow" , "blue" , "purple" , "black"}
WARE.Txtcolors = {Color(46,255,0) , Color(255, 0, 0) , Color(239, 239, 45) , Color(78, 89, 216) , Color(155, 69, 209) , Color(48, 48, 48) }
WARE.Concolors = {Color(119, 0, 183) , Color(0,155,255) , Color(175, 216, 173) , Color(46,255,0) , Color(247, 184, 89) , Color(255, 255, 255)}
--WARE.Concolors = {Color(175, 216, 173) , Color(175, 216, 173) , Color(175, 216, 173) , Color(175, 216, 173) , Color(175, 216, 173) , Color(175, 216, 173) }
WARE.Room = "none"

function WARE:Initialize()
	GAMEMODE:EnableFirstWinAward( )
	GAMEMODE:SetWareWindupAndLength(2, 4)
	GAMEMODE:SetPlayersInitialStatus( nil )
	GAMEMODE:DrawInstructions( "Prepare to type..." )
	

	self.pickcolor = self.Colors[math.ceil( math.random(1,#self.Colors))]

	self.minigametype = math.ceil(math.random(1,2))
end

function WARE:StartAction()
	self.colorindex = math.ceil(math.random(1,#self.Txtcolors))
	local textcolor = self.Txtcolors[self.colorindex]
	local contrast = self.Concolors[self.colorindex]
	local drawtype 
	if self.minigametype == 1 then
		drawtype = "Type the following text: "
	else
		drawtype = "Type the color of the text: "
	end
		
	GAMEMODE:DrawInstructions( drawtype ..self.pickcolor , contrast , textcolor)
	
end

function WARE:EndAction()	--text, background, foreground/textcolor
end

function WARE:PlayerSay(ply, text, say)
	if !ply:IsWarePlayer() then 
		return false
	end
	
	if self.minigametype == 1 then
		if string.lower(text) == self.pickcolor then 
			ply:ApplyWin() 	
			GAMEMODE:PrintInfoMessage(ply:Name() , ": Got it right!" , "")
			return false
		else 
			ply:ApplyLose()
			GAMEMODE:PrintInfoMessage(ply:Name() , ": Failed" , "")
			return false
		end
	else 
		local index = nil
		for i,e in pairs(self.Colors) do
			if string.lower(text) == e then index = i end
		end
	
		if index == self.colorindex then
			ply:ApplyWin() 	
			GAMEMODE:PrintInfoMessage(ply:Name() , ": Got it right!" , "")
			return false
		else 
			ply:ApplyLose()
			GAMEMODE:PrintInfoMessage(ply:Name() , ": Failed" , "")
			return false
		end
	end
end
