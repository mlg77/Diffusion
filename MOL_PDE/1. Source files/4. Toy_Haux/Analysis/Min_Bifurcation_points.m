function [ minpointsfound ] = Min_Bifurcation_points( x,t,Z)
%Min_Bifurcation_points
%   Doesnt work well requires a min distance on steady state to find min
%   point

tol = 0.01*max(max(Z));
pointsfound = [];
minpointsfound = [];
five_sec = find(t== 100);
count = 0;
not_found_yet = 1; 
for ii = 1:length(x)
    % Last 5% of the data for each line
    consider = Z(ii,:);
    if isempty(pointsfound)
       if abs(max(consider)-min(consider)) > tol 
           pointsfound(1,1) = ii;
           pointsfound(2,1) = x(ii);
       end
    elseif size(pointsfound, 2) == 1
        % Find min bifurcation points
        if not_found_yet
            for jj = five_sec:50:size(Z, 2)- five_sec
                consider2 = Z(ii,jj:jj+five_sec);
                if abs(max(consider2)-min(consider2)) < tol
                    count = count + 1;
                    minpointsfound(count,1) = jj;
                    minpointsfound(count,2) = x(ii);
                    break
                end
            end
            if isempty(find(minpointsfound(:,2) == x(ii)))
                not_found_yet = 0;
            end
        end
        
       if abs(max(consider)-min(consider)) < tol
           pointsfound(1,2) = ii;
           pointsfound(2,2) = x(ii);
       end
    else
        break
    end
end
end

