%% Slope of wave at end
% Author: Michelle Goodman
% Date 17/5/16

% Look at only past the bifurcation point
x_look = find(x>0.05,1):find(x>0.25);
t_look = find(t>10,1):find(t>25);
Z_iti_sect = Z(x_look, t_look);
D_iti_sect = d2Zdx2(x_look, t_look);
t_to_close = 1000;

% Find the peeks of the diffusion against the location of them
% And the Peeks in the concentration.
mpeaks = []; mloc = []; 
for i = 1:length(x_look)
    [pks, loc] = findpeaks(D_iti_sect(i, :));
    mpeaks = [mpeaks; [pks', i + pks'*0]];
    mloc = [mloc; [loc', i+ pks'*0]];
end

%% Plot the peeks vs the location 
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
%% Loop through and make them split into the different waves
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
