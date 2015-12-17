function [ CellsGrid ] = tempSquareGridder( X, Y )
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here

M1 = size(X,1);
M2 = size(X,2);
[a,b] = meshgrid(1:M2, 1:M1);
NP = b+(a-1)*M1;

CellsGrid = zeros((M1-1)*(M2-1),4);

count = 0;
for i = 1:M1-1 % 11 
    for j = 1:M2-1 % 17
        count = count+1;
        CellsGrid(count,:) = [NP(i,j), NP(i+1,j), NP(i+1,j+1), NP(i,j+1)];
    end
end

end

