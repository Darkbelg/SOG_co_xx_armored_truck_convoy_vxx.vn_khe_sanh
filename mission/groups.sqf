// Array of all groups that need IDs/Markers.
// FORMAT: [groupIDVariable,groupName,markerType,markerName,markerColor,createChannelGroup]
// * Markers are NEVER shared between sides.
// * You can edit the RGBA values to change the colours.
// * You can delete any groups you're not using (e.g. remove '_grpBLU = [ ... ];' if you're OPFOR).
// ====================================================================================
private ["_red", "_blue", "_green", "_yellow", "_orange", "_purple", "_black", "_white"];
_red = 		[1,   0,   0,   1	];
_blue = 	[0,   0,   1,   1	];
_green = 	[0,   0.5, 0,   1	];
_color = 	[1,   0,   1,   1	];
_yellow = 	[1,   1,   0,   1	];
_orange = 	[1,   0.6, 0,   1	];
_purple	=	[0.5, 0,   0.5, 1 	];
_black =	[0,   0,   0,   1	];
_white =	[1,   1,   1,   1	];

_grpBLU = [
	["GrpBLU_CO","CO","b_mech_inf","CO",_yellow]
	,["GrpBLU_ASL","Alpha","b_mech_inf","A",_red]
	,["GrpBLU_BSL","Bravo","b_mech_inf","B",_blue]
	,["GrpBLU_CSL","Charlie","b_mech_inf","C",_green]
	,["GrpBLU_DSL","Delta","b_mech_inf","D",_orange]
	,["GrpBLU_IFV1","Echo","b_mech_inf","E",_purple]
	,["GrpBLU_IFV2","Foxtrot","b_mech_inf","F",_color]
];
