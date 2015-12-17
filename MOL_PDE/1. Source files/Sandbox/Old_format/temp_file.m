clear; clc; close all

[X,Y] = meshgrid(-2:0.25:2,-1:0.2:1);
T = 0:0.1:2;
F = cell(length(T), 1);
for k = 1 : length(T)
     Z = T(k)*X.* exp(-X.^2 - Y.^2);
     F{k} = sprintf('data.%d.vtu', k-1); % output will be 'data.0.vtu', data.1.vtu' etc
     TRI = delaunay(X,Y);
     TRI = sortrows(TRI,[1 2]);
     vtktrisurf(TRI,X,Y,Z,'pressure',F{k});
end
vtkseries(T, F, 'datatimeseries.pvd');

% x = 1:9;
% y = 1:9;
% z = 0*[1:9];
% 
% u = ones(1,9);
% v= ones(1,9);
% w= zeros(1,9);
% 
% r = zeros(1,9);
% 
% vtkwrite('test.vtu','unstructured_grid',x,y,z,'vectors','vectors1',u,v,w,'scalars', 'scalers1',r)