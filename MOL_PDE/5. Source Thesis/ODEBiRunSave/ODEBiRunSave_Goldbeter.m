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
%       3	concentration vs Time Graphs 		Med Stim
%       4	concentration vs Time Graphs 		Med Stim
%       5	concentration vs Time Graphs 		High Stim
%       6	concentration vs Time Graphs 		High Stim

%       7	concentration vs Time Graphs 		All in one

%       8 	Bifurcation Graph
%       9	Period Graph

%       10 	Bifurcation Graph + Period Graph

%% Move to correct directory
dir_source = 'C:\Temp\Diffusion\MOL_PDE\1. Source files\10. CLean Up Of Run';
dir_parent = 'C:\Temp\Diffusion\MOL_PDE\5. Source Thesis';
dir_save = 'C:\Temp\Diffusion\MOL_PDE\4. Output files\1. ODE_Bifurcations';

cd(dir_source);


%% Inital Conditions to eaisly change
t0 = 0;   t1 = 100; dt = 0.001;
dx = 1e-3;  
x = 0:dx:1;    
mybeta = x';

%% Inital Conditions dont change
Diff_type = 1; D =0;
M = length(x); 
N = length(t); 
mtol = 1e-6;
odeoptions = odeset('RelTol',mtol, 'AbsTol', mtol );
tspan = [t0:dt: t1];

%% Run Simulation
run_model = 'G';
if run_model == 'G'
    Z_0 = 0.5; V_0 = -40; Y_0 = 0.5;
	y0 = [x*0+Z_0, x*0+V_0, x*0+Y_0];
    display(['Goldbeter '])
    tic
    [t, y0D] = ode45(@(t,y) odefun_Goldbeter(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions); 
    runtime = toc;
    Sol.Z = y0D(:, 1:M)';
    Sol.V = y0D(:, M+1:2*M)';
    Sol.Y = y0D(:, 2*M+1:3*M)';

    BifuMax.Z = max(Sol.Z(:, floor(N*0.75):end)')';
    BifuMax.V = max(Sol.V(:, floor(N*0.75):end)')';
    BifuMax.Y = max(Sol.Y(:, floor(N*0.75):end)')';
    
    BifuMin.Z = min(Sol.Z(:, floor(N*0.75):end)')';
    BifuMin.V = min(Sol.V(:, floor(N*0.75):end)')';
    BifuMin.Y = min(Sol.Y(:, floor(N*0.75):end)')';
    
    cd([dir_source, '\Analysis_functions']);
    [ pointsfound ] = Bifurcation_points( x,t,Sol.Z );
    [ TVector ] = FindPeriodVector( Sol.Z ,dt) ;
    
    
    cd([dir_save, '\2. Goldbeter']) 
end

%% Things to save
% Sol, t, s, mybeta, BifuMax, BifuMin, TVector, pointsfound
Z = Sol.Z; Y = Sol.Y; V = Sol.V;
save('DataBi', 'Z','Y', 'V', 't', 'x', 'mybeta', 'BifuMax', 'BifuMin', 'TVector', 'pointsfound', 'runtime')

%% Make Plots
The6_xpoints = [0.1,0.2,0.4,0.6,0.87,0.9];
The6_points = floor(The6_xpoints.*M)+1;

for ii = 1:6
    figure(ii)
    plot(t, Sol.Z(The6_points(ii), :))
    xlabel('Time [s]')
    ylabel('Concentration [\mu M]')
    title(['mybeta = ' , num2str(mybeta(The6_points(ii)))])
    
    figure(7); hold on
    plot(t, Sol.Z(The6_points(ii), :))
    myleg{ii} = ['mybeta = ' , num2str(mybeta(The6_points(ii)))];
end

xlabel('Time [s]')
ylabel('Concentration [\mu M]')
title(['All in one'])
legend(myleg)

figure(8)
hold on;
plot(mybeta, BifuMax.Z, 'b')
plot(mybeta, BifuMin.Z, 'b')
xlabel('Beta, \beta')
ylabel('Concentration [\mu M]')

figure(9)
plot(mybeta, TVector)
xlabel('Beta, \beta')
ylabel('Period [s]')

figure(10)
[hAx,hLine1,hLine2]  = plotyy([mybeta; nan; mybeta], [BifuMax.Z;nan; BifuMin.Z], mybeta, TVector)
xlabel('Beta, \beta')
ylabel(hAx(1),'Concentration [\mu M]') % left y-axis 
ylabel(hAx(2),'Period [s]') % right y-axis

NumberOfFig = 10;
for ii = 1:NumberOfFig
    savefig(ii, [num2str(ii), 'BiDataFigs.fig'])
end

cd(dir_parent);








