%% Given Data file of sensitive pertibations

clc; close all

cd('C:\Temp\Diffusion\MOL_PDE\4. Output files\Stability\Goldbeter')
load('Sensitiveto1.mat')
cd('C:\Temp\Diffusion\MOL_PDE\1. Source files\11. Stability\Goldbeter')


figure(2)
hold on
plotted_Z = [];
for ii = 1:length(betas_coll)
    % which third are you in
    what_betas{ii} = num2str(betas_coll(ii));
    [ r, g, b ] = col_rainbow( ii, length(betas_coll) );
    h(ii) = plot(perts, max_Z(ii,:)-BaseZ(ii,:)-perts, 'Color', [r/255,g/255,b/255]);
    plotted_Z(ii, :) = max_Z(ii,:)-BaseZ(ii,:)-perts;
end
grid on; 
order=length(betas_coll):-1:1;
% legend(h(order), what_betas{order})
xlabel('Pertibations'); ylabel('Max \Phi'); title('Max \Phi')

axis([0,1,-0.05,1.2])



%% Given:
%   plotted_Z which is a matrix of each row relates to a beta value and each
%       colum relates to a pertibation such that size(plotted_Z) = (M,  N)
%   betas_coll which is the betas length(betas_coll) = M
%   perts which is the pertibations applied length(perts) = N
% Find:
%   
x = 0:dx:0.5;

betas_coll = 0.56*betas_coll;

typedbetadx = 4;
if typedbetadx == 1
    %% Make beta equal zero at some point
    x_idx_zero = 400;
    display(['x when goes to zero: ', num2str(x(x_idx_zero))])
    new_beta = betas_coll;
    new_beta(x_idx_zero) = 0;
elseif typedbetadx == 2
    %% Dbeta dx = 
    new_beta = 23.8*x.^3 -18.33*x.^2 +4.21*x;
    new_beta = new_beta*0.56;
elseif typedbetadx == 3
    new_beta = 2*x.^2;
    new_beta = new_beta*0.56;
elseif typedbetadx == 4
    new_beta = 3/5*x + 0.2;
    new_beta = new_beta*0.56;
elseif typedbetadx == 5
    new_beta = betas_coll;
elseif typedbetadx == 6
    new_beta = (0.5*(1+tanh((x-0.5)/0.5)))';
    new_beta = (new_beta*0.56)';
elseif typedbetadx == 7
    new_beta = x * 0.56;
elseif typedbetadx == 8
    new_beta = x * 0.56;
    new_beta(:) = new_beta(401);
end
myfreq = 1;

% Do the first one 
dx = 1e-3;
D = 6e-6;

const = [-0.030540521298861, 0.006814633347649,0.085830263965313, 0.032976935489650];
wavefrontnumber = 8;
a = (const(1)*log(D/dx^2) + const(2));
b = (const(3)*log(D/dx^2) + const(4));
Rate =  a*log(wavefrontnumber) + b;
% Rate = 0.106;
% rate_co = 0.0858*log(D/dx^2) + 0.033;
rate_co = Rate
inital_pert = 0.2;
idx_0_per = find(perts >=inital_pert, 1);
beta_x = find(betas_coll >= new_beta(end), 1); % Relate the x value to the beta value
AoP = plotted_Z(beta_x, idx_0_per);

% Pertibation Applied | AoP | x value | beta value
to_plot(1,1:5) = [perts(idx_0_per), AoP, betas_coll(beta_x), new_beta(end), x(beta_x)];
AoP_alpha = AoP*rate_co;

for ii = 1:length(new_beta)-1
    
    idx_0_per = find(perts >=AoP_alpha, 1); % Finds index of pert
    beta_x = find(betas_coll >= new_beta(end-ii), 1); % Relate the x value to the beta value
    AoP = plotted_Z(beta_x, idx_0_per); % Finds new pertibation
    
    % Save data
    to_plot(ii+1,1:5) = [perts(idx_0_per), AoP, betas_coll(beta_x), new_beta(end-ii), x(end-ii)];
    
    % Update AoP
    AoP_alpha = AoP*rate_co;
end

plot(to_plot(3:end,1),to_plot(3:end,2), 'xk-')
to_plot_idx_end = find(to_plot(:,2)<= 1e-3, 1);
display(['beta when wave will stop: ', num2str(to_plot(to_plot_idx_end, 3))])
display(['With a new beta value of: ', num2str(to_plot(to_plot_idx_end,4))])
display(['With a x value of: ', num2str(to_plot(to_plot_idx_end,5))])

figure(); 
plot(new_beta, x); 
hold on; plot(to_plot(to_plot_idx_end,4),to_plot(to_plot_idx_end,5), 'x' )
xlabel('new beta'); ylabel('x')
plot(Goldbeter.mybeta, Goldbeter.x)
grid on
break
%% Depth plot
% D, Area wave x, area x+dx, dt, T x, T x+dx, dT, myfit a, myfit b
final_save_diffD = [];
rates_diffD = [];
lnx_difD = [];
for dif_D_val = 1:3
    cd('C:\Temp\Diffusion\MOL_PDE\4. Output files\Stability\Goldbeter\changeD')
    % load('GoldbeterHalfSol.mat')
    % load('GoldbeterHalfSol_startMax.mat')
    D = 6e-6;
    if dif_D_val == 1
        load('GoldbeterHalfSol_startMaxEqu.mat')
%         D = D;
        Dcol = 'b';
    elseif dif_D_val == 2
        load('DoubleD_ GoldbeterHalfSol_startMaxEqu.mat')
%         D = D*2;
        Dcol = 'r';
    elseif  dif_D_val == 3
%         load('D4_GoldbeterHalfSol_startMaxEqu.mat')
        load('Dpt5_GoldbeterHalfSol_startMaxEqu.mat')
%         load('D8_GoldbeterHalfSol_startMaxEqu.mat')
%         D = 0.5*D;
%         D = D*4;
        Dcol = 'g';
    end
    cd('C:\Temp\Diffusion\MOL_PDE\1. Source files\11. Stability\Goldbeter')

    end_point = [];
    dbeta_dt =[];
    figure(97); hold on;
    for ii = 2:22 % Note for normal solution use 0:22
        [ wave_data ] = Follow_wave( Goldbeter.ZFD, Goldbeter.x, Goldbeter.t, 0.5, ii-1, [0,1] );
    %     plot(wave_data.t,wave_data.po)
        hold on; plot(wave_data.t,wave_data.po,Dcol, 'linewidth', 2)% For the imagesc
        leg{ii-1} = ['wave', num2str(ii-1)];
        end_point(ii-1) = wave_data.po(end);
        dx_dt(ii-1) =  (wave_data.po(2)- wave_data.po(1))./ (wave_data.t(2)- wave_data.t(1));
    end
    xlabel('time'); ylabel('Position'); legend(leg)

    x = linspace(0,0.5, length(betas_coll));
    newbeta = x*0.56;
    Rate_Depth = [];
    for rate = 0.01:0.0001:0.4
        % Do the first one
        dx = 1e-3;
%         D = 6e-6;
%         rate_co = D/dx^2*0.1;
        rate_co = rate;
        inital_pert = 0.2*rate_co;
        idx_0_per = find(perts >=inital_pert, 1);
        beta_x = find(betas_coll >= newbeta(end), 1); % Relate the x value to the beta value
        AoP = plotted_Z(beta_x, idx_0_per);
        to_plot = [];
        % Pertibation Applied | AoP | x value | beta value
        to_plot(1,1:4) = [perts(idx_0_per), AoP, betas_coll(beta_x), x(end)];
        AoP_alpha = AoP*rate_co;

        for ii = 1:length(x)-1
            idx_0_per = find(perts >=AoP_alpha, 1); % Finds index of pert
            beta_x = find(betas_coll >= newbeta(end-ii), 1); % Relate the x value to the beta value
            AoP = plotted_Z(beta_x, idx_0_per); % Finds new pertibation
            to_plot(ii+1,1:4) = [perts(idx_0_per), AoP, betas_coll(beta_x), x(end-ii)];
            AoP_alpha = AoP*rate_co;
        end
        x_end_wave = to_plot(find(to_plot(:,2)<= 1e-3, 1), 4);
        Rate_Depth(end+1, 1:2) = [rate_co, x_end_wave];
    end

    for ii = 1:size(end_point, 2)
        end_point(2,ii) = Rate_Depth(find(Rate_Depth(:,2)<=end_point(1, ii), 1), 1);
    end
    figure(98);
    plot(end_point(1,:))
    xlabel('Number wave')
    ylabel('The rate needed to stop at this depth')
    
    figure();
    xstar = Goldbeter.Z0D(518, :) ;
    xstarplus = Goldbeter.Z0D(519, :);

    % xstar = xstar- min(Goldbeter.Z0D(518, :));
    % xstarplus = xstarplus - min(Goldbeter.Z0D(519, :));

    % xstar = xstar/max(xstar);
    % xstarplus = xstarplus/max(xstarplus);


    [pks1, loc_min1] = findpeaks(-Goldbeter.Z0D(518, :));
    [pks2, loc_min2] = findpeaks(-Goldbeter.Z0D(519, :));
    loc_min1 = [1, loc_min1];
    loc_min2 = [1, loc_min2];

    % T1 = t(loc_min1(end)- loc_min1(end-1));
    % T2 = t(loc_min2(end)- loc_min2(end-1));
    T1 = 1; T2 = 1;

    areaxstar = (dt)*(xstar(1:end-1)+xstar(2:end))/2;
    areaxstarplus = (dt)*(xstarplus(1:end-1)+xstarplus(2:end))/2;

    area_xstar_wave  = [];
    area_xstarplus_wave = [];
    for ii = 1:length(loc_min1) - 1
        area_xstar_wave(ii) = sum(areaxstar(loc_min1(ii):loc_min1(ii+1))) ;
        area_xstarplus_wave(ii) = sum(areaxstarplus(loc_min2(ii):loc_min2(ii+1)));
    end
    % plot(t_halfarea(:,1));    hold on;
    % plot(t_halfarea(:,2)) 

    % [pks1, loc1] = findpeaks(Goldbeter.Z0D(519, :));
    % [pks2, loc2] = findpeaks(Goldbeter.Z0D(518, :));
    % wave_con = length(end_point(2,:));
    % T_diff = t(abs(loc1(1:wave_con)-loc2(1:wave_con))+1)';

    rate_waveno = end_point(2,:);
    lnx = log(1:length(rate_waveno));
    figure(99);
    subplot(1,2,1)
    plot(lnx, rate_waveno)
    myfit_care = polyfit(lnx, rate_waveno,1)
    hold on; %plot(lnx,  myfit(1)*lnx + myfit(2) )
    title('Loged')

    subplot(1,2,2)
    plot(exp(lnx), rate_waveno)
    % hold on; plot( -0.046*log([1:length(rate_waveno)])  + 0.18436 )
    % hold on; plot( -(area_xstar_wave - area_xstarplus_wave)*10*log([1:length(rate_waveno)])  + 0.185 )
    T1 = mean(t(loc_min1(10:end-1) - loc_min1(9:end-2)));
    T2 = mean(t(loc_min2(10:end-1) - loc_min2(9:end-2)));
    dT = T1-T2;
    dArea = area_xstar_wave - area_xstarplus_wave;

    hold on; %plot( mywannafit(1)*log([1:length(rate_waveno)]) +mywannafit(2))
    title('1:1')

     lnx2 = log([1:length(rate_waveno), ones(1,100)]);
    myfit = polyfit(lnx2, [rate_waveno, rate_waveno(1)*ones(1,100)],1)
    
    % D, Area wave x, area x+dx, dt, T x, T x+dx, dT, myfit a, myfit b
    final_save_diffD(dif_D_val, :) = [D, mean(area_xstar_wave(20:end-1)), mean(area_xstarplus_wave(20:end-1)), dt, T1, T2, dT, myfit_care(1), myfit_care(2)];
    rates_diffD(dif_D_val, 1:length(rate_waveno)) = [rate_waveno];
    lnx_difD(dif_D_val, 1:length(rate_waveno)) = lnx;
end
