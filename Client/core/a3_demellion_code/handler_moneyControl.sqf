/*
	File: handler_moneyControl.sqf
	Author: Demellion Dismal

	Description:
	Advanced altis money control system with graphics and logs of operations

	Execution: [] execVM, [] spawn
	Log format: %player% [%uid]: %message% [%pos%]
*/

fnc_moneyHandler = compileFinal "
	_cash = 	_this select 0;
	_atm  = 	_this select 1;
	_dest = 	_this select 2;
	_invoker =  _this select 3;
	_pos  = 	mapGridPosition player;
	_uid = 		getPlayerUID player;
	_name = 	(name player);
    _xpos = 	(safezonex + 0.294 * safezonew);
    _ypos = 	(safezoney + 0.915 * safezoneh);

	if (_invoker != _uid) exitWith { [_name,_invoker,_uid,_pos] call fnc_moneyHacker;};
	if (((_cash == 0) OR (isNil ""_cash"")) AND ((_atm == 0) OR (isNil ""_atm""))) exitWith { [0,_name,_invoker,_uid,_pos] call fnc_moneyLog;}; // NULL arguments call 
	if (playeratm + _atm != life_atmbank) then { [1,_name,_invoker,_uid,_pos] call fnc_moneyLog;}; // 1 - code malfunction due to tick discruption 
	if (playercash + _cash != life_cash) then { [1,_name,_invoker,_uid,_pos] call fnc_moneyLog;};  // 1 - code malfunction due to tick discruption  

	fnc_message = {
	    _color 	= _this select 0;
	    _value = _this select 1;
	    _destination = _this select 2;
	    _xpos = _this select 3;
	    _ypos = _this select 4;

	    playSound 'click';
	    sleep 0.2;
	    playSound 'Beep_Target';
	    _text = format['<t color=""%1"" size = ""1.2""><t shadow=""1"">%2$<br /><t color=""#000"" size=""0.8"">%3<br /></t></t>', _color, _value, _destination];
	    [_text, _xpos, _ypos, 4, 0.5, 0, 789] spawn BIS_fnc_dynamicText;
	    for ""_i""
	    from 0 to 0.10 step 0.01 do {
	        _ypos = _ypos - 0.01;
	        [_text, _xpos, _ypos, 4, 0, 0, 789] spawn BIS_fnc_dynamicText;
	        sleep 0.01;
	    };
	};    

	switch (_dest) do {
		case ""cash"": {
			if (_cash > 0) then {
				_destination = 'to your pocket';
	    		_color = '#00FF00';
	    		_value = _cash;	
	    		[_color,_value,_destination,_xpos,_ypos] spawn fnc_message;				
			} else
			{
			    _destination = 'from your pocket';
			    _color = '#FF0000';
			    _value = _cash;
	    		[_color,_value,_destination,_xpos,_ypos] spawn fnc_message;	
			};
		};
		case ""bank"": {
			if (_atm > 0) then {
				_destination = 'to your bank account';
	    		_color = '#00FF00';
	    		_value = _atm;
	    		[_color,_value,_destination,_xpos,_ypos] spawn fnc_message;						
			} else
			{
			    _destination = 'from your bank account';
			    _color = '#FF0000';
			    _value = _atm;
	    		[_color,_value,_destination,_xpos,_ypos] spawn fnc_message;	
			};
		};
		case ""atm"": {
			if ((playeratm + _atm) == life_atmbank) then {
				if (_cash > 0) then {
				_destination = 'widtrawn from bank';
	    		_color = '#FF0000';
	    		_value = _atm;
	    		[_color,_value,_destination,_xpos,_ypos] spawn fnc_message;
	    		};
				if (_cash < 0) then {
				_destination = 'deposited to bank';
	    		_color = '#00FF00';
	    		_value = _atm;
	    		[_color,_value,_destination,_xpos,_ypos] spawn fnc_message;
	    		};
			} else
			{
 				[_name,_invoker,_uid,_pos] call fnc_moneyHacker;				
			};

		};
	};

";

// EH for money
while {alive player} do {
	if ((!isNil "playercash") && (!isNil "playeratm")) then {
		if ((playercash != life_cash) OR (playeratm != life_atmbank)) then {
			_cash = life_cash - playercash;
			_atm = life_atmbank - playeratm;
			// Pure Cash change
			if ((playercash != life_cash) && (playeratm == life_atmbank)) then {
				[_cash,_atm,"cash",(getPlayerUID player)] call fnc_moneyHandler;
			};
			// Pure ATM change
			if ((playercash == life_cash) && (playeratm != life_atmbank)) then {
				[_cash,_atm,"bank",(getPlayerUID player)] call fnc_moneyHandler;
			};
			// Mixed change (like atm-to-cash)
			if ((playercash != life_cash) && (playeratm != life_atmbank)) then {
				[_cash,_atm,"atm",(getPlayerUID player)] call fnc_moneyHandler;
			};			
		}; 
	};
	playercash = life_cash;
	playeratm = life_atmbank;
	sleep 0.25; 
};



