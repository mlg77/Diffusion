function [ pointsfound ] = Bifurcation_pointsToy( x,t,Z )
%Finds the bifurcation point of the toy model with only one
%   Takes in the zero diffusion Z, x vector and t vector
% 	Outputs: 	pointsfound(1,:) = index of bifurcation
%				pointsfound(2,:) = corosponding x value of bifurcation

tol = 0.01*(max(max(Z))-min(min(Z)));  % 1% tolerence
pointsfound = [];
for ii = length(x)-1:-1:1
    % Last 5% of the data for each line used to get rid of inital condition spike
    consider = Z(ii,floor(length(t)*0.5):end);
    if abs(max(consider)-min(consider)) < tol 
           pointsfound(1,1) = ii;
           pointsfound(2,1) = x(ii);
           break
    end
    
end
end

