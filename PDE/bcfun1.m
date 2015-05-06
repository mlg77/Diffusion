function [ p1, q1, pr, qr ] = bcfun1( x1,u1,xr, ur, t )
%bcfun1 the partial differential equations, boundry conditions
%   Attempt 1 
%   Michelle Goodman
%   21/4/2015

p1 = [0;0];
q1 = [1;1];
pr = [u1(1)-ur(1);u1(2)-ur(2)];
qr = [0;0];

end

