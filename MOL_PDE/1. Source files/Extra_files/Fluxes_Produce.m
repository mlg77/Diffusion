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
myfig1 = subplot(1,2,1);
load('ED_data_Fluxes');
imagesc(t,flipud(x(2:end-1)),dX_dx(2:end-1,:))
axis([0,100,0,1])
set(gca,'YDir','normal')
xlabel('Time, [s]')
ylabel('Position, x [cm]')
title('Fickian Flux of Calcium in the Cytosol, [\muMcm^{-1}]')
colorbar
cmap = jet(256);
caxis(gca,[-550-2/256, 600]);
placement = 120:140;
cmap(placement,:)=ones(length(placement),3);
colormap(myfig1, cmap)
colorbar
grid on

figure(1)
myfig2 =  subplot(1,2,2);
cmap = jet(256);
imagesc(t,flipud(x(11:end-30)),gZdV_dx(11:end-30,:) )
axis([0,100,0,1])
set(gca,'YDir','normal')
xlabel('Time, [s]')
ylabel('Position, x [cm]')
title('Electro-Diffusive Flux in the Cytosol, [\muMcm^{-1}]')
cmap = jet(256);
caxis(gca,[-105-2/256, 85]);
placement = 138:148;
cmap(placement,:)=ones(length(placement),3);
colormap(myfig2, cmap)
colorbar
grid on



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
%     if t(i)>40
%         break
%     end
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
subplot(2,1,1)
    [AX,H1,H2] = plotyy(t,gZdV_dx(nno,:), t,dX_dx(nno,:));
    title('x = 0.5')
    xlabel('Time, [s]')
    ylabel('Flux, [\muMcm^{-1}]')
    legend('Electro Diffusive Flux', 'Fickian Flux')
    grid on
figure(4)
subplot(2,1,1)
    hold on
    [AX,H1,H2] = plotyy(t,gZdV_dx(nno,:), t,dX_dx(nno,:));
    legend('Electro Diffusive Flux', 'Fickian Flux')
    title('x = 0.5')
    xlabel('Time, [s]')
    ylabel('Flux, [\muMcm^{-1}]')
    [AXX,H11,H22] = plotyy(R2(1:end-1,1), R2(1:end-1,2), R1(3:end-1,1), R1(3:end-1,2));
    set(AX(1),'yLim',[-50 10]); set(AX(2),'yLim',[-250 450]);
    set(AX(1),'xlim',[10 12]); set(AX(2),'xlim',[10 12]);
    set(AXX(1),'yLim',[-50 10]); set(AXX(2),'yLim',[-250 450]);
    set(AXX(1),'xlim',[10 12]); set(AXX(2),'xlim',[10 12]);
    set(AX(1),'YTick', [-60:20:10] )
    set(AXX(2),'YTick', [-400:200:400] )
    set(AX(2),'YTick', [-500:1000:500] )
    set(AXX,{'ycolor'},{'b';'r'}) 
    grid on
    set(gca,'XTick',(2:0.15:4))
%     legend('gZdV\_dx', 'dZ\_dx')
    
    
    H11.Color = 'b'; H11.LineStyle = 'none'; H11.Marker = 'x';
    H22.Color = 'r'; H22.LineStyle = 'none'; H22.Marker = 'x';



figure(5)
subplot(2,1,1)
    plot(R1(3:end-1,1), R1(3:end-1,3), '-xb' ,R2(1:end-1,1), R2(1:end-1,3), '-xr');
    legend('Fickian Flux', 'Electro-Diffusive Flux')
    title('x = 0.5')
    xlabel('Time, [s]')
    ylabel('Period, [s]') % left y-axis
figure(6)
subplot(2,1,1)
    change_phase = R1(3:end,1)- R2(1:end-1,1);
    plot(R1(3:end,1), change_phase, '-x')
    title('x = 0.5')
    xlabel('Time, [s]')
    ylabel('\Delta time between two fluxes occolations')
    
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
figure(3)
subplot(2,1,2)
    [AX,H1,H2] = plotyy(t,gZdV_dx(265,:), t,dX_dx(265,:));
    legend('Electro Diffusive Flux', 'Fickian Flux')
    title('x = 0.2640')
    xlabel('Time, [s]')
    ylabel('Flux, [\muMcm^{-1}]')
%     legend('gZdV\_dx', 'dZ\_dx')
    grid on
figure(4)
subplot(2,1,2)
    hold on
    [AX,H1,H2] = plotyy(t,gZdV_dx(265,:), t,dX_dx(265,:));
     set(AX(1),'YLim',[-100 10]); set(AX(2),'YLim',[-500 600]);
     set(AX(1),'xlim',[10 14.5]); set(AX(2),'xlim',[10 14.5]);
%      legend([H1,H2],'gZdV\_dx', 'dZ\_dx')
    legend('Electro Diffusive Flux', 'Fickian Flux')
    grid on
    [AXX,H11,H22] = plotyy(R2(1:end-1,1), R2(1:end-1,2), R1(3:end-1,1), R1(3:end-1,2));
    set(AXX(1),'YLim',[-100 10]); set(AXX(2),'YLim',[-500 600]);
    set(AXX(1),'xlim',[10 14.5]); set(AXX(2),'xlim',[10 14.5]);
    set(AX,{'ycolor'},{'b';'r'}) 
    H11.Color = 'b'; H11.LineStyle = 'none'; H11.Marker = 'x';
    H22.Color = 'r'; H22.LineStyle = 'none'; H22.Marker = 'x';
    set(AXX(2),'YTick', [-500:200:600] )
    set(AX(2),'YTick', [-500:1500:1500] )
    title('x = 0.2640')
    xlabel('Time, [s]')
    set(get(AX(1),'Ylabel'),'String','Flux, [\muMcm^{-1}]') 
%     set(get(AX(2),'Ylabel'),'String','Calcium Concentration, [\muM]') 


figure(5)
subplot(2,1,2)
    plot(R1(1:end-1,1), R1(1:end-1,3), '-xb' ,R2(1:end-1,1), R2(1:end-1,3),'-xr');
    legend('Fickian Flux', 'Electro-Diffusive Flux')
    title('x = 0.2640')
    xlabel('Time, [s]')
    ylabel('Period, [s]') % left y-axis
    x1 = 23.74;
    y1 = 4.5;
    str1 = '\leftarrow Ignore this points (jump in plot)';
    text(x1,y1,str1)
figure(6)
subplot(2,1,2)
    change_phase = R1(1:end,1)- R2(1:end,1);
    plot(R1(1:end,1), change_phase, '-x')
    title('x = 0.2640')
    xlabel('Time, [s]')
    ylabel('\Delta time between two fluxes occolations')


%% Add Horozontal lines of stability. 
intrim = mybeta;
it_end = t_end;
load('C:\Temp\Diffusion\MOL_PDE\4. Output files\bounds_data.mat');
mybeta = intrim;
list_1 = find(mybeta>bt_point); list_2 = find(mybeta>top_point);
top_pt = x(list_1(1)) ; bt_pt = x(list_2(1));
figure(1)
subplot(1,2,1)
hold on
plot([0,it_end], [top_pt, top_pt], 'k','LineWidth',2)
plot([0,it_end], [bt_pt, bt_pt],  'k','LineWidth',2)
hold off

figure(1)
subplot(1,2,2)
hold on
plot([0,it_end], [top_pt, top_pt], 'k','LineWidth',2)
plot([0,it_end], [bt_pt, bt_pt],  'k','LineWidth',2)
hold off
cd([AllDir.ParentDir, AllDir.SourceDir])



