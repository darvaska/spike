function onColHit(wheel)
	local vehicle = getPedOccupiedVehicle( source )
	if not isElement( vehicle ) then return end				
    local wheelstate = { getVehicleWheelStates( vehicle ) }
    if wheelstate[wheel] ~= 0 then return end
    local wheelStates = {-1,-1,-1,-1}
    wheelStates[wheel] = 1
    setVehicleWheelStates( vehicle, unpack( wheelStates ) )
end
addEvent( "onColHit", true )
addEventHandler( "onColHit", root, onColHit )