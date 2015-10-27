 clear; clc; close all; 
%% Where am I
AllDir.ParentDir = 'C:\Temp\Diffusion\MOL_PDE\';

AllDir.SourceDir = '1. Source files\Extra_files';
AllDir.InitalDataDir = '2. Inital Data';
AllDir.SaveDir = '4. Output files';

cd([AllDir.ParentDir ,AllDir.SaveDir])
load('bounds_data.mat')
load('ED_data.mat')

ind_b = find(mybeta>bt_point);
xpo = [0.4,0.65];

figure(1)
    hold on
    plot(mybeta,x)
    ylabel('Position, x')
    xlabel('Beta, \beta')
    plot([bt_point, bt_point], [0, x(ind_b(end))] , 'k')
    plot([0,bt_point], [x(ind_b(1)), x(ind_b(1))], 'k','LineWidth',2)
    plot([0,bt_point], [x(ind_b(end)), x(ind_b(end))], 'k','LineWidth',2)
    axis([[0.15,0.65], xpo])
    hold off
figure(2)
    imagesc(t,flipud(x),Z3)
    set(gca,'YDir','normal') 
    xlabel('Time, [s]')
    ylabel('Position, x')
    title('Calcium [Ca^2^+] Concentration in the Cytosol with Electro-Diffusion (6x10^-^6), [\muM]')
    colorbar
    colormap jet
    hold on
    plot([0,t_end], [x(ind_b(1)), x(ind_b(1))], 'k','LineWidth',2)
    plot([0,t_end], [x(ind_b(end)), x(ind_b(end))],  'k','LineWidth',2)
    axis([[0,100], xpo])
    hold off
    
figure(3)
    imagesc(t,flipud(x),Z3)
    set(gca,'YDir','normal') 
    xlabel('Time, [s]')
    ylabel('Position, x')
    title('Calcium [Ca^2^+] Concentration in the Cytosol with Electro-Diffusion (6x10^-^6), [\muM]')
    colorbar
    colormap jet
    hold on
    plot([0,t_end], [x(ind_b(1)), x(ind_b(1))], 'k','LineWidth',2)
    plot([0,t_end], [x(ind_b(end)), x(ind_b(end))],  'k','LineWidth',2)
    axis([[0,35], xpo])
    hold off
figure(4)
   x_pt_ind =  471;%(ind_b(1) + ind_b(end))/2;
   plot(t(1:15001),Z3(x_pt_ind,1:15001))
   title(num2str(x(x_pt_ind)))
   xlabel('Time, [s]')
   ylabel('Calcium Concentration, [\muM]')

% x(651) : x(401) t(15001)
figure(5)
start_Z = Z3(401:651,1);
p = plot(x(401:651), start_Z); % Gif
set(gcf, 'Color' ,'w'); % Gif
f = getframe(figure(5)); % Gif
[im,map] = rgb2ind(f.cdata,256,'nodither');  % Gif
count = 0;

for i = 1:10: 15001
    count = count+1;
    % What to plot
    start_Z = Z3(401:651,i);
    figure(5)
    plot(x(401:651), start_Z) 
    % Plot labeling
    xlabel('Position, x')
    ylabel('Concentration Z')
    axis([x(401), x(651), 0, 1.4])
    grid on
    grid minor
    title(num2str(t(i))) 
    % Save Gif
    set(gcf, 'Color' ,'w'); % Gif
    f = getframe(figure(5)); % you get the whole picture including the axis
    im(:,:,1,count) = rgb2ind(f.cdata,map,'nodither'); % Gif
end
imwrite(im,map,'UnusualB.gif','DelayTime',0.1); % Save Gif file


%%
figure(6)
start_Z = Z3(526, 1:15001);
p = plot(t(1:15001), start_Z); % Gif
set(gcf, 'Color' ,'w'); % Gif
f = getframe(figure(6)); % Gif
[im,map] = rgb2ind(f.cdata,256,'nodither');  % Gif
count = 0;

for i = 526:-1:451
    count = count+1;
    % What to plot
    start_Z = Z3(i,1:15001);
    figure(6)
    plot(t(1:15001), start_Z) 
    % Plot labeling
    xlabel('Position, x')
    ylabel('Concentration Z')
    axis([0, 35, 0, 1.4])
    grid on
    grid minor
    title(num2str(x(i))) 
    % Save Gif
    set(gcf, 'Color' ,'w'); % Gif
    f = getframe(figure(6)); % you get the whole picture including the axis
    im(:,:,1,count) = rgb2ind(f.cdata,map,'nodither'); % Gif
end
imwrite(im,map,'UnusualB_dx.gif','DelayTime',0.3); % Save Gif file
 