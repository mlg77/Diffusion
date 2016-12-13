function [  ] = First_Bi_points( t,x, Z0D, ZFD  )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

%% Bifurcation Stuff
[ pointsfound1 ] = Bifurcation_points( x,t,Z0D(:,  length(t) - round(length(t)/20):end) );
[ pointsfound2 ] = Bifurcation_points( x,t,ZFD(:, round(length(t)/10):end) );


figure(1)
subplot(1,3,1)
        h = imagesc(t,x,Z0D);
        set(gca,'YDir','normal')
        xlabel('Time, [s]')
        ylabel('position')
        title(['\Phi Zero Diffusion, [\mu M]'])
        colormap jet
        colorbar
        hold on
        plot([t(1), t(end)], [pointsfound1(2,1), pointsfound1(2,1)], 'k','LineWidth',2)

subplot(1,3,2)
        h = imagesc(t,x,ZFD);
        set(gca,'YDir','normal')
        xlabel('Time, [s]')
        ylabel('position')
        title(['\Phi Fickian Diffusion, [\mu M]'])
        colormap jet
        colorbar
        hold on
        plot([t(1), t(end)], [pointsfound2(2,1), pointsfound2(2,1)], 'g','LineWidth',2)
  

%% Minimum Bifurcation
[ minpointsfound ] = Min_Bifurcation_points( x,t,ZFD(:,round(length(t)/10):end));
figure(1)
subplot(1,3,2)
plot([t(1), t(end)], [max(minpointsfound(:,2)), max(minpointsfound(:,2))], 'r','LineWidth',2)

%% Make diagram
subplot(1,3,3)
hold on
max_line = max(Z0D(:,  length(t) - round(length(t)/20):end)');
plot(x, max_line, 'k')
plot(x, min(Z0D(:,  length(t) - round(length(t)/20):end)'), 'k')
I =  find(x>pointsfound1(2,1), 1); 
plot([pointsfound1(2,1), pointsfound1(2,1)],[0, max_line(I-1)], 'k','LineWidth',2)


% Make min diagram
% num_max = find(minpointsfound(:,2)== max(minpointsfound(:,2)));
% plot(x, ZFD(:, find(t == t(minpointsfound(num_max,1)))))
% plot(x, ZFD(:, find(t == 28.4)))

%FD 
max_line = max(ZFD(:,  length(t) - round(length(t)/20):end)');
plot(x, max_line, 'r')
plot(x, min(ZFD(:,  length(t) - round(length(t)/20):end)'), 'r')
I =  find(x>pointsfound2(2,1), 1); 
plot([pointsfound2(2,1), pointsfound2(2,1)],[0, max_line(I-1)], 'g','LineWidth',2)


K =find(x>max(minpointsfound(:,2)), 1);
plot([max(minpointsfound(:,2)), max(minpointsfound(:,2))],[0, max_line(K-1)], 'r','LineWidth',2)

for ii = 1:length(x)
    current = ZFD(ii,  length(t) - round(length(t)/20):end);
    [PKS1,LOCS1]= findpeaks(current);
    [PKS2,LOCS2]= findpeaks(-current);
    if isempty(PKS1)
        PKS1 = nan;
    end
    if isempty(PKS2)
        PKS2 = nan;
    end
    minpks1(ii) = min(PKS1);
    minpks2(ii) = -min(PKS2);
end
    
    

end

