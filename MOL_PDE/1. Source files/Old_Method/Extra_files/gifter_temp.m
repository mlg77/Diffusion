% clear; clc; close all; 
% AllDir.ParentDir = 'C:\Temp\Diffusion\MOL_PDE\';
% 
% AllDir.SourceDir = '1. Source files';
% AllDir.InitalDataDir = '2. Inital Data';
% AllDir.SaveDir = '4. Output files\Unusual_B\hat_fun_2';
% 
% load('ChangingB')

figure(1)
set(gcf, 'Color' ,'w'); % Gif
f = getframe(figure(2)); % Gif
[im,map] = rgb2ind(f.cdata,256,'nodither');  % Gif
count = 0;
for i = 1:6
    mydata = {['Z_', num2str(i)]}
    count = count+1;
    % What to plot
    figure(1)
        imagesc(t,flipud(x),record.(mydata{1}))
        set(gca,'YDir','normal')
        xlabel('Time, [s]')
        ylabel('Position, x')
        title(['Calcium [Ca^2^+] Concentration, [\muM] Beta', num2str(BLL(i))])
        colormap jet
        hold on
        plot([0,t_end], [0.25,0.25], 'k','LineWidth',2)
        plot([0,t_end], [0.75,0.75],  'k','LineWidth',2)
        colorbar
    % Plot labeling
    % Save Gif
    set(gcf, 'Color' ,'w'); % Gif
    f = getframe(figure(1)); % you get the whole picture including the axis
    im(:,:,1,count) = rgb2ind(f.cdata,map,'nodither'); % Gif
end
imwrite(im,map,'ChangingB.gif','DelayTime',0.5); % Save Gif file
