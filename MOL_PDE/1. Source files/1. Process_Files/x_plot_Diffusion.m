figure(6)
subplot(1,2,1)
imagesc(t,flipud(x),Z)
        set(gca,'YDir','normal')
        xlabel('Time, [s]')
        ylabel('Position, x')
        title(['Z, Calcium Concentration in the Cytosol ',num2str(D),' diffusion, [\muM]'])
        colormap jet
        hold on
        plot([0,t_end], [top_pt, top_pt], 'k','LineWidth',2)
        plot([0,t_end], [bt_pt, bt_pt],  'k','LineWidth',2)
        h = plot([0,0], [0,1]);
        count = 0;
%         
% subplot(1,3,2)
% hold on
% plot([top_pt, top_pt], [-12, 8], 'k','LineWidth',2)
% plot([bt_pt, bt_pt], [-12, 8], 'k','LineWidth',2)
% h1 = plot([1]);
%         
% subplot(1,3,3)
% hold on
% plot([top_pt, top_pt], [0, 1.5], 'k','LineWidth',2)
% plot([bt_pt, bt_pt], [0, 1.5], 'k','LineWidth',2)
% h2 = plot([1]);

subplot(2,2,2)
hold on
plot([top_pt, top_pt], [-20, 10], 'k','LineWidth',2)
plot([bt_pt, bt_pt], [-20, 10], 'k','LineWidth',2)
h2 = plot([1], [1]);
axis([0, 1, -20, 10])

subplot(2,2,4)
hold on
plot([top_pt, top_pt], [0, 1.5], 'k','LineWidth',2)
plot([bt_pt, bt_pt], [0, 1.5], 'k','LineWidth',2)
h3 = plot([1], [1]);
axis([0, 1, 0, 1.5])

pause()
%%%% Gifter
        set(gcf, 'Color' ,'w'); % Gif
        f = getframe(figure(6)); % Gif
        [im,map] = rgb2ind(f.cdata,256,'nodither');  % Gif



for i = find(t>5.5, 1):5: find(t>15, 1)%1:50:length(t)
% for i=(length(x)-1)/2:-2:60
    subplot(1,2,1)
    delete(h)
%     h = plot([0,t(end)], [x(i),x(i)], 'r', 'LineWidth', 2);
    h = plot([t(i), t(i)], [x(1),x(end)], 'r', 'LineWidth', 2);

%     subplot(1,3,2)
%     delete(h1)
%     h1 = plot(x, d2Zdx2(:,i));
%     axis([0, 1, -12, 8])
%     xlabel('Position, x')
%     title(['Time, t = ', num2str(t(i))])
%     ylabel('Diffusion Concentration rate')
% 
%     subplot(1,3,3)
%     delete(h2)
%     h2 = plot(x, Z(:,i));
%     xlabel('')

    subplot(2,2,2)
    delete(h2)
    h2 = plot(x, d2Zdx2(:,i), 'b');
    title(['Time, t = ', num2str(t(i))])
    subplot(2,2,4)
    delete(h3)
    h3 = plot(x, Z(:,i) , 'b');
    
    
    
    count = count+1;
    set(gcf, 'Color' ,'w'); % Gif
    f = getframe(figure(6)); % Gif
    im(:,:,1,count) = rgb2ind(f.cdata,map,'nodither'); % Gif
% pause(0.01)
end

cd([AllDir.ParentDir ,AllDir.SaveDir])
imwrite(im,map,'Changet.gif','DelayTime',0.08);
cd([AllDir.ParentDir, AllDir.SourceDir])
