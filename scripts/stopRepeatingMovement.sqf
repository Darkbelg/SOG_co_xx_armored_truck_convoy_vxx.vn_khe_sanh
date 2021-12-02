params ["_nameBeginsWith","_amountOfObjects"];
if (isDedicated) exitwith {};

for "_i" from 0 to _amountOfObjects do {  
	[(format ["%2%1event",_i,_nameBeginsWith]), "onEachFrame"] call BIS_fnc_removeStackedEventHandler;

	//create vehicle locally
	private _originalObject = missionNamespace getVariable (format ["%2%1",_i,_nameBeginsWith]); 
	private _fakeObject = _originalObject getVariable "fakeVehicle";
	[_originalObject,false] remoteExec ["hideObjectGlobal", 2];
	//_originalObject setPosASL( getPosASL _fakeObject);
	
	// Moving the position and then retrigger of the code just moves the animation further the way the vector is set.
	//private _fakeObjectLocation = getPosASL _fakeObject;
	// [_originalObject,_fakeObjectLocation] remoteExec ["setPosASL",2];
	//_originalObject setPosASL _fakeObjectLocation;
	deleteVehicle _fakeObject;
};

