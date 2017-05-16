% Test Quantify Penetrate


figs2keep = [2]; all_figs = findobj(0, 'type', 'figure'); delete(setdiff(all_figs, figs2keep));
% for each Xi
for ii = 1:length(factor_front_heavy)
    max_change = max(WavexstarF_xi)- min(WavexstarF_xi);
    
    % Chop out the zero
    xstarplusF_xi = xConsidered(end,:,ii);
    WavexstarF_xi = xConsidered(end-1,:,ii);
    xstarminusF_xi = xConsidered(end-2,:,ii);
    belowBi_xi = xConsidered(1,:,ii);
    
    % Quantify Penetrate 
   [PKSxstar,LOCSxstar]= findpeaks(WavexstarF_xi);
   [PKSxplus,LOCSxplus]= findpeaks(xstarplusF_xi);
   [PKSxminus,LOCSxminus]= findpeaks(xstarminusF_xi);
   
   tol_time = find(t>5,1);
   [PKSxstar,LOCSxstar, PKSxplus,LOCSxplus, PKSxminus,LOCSxminus] = SameLengthPeeks(tol_time,PKSxstar,LOCSxstar, PKSxplus,LOCSxplus, PKSxminus,LOCSxminus);
          
       
    % find the peaks of the current point x*
    delta_above = PKSxstar - WavexstarF_xi(LOCSxminus);
    delta_below = PKSxstar - WavexstarF_xi(LOCSxplus);
        
%     delta_delta = abs(delta_below) - abs(delta_above);
    delta_delta = (delta_below) - (delta_above);
    
    per_effect = ((100*delta_delta*dt*D)/(dx^2))/max_change;

    
    offsetby = 0.999:-0.001:0.8;
    per_effect = [];
    for kk = 1:length(LOCSxstar)-1
        myWaveone = WavexstarF_xi(LOCSxstar(kk):LOCSxstar(kk+1));
        mymin1 = min(myWaveone);
        red_zeros = myWaveone- mymin1;
        % The Wave is named red_zeros
        % Loop through different offsets possible
        count = 1;
        dif_over_period = [];
        DelDelCon = [];
        EffectGrid = [];
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
        DelDelCon(1,:) = (dif_over_period(1,:)-dif_over_period(2,:));
        % Percentage of concentration effect
        EffectGrid(1,:) = 100*(DelDelCon(1,:).*dt*D/(dx^2)) /(max(red_zeros));
        per_effect(end+1) = max(EffectGrid);
        figure(1)
        plot(1-offsetby, EffectGrid)
        pause
    end
    LOCSxstar = LOCSxstar(1:end-1); 
    
    
    figure()
    subplot(3,1,1); hold on; 
    plot(t, WavexstarF_xi)
    plot(t, xstarplusF_xi)
    plot(t, xstarminusF_xi)
    xlabel('time'); ylabel('Concentration')
    legend('x*', 'x*+dx', 'x*-dx')
    
    subplot(3,1,2); hold on; 
    plot( per_effect); grid on;
%     plot(t(LOCSxstar), per_effect); grid on;
    xlabel('time'); ylabel('Percentage effect')
    
%     subplot(3,2,5:6); hold on;
%     area(t(LOCSxstar), max(belowBi_xi)*(sign(per_effect)+1)/2)
%     plot(t, belowBi_xi)
%     plot(t, WavexstarF_xi)
%     legend('What I predict', 'Check', 'x* used')
    
    subplot(3,1,3); hold on;
    h = area(t(LOCSxstar),(sign(per_effect)+1)/2); 
    h1 = area(t(LOCSxstar),(sign(per_effect-0.02)+1)/2);
    h.FaceColor = 'green';
    plotyy(1,1,t, belowBi_xi)
    plotyy(1,1,[0,0], [max(WavexstarF_xi), min(WavexstarF_xi)])
    legend('Less than 0.02% Effect', 'Penetrate Large Effect','Check', 'x* used')
    
    %Did it work
end
    