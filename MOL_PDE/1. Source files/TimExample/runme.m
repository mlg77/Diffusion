%The runme file for the Goldbeter equations
%using the format recomended by Richard
clc
clear
%close all
beta = 0.9;
fn = Goldbeter(beta);
fn = Toy(beta);

y0 = [0;0];

[T,Y]=ode15s(fn,[0 50],y0);
plot(T,Y)

