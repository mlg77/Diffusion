%% Both at once to subtract? Try grid map C_in C_out

clear; clc; 
% close all
% clf
%% Where am I
AllDir.ParentDir = 'C:\Temp\Diffusion\MOL_PDE\';

AllDir.SourceDir = '1. Source files\4. Toy_Haux';
AllDir.SaveDir = '4. Output files\ODE45_solver';

addpath([AllDir.ParentDir, AllDir.SourceDir, '\Analysis']) 
%% Initalise parameters
t0 = 0;   t1 = 800; dt = 0.01;
tspan = [t0:dt: 2*dt];
dx = 0.5;  
x = (0:dx:1);    M = length(x); 

Y_0 = 0.1; 



% Diffusion type 1 =(SD) Fickian, 2= (ED)Electro Diffusion 
Diff_type = 1; D =0;% 6e-6;%  0;%
display(['Diffusion = ', num2str(D)])
mtol = 1e-6;
odeoptions = odeset('RelTol',mtol, 'AbsTol', mtol );

poss_I_C = -2.5:0.1:2.5;
poss_I_C = (poss_I_C + 2.5) /2;
poss_I_Y = -2.5:0.5:2.5;
poss_I_Y = (poss_I_Y + 2.5) /2;
pass_B = [0:0.1:1];
poss_I_B = [pass_B;pass_B;pass_B];

grid_res = zeros(length(poss_I_C), length(poss_I_B));
for kk = 1:length(poss_I_Y)
    Y_0 = poss_I_Y(kk);
    for ii = 1:length(poss_I_C)
        X_0 = poss_I_C(ii);
        y0 = [x*0+X_0, x*0+Y_0];

        for jj = 1:length(poss_I_B)
            mybeta = poss_I_B(:, jj);
            
%             [t, y0D] = ode45(@(t,y) odefun_Goldbeter(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions);
            [t, y0D] = ode45(@(t,y) odefun_ToyH(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions);
            Z0D = y0D(:, 1:M)';
            %  V0D = y0D(:, M+1:2*M)';
            grid_res(ii,jj, kk) = Z0D(2,2)-X_0;
        end
    end
end


for jj = 1:length(poss_I_Y)
    figure(2)
    subplot(3,4,jj)
        h = imagesc(pass_B,poss_I_C,grid_res(:,:,jj));
        set(gca,'YDir','normal')
        xlabel('Beta \beta')
        ylabel('Inital Concentration \Phi')
        title(['Chance in \Phi for \Psi= ', num2str(poss_I_Y(jj))])
        colormap jet
        colorbar
        hold on
%         caxis([-0.2, 0.2])
%         for ii = 1:length(pass_B)
%             plot([pass_B(ii), pass_B(ii)], [poss_I_C(1), poss_I_C(end)], 'k')
%         end
        
%         for ii = 1:length(poss_I_C)
%             plot([pass_B(1), pass_B(end)], [poss_I_C(ii), poss_I_C(ii)], 'k')
%         end
        
        plot([0.5, 0.5], [poss_I_C(1), poss_I_C(end)], 'k', 'linewidth',2)
        
end
   

