% Test Stability/ resistance to change of beta value

clear; clc; close all

mtol = 1e-6;
odeoptions = odeset('RelTol',mtol, 'AbsTol', mtol );
perts =  [0:0.1:30];
betas =  0:0.001:0.5;

% perts = 0.2;
% betas =  0.2;

max_Z = [];
Time_taken = [];
count = 0;

%% Run steady state first
t0 = 0;   t1 = 30; dt = 0.001;
x = betas;
M = length(x);
Scalor = 0.57;
mybeta = (x*Scalor)';
Z_0 = 0.3; V_0 = -40; N_0 = 0.5;
y0 = [Z_0+ x*0, V_0+ x*0, N_0+ x*0];
mtol = 1e-6;

tspan = [t0:dt: t1];

Diff_type = 1; D =0;
[t, y0D] = ode45(@(t,y) odefun_Erm(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions);
Z0D = y0D(:, 1:M)';
V0D = y0D(:, M+1:2*M)';
Y0D = y0D(:, 2*M+1: 3*M)';



%% Time simulation
tic;

betas_coll = betas;

for jj = 1:length(perts)
    tspan = [t1+dt:dt: 55];
    y0 = [Z0D(:, end), V0D(:, end)+perts(jj), Y0D(:, end)];
    [t2, y0D] = ode45(@(t,y) odefun_Erm(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions);
    Z0D2 = y0D(:, 1:M)';
    V0D2 = y0D(:, M+1:2*M)';
    N0D2 = y0D(:, 2*M+1: 3*M)';
    % Max reached
    max_V(:, jj) = max(V0D2')';
    BaseV(:, jj) = V0D(:, end);
    display([num2str(jj), ' / ', num2str(length(perts))])
end


figure(1)
hold on
plotted_V = [];
for ii = 1:length(betas_coll)
    % which third are you in
    what_betas{ii} = num2str(betas_coll(ii));
    [ r, g, b ] = col_rainbow( ii, length(betas_coll) );
    h(ii) = plot(perts, max_V(ii,:)-BaseV(ii,:)-perts, 'Color', [r/255,g/255,b/255]);
    plotted_V(ii, :) = max_V(ii,:)-BaseV(ii,:)-perts;
end
grid on; 
order=length(betas_coll):-1:1;
% legend(h(order), what_betas{order})
xlabel('Pertibations'); ylabel('Max \Phi'); title('Max \Phi')



cd('C:\Temp\Diffusion\MOL_PDE\4. Output files\Stability\Etrout')
save('sen_perts_data')
cd('C:\Temp\Diffusion\MOL_PDE\1. Source files\11. Stability\Etrout')