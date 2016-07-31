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
% Found first now
%
% L_Z=[]; L_Y=[]; v_2=[]; v_3=[]; d2Zdx2 = [];
% for j = 1:length(t) % Loop through each time to find L, v2 and v3
%     [ dydt , L_Zt, L_Yt, d2Zdx2t, v_2t, v_3t] = odefun_Goldbeter( j, y(j,:)' , mybeta, 1, D);
%     L_Z(:, j) = L_Zt;
%     L_Y(:, j) = L_Yt;
%     d2Zdx2(:, j) = d2Zdx2t; 
%     v_2(:, j) = v_2t;
%     v_3(:, j) = v_3t;
% end
% break
%% Diffusion
figure(4)
subplot(1,2,1)
hold on
for i = x_look
    plot(t(t_look), d2Zdx2(i, t_look), 'linewidth', 2)
end
legend('0.082','0.083', '0.084', '0.085', '0.086', '0.087')
grid on
xlabel('time [s]')
ylabel('Calcium concentration per second')
title('Diffusion Component')
subplot(1,2,2)
hold on; pks = []; loc = []; count = 0;
for i = x_look
    count = count + 1;
    [mpks, mloc] = findpeaks(d2Zdx2(i, t_look));
    pks(count,1:length(mpks)) = mpks;
    loc(count,1:length(mloc)) = mloc;
end

plot(t(t_look(1)+loc(:,1)), pks(:,1)); plot(t(t_look(1)+loc(5:end, 2)), pks(5:end,2))
grid on; legend('First Peek, from above', 'Second Peek, from below')
xlabel('time [s]')
ylabel('Calcium concentration per second')
title('Diffusion Component into the cell at wave end')

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
legend('total', 'Diffusion into cell', 'Diffusion out of the cell')
grid on

