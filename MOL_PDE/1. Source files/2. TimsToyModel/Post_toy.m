% Post calcs to toy model showing protrusions and stopping
% Use 0.5 is cut off

figure(3)
subplot(1,2,1)
imagesc(t,flipud(x),Z)
    set(gca,'YDir','normal')
    xlabel('Time, [s]')
    ylabel('Position, x')
    title(['Z, Calcium Concentration in the Cytosol ',num2str(D),' diffusion, [\muM]'])
    colormap jet
    hold on
    h = plot([0,t(end)], [0,0]);
pause()
for i = 401:-2:401
    subplot(1,2,1)
    delete(h)
    h = plot([0,t(end)], [x(i),x(i)], 'r', 'LineWidth', 2);
    
    t_iti = length(t); %find(t>45,1);
    subplot(3,2,2); hold off
    plot(t(1:t_iti), Z(i,1:t_iti)); hold on
    plot(t(1:t_iti), Z(i+1,1:t_iti), 'r')
    plot(t(1:t_iti), Z(i-1,1:t_iti), 'g')
    legend(num2str(x(i)), num2str(x(i+1)), num2str(x(i-1)))


    % Change in Concentration
    subplot(3,2,4); hold off
    CZ_dxup =  Z(i+1,1:t_iti) - Z(i,1:t_iti); 
    CZ_dxdown = Z(i-1,1:t_iti) - Z(i,1:t_iti);
    plot(t(1:t_iti), CZ_dxup, 'r'); hold on
    plot(t(1:t_iti), CZ_dxdown, 'g')

    
    subplot(3,2,6); hold off
    plot(t(1:t_iti), abs(CZ_dxup-CZ_dxdown), 'b')
    
    pause(0.2)
end