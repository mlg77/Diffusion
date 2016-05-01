function [] = dots2Lines( peek, colour, x, t, figno)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

mylines1_y = []; mylines2_y = []; mylines3_y = []; mylines2b_y = []; mylines1b_y = [];
mylines1_x = []; mylines2_x = []; mylines3_x = []; mylines2b_x = []; mylines1b_x = [];
count1 = 1; count1b = 1;
count2 = 1;count2b = 1;
count3 = 1;
Row_indx = unique(peek(:,1));
for i = 1:length(Row_indx)
    NoPtsInRow = length(find(peek(:,1) == Row_indx(i) ));
    begpt = find(peek(:,1)==Row_indx(i),1);
    if Row_indx(i,1)/length(x) < 0.198
        mylines1b_y(count1b, 1:NoPtsInRow) = peek(begpt:begpt+NoPtsInRow-1, 1)';
        mylines1b_x(count1b, 1:NoPtsInRow) = peek(begpt:begpt+NoPtsInRow-1, 2)';
        count1b = count1b + 1;
    elseif Row_indx(i,1)/length(x) < 0.2 
        mylines1_y(count1, 1:NoPtsInRow) = peek(begpt:begpt+NoPtsInRow-1, 1)';
        mylines1_x(count1, 1:NoPtsInRow) = peek(begpt:begpt+NoPtsInRow-1, 2)';
        count1 = count1 + 1;
    elseif Row_indx(i,1)/length(x) > 0.805
        mylines2_y(count2, 1:NoPtsInRow) = peek(begpt:begpt+NoPtsInRow-1, 1)';
        mylines2_x(count2, 1:NoPtsInRow) = peek(begpt:begpt+NoPtsInRow-1, 2)';
        count2 = count2 + 1;
    elseif Row_indx(i,1)/length(x) > 0.802
        mylines2b_y(count2b, 1:NoPtsInRow) = peek(begpt:begpt+NoPtsInRow-1, 1)';
        mylines2b_x(count2b, 1:NoPtsInRow) = peek(begpt:begpt+NoPtsInRow-1, 2)';
        count2b = count2b + 1;
    else
        mylines3_y(count3, 1:NoPtsInRow) = peek(begpt:begpt+NoPtsInRow-1, 1)';
        mylines3_x(count3, 1:NoPtsInRow) = peek(begpt:begpt+NoPtsInRow-1, 2)';
        count3 = count3 + 1;
    end
end
BotisEmpty = 0;
TopisEmpty = 0;
if isempty(mylines1b_y) || isempty(mylines1_y)
    BotisEmpty = 1;
end
if isempty(mylines2b_y) || isempty(mylines2_y)
    TopisEmpty = 1;
end

NoC = size(mylines3_y, 2);

NoRT1 = size(mylines1_y, 1);
NoRT = size(mylines1b_y, 1) + NoRT1;
NoRB1 = size(mylines2b_y, 1) ;
NoRB = NoRB1 + size(mylines2_y, 1);

CompleteLinesy = [zeros(NoRT, NoC);mylines3_y; zeros(NoRB, NoC)];
CompleteLinesx = [zeros(NoRT, NoC);mylines3_x; zeros(NoRB, NoC)];

for i = 1:size(mylines3_x,2)
    if not(TopisEmpty)
        for j = 1:size(mylines1_x, 2)
            if abs(mylines1_x(end,j)- mylines3_x(1,i)) < 0.5*length(t)/t(end)
                CompleteLinesx(NoRT-NoRT1:NoRT,i) = mylines1_x(:,j);
                CompleteLinesy(NoRT-NoRT1:NoRT,i) = mylines1_y(:,j);
                break
            end
        end
        
    end
    if not(BotisEmpty)
        for j = 1:size(mylines2b_x, 2)
            if abs(mylines2b_x(1,j)- mylines3_x(end,i)) < 0.5*length(t)/t(end)
                CompleteLinesx(end-NoRB+1:end-NoRT+NoRB1,i) = mylines2b_x(:,j);
                CompleteLinesy(end-NoRB+1:end-NoRT+NoRB1,i) = mylines2b_y(:,j);
                break
            end
        end
    end
end

for i = 1:size(mylines3_x,2)
    if not(TopisEmpty)
        for j = 1:size(mylines1b_x, 2)
            if abs(mylines1b_x(end,j)- CompleteLinesx(NoRT-NoRT1,i)) < 0.5*length(t)/t(end)
                CompleteLinesx(1:NoRT-NoRT1,i) = mylines1b_x(:,j);
                CompleteLinesy(1:NoRT-NoRT1,i) = mylines1b_y(:,j);
                break
            end
        end
        
    end
    if not(BotisEmpty)
        for j = 1:size(mylines2_x, 2)
            if abs(mylines2_x(1,j)- CompleteLinesx(end-NoRB+NoRB1,i)) < 0.5*length(t)/t(end)
                CompleteLinesx(end-NoRB+NoRB1+1:end,i) = mylines2_x(:,j);
                CompleteLinesy(end-NoRB+NoRB1+1:end,i) = mylines2_y(:,j);
                break
            end
        end
    end
end

%% Plot
% mylines1_x(find(mylines1_x == 0)) = nan;
% mylines1_y(find(mylines1_y == 0)) = nan;
% mylines2_x(find(mylines2_x == 0)) = nan;
% mylines2_y(find(mylines2_y == 0)) = nan;
% mylines3_x(find(mylines3_x == 0)) = nan;
% mylines3_y(find(mylines3_y == 0)) = nan;
% 
% mylines1b_x(find(mylines1b_x == 0)) = nan;
% mylines1b_y(find(mylines1b_y == 0)) = nan;
% mylines2b_x(find(mylines2b_x == 0)) = nan;
% mylines2b_y(find(mylines2b_y == 0)) = nan;

CompleteLinesx(find(CompleteLinesx == 0)) = nan;
CompleteLinesy(find(CompleteLinesy == 0)) = nan;

figure(figno)
hold on
h = plot(CompleteLinesx*t(end)/length(t), CompleteLinesy/length(x), colour);
% plot(mylines1_x*t(end)/length(t), mylines1_y/length(x), [colour, '.']) % problem points
% plot(mylines2_x*t(end)/length(t), mylines2_y/length(x), colour)
% plot(mylines3_x*t(end)/length(t), mylines3_y/length(x), colour)
% plot(mylines2b_x*t(end)/length(t), mylines2b_y/length(x), colour)
% plot(mylines1b_x*t(end)/length(t), mylines1b_y/length(x), colour)
end

