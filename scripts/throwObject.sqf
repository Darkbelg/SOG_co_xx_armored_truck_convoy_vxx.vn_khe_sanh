params ["_movingObject","_blowUpObject",["_maxheight",10],["_totalMovementTime",10],["_blowUpObjectVelocity",[15,2,0]]];
if (isDedicated) exitwith {};

private _originalObject = _movingObject; 

[_originalObject,true] remoteExec ["hideObjectGlobal", 2];
private _originalObjectPosition = _originalObject getVariable "position";
if (isNil "_originalObjectPosition") then
{
	_originalObjectPosition = getPosASL _originalObject;
	_originalObject setVariable ["position",_originalObjectPosition];
};

private _beginPosition = _originalObjectPosition;
private _finalPosition = (getPosASL _blowUpObject) vectorAdd [0,0,0];
private _distance = [_beginPosition,_finalPosition] call BIS_fnc_distance2D;
private _direction = [_beginPosition,_finalPosition] call BIS_fnc_dirTo;
private _betweenPosition = [_beginPosition, (_distance/2),_direction] call BIS_fnc_relPos vectorAdd [0,0,_maxheight];

_fakeObject = (typeOf _originalObject) createVehicleLocal _beginPosition;
_fakeObject setVectorDir (vectorDir _originalObject);
_fakeObject setVariable ["originalVehicle" ,_originalObject];

_fakeObject setVariable ["beginPosition" ,_beginPosition];
_fakeObject setVariable ["betweenPosition",_betweenPosition];
_fakeObject setVariable ["finalPosition",_finalPosition];

private _t1 = time;
private _t2 = time + _totalMovementTime;

_fakeObject setVariable ["totalMovementTime" ,_totalMovementTime];
_fakeObject setVariable ["t1" ,_t1];
_fakeObject setVariable ["t2" ,_t2];

_blowUpObject setVariable ["blowUpObjectVelocity",_blowUpObjectVelocity];

[(format ["%1event",_fakeObject]), "onEachFrame" , {
	params ["_object","_blowUpObject"];

	private _t1 = _object getVariable "t1";
	private _t2 = _object getVariable "t2";

	private _interval = linearConversion [_t1,_t2, time, 0, 1];

	private _newPosition = (_interval bezierInterpolation [(_object getVariable "beginPosition"),(_object getVariable "betweenPosition"),(_object getVariable "finalPosition")]);

	_object setPosASL _newPosition;

	if (_interval >= 1) then {
		_originalObject =  _object getVariable "originalVehicle";
		[_originalObject,false] remoteExec ["deleteVehicle", 2];
		[(format ["%1event",_object]), "onEachFrame"] call BIS_fnc_removeStackedEventHandler;
		//_originalObject setPosASL( getPosASL _fakeObject);
		
		// Moving the position and then retrigger of the code just moves the animation further the way the vector is set.
		//private _fakeObjectLocation = getPosASL _fakeObject;
		// [_originalObject,_fakeObjectLocation] remoteExec ["setPosASL",2];
		//_originalObject setPosASL _fakeObjectLocation;
		deleteVehicle _object;
		[_blowUpObject,_blowUpObject getVariable "blowUpObjectVelocity"] remoteExec ["setVelocityModelSpace", 2];
		[_blowUpObject,1] remoteExec ["setDamage", 2];
		PlayMusic "godada";
	}
} , [_fakeObject,_blowUpObject]] call BIS_fnc_addStackedEventHandler;

