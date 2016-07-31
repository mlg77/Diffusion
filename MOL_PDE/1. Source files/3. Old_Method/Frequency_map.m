%% Produce a map of period over space and time. Save as a sparse matrix
% Use Flux data 

% clear; clc; close all; 
%% Where am I
AllDir.ParentDir = 'C:\Temp\Diffusion\MOL_PDE\';

AllDir.SourceDir = '1. Source files\';
AllDir.InitalDataDir = '2. Inital Data';
AllDir.SaveDir = '4. Output files';
%% Plot raw flux data
cd([AllDir.ParentDir ,AllDir.SaveDir])
% % figure(1)
% % load('ED_data_Fluxes');
% % imagesc(t,flipud(x(2:end-1)),dX_dx(2:end-1,:))
% % set(gca,'YDir','normal')
% % xlabel('Time, [s]')
% % ylabel('Position, x')
% % title('dZ\_dx, Flux of Calcium Concentration in the Cytosol, [\muM m^{-1}]')
% % colormap jet
% % colorbar
% % 
% % figure(2)
% % imagesc(t,flipud(x(11:end-30)),gZdV_dx(11:end-30,:) )
% % set(gca,'YDir','normal')
% % xlabel('Time, [s]')
% % ylabel('Position, x')
% % title('gZdV\_dx, Calcium Concentration in the Cytosol, [\muM m^{-1}]')
% % colorbar
% % colormap jet
% 
cd([AllDir.ParentDir ,AllDir.SaveDir])
load('SD_data_6');
cd([AllDir.ParentDir ,AllDir.SourceDir])
f2 = findchangingf(V2b, Z2b, x, t);

figure(2)
h = imagesc(t(1:19931),flipud(x(2:end-1)), f2);     % 49963
set(gca,'YDir','normal') 
xlabel('Time, [s]')
ylabel('Position, x')
cmap = jet(256);
colormap(cmap);
caxis(gca,[0.1-2/256, 3]);
cmap(1,:)=[1,1,1];
colormap(cmap)
colorbar

cd([AllDir.ParentDir ,AllDir.SaveDir])
load('simple_data')
cd([AllDir.ParentDir ,AllDir.SourceDir])
for i = 1:length(x)
%     if x(i) == 0.268
%         0
%     end
    plot(t(10000:end), Z2(i, 10000:end))
    l = diff(Z2(i,10000:end));
    l(find(l>0))=0;
    l(find(l<0))=1;
    l = diff(l);
    t_at_max = t(find(l==1)+10000);
    t_at_min = t(find(l==-1)+10000);
    if isempty(t_at_max)
        t_at_max = 1; t_at_min = 1; 
    end
    if abs(min(Z2(i, find(l==1)+10000))-max(Z2(i, find(l==-1)+10000)))> 0.45
        PP(i) = mean(t_at_max(2:end)-t_at_max(1:end-1));
    else
        PP(i) = 0;
    end
    if isnan(PP(i))
        PP(i) = 0;
    end
end

cd([AllDir.ParentDir ,AllDir.SaveDir])
load('SD_data_6');
cd([AllDir.ParentDir ,AllDir.SourceDir])
figure(3)
pause()
subplot(1,2,1)
imagesc(t,flipud(x), Z2b);
set(gca,'YDir','normal')
xlabel('Time, [s]')
ylabel('Position, x')
title('Calcium Concentration in the Cytosol, [\muM]')
colormap jet
colorbar
hold on

subplot(1,2,2)
plot(x, PP , 'r')
xlabel('space')
ylabel('Period')
axis([0, 1, 0, 3])
hold on
set(gcf, 'Color' ,'w'); % Gif
f = getframe(figure(3)); % Gif
[im,map] = rgb2ind(f.cdata,256,'nodither');  % Gif

count = 0;
for i = 1:200:length(t(1:end-0.05*end)) %49963
    count = count+1;
    subplot(1,2,2)
    h = plot(x, f2(:,i), 'b');
    title(num2str(t(i)))
    
    subplot(1,2,1)
    j = plot([t(i),t(i)], [0, 1], 'k') ;
    set(gcf, 'Color' ,'w'); % Gif
    f = getframe(figure(3)); % you get the whole picture including the axis
    im(:,:,1,count) = rgb2ind(f.cdata,map,'nodither'); % Gif
    
%     pause(0.2)
    delete(h)
    delete(j)
    
end
imwrite(im,map,'Explin.gif','DelayTime',0.2); % Save Gif file

% pause()
cd([AllDir.ParentDir ,AllDir.SaveDir])
load('SD_data_1');
cd([AllDir.ParentDir ,AllDir.SourceDir])
f3 = findchangingf(V2b, Z2b, x, t);

cd([AllDir.ParentDir ,AllDir.SaveDir])
load('SD_data_60');
cd([AllDir.ParentDir ,AllDir.SourceDir])
f4 = findchangingf(V2b, Z2b, x, t);

figure(4)
pause()
plot(x, PP , 'r')
xlabel('space')
ylabel('Period')
axis([0, 1, 0, 3])
hold on
set(gcf, 'Color' ,'w'); % Gif
f = getframe(figure(4)); % Gif
[im,map] = rgb2ind(f.cdata,256,'nodither');  % Gif
count = 0;
for i = 1:200:length(t(1:end-0.05*end)) %49963
    count = count+1;
    h = plot(x, f2(:,i), 'b');
    j = plot(x, f3(:,i), 'g');
    w = plot(x, f4(:,i), 'c');
    title(num2str(t(i)))
    legend('zero difision', '6e-6', '1e-6', '60e-6')
    set(gcf, 'Color' ,'w'); % Gif
    f = getframe(figure(4)); % you get the whole picture including the axis
    im(:,:,1,count) = rgb2ind(f.cdata,map,'nodither'); % Gif
    
    pause(0.2)
    delete(h)
    delete(j)
    delete(w)
end
imwrite(im,map,'Rival.gif','DelayTime',0.2); % Save Gif file
