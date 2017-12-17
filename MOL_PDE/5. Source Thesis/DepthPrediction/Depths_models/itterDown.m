function [ pathdata ] = itterDown( E, f1, P0, P, x )
%UNTITLED12 Summary of this function goes here
%   Detailed explanation goes here


P_itt = P0;
count = 0;
pathdata.P = [];
pathdata.x = [];
pathdata.E = [];

for ii = length(x):-1:1
    idx_x = ii;
%     idx_P = find(P_itt <= P,1);
    myE = interp1(P, E(idx_x, :), P_itt);
    P_itt = (myE+ P_itt) * f1;
    
    count = count+1;
    if length(P_itt) ~= 1
        pathdata.P(count) = nan;
        pathdata.x(count) = nan;
        pathdata.E(count) = nan;
        display(['f1 overshot P: ', num2str(f1)])
        return
    end
    pathdata.P(count) = P_itt;
    pathdata.x(count) = x(ii);
%     pathdata.E(count) = E(idx_x, idx_P);
    pathdata.E(count) = myE;
    
    if P_itt <= 1e-6
        return
    end
end



end

