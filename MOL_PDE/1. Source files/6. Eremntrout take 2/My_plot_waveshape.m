function [  ] = My_plot_waveshape( AllDir )
% My plot Report for 18mo 


cd([AllDir.ParentDir ,AllDir.SaveDir])
load('All_data_ode')
cd([AllDir.ParentDir, AllDir.SourceDir])


top_pt = 0.750;  bt_pt = 0.2640;

t_end = round(length(t)/10);
t_start = 1;

colororder = [
	0.00  0.00  1.00
	0.00  0.50  0.00 
	1.00  0.00  0.00 
	0.00  0.75  0.75
	0.75  0.00  0.75
	0.75  0.75  0.00 
	0.25  0.25  0.25
	0.75  0.25  0.25
	0.95  0.95  0.00 
	0.25  0.25  0.75
	0.75  0.75  0.75
	0.00  1.00  0.00 
	0.76  0.57  0.17
	0.54  0.63  0.22
	0.34  0.57  0.92
	1.00  0.10  0.60
	0.88  0.75  0.73
	0.10  0.49  0.47
	0.66  0.34  0.65
	0.99  0.41  0.23
];
set(gca, 'ColorOrder', colororder);

points_plot = (1:6)/6*(top_pt - bt_pt) + bt_pt;
for ii = 1:6
    row_in_q = find(x>points_plot(ii), 1);
    
    % Make time frame for each one peak not the first one
    [pks,locs] = findpeaks(-Z0D(row_in_q,:)); % Find mins
    t_start= locs(3); t_end = locs(4);
    
    figure(5)
    subplot(2,3,ii)
    plot(t(t_start:t_end), Z0D(row_in_q,t_start:t_end))
    title(num2str(points_plot(ii)))
    xlabel('Time, [s]')
    ylabel('Membrain Potential [mV]')
    
%     % Subtract max time to line up all
%     [pks2,locs2] = findpeaks(V0D(row_in_q,:)); % Find maxs
%     guess_start = 2;
%     t_to_max = locs2(guess_start);
%     % check is between
%     while t_to_max>t_end || t_to_max < t_start
%         guess_start = guess_start+1;
%         t_to_max =locs2(guess_start);
%     end
%     
%     figure(6)
%     hold on
%     plot(t(t_start:t_end)- t(t_to_max), V0D(row_in_q,t_start:t_end))
%     title(num2str(points_plot(ii)))
%     xlabel('Time, [s]')
%     ylabel('Membrain Potential [mV]')
end 
end
