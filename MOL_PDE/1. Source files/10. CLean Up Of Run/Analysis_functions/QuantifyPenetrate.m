% Quantify when a wave will and will not penetrate for what phase lag
%       Need to have run file Change_front_heavy first
% Author: Michelle Goodman
% Date: 1/2/2017

% Close extra Figurers
% figs2keep = [1,2,3]; 
% all_figs = findobj(0, 'type', 'figure'); 
% delete(setdiff(all_figs, figs2keep));

% Per allocation
offsetby = 0.999:-0.001:0.75;
dif_over_period = zeros(2, length(offsetby));
DelDelCon = zeros(size(Data_each_round,1), length(offsetby));
Does_pene = zeros(size(Data_each_round,1), 2);
EffectGrid = zeros(size(Data_each_round,1), length(offsetby));

for ii = 1:size(Data_each_round,1)
    % Collect the Wave that is needed and zero it
    [mymin1, idxmin1] = min(WaveConsidered.Waveone(ii,:));
    myWaveone = WaveConsidered.Waveone(ii,:)- mymin1;
    % Remove any zeros at the end
    idxend1 = find(myWaveone==-mymin1,1)-1;
    if isempty(idxend1); idxend1 = length(myWaveone); end
    red_zeros = myWaveone(1:idxend1);
    t_red = WaveConsidered.t_wave(ii,1:idxend1);
    
    % The Wave is named red_zeros
    % Loop through different offsets possible
    count = 1;
    for jj = offsetby
        % Find the index of the movement
        lenblu = floor(length(red_zeros)*jj);
        % Save the Change to behind (Down stream)
        dif_over_period(1, count) = max(red_zeros) - red_zeros(lenblu+1);
        % Save the Change to infront (Upstream)
        dif_over_period(2, count) = max(red_zeros) - red_zeros(end-lenblu);
        count = count + 1;
    end
    % Change in the change
    DelDelCon(ii,:) = (dif_over_period(1,:)-dif_over_period(2,:));
    
    % Percentage of concentration effect
    EffectGrid(ii,:) = 100*(DelDelCon(ii,:).*dt*D/(dx^2)) /(max(red_zeros));
        
    % Does it actuall penetrate?
    Does_pene(ii, 1) = (x(Data_each_round(ii, 3)) - x(Data_each_round(ii,4))) > 1.5*dx;
    % Is it predicted to penetrate? if negative make zero
    if max(EffectGrid(ii,:))<0
        Does_pene(ii, 2) = 0;
    else 
        Does_pene(ii, 2) = max(EffectGrid(ii,:));
    end
end

% Plot the line and shadow
figure(4); hold on
area(factor_front_heavy, Does_pene(:, 1)*max(Does_pene(:, 2)))
plot(factor_front_heavy, Does_pene(:, 2),'r',  'linewidth', 2)
legend('When It actually Penetrates', 'Predicted Will penetration')
xlabel('\xi')
ylabel('Percentage effect on concentration levels')
grid on

% Plot the grid as is
figure(5); 
h=surf((1-offsetby)*100, factor_front_heavy, EffectGrid);
xlabel('Phase Lage as percentage of period')
ylabel('\xi')
zlabel('Percentage effect to cause penetration')
set(h,'edgecolor','none')

EffectGridPos = EffectGrid;
EffectGridPos(find(EffectGridPos<=0)) = 0;
figure(6); 
hh = surf((1-offsetby)*100, factor_front_heavy, EffectGridPos);
xlabel('Phase Lage as percentage of period')
ylabel('\xi')
zlabel('Percentage effect to cause penetration')
set(hh,'edgecolor','none')
    

% Plot the line and shadow
figure(7); hold on
change_point = find(Does_pene(:, 1)==1,1);
area(factor_front_heavy(change_point:end), Does_pene(change_point:end, 1)*max(Does_pene(:, 2)))
area(factor_front_heavy(change_point-1:change_point), [1,1]*max(Does_pene(:, 2)), 'FaceColor',[1 1 0],'EdgeColor','k')
area(factor_front_heavy(1:change_point-1),(Does_pene(1:change_point-1, 1)+1)*max(Does_pene(:, 2)),'FaceColor',[0.7 0.7 0.7],'EdgeColor','k')
plot(factor_front_heavy, Does_pene(:, 2),'rx',  'linewidth', 2)
legend('When It Penetrates','Unknown Penetration due to steps', 'Doesnt Penetrate', 'Predicted Will penetration')
xlabel('\xi')
ylabel('Percentage effect on concentration levels')
grid on
axis([factor_front_heavy(1), factor_front_heavy(end), 0, max(Does_pene(:, 2))])

plot(factor_front_heavy(change_point:end), Does_pene(change_point:end, 2),'r')

% Plot the line and shadow
figure(8); hold on
change_point = find(Does_pene(:, 1)==1,1);
area(factor_front_heavy(change_point:end), Does_pene(change_point:end, 1)*max(Does_pene(:, 2)))
area(factor_front_heavy(change_point-1:change_point), [1,1]*max(Does_pene(:, 2)), 'FaceColor',[1 1 0],'EdgeColor','k')
area(factor_front_heavy(1:change_point-1),(Does_pene(1:change_point-1, 1)+1)*max(Does_pene(:, 2)),'FaceColor',[0.7 0.7 0.7],'EdgeColor','k')
[AX, H1, H2]= plotyy(factor_front_heavy, Does_pene(:, 2),factor_front_heavy, Data_each_round(:, 7));

legend('When It Penetrates','Unknown Penetration due to steps', 'Doesnt Penetrate', 'Predicted Will penetration', 'Depth Of Penetration')
xlabel('\xi')
ylabel('Percentage effect on concentration levels')
grid on
axis([factor_front_heavy(1), factor_front_heavy(end), 0, max(Does_pene(:, 2))])
set(AX(2), 'YLim', [0 0.3])
ylabel(AX(2), 'Depth of Penetration')

H1.LineStyle = 'none'; H1.Marker = 'x'; H1.LineWidth = 2;
H2.LineStyle = 'none'; H2.Marker = 'x'; H2.LineWidth = 2;
plot(factor_front_heavy(change_point:end), Does_pene(change_point:end, 2),'b')

    