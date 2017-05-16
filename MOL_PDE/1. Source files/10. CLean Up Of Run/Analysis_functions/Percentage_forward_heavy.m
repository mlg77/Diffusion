function [ Per_f_heavy ] = Percentage_forward_heavy( Waveone, backwardsWave, t_wave )
%Find the percentage forward heavy
%   Given the data for the forward and backward heavy wave find the signed
%   area encolsed between the two
%   Next find only the positive area and create a percentage forward
%   If the percentage is less than 50% then the wave is said to be
%   backwards heavy

% First find intersection points
change_line = Waveone - backwardsWave;
grad_change = sign(change_line(2:end))- sign(change_line(1:end-1));

cross_overs = find(abs(grad_change) ~= 0);
idx_idx_half = ceil(length(cross_overs)/2);
cross_overs = cross_overs(1:idx_idx_half);

if length(cross_overs) == 0 
    Per_f_heavy = nan;
    return
end
% Find the total area 
Total_area = trapz(t_wave(1:cross_overs(end)),abs(change_line(1:cross_overs(end))));

% Find only the positive area
Positive_change_line = change_line;
Positive_change_line(find(change_line<0)) = 0;
Positive_area = trapz(t_wave(1:cross_overs(end)),Positive_change_line(1:cross_overs(end)));

% Find the percentage positive 
Per_f_heavy = Positive_area/Total_area;



end

