%% Addition of Diffusion to Rate equation
%   dCdt = v0 + v1B + D(x) + R
%   Michelle Goodman
%   25/07/16

clear; clc; close all
tic
%% Where am I
AllDir.ParentDir = 'C:\Temp\Diffusion\MOL_PDE\';
AllDir.SourceDir = '1. Source files';
AllDir.SaveDir = '4. Output files\D_of_x';

cd([AllDir.ParentDir ,AllDir.SaveDir])
load('All_data_ode')
cd([AllDir.ParentDir, AllDir.SourceDir])


%% Figure 1
% Plot the 0 Diffusion
% Plot the full simple diffusion with the line in time chosen
% Plot the Diffusion Component
% Plot the Bifurcation Diagram
top_pt = 0.285;  bt_pt = 0.780;
t_end = t(end);

figure(1)
subplot(2,3,1)
        imagesc(t,flipud(x),Z0) % (:, 1:20/dt+1)
        set(gca,'YDir','normal')
        xlabel('Time, [s]')
        ylabel('Position, x')
        title(['[Ca^2^+]_{Cytosol} zero Diffusion, [\mu M]'])
        colormap jet
        colorbar
        hold on
        plot([0,t_end], [top_pt, top_pt], 'k','LineWidth',2)
        plot([0,t_end], [bt_pt, bt_pt],  'k','LineWidth',2)
        
subplot(2,3,2)
        imagesc(t,flipud(x),ZFD) % (:, 1:20/dt+1)
        set(gca,'YDir','normal')
        xlabel('Time, [s]')
        ylabel('Position, x')
        title(['[Ca^2^+]_{Cytosol} zero Diffusion, [\mu M]'])
        colormap jet
        colorbar
        hold on
        plot([0,t_end], [top_pt, top_pt], 'k','LineWidth',2)
        plot([0,t_end], [bt_pt, bt_pt],  'k','LineWidth',2)
        
%% Get time after first hump
L_Z=[]; L_Y=[]; v_2=[]; v_3=[]; d2Zdx2 = [];
for j = 1:length(t) % Loop through each time to find L, v2 and v3
    [ dydt , L_Zt, L_Yt, d2Zdx2t, v_2t, v_3t] = odefun_Goldbeter( j, yFD(j,:)' , mybeta, 1, D);
    L_Z(:, j) = L_Zt;
    L_Y(:, j) = L_Yt;
    d2Zdx2(:, j) = d2Zdx2t; 
    v_2(:, j) = v_2t;
    v_3(:, j) = v_3t;
end

%% Find just first wave
x_look = find(x>0.16,1):find(x>0.7,1);% All
t_look = find(t>0,1):find(t>9,1);

tlook = t(t_look);
Z_iti_sect = ZFD(x_look, t_look);
D_iti_sect = d2Zdx2(x_look, t_look);
t_to_close = 1000;
% imagesc(Z_iti_sect)
% Find the peeks of the diffusion against the location of them
% And the Peeks in the concentration.
peaksZ = []; locZ = []; 
peaksD = []; locD = []; 
count = 0;
for i = 1:length(x_look) % Loop up through x points
    count = count + 1;
    [pks, loc] = findpeaks(D_iti_sect(i, :));
    peaksD(count, 1:length(pks)) = pks;
    locD(count, 1:length(pks)) = loc;
    
    
    [pks, loc] = findpeaks(Z_iti_sect(i, :));
    peaksZ(count, 1:length(pks)) = pks;
    locZ(count, 1:length(pks)) = loc;
    
end

locZ(find(peaksZ==0)) = 1;
peaksZ(find(peaksZ==0)) = nan;

%% Time to stop as a function of position
t_end_first =  x*0;
t_end_first(x_look) = tlook(locZ(:, 1)+50);
t_end_first(1:x_look(1)) = t_end_first(x_look(1));
t_end_first(x_look(end):end) = t_end_first(x_look(end));

Diff_type = 1; D =0;% 6e-6;%  0;%
mtol = 1e-6;
odeoptions = odeset('RelTol',mtol, 'AbsTol', mtol );
Z_0 = 0.3; V_0 = -40; Y_0 = 0.5;
y0 = [Z_0, V_0, Y_0];
for i = 1:length(x)
    mybeta_temp = i + d2Zdx2(i,:);%(i,1:find(t>t_end_first(i),1));
    plot(mybeta_temp)
    pause(0.1)
    t0 = 0;   t1 = t_end_first(i); dt = 0.005;
    tspan_temp = [t0:dt: t1];
%     [t_temp, y0D_temp] = ode45(@(t,y) odefun_Goldbeter(t,y,mybeta_temp,Diff_type, D), tspan, y0, odeoptions);
%     y0D_pD(i,1:length(t_temp)) = y0D_temp(:,1);
end
    
    
subplot(2,3,4)
        hold on
        max_line_0D = max(Z0(:, 20/dt:end), [], 2);
        min_line_0D = min(Z0(:, 20/dt:end), [], 2);
        plot(x, max_line_0D, 'b', x, min_line_0D, 'b')
        xlabel('Position, x')
        ylabel('[Ca^2^+]_{Cytosol} Concentation, [\mu M]')
        title(['Bifurcation Diagram'])
%         plot([top_pt, top_pt], [0, max_line_0D(top_pt/dt)], 'k','LineWidth',2)
%         plot([bt_pt, bt_pt], [0, max_line_0D(bt_pt/dt)], 'k','LineWidth',2)
        
        
        