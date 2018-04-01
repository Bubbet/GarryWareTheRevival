WARE.Author = ""
WARE.Room = "none"

function WARE:Initialize()
	GAMEMODE:SetWareWindupAndLength(5, 6)
	GAMEMODE:SetPlayersInitialStatus( nil )
	GAMEMODE:DrawInstructions( "Displayed In Pre-Game" )

	
	
end

function WARE:StartAction()
	GAMEMODE:DrawInstructions( "Displayed When Ware Starts" )
end

function WARE:EndAction()	
	GAMEMODE:DrawInstructions( "Displayed When Ware Ends", Color(255,255,255,255) )
end

function WARE:PlayerSay(ply, text, say)
	--ply The player speaking
	--text The text being said
	--say uhh probably not important so who knows
end
