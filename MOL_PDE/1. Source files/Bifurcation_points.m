function [ pointsfound ] = Bifurcation_points( x,t,Z )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

tol = 0.01*max(max(Z));
pointsfound = [];
for ii = 1:length(x)
    % Last 5% of the data for each line
    consider = Z(ii,:);
    if isempty(pointsfound)
       if abs(max(consider)-min(consider)) > tol 
           pointsfound(1,1) = ii;
           pointsfound(2,1) = x(ii);
       end
    elseif size(pointsfound, 2) == 1
       if abs(max(consider)-min(consider)) < tol
           pointsfound(1,2) = ii;
           pointsfound(2,2) = x(ii);
       end
    else
        break
    end
end
end

