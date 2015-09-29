% Creates a gif of the calcium orer time 
% 24/9/15
% Michelle Goodman

clear; clc; close all
%% Load data
load('C:\Temp\Diffusion\MOL_PDE\4. Output files\ED_data.mat')
%% Identify Time concerned
start_t = 4850;
% end_t_slow = 5151; start_t_fast = end_t_slow;
end_t_slow =15001;
end_t = 6001;

%% Finds the First spike top position.
count = 1;
for j =  start_t:end_t_slow
    conc_Z = Z3(:,j); % Concentration along one time point concerned
    diff = sign(conc_Z(2:end) - conc_Z(1:end-1)); % Gradient sign
    % loop through to find the first point that changes gradient sign
    for i = 1:length(diff)-1 
        % Point must be in range
        if (diff(i+1) ~= diff(i) && diff(i) > 0 ) && (conc_Z(i)>0.28 && x(i)< 0.121)
            % Record info about the top point
            maxxx(count,:) = [t(j), conc_Z(i+1)];
            count = count + 1;
            break
        end
    end
end
    
%% Greates a giff to plot concentration over position over time
figure(1);
start_Z = Z3(:,start_t);  
p = plot(x, start_Z); % Gif
set(gcf, 'Color' ,'w'); % Gif
f = getframe(figure(1)); % Gif
[im,map] = rgb2ind(f.cdata,256,'nodither');  % Gif
count = 0;
for i = start_t: 20:end_t_slow
    count = count+1;
    % What to plot
    start_Z = Z3(:,i);
    plot(x, start_Z) 
    % Plot labeling
    xlabel('Position, x')
    ylabel('Concentration Z')
    grid on
    grid minor
    title(num2str(t(i))) 
    % Save Gif
    set(gcf, 'Color' ,'w'); % Gif
    f = getframe(figure(1)); % you get the whole picture including the axis
    im(:,:,1,count) = rgb2ind(f.cdata,map,'nodither'); % Gif
end
imwrite(im,map,'Longtslow.gif','DelayTime',0.08); % Save Gif file

%% Plot concentration of first peek
figure(2)
plot(maxxx(:,1), maxxx(:,2))
title('first spike')
xlabel('time')
ylabel('concentration')


