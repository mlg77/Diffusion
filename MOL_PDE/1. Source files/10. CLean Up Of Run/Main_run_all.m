% Main Run all; Choose which model/models then run both types of diffusion and plot  
% Author: Michelle Goodman
% Date: 2/01/2017

clear; clc; % close all; 
tic

%% File Location
AllDir.ParentDir = 'C:\Temp\Diffusion\MOL_PDE\';
AllDir.SourceDir = '1. Source files\10. CLean Up Of Run\';
AllDir.SaveDir = '4. Output files\NewFormat';
AllDir.Analysis = 'Analysis_functions';

%% Always Produce both diffusion types in this file however choose which models etc
prompt1 = 'How many models would you like to run? (up to 7): ';
numModels = input(prompt1);
if numModels == 6
    mystr = {'G', 'E', 'T1', 'T2', 'F', 'K', 'D'};
else
    for jj = 1:numModels

        % Model sets are goldbeter ernmentrout or toy model then if toy model which one?
        prompt = 'What Model? \nGoldbeter(G) \nErnmentrout(E) \nToy Model (T(1/2/3)) \nFitz(F) \nKath(K) \nDupont (D) \n____________________\n: ';
        mystr{jj} = input(prompt,'s');

        acceptable = [{'G'}, {'E'}, {'T1'}, {'T2'}, {'T3'}, {'F'}, {'K'}, {'D'}];
        while ismember(mystr{jj},acceptable) == 0
            display('Choose again! Check correct captles')
            mystr{jj} = input(prompt,'s');
        end
    end
end

Goldbeter.On = 0;
Ernmentrout.On = 0;
Toy1.On = 0;
Toy2.On = 0;
FitzHugh.On = 0;
KathiEdit.On = 0;
Dupont.On = 0;

for ii = 1:numModels
    mystr2 = mystr{ii};
    
	% Find out Inital Conditions
	[ mybeta, tspan, y0, x, M, mtol, odeoptions ] = Inital_Conditions( mystr2 );

	% Depending on model open file and run
	if strcmp(mystr2, 'G')
        display('Goldbeter')
		Goldbeter.On = 1;
		Diff_type = 1; D =0;
		display(['Diffusion = ', num2str(D)])
		[t, y0D] = ode45(@(t,y) odefun_Goldbeter(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions); 
		Goldbeter.Z0D = y0D(:, 1:M)';
		Goldbeter.V0D = y0D(:, M+1:2*M)';
		Goldbeter.Y0D = y0D(:, 2*M+1:3*M)';
        
        y0max = 0;
        if y0max
            startidx = floor(length(t)*0.8);
            [maxZpoint, idxmaxZpoint] = max(Goldbeter.Z0D(:, startidx:end)');
              
            matchingV = []; matchingY = [];
            for kk = 1:length(x)
                matchingV(kk) = Goldbeter.V0D(kk, idxmaxZpoint(kk)+startidx-1);
                matchingY(kk) = Goldbeter.Y0D(kk, idxmaxZpoint(kk)+startidx-1);
            end

            y0 =  [maxZpoint, matchingV, matchingY]  ;         
            
            display('Goldbeter')
            Goldbeter.On = 1;
            Diff_type = 1; D =0;
            display(['Diffusion = ', num2str(D)])
            [t, y0D] = ode45(@(t,y) odefun_Goldbeter(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions);
            Goldbeter.Z0D = y0D(:, 1:M)';
            Goldbeter.V0D = y0D(:, M+1:2*M)';
            Goldbeter.Y0D = y0D(:, 2*M+1:3*M)';
        end
        
		Diff_type = 1; D = 6e-6;
		display(['Diffusion = ', num2str(D)])
		[t, yFD] = ode45(@(t,y) odefun_Goldbeter(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions);
		Goldbeter.ZFD = yFD(:, 1:M)';
		Goldbeter.VFD = yFD(:, M+1:2*M)';
		Goldbeter.YFD = yFD(:, 2*M+1:3*M)';
		
		Goldbeter.t = t;
		Goldbeter.mybeta = mybeta;
		Goldbeter.x = x;
    end	
	if strcmp(mystr2, 'E')
        display('Ernmentrout')
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
    end	
	if strcmp(mystr2, 'T1')
        display('Toy1')
		Toy1.On = 1;
        toymodelNo = 1;

		Diff_type = 1; D =0;
		display(['Diffusion = ', num2str(D)])
		[t, y0D] = ode45(@(t,y) odefun_ToyH(t,y,mybeta,Diff_type, D, toymodelNo), tspan, y0, odeoptions);
		Toy1.Z0D = y0D(:, 1:M)';
		Toy1.V0D = y0D(:, M+1:2*M)';

		Diff_type = 1; D =6e-6;
		display(['Diffusion = ', num2str(D)])
		[t, yFD] = ode45(@(t,y) odefun_ToyH(t,y,mybeta,Diff_type, D, toymodelNo), tspan, y0, odeoptions);
		Toy1.ZFD = yFD(:, 1:M)';
		Toy1.VFD = yFD(:, M+1:2*M)';
		
		Toy1.t = t;
		Toy1.mybeta = mybeta;
		Toy1.x = x;
    end
    if strcmp(mystr2, 'T2') 
        display('Toy2')
		Toy2.On = 1;
        toymodelNo = 2;
		
		Diff_type = 1; D =0;
		display(['Diffusion = ', num2str(D)])
		[t, y0D] = ode45(@(t,y) odefun_ToyH(t,y,mybeta,Diff_type, D, toymodelNo), tspan, y0, odeoptions);
		Toy2.Z0D = y0D(:, 1:M)';
		Toy2.V0D = y0D(:, M+1:2*M)';

		Diff_type = 1; D =6e-6;
		display(['Diffusion = ', num2str(D)])
		[t, yFD] = ode45(@(t,y) odefun_ToyH(t,y,mybeta,Diff_type, D, toymodelNo), tspan, y0, odeoptions);
		Toy2.ZFD = yFD(:, 1:M)';
		Toy2.VFD = yFD(:, M+1:2*M)';
		
		Toy2.t = t;
		Toy2.mybeta = mybeta;
		Toy2.x = x;
    end
    
    if strcmp(mystr2, 'F')
        display('FitzHugh–Nagumo model')
		FitzHugh.On = 1;
		
		Diff_type = 1; D =0;
		display(['Diffusion = ', num2str(D)])
		[t, y0D] = ode45(@(t,y) odefun_Fitz(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions);
		FitzHugh.Z0D = y0D(:, 1:M)';
		FitzHugh.V0D = y0D(:, M+1:2*M)';

		Diff_type = 1; D =6e-6;
		display(['Diffusion = ', num2str(D)])
		[t, yFD] = ode45(@(t,y) odefun_Fitz(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions);
		FitzHugh.ZFD = yFD(:, 1:M)';
		FitzHugh.VFD = yFD(:, M+1:2*M)';
		
		FitzHugh.t = t;
		FitzHugh.mybeta = mybeta;
		FitzHugh.x = x;
    end
    if strcmp(mystr2, 'K')
        display('Kathi Edit')
		KathiEdit.On = 1;
		Diff_type = 1; D =0;
		display(['Diffusion = ', num2str(D)])
		[t, y0D] = ode45(@(t,y) odefun_Kathiedit(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions);
		KathiEdit.Z0D = y0D(:, 1:M)';
		KathiEdit.V0D = y0D(:, M+1:2*M)';
		KathiEdit.Y0D = y0D(:, 2*M+1:3*M)';
        KathiEdit.y0D = y0D;

% 		Diff_type = 1; D = 6e-6;
% 		display(['Diffusion = ', num2str(D)])
% % 		[t, yFD] = ode45(@(t,y) odefun_Kathiedit(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions);
% 		KathiEdit.ZFD = yFD(:, 1:M)';
% 		KathiEdit.VFD = yFD(:, M+1:2*M)';
% 		KathiEdit.YFD = yFD(:, 2*M+1:3*M)';
		
		KathiEdit.t = t;
		KathiEdit.mybeta = mybeta;
		KathiEdit.x = x;
    end	
    if strcmp(mystr2, 'D')
        display('Dupont (Goldbeter edit)')
		Dupont.On = 1;
		Diff_type = 1; D =0;
		display(['Diffusion = ', num2str(D)])
		[t, y0D] = ode45(@(t,y) odefun_Dupont(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions);
		Dupont.Z0D = y0D(:, 1:M)';
		Dupont.A0D = y0D(:, M+1:2*M)';
		Dupont.Y0D = y0D(:, 2*M+1:3*M)';

		Diff_type = 1; D = 6e-6;
		display(['Diffusion = ', num2str(D)])
		[t, yFD] = ode45(@(t,y) odefun_Dupont(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions);
		Dupont.ZFD = yFD(:, 1:M)';
		Dupont.AFD = yFD(:, M+1:2*M)';
		Dupont.YFD = yFD(:, 2*M+1:3*M)';
		
		Dupont.t = t;
		Dupont.mybeta = mybeta;
		Dupont.x = x;
    end	
end
ifsave = 0;
if numModels == 0 
    cd([AllDir.ParentDir , AllDir.SaveDir ])
    load('All_run_data')
    cd([AllDir.ParentDir , AllDir.SourceDir ])
elseif ifsave
    cd([AllDir.ParentDir , AllDir.SaveDir ])
    save('All_run_data')
    cd([AllDir.ParentDir , AllDir.SourceDir ])
end

load handel
sound(y,Fs)

addpath(AllDir.Analysis)
MyPlot(Goldbeter, Ernmentrout, Toy1, Toy2, FitzHugh, KathiEdit, Dupont, D)


    
