%% Simple to run code for Paul :)
% Calls odefun_Goldbeter and calc_Gold 
% Code takes approximatly 20 seconds to run
% Author: Michelle Goodman
% Date: 7/11/2017

clear; clc; close all

%% Inital Start up
t0 = 0;   t1 = 20; dt = 0.01;                      % Time array
tspan = [t0:dt: t1];
dx = 1e-3;                                          % Position array
x = 0:dx:1;    
M = length(x); 
mybeta = x';                                        % Beta array
mybeta(201:280) = mybeta(191); % change to beta 
mtol = 1e-6;                                        % Tolerences
odeoptions = odeset('RelTol',mtol, 'AbsTol', mtol );
Z_0 = 0.5; V_0 = -40; Y_0 = 0.5;                    % Inital conditions
y0 = [x*0+Z_0, x*0+V_0, x*0+Y_0];


%% Diffusion Problem 
% Diffusion Type {1 for zero diffusion or Fickian Diffusion}{2 for Electro diffusion}
Diff_type = 1; 
% Diffusion ammount (0 if for zero diffusion)
D = 6e-6;


%% Run and assigning results
display(['Goldbeter Diffusion = ', num2str(D)])
tic
[t, y0D] = ode45(@(t,y) odefun_Goldbeter(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions); 
toc
Z = y0D(:, 1:M)';
V = y0D(:, M+1:2*M)'; 
Y = y0D(:, 2*M+1:3*M)';


%% Plot
figure();
imagesc(t,flipud(x),Z)
set(gca,'YDir','normal')
		xlabel('Time, [s]')
		ylabel('Position, x')
		colorbar
		colormap jet
		hold on
if D == 0;              title('Concentration Plot [\muM]; Zero diffusion'); 
elseif Diff_type == 1;  title(['Concentration Plot [\muM]; Fickian diffusion D = ', num2str(D)]);
elseif Diff_type == 2;  title(['Concentration Plot [\muM]; Electro diffusion D = ', num2str(D)]);
end
        
figure();
plot(x,mybeta)
hold on; title('\beta to x profile') 
xlabel('position'); ylabel('Beta \beta')
        