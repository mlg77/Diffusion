% Main Run all; Choose which model/models then run both types of diffusion and plot  
% Author: Michelle Goodman
% Date: 2/01/2017

clear; clc; close all; 
tic

%% File Location
AllDir.ParentDir = 'C:\Temp\Diffusion\MOL_PDE\';
AllDir.SourceDir = '1. Source files\10. CLean Up Of Run\';
AllDir.SaveDir = '4. Output files\NewFormat';

%% Always Produce both diffusion types in this file however choose which models etc
prompt1 = 'How many models would you like to run? (1/2/3 Note only one toy): ';
numModels = input(prompt1);

for ii = 1:numModels

	% Model sets are goldbeter ernmentrout or toy model then if toy model which one?
	prompt = 'What Model? Goldbeter(G) Ernmentrout(E) or Toy Model (T(1/2/3)): ';
	mystr2 = input(prompt,'s');

	acceptable = [{'G'}, {'E'}, {'T1'}, {'T2'}, {'T3'}];
	while ismember(mystr,acceptable) == 0
		display('Choose again! Check correct captles')
		mystr2 = input(prompt,'s');
	end

	% Find out Inital Conditions
	[ mybeta, tspan, y0, x, M, mtol, odeoptions ] = Inital_Conditions( mystr )

	Goldbeter.On = 0;
	Ernmentrout.On = 0;
	Toy.On = 0;
		
	% Depending on model open file and run
	if strcmp(mystr, 'G')
		Goldbeter.On = 1;
		Diff_type = 1; D =0;
		display(['Diffusion = ', num2str(D)])
		[t, y0D] = ode45(@(t,y) odefun_Goldbeter(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions);
		Goldbeter.Z0D = y0D(:, 1:M)';
		Goldbeter.V0D = y0D(:, M+1:2*M)';
		Goldbeter.Y0D = y0D(:, 2*M+1:3*M)';

		Diff_type = 1; D = 6e-6;
		display(['Diffusion = ', num2str(D)])
		[t, yFD] = ode45(@(t,y) odefun_Goldbeter(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions);
		Goldbeter.ZFD = yFD(:, 1:M)';
		Goldbeter.VFD = yFD(:, M+1:2*M)';
		Goldbeter.YFD = yFD(:, 2*M+1:3*M)';
		
		Goldbeter.t = t;
		Goldbeter.mybeta = mybeta;
		Goldbeter.x = x;
		
	elseif strcmp(mystr, 'E')
		Ernmentrout.On = 1;
		Diff_type = 1; D =0;
		display(['Diffusion = ', num2str(D)])
		[t, y0D] = ode45(@(t,y) odefun_Erm(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions);
		Ernmentrout.Z0D = y0D(:, 1:M)';
		Ernmentrout.V0D = y0D(:, M+1:2*M)';
		Ernmentrout.N0D = y0D(:, 2*M+1:3*M)';
		
		Diff_type = 1; D = 60e-6;%  0;%
		display(['Diffusion = ', num2str(D)])
		[t, yFD] = ode45(@(t,y) odefun_Erm(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions);
		Ernmentrout.ZFD = yFD(:, 1:M)';
		Ernmentrout.VFD = yFD(:, M+1:2*M)';
		Ernmentrout.NFD = yFD(:, 2*M+1:3*M)';
		
		Ernmentrout.t = t;
		Ernmentrout.mybeta = mybeta;
		Ernmentrout.x = x;
		
	elseif strcmp(mystr(1), 'T') %%%% Check this works
		toymodelNo = str2num(mystr(2)); %% Check This
		Toy.On = 0;
		Toy.modelNo = toymodelNo;

		Diff_type = 1; D =0;
		display(['Diffusion = ', num2str(D)])
		[t, y0D] = ode45(@(t,y) odefun_ToyH(t,y,mybeta,Diff_type, D, toymodelNo), tspan, y0, odeoptions);
		Toy.Z0D = y0D(:, 1:M)';
		Toy.V0D = y0D(:, M+1:2*M)';

		Diff_type = 1; D =6e-6;
		display(['Diffusion = ', num2str(D)])
		[t, yFD] = ode45(@(t,y) odefun_ToyH(t,y,mybeta,Diff_type, D, toymodelNo), tspan, y0, odeoptions);
		Toy.ZFD = yFD(:, 1:M)';
		Toy.VFD = yFD(:, M+1:2*M)';
		
		Toy.t = t;
		Toy.mybeta = mybeta;
		Toy.x = x;
	end
end

MyPlot(Goldbeter, Ernmentrout, Toy)


    
