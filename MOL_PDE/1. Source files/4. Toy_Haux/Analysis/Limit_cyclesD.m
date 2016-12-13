function [  ] = Limit_cyclesD( Z,V, t, x, Bol_Gif, name_file, Bol_save, t_inQ, x_inQ, ax_max, speed_per)
% Limit_cycles Plot the limit cycles. If choose to plot over time and save
% as a gif 
% Inputs:
%   Z0D,V, t, x, : as per every script 
%   Bol_Gif: 0/1 Do you want a annimation 
%   name_file: string gif name
%   Bol_save: Do you want to save it?
%   t_inQ: What time points do you want?
%   x_inQ: What descrete x points do you want
%   speed_per: 0 to 1 speed

mybeta = x;
% Set up regions you want
for ii = 1:length(x_inQ)
    point = round(find(x>x_inQ(ii),1)); 
    if isempty(point)
        point = length(x);
    end
    idx_inQ(ii) = point;
end
idx_time_whole = round(find(t>t_inQ(1),1)):round(find(t>t_inQ(2),1));


speed_step = round(speed_per*(find(t>t_inQ(2), 1)-(find(t>t_inQ(1)))));
idx_time = round(find(t>t_inQ(1),1)):speed_step:round(find(t>t_inQ(2),1));

% Largest limit cycle on whole section
disp('section started')
V_max = -5:1e-2:5;
zero_mark = -1;
Z_max = V_max*0+ zero_mark;
Z_min = V_max*0+ zero_mark;
% figure(10)
for ii =1:2:size(Z, 1)
    for jj = round(size(Z, 2)/2):5 :size(Z, 2)
%         hold on
%         plot(V(ii, :), Z(ii, :))
        ele = find(round(V(ii, jj), 2)==V_max);
        pt = round(Z(ii, jj), 2);
        if pt > Z_max(ele)
            Z_max(ele) = pt;
        elseif pt < Z_min(ele)
            Z_min(ele) = pt;
        end
    end
end
Z_max(find(Z_max<=zero_mark +1e-2)) = nan;
Z_min(find(Z_min>=zero_mark-1e-2)) = nan;
count = 1;  count2  =1 ;
for ii = 1:length(Z_max)
    if isnan(Z_max(ii)) ==0
        Z_max1(count) = Z_max(ii); 
        V_max1(count) = V_max(ii);
        count = count+1;
    end
    if isnan(Z_min(ii)) ==0
        Z_min1(count2) = Z_min(ii); 
        V_max2(count2) = V_max(ii);
        count2 = count2+1;
    end
end
plot(V_max1, Z_max1,'b', V_max2, Z_min1, 'b')

% Set up Figure
figure(2)
clf
suptitle('Limit cycles of respective beta values ')
% Cycle through different betas
for ii = 1:length(idx_inQ)
    if Bol_Gif 
        col_use = [0.5,0.5,0.5];
    else
        col_use = 'b';
    end
    % Set up Figure
    subplot(1,length(idx_inQ), ii)
        hold on
        grid on
        xlabel('\Psi')
        ylabel('\Phi')

    plot(V(idx_inQ(ii),idx_time_whole), Z(idx_inQ(ii),idx_time_whole), 'Color', col_use)
    % add label
    h = text(V(idx_inQ(ii),end), Z(idx_inQ(ii),end),num2str(mybeta(idx_inQ(ii))));
    set(h, 'FontSize', 15);  set(h, 'VerticalAlignment', 'bottom'); 
    col_use = {'b', 'r', 'g', 'm', 'c', 'k'};
    hh{ii} = plot(V(idx_inQ(ii),idx_time_whole(1)), Z(idx_inQ(ii),idx_time_whole(1)), 'Color', col_use{ii});
    hcol{ii} = plot(V(idx_inQ(ii),idx_time_whole(1)), Z(idx_inQ(ii),idx_time_whole(1)), 'Color', 'b', 'linewidth', 2);
    axis([-1*ax_max(1), ax_max(1), -1*ax_max(end), ax_max(end)])
    plot(V_max1, Z_max1,'b', V_max2, Z_min1, 'b')
end

%%%% Gifter
if Bol_save
    set(gcf, 'Color' ,'w'); % Gif
    f = getframe(figure(2)); % Gif
    [im,map] = rgb2ind(f.cdata,256,'nodither');  % Gif
end
count = 0;
% Do you want an annimation?
if Bol_Gif
    disp('Press enter when ready to start')
    pause()
    
    col_use = {'b', 'r', 'g', 'm', 'c', 'k'};
    for jj = 1:length(idx_time)-1 % minus 1 different
        for ii = 1:length(idx_inQ)
            subplot(1,length(idx_inQ), ii)
            delete(hh{ii})
            delete(hcol{ii})
%             hcol{ii} = plot(V(ii,idx_time(1):idx_time(jj)), Z(ii,idx_time(1):idx_time(jj)), 'Color', col_use, 'Linewidth', 2);
%             hh{ii} = plot(V(ii,idx_time(jj)), Z(ii,idx_time(jj)), 'ob');
            hcol{ii} = plot(V(idx_inQ(ii),idx_time(jj):idx_time(jj+1)), Z(idx_inQ(ii),idx_time(jj):idx_time(jj+1)), 'Color', col_use{ii} , 'Linewidth', 2);
            hh{ii} = plot(V(idx_inQ(ii),idx_time(jj+1)), Z(idx_inQ(ii),idx_time(jj+1)), 'ob');
        end
        if Bol_save
            count = count+1;
            set(gcf, 'Color' ,'w'); % Gif
            f = getframe(figure(2)); % Gif
            im(:,:,1, count) = rgb2ind(f.cdata,map,'nodither'); % Gif
        else
            pause(0.1)
        end
    end
    for ii = 1:length(idx_inQ)
        delete(hh{ii})
    end
end

if Bol_save
%     cd([AllDir.ParentDir ,AllDir.SaveDir])
    imwrite(im,map,[name_file, '.gif'],'DelayTime',0.08);
%     cd([AllDir.ParentDir, AllDir.SourceDir])
end

disp('Finished')
end



