function [ periodarray, periodarraymin, periodarraymax ] = Period_gen( x, t, Z)
%Generates an array of periods 
%   Detailed explanation goes here
periodarray = 0*x;
periodarraymax = 0*x;
periodarraymin = 0*x;
min_Z = min(min(Z));
max_Z = max(max(Z));
for i = 1:length(x)
    [pks,locs] = findpeaks(Z(i, round(length(Z)/2):end));
    del_below = find((pks-min_Z)<0.1*max_Z);
    pks(del_below)=[];
    locs(del_below)=[];
    if length(locs) <= 1
        periodarray(i) = 0;
    else
        periodarraymin(i) = prctile(abs(t(locs(1:end-1)) - t(locs(2:end))), [10]);
        periodarraymax(i) = prctile(abs(t(locs(1:end-1)) - t(locs(2:end))), [90]);
        periodarray(i) = mean(abs(t(locs(1:end-1)) - t(locs(2:end))));
    end
end


end



