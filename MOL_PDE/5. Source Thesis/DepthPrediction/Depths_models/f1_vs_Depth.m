% f1 vs depth 


clear; clc;

dir_source = 'C:\Temp\Diffusion\MOL_PDE\1. Source files\12. Aop';
dir_parent = 'C:\Temp\Diffusion\MOL_PDE\5. Source Thesis\DepthPrediction\Depths_models';
dir_save = 'C:\Temp\Diffusion\MOL_PDE\4. Output files\9. Depth';
dir_load = 'C:\Temp\Diffusion\MOL_PDE\4. Output files\7. Generate E';
figure();
%% Dupont
f1 = 0:0.001:0.5 ;
x = linspace(0, 0.499, 500);

cd(dir_load)
load('Dupont_E.mat')
cd(dir_parent)

depthV = [];
for ii = 1:length(f1)
    [ pathdata ] = itterDown( E, f1(ii), 0.2, P, x );
    depthV(ii) = pathdata.x(end);
end

figure(1);
plot(f1, depthV,'k-', 'linewidth', 2)
xlabel('f_1 required [-]')
ylabel('Depth Reached')
axis([0, 0.5, 0, 0.5])

cd([dir_save, '\f1'])
savefig(1, ['Dupont', '.fig'])
set(gcf,'PaperPositionMode','auto')
print(['Dupont'],'-dpng', '-r300')

cd(dir_save)
save('Dupont.mat',  'f1', 'depthV')
cd(dir_parent)
    
%% Gold
f1 = 0:0.001:0.5 ;
x = linspace(0, 0.499, 500);

cd(dir_load)
load('Goldbeter_E.mat')
cd(dir_parent)

depthV = [];
for ii = 1:length(f1)
    [ pathdata ] = itterDown( E, f1(ii), 0.2, P, x );
    depthV(ii) = pathdata.x(end);
end

figure(2);
plot(f1, depthV,'k-', 'linewidth', 2)
xlabel('f_1 required [-]')
ylabel('Depth Reached')
axis([0, 0.5, 0, 0.5])

cd([dir_save, '\f1'])
savefig(2, ['Gold', '.fig'])
set(gcf,'PaperPositionMode','auto')
print(['Gold'],'-dpng', '-r300')

cd(dir_save)
save('Gold.mat',  'f1', 'depthV')
cd(dir_parent)

%% Koe
f1 = 0:0.001:0.5 ;
x = linspace(0, 0.499, 500);

cd(dir_load)
load('Koe_E_Z.mat')
cd(dir_parent)

depthV = [];
for ii = 1:length(f1)
    [ pathdata ] = itterDown( flipud(E), f1(ii), 0.05, P, x );
    depthV(ii) = pathdata.x(end);
end

figure(3);
plot(f1, depthV,'k-', 'linewidth', 2)
xlabel('f_1 required [-]')
ylabel('Depth Reached')
axis([0, 0.5, 0, 0.5])

cd([dir_save, '\f1'])
savefig(3, ['Koe', '.fig'])
set(gcf,'PaperPositionMode','auto')
print(['Koe'],'-dpng', '-r300')

cd(dir_save)
save('Koe.mat',  'f1', 'depthV')
cd(dir_parent)

%% FHN
f1 = 0:0.001:0.5 ;
x = linspace(0, 0.499, 500);

cd(dir_load)
load('Fitz_E_W.mat')
cd(dir_parent)

depthV = [];
for ii = 1:length(f1)
    [ pathdata ] = itterDown( E, f1(ii), 0.75, P, x );
    depthV(ii) = pathdata.x(end);
end

figure(4);
plot(f1, depthV,'k-', 'linewidth', 2)
xlabel('f_1 required [-]')
ylabel('Depth Reached')
axis([0, 0.5, 0, 0.5])

cd([dir_save, '\f1'])
savefig(4, ['FHN', '.fig'])
set(gcf,'PaperPositionMode','auto')
print(['FHN'],'-dpng', '-r300')

cd(dir_save)
save('FHN.mat',  'f1', 'depthV')
cd(dir_parent)

%% Toy2
f1 = 0:0.001:0.5 ;
x = linspace(0, 0.499, 500);

cd(dir_load)
load('Toy2_E.mat')
cd(dir_parent)

depthV = [];
for ii = 1:length(f1)
    [ pathdata ] = itterDown( E, f1(ii), 0.2, P, x );
    depthV(ii) = pathdata.x(end);
end

figure(5);
plot(f1, depthV,'k-', 'linewidth', 2)
xlabel('f_1 required [-]')
ylabel('Depth Reached')
axis([0, 0.5, 0, 0.5])

cd([dir_save, '\f1'])
savefig(5, ['Toy2', '.fig'])
set(gcf,'PaperPositionMode','auto')
print(['Toy2'],'-dpng', '-r300')

cd(dir_save)
save('Toy2.mat',  'f1', 'depthV')
cd(dir_parent)

