params ["_nameBeginsWith","_amountOfObjects",["_maxPositionVector",[0,0,1]],["_randomMovementTime",[5,9,10]],["_scalingObjects",false]];
if (isDedicated) exitwith {};

for "_i" from 0 to _amountOfObjects do {  
	private _originalObject = missionNamespace getVariable (format ["%2%1",_i,_nameBeginsWith]); 

	[_originalObject,true] remoteExec ["hideObjectGlobal", 2];
	private _originalObjectPosition = _originalObject getVariable "position";
	if (isNil "_originalObjectPosition") then
	{
		_originalObjectPosition = getPosASL _originalObject;
		_originalObject setVariable ["position",_originalObjectPosition];
	};
	
	private _beginPosition = _originalObjectPosition;
	private _betweenPosition = _beginPosition vectorAdd _maxPositionVector;
	private _finalPosition = _beginPosition vectorAdd [0,0,0];

	_fakeObject = (typeOf _originalObject) createVehicleLocal _beginPosition;
	_fakeObject enableSimulation false;
	_fakeObject setVectorDir (vectorDir _originalObject);
	_originalObject setVariable ["fakeVehicle" ,_fakeObject];

	_fakeObject setVariable ["beginPosition" ,_beginPosition];
	_fakeObject setVariable ["betweenPosition",_betweenPosition];
	_fakeObject setVariable ["finalPosition",_finalPosition];

	private _totalMovementTime = random _randomMovementTime;
	private _t1 = time;
	private _t2 = time + _totalMovementTime;

	_fakeObject setVariable ["totalMovementTime" ,_totalMovementTime];
	_fakeObject setVariable ["t1" ,_t1];
	_fakeObject setVariable ["t2" ,_t2];

	if (_scalingObjects) then {
		_fakeObject setVariable ["maxSizeObject", random [0.5,0.6,1.25]];
	};

	[(format ["%1event",_originalObject]), "onEachFrame" , {
		params ["_object","_scalingObjects"];

		private _t1 = _object getVariable "t1";
		private _t2 = _object getVariable "t2";

		// private _interval = [linearConversion [_t1,_t2, time, 0, 1]] call BIS_fnc_smoothStep;
		private _interval = [0, 1, linearConversion [_t1,_t2, time, 0, 1], 2] call BIS_fnc_easeInOut;

		private _newPosition = (_interval bezierInterpolation [(_object getVariable "beginPosition"),(_object getVariable "betweenPosition"),(_object getVariable "finalPosition")]);

		if (_scalingObjects) then {
			_object setobjectScale linearConversion [0,1, sin (linearConversion [_t1,_t2, time, 0, 180]), 0.5, _object getVariable "maxSizeObject"];
		};

		_object setPosASL _newPosition;

		if (linearConversion [_t1,_t2, time, 0, 1] >= 1) then {
			_object setVariable ["t1" ,time];
			_object setVariable ["t2" ,time + (_object getVariable "totalMovementTime")];
		}
	} , [_fakeObject,_scalingObjects]] call BIS_fnc_addStackedEventHandler;
};
