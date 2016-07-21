#include "..\..\script_macros.hpp"
/*
	File: fn_deathEffect.sqf
	Author: Demellion Dismal

	Description:
	Death PP Effect Switch
*/

life_deatheffect = {
_state = _this select 0;
      
if (_state == 1) then {
      //systemChat "DEBUG: Player death."; 
      5 fadesound 0;
      playMusic "";
      playMusic "EventTrack02_F_Curator";
      "colorCorrections" ppEffectEnable true;
      "dynamicBlur" ppEffectEnable true;   
      "colorCorrections" ppEffectAdjust [0.95, 1.0, 0.0,[0.14, 0.14, 0.4, 0.0],[0.4, 0.75, 0.65, 0.70],[0.4,-5.5,0.4,-0.1]]; 
      "colorCorrections" ppEffectCommit 2;
      "dynamicBlur" ppEffectAdjust [3]; 
      "dynamicBlur" ppEffectCommit 3;
};
if (_state == 0) then {
      //systemChat "DEBUG: Player respawned.";
      force_spawned = false; 
      1 fadesound 1;
      resetCamShake;
      player enableSimulation true;
      "colorCorrections" ppEffectEnable false;
      "dynamicBlur" ppEffectEnable false;      
};
};
