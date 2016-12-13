function [  ] = RunInTimePlot( Z0D,ZFD, t,x, name_file, Bol_save, Bif_pt, t_inQ, x_inQ, speed_per)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
axis_x = [0, 2];
idx_start = find(t>t_inQ(1),1);
idx_end = find(t>t_inQ(2),1);
buf_region = round((idx_end- idx_start)*0.02);
idx_inQ = idx_start-buf_region:idx_end+ buf_region;


idx_startx = find(x>x_inQ(1),1);
idx_endx = find(x>x_inQ(2),1);
idx_inQx = idx_startx:idx_endx;

figure(6)
subplot(2,2,1)
imagesc(t(idx_inQ),flipud(x(idx_inQx)),Z0D(idx_inQx, idx_inQ))
        set(gca,'YDir','normal')
        xlabel('Time, [s]')
        ylabel('Position, x')
        title(['Zero Diffusion ']) 
        colormap jet
        colorbar
        hold on
        plot([0,t(end)], [Bif_pt, Bif_pt], 'k','LineWidth',2)
        h = plot([t_inQ(1),t_inQ(1)], [0,1]);
        

subplot(2,2,3)
imagesc(t(idx_inQ),flipud(x(idx_inQx)),ZFD(idx_inQx, idx_inQ))
        set(gca,'YDir','normal')
        xlabel('Time, [s]')
        ylabel('Position, x')
        title(['Fickian Diffusion ']) 
        colormap jet
        colorbar
        hold on
        plot([0,t(end)], [Bif_pt, Bif_pt], 'k','LineWidth',2)
        h1 = plot([t_inQ(1),t_inQ(1)], [t_inQ(1),1]);
        count = 0;
        
% Plot The 0 Diffusion Case over time        
subplot(2,2,2)
hold on
plot([Bif_pt, Bif_pt], axis_x, 'k','LineWidth',2)
h2 = plot([1], [1]);
axis([x_inQ, axis_x])
xlabel('Position')
ylabel('Magnitude \Phi')

% Plot The Fickian Diffusion Case over time  
subplot(2,2,4)
hold on
plot([Bif_pt, Bif_pt], axis_x, 'k','LineWidth',2)
h3 = plot([1], [1]);
axis([x_inQ, axis_x])
xlabel('Position')
ylabel('Magnitude \Phi')

disp('Press enter when ready to start')
pause()

%%%% Gifter
if Bol_save
    set(gcf, 'Color' ,'w'); % Gif
    f = getframe(figure(6)); % Gif
    [im,map] = rgb2ind(f.cdata,256,'nodither');  % Gif
end

speed_step = round(speed_per*(find(t>t_inQ(2), 1)-(find(t>t_inQ(1)))));

for i = find(t>t_inQ(1), 1):speed_step: find(t>t_inQ(2), 1)%1:50:length(t)

    subplot(2,2,1)
    delete(h)
    h = plot([t(i), t(i)], [x_inQ], 'r', 'LineWidth', 2);
    
    subplot(2,2,3)
    delete(h1)
    h1 = plot([t(i), t(i)], [x_inQ], 'r', 'LineWidth', 2);

    subplot(2,2,2)
    delete(h2)
    h2 = plot(x(idx_inQx), Z0D(idx_inQx,i), 'b-');
    title(['Time, t = ', num2str(round(t(i)))])
    
    
    subplot(2,2,4)
    delete(h3)
    h3 = plot(x(idx_inQx), ZFD(idx_inQx,i) , 'b-', 'LineWidth', 2);
    
    
    
    count = count+1;
    
    if Bol_save
        set(gcf, 'Color' ,'w'); % Gif
        f = getframe(figure(6)); % Gif
        im(:,:,1,count) = rgb2ind(f.cdata,map,'nodither'); % Gif
    else
        pause(0.01)
    end
end
if Bol_save
%     cd([AllDir.ParentDir ,AllDir.SaveDir])
    imwrite(im,map,[name_file, '.gif'],'DelayTime',0.08);
%     cd([AllDir.ParentDir, AllDir.SourceDir])
end


end

