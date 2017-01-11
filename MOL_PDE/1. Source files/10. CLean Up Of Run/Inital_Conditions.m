function [ mybeta, tspan, y0,x, M, mtol, odeoptions ] = Inital_Conditions( mystr )
% Depending on which model used define the inital conditions
%   Author: Michelle Goodman
%   Date: 02/01/17

if strcmp(mystr, 'G') %Goldbeter
	t0 = 0;   t1 = 100; dt = 0.005;
	dx = 1e-3;  
	x = 0:dx:1;    
	mybeta = (0.5*(1+tanh((x-0.5)/0.5)))';
	% mybeta = (x*0.56)';
	% mybeta = x';
	% start_fixed_beta = find(x== 0.162);
	% fixed_beta = mybeta(start_fixed_beta);
	% mybeta(find(x== 0.156):start_fixed_beta) = fixed_beta;
	Z_0 = 0.3; V_0 = -40; Y_0 = 0.5;
	y0 = [x*0+Z_0, x*0+V_0, x*0+Y_0];
elseif strcmp(mystr, 'E') % Ernmentrout
	t0 = 0;   t1 = 50; dt = 0.01;
	dx = 1e-3;  
	x = 0:dx:1;   
	mybeta = (0.5*(1+tanh((x-0.5)/0.5)))';
	Z_0 = 300; V_0 = -40; N_0 = 0.5;
	y0 = [x*0+Z_0, x*0+V_0, x*0+N_0];
	
elseif strcmp(mystr, 'T1') % Toymodel 1 No Penetrate
	t0 = 0;   t1 = 500; dt = 0.01;
	dx = 1e-3;  
	x = (0:dx:1);    M = length(x); 
	mybeta = 0.5+0.4*(1+tanh((x-0.5)/0.25))'; % HomoPaper Symetric
	x = mybeta';
	X_0 = -1; Y_0 = -1; 
	y0 = [x*0+X_0, x*0+Y_0];
	
elseif strcmp(mystr, 'T2') % Toy Model 2 Penetrate
	t0 = 0;   t1 = 1000; dt = 0.01;
	dx = 1e-3;  
	x = (0:dx:1);    M = length(x); 
	mybeta = 0.4*(1+tanh((x-0.5)/0.25))'; % HomoPaper Front heavy
	x = mybeta';
	X_0 = 0.5; Y_0 = 0.1; 
	y0 = [x*0+X_0, x*0+Y_0];
	
elseif strcmp(mystr, 'T3') % Toymodel 3 Other?
	error('Toymodel3?')

end



%% Diffusion type 1 =(SD) Fickian, 2= (ED)Electro Diffusion 
Diff_type = 1; D =0;% 6e-6;%  0;%

%prompt = {'Diffusion_type:','Diffusion:', };
%dlg_title = 'Input';
%num_lines = 1;
%defaultans = {num2str(Diff_type),num2str(D)};
%answer = inputdlg(prompt,dlg_title,num_lines,defaultans);

M = length(x); 
mtol = 1e-6;
odeoptions = odeset('RelTol',mtol, 'AbsTol', mtol );
tspan = [t0:dt: t1];

end

