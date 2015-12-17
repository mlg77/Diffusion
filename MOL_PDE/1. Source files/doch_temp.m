% Dealing with High low data

clear; clc; close all

% AllDir.ParentDir = 'C:\Temp\Diffusion\MOL_PDE\';
% 
% AllDir.SourceDir = '1. Source files';
% AllDir.SaveDir = '4. Output files\Docherty\HighLow';
% 
% 
% cd([AllDir.ParentDir, AllDir.SaveDir])
% load('HL_data.mat')
% 
% 
% mydiffusion = [0.5e-6:0.5e-6:10e-6];
% 
% DD =length(mydiffusion); BB = length(BetaBase); BL = length(Betalow);
% perD = BB*BL;
% for i = 1:DD-1
%     figure()
%     hold on
%     j = (i-1)*perD+1; k = j+perD;
% %     plot(FFgrid(j:k,1)); 
% %     plot(FFgrid(j:k,2)); 
% %     plot(FFgrid(j:k,3)); 
%     plot(FFgrid(j:k,2)-FFgrid(j:k,4)); 
% %     plot(FFgrid(j:k,5)); 
%     plot(FFgrid(j:k,2)-FFgrid(j:k,6));
% %     legend('SimpleB','SimpleH','SD B','SD H','ED B','ED H')
%     legend('SimpleH- SD H', 'Simple H -ED H')
% end
% 
% display('Every 9 BL resets')
% Betalow
% BetaBase
% mydiffusion

load('C:\Temp\Diffusion\MOL_PDE\4. Output files\Figurers_Tim\Data_For_Tim_Plots\Simple_data.mat')
if exist('Z2b')
    Z2 = Z2b;
end
count = 0;
for i = 1:M
    count = count+1;
    L = (length(t)-1)*0.5; Fs = 1/(t(2)-t(1));

    P_S = abs(fft(Z2(i,0.5*L:end))/L);
    P_S = P_S(1:L/2+1); 
    P_S(2:end-1) = 2*P_S(2:end-1); 

    f = Fs*(0:(L/2))/L;
    
    highpts1 = find(P_S>0.05==1);
    % Condence list
    highpts = [];
    ct2 = 1;
    doubleups = -(highpts1(1:end-1)- highpts1(2:end))<5;
    doubleups = find(doubleups ==1);
    if isempty(doubleups)
        highpts =highpts1;
    else
        doubleups(2,:) = highpts1(doubleups(1,:)); doubleups(3,:) = highpts1(doubleups(1,:)+1);
        for j = 1:size(doubleups,2)
            doubleups(4,j)= find(min(P_S(doubleups(2:3,j)))==P_S);
            highpts1(find(highpts1 == doubleups(4,j)) ) = nan;
        end
        for j = 1:length(highpts1)
            if isnan(highpts1(j))
            else
                highpts(ct2) = highpts1(j);
                ct2 = ct2+1;
            end
        end
    end
%     doubleups = -(highpts(1:end-1)- highpts(2:end))<5;
%     doubleups = find(doubleups ==1);
%     if numel(doubleups)>0
%         numel(doubleups)
%     end

    highpts_girdf(count, 1:length(highpts)) = f(highpts);
    highpts_girdP_S(count, 1:length(highpts)) = P_S(highpts);
%     hold off
%     plot(f,P_S); axis([0,15,0,0.5])
%     hold on
%     plot(highpts_girdf(count,:), highpts_girdP_S(count,:), 'rx')

end
highpts_girdf(find(highpts_girdf == 0)) = nan;
highpts_girdP_S(find(highpts_girdP_S == 0)) = nan;


simple = nan(size(highpts_girdP_S));
for j = 1:length(highpts_girdP_S)-30
    simple(j+15,:) = mean(highpts_girdP_S(j:j+30,:));
end

for i = 2:4%size(highpts_girdf, 2)
    hold on 
    plot3(mybeta, highpts_girdP_S(:,i), highpts_girdf(:,i))
    plot3(mybeta, simple(:,i), highpts_girdf(:,i))
    legenddd{i-1} = ['peek', num2str(i)];
    
    k = ~isnan(highpts_girdP_S(:,i));
    k2 = ~isnan(highpts_girdf(:,i));
    coeff_A(i-1,:) = polyfit(mybeta(k),highpts_girdP_S(k,i),5);
    coeff_f(i-1,:) = polyfit(mybeta(k2),highpts_girdf(k2,i),5);
end
% legend(legenddd)
xlabel('beta');zlabel('frequency'); ylabel( 'Amplitude');
grid on




