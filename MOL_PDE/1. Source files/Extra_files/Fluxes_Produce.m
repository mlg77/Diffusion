% Run ED to plot fluxes
% Michelle Goodman 
% 14/9/2015

clear; clc; close all; 
%% Where am I
AllDir.ParentDir = 'C:\Temp\Diffusion\MOL_PDE\';

AllDir.SourceDir = '1. Source files';
AllDir.InitalDataDir = '2. Inital Data';
AllDir.SaveDir = '4. Output files';
%%
prompt = 'Plot or Produce (0 / 1): ';
produce = input(prompt);

if produce == 1
    cd([AllDir.ParentDir, AllDir.SourceDir])
    Z_0 = 0.3; V_0 = -40; Y_0 = 0.5;
    D = 6e-6;
    dt = 2e-3; t_end = 100; t = 0:dt:t_end;   N = length(t);
    dx = 1e-3; x = 0:dx:1;   M = length(x); 
    mybeta = (0.5*(1+tanh((x-0.5)/0.5)))';
    [ Z3, V3, dX_dx, gZdV_dx ] = Gold_Electro_Diffusion_fluxes( dt, dx, x, t, M, N, Z_0, V_0, Y_0, mybeta, D);
    cd([AllDir.ParentDir ,AllDir.SaveDir])
    save('ED_data_Fluxes', '-regexp', '^(?!(mystr)$).')
    cd([AllDir.ParentDir, AllDir.SourceDir])
end
cd([AllDir.ParentDir ,AllDir.SaveDir])
figure(1)
load('ED_data_Fluxes');
imagesc(t,flipud(x(2:end-1)),dX_dx(2:end-1,:))
set(gca,'YDir','normal')
xlabel('Time, [s]')
ylabel('Position, x')
title('dZ\_dx, Flux of Calcium Concentration in the Cytosol, [\muM m^{-1}]')
colormap jet
colorbar

figure(2)
imagesc(t,flipud(x(11:end-30)),gZdV_dx(11:end-30,:) )
set(gca,'YDir','normal')
xlabel('Time, [s]')
ylabel('Position, x')
title('gZdV\_dx, Calcium Concentration in the Cytosol, [\muM m^{-1}]')
colorbar
colormap jet


%% Plot x(501)=0.5
nno = 501;

grad_gZdV_dx = gZdV_dx(nno,2)-gZdV_dx(nno,1);
grad_dX_dx = dX_dx(nno,2)- dX_dx(nno,1);
countZ = 2;
countV = 2;
myrecordV = [0,0,0,0];
myrecordZ = [0,0,0,0];
for i = 2:length(t)-1
    grad_gZdV_dx1 = gZdV_dx(nno,i+1)-gZdV_dx(nno,i);
    grad_dX_dx1 = dX_dx(nno,i+1) -dX_dx(nno,i);
    if sign(grad_gZdV_dx1)~= sign(grad_gZdV_dx)
        isitmax = 0;
        myrecordV(countV,:) = [t(i), sign(grad_gZdV_dx), gZdV_dx(nno,i), isitmax]; % where a 1= max and -1 = min
        if  sign(grad_gZdV_dx) < 0 & abs(gZdV_dx(nno,i)- myrecordV(countV-1,3))> 15
            myrecordV(countV-1,4) = 1;
        end
        countV = countV+1;
    end
    if sign(grad_dX_dx1)~= sign(grad_dX_dx)
        isitmax = 0;
        myrecordZ(countZ,:) = [t(i), sign(grad_dX_dx), dX_dx(nno,i), isitmax]; % where a 1= max and -1 = min
        if  sign(grad_dX_dx) < 0 & abs(dX_dx(nno,i)- myrecordZ(countZ-1,3))> 200
            myrecordZ(countZ-1,4) = 1;
        end
        countZ = countZ+1;
    end 
    grad_gZdV_dx = grad_gZdV_dx1;
    grad_dX_dx = grad_dX_dx1;
    if t(i)>40
        break
    end
end


Y1 = myrecordZ(:, 3).*myrecordZ(:, 4);
Y2 = myrecordV(:,3).*myrecordV(:, 4);
ct = 0; 
for i = 1:length(Y1)
    if Y1(i) ~= 0
        ct = ct+1;
        R1(ct, :) = [myrecordZ(i,1), Y1(i), 0];
        if ct > 1
            R1(ct-1, 3) = R1(ct, 1) - R1(ct-1, 1);
        end
    end
end
ct = 0;
for i = 1:length(Y2)
    if Y2(i) ~= 0
        ct = ct+1;
        R2(ct, :) = [myrecordV(i,1), Y2(i), 0];
        if ct > 1
            R2(ct-1, 3) = R2(ct, 1) - R2(ct-1, 1);
        end
    end
end

%%
figure(3)
suptitle('x = 0.5')
subplot(1,2,1)
    [AX,H1,H2] = plotyy(t,gZdV_dx(nno,:), t,dX_dx(nno,:));
    legend('gZdV\_dx', 'dZ\_dx')
    grid on
subplot(1,2,2)
    hold on
    [AX,H1,H2] = plotyy(t,gZdV_dx(nno,:), t,dX_dx(nno,:));
     set(AX(1),'YLim',[-5 10]); set(AX(2),'YLim',[275 425]);
     set(AX(1),'xlim',[0 45]); set(AX(2),'xlim',[0 45]);
    legend('gZdV\_dx', 'dZ\_dx')
    grid on
    [AXX,H11,H22] = plotyy(R2(1:end-1,1), R2(1:end-1,2), R1(3:end-1,1), R1(3:end-1,2));
    set(AXX(1),'YLim',[-5 10]); set(AXX(2),'YLim',[275 425]);
    set(AX(1),'xlim',[0 45]); set(AX(2),'xlim',[0 45]);
    
    H11.Color = 'b'; H11.LineStyle = 'none'; H11.Marker = 'x';
    H22.Color = 'r'; H22.LineStyle = 'none'; H22.Marker = 'x';



figure(4)
suptitle('x = 0.5')
subplot(1,2,1)
    plot(R1(3:end-1,1), R1(3:end-1,3) ,R2(1:end-1,1), R2(1:end-1,3));
    legend('Flux Z', 'Flux V')
    title('Period changes over space')
    xlabel('time')
    ylabel('period ') % left y-axis
subplot(1,2,2)
    change_phase = R1(3:end,1)- R2(1:end,1);
    plot(R1(3:end,1), change_phase, '-x')
    title('Phase Difference')
    xlabel('time')
    xlabel('\Delta time between two fluxes occolations')
    
%% Plot x(265)=0.2640


grad_gZdV_dx = gZdV_dx(265,2)-gZdV_dx(265,1);
grad_dX_dx = dX_dx(265,2)- dX_dx(265,1);
countZ = 2;
countV = 2;
myrecordV = [0,0,0,0];
myrecordZ = [0,0,0,0];
for i = 2:length(t)-1
    grad_gZdV_dx1 = gZdV_dx(265,i+1)-gZdV_dx(265,i);
    grad_dX_dx1 = dX_dx(265,i+1) -dX_dx(265,i);
    if sign(grad_gZdV_dx1)~= sign(grad_gZdV_dx)
        isitmax = 0;
        myrecordV(countV,:) = [t(i), sign(grad_gZdV_dx), gZdV_dx(265,i), isitmax]; % where a 1= max and -1 = min
        if  sign(grad_gZdV_dx) < 0 & abs(gZdV_dx(265,i)- myrecordV(countV-1,3))> 15
            myrecordV(countV-1,4) = 1;
        end
        countV = countV+1;
    end
    if sign(grad_dX_dx1)~= sign(grad_dX_dx)
        isitmax = 0;
        myrecordZ(countZ,:) = [t(i), sign(grad_dX_dx), dX_dx(265,i), isitmax]; % where a 1= max and -1 = min
        if  sign(grad_dX_dx) < 0 & abs(dX_dx(265,i)- myrecordZ(countZ-1,3))> 200
            myrecordZ(countZ-1,4) = 1;
        end
        countZ = countZ+1;
    end 
    grad_gZdV_dx = grad_gZdV_dx1;
    grad_dX_dx = grad_dX_dx1;
    if t(i)>99
        break
    end
end

R2 = []; R1 = [];

Y1 = myrecordZ(:, 3).*myrecordZ(:, 4);
Y2 = myrecordV(:,3).*myrecordV(:, 4);
ct = 0; 
for i = 1:length(Y1)
    if Y1(i) ~= 0
        ct = ct+1;
        R1(ct, :) = [myrecordZ(i,1), Y1(i), 0];
        if ct > 1
            R1(ct-1, 3) = R1(ct, 1) - R1(ct-1, 1);
        end
    end
end
ct = 0;
for i = 1:length(Y2)
    if Y2(i) ~= 0
        ct = ct+1;
        R2(ct, :) = [myrecordV(i,1), Y2(i), 0];
        if ct > 1
            R2(ct-1, 3) = R2(ct, 1) - R2(ct-1, 1);
        end
    end
end

%%
figure(5)
suptitle('x = 0.2640')
subplot(1,2,1)
    [AX,H1,H2] = plotyy(t,gZdV_dx(265,:), t,dX_dx(265,:));
    legend('gZdV\_dx', 'dZ\_dx')
    grid on
subplot(1,2,2)
    hold on
    [AX,H1,H2] = plotyy(t,gZdV_dx(265,:), t,dX_dx(265,:));
     set(AX(1),'YLim',[-5 10]); set(AX(2),'YLim',[275 600]);
     set(AX(1),'xlim',[0 100]); set(AX(2),'xlim',[0 100]);
    legend('gZdV\_dx', 'dZ\_dx')
    grid on
    [AXX,H11,H22] = plotyy(R2(1:end-1,1), R2(1:end-1,2), R1(3:end-1,1), R1(3:end-1,2));
    set(AXX(1),'YLim',[-5 10]); set(AXX(2),'YLim',[275 600]);
    set(AX(1),'xlim',[0 100]); set(AX(2),'xlim',[0 100]);
    
    H11.Color = 'b'; H11.LineStyle = 'none'; H11.Marker = 'x';
    H22.Color = 'r'; H22.LineStyle = 'none'; H22.Marker = 'x';



figure(6)
suptitle('x = 0.2640')
subplot(1,2,1)
    plot(R1(1:end-1,1), R1(1:end-1,3), '-xb' ,R2(1:end-1,1), R2(1:end-1,3),'-xr');
    legend('Flux Z', 'Flux V')
    title('Period changes over space')
    xlabel('time')
    ylabel('period ') % left y-axis
    x1 = 23.74;
    y1 = 5.002;
    str1 = '\leftarrow Ignore these points (jump in plot)';
    text(x1,y1,str1)
subplot(1,2,2)
    change_phase = R1(1:end,1)- R2(1:end,1);
    plot(R1(1:end,1), change_phase, '-x')
    title('Phase Difference')
    xlabel('time')
    ylabel('\Delta time between two fluxes occolations')


%% Add Horozontal lines of stability. 
intrim = mybeta;
it_end = t_end;
load('C:\Temp\Diffusion\MOL_PDE\4. Output files\bounds_data.mat');
mybeta = intrim;
list_1 = find(mybeta>bt_point); list_2 = find(mybeta>top_point);
top_pt = x(list_1(1)) ; bt_pt = x(list_2(1));
figure(1)
hold on
plot([0,it_end], [top_pt, top_pt], 'k','LineWidth',2)
plot([0,it_end], [bt_pt, bt_pt],  'k','LineWidth',2)
hold off

figure(2)
hold on
plot([0,it_end], [top_pt, top_pt], 'k','LineWidth',2)
plot([0,it_end], [bt_pt, bt_pt],  'k','LineWidth',2)
hold off
cd([AllDir.ParentDir, AllDir.SourceDir])



