function [ mybeta, tspan, y0,x, M, mtol, odeoptions ] = Inital_Conditions( mystr )
% Depending on which model used define the inital conditions
%   Author: Michelle Goodman
%   Date: 02/01/17


if strcmp(mystr, 'E') % Ernmentrout
	t0 = 0;   t1 = 80; dt = 1e-3;
	dx = 1e-3;  
	x = 0:dx:1;   
    mybeta = (x)';
	Z_0 = 300; V_0 = -40; N_0 = 0.5;
	y0 = [x*0+Z_0, x*0+V_0, x*0+N_0];
	
elseif strcmp(mystr, 'T1') % Toymodel 1 No Penetrate
	t0 = 0;   t1 = 300; dt = 0.01;
	dx = 1e-3;  
	x = (0:dx:1);    M = length(x); 
	mybeta = (x*0.8 + 0.5)'; % HomoPaper Symetric
	X_0 = -1; Y_0 = -1; 
	y0 = [x*0+X_0, x*0+Y_0];
	
elseif strcmp(mystr, 'T2') % Toy Model 2 Penetrate
	t0 = 0;   t1 = 1000; dt = 0.01;
	dx = 1e-3;  
	x = (0:dx:1);    M = length(x); 
	mybeta = (x*0.24 + 0.08)'; % HomoPaper Front heavy
	X_0 = -1.152; Y_0 = 3.6908; 
	y0 = [x*0+X_0, x*0+Y_0];
    
elseif strcmp(mystr, 'F') % Fitz Hugh nogomo
	t0 = 0;   t1 = 600; dt = 0.01;
	dx = 1e-3;  
	x = (0:dx:1);    M = length(x); 
	mybeta = (x*2)';
	X_0 = -1; Y_0 = 1; 
	y0 = [x*0+X_0, x*0+Y_0];
	
elseif strcmp(mystr, 'D') 
	t0 = 0;   t1 = 100; dt = 2e-3;
	dx = 1e-3;  
	x = 0:dx:1;    
	mybeta = x';
	Z_0 = 0.2; A_0 = 0.1; Y_0 = 0.5;
	y0 = [x*0+Z_0, x*0+A_0, x*0+Y_0];

end



%% Diffusion type 1 =(SD) Fickian, 2= (ED)Electro Diffusion 
Diff_type = 1; D =0;% 6e-6;%  0;%

M = length(x); 
mtol = 1e-6;
odeoptions = odeset('RelTol',mtol, 'AbsTol', mtol );
tspan = [t0:dt: t1];

end

