% Test Stability/ resistance to change of beta value

clear; clc; close all

mtol = 1e-6;
odeoptions = odeset('RelTol',mtol, 'AbsTol', mtol );
perts =  0:0.001:0.3;
betas =  0:0.001:0.5;
betas_coll = betas;

% perts = 0.2;
% betas =  0.2;

max_Z = [];
Time_taken = [];
count = 0;

M = length(betas);
t0 = 0;   t1 = 50; dt = 0.001;
Z_0 = 0.3; V_0 = -40; Y_0 = 0.5;
y0 = [betas*0+Z_0, betas*0+V_0, betas*0+Y_0];
mtol = 1e-6;

tspan = [t0:dt: t1];
Diff_type = 1; D =0;
[t, y0D] = ode45(@(t,y) odefun_Goldbeter(t,y,(betas*0.56)',Diff_type, D), tspan, y0, odeoptions);
Z = y0D(:, 1:M)';
V = y0D(:, M+1:2*M)';
Y = y0D(:, 2*M+1:3*M)';

% Time simulation
tic;


for ii = 1:length(betas)
    
    x = betas(ii);
    mybeta = (x*0.56)';
    
    sim_time_so_far = toc;
    sim_taken = toc/(60);
    sim_expected_full = sim_taken* length(betas)/(ii-1);
    display(['Goldbeter: ', num2str(betas(ii)), ' Time remaining: ', num2str(round(sim_expected_full - sim_taken,1)), ' minutes'])
    
    Z0D = Z(ii, :)';
    V0D = V(ii, :)';
    Y0D = Y(ii, :)';
    
%     figure(); hold on;
%     plot(t, Z0D)

    % Are you at steady state
    test_10 = Z0D(floor(length(t)*0.9):end);
    steadystateerror = max(test_10) - min(test_10);
    if steadystateerror < 0.001*Z_0
        count = count+1;
        betas_coll(count) = betas(ii);
        % We have steady state
        for jj = 1:length(perts)
            tspan = [t1+dt:dt: 75];
            y0 = [Z0D(end)+perts(jj), V0D(end), Y0D(end)];
            [t2, y0D] = ode45(@(t,y) odefun_Goldbeter(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions);
            Z0D2 = y0D(:, 1)';
            V0D2 = y0D(:, 2)';
            Y0D2 = y0D(:, 3)';
%             plot(t2, Z0D2)
%             axis([0,100,0,2])
%             pause();

            % Max reached
            max_Z(ii, jj) = max(Z0D2);
            BaseZ(ii, jj) = Z0D(end);
            % Time taken to reach back to steady state
            within_steadystate = abs(Z0D2 - Z0D(end)) < steadystateerror;
            idx_time = length(within_steadystate)-( find(fliplr(within_steadystate) == 0, 1)-1)+1;
            if isempty(idx_time); idx_time = 1; end
            Time_taken(ii, jj) = t(idx_time);
            
        end
    else
        % Already ocs No need to rerun
        break
    end
end
figure(1)
hold on
for ii = 1:length(betas_coll)
    % which third are you in
    what_betas{ii} = num2str(betas_coll(ii));
    [ r, g, b ] = col_rainbow( ii, length(betas_coll) );
    h(ii) = plot(perts, max_Z(ii,:), 'Color', [r/255,g/255,b/255]);
end
grid on; 
order=length(betas_coll):-1:1;
legend(h(order), what_betas{order})
xlabel('Pertibations'); ylabel('Max \Phi'); title('Max \Phi')

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

% subplot(1,2,2)
% surf(perts, betas_coll, Time_taken)
% xlabel('Pertibations'); ylabel('Betas'); title('Time taken to reach staedy state')
% 
% load handel
% sound(y,Fs)
axis([0,1,-0.05,1.2])
%% Track changes
% start at a pertibation of 1 and x of 0.51
dbeta_dx = betas_coll; % 1:1 just as normal


dx = 1e-3;
D = 6e-6;
rate_co = D/dx^2*0.1;
inital_pert = 0.5458*rate_co;
idx_0_per = find(perts >=inital_pert, 1);
idx_0_beta = length(betas_coll); % find(betas_coll >= 0.50, 1);
to_plot = [];
to_plot(1,1:2) = [perts(idx_0_per), plotted_Z(idx_0_beta, idx_0_per)];
new_pert = (plotted_Z(idx_0_beta, idx_0_per)*rate_co);

for ii = 1:length(dbeta_dx)-1;    
    new_po = dbeta_dx(idx_0_beta - ii);
    idx_per = find(perts >=new_pert, 1);
    idx_beta = find(betas_coll >= new_po, 1);
    to_plot(ii+1,:) = [perts(idx_per), plotted_Z(idx_beta, idx_per)];
    new_pert = plotted_Z(idx_beta, idx_per)*rate_co;
end
plot(to_plot(3:end,1),to_plot(3:end,2), 'xk-')

x_end_wave = to_plot(find(to_plot(:,2)<= 0, 1), 1);
display(['x when wave will stop: ', num2str(x_end_wave)])
display(['With a beta value of: ', num2str(x_end_wave*0.56)])

poisition_x = betas;
cd('C:\Temp\Diffusion\MOL_PDE\4. Output files\Stability')
save('AoP_Gold_2', 'BaseZ', 'max_Z', 'perts', 'poisition_x')