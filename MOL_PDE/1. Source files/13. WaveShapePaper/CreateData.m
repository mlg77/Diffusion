% Main Run all; Choose which model/models then run both types of diffusion and plot  
% Author: Michelle Goodman
% Date: 2/01/2017

clear; clc; % close all; 
tic

%% File Location
AllDir.ParentDir = 'C:\Temp\Diffusion\MOL_PDE\';
AllDir.SourceDir = '1. Source files\13. WaveShapePaper\';
AllDir.SaveDir = '4. Output files\WaveShapePaper';


    
%% Ernmentrout
display('Ernmentrout')
[ mybeta, tspan, y0, x, M, mtol, odeoptions ] = Inital_Conditions( 'E' );
Diff_type = 1; D =0;
display(['Diffusion = ', num2str(D)])
[t, y0D] = ode45(@(t,y) odefun_Erm(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions);
Ernmentrout.ZBD = y0D(:, 1:M)';

Ernmentrout.mybetaB = mybeta;

display(['Diffusion = ', num2str(D)])
mybeta = x'*0.2 + 0.2;% adjust so that gives half.
[t, y0D] = ode45(@(t,y) odefun_Erm(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions);
Ernmentrout.Z0D = y0D(:, 1:M)';

Diff_type = 1; D = 60e-6;%  0;%
display(['Diffusion = ', num2str(D)])
[t, yFD] = ode45(@(t,y) odefun_Erm(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions);
Ernmentrout.ZFD = yFD(:, 1:M)';

Ernmentrout.t = t;
Ernmentrout.mybeta = mybeta;
Ernmentrout.x = x;

%% Toy 1
[ mybeta, tspan, y0, x, M, mtol, odeoptions ] = Inital_Conditions( 'T1' );
display('Toy1')
toymodelNo = 1;

Diff_type = 1; D =0;
display(['Diffusion = ', num2str(D)])
[t, y0D] = ode45(@(t,y) odefun_ToyH(t,y,mybeta,Diff_type, D, toymodelNo), tspan, y0, odeoptions);
Toy1.ZBD = y0D(:, 1:M)';

y0 = [y0D(end, 431)+x*0, y0D(end, M + 431)+x*0];
Diff_type = 1; D =0;
display(['Diffusion = ', num2str(D)])
[t, y0D] = ode45(@(t,y) odefun_ToyH(t,y,mybeta,Diff_type, D, toymodelNo), tspan, y0, odeoptions);
Toy1.Z0D = y0D(:, 1:M)';

Diff_type = 1; D =6e-6;
display(['Diffusion = ', num2str(D)])
[t, yFD] = ode45(@(t,y) odefun_ToyH(t,y,mybeta,Diff_type, D, toymodelNo), tspan, y0, odeoptions);
Toy1.ZFD = yFD(:, 1:M)';

Toy1.t = t;
Toy1.mybeta = mybeta;
Toy1.x = x;

%% Toy 2
[ mybeta, tspan, y0, x, M, mtol, odeoptions ] = Inital_Conditions( 'T2' );
display('Toy2')
toymodelNo = 2;

Diff_type = 1; D =0;
display(['Diffusion = ', num2str(D)])
[t, y0D] = ode45(@(t,y) odefun_ToyH(t,y,mybeta,Diff_type, D, toymodelNo), tspan, y0, odeoptions);

y0 = y0D(end, :);
Diff_type = 1; D =0;
display(['Diffusion = ', num2str(D)])
[t, y0D] = ode45(@(t,y) odefun_ToyH(t,y,mybeta,Diff_type, D, toymodelNo), tspan, y0, odeoptions);

y0 = y0D(end, :);
Diff_type = 1; D =0;
display(['Diffusion = ', num2str(D)])
[t, y0D] = ode45(@(t,y) odefun_ToyH(t,y,mybeta,Diff_type, D, toymodelNo), tspan, y0, odeoptions);

Toy2.ZBD = y0D(:, 1:M)';

y0 = [y0D(end, 481)+x*0, y0D(end, M + 481)+x*0];

tspan = [0:0.02:1000];
Diff_type = 1; D =0;
display(['Diffusion = ', num2str(D)])
[t, y0D] = ode45(@(t,y) odefun_ToyH(t,y,mybeta,Diff_type, D, toymodelNo), tspan, y0, odeoptions);
Toy2.Z0D = y0D(:, 1:M)';

Diff_type = 1; D =6e-6;
display(['Diffusion = ', num2str(D)])
[t, yFD] = ode45(@(t,y) odefun_ToyH(t,y,mybeta,Diff_type, D, toymodelNo), tspan, y0, odeoptions);
Toy2.ZFD = yFD(:, 1:M)';

Toy2.t = t;
Toy2.mybeta = mybeta;
Toy2.x = x;


%% FitzHugh–Nagumo
[ mybeta, tspan, y0, x, M, mtol, odeoptions ] = Inital_Conditions( 'F' );
display('FitzHugh–Nagumo model')
Diff_type = 1; D =0;
display(['Diffusion = ', num2str(D)])
[t, y0D] = ode45(@(t,y) odefun_Fitz(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions);
FitzHugh.ZBD = y0D(:, 1:M)';
FitzHugh.ZBD = FitzHugh.ZBD(:, round(length(t)*0.8):end);

FitzHugh.mybetaB = mybeta;

tspan = [0:0.01: 1000];
display(['Diffusion = ', num2str(D)])
mybeta = ((x*0.4+0.3)'*2*0.323);
[t, y0D] = ode45(@(t,y) odefun_Fitz(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions);
FitzHugh.Z0D = y0D(:, 1:M)';

Diff_type = 1; D =0.5e-6;
display(['Diffusion = ', num2str(D)])
[t, yFD] = ode45(@(t,y) odefun_Fitz(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions);
FitzHugh.ZFD = yFD(:, 1:M)';


FitzHugh.t = t;
FitzHugh.mybeta = mybeta;
FitzHugh.x = x;

%% Dupont
[ mybeta, tspan, y0, x, M, mtol, odeoptions ] = Inital_Conditions( 'D' );
display('Dupont')
Diff_type = 1; D =0;
display(['Diffusion = ', num2str(D)])
[t, y0D] = ode45(@(t,y) odefun_Dupont(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions);
Dupont.ZBD = y0D(:, 1:M)';

Dupont.mybetaB = mybeta;

display(['Diffusion = ', num2str(D)])
mybeta = ((x*0.5+0.25)*0.792)';
[t, y0D] = ode45(@(t,y) odefun_Dupont(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions);
Dupont.Z0D = y0D(:, 1:M)';

Diff_type = 1; D = 6e-6;
display(['Diffusion = ', num2str(D)])
[t, yFD] = ode45(@(t,y) odefun_Dupont(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions);
Dupont.ZFD = yFD(:, 1:M)';

Dupont.t = t;
Dupont.mybeta = mybeta;
Dupont.x = x;

y0D = 0; yFD = 0; 
ifsave = 1;
if ifsave
    cd([AllDir.ParentDir , AllDir.SaveDir ])
    save('All_run_data')
    cd([AllDir.ParentDir , AllDir.SourceDir ])
end

Plot_Basic