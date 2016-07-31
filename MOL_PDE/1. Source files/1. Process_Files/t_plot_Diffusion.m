%% Plot Diffusion changing position Gif
% cd([AllDir.ParentDir ,AllDir.SaveDir])
figure(6)
subplot(1,2,1)
imagesc(t,flipud(x),Z)
        set(gca,'YDir','normal')
        xlabel('Time, [s]')
        ylabel('Position, x')
        title(['Z, Calcium Concentration in the Cytosol ',num2str(D),' diffusion, [\muM]'])
        colormap jet
        hold on
%         plot([0,t_end], [top_pt, top_pt], 'k','LineWidth',2)
%         plot([0,t_end], [bt_pt, bt_pt],  'k','LineWidth',2)
        h = plot([0,t(end)], [0,0]);
%         set(gcf, 'Color' ,'w'); % Gif
%         f = getframe(figure(6)); % Gif
%         [im,map] = rgb2ind(f.cdata,256,'nodither');  % Gif
        count = 0;
pause()
for i=(length(x)-1)/2:-2:60
    subplot(1,2,1)
    delete(h)
    h = plot([0,t(end)], [x(i),x(i)], 'r', 'LineWidth', 2);
    
    subplot(1,2,2)
    hold off
    plot(t, d2Zdx2(i,:))
%     axis([0, 30, -12, 8])
    xlabel('Time')
    title(['Position x = ', num2str(x(i))])
    ylabel('Diffusion Concentration rate')
    
    count = count+1;
%     set(gcf, 'Color' ,'w'); % Gif
%     f = getframe(figure(6)); % Gif
%     im(:,:,1,count) = rgb2ind(f.cdata,map,'nodither'); % Gif
pause(0.2)
end

% imwrite(im,map,'changex_short.gif','DelayTime',0.08); % Save Gif file
% 