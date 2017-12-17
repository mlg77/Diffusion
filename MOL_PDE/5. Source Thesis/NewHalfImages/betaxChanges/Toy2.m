% Create the half beta image to view only the lower bifurcation region
% Have the ODE and only Fickian Diffusion * 10 different D

clear; clc; close all

%% Move to correct directory
dir_source = 'C:\Temp\Diffusion\MOL_PDE\1. Source files\17. ToyClean';
dir_parent = 'C:\Temp\Diffusion\MOL_PDE\5. Source Thesis\NewHalfImages\betaxChanges';
dir_save = 'C:\Temp\Diffusion\MOL_PDE\4. Output files\8. HalfImages\betaChanges\Toy2';

cd(dir_source);

t0 = 0;   t1 = 700; dt = 0.01;
dx = 1e-3;  
x = 0:dx:1;   

mybeta = x';
D = 5e-6;

Diff_type = 1; 
tspan = [t0:dt: t1];
t = tspan;
M = length(x); 
N = length(t); 
mtol = 1e-6;
odeoptions = odeset('RelTol',mtol, 'AbsTol', mtol );

X_0 = -1.2; Y_0 = 0.1; 
% X_0 = -1.4389; Y_0 = 3.2074; 
y0 = [x*0+X_0, x*0+Y_0];

for ii = 4%[1,3,4]%2%1:4
    if ii == 1
        mybeta = x';
    elseif ii == 2
        mybeta = x';
        idx_1 = find(mybeta>= 0.195, 1)
        mybeta(401:451) = mybeta(idx_1);
    elseif ii == 3
        mybeta = x';
        mybeta(376:451) = mybeta(451);
        mybeta(301:375) = mybeta(375);
        mybeta(226:300) = mybeta(300);
        mybeta(151:225) = mybeta(225);
        mybeta(76:150) = mybeta(150);
    elseif ii == 4
        mybetabase = x';
        % intersect :
        x_eq = [0, 0.5, 0.35, 0.25 ]';
        b_eq = [0, 0.5, 0.24, 0.52 ]';
        A = [x_eq.^3, x_eq.^2, x_eq, ones(4,1)];
        pars = A\b_eq
        a = pars(1); b= pars(2); c = pars(3);  d = pars(4);
        betacurve = a.*x.^3 + b.*x.^2 + c.*x + d;
        mybeta = [betacurve(1:500)'; mybetabase(501:end)];
    end
    display(['Toy2 ii = ', num2str(ii)])
    cd(dir_source)
    [t, y0D] = ode45(@(t,y) odefun_Toy2(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions); 

    Z0D = y0D(:, 1:M)';
    Y0D = y0D(:, M+1:2*M)';
    

    cd([dir_save])
    mybeta = mybeta*0.2+0.1;
    save(['Toy2_', num2str(ii)], 'Z0D', 'Y0D', 't', 'x', 'mybeta', 'D')
    
    figure(ii);
    imagesc(t,flipud(x),Z0D)
    set(gca,'YDir','normal')
    xlabel('Time, [s]')
    ylabel('Position, x')
    colormap jet
    colorbar
    hold on
    plot([t(1), t(end)], 0.5*[1,1],'k', 'linewidth', 2)
    
    figure(ii+10);
    hold on;
    plot(mybeta, x,  'b', 'linewidth', 2)
    idx_half = find(x>=0.5,1);
    plot([mybeta(idx_half), mybeta(idx_half), mybeta(1)], [x(1), x(idx_half), x(idx_half)],'k', 'linewidth', 2)
    if ii == 4
        figure(ii);
        idx2 = find(mybeta>= mybeta(idx_half), 1);
        idx3 = find(mybeta(201:end)<= mybeta(idx_half), 1) + 200;
        plot([t(1), t(end)], [x(idx2), x(idx2)],'k', 'linewidth', 2)
        plot([t(1), t(end)], [x(idx3), x(idx3)],'k', 'linewidth', 2)
    end
    ylabel('Position, x')
    xlabel('Beta, \beta')
    
end
display('finished Run')
return

num_figs = 1:4;
cd([dir_save, '\Images'])
for ii = num_figs
    figure(ii)
    savefig(ii, ['Toy2_st_', num2str(ii), '.fig'])
    set(gcf,'PaperPositionMode','auto')
    print(['Toy2_st_', num2str(ii)],'-dpng', '-r300')
    
    figure(ii + 10)
    savefig(ii+10, ['Toy2_beta_', num2str(ii), '.fig'])
    set(gcf,'PaperPositionMode','auto')
    print(['Toy2_beta_', num2str(ii)],'-dpng', '-r300')
end


cd(dir_parent);