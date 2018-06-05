% Main Run Pauls Toy Model

clear; clc; close all



%mybeta = -0.1; myxi = -0.1;
mybetav = [0.05,0.015,0.07,100]; 
myxiv = [-0.3,-0.1,0.1,0.3];

for ii = 1:4
    for jj = 1:4
        mybeta = mybetav(ii);
        myxi = myxiv(jj);
        [t, y] = ode45(@(t,y) odefun_Toy3(t,y,mybeta,1, 0, myxi), [0:0.01:500], [-2,-2]);
        Z = y(:, 1)';
        Y = y(:, 2)';
        subplot(4,4,(ii-1)*4+jj)
        plot(t,Z, t,Y)
        %pause()
        title(['\beta = ', num2str(mybeta), ' \xi = ', num2str(myxi)])
    end
end
