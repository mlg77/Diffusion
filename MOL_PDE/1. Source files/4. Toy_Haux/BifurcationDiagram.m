clear; clc; 
close all
clf
%% Where am I
AllDir.ParentDir = 'C:\Temp\Diffusion\MOL_PDE\';

AllDir.SourceDir = '1. Source files\4. Toy_Haux';
AllDir.SaveDir = '4. Output files\ODE45_solver';

addpath([AllDir.ParentDir, AllDir.SourceDir, '\Analysis']) 
%%
t0 = 0;   t1 = 2000; dt = 0.01;
tspan = [t0:dt: t1];
dx = 1e-3;  
x = (0:dx:1);    M = length(x); 
mybeta = x'*0.5+0.25;
% mybeta = x';


X_0 = -2; Y_0 = -2; 
X_0 = 0.5; Y_0 = 0.1; 
y0 = [x*0+X_0, x*0+Y_0];

%% Diffusion type 1 =(SD) Fickian, 2= (ED)Electro Diffusion 
Diff_type = 1; D =0;% 6e-6;%  0;%
display(['Diffusion = ', num2str(D)])

mtol = 1e-6;
odeoptions = odeset('RelTol',mtol, 'AbsTol', mtol );
[t, y0D] = ode45(@(t,y) odefun_ToyH(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions);
display(['Sim Done'])

tol = 0.005*X_0;
Z0D = y0D(:, 1:M)';
pointsfound = [];
for ii = 1:M
    % Last 5% of the data for each line
    consider = Z0D(ii, length(t) - round(length(t)/20):end);
    if isempty(pointsfound)
       if abs(max(consider)-min(consider)) > tol 
           pointsfound(1,1) = ii;
           pointsfound(2,1) = x(ii);
       end
    elseif length(pointsfound) == 1
       if abs(max(consider)-min(consider)) < tol 
           pointsfound(1,2) = ii;
           pointsfound(2,2) = x(ii);
       end
    else
        break
    end
end

figure(1)
        h = imagesc(t,x,Z0D);
        set(gca,'YDir','normal')
        xlabel('Time, [s]')
        ylabel('position')
        title(['\Phi Zero Diffusion, [\mu M]'])
        colormap jet
        colorbar
        hold on
        plot([t(1), t(end)], [pointsfound(2,1), pointsfound(2,1)], 'k','LineWidth',2)
%         plot([t(1), t(end)], [pointsfound(2,2), pointsfound(2,2)],  'k','LineWidth',2)


