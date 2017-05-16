% Run Goldeter
% Opens sa

cd('C:\Temp\Diffusion\MOL_PDE\4. Output files\Stability\Goldbeter')
load('DepthResults.mat')
cd('C:\Temp\Diffusion\MOL_PDE\1. Source files\11. Stability\Goldbeter')


%% Inital Conditions
t0 = 0;   t1 = 50; dt = 0.01;
dx = 1e-3;  
x = 0:dx:1;    
Z_0 = 0.5; V_0 = -40; Y_0 = 0.5;
y0 = [x*0+Z_0, x*0+V_0, x*0+Y_0];
Diff_type = 1; D =0;% 6e-6;%  0;%
M = length(x); 
mtol = 1e-6;
odeoptions = odeset('RelTol',mtol, 'AbsTol', mtol );
tspan = [t0:dt: t1];

%% Cycle stuff
x = 0:dx:1;
dBetadxTypes(:, 1) = x*0.56;
    new_beta = 23.8*x.^3 -18.33*x.^2 +4.21*x;
    new_beta(501:end) = x(501:end);
    new_beta = new_beta*0.56;
dBetadxTypes(:, 2) = new_beta(:);
    new_beta = 3/5*x + 0.2;
    new_beta = (new_beta*0.56)';
dBetadxTypes(:, 3) = new_beta(:);
    new_beta = (x*0.56)';
    new_beta(451:455) = 0;
dBetadxTypes(:, 4) = new_beta(:);

possible_D = [2,4,6,8]*1e-6;
possible_D = [6]*1e-6;
count = 0;
%% Run Program
for ii = 3% 1:4 
	mybeta = dBetadxTypes(:,ii);
    for kk = 1:length(possible_D)
        display(['Goldbeter', num2str(ii), '.', num2str(kk)])
        Goldbeter.On = 1;
        Diff_type = 1; D =possible_D(kk);
        [t, yFD] = ode45(@(t,y) odefun_Goldbeter(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions);
        ZFD = yFD(:, 1:M)';
        figure(); imagesc(t, x, ZFD)
        for jj = 1:9
            [ wave_data ] = Follow_wave( ZFD, x, t, 0.54, jj, [3, 1] );

            count = count + 1;
            DepthResults(count, 5) = wave_data.po(end);
            DepthResults(count, 6) = abs(DepthResults(count, 5) - DepthResults(count, 4))*100;
            hold on;
            plot(wave_data.t, wave_data.po, 'k', 'linewidth', 2)
        end
        % need to check at this point
%         DepthResults(count-9:count, 4:6)
    end
end
