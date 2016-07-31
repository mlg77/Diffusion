% Slope at wave end type Attempt number 2
% Author Michelle Goodman
% Date 18/05/16

x_look = find(x>0.14,1):find(x>0.246,1); % 1e-3 linear D
t_look = find(t>4,1):find(t>25,1);

x_look = find(x>0.10,1):find(x>0.246,1);% 1e-4 linear D
t_look = find(t>3,1):find(t>25,1);

x_look = find(x>0.16,1):find(x>0.7,1);% All
t_look = find(t>0,1):find(t>8,1);

tlook = t(t_look);
Z_iti_sect = Z(x_look, t_look);
D_iti_sect = d2Zdx2(x_look, t_look);
t_to_close = 1000;
% imagesc(Z_iti_sect)
% Find the peeks of the diffusion against the location of them
% And the Peeks in the concentration.
peaksZ = []; locZ = []; 
peaksD = []; locD = []; 
count = 0;
for i = 1:length(x_look) % Loop up through x points
    count = count + 1;
    [pks, loc] = findpeaks(D_iti_sect(i, :));
    peaksD(count, 1:length(pks)) = pks;
    locD(count, 1:length(pks)) = loc;
    
    
    [pks, loc] = findpeaks(Z_iti_sect(i, :));
    peaksZ(count, 1:length(pks)) = pks;
    locZ(count, 1:length(pks)) = loc;
    
end

locZ(find(peaksZ==0)) = 1;
peaksZ(find(peaksZ==0)) = nan;

one_end = [];
for i = 1:size(locZ,2) % loop through the waves
    for j = 2:size(locZ,1) % Loop through the wave
       if locZ(j,i) == 1
           one_end(i) = j;
       end
    end
    locZ(1:one_end(i),i) = 1;
    peaksZ(1:one_end(i),i) = nan;
end

close(figure(2))
figure(2)
subplot(2,2,1)
hold on
num_wave = 1:8; 
for i = num_wave
    plot(tlook(locZ(:, i)), peaksZ(:, i))
    txt1 = ['\leftarrow#', num2str(i)];
    suit_pt = one_end(i)+4;
    text(tlook(locZ(suit_pt, i)), peaksZ(suit_pt, i),txt1)
end
grid on
xlabel('Time, [s]'); ylabel('Calcium Concentration [\mu M]')
title('Max Concentration height of wave over time near end')

%% Find gradient dx/dt of each wave
% dx between position data is constant
% dt between time data is constant
grad_wave = dx./((locZ(2:end, :) - locZ(1:end-1, :)).*dt);
grad_wave = 3*dx./((locZ(4:end, :) - locZ(1:end-3, :)).*dt); % Smooth
subplot(2,2,2)
hold on
num_wave = 1:8; 
grad_wave(find(grad_wave==inf)) = nan;
for i = num_wave
    grad_wave(one_end(i), i) = nan;
    plot(tlook(locZ(2:end-2, i)), grad_wave(:, i))
    txt1 = ['\leftarrow#', num2str(i)];
    suit_pt = one_end(i)+4;
    text(tlook(locZ(suit_pt, i)), grad_wave(suit_pt, i),txt1)
end
grid on
xlabel('Time, [s]'); ylabel('Gradient dx/dt')
title('Gradient of max concentration of wave')

subplot(2,1,2)
hold on
mycol = 'gbrcmykb';
for i = num_wave
    [ax,h1,h2] = plotyy(tlook(locZ(:, i)), peaksZ(:, i), tlook(locZ(2:end-2, i)), grad_wave(:, i));
    set(h1,'LineStyle',':','color',mycol(i), 'linewidth', 2)
    set(h2,'LineStyle','-','color',mycol(i))
    txt1 = ['\uparrow#', num2str(i)];
    suit_pt = one_end(i)+4;
    text(tlook(locZ(suit_pt, i)), grad_wave(suit_pt, i),txt1)
    set(ax,'xlim',[4,18]);set(ax(1),'ylim',[0.2,1.6]);set(ax(2),'ylim',[-0.04,-0.005]);
    set(ax(2),'ytick', [-0.04:0.005:-0.005])
    set(ax(1),'ytick',[0.2:0.2:1.6])
end
grid on
grid minor
xlabel('Time, [s]'); ylabel('Gradient dx/dt')
set(get(ax(2),'Ylabel'),'String','Gradient')





