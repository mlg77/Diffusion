%% Plotting only
cd('C:\Temp\Diffusion\MOL_PDE\4. Output files\Temp_2D')
% load('Data_2D_D6.mat')
% load('Data_2D_0D.mat')
% load('Data_2D_D6_First.mat')
% load('Data_2D_0D_First.mat')

close all
M = length(x1);



Radium_Grid = [];
Radium_GridD = [];

for ii = 1:length(t)*0.5
    Z_Grid = zeros(length(x1), length(x1));
    for jj = 1:length(x2)
        Z_Grid(jj, :) = Z((jj-1)*M + 1:jj*M, ii);
    end
    Zcircle = [fliplr(flipud(Z_Grid)),flipud(Z_Grid);fliplr(Z_Grid),Z_Grid];
    Radium_Grid(:,ii) = Z_Grid(:,1);
    
    Z_GridD = zeros(length(x1), length(x1));
    for jj = 1:length(x2)
        Z_GridD(jj, :) = ZF((jj-1)*M + 1:jj*M, ii);
    end
    ZcircleD = [fliplr(flipud(Z_GridD)),flipud(Z_GridD);fliplr(Z_GridD),Z_GridD];
    Radium_GridD(:,ii) = Z_GridD(:,1);
    
    if floor(t(ii)*100) == 193
        figure()
        suptitle('t = 1.93')
        subplot(1,2,1); imagesc([-x1,x1], [-x2,x2], Zcircle)
        colorbar; caxis([0 1.1])
        subplot(1,2,2); imagesc([-x1,x1], [-x2,x2], ZcircleD)
        colorbar; caxis([0 1.1])
    elseif t(ii) ==2.22
        figure()
        suptitle('t = 2.22')
        subplot(1,2,1); imagesc([-x1,x1], [-x2,x2], Zcircle)
        colorbar; caxis([0 1.1])
        subplot(1,2,2); imagesc([-x1,x1], [-x2,x2], ZcircleD)
        colorbar; caxis([0 1.1])
    elseif t(ii) ==2.27
        figure()
        suptitle('t = 2.27')
        subplot(1,2,1); imagesc([-x1,x1], [-x2,x2], Zcircle)
        colorbar; caxis([0 1.1])
        subplot(1,2,2); imagesc([-x1,x1], [-x2,x2], ZcircleD)
        colorbar; caxis([0 1.1])
     elseif t(ii) ==2.82
        figure()
        suptitle('t = 2.82')
        subplot(1,2,1); imagesc([-x1,x1], [-x2,x2], Zcircle)
        colorbar; caxis([0 1.1])
        subplot(1,2,2); imagesc([-x1,x1], [-x2,x2], ZcircleD)
        colorbar; caxis([0 1.1])
    end
    
end

figure()
subplot(1,2,1); imagesc(t(1:1000),x1, Radium_Grid)
xlabel('x1'); ylabel('x2'); title('Concentration D = 0');
subplot(1,2,2); imagesc(t(1:1000),x1, Radium_GridD)
xlabel('x1'); ylabel('x2'); title('Concentration D = 6e-6');


cd('C:\Temp\Diffusion\MOL_PDE\1. Source files\16. 2D')
