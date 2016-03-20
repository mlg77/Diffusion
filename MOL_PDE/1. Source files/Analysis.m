%% Analysis For Tim Later stages of Report 
% Author Michelle Goodman
% Date 18/3/16

clear
clc

%% Where am I
AllDir.ParentDir = 'C:\Temp\Diffusion\MOL_PDE\';
AllDir.SourceDir = '1. Source files';
AllDir.SaveDir = '4. Output files\Figurers_Tim\Data_For_Tim_Plots';
AllDir.InitalDataDir = '2. Inital Data';

%% Plot First
mystr = 'plot_only';
cd([AllDir.ParentDir, AllDir.SourceDir])
My_plot_report( mystr , AllDir)
cd([AllDir.ParentDir, AllDir.SourceDir])

