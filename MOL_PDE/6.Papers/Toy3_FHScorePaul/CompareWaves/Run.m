%% Run Toy model 3 

clear; clc; close all

% Move to correct directory
dir_source = 'C:\Temp\Diffusion\MOL_PDE\1. Source files\18. Pauls Toy';
dir_parent = 'C:\Temp\Diffusion\MOL_PDE\6.Papers\Toy3_FHScorePaul\CompareWaves';
dir_save = 'C:\Temp\Diffusion\MOL_PDE\4. Output files\A. 1. Paper';

%% Step 1 
% 3 xi Symetrical, FHW, BHW
% with a beta value close to bifurcation point

cd(dir_source);
myXi_vector = [0.1, 0.3, 0.65];
betavalues = [0.7, 0.4, 0.3];
timeplot = [160, 150, 50]*2;
idxmin_min = [];
P_10p = [0.05,0.05,0.05];


t0 = 0;   t1 = 200*2; dt = 0.05;
Diff_type = 1; 
D = 0;

tspan = [t0:dt: t1];
t = tspan;
N = length(t); 
mtol = 1e-6;
odeoptions = odeset('RelTol',mtol, 'AbsTol', mtol );
X_0 = -0.5; Y_0 = 0.1; 
y0 = [X_0, Y_0];

for ii = 1:length(myXi_vector)
    myXi = myXi_vector(ii);
    x = betavalues(ii); 
    mybeta = x;
    M = length(x); 
    display(['Toy 3; {Xi = ', num2str(myXi), '} {D = ', num2str(D), '}'])
    [t, y] = ode45(@(t,y) odefun_Toy3(t,y,mybeta,Diff_type, D, myXi), tspan, y0, odeoptions);
    Z = y(:, 1:M)';

    idx_t = find(t>=timeplot(ii),1);
    [PKS,LOCS]= findpeaks(-Z);
    Locs_idx1 = find(LOCS>=idx_t,1);
    Loc_min_1 = LOCS(Locs_idx1);
    Loc_min_2 = LOCS(Locs_idx1+1);
    idxmin_min(ii, 1:2) = [Loc_min_1, Loc_min_2];
    
    
    idx_length_p = Loc_min_2 - Loc_min_1+1;
    T = linspace(0,1,idx_length_p);
    
    idx_10p = find(T>=P_10p(ii),1);
    idx_50p = find(T>=0.5,1);
    
    zidx_b = Loc_min_1-idx_10p - idx_50p: Loc_min_2-idx_10p + idx_50p;
    zidx_c = Loc_min_1- idx_50p: Loc_min_2+ idx_50p;
    zidx_a = Loc_min_1+idx_10p - idx_50p: Loc_min_2+idx_10p + idx_50p;
    ddzddt = -2*Z(zidx_c) + Z(zidx_b) + Z(zidx_a);
    
    
    figure(4)
    subplot(3,length(myXi_vector), ii); hold on;
    T2 = linspace(-0.5,1.5,length(ddzddt));
    plot(T2, Z(zidx_c)); plot(T2, Z(zidx_b)); plot(T2, Z(zidx_a)); 
    
    subplot(3,length(myXi_vector), ii+3); hold on;
    T2 = linspace(-0.5,1.5,length(ddzddt));
    plot(T2, Z(zidx_c) - Z(zidx_b)); plot(T2, Z(zidx_c) - Z(zidx_a));  plot([-0.5,1.5], [0,0], 'k')
    
    subplot(3,length(myXi_vector), ii+6); hold on;
    T2 = linspace(-0.5,1.5,length(ddzddt));
    plot(T2, -1*(Z(zidx_c) - Z(zidx_b)+( Z(zidx_c) - Z(zidx_a))));  plot([-0.5,1.5], [0,0], 'k')
    figure(90+ii); hold on;
    plot(T2, -1*(Z(zidx_c) - Z(zidx_b)+( Z(zidx_c) - Z(zidx_a))));  plot([-0.5,1.5], [0,0], 'k')
    
end


%% Step 2
% Load diffusion data
% plot 


myXi = myXi_vector(ii);
x = 0:1e-3:1; 
mybeta = x';
M = length(x); 
X_0 = -0.5; Y_0 = 0.1; 
y0 = [x*0+X_0, x*0+Y_0];
D = 5e-6;
for ii = 1:length(myXi_vector)
    myXi = myXi_vector(ii);
    display(['Toy 3; {Xi = ', num2str(myXi), '} {D = ', num2str(D), '}'])
    [t, y] = ode45(@(t,y) odefun_Toy3(t,y,mybeta,Diff_type, D, myXi), tspan, y0, odeoptions);
    Z = y(:, 1:M)';
    
    figure(5)
    subplot(2,length(myXi_vector), ii); hold on;
    imagesc(t,flipud(x),Z)
    axis([0,700,0,1])
    set(gca,'YDir','normal')
    xlabel('Time, [s]')
    ylabel('Position, x')
    colormap jet
    
    display('Flux')
    for jj = 1:length(t)
        [ dydt , L_X, L_Y, d2Zdx2] = odefun_Toy3( t(jj), y(jj, :)' , mybeta, Diff_type, D, myXi);
        d2Zdx2_V(jj, :) = d2Zdx2;
    end
        
    idx_x = find(mybeta >= betavalues(ii), 1);
    subplot(2,length(myXi_vector), ii+3); hold on;
    plot(t(idxmin_min(ii, 1):end), d2Zdx2_V( idxmin_min(ii, 1): end,idx_x))
    
    figure(80+ii); hold on;
    plot([0,t(end)], [0,0])
    plot(t, d2Zdx2_V(:, idx_x), 'k')
    
    figure(100)
    subplot(1,length(myXi_vector), ii); hold on;
    title('above or not')
    idxcale = find(Z(idx_x, :)>=0.1*(max(Z(idx_x, :))+ min(Z(idx_x, :))));
    if ii == 3
        plot(t(idxcale), d2Zdx2_V(idxcale, idx_x)*1e-6 + Z(idx_x, idxcale)')
    else
        plot(t, d2Zdx2_V(:, idx_x)*1e-6 + Z(idx_x, :)')
    end
    
end

cd(dir_parent)

figure(91); axis([-0.41, 0.8, -0.04, 0.04])
figure(92); axis([-0.5, 1, -15e-2,15e-2])
figure(93); axis([0.2, 1.3, -1.5, 1.7])


figure(81); axis([32, 43, -2.5e-3, 1.8e-3])
figure(82); axis([105, 130, -0.025, 0.015])
figure(83); axis([32, 67, -0.3, 0.35])






