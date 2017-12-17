function [ tempE ] = ReorderE( E, mybeta, newbeta )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

tempE = nan(length(newbeta), size(E, 2));
for ii = 1:length(newbeta)
    idx_b = find(mybeta>= newbeta(ii), 1);
       
    if isempty(idx_b )
        
    else
        vq = interp1(mybeta,E,newbeta(ii));
%         tempE(ii, 1:end) = E(idx_b, :);
        tempE(ii, 1:end) = vq;
    end
    
end


end

