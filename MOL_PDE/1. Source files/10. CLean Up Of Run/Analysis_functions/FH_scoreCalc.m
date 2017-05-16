function [ FH_score ] = FH_scoreCalc( Z )
%Find the percentage forward heavy
%   Given the data for the oscillating wave
%   size(Z) = [n , 1]

% find max
[PKS,LOCS] = findpeaks(Z);

if length(LOCS) < 3
    FH_score = nan;
    return
end

% one period is:
T = LOCS(end) - LOCS(end-1);
% Tou used
idxmax  = LOCS(end-2);

change_array = zeros(floor(T/3), 1);
for ii = 1:floor(T/3)
    change_array(ii) = Z(idxmax + ii) - Z(idxmax - ii);
end
plot(change_array)
FH_score = max(change_array);

end

