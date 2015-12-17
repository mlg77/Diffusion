function [ mysigma] = Solve_noinv( FullA, b, mysigma )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
 %% Solve with no inv
    r = b - FullA*mysigma;
    p = r;
    for loop = 1:80
%         mysigmasave(:,loop) = mysigma;
        myalpha = sum(r.^2)/(p'*FullA*p);
        mysigma = mysigma + myalpha*p;
        r2 = b - FullA*mysigma;
        if max(abs(r2)) < 1e-3
            break
%         elseif max(abs(mysigma))> 80
%             problem_var = find(abs(mysigma) > 80);
%             r2_considered = r2;
%             r2_considered(problem_var) = 0; 
%             if  max(abs(r2_considered)) < 1e-3
%                  break
%             end
        end    
        B = sum(r2.^2)/sum(r.^2);
        p = r2 + B*p;
        r = r2;
    end
    if loop>79
        max(mysigma)
        error('Need more inner loops')
    end
end

