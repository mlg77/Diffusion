% Bifurcations
clear; clc; close all
cur = pwd;
cd('C:\Users\mlg77\Local Documents\5. Current working\Bifurcations\axis')
%% Toy1
figure()
plot([1], [1])
axis([0.50	1.50	-2.00	0.50])
xlabel('Beta, \beta')
ylabel('\Phi, [-]')

set(gcf,'PaperPositionMode','auto')
print(['axis_T1'],'-dpng', '-r300')

%% Toy2
figure()
plot([1], [1])
axis([0.10	0.30	-2.50	2])
xlabel('Beta, \beta')
ylabel('\Phi, [-]')

set(gcf,'PaperPositionMode','auto')
print(['axis_T2'],'-dpng', '-r300')

%% Toy3
figure()
plot([1], [1])
axis([0.10	0.80	-2.50	2.00])
xlabel('Beta, \beta')
ylabel('\Phi, [-]')

set(gcf,'PaperPositionMode','auto')
print(['axis_T3_all'],'-dpng', '-r300')

%% Toy1T
figure()
plot([1], [1])
axis([0.50	1.50	0, 7])
xlabel('Beta, \beta')
ylabel('Time')

set(gcf,'PaperPositionMode','auto')
print(['axis_T1_T'],'-dpng', '-r300')

%% Toy2
figure()
plot([1], [1])
axis([0.10	0.30	0, 130])
xlabel('Beta, \beta')
ylabel('Time')

set(gcf,'PaperPositionMode','auto')
print(['axis_T2_T'],'-dpng', '-r300')


cd(cur)

close all



