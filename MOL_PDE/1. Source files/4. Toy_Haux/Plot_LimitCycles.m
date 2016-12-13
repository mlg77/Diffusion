close all
% In order: Over all, time plot, limit cycle zero, limit cycle FD, 3D 0D,
% 3D FD
figurers_to_plot = [1,1,1,1,1,1]; % Plot all
% figurers_to_plot = [1,0,1,0,0,0];
if figurers_to_plot(1)
    figure(1)
    subplot(2,2,1)
            h = imagesc(t,flipud(x),Z0D);
            set(gca,'YDir','normal')
            xlabel('Time, [s]')
            ylabel('Beta')
            title(['\Phi Zero Diffusion, [\mu M]'])
            colormap jet
            colorbar
            hold on

    subplot(2,2,3)
            imagesc(t,flipud(x),ZFD)
            set(gca,'YDir','normal')
            xlabel('Time, [s]')
            ylabel('Position, x')
            title(['[Ca^2^+]_{Cytosol} FD (6x10^{-6}), [\muM]'])
            colormap jet
            colorbar


    subplot(2,2,2)
        plot(t, Z0D( end,:))
        xlabel('time [s]')
        ylabel('Concentration')
        grid on
        title(['Beta = ',num2str(x(end)),', 0D'])


    subplot(2,2,4)
        hold on
        plot(x, max(Z0D(:, round(0.75*t1/dt):end)'), 'b')
        plot(x, max(ZFD(:, round(0.75*t1/dt):end)'), 'r')
        title('bifurcation Diagrams')
        xlabel('beta')
        ylabel('Concentration')
        legend('0D', 'FD')
        plot(x, min(Z0D(:, 0.5*t1/dt:end)'), 'b')
        plot(x, min(ZFD(:, 0.5*t1/dt:end)'), 'r')
        grid on
end

%% if you want to plot it running in time
if figurers_to_plot(2)
    figure(99)
    beta2plot = [551, 601, 801, 1001];
    beta2plotCol = {'k', 'r', 'b', 'g'};
        clf
        grid on
        hold on
        xlabel('\Psi')
        ylabel('\Phi')
        title(['Different Beta and thier limit cycle over time'])
        axis([-1.5,1.5,-1.5,1.5])
        text(0,1, num2str(mybeta(beta2plot(4)))) ; text(0,0.75, num2str(mybeta(beta2plot(3))))
        text(0,0.4, num2str(mybeta(beta2plot(2)))) ; text(0,0.25, num2str(mybeta(beta2plot(1))))
        for jj = 1500:15:3700
            for ii = 1:length(beta2plot)
                plot(V0D(beta2plot(ii),1500:jj), Z0D(beta2plot(ii),1500:jj), beta2plotCol{ii})
            end
            pause(0.1)
        end
end

if figurers_to_plot(3)
    figure(2)
    clf
    hold on
    for ii = 1+(length(x)-1)*6/10 :(length(x)-1)/10: length(x)
        plot(V0D(ii,1500:end), Z0D(ii,1500:end), 'b')
        h = text(V0D(ii,end), Z0D(ii,end),num2str(mybeta(ii)));
        set(h, 'FontSize', 15);  set(h, 'HorizontalAlignment', 'center'); 
    end
    grid on
    title('Limit cycles of respective beta values (Zero Diffusion)')
    xlabel('\Psi')
    ylabel('\Phi')
end

if figurers_to_plot(4)
    figure(3)
    clf
    hold on
    for ii = 1+(length(x)-1)*6/10 :(length(x)-1)/5: length(x)
        plot(VFD(ii,1500:end), ZFD(ii,1500:end))
        h = text(VFD(ii,end), ZFD(ii,end),num2str(mybeta(ii)));
        set(h, 'FontSize', 15);  set(h, 'HorizontalAlignment', 'center'); 
    end
    grid on
    title('Limit cycles of respective beta values (Fickian Diffusion)')
    xlabel('\Psi')
    ylabel('\Phi')
end

if figurers_to_plot(5)
    figure(4)
    hold on
    for ii = 1+(length(x)-1)*6/10 :(length(x)-1)/5: length(x)
        plot3(V0D(ii,1500:20001), Z0D(ii,1500:20001), t(1500:20001), 'linewidth', 2)
        h = text(V0D(ii,20001), Z0D(ii,20001),num2str(mybeta(ii)));
        set(h, 'FontSize', 15);  set(h, 'HorizontalAlignment', 'center'); 
    end
    grid on
    title('Limit cycles of respective beta values 3D plot use rotate (Zero Diffusion)')
    xlabel('\Psi')
    ylabel('\Phi')
end

if figurers_to_plot(6)
    figure(5)
    hold on
    for ii = 1+(length(x)-1)*6/10 :(length(x)-1)/5: length(x)-1
        plot3(VFD(ii,1500:end), ZFD(ii,1500:end), t(1500:end), 'linewidth', 2)
        h = text(VFD(ii,end), ZFD(ii,end),num2str(mybeta(ii)));
        set(h, 'FontSize', 15);  set(h, 'HorizontalAlignment', 'center'); 
    end
    grid on
    title('Limit cycles of respective beta values 3D plot use rotate (Fickian Diffusion)')
    xlabel('\Psi')
    ylabel('\Phi')
end