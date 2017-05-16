%% Given Data file of sensitive pertibations

clc; close all

cd('C:\Temp\Diffusion\MOL_PDE\4. Output files\Stability\Dupont')
load('sen_perts_data.mat')
cd('C:\Temp\Diffusion\MOL_PDE\1. Source files\11. Stability\Dupont')


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
xlabel('Pertibations'); ylabel('Max \Phi'); title('Max \Phi')


    
%% Given: % This section is an example
%   plotted_Z which is a matrix of each row relates to a beta value and each
%       colum relates to a pertibation such that size(plotted_Z) = (M,  N)
%   betas_coll which is the betas length(betas_coll) = M
%   perts which is the pertibations applied length(perts) = N
% Find:
%   
runexample = 1;
if runexample

    x = betas_coll;
    new_beta = betas_coll;

    myfreq = 1;

    % Do the first one 
    dx = 1e-3;
    D = 6e-6;

    const = [-0.030540521298861, 0.006814633347649,0.085830263965313, 0.032976935489650];
    wavefrontnumber = 8;
    a = (const(1)*log(D/dx^2) + const(2));
    b = (const(3)*log(D/dx^2) + const(4));
    Rate =  a*log(wavefrontnumber) + b;
    Rate = 0.106;
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
    grid on
end
