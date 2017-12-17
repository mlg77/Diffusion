% Get Second possible P path 
E_bet = nan(size(tempE));
tol = 0.005*max(tempE);
for ii = 1:length(pathdata.x)
    list1 = (tempE(end+1-ii,:) < pathdata.E(ii) + tol) ;
    list2 = (tempE(end+1-ii,:) > pathdata.E(ii) - tol);
    list3 = (list1 + list2 == 2);
    
    E_bet(ii, :) = list3;
    
    firstidx = find(list3==1, 1);
    secidx = find(list3(firstidx:end)==0, 1)-1+firstidx;
    
    if isempty(tempE(end+1-ii,firstidx:secidx) - pathdata.E(ii))
        pathdata.P2(ii) = nan;
    else
        pathdata.P2(ii) = interp1(tempE(end+1-ii,firstidx:secidx) - pathdata.E(ii),P(firstidx:secidx),0);
    end
    
end
    
    %%
    

load('C:\Temp\Diffusion\MOL_PDE\4. Output files\1. ODE_Bifurcations\1. Dupont\DataBi.mat')

Z_SS = median(Z(:, floor(length(t)*0.75):end)')';
Z_SS_order=[];
for ii = length(mybetanew(1:500)):-1:1
    vq = interp1(mybeta,Z_SS,mybetanew(ii));
    Z_SS_order(ii) = vq;
end
Z_SS_order = fliplr(Z_SS_order);

E_plu_Zss = pathdata.E + Z_SS_order(1:length(pathdata.E))'; 

figure(); hold on;
plot(wave_data.po, wave_data.mag, 'b', 'linewidth', 2)
plot(pathdata.x, E_plu_Zss, 'k', 'linewidth', 2)
legend('Actual Wave Concentration', 'E(\beta, P)+Z_{SS}(\beta)')
set(gca,'XDir','reverse')
ylim([0,2.2])
% 
% figure(); hold on;
% plot(pathdata.x, wave_data.mag(1:length(E_plu_Zss))- E_plu_Zss')
% plot(pathdata.x, pathdata.P)
% plot(pathdata.x, pathdata.P2)

pathdata.P12 = [];
pathdata.P22 = [];
for ii = 1:length(pathdata.E)-2
    vect = tempE(500-ii, :) - pathdata.E(ii);
    idx_12 = find(vect >= 0, 1);
    if isempty(idx_12)
        [throw, idxmax] = max(vect);
        pathdata.P22(ii) = P(idxmax);
        pathdata.P12(ii) = P(idxmax);
    else
        pathdata.P22(ii) = interp1(vect(idx_12-1:idx_12), P(idx_12-1:idx_12), 0);
        idx_21 = find(vect >= 0,1, 'last');
        pathdata.P12(ii) = interp1(vect(idx_21:idx_21+1), P(idx_21-1:idx_21+1), 0);
    end
end
% 
% plot(pathdata.x(1:ii), pathdata.P12)
% plot(pathdata.x(1:ii), pathdata.P22)
% legend('needed', 'P', 'P2', 'P12', 'P22')

% figure(); hold on;
% plot(wave_data.po, wave_data.mag)
% plot(pathdata.x(1:ii), E_plu_Zss(1:ii)-pathdata.P22')
% legend('Actual Wave Concentration', 'E(\beta, P)+Z_{SS}+ P')
% set(gca,'XDir','reverse')
% ylim([0,2.2])

E_bet(find(E_bet == 0)) =  0;
E_bet = flipud(E_bet);
%% Report Figs

figure(99)
imagesc(P,x(1:500), tempE)
set(gca,'YDir','normal')
xlabel('Perturbations, P')
ylabel('Position, x')
colormap jet
myColorMap = summer;
myColorMap(1, :) = [1 1 1];
colormap(myColorMap); colorbar
figure(100)
imagesc(P,x(1:500), E_bet)
set(gca,'YDir','normal')
myColorMap = jet;
myColorMap(:, 1) = 1; myColorMap(:, 2) = 0; myColorMap(:, 3) = 0;
myColorMap(1, :) = [1 1 1];
colormap(myColorMap); colorbar
hold on;
plot(pathdata.P, pathdata.x, 'k', 'linewidth', 2)
plot(pathdata.P, pathdata.x, 'k', 'linewidth', 2)
plot(wave_data.po, wave_data.mag)
plot(pathdata.x, E_plu_Zss+0.05)



