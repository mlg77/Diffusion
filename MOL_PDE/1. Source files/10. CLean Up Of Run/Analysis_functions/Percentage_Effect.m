function [ PercentageEffect ] = Percentage_Effect( Z_at_x_star, dt, dx, D, offsetby )
%Percentage_Effect A function to do it all
%   Given one wave shape (Or a line of waves) give the percentage effect

%% First find just one wave
[pks, locs] =findpeaks(Z_at_x_star);
if length(locs) < 2
    error('too short data given')
elseif length(locs) == 2
    %exact one wave of data
    onewave = Z_at_x_star(locs(1):locs(2));
else
    mid_point = floor(length(locs)*0.75);
    onewave = Z_at_x_star(locs(mid_point):locs(mid_point+1));
end

%% Given the one wave find the percentage effect
dif_over_period = zeros(2, length(offsetby));
DelDelCon = zeros(1, length(offsetby));
PercentageEffect = zeros(1, length(offsetby));

for jj = 1:length(offsetby)
    % Find the index of the movement
    lenblu = floor(length(onewave)*offsetby(jj));
    % Save the Change to behind (Down stream)
    dif_over_period(1, jj) = max(onewave) - onewave(lenblu+1);
    % Save the Change to infront (Upstream)
    dif_over_period(2, jj) = max(onewave) - onewave(end-lenblu);
end
% Change in the change
DelDelCon(1,:) = (dif_over_period(1,:)-dif_over_period(2,:));


% Percentage of concentration effect
% PercentageEffect(1,:) = 100*(DelDelCon(1,:).*dt*D/(dx^2)) /(max(onewave)-min(onewave));
PercentageEffect(1,:) = 100*DelDelCon(1,:)/(max(onewave)-min(onewave));
% PercentageEffect(1,:) = DelDelCon(1,:); % Just the change

end


