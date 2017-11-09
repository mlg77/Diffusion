%% For my report 
% Step 1:   choose 6 dbdx profiles 
% Step 2:   Compute the solutions for D = 6e-6
% Step 3:   Run Depth approximations for all 6x5(profiles*D*wave)
% Step 4:   Plot [dbdx, sol(D=6e-6), AoP(wave 1:5)]

% Author: Michelle Goodman
% Date: 11/6/17

clear; clc; close all
dirs.this_file = 'C:\Temp\Diffusion\MOL_PDE\1. Source files\12. Aop';
dirs.save_file = 'C:\Temp\Diffusion\MOL_PDE\4. Output files\Archive_PreThesis\Stability\Dupont';

po_zero = @(x) ([x>=0.39] + [x<=0.42] - 1);
po_norm = @(x) x>=0.5;
f_dbdx = @(x) [x*0.792;
    0.1980/0.5*x+0.1980;
    0.1980/0.5*x.*(1 - po_zero(x))+0.1980 - po_zero(x)*0.098;
    0.792*x.*po_norm(x) + (1-po_norm(x)).*(27.1*x.^3 - 22.72*x.^2 + 5.38*x );
    0.792*x.*po_norm(x) + (1-po_norm(x)).*(50.2*x.^3 - 41*x.^2 + 8.8*x ); % doesnt interconnect
    0.792*x.*po_norm(x) + (1-po_norm(x)).*(28.78*x.^3 - 24.89*x.^2 + 6.05*x )]; % interconnecting

x = 0:1e-3:1;
M = length(x);
tspan = [0:1e-3: 50];
t = tspan;
dbdx = f_dbdx(x);
dbdx(5, [496:500]) = 0.3960;
dbdx(6, 500) = 0.3960;
%% Run solution only plot
prerun =1;
if prerun
    Z0D = [];
    cd(dirs.save_file)
    load('Sol2')
    Z0D(:,:, 1:3) = Z0D_1;
    Z0D(:,:, 4:6) = Z0D_2;
    cd(dirs.this_file)
else

    for ii = 1:size(dbdx, 1)
        mybeta = dbdx(ii, :)';
        Z_0 = 0.5; A_0 = 0.1; Y_0 = 0.5;
        y0 = [Z_0+ x*0, A_0+ x*0, Y_0+ x*0];
        mtol = 1e-6;
        Diff_type = 1; D = 6e-6;
        odeoptions = odeset('RelTol',mtol, 'AbsTol', mtol );
        [t, y0D] = ode45(@(t,y) odefun_Dupont(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions);
        Z0D(:,:, ii) = y0D(:, 1:M)';
    end
    Z0D_1 = Z0D(:,:, 1:3);
    Z0D_2 = Z0D(:,:, 4:6);
    cd(dirs.save_file)
    save('Sol2', 'Z0D_1', 'Z0D_2')
    cd(dirs.this_file)
end

%% Predict depth of plotting ones

cd(dirs.save_file)
load('sen_perts_data_full_need')
cd(dirs.this_file)

a1_a2_b1_b2 = [-0.025573737362939, -0.01278638174584, 0.063408766383566, 0.067664806911860];
% a1_a2_b1_b2 = [-0.025573737362939, 0.0127863817458, 0.063408766383566, 0.067664806911860];
% a1_a2_b1_b2 = [-0.0377,-0.0105, 0.0883, 0.0651];% p = aop*f1

position_x = 0:1e-3:0.5;
Aop = [];
for ii = 1:length(position_x)
    Aop(ii, :) = max_Z(ii,:)-BaseZ(ii,:)-perts;
end
betas_coll = position_x*0.792;
Aop(find(Aop <= 1e-5)) = 0;
lastpertcare = find(perts >=0.5, 1);

wvae_num = 1:4;
prerun_pre =1;
if prerun_pre
    cd(dirs.save_file)
    load('Predicted')
    cd(dirs.this_file)
else
    Predicted_D = [];
    for ii = 1:size(dbdx, 1)
        mybeta = dbdx(ii, :)';
        D = 6e-6;
        
        [ reordered_AoP, Predicted_x_pert_pert ] = Predicted_function( Aop,perts,mybeta, dbdx(1,:) , a1_a2_b1_b2, D, wvae_num  );
        Aop_reordered(:,:, ii) = reordered_AoP;
        Predicted_x_pert_pert_db(:,:, ii) = Predicted_x_pert_pert;
    end
    cd(dirs.save_file)
    save('Predicted', 'Aop_reordered', 'Predicted_x_pert_pert_db')
    cd(dirs.this_file)
end


%% Actually plot
% figure(1)
for ii = 1:size(dbdx, 1)
    figure(ii)
    subplot(1,3, 1); hold on
%     subplot(6,3, ii*3-2); hold on
    plot(dbdx(ii, :) , x,'b','linewidth', 2)
    plot([0,0.396,0.396] , [0.5,0.5,0] ,':k','linewidth', 2)
    grid on;
    xlabel('Beta, \beta'); ylabel('Position, x [cm]')
    axis([0,0.8,0,1])
        
    ax1 = subplot(1,3,2); hold on
%     ax1 = subplot(6,3, ii*3-1); hold on
    imagesc(t,flipud(x),Z0D(:,:,ii))
    colormap(ax1,jet);
    plot([0,50] , [0.5,0.5] ,':k','linewidth', 2)
    xlabel('Time, [s]'); ylabel('Position, x [cm]')
    axis([0,50,0,1])
    
    subplot(1,3,3); hold on
%     subplot(6,3, ii*3); hold on
    myColorMap = summer; 
    myColorMap(1, :) = [1 1 1];
    [C,h1] = contourf(perts(1:lastpertcare), position_x, Aop_reordered(:, 1:lastpertcare,ii), 20); hold on;
    [C,h2] = contour(perts(1:lastpertcare), position_x, Aop_reordered(:, 1:lastpertcare, ii), 20);
    axis([0,0.5,0,1])
    xlabel('Perturbations'); ylabel('Position, x [cm]');
    colormap(myColorMap); colorbar
    set(gca,'YDir','normal'); set(gca,'layer','top');
    grid on
    hasbehavior(h1, 'legend', false);  hasbehavior(h2, 'legend', false); 
    rectangle('Position',[0,0.5,0.5,0.5],'FaceColor',[0.5 0.5 0.5])
    
    if ii == 5 
        nan_aop = find(isnan(Aop_reordered(:, 1,ii)));
        rectangle('Position',[0,x(nan_aop(1)), 0.5,x(nan_aop(end-1)-nan_aop(1))],'FaceColor',[0.5 0.5 0.5])
    elseif ii == 6
        nan_aop = find(isnan(Aop_reordered(:, 1,ii)));
        rectangle('Position',[0,x(nan_aop(1)), 0.5,x(nan_aop(end-1)-nan_aop(1))],'FaceColor',[0.5 0.5 0.5])
        subplot(1,3,2); hold on; plot([0,50], 0.2603*[1,1], 'k:', 'linewidth', 2)
        subplot(1,3,2); hold on; plot([0,50], 0.1061*[1,1], 'k:', 'linewidth', 2)
    end
    
    for jj = 1:length(wvae_num)
        subplot(1,3,3);
        plot(Predicted_x_pert_pert_db(:,jj+1, ii), Predicted_x_pert_pert_db(:,1, ii) , 'linewidth', 2)
    end
    
    
    
end

col_4 = {'b', 'r','c', 'm'};
for ii = 6
    figure(ii)
    mybeta = dbdx(ii, :)';
    D = 6e-6;
    for wvae_num = 1:4
        a1a2a3a4 = [-0.025573737362939, -0.02, 0.063408766383566, 0.067664806911860];
        a = (a1a2a3a4(1)*log(6) + a1a2a3a4(2));
        b = (a1a2a3a4(3)*log(6) + a1a2a3a4(4));
        f_1 =  a*log(wvae_num) + b;
        
        [ x_P, P ] = predict_depth_ex6( Aop_reordered(:,:, ii), perts, x, 0.499, f_1, 1 );
        subplot(1,3,3); plot(P(2:end), x_P(2:end), col_4{wvae_num}, 'linewidth', 2)
        
        [ x_P, P ] = predict_depth_ex6( Aop_reordered(:,:, ii), perts, x, x(107), f_1, 1 );
        subplot(1,3,3); plot(P(2:end), x_P(2:end), col_4{wvae_num}, 'linewidth', 2)
        if wvae_num == 1
            % don't do -ve dir from osc
        else
            [ x_P, P ] = predict_depth_ex6( Aop_reordered(:,:, ii), perts, x, x(262), f_1, -1 );
            subplot(1,3,3); plot(P(2:end), x_P(2:end), col_4{wvae_num}, 'linewidth', 2)
        end
    end
end
        