//Air to air range
//Spawns enemy aircraft when an aircraft is inside the a2a zone

if !(isServer) exitWith {};

timer1 = 0;

params ["_tList"];
_unitTypes = [
"O_Plane_Fighter_02_Stealth_F",
//"O_PLane_CAS_02_dynamicLoadout_F",
"rhs_mig29s_vvsc",
"rhs_mig29sm_vvsc",
//"RHS_Su25SM_vvsc",
"RHS_t50_vvs_052"
];

/*
Each time a play enters into the zone, a check is made to see if they're currently in _playerTargets. If they are, nothing is done since enemy aircraft have been spawned for them. If they are not, enemy aircraft are spawned based upon a global variable that is changeable via action menu on the nimitz. The player is added to _playerTargets and the aircraft are added to an array within _enemyAircraft at a corresponding index. Each time an aircraft is destroyed, an mpKilled EH checks if all the other enemy aircraft spawned for the player are dead, if they are, the enemy array is removed from _enemyAircraft and the player is removed from _playerTargets after 20 seconds.
*/

{
	if (side _x == west) then {
		if !(_x in (a2aTargets select 0)) then {
			//spawn more aircraft!!
			_player = _x;
			_index = (a2aTargets select 0) pushBack _player;

			_ehHandle = _player addEventHandler ["Killed", {[_this] spawn a2aKilled;}];
			_player setVariable ["A2AEH", _ehHandle];
			_spawnCount = missionNamespace getVariable ["A2ADiff", 1]; //_spawnCount will be determined by a globalvariable that's set via actionmenu on the nimitz
			_enemyAircraft = [];
			["Spawning Enemy Aircraft"] remoteExec ["Hint",_player];
			for "_i" from 1 to _spawnCount do {

				_unitType = selectrandom _unitTypes;
				_dir = random 359;
				_rPos = [15150.244,8110.756,1500] getPos [(random 7000) + 3000, _dir];
				_rPos set [2, (random 4800) + 200];

				_newUnit = createVehicle [_unitType,[0,0,0], [], 0, "FLY"];
				_newUnit setDir (_dir + 180);
				_newUnit setPos _rPos;

				createVehicleCrew _newUnit;
				{_x reveal (vehicle _player), _x doTarget (vehicle _player); _x setSkill 1;}forEach crew _newUnit;

				_newUnit allowCrewInImmobile true;
				_newUnit lock true;

				_enemyAircraft pushBack _newUnit;
				_newUnit addEventHandler ["Killed", {[_this] spawn a2aDestroyed;}];
			};
			(a2aTargets select 1) pushBack _enemyAircraft;

		};
	};

}forEach _tList;

