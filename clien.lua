
local dutyState = false;
local stingers = {}

addEventHandler("onClientResourceStart",resourceRoot,function()
    createWheelCollisions()
end);

addCommandHandler("spike", function(cmd) 
	if(dutyState) then
        local x, y, z = getElementPosition(localPlayer);
        local rx,ry,rz = getElementRotation(localPlayer);
        local z = z-0.8;
    
        local object = createObject( 2899, x, y, z, ry, rx, rz );
        local x0, y0, z0, x1, y1, z1 = getElementBoundingBox( object );
        local h = z1 - z0;
        local time = 600;
    
        moveObject( object, time, x,y,z, 0,0,0, "InQuad" );
        createStingerCollisions(localPlayer, x,y,z, rx,ry,rz, h );
	else
		outputChatBox("Nem vagy szolgálatban.", 255, 255, 255, true);
	end
end)

addCommandHandler("duty", function()
    if dutyState then
        outputChatBox("Sikersen #FF0000Kiléptél #FFFFFF a szolgálatból.", 255,255, 255, true,true,true,false);
    else
        outputChatBox("Sikersen #2ecc71beléptél #FFFFFF a szolgálatba.", 255,255, 255, true,true,true,false);
    end
    dutyState = not dutyState;
end)

function createStingerCollisions( player, x,y,z, rx,ry,rz, h )
	local colC = createColTube( x, y, z, 0.9, 2*h );
	local colL = createColTube( x + 1.7*math.cos( math.rad(rz+90) ), y + 1.7*math.sin( math.rad(rz+90) ), z + 1.7*math.sin( math.rad(ry) ), 0.9, 2*h );
    local colR = createColTube( x - 1.7*math.cos( math.rad(rz+90) ), y - 1.7*math.sin( math.rad(rz+90) ), z - 1.7*math.sin( math.rad(ry) ), 0.9, 2*h );
    
	addEventHandler( "onClientColShapeHit", colC, onPlayerStingerHit );
	addEventHandler( "onClientColShapeHit", colL, onPlayerStingerHit );
	addEventHandler( "onClientColShapeHit", colR, onPlayerStingerHit );
end

local wheelIndex = {["lf"]=1, ["lb"]=2, ["rf"]=3, ["rb"]=4,["front"]=1,["rear"]=2};
local wheel = {};

function createWheelCollisions()
	for marker in pairs( wheel ) do
		destroyElement( marker )
	end
    wheel = {}
    for _, vehicle in pairs(getElementsByType("vehicle", _, true)) do
        if vehicle then
            local vx, vy, vz = getElementPosition( vehicle );
            for component in pairs( getVehicleComponents( vehicle ) ) do
                local wheelstr, r = component:gsub("wheel_", "");
                if r > 0 then
                    wheelstr = wheelstr:gsub("_dummy", "");
                    if wheelIndex[wheelstr] then
                        local wx, wy, wz = getVehicleComponentPosition( vehicle, component );
                        local marker = createMarker( 0, 0, 0, "corona", 0.8, 0, 0, 0, 0 );
                        attachElements( marker, vehicle, wx, wy, wz );
                        wheel[marker] = wheelIndex[wheelstr];
                    end
                end
            end
        end
    end
end


function onPlayerStingerHit( element )
	if not wheel[element] then return end
	triggerServerEvent( "onColHit", localPlayer, wheel[element]);
end
