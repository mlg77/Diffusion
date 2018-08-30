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
close all

%% Move to correct directory
dir_source = 'C:\Temp\Diffusion\MOL_PDE\1. Source files\17. ToyClean';
dir_parent = 'C:\Temp\Diffusion\MOL_PDE\5. Source Thesis\Toy3_FHScore';
dir_save = 'C:\Temp\Diffusion\MOL_PDE\4. Output files\5. ToyModel 3';

cd(dir_source);

%% Inital Conditions to eaisly change
myXi_vector = 0.1:0.05:1;
D_Array = [0, 5e-6];

% bif_x(1) = 0.5690; bottom_bif(1) = 0.2;
% bif_x(2) = 0.4230; bottom_bif(2) = 0.19;
% bif_x(3) = 0.3520; bottom_bif(3) = 0.18;
% bif_x(4) = 0.3080; bottom_bif(4) = 0.17;
% bif_x(5) = 0.2770; bottom_bif(5) = 0.16;
% bif_x(6) = 0.2540; bottom_bif(6) = 0.15;
% bif_x(7) = 0.2360; bottom_bif(7) = 0.14;
% bif_x(8) = 0.2210; bottom_bif(8) = 0.13;
% bif_x(9) = 0.2090; bottom_bif(9) = 0.11;
% bif_x(10) = 0.1980; bottom_bif(10) = 0.12;

% bif_x(1) = 0.6280; bottom_bif(1) = 0.1;
% bif_x(2) = 0.4450; bottom_bif(2) = 0.1;
% bif_x(3) = 0.3640; bottom_bif(3) = 0.1;
% bif_x(4) = 0.3150; bottom_bif(4) = 0.1;
% bif_x(5) = 0.2820; bottom_bif(5) = 0.1;
% bif_x(6) = 0.2580; bottom_bif(6) = 0.1;
% bif_x(7) = 0.2380; bottom_bif(7) = 0.1;
% bif_x(8) = 0.2230; bottom_bif(8) = 0.1;
% bif_x(9) = 0.2100; bottom_bif(9) = 0.1;
% bif_x(10) = 0.1990; bottom_bif(10) = 0.1;


t0 = 0;   t1 = 4000; dt = 0.05;
dx = 1e-3;  
x = (0:dx:1);  
Diff_type = 1; 
tspan = [t0:dt: t1];
t = tspan;
M = length(x); 
N = length(t); 
mtol = 1e-6;
odeoptions = odeset('RelTol',mtol, 'AbsTol', mtol );
X_0 = -0.5; Y_0 = 0.1; 
y0 = [x*0+X_0, x*0+Y_0];

run_data = 0;
if run_data
for ii = [1,5,12,19]% 1:length(myXi_vector)
    
    myXi = myXi_vector(ii);
%     mybeta = (x*2*(bif_x(ii)- bottom_bif(ii))+ bottom_bif(ii))';
%     mybeta = x';
    mybeta = (x*0.7+0.1)';
    for jj = 1:length(D_Array)
        D = D_Array(jj);
        display(['Toy 3; {Xi = ', num2str(myXi), '} {D_itt = ', num2str(jj), '}'])
        [t, y] = ode45(@(t,y) odefun_Toy3(t,y,mybeta,Diff_type, D, myXi), tspan, y0, odeoptions);
        Z = y(:, 1:M)';
        Y = y(:, M+1:2*M)';

        cd([dir_save]) 
        save(['Data_', num2str(ii), '_', num2str(jj)], 'Z','Y', 't', 'x', 'mybeta', 'myXi', 'D')
        cd(dir_source);
        
        
    end
end
end

pointsall = [];
cd([dir_save]) 
for ii = [1,5,12,19]% 1:length(myXi_vector)
    myXi = myXi_vector(ii);
    mybeta = x';
    figure();
    
    for jj = 1:length(D_Array)
        D = D_Array(jj);
        load(['Data_', num2str(ii), '_', num2str(jj)])

        subplot(1,4,jj+2)
        imagesc(t,flipud(x),Z)
        axis([0,700,0,1])
        set(gca,'YDir','normal')
		xlabel('Time, [s]')
		ylabel('Position, x')
        colormap jet
		hold on
        if jj ==1
            per_end = 0.5;
            BifuMax = max(Z(:, floor(N*per_end):end)')';
            BifuMin = min(Z(:, floor(N*per_end):end)')';
        
            cd(['C:\Temp\Diffusion\MOL_PDE\1. Source files\10. CLean Up Of Run\Analysis_functions']);
            [ pointsfound ] = Bifurcation_pointsToy( x,t,Z );
            pointsall = [pointsall, pointsfound];
            [ TVector ] = FindPeriodVector( Z ,dt) ;
            cd([dir_save]) 
            subplot(1,4,1)
            [hAx,hLine1,hLine2]  = plotyy([mybeta; nan; mybeta], [BifuMax;nan; BifuMin], mybeta, TVector);
            xlabel('Beta, \beta')
            ylabel(hAx(1),'\Phi') % left y-axis 
            ylabel(hAx(2),'Period [s]') % right y-axis
            
            subplot(1,4,2); hold on
            idx_wave = pointsfound(1)+31;
            Zp = Z(idx_wave, floor(length(t)/2):end);
            tp = t(floor(length(t)/2):end);
            [Troughs,LOCS] = findpeaks(-Zp);
            Zp = Zp(LOCS(2):LOCS(3)); 
            tp = tp(LOCS(2):LOCS(3));
            periodT = tp(end)-tp(1);
            plot(tp - 0.1*periodT, Zp, ':k', 'linewidth', 2)
            plot(tp + 0.1*periodT, Zp, ':b', 'linewidth', 2)
            plot(tp, Zp, 'r', 'linewidth', 3)
            
            subplot(1,4,3)
            hold on; plot([0,t(end)], pointsfound(2)*[1,1],'k', 'linewidth', 2)
        else
            hold on; plot([0,t(end)], pointsfound(2)*[1,1],'k', 'linewidth', 2)
        end
    end
end

return

%% Figs Report 
% Want bifurcation and period overlayed
% Want wave shape 
% Want diffusion up to 
count = 0;
cd([dir_save]) 
for ii = [1,5,12,19]% 1:length(myXi_vector)
    myXi = myXi_vector(ii);
    mybeta = (x*0.7+0.1)';
    for jj = 1:length(D_Array)
        D = D_Array(jj);
        load(['Data_', num2str(ii), '_', num2str(jj)])
        if jj ==1
            per_end = 0.5;
            BifuMax = max(Z(:, floor(N*per_end):end)')';
            BifuMin = min(Z(:, floor(N*per_end):end)')';
        
            cd(['C:\Temp\Diffusion\MOL_PDE\1. Source files\10. CLean Up Of Run\Analysis_functions']);
            [ pointsfound ] = Bifurcation_pointsToy( x,t,Z );
            [ TVector ] = FindPeriodVector( Z ,dt) ;
            cd([dir_save]) 

            count = count+1;
            figure(count);
            [hAx,hLine1,hLine2]  = plotyy([mybeta; nan; mybeta], [BifuMax;nan; BifuMin], mybeta, TVector);
            xlabel('Beta, \beta')
            ylabel(hAx(1),'Variable \Phi') % left y-axis 
            ylabel(hAx(2),'Period [s]') % right y-axis
            
            count = count+1;
            figure(count); hold on
            idx_wave = pointsfound(1)+31;
            Zp = Z(idx_wave, floor(length(t)/2):end);
            tp = t(floor(length(t)/2):end);
            [Troughs,LOCS] = findpeaks(-Zp);
            Zp = Zp(LOCS(2):LOCS(3)); 
            tp = tp(LOCS(2):LOCS(3));
            periodT = tp(end)-tp(1);
            plot(tp - 0.1*periodT, Zp, ':k', 'linewidth', 2)
            plot(tp + 0.1*periodT, Zp, ':b', 'linewidth', 2)
            plot(tp, Zp, 'r', 'linewidth', 3)

        else
            count = count+1;
            figure(count);
            imagesc(t,flipud(x),Z)
            axis([0,700,0,1])
            set(gca,'YDir','normal')
            xlabel('Time, [s]')
            ylabel('Position, x')
            colormap jet
            hold on; plot([0,t(end)], pointsfound(2)*[1,1],'k', 'linewidth', 2)
        end
    end
end

return
%% Figs paper 
% Want bifurcation and period overlayed
% Want wave shape 
% Want diffusion up to 
count = 0;
cd([dir_save]) 
for ii = 10% [1,5,12,19]% 1:length(myXi_vector)
    myXi = myXi_vector(ii);
    mybeta = (x*0.7+0.1)';
    for jj = 1:length(D_Array)
        D = D_Array(jj);
        load(['Data_', num2str(ii), '_', num2str(jj)])
        if jj ==1
            per_end = 0.5;
            BifuMax = max(Z(:, floor(N*per_end):end)')';
            BifuMin = min(Z(:, floor(N*per_end):end)')';
        
            cd(['C:\Temp\Diffusion\MOL_PDE\1. Source files\10. CLean Up Of Run\Analysis_functions']);
            [ pointsfound ] = Bifurcation_pointsToy( x,t,Z );
            [ TVector ] = FindPeriodVector( Z ,dt) ;
            cd([dir_save]) 

            count = count+1;
            figure(count);
            [hAx,hLine1,hLine2]  = plotyy([mybeta; nan; mybeta], [BifuMax;nan; BifuMin], mybeta, TVector);
            xlabel('Beta, \beta')
            ylabel(hAx(1),'Variable \Phi') % left y-axis 
            ylabel(hAx(2),'Period [s]') % right y-axis
            
            count = count+1;
            figure(count); hold on
            idx_wave = pointsfound(1)+31;
            Zp = Z(idx_wave, floor(length(t)/2):end);
            tp = t(floor(length(t)/2):end);
            [Troughs,LOCS] = findpeaks(-Zp);
            Zp = Zp(LOCS(2):LOCS(3)); 
            tp = tp(LOCS(2):LOCS(3));
            periodT = tp(end)-tp(1);
            plot(tp - 0.1*periodT, Zp, ':k', 'linewidth', 2)
            plot(tp + 0.1*periodT, Zp, ':b', 'linewidth', 2)
            plot(tp, Zp, 'r', 'linewidth', 3)
            
            figure(99+count); hold on
            Zp = Zp +3;
            [mymax,Imax] = max(Zp);
            Idxcol = find(Zp > (max(Zp)+min(Zp))/2, 1, 'last');
            h1 = area(tp(Imax*2 - Idxcol:Imax),Zp(Imax*2 - Idxcol:Imax))
            h1(1).FaceColor = [1 0 0];
            h2 = area(tp(Imax:Idxcol),Zp(Imax:Idxcol))
            h2(1).FaceColor = [0 0 1];
            plot([1,1]*tp(Imax), [min(Zp), max(Zp)], 'k')
            plot(tp, Zp, 'k', 'linewidth', 3)
        %     plot([t(1), t(Idxcol)], [1,1]*(max(Z)+min(Z))/2, 'k')
            plot([1,1]*tp(Idxcol), [min(Zp), Zp(Idxcol)], 'k' )
            plot([t(1),tp(end)], [1,1]*min(Zp), 'k' )
            plot([1,1]*(tp(Imax*2 - Idxcol)), [min(Zp), Zp(Imax*2 - Idxcol)], 'k' )
            axis([min(tp)*0.99,max(tp)*1.01 , min(Zp)*0.99,max(Zp)*1.01 ])
        else
            count = count+1;
            figure(count);
            imagesc(t,flipud(x),Z)
            axis([0,700,0,1])
            set(gca,'YDir','normal')
            xlabel('Time, [s]')
            ylabel('Position, x')
            colormap jet
            hold on; plot([0,t(end)], pointsfound(2)*[1,1],'k', 'linewidth', 2)
        end
    end
end

return

%% Save Plots

cd([dir_save, '\Figs\Report'])
NumberOfFig = 12;
for ii = 1:NumberOfFig
    savefig(ii, [num2str(ii), 'AllFour.fig'])
end

cd([dir_save, '\Figs\Report\Images'])
for i = 1:NumberOfFig
    figure(i)
    set(gcf,'PaperPositionMode','auto')
    print([num2str(i),'AllFour'],'-dpng', '-r300')
end


cd(dir_parent);








