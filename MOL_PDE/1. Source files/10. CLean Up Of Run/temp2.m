%Temp

clear;clc;close all

[ mybeta, tspan, y0, x, M, mtol, odeoptions ] = Inital_Conditions( 'G' );
display('Goldbeter')
Diff_type = 1; D =0;
display(['Diffusion = ', num2str(D)])
tic
[t, y0D] = ode45(@(t,y) odefun_Goldbeter(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions); 
toc
Goldbeter.Z0D = y0D(:, 1:M)';

figure();
imagesc(t,flipud(x),Goldbeter.Z0D)
set(gca,'YDir','normal')
		xlabel('Time, [s]')
		ylabel('Position, x')
		title('Zero diffusion')
		colormap jet
		hold on

%%

[ mybeta, tspan, y0, x, M, mtol, odeoptions ] = Inital_Conditions( 'G' );
display('Goldbeter')
Diff_type = 1; D =6e-6;
display(['Diffusion = ', num2str(D)])
tic
[t, y0D] = ode45(@(t,y) odefun_Goldbeter(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions); 
toc
Goldbeter.ZFD = y0D(:, 1:M)';

figure();
imagesc(t,flipud(x),Goldbeter.ZFD)
set(gca,'YDir','normal')
		xlabel('Time, [s]')
		ylabel('Position, x')
		title('Zero diffusion')
		colormap jet
		hold on
        
xdepth = x(161)
betadepth = mybeta(161)
        
%%
        
t0 = 0;   t1 = 20; dt = 0.001;
	dx = 1e-3;  
	x = 0:dx:1;    
	mybeta = x';
    mybeta(201:301) = mybeta(191);
M = length(x); 
mtol = 1e-6;
odeoptions = odeset('RelTol',mtol, 'AbsTol', mtol );
tspan = [t0:dt: t1];
Z_0 = 0.5; V_0 = -40; Y_0 = 0.5;
y0 = [x*0+Z_0, x*0+V_0, x*0+Y_0];
    
display('Goldbeter')
Diff_type = 1; D =6e-6;
display(['Diffusion = ', num2str(D)])
tic
[t, y0D] = ode45(@(t,y) odefun_Goldbeter(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions); 
toc
Goldbeter.ZFD2 = y0D(:, 1:M)';

figure();
imagesc(t,flipud(x),Goldbeter.ZFD2)
set(gca,'YDir','normal')
		xlabel('Time, [s]')
		ylabel('Position, x')
		title('Zero diffusion')
		colormap jet
		hold on
        
figure();
plot(x,mybeta)
hold on; plot([0,1], [0.16,0.16])
xlabel('position'); ylabel('Beta \beta')
        
xdepth = x(321)
betadepth = mybeta(321)