%%%%%%%%%%%%%%%%%% Not in Opperation!!!!!! %%%%%%%%%%%%%%%%%%

%% What I want to save for just the ODE Bifurcation diagrams

%       Z = 1 entire concentration matrix + other parameters
%       t = The matching time
%       x = The matching position (shouldn't be used)
%       mybeta = the matching beta array
%       Zmax = Bifurcation max line
%       Zmin = Bifurcation min line
%       TZ = The period of oscillations

%% What I want to plot for just the ODE Bifurcation diagrams

%       1	concentration vs Time Graphs 		Low Stim
%       2	concentration vs Time Graphs 		Low Stim
%       3	concentration vs Time Graphs 		Low Stim
%       4	concentration vs Time Graphs 		High Stim
%       5	concentration vs Time Graphs 		High Stim
%       6	concentration vs Time Graphs 		High Stim

%       7	concentration vs Time Graphs 		All in one

%       8 	Bifurcation Graph
%       9	Period Graph

%       10 	Bifurcation Graph + Period Graph
clear; clc; close all
%% Move to correct directory
dir_source = 'C:\Temp\Diffusion\MOL_PDE\1. Source files\17. ToyClean';
dir_parent = 'C:\Temp\Diffusion\MOL_PDE\5. Source Thesis\Toy_1_2';
dir_save = 'C:\Temp\Diffusion\MOL_PDE\4. Output files\4. ToyModel 1 and 2';

cd(dir_source);


%% Inital Conditions to eaisly change
t0 = 0;   t1 = 4000; dt = 0.01;
dx = 1e-3;  
t = t0:dt:t1;
x = (0:dx:1);   
mybeta = x';
toymodelNo = 1;
	
%% Inital Conditions dont change
Diff_type = 1; D =0;
M = length(x); 
N = length(t); 
mtol = 1e-6;
odeoptions = odeset('RelTol',mtol, 'AbsTol', mtol );
tspan = [t0:dt: t1];

%% Run Simulation
    X_0 = -1.2; Y_0 = 0.1; 
	y0 = [x*0+X_0, x*0+Y_0];
    display(['Toy`2'])
    tic
    [t, y0D] = ode45(@(t,y) odefun_Toy2(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions);
		
    runtime = toc;
    Sol.Z0D = y0D(:, 1:M)';
    Sol.Y0D = y0D(:, M+1:2*M)';
        
    per_end = 0.5;
    
    BifuMax.Z = max(Sol.Z0D(:, floor(N*per_end):end)')';
    BifuMax.Y = max(Sol.Y0D(:, floor(N*per_end):end)')';
        
    BifuMin.Z = min(Sol.Z0D(:, floor(N*per_end):end)')';
    BifuMin.Y = min(Sol.Y0D(:, floor(N*per_end):end)')';
        
    cd(['C:\Temp\Diffusion\MOL_PDE\1. Source files\10. CLean Up Of Run\Analysis_functions']);
    [ pointsfound ] = Bifurcation_points( x,t,Sol.Z0D );
    [ TVector ] = FindPeriodVector( Sol.Z0D ,dt) ;
    
    
    cd([dir_save']) 
    mybeta = mybeta*0.2+0.1;

%% Things to save
% Sol, t, s, mybeta, BifuMax, BifuMin, TVector, pointsfound
Z = Sol.Z0D; Y = Sol.Y0D;
save('Toy2_DataBi', 'Z','Y', 't', 'x', 'mybeta', 'BifuMax', 'BifuMin', 'TVector', 'pointsfound', 'runtime')

%% Make Plots
The6_xpoints = [0.1,0.2,0.4,0.6,0.8,0.9];
The6_points = floor(The6_xpoints.*M)+1;

for ii = 1:6
    figure(ii)
    plot(t, Sol.Z0D(The6_points(ii), :))
    xlabel('Time [s]')
    ylabel('Concentration ')
    title(['mybeta = ' , num2str(mybeta(The6_points(ii)))])
    
    figure(7); hold on
    plot(t, Sol.Z0D(The6_points(ii), :))
    myleg{ii} = ['mybeta = ' , num2str(mybeta(The6_points(ii)))];
end

xlabel('Time [s]')
ylabel('Concentration ')
title(['All in one'])
legend(myleg)

figure(8)
hold on;
plot(mybeta, BifuMax.Z, 'b')
plot(mybeta, BifuMin.Z, 'b')
xlabel('Beta, \beta')
ylabel('Concentration')

figure(9)
plot(mybeta, TVector)
xlabel('Beta, \beta')
ylabel('Period [s]')
box off

figure(10)
[hAx,hLine1,hLine2]  = plotyy([mybeta; nan; mybeta], [BifuMax.Z;nan; BifuMin.Z], mybeta, TVector);
xlabel('Beta, \beta')
ylabel(hAx(1),'Concentration [\mu M]') % left y-axis 
ylabel(hAx(2),'Period [s]') % right y-axis

NumberOfFig = 10;
for ii = 1:NumberOfFig
    savefig(ii, ['Toy2_', num2str(ii), 'BiDataFigs.fig'])
end

cd([dir_save, '\Images']) 
for  ii = 1:6
figure(ii)
% axis([0,300,-1,3]); grid on
end
figure(7); %axis([0,300,-1,3]);

for i = 1:10
figure(i)
set(gcf,'PaperPositionMode','auto')
print(['Toy2_',num2str(i), '_BiDataFigs'],'-dpng', '-r300')
end

 figure();
    imagesc(t,flipud(x),Z)
        set(gca,'YDir','normal')
		xlabel('Time, [s]')
		ylabel('Position, x')
		colormap jet
		hold on
        axis([0,1000,0,1])
        colorbar
        plot([0,1000], [0.5,0.5], 'k', 'linewidth', 2)

set(gcf,'PaperPositionMode','auto')
print('Toy2_ZeroD','-dpng', '-r300')

cd(dir_parent);
%% Now fd
cd(dir_source);
%% Inital Conditions to eaisly change
mybeta = (mybeta-0.1)/0.2;
t0 = 0;   t1 = 1000; dt = 0.01;
t = t0:dt:t1;
tspan = [t0:dt: t1];
Diff_type = 1; D =6e-6;
X_0 = -1.2; Y_0 = 0.1; 
y0 = [x*0+X_0, x*0+Y_0];
display(['Toy`2'])
tic
[t, y0D] = ode45(@(t,y) odefun_Toy2(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions);
runtime = toc;
ZFD = y0D(:, 1:M)';
YFD = y0D(:, M+1:2*M)';

figure();
    imagesc(t,flipud(x),ZFD)
        set(gca,'YDir','normal')
		xlabel('Time, [s]')
		ylabel('Position, x')
		colormap jet
		hold on
        axis([0,1000,0,1])
        colorbar
        plot([0,1000], [0.5,0.5], 'k', 'linewidth', 2)

cd([dir_save']) 
set(gcf,'PaperPositionMode','auto')
print('Toy2_FD','-dpng', '-r300')


cd(dir_parent);


