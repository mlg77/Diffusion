function [L_X, L_Y] = calc_Toy(X, Y, mybeta, toymodelNo)
%Toy Hauxaung Set
%   Calculates the non linear concentration rates for the calciun in the
%   cytocol, Z, the calcium in the stores, and the membrain potential.
%   where beta is a spatially varying variable 

if toymodelNo(1) == 1
	% Poster Symetrical 
% 	mybeta = mybeta/2 + 1;
	alpha = 0.9;
	endstuff = -X.^2./2;
 
	L_X = mybeta.*Y - X.^3./3 + endstuff;
	L_Y = -(mybeta.*X + alpha);
	
elseif toymodelNo(1) == 2
	% Poster Penertrate
% 	mybeta = mybeta*0.4 ;
	alpha = 0.2;
	endstuff = X;
    
    if length(toymodelNo) == 1
        factor = 1;
    else
        factor = toymodelNo(2);
    end

	L_X = mybeta.*Y - X.^3/3 + factor*endstuff;
	L_Y = -(mybeta.*X + alpha);

elseif toymodelNo(1) == 3
	error('Toymodel3?')
	%% Attempt Sign / constant change  ###2
	% mymu = mybeta;
	% w = 0.5;
	% b = 0.1;
	% 
	% endstuff = (b.*Y-X).*(X.^2+Y.^2);
	% 
	% L_X = mymu.*X + w.*Y + endstuff;
	% L_Y = -w.*Y - mymu.*X + endstuff;


	%% Attempt Hauxong Model  ###1
	% mymu = mybeta;
	% w = -1/1.5;
	% b = 0.01;
	% 
	% endstuff = (b.*Y-X).*(X.^2+Y.^2);
	% 
	% L_X = mymu.*X - w.*Y + endstuff;
	% L_Y = w.*X + mymu.*Y + endstuff;

	%% Hope for borring No period change ###3
	% w = 0.5;
	% endstuff = (X.^2+Y.^2);
	% 
	% L_X = mybeta.*X - w.*Y - X.*endstuff;
	% L_Y = w.*X + mybeta.*Y - Y.*endstuff;

	%% Hope for borring ###4
	% w = 0.5;
	% endstuff = (X.^2+Y.^2);
	% 
	% L_X = mybeta.*X - (2*mybeta+w).*Y - X.*endstuff;
	% L_Y = (2*mybeta+w).*X + mybeta.*Y - Y.*endstuff;

end



end

