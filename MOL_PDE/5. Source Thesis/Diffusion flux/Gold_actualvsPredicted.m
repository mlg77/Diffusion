
clear; clc; close all
load('C:\Temp\Diffusion\MOL_PDE\4. Output files\2. PDE_Results\2. Goldbeter\DataPDE2.mat')


dir_source = 'C:\Temp\Diffusion\MOL_PDE\1. Source files\10. CLean Up Of Run';
dir_parent = 'C:\Temp\Diffusion\MOL_PDE\5. Source Thesis';
dir_save = 'C:\Temp\Diffusion\MOL_PDE\4. Output files\12. Diffusion Flux';

cd(dir_source);

J_D = zeros(size(Z));
M = length(x);
for ii = 1:length(t)
    y = [];
    y(1:M) = Z(:,ii);
    y(M+1:2*M) = V(:,ii);
    y(2*M+1:3*M) = Y(:,ii);
    [ dydt , L_Z, L_Y, d2Zdx2, v_2, v_3] = odefun_Goldbeter( t, y' , mybeta, 1, D);
    J_D(:, ii) = d2Zdx2;
end
point_care = 301;
figure()
plot(t, J_D(point_care,:))
axis([10,20,-8,5])

load('C:\Temp\Diffusion\MOL_PDE\4. Output files\1. ODE_Bifurcations\2. Goldbeter\DataBi.mat')

for ii = [0.05,0.1]
figure()
tshift = floor(find(t>=ii,1));
z_current = Z(point_care, 1+tshift:end-tshift);
z_next = Z(point_care, 1:end-2*(tshift));
z_prev = Z(point_care, 1+2*(tshift):end);
fluxrough = (D/((1e-3)^2)) * (-2*z_current +z_next   + z_prev);
plot(t(1+tshift:end-tshift), fluxrough)
axis([20,30,-10,5])
end

figure(99)


return

cd(dir_save)
for i = [2,11]%[1, 12]
figure(i)
set(gcf,'PaperPositionMode','auto')
print(['first_results_', num2str(i)],'-dpng', '-r300')
end

