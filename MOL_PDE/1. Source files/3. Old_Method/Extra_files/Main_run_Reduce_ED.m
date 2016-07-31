% Diffusion
% Author: Michelle Goodman
% Date 8/6/2015

clear; clc; close all; 
%% Where am I
AllDir.ParentDir = 'C:\Temp\Diffusion\MOL_PDE\';

AllDir.SourceDir = '1. Source files';
AllDir.InitalDataDir = '2. Inital Data';
AllDir.SaveDir = '4. Output files';
%% Inital Data
Z_0 = 0.3; V_0 = -40; Y_0 = 0.5;
D = 6e-6;
dt = 2e-3; t_end = 100; t = 0:dt:t_end;   N = length(t);
dx = 1e-3; x = 0:dx:1;   M = length(x); 
mybeta = (0.5*(1+tanh((x-0.5)/0.5)))';
%% Loop through changing Percentage Electro Diffusion
prompt = 'What sections? Produce=0/plot=1: ';
section = input(prompt);

if section == 0
    for PED = 0.1:0.1:0.9
        [ Z3, V3 ] = Gold_Electro_Diffusion_noinvsp_C( dt, dx, x, t, M, N, Z_0, V_0, Y_0, mybeta, D, PED);
        cd([AllDir.ParentDir ,AllDir.SaveDir, '\Changing_P_ED'])
        save(['ED_data_', num2str(PED*10)])
        cd([AllDir.ParentDir, AllDir.SourceDir])
    end
elseif section == 1
    for PED = 0:0.1:1
        cd([AllDir.ParentDir ,AllDir.SaveDir, '\Changing_P_ED'])
        load('bounds_data.mat')
        load(['ED_data_',num2str(PED*10) ,'.mat'])
        figure(PED*10+1)
        if PED == 0
            imagesc(t,flipud(x),Z2b)
        else
            imagesc(t,flipud(x),Z3)
        end
        set(gca,'YDir','normal') 
        xlabel('Time, [s]')
        ylabel('Position, x')
        title(['[Ca^2^+] Concentration in the Cytosol with Electro-Diffusion (6x10^-^6), [\muM]', num2str(PED*10)])
        colorbar
        colormap jet
        hold on
        list_1 = find(mybeta>bt_point); list_2 = find(mybeta>top_point);
        top_pt = x(list_1(1)) ; bt_pt = x(list_2(1));
        plot([0,t_end], [top_pt, top_pt], 'k','LineWidth',2)
        plot([0,t_end], [bt_pt, bt_pt],  'k','LineWidth',2)
        set(gcf,'PaperPositionMode','auto')
        print([num2str(PED*10),'ED'],'-dpng', '-r300')
    end
end

cd([AllDir.ParentDir, AllDir.SourceDir])
        