%% Plot First basic plots
% Bifurcation zero diffusion, fickian diffusion, actual wave shape

%% File Location
AllDir.ParentDir = 'C:\Temp\Diffusion\MOL_PDE\';
AllDir.SourceDir = '1. Source files\13. WaveShapePaper\';
AllDir.SaveDir = '4. Output files\WaveShapePaper';

load_or_not = 1;
if load_or_not == 1
    cd([AllDir.ParentDir , AllDir.SaveDir ])
    load('All_run_data')
    cd([AllDir.ParentDir , AllDir.SourceDir ])

end
close all
%% Fig 1- 4: Dupont
figure(1) % Zero Diffusion
imagesc(Dupont.t,flipud(Dupont.x),Dupont.Z0D); hold on
plot([Dupont.t(1), Dupont.t(end)],[0.5, 0.5], 'k', 'linewidth', 2)
set(gca,'YDir','normal')
xlabel('Time, [s]')
ylabel('Position, x, [cm]')
title('Zero diffusion')
colormap jet
axis([0,60,0,1])
hold on
colorbar

figure(2) % Fickian Diffusion
imagesc(Dupont.t,flipud(Dupont.x),Dupont.ZFD); hold on
plot([Dupont.t(1), Dupont.t(end)],[0.5, 0.5], 'k', 'linewidth', 2)
set(gca,'YDir','normal')
xlabel('Time, [s]')
ylabel('Position, x, [cm]')
title('Fickian diffusion')
colormap jet
axis([0,60,0,1])
hold on
colorbar

figure(3) % Wave Shape
[PKS,LOCS] = findpeaks(-1*Dupont.Z0D(521, :)); % find mins
plot(Dupont.t(LOCS(end-2): LOCS(end-1)),Dupont.Z0D(521, LOCS(end-2): LOCS(end-1)), 'k', 'linewidth', 2); hold on
[Ymax,Imax] = max(Dupont.Z0D(521, LOCS(end-2): LOCS(end-1)));
[Ymin,Imin] = min(Dupont.Z0D(521, LOCS(end-2): LOCS(end-1)));
tims_cycle = Dupont.t(LOCS(end-2): LOCS(end-1));
plot(tims_cycle(Imax)*[1,1],[Ymax, Ymin], ':k', 'linewidth', 2)
xlabel('Time, [s]')
ylabel('Concentration [\muM]')

figure(4) % Bifurcation
maxline = max(Dupont.ZBD(:, 10000:end)')';
minline = min(Dupont.ZBD(:, 10000:end)')';
plot(Dupont.mybetaB, maxline,  'k', 'linewidth', 2); hold on
plot(Dupont.mybetaB, minline,  'k', 'linewidth', 2)
xlabel('Beta \beta [-]')
ylabel('Concentration [\muM]')

%% Fig 5- 8: Ernmentrout
figure(5) % Zero Diffusion
imagesc(Ernmentrout.t,flipud(Ernmentrout.x),Ernmentrout.Z0D); hold on
plot([Ernmentrout.t(1), Ernmentrout.t(end)],[0.5, 0.5], 'k', 'linewidth', 2)
set(gca,'YDir','normal')
xlabel('Time, [s]')
ylabel('Position, x, [cm]')
title('Zero diffusion')
colormap jet
hold on
colorbar

figure(6) % Fickian Diffusion
imagesc(Ernmentrout.t,flipud(Ernmentrout.x),Ernmentrout.ZFD); hold on
plot([Ernmentrout.t(1), Ernmentrout.t(end)],[0.5, 0.5], 'k', 'linewidth', 2)
set(gca,'YDir','normal')
xlabel('Time, [s]')
ylabel('Position, x, [cm]')
title('Fickian diffusion')
colormap jet
hold on
colorbar

figure(7) % Wave Shape
[PKS,LOCS] = findpeaks(-1*Ernmentrout.Z0D(521, :)); % find mins
plot(Ernmentrout.t(LOCS(end-2): LOCS(end-1)),Ernmentrout.Z0D(521, LOCS(end-2): LOCS(end-1)), 'k', 'linewidth', 2); hold on
[Ymax,Imax] = max(Ernmentrout.Z0D(521, LOCS(end-2): LOCS(end-1)));
[Ymin,Imin] = min(Ernmentrout.Z0D(521, LOCS(end-2): LOCS(end-1)));
tims_cycle = Ernmentrout.t(LOCS(end-2): LOCS(end-1));
plot(tims_cycle(Imax)*[1,1],[Ymax, Ymin], ':k', 'linewidth', 2)
xlabel('Time, [s]')
ylabel('Concentration [\muM]')

figure(8) % Bifurcation
maxline = max(Ernmentrout.ZBD(:, 5000:end)')';
minline = min(Ernmentrout.ZBD(:, 5000:end)')';
plot(Ernmentrout.mybetaB, maxline,  'k', 'linewidth', 2); hold on
plot(Ernmentrout.mybetaB, minline,  'k', 'linewidth', 2)
xlabel('Beta \beta [-]')
ylabel('Concentration [\muM]')

%% Fig 9- 12: Fitz
figure(9) % Zero Diffusion
imagesc(FitzHugh.t,flipud(FitzHugh.x),FitzHugh.Z0D); hold on
plot([FitzHugh.t(1), FitzHugh.t(end)],[0.5, 0.5], 'k', 'linewidth', 2)
set(gca,'YDir','normal')
xlabel('Time, [s]')
ylabel('Position, x, [cm]')
title('Zero diffusion')
axis([0,1000,0,1]);
colormap jet
hold on
colorbar

figure(10) % Fickian Diffusion
imagesc(FitzHugh.t,flipud(FitzHugh.x),FitzHugh.ZFD); hold on
plot([FitzHugh.t(1), FitzHugh.t(end)],[0.5, 0.5], 'k', 'linewidth', 2)
set(gca,'YDir','normal')
xlabel('Time, [s]')
ylabel('Position, x, [cm]')
title('Fickian diffusion')
axis([0,1000,0,1]);
colormap jet
hold on
colorbar

figure(11) % Wave Shape
[PKS,LOCS] = findpeaks(-1*FitzHugh.Z0D(521, :)); % find mins
plot(FitzHugh.t(LOCS(end-2): LOCS(end-1)),FitzHugh.Z0D(521, LOCS(end-2): LOCS(end-1)), 'k', 'linewidth', 2); hold on
[Ymax,Imax] = max(FitzHugh.Z0D(521, LOCS(end-2): LOCS(end-1)));
[Ymin,Imin] = min(FitzHugh.Z0D(521, LOCS(end-2): LOCS(end-1)));
tims_cycle = FitzHugh.t(LOCS(end-2): LOCS(end-1));
plot(tims_cycle(Imax)*[1,1],[Ymax, Ymin], ':k', 'linewidth', 2)
xlabel('Time, [s]')
ylabel('Concentration [\muM]')

figure(12) % Bifurcation
maxline = max(FitzHugh.ZBD(:, 5000:end)')';
minline = min(FitzHugh.ZBD(:, 5000:end)')';
plot(FitzHugh.mybetaB, maxline,  'k', 'linewidth', 2); hold on
plot(FitzHugh.mybetaB, minline,  'k', 'linewidth', 2)
xlabel('Beta \beta [-]')
ylabel('Concentration [\muM]')

%% Fig 13- 16: Toy1
figure(13) % Zero Diffusion
imagesc(Toy1.t,flipud(Toy1.x),Toy1.Z0D); hold on
plot([Toy1.t(1), Toy1.t(end)],[0.5, 0.5], 'k', 'linewidth', 2)
set(gca,'YDir','normal')
xlabel('Time, [s]')
ylabel('Position, x, [cm]')
title('Zero diffusion')
axis([0,150,0,1]);
colormap jet
hold on
colorbar

figure(14) % Fickian Diffusion
imagesc(Toy1.t,flipud(Toy1.x),Toy1.ZFD); hold on
plot([Toy1.t(1), Toy1.t(end)],[0.5, 0.5], 'k', 'linewidth', 2)
set(gca,'YDir','normal')
xlabel('Time, [s]')
ylabel('Position, x, [cm]')
title('Fickian diffusion')
colormap jet
axis([0,150,0,1]);
hold on
colorbar

figure(15) % Wave Shape
[PKS,LOCS] = findpeaks(-1*Toy1.Z0D(521, :)); % find mins
plot(Toy1.t(LOCS(end-2): LOCS(end-1)),Toy1.Z0D(521, LOCS(end-2): LOCS(end-1)), 'k', 'linewidth', 2); hold on
[Ymax,Imax] = max(Toy1.Z0D(521, LOCS(end-2): LOCS(end-1)));
[Ymin,Imin] = min(Toy1.Z0D(521, LOCS(end-2): LOCS(end-1)));
tims_cycle = Toy1.t(LOCS(end-2): LOCS(end-1));
plot(tims_cycle(Imax)*[1,1],[Ymax, Ymin], ':k', 'linewidth', 2)
xlabel('Time, [s]')
ylabel('Concentration \Phi')

figure(16) % Bifurcation
maxline = max(Toy1.Z0D(:, 5000:end)')';
minline = min(Toy1.Z0D(:, 5000:end)')';
plot(Toy1.mybeta, maxline,  'k', 'linewidth', 2); hold on
plot(Toy1.mybeta, minline,  'k', 'linewidth', 2)
xlabel('Beta \beta [-]')
ylabel('Concentration \Phi')

%% Fig 17- 20: Toy2
figure(17) % Zero Diffusion
imagesc(Toy2.t,flipud(Toy2.x),Toy2.Z0D); hold on
plot([Toy2.t(1), Toy2.t(end)],[0.5, 0.5], 'k', 'linewidth', 2)
set(gca,'YDir','normal')
xlabel('Time, [s]')
ylabel('Position, x')
title('Zero diffusion')
colormap jet
hold on
colorbar

figure(18) % Fickian Diffusion
imagesc(Toy2.t,flipud(Toy2.x),Toy2.ZFD); hold on
plot([Toy2.t(1), Toy2.t(end)],[0.5, 0.5], 'k', 'linewidth', 2)
set(gca,'YDir','normal')
xlabel('Time, [s]')
ylabel('Position, x, [cm]')
title('Fickian diffusion')
colormap jet
hold on
colorbar

figure(19) % Wave Shape
[PKS,LOCS] = findpeaks(-1*Toy2.Z0D(521, :)); % find mins
plot(Toy2.t(LOCS(end-2): LOCS(end-1)),Toy2.Z0D(521, LOCS(end-2): LOCS(end-1)), 'k', 'linewidth', 2); hold on
[Ymax,Imax] = max(Toy2.Z0D(521, LOCS(end-2): LOCS(end-1)));
[Ymin,Imin] = min(Toy2.Z0D(521, LOCS(end-2): LOCS(end-1)));
tims_cycle = Toy2.t(LOCS(end-2): LOCS(end-1));
plot(tims_cycle(Imax)*[1,1],[Ymax, Ymin], ':k', 'linewidth', 2)
xlabel('Time, [s]')
ylabel('Concentration \Phi')

figure(20) % Bifurcation
maxline = max(Toy2.ZBD(:, 10000:end)')';
minline = min(Toy2.ZBD(:, 10000:end)')';
plot(Toy2.mybeta, maxline,  'k', 'linewidth', 2); hold on
plot(Toy2.mybeta, minline,  'k', 'linewidth', 2)
xlabel('Beta \beta [-]')
ylabel('Concentration \Phi')

%% Plotting for report
Ifsave = 0;
if Ifsave == 1
    cd('C:\Users\mlg77\Local Documents\Git\MG_PhD_Thesis\5. Toy Model Paper\NewFormat\fig\Results')
    for ii = 1:20
        figure(ii)
        grid on
        title('')
        set(gcf,'PaperPositionMode','auto')
        print(['first_results_', num2str(ii)],'-dpng', '-r300')
    end
end