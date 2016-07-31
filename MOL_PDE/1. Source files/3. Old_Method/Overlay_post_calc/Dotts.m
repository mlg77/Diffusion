function [ peek ] = Dotts( Z )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

Z(find(Z<0.6)) = 0;
Z = sparse(Z);

[t_po,x_po,Val] = find(Z);

to_sort =[t_po,x_po,Val];
sortedZ = sortrows(to_sort, [1,2]);
Row_indx = unique(sortedZ(:,1));

count = 1;
peek = [];
for i = 1:length(Row_indx) % Loop through the rows
    NoPtsInRow = length(find(sortedZ(:,1) == Row_indx(i) ));
    begpt = find(sortedZ(:,1)==Row_indx(i),1);
    hpbegpt = find(sortedZ(:,1)==Row_indx(i),1);
    for j = 1: NoPtsInRow-1 % Loop through the colums -1
        if abs(sortedZ(begpt+j-1,2)-sortedZ(begpt+j,2))> 1 
            SomewhereInHere = sortedZ(hpbegpt:begpt+j-1,:);
            peek(count,:) = SomewhereInHere(find(round(SomewhereInHere(:,3)*10000)==round(max(SomewhereInHere(:,3))*10000),1),:);
            count = count+1;
            hpbegpt = begpt+j-1;
        end
        if j == NoPtsInRow-1
            SomewhereInHere = sortedZ(hpbegpt:begpt+j,:);
            peek(count,:) = SomewhereInHere(find(round(SomewhereInHere(:,3)*10000)==round(max(SomewhereInHere(:,3))*10000),1),:);
            count = count+1;
        end
    end
end

end

