%% find each component either side of end {0.08... 0.09}
x_look = find(x>0.153,1):find(x>0.164);
t_look = find(t>7,1):find(t>10);

% x_look = find(x>0.081,1):find(x>0.087);
% t_look = find(t>10,1):find(t>12);
figure(2)
imagesc(t(t_look),flipud(x(x_look)),Z(x_look, t_look))
        set(gca,'YDir','normal')
        xlabel('Time, [s]')
        ylabel('Position, x')
        title(['Z, Calcium Concentration in the Cytosol ',num2str(D),' diffusion, [\muM]'])
        colormap jet
figure(3)
hold on
for i = x_look
    plot(t(t_look), Z(i, t_look), 'LineWidth',2)
end
legend('0.082','0.083', '0.084', '0.085', '0.086', '0.087')
grid on
xlabel('time [s]')
ylabel('Calcium concentration Z')
title('Six points in question')

%% Find the diffusion components looping back through 
L_Z=[]; L_Y=[]; v_2=[]; v_3=[]; d2Zdx2 = [];
for j = 1:length(t) % Loop through each time to find L, v2 and v3
    [ dydt , L_Zt, L_Yt, d2Zdx2t, v_2t, v_3t] = odefun_Goldbeter( j, y(j,:)' , mybeta, 1, D);
    L_Z(:, j) = L_Zt;
    L_Y(:, j) = L_Yt;
    d2Zdx2(:, j) = d2Zdx2t; 
    v_2(:, j) = v_2t;
    v_3(:, j) = v_3t;
end

%% Diffusion
figure()
hold on
for i = x_look
    plot(t(t_look), d2Zdx2(i, t_look), 'linewidth', 2)
end
legend('0.082','0.083', '0.084', '0.085', '0.086', '0.087')
grid on
xlabel('time [s]')
ylabel('Calcium concentration per second')
title('Diffusion Component')

%% V_2
figure(5)
subplot(1,2, 1)
hold on
for i = x_look
    plot(t(t_look), v_2(i, t_look))
end
legend('0.082','0.083', '0.084', '0.085', '0.086', '0.087')
grid on
xlabel('time [s]')
ylabel('Calcium concentration per second')
title('V_2')

%% V_3
figure(5)
subplot(1,2, 2)
hold on
for i = x_look
    plot(t(t_look), v_3(i, t_look))
end
legend('0.082','0.083', '0.084', '0.085', '0.086', '0.087')
grid on
xlabel('time [s]')
ylabel('Calcium concentration per second')
title('V_3')

%% Plot changing position
% cd([AllDir.ParentDir ,AllDir.SaveDir])
% figure(6)
% subplot(1,2,1)
% imagesc(t,flipud(x),Z)
%         set(gca,'YDir','normal')
%         xlabel('Time, [s]')
%         ylabel('Position, x')
%         title(['Z, Calcium Concentration in the Cytosol ',num2str(D),' diffusion, [\muM]'])
%         colormap jet
%         hold on
%         plot([0,t_end], [top_pt, top_pt], 'k','LineWidth',2)
%         plot([0,t_end], [bt_pt, bt_pt],  'k','LineWidth',2)
%         h = plot([0,t(end)], [0,0]);
%         set(gcf, 'Color' ,'w'); % Gif
%         f = getframe(figure(6)); % Gif
%         [im,map] = rgb2ind(f.cdata,256,'nodither');  % Gif
%         count = 0;
% pause()
% for i=(length(x)-1)/2:-2:60
%     subplot(1,2,1)
%     delete(h)
%     h = plot([0,t(end)], [x(i),x(i)], 'r', 'LineWidth', 2);
%     
%     subplot(1,2,2)
%     hold off
%     plot(t, d2Zdx2(i,:))
%     axis([0, 30, -12, 8])
%     xlabel('Time')
%     title(['Position x = ', num2str(x(i))])
%     ylabel('Diffusion Concentration rate')
%     
%     count = count+1;
%     set(gcf, 'Color' ,'w'); % Gif
%     f = getframe(figure(6)); 
%     im(:,:,1,count) = rgb2ind(f.cdata,map,'nodither');
% % pause(0.2)
% end
% 
% imwrite(im,map,'changex_short.gif','DelayTime',0.08); % Save Gif file
% 
% break
%% Area under D
iti_sect = d2Zdx2(x_look, t_look);
pos_iti_sect = iti_sect;
neg_iti_sect = iti_sect;
pos_iti_sect(find(iti_sect<0)) = 0;
neg_iti_sect(find(iti_sect>0)) = 0;

res = []; 
for i = length(x_look):-1:1
    a = trapz(t(t_look), iti_sect(i, :));
    b = trapz(t(t_look), pos_iti_sect(i, :));
    c = trapz(t(t_look), neg_iti_sect(i, :));
    res = [res; [a,b,c]];
end
figure(7);
hold on;
plot(flip(x(x_look)),res(:,1), '-x'); plot(flip(x(x_look)), res(:,2), '-x'); plot(flip(x(x_look)), res(:,3), '-x')
xlabel('position')
ylabel('Diffusion in that time')
legend('total', 'Diffusion into cell', 'Diffusion into cell')
grid on

%% Slope of wave at end
x_look = find(x>0.05,1):find(x>0.25);
t_look = find(t>10,1):find(t>25);
nui_iti_sect = d2Zdx2(x_look, t_look);
t_to_close = 1000;
mpeaks = []; mloc = [];

for i = 1:length(x_look)
    [pks, loc] = findpeaks(nui_iti_sect(i, :));
    mpeaks = [mpeaks; [pks', i + pks'*0]];
    mloc = [mloc; [loc', i+ pks'*0]];
end

figure(8)
subplot(1,2,1)
plot(mpeaks(:,1), 'x')
    
subplot(1,2,2)
plot(x(mloc(:,2)+x_look(1)-1), t(mloc(:,1)+t_look(1)-1), 'x')

% for i = 1:length(mpeaks)
%     subplot(1,2,1)
%     hold on
%     plot(i, mpeaks(i, 1), 'xg')
%     
%     subplot(1,2,2)
%     hold on
%     plot(x(mloc(i,2)+x_look(1)-1),t(mloc(i,1)+t_look(1)-1), 'xg')
%     
%     pause(0.1)
% end
% postion1, position2, time1, time2
EqnLines = [0.06, 0.12,12 , 10
    0.09, 0.14,14 , 10
    0.105, 0.16,14 , 10
    0.11,0.18,15 , 10
    0.125, 0.2,15 , 10
    0.129, 0.2205,16 , 10
    0.145, 0.235,16 , 10];
Eqntops = [13.5
    15
    16];

EquationLine = @(q, q1, q2, r1, r2) r1 + ((r2-r1)./(q2-q1)).*(q - q1);

wave1 = []; wave2 = []; wave3 = []; wave4 = [];
for i = 1:length(mpeaks)
    % Handle one point at a time [Position, Time, Magnitude]
    ptinQ = [x(mloc(i,2)+x_look(1)-1),t(mloc(i,1)+t_look(1)-1), mpeaks(i,1)];
    cond_line1 = EquationLine(ptinQ(1), EqnLines(:, 1), EqnLines(:, 2), EqnLines(:, 3), EqnLines(:, 4));
    % Which region am I in
    which_am_i_above1 = ptinQ(2) > cond_line1;
    % Put into regions 
    if sum(which_am_i_above1)== 0
        %Region 1
        wave1 = [wave1; [ptinQ]];
    elseif sum(which_am_i_above1)== 2 & ptinQ(2)<Eqntops(1)
        % Region 2
        wave2 = [wave2; [ptinQ]];
    elseif sum(which_am_i_above1)== 4 & ptinQ(2)<Eqntops(2)
        % Region 3
        wave3 = [wave3; [ptinQ]];
    elseif sum(which_am_i_above1)== 6 & ptinQ(2)<Eqntops(3)
        % Region 4
        wave4 = [wave4; [ptinQ]];
    else
        % Left over
    end
end
ptinQ2 = [mloc(:,2),mloc(:,1), mpeaks(:,1)];

figure(8); subplot(1,2,2); hold on; 
plot(wave1(:,1), wave1(:, 2), 'ko', 'linewidth', 2)
plot(wave2(:,1), wave2(:, 2), 'ro', 'linewidth', 2)
plot(wave3(:,1), wave3(:, 2), 'ko', 'linewidth', 2)
plot(wave4(:,1), wave4(:, 2), 'ro', 'linewidth', 2)
grid on
grid minor

%% Plot of Diffusion
figure(9); imagesc(t(t_look),flipud(x(x_look)),d2Zdx2(x_look, t_look))
set(gca,'YDir','normal')
xlabel('Time, [s]')
ylabel('Position, x')
title(['Z, Calcium Concentration in the Cytosol ',num2str(D),' diffusion, [\muM]'])
colormap jet
hold on
plot(wave1(:,2), wave1(:, 1), 'ko', 'linewidth', 2)
plot(wave2(:,2), wave2(:, 1), 'ro', 'linewidth', 2)
plot(wave3(:,2), wave3(:, 1), 'ko', 'linewidth', 2)
plot(wave4(:,2), wave4(:, 1), 'ro', 'linewidth', 2)
