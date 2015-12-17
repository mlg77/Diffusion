%% Toy model Example

clear; clc; close all

%% Where am I
AllDir.ParentDir = 'C:\Temp\Diffusion\MOL_PDE\';

AllDir.SourceDir = '1. Source files\Toy_model';
AllDir.SaveDir = '4. Output files\Toy_Model';

%% Ask what sections
prompt = 'What sections? all/bounds/simple/SD/plot_only: ';
mystr = input(prompt,'s');

acceptable = [{'all'}, {'bounds'}, {'simple'}, {'SD'}, {'plot_only'}];
while ismember(mystr,acceptable) == 0
    display('Choose again! Check correct captles')
    mystr = input(prompt,'s');
end
%% Initalise Parameters
    Z_0 = 3; V_0 = 2;
    dt = 0.005; t_end = 40; t = 0:dt:t_end;   N = length(t);
    dx = 0.01; x = 0+dx:dx:1;   M = length(x); 
    dxt = 0.01; xt = 0+dxt:dxt:1;   Mt = length(xt);
    D = 5e-6;
%      zerod_B = -tanh();%(-Z_0^3/3 + Z_0)/V_0;
%      zerod_at = -2*Z_0;
% al = [linspace(zerod_at,-zerod_at,Mt)'];
% B = zerod_B;
al = [linspace(-1,1,Mt)]';
B = -0.5;


%% Bounds
if strcmp(mystr, 'bounds') | strcmp(mystr, 'all')
    cd([AllDir.ParentDir, AllDir.SourceDir])
    for i = 1:length(al)
        Z1 = Simple_toy( dt, dx, x, t, M, N, Z_0, V_0, B, al(i));
        my_max(i) = max(Z1(10, 6001:end));
        my_min(i) = min(Z1(10, 6001:end));
    end
    bt_point_found = 1;
    past_max = 0;
    for k = 1:length(my_max)
        if abs(my_max(k) - my_min(k)) < 0.07 & bt_point_found
            bt_point = al(k);
            x_bt_pt = my_max(k);
        elseif bt_point_found
            bt_point_found = 0;
        elseif ~past_max & abs(my_max(k) - my_min(k)) > 2
            past_max = 1;
        elseif abs(my_max(k) - my_min(k)) < 0.07  & past_max
            top_point = al(k);
            x_top_pt = my_max(k);
            break
        end
    end
end

%% Initalise Parameters
    Z_0 = 3; V_0 = 2;
    dt = 0.002; t_end = 60; t = 0:dt:t_end;   N = length(t);
    dx = 0.005; x = 0+dx:dx:1;   M = length(x); 
    D = 100e-6;
%     zerod_B = 0;%(-Z_0^3/3 + Z_0)/V_0;
%     zerod_a = -2*Z_0;
% zerod_a = 1.5;
% al = [ones(0.2/dx,1)*zerod_a;linspace(zerod_a,-zerod_a,M-0.4/dx)';ones(0.2/dx,1)*-zerod_a];
% al = [linspace(zerod_a,-zerod_a,M)'];
% B = zerod_B;
al = [linspace(1,0,M)]';
B = -0.5; %[ones(M/2,1); -1*ones(M/2,1)];



%% If Choose Simple
if strcmp(mystr, 'simple') | strcmp(mystr, 'all')
    SimpleZ = Simple_toy( dt, dx, x, t, M, N, Z_0, V_0, B, al);
%     [AD.SimpleP.tp, AD.SimpleP.P, AD.SimpleP.map, AD.SimpleP.overx]  = find_freq(x, t, M, N, AD.SimpleZ);
end

%% Do Simple Diffusion section
if strcmp(mystr, 'SD') | strcmp(mystr, 'all')
    AD.SDZ = SD_toy( dt, dx, x, t, M, N, Z_0, V_0, D, B, al);
%     [AD.SDP.tp, AD.SDP.P, AD.SDP.map, AD.SDP.overx]  = find_freq(x, t, M, N, AD.SDZ);
end

if strcmp(mystr, 'plot_only')
    cd([AllDir.ParentDir ,AllDir.SaveDir])
    load('Toy_Data')
    cd([AllDir.ParentDir, AllDir.SourceDir])
else
    cd([AllDir.ParentDir ,AllDir.SaveDir])
    if ~strcmp(mystr, 'bounds') & ~strcmp(mystr, 'all')
        prompt = 'Continued data? 0=no, 1=yes: ';
        ContD = input(prompt);
        if ContD
            save('Toy_Data_temp')
            load('Toy_Data')
            load('Toy_Data_temp')
        end
    end
    save('Toy_Data')
    cd([AllDir.ParentDir, AllDir.SourceDir])
end
AD.t = t;
AD.x = x;
AD.M = M;
AD.B = B;
AD.al= al;
AD.D = D;
AD.SimpleZ = SimpleZ;


My_plot_toy( mystr, AD )

figure(1)
grid on; hold on; plot([0.5, 0.5], [0, 1], 'r')
legend('Alpha', 'Beta')

if exist('top_point')
    list_1 = find(al<=bt_point); list_2 = find(al<=top_point);
    if isempty(list_2) | isempty(list_1)
        top_pt = xt(1) ; bt_pt = xt(end);
    else
        top_pt = x(list_1(1)) ; bt_pt = x(list_2(1));
    end
else
    list_1 = find(al<=bt_point);
    if isempty(list_1)
        top_pt = xt(1) ; bt_pt = xt(end);
    else
        top_pt = x(list_1(1)) ; 
    end
    top_point = 0;
    x_top_pt = 0;
end


figure()
hold on
% plot( [linspace(zerod_at,-zerod_at,Mt)'], my_max)
% plot( [linspace(zerod_at,-zerod_at,Mt)'], my_min)
% plot([bt_point, bt_point, -3], [-3, x_bt_pt, x_bt_pt], 'k','LineWidth',2)
% plot([top_point, top_point, -3], [-3, x_top_pt, x_top_pt],  'k','LineWidth',2)
plot( [linspace(-2,2,Mt)'], my_max)
plot( [linspace(-2,2,Mt)'], my_min)
plot([bt_point, bt_point, -3], [-3, x_bt_pt, x_bt_pt], 'k','LineWidth',2)
plot([top_point, top_point, -3], [-3, x_top_pt, x_top_pt],  'k','LineWidth',2)


for i = 2:3
    figure(i); hold on
    plot([0,t_end], [top_pt, top_pt], 'k','LineWidth',2)
    plot([0,t_end], [bt_pt, bt_pt],  'k','LineWidth',2)
end
        
figure()
deets = AD.SimpleZ;
for i = 1:2
    subplot(1,2,i); hold on
    plot(t, deets(200,:))
    plot(t, deets(0.8*200,:))
    plot(t, deets(100,:))
    plot(t, deets(0.2*200+1,:))
    plot(t, deets(1,:))
    legend(num2str(x(200)),num2str(x(0.8*200)), num2str(x(100)), num2str(x(0.2*200+1)), num2str(x(1)))
    deets = AD.SDZ;
end