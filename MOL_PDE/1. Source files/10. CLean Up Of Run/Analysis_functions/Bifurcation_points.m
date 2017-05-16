function [ pointsfound ] = Bifurcation_points( x,t,Z )
%Finds the upper and lower bifurcation points if they exist
%   Takes in the zero diffusion Z, x vector and t vector
% 	Outputs: 	pointsfound(1,:) = index of bifurcation
%				pointsfound(2,:) = corosponding x value of bifurcation

tol = 0.01*max(max(Z));  % 1% tolerence
pointsfound = [];
for ii = 1:length(x)
    % Last 5% of the data for each line used to get rid of inital condition spike
    consider = Z(ii,:);
    if isempty(pointsfound)
       if abs(max(consider)-min(consider)) > tol % If ii = 1 or 2 then no lower bifurcation found
           pointsfound(1,1) = ii;
           pointsfound(2,1) = x(ii);
       end
    elseif size(pointsfound, 2) == 1
       if abs(max(consider)-min(consider)) < tol % Will only find the second if there is one 
           pointsfound(1,2) = ii;
           pointsfound(2,2) = x(ii);
       end
    else
        break
    end
end
end

