/*
	File: handler_moneyControl.sqf
	Author: Demellion Dismal

	Description:
	Advanced altis money control system with graphics and logs of operations

	Execution: [] call compile
	Log format: %player% [%uid]: %message% [%pos%]
*/
fnc_moneyHandler = compileFinal "
	_cash = 	_this select 0;
	_atm  = 	_this select 1;
	_gold =     _this select 2;
	_dest = 	_this select 3;
	_invoker =  _this select 4;
	_pos  = 	mapGridPosition player;
	_uid = 		getPlayerUID player;
	_name = 	(name player);
    _xpos = 	(safezonex + 0.294 * safezonew);
    _ypos =  	(safezoney + 0.915 * safezoneh); 


	if (_invoker != _uid) exitWith { [_name,_invoker,_uid,_pos] call fnc_moneyHacker;};
	if (((_cash == 0) OR (isNil ""_cash"")) AND ((_atm == 0) OR (isNil ""_atm"")) AND ((_gold == 0) OR (isNil ""_gold""))) exitWith { [0,_name,_invoker,_uid,_pos] call fnc_moneyLog;};
	if (playeratm + _atm != life_atmbank) then { [1,_name,_invoker,_uid,_pos] call fnc_moneyLog;};
	if (playercash + _cash != life_cash) then { [1,_name,_invoker,_uid,_pos] call fnc_moneyLog;};
	if (playergold + _gold != life_gold) then { [1,_name,_invoker,_uid,_pos] call fnc_moneyLog;};


	fnc_message = {
	    _color 	= _this select 0;
	    _value = _this select 1;
	    _destination = _this select 2;
	    _xpos = _this select 3;
	    _ypos = _this select 4;
	    _curType = _this select 5;
	    _rhesus = """";

		if ((_value > 0) OR (_value < 0)) then { 
		 if (_value > 0) exitWith { 
		 _value = _value call MTP_fnc_numberToString; 
		    _rhesus = ""+""; 
		    }; 
		    if (_value < 0) exitWith { 
		 _value = (_value * -1) call MTP_fnc_numberToString; 
		    _rhesus = ""-""; 
		 }; 
		}; 
		_split = _value splitString """"; 
		_splitCount = count _split; 
		 
		if (_splitCount == 1) then {_value = format [""%1%2"",_rhesus,(_split select 0)];}; 
		if (_splitCount == 2) then {_value = format [""%1%2%3"",_rhesus,(_split select 0),(_split select 1)];}; 
		if (_splitCount == 3) then {_value = format [""%1%2%3%4"",_rhesus,(_split select 0),(_split select 1),(_split select 2)];}; 
		if (_splitCount == 4) then {_value = format [""%1%2 %3%4%5"",_rhesus,(_split select 0),(_split select 1),(_split select 2),(_split select 3)];}; 
		if (_splitCount == 5) then {_value = format [""%1%2%3 %4%5%6"",_rhesus,(_split select 0),(_split select 1),(_split select 2),(_split select 3),(_split select 4)];}; 
		if (_splitCount == 6) then {_value = format [""%1%2%3%4 %5%6%7"",_rhesus,(_split select 0),(_split select 1),(_split select 2),(_split select 3),(_split select 4),(_split select 5)];}; 
		if (_splitCount == 7) then {_value = format [""%1%2 %3%4%5,%6%7%8"",_rhesus,(_split select 0),(_split select 1),(_split select 2),(_split select 3),(_split select 4),(_split select 5),(_split select 6)];}; 
		if (_splitCount == 8) then {_value = format [""%1%2%3 %4%5%6,%7%8%9"",_rhesus,(_split select 0),(_split select 1),(_split select 2),(_split select 3),(_split select 4),(_split select 5),(_split select 6),(_split select 7)];}; 
		if (_splitCount == 9) then {_value = format [""%1%2%3%4 %5%6%7 %7%8%9"",_rhesus,(_split select 0),(_split select 1),(_split select 2),(_split select 3),(_split select 4),(_split select 5),(_split select 6),(_split select 7),(_split select 8)];};  
		if (_splitCount > 9)  then {_value = format [""%1%2"",_rhesus,""999 999 999++""];}; 
	    
	    if (!(alive player) OR (life_playerdead)) then {_ypos = (safezoney + 0.825 * safezoneh);};
	    playSound 'click';
	    sleep 0.2;
	    playSound 'Beep_Target';
	    _text = format['<t color=""%1"" size = ""1.2""><t shadow=""1"">%2 %4<br /><t color=""#000"" size=""0.8"">%3<br /></t></t>', _color, _value, _destination, _curType];
	    [_text, _xpos, _ypos, 6, 0.5, 0, 789] spawn BIS_fnc_dynamicText;
	    for ""_i""
	    from 0 to 0.10 step 0.01 do {
	        _ypos = _ypos - 0.01;
	        [_text, _xpos, _ypos, 6, 0, 0, 789] spawn BIS_fnc_dynamicText;
	        sleep 0.01;
	    };
	};    

	switch (_dest) do {
		case ""cash"": {
			if (_cash > 0) then {
				if (source_r == 'admin') then {
				_destination = 'to pocket from admin';
	    		_color = '#00FF00';
	    		_value = _cash; 
				_curType = 'Ce';
	    		[_color,_value,_destination,_xpos,_ypos,_curType] spawn fnc_message;					
	    		};
	    		if (source_r == '[UNKNOWN]') then {
				_destination = 'to your pocket';
	    		_color = '#00FF00';
	    		_value = _cash; 
				_curType = 'Ce';
	    		[_color,_value,_destination,_xpos,_ypos,_curType] spawn fnc_message;
	    		};				
			} else
			{
			    _destination = 'from your pocket';
			    _color = '#FF0000';
			    _value = _cash;
				_curType = 'Ce';
	    		[_color,_value,_destination,_xpos,_ypos,_curType] spawn fnc_message;	
			};
		};
		case ""bank"": {
			if (_atm > 0) then {
				if (source_r == 'admin') then {
				_destination = 'to bank from admin';
	    		_color = '#00FF00';
	    		_value = _atm; 
				_curType = 'Ce';
	    		[_color,_value,_destination,_xpos,_ypos,_curType] spawn fnc_message;
				};
				if (source_r == '[UNKNOWN]') then {
				_destination = 'to your bank account';
	    		_color = '#00FF00';
	    		_value = _atm; 
				_curType = 'Ce';
	    		[_color,_value,_destination,_xpos,_ypos,_curType] spawn fnc_message;
	    		};						
			} else
			{
			    _destination = 'from your bank account';
			    _color = '#FF0000';
			    _value = _atm;
				_curType = 'Ce';
	    		[_color,_value,_destination,_xpos,_ypos,_curType] spawn fnc_message;	
			};
		};
		case ""atm"": {
			if (((playeratm + _atm) == life_atmbank) 
			AND ((playercash - _atm) == life_cash)) then {
			if !(isNull (findDisplay 2700)) then {
				if (_cash > 0) then {
				_destination = 'widtrawn from bank';
	    		_color = '#FF0000';
	    		_value = _atm;
				_curType = 'Ce';
	    		[_color,_value,_destination,_xpos,_ypos,_curType] spawn fnc_message;
	    		};
				if (_cash < 0) then {
				_destination = 'deposited to bank';
	    		_color = '#00FF00';
	    		_value = _atm;
				_curType = 'Ce';
	    		[_color,_value,_destination,_xpos,_ypos,_curType] spawn fnc_message;
	    		};
			} else
			{
 				[_name,_invoker,_uid,_pos] call fnc_moneyHacker;				
			};
			} else
			{
				[_name,_invoker,_uid,_pos] call fnc_moneyHacker;
			};
		};
		case ""gold"": {
				if (_gold > 0) then {
				if (source_r == 'admin') then {
				_destination = 'gold from admin';
	    		_color = '#FFD700';
	    		_value = _gold;
				_curType = 'G';
	    		[_color,_value,_destination,_xpos,_ypos,_curType] spawn fnc_message;
				};
				if (source_r == '[UNKNOWN]') then {
				_destination = 'gold recieved';
	    		_color = '#FFD700';
	    		_value = _gold;
				_curType = 'G';
	    		[_color,_value,_destination,_xpos,_ypos,_curType] spawn fnc_message;
	    		};
	    		};
				if (_gold < 0) then {
				_destination = 'gold spend';
	    		_color = '#FF0000';
	    		_value = _gold;
				_curType = 'G';
	    		[_color,_value,_destination,_xpos,_ypos,_curType] spawn fnc_message;
	    		};
	    };
		case ""goldtoatm"": {
			if !(isNull (findDisplay 2700)) then {
				if ((_gold < 0) && (_atm > 0)) then {
				_destination = format ['+' + '%1 Ce', _atm]; 
	    		_color = '#FF0000';
	    		_value = _gold;
				_curType = 'G';
	    		[_color,_value,_destination,_xpos,_ypos,_curType] spawn fnc_message;
	    		};
	    		if ((_gold < 0) && (_cash > 0)) then {
 					[_name,_invoker,_uid,_pos] call fnc_moneyHacker;	
	    		};
	    		if ((_gold > 0) && ((_cash > 0) OR (_atm > 0))) then {
 					[_name,_invoker,_uid,_pos] call fnc_moneyHacker;
	    		};
	    	} else
	    	{
	    		[_name,_invoker,_uid,_pos] call fnc_moneyHacker;
	    	};
	    };
	};
";
// EH for money
[] spawn {
	scriptName "EventHandler_moneyControl";
	// Init
	playercash = life_cash;
	playeratm = life_atmbank;
	playergold = 0; life_gold = 0; // Debug

	// Proxy Handler
	"moneyproxy" addPublicVariableEventHandler {
	call {
		_var        = _this select 0;	
		_owner 		= (_this select 1) select 0;
		_moneytype	= (_this select 1) select 1;
		_value      = (_this select 1) select 2; 
		_object 	= (_this select 1) select 3; 
		_source     = (_this select 1) select 4;

		// Sources:
		//	-1  = admin tool
		//  0   = selling general
		//  1   = reviving someone (medic)
		//  2   = wanted arrest/kill (cop)
		//  3   = selling private (not implemented)
		//  4   = lottery win (not implemented)

		// Usage:
		// moneyproxy = [clientOwner,0,250,player,-1];
		// clientOwner publicVariableClient "moneyproxy";

		if (_owner != clientOwner) exitWith {}; // avoiding errors
		if (_value == 0) exitWith {}; // avoiding nils

		switch (_moneytype) do {
			case 0: {
				if (_source == -1) then {
				life_cash = life_cash + _value;
				source_r = "admin";
				source_uid = (getPlayerUID _object); 
				};
			};
			case 1: {
				if (_source == -1) then {
				life_atmbank = life_atmbank + _value;
				source_r = "admin";
				source_uid = (getPlayerUID _object); 
				};
			};
			case 2: {
				if (_source == -1) then {
				life_gold = life_gold + _value;
				source_r = "admin";
				source_uid = (getPlayerUID _object); 
				};
			};
		};

    };	
	};	
	// MainHandler
	call {
	while {true} do {
		if ((!isNil "playercash") && (!isNil "playeratm") && (!isNil "playergold")) then {
			if ((playercash != life_cash) OR (playeratm != life_atmbank) OR (playergold != life_gold)) then {
				if (isNil "source_r") then {source_r = "[UNKNOWN]"};
				if ((isNil "source_uid") OR (source_uid == (getPlayerUID player))) then {source_uid = "[LOCAL]"};
				_cash = life_cash - playercash;
				_atm = life_atmbank - playeratm;
				_gold = life_gold - playergold;
				// Pure Cash change
				if ((playercash != life_cash) && (playeratm == life_atmbank)) then {
					[_cash,_atm,_gold,"cash",(getPlayerUID player)] call fnc_moneyHandler;
				};
				// Pure ATM change
				if ((playercash == life_cash) && (playeratm != life_atmbank)) then {
					[_cash,_atm,_gold,"bank",(getPlayerUID player)] call fnc_moneyHandler;
				};
				// Mixed change (like atm-to-cash)
				if ((playercash != life_cash) && (playeratm != life_atmbank)) then {
					[_cash,_atm,_gold,"atm",(getPlayerUID player)] call fnc_moneyHandler;
				};
				// Pure Gold Change
				if ((playergold != life_gold) && (playercash == life_cash)) then {
					[_cash,_atm,_gold,"gold",(getPlayerUID player)] call fnc_moneyHandler;
				};
				// Gold to ATM Change
				if ((playergold != life_gold) && ((playeratm != life_atmbank) OR (playercash != life_cash))) then {
					[_cash,_atm,_gold,"goldtoatm",(getPlayerUID player)] call fnc_moneyHandler;
				};				
			}; 
		};
		// Recount
		playercash = life_cash;
		playeratm = life_atmbank;
		playergold = life_gold;
		sleep 0.25; 
	};
	};
};
