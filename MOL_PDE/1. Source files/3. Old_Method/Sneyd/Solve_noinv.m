function [ mysigma] = Solve_noinv( FullA, b, mysigma )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
 %% Solve with no inv
    r = b - FullA*mysigma;
    p = r;
    for loop = 1:40
        myalpha = sum(r.^2)/(p'*FullA*p);
        mysigma = mysigma + myalpha*p;
        r2 = b - FullA*mysigma;
        if max(abs(r2)) < 1e-5
            break
        end    
        B = sum(r2.^2)/sum(r.^2);
        p = r2 + B*p;
        r = r2;
    end
    if loop>39
        loop
        error('Need more inner loops')
    end
end

