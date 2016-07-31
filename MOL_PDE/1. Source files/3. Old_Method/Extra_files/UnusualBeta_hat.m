clear; clc; close all; 
%% Where am I
AllDir.ParentDir = 'C:\Temp\Diffusion\MOL_PDE\';

AllDir.SourceDir = '1. Source files';
AllDir.InitalDataDir = '2. Inital Data';
AllDir.SaveDir = '4. Output files';

bt_point = 0.281; top_point = 0.8
% list_1 = find(mybeta>bt_point); list_2 = find(mybeta>top_point);
%         top_pt = x(list_1(1)) ; bt_pt = x(list_2(1));
%         plot([bt_point, bt_point, 0], [0, top_pt, top_pt], 'k','LineWidth',2)
%         plot([top_point, top_point, 0], [0, bt_pt, bt_pt],  'k','LineWidth',2)

% Initalise Parameters
Z_0 = 0.3; V_0 = -40; Y_0 = 0.5;
D = 6e-6;
dt = 2e-3; t_end = 50; t = 0:dt:t_end;   N = length(t);
dx = 2e-3; x = dx:dx:1;   M = length(x); 
vert = 0.10;
inter = 0.25;
BLL = 0.05:0.02:0.15;
for i = 1:length(BLL)
    % initalise beta to bottom line 
    mybeta = BLL(i) + 0*x;
    grad_beta = (bt_point-BLL(i))/(inter-vert);
    gbs(i) = grad_beta;
    max_beta = BLL(i) + grad_beta*(0.5-vert);
    mybeta(M*vert:M*0.5-1) = linspace(BLL(i),max_beta, M*(0.5-vert));
    mybeta(M*0.5:M*(1-vert)-1) = linspace(max_beta, BLL(i), M*(0.5-vert));
    figure(1)
    hold on
    plot(x, mybeta)
    hold off
    
    [ Z, V ] = Gold_Electro_Diffusion_noinvsp( dt, dx, x, t, M, N, Z_0, V_0, Y_0, mybeta', D);
    clc
    record.(genvarname(['Z_' num2str(i)])) = Z;
    record.(genvarname(['V_' num2str(i)])) = V;
    figure(i+1)
        imagesc(t,flipud(x),Z)
        set(gca,'YDir','normal')
        xlabel('Time, [s]')
        ylabel('Position, x')
        title(['Calcium [Ca^2^+] Concentration, [\muM] Beta', num2str(BLL(i))])
        colormap jet
        hold on
        plot([0,t_end], [0.2,0.2], 'k','LineWidth',2)
        plot([0,t_end], [0.8,0.8],  'k','LineWidth',2)
        colorbar
    
end
figure(1)
legend(['BBL = 0.05, grad = ', num2str(gbs(1))], ['0.07 ,', num2str(gbs(2))],['0.09 ,', num2str(gbs(3))],['0.11 ,', num2str(gbs(4))],['0.13 ,', num2str(gbs(5))],['0.15 ,', num2str(gbs(6))])
xlabel('Position, x')
ylabel('Beta, \beta')
axis([0,1,0,1])


