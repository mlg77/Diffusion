%   Calculates the non linear concentration rates for the calciun in the
%   cytocol, Z, the calcium in the stores, and the membrain potential.
%   where beta is a spatially varying variable 
clear
clc
close all
dt = 1e-3; t_end = 20;
dx = 1e-3;  
x = 0:dx:1;  M = length(x);
t = 0:dt:t_end;   N = length(t);
mybeta = (0.5*(1+tanh((x-0.5)/0.5)))';

coeff_A = [-171.773675347487,403.127438242869,-372.247416821044,166.295691367025,-34.4458040831343,2.73510445037581;-90.8736195227281,222.683603507953,-207.844879821320,88.8214258506532,-16.2024499495799,1.03927600567759;-44.2802277496113,74.7734470935165,-28.2191176902882,-14.0565862668222,11.1819355998314,-1.70066622398168];
coeff_f = [1022.34952099180,-2510.98919343174,2417.42011886330,-1141.56128742845,271.675687994414,-25.4773298830170;1866.60325251365,-4575.04770330349,4395.69020610544,-2072.06864552119,493.748509476929,-46.3913779578370;1947.24232671666,-4752.97317000380,4549.25145127709,-2139.23847445029,516.228565685244,-49.2809483294809];
Amp = zeros(M,3);
f = zeros(M,3);

for i = 1:5
    Amp(:,1) = Amp(:,1) + coeff_A(1,i)*mybeta.^(5-i);
    Amp(:,2) = Amp(:,2) + coeff_A(2,i)*mybeta.^(5-i);
    Amp(:,3) = Amp(:,3) + coeff_A(3,i)*mybeta.^(5-i);

    f(:,1) = f(:,1) + coeff_A(1,i)*mybeta.^(5-i);
    f(:,2) = f(:,2) + coeff_A(2,i)*mybeta.^(5-i);
    f(:,3) = f(:,3) + coeff_A(3,i)*mybeta.^(5-i);
end

for i = 1:M
    Z(i, :) = Amp(i,1)*sin(2*pi*f(i,1)*t)+ Amp(i,2)*sin(2*pi*f(i,2)*t) + Amp(i,3)*sin(2*pi*f(i,3)*t);
end

imagesc(t,x,Z)
% set(gca,'YDir','normal')
        xlabel('Time, [s]')
        ylabel('Position, x')
        title('Z, Calcium Concentration in the Cytosol made up by me, [\muM]')
        colormap jet
        hold on



