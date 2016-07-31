function [L_Z, L_V] = calc_L_ZYV(Z, V, mbeta)
%Toy Model Equations Set
%   Calculates the non linear concentration rates for the calciun in the
%   cytocol, Z, the calcium in the stores, and the membrain potential.
%   where beta is a spatially varying variable 

malpha = 1;
malpha2 = 0.5;

use_model = '5g';

%% L equations 5b
if use_model == '5b'
    L_Z =  mbeta.*V.*exp(-malpha.*V);
    L_V =  -mbeta.*Z;
elseif use_model == '5c'
    L_Z =  mbeta.*V.*exp(malpha.*V);
    L_V =  -mbeta.*Z;
% elseif use_model == '5d' % Negative version
%     malpha = 0.2;
%     L_Z =  -mbeta.*V - Z.^3./3 +Z;
%     L_V =  mbeta.*Z + malpha;
elseif use_model == '5d' % Positive Sent Paul
    malpha = -0.2;
    L_Z =  -malpha.*V - Z.^3./3 +Z;
    L_V =  malpha.*Z + mbeta;
elseif use_model == '5e' % Make symetrical
    malpha = -1;
    L_Z =  -mbeta.*V- Z.^2./2 - Z.^3./3;
%     L_Z =  -mbeta.*V- Z.^2./5 - Z.^3./3;
    L_V =  mbeta.*Z + malpha;
elseif use_model == '5f' % Paul make better
    malpha = -0.2;
    L_Z =  -mbeta.*V - Z.^3./3 +Z;
    L_V =  mbeta.*Z + malpha;
elseif use_model == '5g' % Back heavy
   malpha = -1.5;
    L_Z =  -mbeta.*V - Z.^3./3 +Z;
    L_V =  mbeta.*Z + malpha;
end


% L_Z =  mbeta.*(V.*(exp(-malpha.*Z)-exp(-malpha2.*Z)));
end

