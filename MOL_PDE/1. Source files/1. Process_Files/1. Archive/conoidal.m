n2 = 0;
H = 1;
mlamba = 5;


x = 0:0.01:3;
mpos = [2, 1.25, 1.11, 1.052, 1.0101, 1.001];
for i = 1./mpos
    m = i
    funct = @(x) 1./sqrt(1-m.^2.*sin(x));
    K = integral(funct, 0, 2*pi);
    fsurf = n2 + H*sech(2*K*((x)/(mlamba))).^2;

    plot(x, fsurf)
    hold on
    pause()
end

plot(x, 0.5*(cos(x*2*pi/mlamba)+1), 'k','linewidth', 2)