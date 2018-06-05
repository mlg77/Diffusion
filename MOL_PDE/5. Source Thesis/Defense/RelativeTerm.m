% relative term sizes

clear; clc; close all

%% Move to correct directory
dir_source = 'C:\Temp\Diffusion\MOL_PDE\1. Source files\10. CLean Up Of Run\Dupontround2';
dir_parent = 'C:\Temp\Diffusion\MOL_PDE\5. Source Thesis\Defense';
dir_save = 'C:\Temp\Diffusion\MOL_PDE\4. Output files\13. Defense';

cd(dir_source);

t0 = 0;   t1 = 50; dt = 0.01;
dx = 1e-3;  
x = 0:dx:1;   

LowestPt = 0;
LowerBi = 0.395;
mybeta = ((LowerBi- LowestPt)/0.5)*(x') + LowestPt;
mybeta = x';

D = 5*1e-6;
count = 0;

Diff_type = 2; 
tspan = [t0:dt: t1];
t = tspan;
M = length(x); 
N = length(t); 
mtol = 1e-6;
odeoptions = odeset('RelTol',mtol, 'AbsTol', mtol );

Z_0 = 0.5; A_0 = 0.1; Y_0 = 0.5; V_0 = -40;
y0 = [x*0+Z_0, x*0+A_0, x*0+Y_0, x*0+V_0];
    
display(['Dupont D = ', num2str(D)])
cd(dir_source)
[t, y0D] = ode45(@(t,y) odefun_Dupont(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions); 

Allres = []; Dydt = [];
for ii = 1:length(t) 
    [ dydt , L_Z, L_Y, d2Zdx2,d2Zdxfd, v_2, v_3] = odefun_Dupont( t(ii), y0D(ii,:)', mybeta, Diff_type, D);
    Dydt(1:length(dydt),ii) = dydt;
    Allres(1:length(L_Z),ii,1) = L_Z;
    Allres(1:length(L_Z),ii,2) = L_Y;
    Allres(1:length(L_Z),ii,3) = d2Zdx2;
    Allres(1:length(L_Z),ii,4)= v_2;
    Allres(1:length(L_Z),ii,5) = v_3;
    Allres(1:length(L_Z),ii,6) =d2Zdxfd;
end

Z0D = y0D(:, 1:M)';
figure(1);
imagesc(t,flipud(x),Z0D)
set(gca,'YDir','normal')
xlabel('Time, [s]')
ylabel('Position, x')
colormap jet
colorbar
hold on

figure(2);
    imagesc(t,flipud(x),Dydt(1:M, :))
    set(gca,'YDir','normal')
    xlabel('Time, [s]')
    ylabel('Position, x')
    colormap jet
    colorbar
    hold on
    title('dZdt')
titless = {'L_Z', 'L_Y', 'ED d2Zdx2', 'v_2', 'v_3', 'FD d2Zdx2'}
for ii = 1:6
    figure(ii);
    imagesc(t,flipud(x),Allres(:,:,ii))
    set(gca,'YDir','normal')
    xlabel('Time, [s]')
    ylabel('Position, x')
    colormap jet
    colorbar
    title(titless{ii})
    hold on
end

figure(12);
    plot(t(1:400),Dydt(501, 1:400))
    xlabel('Time, [s]')
    ylabel('dZdt')
    
for ii = 1:6
    figure(ii+10);
    plot(t(1:400),Allres(501,1:400,ii))
    xlabel('Time, [s]')
    ylabel(titless{ii})
end
