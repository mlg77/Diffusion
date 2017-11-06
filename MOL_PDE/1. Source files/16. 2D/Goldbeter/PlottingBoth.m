%% Plotting only
cd('C:\Temp\Diffusion\MOL_PDE\4. Output files\Temp_2D')
% load('Data_2D_D6.mat')
% load('Data_2D_0D.mat')
% load('Data_2D_D6_First.mat')
% load('Data_2D_0D_First.mat')


M = length(x1);

figure(1); 
subplot(1,2,1); hold on; xlabel('x1'); ylabel('x2'); title('Concentration D = 0');
subplot(1,2,2); hold on; xlabel('x1'); ylabel('x2'); title('Concentration D = 6e-6');
pause();

set(gcf, 'Color' ,'w'); % Gif
f = getframe(figure(1)); % Gif
f.colormap = jet;
[im,map] = rgb2ind(f.cdata,256,'nodither'); % Gif
count = 1; %gif


for ii = 1:5:length(t)*0.5
    subplot(1,2,1);
    Z_Grid = zeros(length(x1), length(x1));
    for jj = 1:length(x2)
        Z_Grid(jj, :) = Z((jj-1)*M + 1:jj*M, ii);
    end
%     Make a circle
    Zcircle = [fliplr(flipud(Z_Grid)),flipud(Z_Grid);fliplr(Z_Grid),Z_Grid];
    imagesc([-x1,x1], [-x2,x2], Zcircle)
%     imagesc(x1, x2, Z_Grid)
    axis([0,x1(end),0,x1(end)])
    colorbar; caxis([0 1.1])
    
    subplot(1,2,2);
    Z_Grid = zeros(length(x1), length(x1));
    for jj = 1:length(x2)
        Z_Grid(jj, :) = ZF((jj-1)*M + 1:jj*M, ii);
    end
%     Make a circle
    Zcircle = [fliplr(flipud(Z_Grid)),flipud(Z_Grid);fliplr(Z_Grid),Z_Grid];
    imagesc([-x1,x1], [-x2,x2], Zcircle)
%     imagesc(x1, x2, Z_Grid)
    axis([0,x1(end),0,x1(end)])
    colorbar; caxis([0 1.1])
    
%      pause()
    
    set(gcf, 'Color' ,'w'); % Gif
    f = getframe(figure(1)); 
    f.colormap = jet;
    im(:,:,1,count) = rgb2ind(f.cdata,map,'nodither');
    count = count + 1;
end

imwrite(im,map,'Longtslow.gif','DelayTime',dt); % Save Gif file

cd('C:\Temp\Diffusion\MOL_PDE\1. Source files\16. 2D')
