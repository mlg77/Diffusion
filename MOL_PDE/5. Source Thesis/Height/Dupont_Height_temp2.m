close all;
load('C:\Temp\Diffusion\MOL_PDE\4. Output files\1. ODE_Bifurcations\1. Dupont\DataBi.mat')

Z_SS = median(Z(:, floor(length(t)*0.75):end)')';
Z_SS_order=[];
for ii = length(mybetanew(1:500)):-1:1
    vq = interp1(mybeta,Z_SS,mybetanew(ii));
    Z_SS_order(ii) = vq;
end
% Z_SS_order = fliplr(Z_SS_order);
lastpertcare = 501;

% Loop through actual data and find aop value
Grid_available_aop = [];
vect_aop_point = [];
eddit_f = 0.212; % 4e-6
for ii = 3 :length(wave_data.po)
    % Step 1: Find Aop of actual point
    idx_P = find(tempE(end+1-ii, :)+P+ Z_SS_order(end+1-ii)>=wave_data.mag(ii) + eddit_f, 1);
    Aop_point = tempE(end+1-ii, idx_P);
    % Find when that aop range apperar on the aop grid
    pm_n = 0.005;
    vect_1 = tempE(end+1-ii, :) <= (1 + pm_n) * Aop_point;
    vect_2 = tempE(end+1-ii, :) >= (1 - pm_n) * Aop_point;
    
    vect_aop_point(ii) = Aop_point+P(idx_P)+ Z_SS_order(end+1-ii)-eddit_f;
    
    actual_range = floor((vect_1 + vect_2)*0.5);
    mid_aop_P(ii) = P(idx_P);
    Grid_available_aop(ii, :) = actual_range;
end

Grid_available_aop(find(isnan(Grid_available_aop))) = 0;
% figure(); imagesc(perts,wave_data.po, Grid_available_aop)

figure(99)
myColorMap = summer; 
myColorMap(1, :) = [1 1 1];
myColorMap(end, :) = [1 0 0];

Grid_to_Plot = tempE(:, 1:lastpertcare);
highest_no = max(max(Grid_to_Plot)) + 0.1;
Grid_to_Plot(end:-1:end+1-size(Grid_available_aop, 1), :) = Grid_to_Plot(end:-1:end+1-size(Grid_available_aop, 1), :) + highest_no*Grid_available_aop;
Grid_to_Plot(find(Grid_to_Plot>= highest_no)) = highest_no;
Grid_to_Plot(end-1:end, :) = highest_no;

[C,h1] = contourf(P(1:lastpertcare), x(1:500), Grid_to_Plot,20); hold on;
[C,h2] = contour(P(1:lastpertcare), x(1:500), Grid_to_Plot, 20);
axis([0,0.5,0,0.5])
xlabel('Pertibations'); ylabel('Position, x [cm]');
colormap(myColorMap); colorbar
set(gca,'YDir','normal'); set(gca,'layer','top');
grid on
hasbehavior(h1, 'legend', false); hasbehavior(h2, 'legend', false); 
hold on; plot([pathdata.P;0], [pathdata.x; pathdata.x(end)], 'k', 'linewidth', 2)
plot([mid_aop_P, 0], [wave_data.po, wave_data.po(end)], 'k:', 'linewidth', 2)
legend('Predicted Trijectory', 'Actual Concentration translated to E')

%% Can I get a height graph
Z_SS_orderflip = [fliplr(Z_SS_order)]';
figure(); hold on;
plot(wave_data.po,  wave_data.mag, 'linewidth', 2)
plot([pathdata.x],pathdata.P+pathdata.E+Z_SS_orderflip(1:length(pathdata.P))-eddit_f, 'linewidth', 2)
set(gca,'XDir','reverse')
ylim([0,2.2])
grid on;
legend('Actual Concentration from PDE', 'Predicted Concentration (E+P^*+Z_{SS})')
xlabel('Position, x'); ylabel('Concentration, Z')

return


