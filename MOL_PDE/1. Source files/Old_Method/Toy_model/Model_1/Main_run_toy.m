%% Toy model Example

clear; clc; close all

%% Where am I
AllDir.ParentDir = 'C:\Temp\Diffusion\MOL_PDE\';

AllDir.SourceDir = '1. Source files\Toy_model';
AllDir.SaveDir = '4. Output files\Toy_Model';

%% Ask what sections
prompt = 'What sections? all/simple/SD/plot_only: ';
mystr = input(prompt,'s');

acceptable = [{'all'}, {'simple'}, {'SD'}, {'plot_only'}];
while ismember(mystr,acceptable) == 0
    display('Choose again! Check correct captles')
    mystr = input(prompt,'s');
end
%% Initalise Parameters
    Z_0 = 1;
    dt = 0.001; t_end = 50; t = 0:dt:t_end;   N = length(t);
    dx = 0.002; x = 0:dx:1;   M = length(x); 
    D = 80e-6;
    
AD.t = t;
AD.x = x;
AD.M = M;

%% If Choose Simple
if strcmp(mystr, 'simple') | strcmp(mystr, 'all')
    AD.SimpleZ = Simple_toy( dt, dx, x, t, M, N, Z_0);
    [AD.SimpleP.tp, AD.SimpleP.P, AD.SimpleP.map, AD.SimpleP.overx]  = find_freq(x, t, M, N, AD.SimpleZ);
end

%% Do Simple Diffusion section
if strcmp(mystr, 'SD') | strcmp(mystr, 'all')
    AD.SDZ = SD_toy( dt, dx, x, t, M, N, Z_0, D);
    [AD.SDP.tp, AD.SDP.P, AD.SDP.map, AD.SDP.overx]  = find_freq(x, t, M, N, AD.SDZ);
end

if strcmp(mystr, 'plot_only')
    cd([AllDir.ParentDir ,AllDir.SaveDir])
    load('Toy_Data')
    cd([AllDir.ParentDir, AllDir.SourceDir])
else
    cd([AllDir.ParentDir ,AllDir.SaveDir])
    save('Toy_Data')
    cd([AllDir.ParentDir, AllDir.SourceDir])
end

My_plot_toy( mystr, AD )