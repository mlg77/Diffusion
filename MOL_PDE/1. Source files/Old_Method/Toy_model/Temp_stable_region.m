clear; clc; close all

figure(1)

%% Initalise Parameters
    Z_0 = 3; V_0 = 2;
    dt = 0.005; t_end = 60; t = 0:dt:t_end;   N = length(t);
    dx = 0.5; x = 0+dx:dx:1;   M = length(x); 
    D = 5e-6;

B_possible = -5:0.5:5;
for j = 1:length(B_possible)
    B = B_possible(j);
    if sign(B)<1
        al = [linspace(B-2,-B+2,20)'];
%         al = [linspace(B-2,B-0.5,4)'; linspace(-B+0.5,-B+2,4)'];
    else
        al = [linspace(-B-2,B+2,20)'];
%         al = [linspace(-B-2,-B-0.5,4)'; linspace(B+0.5,B+2,4)'];
    end
%% Bounds
    for i = 1:length(al)
        Z1 = Simple_toy( dt, dx, x, t, M, N, Z_0, V_0, B, al(i));
        my_max(i,j) = max(Z1(2, 10001:end));
        my_min(i,j) = min(Z1(2, 10001:end));
    end
    al_mat(:, j) = al; 
    if max(my_max- my_min) > 0.01*max(my_max)
        B
    end
    
    hold on;
    plot(al,my_min(:,j), 'x-')
    
% gif utilities
    set(gcf,'color','w'); % set figure background to white
    drawnow;
    frame = getframe(1);
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256);
    outfile = 'Changing_B.gif';
 
    % On the first loop, create the file. In subsequent loops, append.
    if j==1
        imwrite(imind,cm,outfile,'gif','DelayTime',0.1,'loopcount',inf);
    else
        imwrite(imind,cm,outfile,'gif','DelayTime',0.1,'writemode','append');
    end
    
end

