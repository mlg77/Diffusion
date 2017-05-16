%% Plot the Drop off

clc; close all
cd('C:\Temp\Diffusion\MOL_PDE\4. Output files\Stability\Dupont')
load('sen_perts_data.mat')
cd('C:\Temp\Diffusion\MOL_PDE\1. Source files\11. Stability\Dupont')
Scalor = 0.78;

figure(2)
hold on

%% Start off By converting the saved data to use.

plotted_Z = [];
for ii = 1:length(betas_coll)
    % which third are you in
    what_betas{ii} = num2str(betas_coll(ii));
%     [ r, g, b ] = col_rainbow( ii, length(betas_coll) );
%     h(ii) = plot(perts, max_Z(ii,:)-BaseZ(ii,:)-perts, 'Color', [r/255,g/255,b/255]);
    plotted_Z(ii, :) = max_Z(ii,:)-BaseZ(ii,:)-perts;
end

betas_coll = betas_coll*Scalor;
% x is 200 y is 500
% imagesc(perts, betas_coll, plotted_Z)
plottedZ_0 = plotted_Z;
plottedZ_0(find(plotted_Z <= 1e-10)) = 0;


%% Create the special Beta profile
x = 0:1e-3:0.5;


% newb = 47.619*x.^3 -39.52*x.^2 +8.8571*x;
newb = 38.095*x.^3 -32.38*x.^2 +7.6667*x;
newb(find(newb>=0.5)) = nan; % Set osc region to nan
newb = [newb(1:500) , x(501:end)];
new_beta = (newb*Scalor)';
dBetadxTypes = new_beta(:);
% Times nan
timestostart = 3;
    
lastpertcare = find(perts >=0.3, 1);
myColorMap = summer; % Make a copy of jet.

%% Plot the beta profile
subplot(1,3,1)
plot(linspace(0,0.5, length(dBetadxTypes)),dBetadxTypes,'k', 'linewidth', 2)
xlabel('Position, x, [cm]'); ylabel('Beta, (\beta)')
axis([0,0.5,0,0.3])
grid on


%% Plot the first wave with different diffusion values
subplot(1,3,2)
for jj = 1:timestostart
    if jj == 1
        NewBetastuff = dBetadxTypes;
        startnan = 0.5;
    elseif jj == 2
        % do second down part
        NewBetastuff = dBetadxTypes(1:find(isnan(dBetadxTypes),1)-1);
        startnan = x(find(isnan(dBetadxTypes),1)-1);
    elseif jj == 3
        NewBetastuff = flipud(dBetadxTypes(find(isnan(dBetadxTypes),1, 'last')+1:end));
        startnan = x(find(isnan(dBetadxTypes),1, 'last')-1);
    end
    
    for kk = 1:length(NewBetastuff)
        if isnan(NewBetastuff(kk) )
            reorderedZ(kk,:) = plottedZ_0(1, :)*nan;
        else
            reorderedZ(kk,:) = plottedZ_0(find(NewBetastuff(kk)<=betas_coll,1), :);
        end
    end
    
    if jj == 1
        [C,h1] = contourf(perts(1:lastpertcare), x, reorderedZ(:, 1:lastpertcare), 20); hold on;
        [C,h2] = contour(perts(1:lastpertcare), x, reorderedZ(:, 1:lastpertcare), 20);
        axis([0,0.3,0,0.5])
    end
    
    

    possible_D = [2, 4, 6, 8]*1e-6;
    code_leg = {'k', 'b', 'r:', 'm'};
    for ii = 1:length(possible_D)

        const = [-0.0305,0.0068,0.0858,0.033];
        wavefrontnumber = 1;
        a = (const(1)*log(possible_D(ii)/dx^2) + const(2));
        b = (const(3)*log(possible_D(ii)/dx^2) + const(4));
        Rate =  a*log(wavefrontnumber) + b;
        [ Perts_dbdx, Plot_dbetadx, plotxer ] = ItterationDownBeta( perts, betas_coll, plotted_Z, NewBetastuff,x, Rate, 0.2 );

        hold on;
        if jj == 3
            plot(Perts_dbdx(3:end), startnan - (plotxer(3:end)-0.5), code_leg{ii}, 'linewidth', 2); 
        else
            plot(Perts_dbdx(3:end), plotxer(3:end)-0.5+startnan, code_leg{ii}, 'linewidth', 2);
        end
    end

    %% Plotting format
    
    xlabel('Pertibations'); ylabel('Position, x [cm]');
    % Assign white (all 1's) to black (the first row in myColorMap).

    colorbar
    set(gca,'YDir','normal')
    set(gca,'layer','top');
    grid on
    hasbehavior(h1, 'legend', false); 
    hasbehavior(h2, 'legend', false); 
end

subplot(1,3,3)

for jj = 1:timestostart
  
    if jj == 1
        NewBetastuff = dBetadxTypes;
        startnan = 0.5;
    elseif jj == 2
        % do second down part
        NewBetastuff = dBetadxTypes(1:find(isnan(dBetadxTypes),1)-1);
        startnan = x(find(isnan(dBetadxTypes),1)-1);
    elseif jj == 3
        NewBetastuff = flipud(dBetadxTypes(find(isnan(dBetadxTypes),1, 'last')+1:end));
        startnan = x(find(isnan(dBetadxTypes),1, 'last')-1);
    end
    
    for kk = 1:length(NewBetastuff)
        if isnan(NewBetastuff(kk) )
            reorderedZ(kk,:) = plottedZ_0(1, :)*nan;
        else
            reorderedZ(kk,:) = plottedZ_0(find(NewBetastuff(kk)<=betas_coll,1), :);
        end
    end
    
    if jj == 1
        
        [C,h1] = contourf(perts(1:lastpertcare), x, reorderedZ(:, 1:lastpertcare), 20); hold on;
        [C,h2] = contour(perts(1:lastpertcare), x, reorderedZ(:, 1:lastpertcare), 20);
    end

    possible_wavenumber = [1:4];
    possible_D = 6e-6;
    code_leg = {'k:', 'b', 'r', 'm'};
    for ii = 1:length(possible_wavenumber)

        const = [-0.0305,0.0068,0.0858,0.033];
        wavefrontnumber = possible_wavenumber(ii);
        a = (const(1)*log(possible_D/dx^2) + const(2));
        b = (const(3)*log(possible_D/dx^2) + const(4));
        Rate =  a*log(wavefrontnumber) + b;
        [ Perts_dbdx, Plot_dbetadx, plotxer ] = ItterationDownBeta( perts, betas_coll, plotted_Z, NewBetastuff, x, Rate, 0.2 );

        hold on;
         if jj == 3
            plot(Perts_dbdx(3:end), startnan - (plotxer(3:end)-0.5), code_leg{ii}, 'linewidth', 2); 
        else
            plot(Perts_dbdx(3:end), plotxer(3:end)-0.5+startnan, code_leg{ii}, 'linewidth', 2);
        end
    end

    %% Plotting format
    axis([0,0.3,0, 0.5])
    xlabel('Pertibations'); ylabel('Position, x [cm]'); 
    
    % Assign white (all 1's) to black (the first row in myColorMap).
    colorbar
    set(gca,'YDir','normal')
    set(gca,'layer','top');
    grid on
    hasbehavior(h1, 'legend', false); 
    hasbehavior(h2, 'legend', false); 
end

subplot(1,3,1); title('Beta to Position Profile')
subplot(1,3,2); title('Contour Plot of AoP grid of (P, x); Wave Front = 1')
subplot(1,3,3); title('Contour Plot of AoP grid of (P, x); D = 6\times 10^{-6}')
subplot(1,3,2); legend({'D = 2\times10^{-6}', 'D = 4\times10^{-6}', 'D = 6\times10^{-6}', 'D = 8\times10^{-6}'}, 'Orientation','horizontal')
subplot(1,3,3); legend({'Wave Front 1', 'Wave Front 2', 'Wave Front 3', 'Wave Front 4'}, 'Orientation','horizontal')

