function [ mybeta, tspan, y0,x, M, mtol, odeoptions ] = Inital_Conditions( mystr )
% Depending on which model used define the inital conditions
%   Author: Michelle Goodman
%   Date: 02/01/17

if strcmp(mystr, 'G') %Goldbeter
	t0 = 0;   t1 = 20; dt = 0.001;
	dx = 1e-3;  
	x = 0:dx:1;    
% 	mybeta = (0.5*(1+tanh((x-0.5)/0.5)))';
%     mybeta = (0.35*(1+tanh((x-0.5)/0.5)))';
% 	mybeta = (x*0.56)'; % Used for half bi at 0.5
%     mybeta(floor(length(x)/2)) = 0;
	mybeta = x';

%% New dbetadx
typedbetadx = 0;
if typedbetadx == 1
    %% Make beta equal zero at some point
    mybeta = x;
    x_idx_zero = 400;
    mybeta(x_idx_zero) = 0;
elseif typedbetadx == 2
    %% Dbeta dx = 
    newb = 23.8*x.^3 -18.33*x.^2 +4.21*x;
    newb = [newb(1:500) , x(501:end)];
    mybeta = (newb*0.56)';
elseif typedbetadx == 3
    newb = 2*x.^2;
    newb = [newb(1:500) , x(501:end)];
    mybeta = (newb*0.56)';
elseif typedbetadx == 4
    newb = 3/5*x + 0.2;
    newb = [newb(1:500) , x(501:end)];
    mybeta = (newb*0.56)';
elseif typedbetadx == 5
    newb = 3/5*x + 0.2;
    mybeta = (newb*0.56)';
elseif typedbetadx == 6
    newb = (0.5*(1+tanh((x-0.5)/0.5)))';
    mybeta = (newb*0.56);
elseif typedbetadx == 7
    mybeta = x';
    mybeta = (mybeta*0.56);
    mybeta(501:end) = mybeta(551);
elseif typedbetadx == 8
    mybeta = x';
    mybeta = (mybeta*0.56);
    mybeta(501:end) = mybeta(551);
    mybeta(1:500) = mybeta(401);
elseif typedbetadx == 9
%     newb = 47.619*x.^3 -39.52*x.^2 +8.8571*x;
    newb = 38.095*x.^3 -32.38*x.^2 +7.6667*x;
    newb = [newb(1:500) , x(501:end)];
    mybeta = (newb*0.56)';
end
    
	
    Z_0 = 0.5; V_0 = -40; Y_0 = 0.5;
	y0 = [x*0+Z_0, x*0+V_0, x*0+Y_0];
elseif strcmp(mystr, 'E') % Ernmentrout
	t0 = 0;   t1 = 80; dt = 0.01;
	dx = 1e-3;  
	x = 0:dx:1;   
    mybeta = (x*0.3 +0.2)';
%     mybeta = (x*0.1966 +0.2)'; Half?
% 	mybeta = (0.5*(1+tanh((x-0.5)/0.5)))';
	Z_0 = 300; V_0 = -40; N_0 = 0.5;
	y0 = [x*0+Z_0, x*0+V_0, x*0+N_0];
	
elseif strcmp(mystr, 'T1') % Toymodel 1 No Penetrate
	t0 = 0;   t1 = 300; dt = 0.01;
	dx = 1e-3;  
	x = (0:dx:1);    M = length(x); 
	mybeta = 0.5+0.4*(1+tanh((x-0.5)/0.25))'; % HomoPaper Symetric
% 	x = mybeta';
	X_0 = -1; Y_0 = -1; 
	y0 = [x*0+X_0, x*0+Y_0];
	
elseif strcmp(mystr, 'T2') % Toy Model 2 Penetrate
	t0 = 0;   t1 = 1000; dt = 0.01;
	dx = 1e-3;  
	x = (0:dx:1);    M = length(x); 
	mybeta = 0.2*(1+tanh((x-0.5)/0.4))'; % HomoPaper Front heavy
% 	x = mybeta';
    mybeta = 0.2*(1+tanh((x-0.5)/0.4))'; % Testing
    mybeta(floor(length(x)/2):end) = mybeta(floor(length(x)*0.56));
	X_0 = -2; Y_0 = 2; 
	y0 = [x*0+X_0, x*0+Y_0];
	
elseif strcmp(mystr, 'T3') % Toymodel 3 Other?
	error('Toymodel3?')
    
elseif strcmp(mystr, 'F') % Fitz Hugh nogomo
	t0 = 0;   t1 = 600; dt = 0.01;
	dx = 1e-3;  
	x = (0:dx:1);    M = length(x); 
	mybeta = x';
    mybeta = mybeta*2*0.3380+0.01;
	X_0 = -1; Y_0 = 1; 
	y0 = [x*0+X_0, x*0+Y_0];
	
elseif strcmp(mystr, 'K') % Kathi Edit
	t0 = 0;   t1 = 50; dt = 0.01;
	dx = 1e-3;  
	x = (0:dx:1);    M = length(x); 
	mybeta = x';
	Z_0 = 0.1; V_0 = -28.42; Y_0 = 1.36;
	y0 = [x*0+Z_0, x*0+V_0, x*0+Y_0];
    
elseif strcmp(mystr, 'D') %Goldbeter
	t0 = 0;   t1 = 60; dt = 0.002;
	dx = 1e-3;  
	x = 0:dx:1;    
% 	mybeta = (0.5*(1+tanh((x-0.5)/0.5)))';
%     mybeta = (0.35*(1+tanh((x-0.5)/0.5)))';
	mybeta = (x*0.792)'; % Used for half bi at 0.5
%     mybeta(floor(length(x)/2)) = 0;
% 	mybeta = x';
	% start_fixed_beta = find(x== 0.162);
	% fixed_beta = mybeta(start_fixed_beta);
	% mybeta(find(x== 0.156):start_fixed_beta) = fixed_beta;
	Z_0 = 0.5; A_0 = 0.1; Y_0 = 0.5;
	y0 = [x*0+Z_0, x*0+A_0, x*0+Y_0];

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

