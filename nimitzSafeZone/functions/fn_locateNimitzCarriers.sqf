//locateNimitzCarriers

private["_nimitzList"];
_nimitzList = [];

{
	if(["nimspots",str _x, false] call bis_fnc_inString) then {_nimitzList pushBack _x;};
}forEach vehicles;
diag_log format ["*** LNC OUTPUT: List - %1", _nimitzList];
{
	[_x] spawn psq_fnc_respawnNimitz;
	[_x] spawn psq_fnc_nimitzSafeZone;
	[_x] spawn psq_fnc_nimitzCleanUp;
}forEach _nimitzList;