% Bifurcations
clear; clc; close all
cur = pwd;
cd('C:\Users\mlg77\Local Documents\5. Current working\Bifurcations\axis')
%% Goldbeter Z
figure('rend','painters','pos',[10 10 900*0.75 500*0.75])
plot([1], [1])
axis([0,1,0,1.5])
xlabel('Beta, \beta')
ylabel('Concentration, Z, [\mu M]')

set(gcf,'PaperPositionMode','auto')
print(['axis_Gold_Z'],'-dpng', '-r300')

%% Goldbeter Y
figure('rend','painters','pos',[10 10 900*0.75 500*0.75])
plot([1], [1])
axis([0	1	5.00E-01	2.25E+00])
xlabel('Beta, \beta')
ylabel('Concentration, Y, [\mu M]')

set(gcf,'PaperPositionMode','auto')
print(['axis_Gold_Y'],'-dpng', '-r300')

%% Dupont Z
figure('rend','painters','pos',[10 10 900*0.75 500*0.75])
plot([1], [1])
axis([0.00	1.00	0.00	2.00])
xlabel('Beta, \beta')
ylabel('Concentration, Z, [\mu M]')

set(gcf,'PaperPositionMode','auto')
print(['axis_Dup_Z'],'-dpng', '-r300')

%% Dupont Y
figure('rend','painters','pos',[10 10 900*0.75 500*0.75])
plot([1], [1])
axis([0.00	1.00	0.50	4.50])
xlabel('Beta, \beta')
ylabel('Concentration, Y, [\mu M]')

set(gcf,'PaperPositionMode','auto')
print(['axis_Dup_Y'],'-dpng', '-r300')

%% Ern Z
figure('rend','painters','pos',[10 10 900*0.75 500*0.75])
plot([1], [1])
axis([0.00	1.00	0.00	0.80])
xlabel('Beta, \beta')
ylabel('Concentration,  Z, [\mu M]')

set(gcf,'PaperPositionMode','auto')
print(['axis_Ern_Z'],'-dpng', '-r300')

%% Ern V
figure('rend','painters','pos',[10 10 900*0.75 500*0.75])
plot([1], [1])
axis([0.00	1.00	-70.00	0.00])
xlabel('Beta, \beta')
ylabel('Membrane Potential,  V, [mV]')

set(gcf,'PaperPositionMode','auto')
print(['axis_Ern_V'],'-dpng', '-r300')

%% Ern N
figure('rend','painters','pos',[10 10 900*0.75 500*0.75])
plot([1], [1])
axis([0.00	1.00	0.00	0.50])
xlabel('Beta, \beta')
ylabel('Probability,  N, [-]')

set(gcf,'PaperPositionMode','auto')
print(['axis_Ern_N'],'-dpng', '-r300')

%% Koe Z
figure('rend','painters','pos',[10 10 900*0.75 500*0.75])
plot([1], [1])
axis([0.00	1.00	0.00	0.90])
xlabel('Beta, \beta')
ylabel('Concentration,  Z, [\mu M]')

set(gcf,'PaperPositionMode','auto')
print(['axis_Koe_Z'],'-dpng', '-r300')

%% Koe Y
figure('rend','painters','pos',[10 10 900*0.75 500*0.75])
plot([1], [1])
axis([0.00	1.00	0.30	1.40])
xlabel('Beta, \beta')
ylabel('Concentration,  Y, [\mu M]')

set(gcf,'PaperPositionMode','auto')
print(['axis_Koe_Y'],'-dpng', '-r300')

%% Koe V
figure('rend','painters','pos',[10 10 900*0.75 500*0.75])
plot([1], [1])
axis([0.00	1.00	-60.00	-30.00])
xlabel('Beta, \beta')
ylabel('Membrane Potential,  V, [mV]')

set(gcf,'PaperPositionMode','auto')
print(['axis_Koe_V'],'-dpng', '-r300')

%% Koe N
figure('rend','painters','pos',[10 10 900*0.75 500*0.75])
plot([1], [1])
axis([0.00	1.00	0.00	0.30])
xlabel('Beta, \beta')
ylabel('Probability,  N, [-]')

set(gcf,'PaperPositionMode','auto')
print(['axis_Koe_N'],'-dpng', '-r300')


%% FHN W
figure('rend','painters','pos',[10 10 900*0.75 500*0.75])
plot([1], [1])
axis([0.00	2.00	-2.00	2.00])
xlabel('Beta, \beta')
ylabel('Electrical Potential')

set(gcf,'PaperPositionMode','auto')
print(['axis_FHN_W'],'-dpng', '-r300')

%% FHN U
figure('rend','painters','pos',[10 10 900*0.75 500*0.75])
plot([1], [1])
axis([0.00	2.00	-1.00	3.00])
xlabel('Beta, \beta')
ylabel('Recovery Voltage')

set(gcf,'PaperPositionMode','auto')
print(['axis_FHN_U'],'-dpng', '-r300')


%% Goldbeter Z
figure('rend','painters','pos',[10 10 900*0.75 500*0.75])
plot([1], [1])
axis([0.00	1.00	0.00	3.00])
xlabel('Beta, \beta')
ylabel('Period, [s]')

set(gcf,'PaperPositionMode','auto')
print(['axis_Gold_T'],'-dpng', '-r300')

%% Dupont Z
figure('rend','painters','pos',[10 10 900*0.75 500*0.75])
plot([1], [1])
axis([0.00	1.00	0.00	5.00])
xlabel('Beta, \beta')
ylabel('Period, [s]')

set(gcf,'PaperPositionMode','auto')
print(['axis_Dup_T'],'-dpng', '-r300')


%% Koe Z
figure('rend','painters','pos',[10 10 900*0.75 500*0.75])
plot([1], [1])
axis([0.00	1.00	5.00	40.00])
xlabel('Beta, \beta')
ylabel('Period, [s]')

set(gcf,'PaperPositionMode','auto')
print(['axis_Koe_T'],'-dpng', '-r300')


%% FHN W
figure('rend','painters','pos',[10 10 900*0.75 500*0.75])
plot([1], [1])
axis([0.00	2.00	0.00	70.00])
xlabel('Beta, \beta')
ylabel('Period, [s]')

set(gcf,'PaperPositionMode','auto')
print(['axis_FHN_T'],'-dpng', '-r300')

%% Ern T
figure('rend','painters','pos',[10 10 900*0.75 500*0.75])
plot([1], [1])
axis([0.00	1.00	0.00	14.00])
xlabel('Beta, \beta')
ylabel('Period, [s]')

set(gcf,'PaperPositionMode','auto')
print(['axis_Ern_T'],'-dpng', '-r300')


cd(cur)

close all



