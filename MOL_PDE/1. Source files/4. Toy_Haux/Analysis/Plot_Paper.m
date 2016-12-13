% Plot Homogenisation Paper
% C:\Temp\Diffusion\MOL_PDE\4. Output files\Figurers_Tim\HomoPaperDec2016
% Plot Toymodel symetric 
close all

figure(1)
h = imagesc(t,x,Z0D);
set(gca,'YDir','normal')
xlabel('Time, [s]')
ylabel('Position, x')
colormap jet
colorbar
hold on

figure(2)
h = imagesc(t,x,ZFD);
set(gca,'YDir','normal')
xlabel('Time, [s]')
ylabel('Position, x')
colormap jet
colorbar
hold on

cd('C:\Temp\Diffusion\MOL_PDE\4. Output files\Figurers_Tim\HomoPaperDec2016')

for i = 1:2
figure(i)
set(gcf,'PaperPositionMode','auto')
print(['Symetric Diffusion', num2str(i)],'-dpng', '-r300')
end

figure(3)
hold on
plot(t(1:0.5e4),Z0D(600, 1:0.5e4))
plot(t(1:0.5e4),V0D(600, 1:0.5e4))
xlabel('Time [s]')
ylabel('\phi (t), \psi (t)')
legend('\phi (t)', '\psi (t)')

