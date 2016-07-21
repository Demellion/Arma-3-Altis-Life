#include "..\..\script_macros.hpp"
/*
	File: fn_revivedPenalty.sqf
	Author: Demellion Dismal 

	Description:
	Inits revival aftermath penalty function
*/

life_fnc_revivepenalty = {
            waitUntil {!isNil {player getVariable "Revive"}};
            systemChat "DEBUG: Player revived."; 
            1 fadesound 1;
            player switchMove "incapacitated";
            player setHit ["legs",1];
            showHud false;
            "colorCorrections" ppEffectAdjust [0.95, 1.0, 0.2,[0.14, 0.14, 0.4, 0.0],[1.5, 1.5,1.5, 0.70],[5.4,-5.5,5.4,-0.1]]; 
            "colorCorrections" ppEffectCommit 0;
            "colorCorrections" ppEffectAdjust [0.95, 1.0, 0.0,[0.14, 0.14, 0.4, 0.0],[0.4, 0.75, 0.65, 0.70],[0.4,-0.5,0.4,-0.1]]; 
            "colorCorrections" ppEffectCommit 3;
            sleep 1;
            player enableSimulation false;
            enableCamShake true; 
            addCamShake [25, 5000, 0.1];
            for "_x" from 1 to 4 step 0.5 do {
               "dynamicBlur" ppEffectEnable true; 
               "colorCorrections" ppEffectEnable true;
               "dynamicBlur" ppEffectAdjust [random(6)]; 
               "dynamicBlur" ppEffectCommit 1;
               sleep 0.5;
               "dynamicBlur" ppEffectAdjust [1]; 
               "dynamicBlur" ppEffectCommit 2;
               sleep 1;
               "dynamicBlur" ppEffectAdjust [random(3)];
               "colorCorrections" ppEffectAdjust [0.95, 1.0, 0.0,[0.14, 0.14, 0.4, 0.0],[0.4, 0.75, 0.85, 0.70],[0.4,-0.5,0.4,-0.1]]; 
               "colorCorrections" ppEffectCommit 0.5;
               "dynamicBlur" ppEffectCommit 0.5;
               sleep (1.5 + random 5);
               "colorCorrections" ppEffectAdjust [0.95, 0.0, 0.0,[0.14, 0.14, 0.4, 0.0],[0.4, 0.75, 0.65, 0.70],[0.4,-0.5,0.4,-0.1]]; 
               "colorCorrections" ppEffectCommit 0.5; 
               "dynamicBlur" ppEffectAdjust [0]; 
               "dynamicBlur" ppEffectCommit 1;
            };
            resetCamShake;
            "colorCorrections" ppEffectAdjust [0.95, 1.0, 0.0,[0.14, 0.14, 0.4, 0.0],[0.4, 0.75, 0.85, 0.70],[0.4,-0.5,0.4,-0.1]]; 
            "colorCorrections" ppEffectCommit 0.5;
            player playMove "AmovPpneMstpSnonWnonDnon_AmovPknlMstpSnonWnonDnon";
            [] spawn {
               for "_x" from 1 to 180 step 1 do {
                  player setFatigue 1;
                  sleep 1; 
                  if (new_spawned) exitWith {};
               };
            };
            player enableSimulation true;
            showHud true;
            enableCamShake true;
            addCamShake [12, 140, 0.75];
            for "_x" from 1 to 25 step 1 do {
               "dynamicBlur" ppEffectEnable true;   
               "dynamicBlur" ppEffectAdjust [random(1)]; 
               "dynamicBlur" ppEffectCommit 0.5;
               sleep (0.5 + random 1);
               "dynamicBlur" ppEffectAdjust [random(6)];
               "dynamicBlur" ppEffectCommit 0.5;
               sleep (1.5 + random 1);
            };
            "dynamicBlur" ppEffectAdjust [0];
            "dynamicBlur" ppEffectCommit 2;
            "dynamicBlur" ppEffectEnable false; 
            "colorCorrections" ppEffectEnable false;

};
