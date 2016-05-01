function [  ] = My_plot_toy( mystr, AD )
%Plots the results saved from the previous
%   Plots up to the section specified as input
%   No outputs only plots
%   Author Michelle Goodman
%   Date 11/8/15
 
t = AD.t;
x = AD.x;
M = length(x);
N = length(t);
t_end = t(end);

    figure(1)
    imagesc(t,flipud(x),AD.SimpleZ)
        set(gca,'YDir','normal')
        xlabel('Time, [s]')
        ylabel('Position, x')
        title('Phi, [\muM]')
        colormap jet
        colorbar

if strcmp(mystr, 'simple')
    return
end

    figure(2)
    imagesc(t,flipud(x),AD.SDZ)
        set(gca,'YDir','normal')
        xlabel('Time, [s]')
        ylabel('Position, x')
        title('Phi, [\muM]')
        colormap jet
        colorbar
     
 
    figure(4)
    subplot(2,1,1)
    imagesc(t,flipud(x),AD.SimpleP.map)
        set(gca,'YDir','normal')
        xlabel('Time, [s]')
        ylabel('Position, x')
        title('Phi, [\muM]')
        colormap jet
        colorbar
    subplot(2,1,2)
    plot(x, AD.SimpleP.overx)
    
    figure(5)
%     subplot(2,1,1)
    imagesc(t,flipud(x),log(AD.SDP.map))
        set(gca,'YDir','normal')
        xlabel('Time, [s]')
        ylabel('Position, x')
        title('Phi, [\muM]')
        colormap jet
        colorbar
%     subplot(2,1,2)
%     plot(x, AD.SimpleP.overx)

xpts = [0.6,0.5,0.3];
for i = 1:length(xpts)
    idx_x1 = find(x>xpts(i), 1);
    L1 = length(AD.SimpleP.tp(idx_x1,:)); L2 = length(AD.SDP.tp(idx_x1, :));
    L3 = length(AD.SimpleP.map(idx_x1,:)); L4 = length(AD.SDP.map(idx_x1, :));
    
    figure(3)
    subplot(3,1,i)
    hold on
    plot(t, AD.SimpleZ(idx_x1,:), '-b', t, AD.SDZ(idx_x1, :), '-r')        
    plot(t(1:L1), AD.SimpleP.tp(idx_x1,:), 'xb', t(1:L2), AD.SDP.tp(idx_x1, :), 'xr')   
%     axis([0,t_end,0.25,0.35])
    
    figure(6)
    subplot(3,1,i)
    plot(t(1:L3), AD.SimpleP.map(idx_x1,:), 'b', t(1:L4), AD.SDP.map(idx_x1, :), 'r')        
%     xlim([0, t_end])
end
count = 1;
for i = 1:size(AD.SDP.map, 1)
    z_v = min(AD.SDP.map(i, 1:end-round(0.1*L4)));
    if z_v ~= 0
        z_val(count) = z_v;
        x_val(count) = t(find(AD.SDP.map(i, 1:end-0.1*10000) == z_val(count), 1));
        y_val(count) = x(i);
        count = count+1;
    end
end
figure(7)
plot(y_val, z_val)
figure(5) 
hold on
plot(x_val, y_val)


for i = [1,2,5]
    figure(i)
    hold on
    plot(t, ones(1,N)*0.2,'color', 'k', 'linewidth', 2)
    plot(t, ones(1,N)*0.8,'color', 'k', 'linewidth', 2)
end
figure(4)
subplot(2,1,1)
hold on
plot(t, ones(1,N)*0.2,'color', 'b', 'linewidth', 2)
plot(t, ones(1,N)*0.8,'color', 'b', 'linewidth', 2)
hold off

for i = 7:-1:1
    figure(i)
end
end

