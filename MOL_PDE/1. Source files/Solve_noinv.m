function [ sigma] = Solve_noinv( FullA, b, sigma )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
 %% Solve with no inv
    r = b - FullA*sigma;
    p = r;
    for loop = 1:20
        alpha = sum(r.^2)/(p'*FullA*p);
        sigma = sigma + alpha*p;
        r2 = b - FullA*sigma;
        if max(abs(r2)) < 1e-10
            break
        end    
        B = sum(r2.^2)/sum(r.^2);
        p = r2 + B*p;
        r = r2;
    end

end

