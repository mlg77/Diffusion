%% Analysis For Tim Later stages of Report 
% Author Michelle Goodman
% Date 18/3/16

clear
clc

%% Where am I
AllDir.ParentDir = 'C:\Temp\Diffusion\MOL_PDE\';
AllDir.SourceDir = '1. Source files';
AllDir.SaveDir = '4. Output files\Figurers_Tim\Data_For_Tim_Plots';
AllDir.InitalDataDir = '2. Inital Data';

%% Plot First
mystr = 'plot_only';
cd([AllDir.ParentDir, AllDir.SourceDir])
My_plot_report( mystr , AllDir)
cd([AllDir.ParentDir, AllDir.SourceDir])
% return

%% Need to relate magnitude of wave at penertration point to depth
% close all
cd([AllDir.ParentDir, AllDir.InitalDataDir]);
load('Defult_data.mat')
cd([AllDir.ParentDir ,AllDir.SaveDir])
load('bounds_data.mat')
load('SD_data.mat')
list_1 = find(mybeta>bt_point); list_2 = find(mybeta>top_point);
if isempty(list_2) | isempty(list_1)
    top_pt = x(1) ; bt_pt = x(end);
else
    top_pt = x(list_1(1)) ; bt_pt = x(list_2(1));
end
Num_top_pt = 277; % Exactly

maxxxes = [];
% Go through each row
for j = 1:length(mybeta)
    Z = [];
    Z = Z2b(j, :); 
%     plot(t, Z)
%     pause(0.2)
    if abs(max(Z) -min(Z))/max(Z) > 0.001
        up = 0; down = 0;
        for  i = 1:length(Z)-1
            if Z(i+1) - Z(i)  > 0
                up = 1;
            else
                down = 1;
            end
        end

        if up & down
            % Find the sign (+/-) of the gradient matrix
            diff = sign(Z(2:end) - Z(1:end-1));
            for i = 1:length(diff)-1
                if diff(i+1) ~= diff(i) && diff(i) > 0
                    % Fill in maxxess matrix to find the peeks
                    maxxxes(j, (i+1)) = Z(i+1);
                end
            end
        end
    end
end
%% Go through and find the magnitude of the waves at the transition point.
[i,j,s] = find(sparse(maxxxes(Num_top_pt,:)));
peeks_tran = [j;s]';

%% Go through and try find the end of the waves
% find manually
length(peeks_tran)
depthlist = [0.084, 0.113, 0.133, 0.149, 0.161, 0.173, 0.184 0.2878 0.199];

figure()
plot(depthlist, peeks_tran(1:7,2))
    

% imagesc(maxxxes)
% cmap = jet(256);
% caxis(gca,[0, 1.5]);
% placement = 1;
% cmap(placement,:)=ones(length(placement),3);
% colormap(figure(1), cmap)
% colorbar

