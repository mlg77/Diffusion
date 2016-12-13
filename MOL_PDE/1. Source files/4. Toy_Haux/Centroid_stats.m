% Is angular velocity constant

figure(2)
clf
hold on
grid on
title('Limit cycles of respective beta values (Zero Diffusion)')
xlabel('\Psi')
ylabel('\Phi')
% axis([-1.5,1.5,-1.5,1.5])
% Cycle through different betas
for ii = 1+(length(x)-1)*6/10 :(length(x)-1)/20: length(x)
    plot(V0D(ii,1500:end), Z0D(ii,1500:end), 'b')
    % add label
    h = text(V0D(ii,end), Z0D(ii,end),num2str(mybeta(ii)));
    set(h, 'FontSize', 15);  set(h, 'HorizontalAlignment', 'center'); 
    
%     % Continious angular velocity ... it is perfectly symetrical???
%     Change_in_time = t(1501:end)- t(1500:end-1);
%     theata1 = atan(V0D(ii,1500:end-1)./Z0D(ii,1500:end-1))';
%     theata2 = atan(V0D(ii,1501:end)./Z0D(ii,1501:end))';
%     ang_vel = (theata2 - theata1)./Change_in_time;
%     ang_vel(find(ang_vel < -300)) = 0.2;
      
    % Find theata corosponding to max distance from centroid 
    x_c = (max(V0D(ii,1500:end)) + min(V0D(ii,1500:end)))/2; % centroid
    y_c = (max(Z0D(ii,1500:end)) + min(Z0D(ii,1500:end)))/2; % centroid
    Z0D_pos = Z0D(ii,1500:end);
    Z0D_pos(find(sign(Z0D_pos)==-1)) = 0; % Only do positive half
    distance_c = sqrt((x_c - V0D(ii,1500:end)).^2 + (y_c - Z0D_pos).^2);
    [maxd, loc_maxd] = max(distance_c);
    loc_maxd = loc_maxd + 1500;
    plot([ x_c], [ y_c], 'rx')
    plot([ V0D(ii,loc_maxd)], [ Z0D(ii,loc_maxd)], 'rx')
    
    pause(1)
    
end

