% Test Quantify Penetrate



% for each Xi
for ii = 1:length(factor_front_heavy)
    % Chop out the zero
    t_xi = xConsidered.thet(ii, :);
    idxend1 = find(t_xi==0,1)-1;
    if idxend1 == 0; 
        idxend1 = find(t_xi(2:end)==0,1)+1-1;
    end
    if isempty(idxend1); idxend1 = length(t_xi); end
    
    % Tims, x*, x*+dx , x*-dx
    t_xi = t_xi(1:idxend1);
    WavexstarF_xi = xConsidered.WavexstarF(ii, 1:idxend1);
    xstarplusF_xi = xConsidered.xstarplusF(ii, 1:idxend1);
    xstarminusF_xi = xConsidered.xstarminusF(ii, 1:idxend1);
    
    % Below Bifurcation point to check
    belowBi_xi = xConsidered.belowBi(ii, 1:idxend1);
    
    % find the peaks of the current point x*
    [pks,locs] = findpeaks(WavexstarF_xi);
    delta_above = pks - (xstarplusF_xi(locs));
    delta_below = pks - (xstarminusF_xi(locs));
    
    delta_delta = delta_below - delta_above;
    
    per_effect = ((100*delta_delta*dt*D)/(dx^2))/max(WavexstarF_xi);
    
    figure()
    subplot(3,2,1:2); hold on; 
    plot(t_xi, WavexstarF_xi)
    plot(t_xi, xstarplusF_xi)
    plot(t_xi, xstarminusF_xi)
    xlabel('time'); ylabel('Concentration')
    legend('x*', 'x*+dx', 'x*-dx')
    
    subplot(3,2,3); hold on; 
    plot(delta_above)
    plot(delta_below)
    xlabel('peak number'); ylabel('Change in concentration')
     
    subplot(3,2,4); 
    plot(per_effect); grid on;
    xlabel('Peak Number'); ylabel('Percentage effect')
    
    subplot(3,2,5:6); hold on;
    area(t_xi(locs), max(belowBi_xi)*(sign(per_effect)+1)/2)
    plot(t_xi, belowBi_xi)
    plot(t_xi, WavexstarF_xi)
    legend('What I predict', 'Check', 'x* used')
    %Did it work
end
    