%% Plotting only
cd('C:\Temp\Diffusion\MOL_PDE\4. Output files\Temp_2D')
% load('Data_2D_0D.mat')
% load('Data_2D_D6.mat')
% load('Data_2D_D6_First.mat')
% load('Data_2D_0D_First.mat')

close all
M = length(x1);



Radium_Grid = [];
Radium_GridD = [];



for ii = 1:length(t)
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
    
    if floor(t(ii)*100)/100 == 0.08
        figure(1);
        subplot(1,3,1); imagesc([-fliplr(x1),x1], [-fliplr(x2),x2], ZcircleD)
        colorbar; caxis([0 1.1]);  title('t = 0.08')
    elseif floor(t(ii)*100)/100  == 0.16
        figure(1);
        subplot(1,3,2); imagesc([-fliplr(x1),x1], [-fliplr(x2),x2], ZcircleD)
        colorbar; caxis([0 1.1]);  title('t = 0.16')
    elseif floor(t(ii)*100)/100  ==0.24
        figure(1);
        subplot(1,3,3); imagesc([-fliplr(x1),x1], [-fliplr(x2),x2], ZcircleD)
        colorbar; caxis([0 1.1]);  title('t = 0.24')
     elseif floor(t(ii)*100)/100  ==0.51
        figure(2); 
        subplot(1,3,1); imagesc([-fliplr(x1),x1], [-fliplr(x2),x2], Zcircle)
        colorbar; caxis([0 1.1]); title('t = 0.51')
    elseif floor(t(ii)*100)/100  ==2.30
        figure(2); 
        subplot(1,3,2); imagesc([-fliplr(x1),x1], [-fliplr(x2),x2], Zcircle)
        colorbar; caxis([0 1.1]); title('t = 2.30')
     elseif floor(t(ii)*100)/100  == 4.08
         figure(2); 
         subplot(1,3,3); imagesc([-fliplr(x1),x1], [-fliplr(x2),x2], Zcircle)
         colorbar; caxis([0 1.1]); title('t = 4.08')
    end
    
end

figure()
subplot(1,2,1); imagesc(t,x1, Radium_Grid)
xlabel('x1'); ylabel('x2'); title('Concentration D = 0');
subplot(1,2,2); imagesc(t,x1, Radium_GridD)
xlabel('x1'); ylabel('x2'); title('Concentration D = 6e-6');


cd('C:\Temp\Diffusion\MOL_PDE\1. Source files\16. 2D')


% 
% [ wave_data ] = Follow_wave( Radium_GridD, x1, t, 0.2, 1, 1 )
