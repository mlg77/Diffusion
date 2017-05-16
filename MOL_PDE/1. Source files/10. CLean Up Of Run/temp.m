% 1 = arrays.TotalUnder  = [];
% 2 = arrays.FirstHalf = [];
% 3 = arrays.SecondHalf = [];
% 4 = arrays.AreaFrontheavy = [];
% 5 = arrays.TimeFrontheavy = [];
% 6 = arrays.LengthPeriod = [];
% 7 = arrays.Height = [];
% 8 = arrays.unsigned = [];
% 9 = arrays.positive = [];
% 10 = Per Front heavy
% 11 = arrays.PerConcavitydownA  = [];
% 12 = arrays.PerConcavitydownB = [];
% 13 = arrays.area??

figs2keep = [1,2,3]; all_figs = findobj(0, 'type', 'figure'); delete(setdiff(all_figs, figs2keep));
arrays = [];
offsets_pene = [];
Does_pene = []; 
area_dif = [];
EffectGrid = [];
DelDelCon = [];

% figure();
for ii = 1:9

    firstfirstwave = WaveConsidered.Waveone(ii,:);
    firstbackwave = WaveConsidered.backwardsWave(ii,:);
    firsttwave = WaveConsidered.t_wave(ii,:);
    
    endpoint = find(firsttwave==0,1)-1;
    if isempty(endpoint)
        endpoint = length(firsttwave);
    end
    
    firstfirstwave = firstfirstwave(1:endpoint);
    firstbackwave = firstbackwave(1:endpoint);
    firsttwave = firsttwave(1:endpoint);
    
    [themin, idxmin] = min(firstfirstwave);
    firstfirstwave = firstfirstwave-themin;
    firstbackwave = firstbackwave-themin;
    subed = (firstfirstwave- firstbackwave);
    
    % Trapizium rule
    arrays(ii,1)  = dt/2*(firstfirstwave(1) + firstfirstwave(end) + 2*sum(firstfirstwave(2:end-1)));
    
    arrays(ii,2) = dt/2*(firstfirstwave(1) + firstfirstwave(idxmin) + 2*sum(firstfirstwave(2:idxmin-1)));
    
    arrays(ii,3) = dt/2*(firstfirstwave(idxmin) + firstfirstwave(end) + 2*sum(firstfirstwave(idxmin:end-1)));
    
    % Left hand rule
    idxhalf = round(length(firstfirstwave)/2);
    frontheavy = find(firstfirstwave(1:idxhalf) > firstbackwave(1:idxhalf));
    arrays(ii,4) = dt*sum(firstfirstwave(frontheavy));
    arrays(ii,5) = length(frontheavy)*dt;
    
    arrays(ii,6) = firsttwave(end)-firsttwave(1);
    arrays(ii,7) = max(firstfirstwave);
    
    % LHR
    arrays(ii,8) = sum(abs(subed(1:idxhalf)))*dt;
    arrays(ii,9) = dt*sum(abs(subed(frontheavy)));    
    arrays(ii,10) = arrays(ii,9)/arrays(ii,8);
    
    %% Now in dx
    [mymin1, idxmin1] = min(WaveConsidered.Waveone(ii,:));
    myWaveone = WaveConsidered.Waveone(ii,:)- mymin1;
    
    idxend1 = find(myWaveone==-mymin1,1)-1;
    if isempty(idxend1); idxend1 = length(myWaveone); end
    red_zeros = myWaveone(1:idxend1);
    
    figure();
%     subplot(1,2,1)
%     plot(red_zeros, 'r', 'linewidth', 2)
    count = 1;
    offsetby = 0.999:-0.001:0.5;
    for jj = offsetby
        lenblu = round(length(red_zeros)*jj);
        dif_over_period(1, count) = max(red_zeros) - red_zeros(lenblu+1);
        dif_over_period(2, count) = max(red_zeros) - red_zeros(end-lenblu);
        dif_over_period(3, count) = arrays(ii,6)*(1-jj); % Time
%         hold on; plot([red_zeros(lenblu+1:end), red_zeros(1:lenblu)])
        count = count + 1;
    end
     subplot(1,2,1)
    plot(1-[0.999:-0.001:0.5],dif_over_period(1,:)); hold on
    plot(1-[0.999:-0.001:0.5],dif_over_period(2,:));
    axis([0,0.5,0,3.5])
        
    DelDelCon(ii,:) = (dif_over_period(1,:)-dif_over_period(2,:));
    subplot(1,2,2)
    plot(1-[0.999:-0.001:0.5],DelDelCon(ii,:)); grid on
    
    offsets_pene(ii, :) = (DelDelCon(ii,:).*dt*D/(dx^2)> mtol);
%     offsets_pene(ii, :) = (DelDelCon(ii,:)*D> mtol);
    
    Does_pene(ii, 2) = (x(Data_each_round(ii, 3)) - x(Data_each_round(ii,4))) > 1.5*dx;
    Does_pene(ii, 3) = abs(WaveConsidered.t_wavetwo(ii,1)- WaveConsidered.t_wave(ii,1));
    
    EffectGrid(ii,:) = (DelDelCon(ii,:).*dt*D/(dx^2)) /(max(red_zeros));
    Does_pene(ii, 1) = max(EffectGrid(ii,:));
end

figure();
titlesarray = {'Area Total', 'Area First half', 'Area Second half to min', 'Area when Front heavy', 'time Front heavy', 'Period length', 'Amplitude', 'unsigned area', '"positive" area', 'Perfrontheavy'};
for ii = 1:10
    subplot(2,5,ii); 
    plot(arrays(:,ii), 'x-')
    grid on
    title(titlesarray{ii});
    if ismember(ii, [1,2,4])
        hold on;
        b = polyfit([1:length(arrays(:,ii))], arrays(:,ii)', 1);
        fr = polyval(b, factor_front_heavy);
        plot(factor_front_heavy, fr, 'r-')
        hold off
    end
end

predicpene = Does_pene(:,1);
predicpene(find(predicpene<=0)) = 0;
figure(); hold on
area(factor_front_heavy, 100*Does_pene(:,2)*max(Does_pene(:,1)))
plot(factor_front_heavy, 100*(predicpene),'r',  'linewidth', 2)
legend('When It actually Penetrates', 'Predicted Will penetration')
xlabel('\xi')
ylabel('Percentage effect on concentration levels')
grid on

figure(); 
h=surf(100*(1-[0.999:-0.001:0.5]), factor_front_heavy, EffectGrid);
xlabel('Phase Lage as percentage of period')
ylabel('\xi')
zlabel('Percentage effect to cause penetration')
set(h,'edgecolor','none')

EffectGridPos = EffectGrid;
EffectGridPos(find(EffectGridPos<=0)) = 0;
figure(); 
hh = surf(100*(1-[0.999:-0.001:0.5]), factor_front_heavy, EffectGridPos);
xlabel('Phase Lage as percentage of period')
ylabel('\xi')
zlabel('Percentage effect to cause penetration')
set(hh,'edgecolor','none')