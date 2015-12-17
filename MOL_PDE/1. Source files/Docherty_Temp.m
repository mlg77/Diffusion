function [ Z2, Z2b, Z3, t, x, mybeta ] = Docherty_Temp( BetaBase, Betalow, BetaHigh, D )
%Tempery document to run through Docherties suggestions
%   Couples with run_docherty


%% They all have the same IC

Z_0 = 0.3; V_0 = -40; Y_0 = 0.5;
% D = 6e-6;
dt = 1e-3; t_end = 10;
dx = 2e-3;  

t = 0:dt:t_end;   N = length(t);
% x = 0:dx:0.3;   M = length(x); 
x = dx:dx:2*dx;   M = length(x); 

%     mybeta = (0.5*(1+tanh((x-0.5)/0.5)))';
% mybeta = [BetaBase*ones(1, round(0.5*M)),Betalow* ones(1,round(0.5*M)-1)]';
mybeta = [BetaBase, Betalow]';

%% Do Second Section
[ Z2, V2 ] = Gold_Simple( dt, dx, x, t, M, N, Z_0, V_0, Y_0, mybeta, 1);
% Z2 = 0;
%% Do Simple Diffusion section
[ Z2b, V2b ] = Gold_Simple_Diffusion_sp( dt, dx, x, t, M, N, Z_0, V_0, Y_0, mybeta, D);
%% Do Second Section
[ Z3, V3 ] = Gold_Electro_Diffusion_noinvsp( dt, dx, x, t, M, N, Z_0, V_0, Y_0, mybeta, D);

end

