function [  ] = My_plot_report( mystr, AllDir )
%Plots the results saved from the previous
%   Plots up to the section specified as input
%   No outputs only plots
%   Author Michelle Goodman
%   Date 11/8/15
    close all
    cd([AllDir.ParentDir, AllDir.InitalDataDir]);
    load('Defult_data.mat')
    cd([AllDir.ParentDir ,AllDir.SaveDir])
    load('bounds_data.mat')
    figure(1)
    plot(mybeta, my_max, mybeta, my_min)
    title('Unstable Region Determined from changing Beta')
    xlabel('beta')
    ylabel('Calcium Concentration [\muM]')
    legend('max', 'min')
    hold on
    plot([bt_point, bt_point], [0, x_bt_pt], 'k','LineWidth',2)
    plot([top_point, top_point], [0, x_top_pt],  'k','LineWidth',2)
    
    if strcmp(mystr, 'bounds')
        return
    end
    
    load('simple_data.mat')
    
    figure(2)
%         v_1 = mybeta*16-33;
        plot(mybeta,flipud(x))
%         plot(v_1,x)
        ylabel('Position, x')
        xlabel('beta, [-]')
%         xlabel('v_1')
        title('Changing Beta Ploted over Space Showing Unstable Region')
        hold on
        list_1 = find(mybeta>bt_point); list_2 = find(mybeta>top_point);
        if isempty(list_2) | isempty(list_1)
            top_pt = x(1) ; bt_pt = x(end);
        else
            top_pt = x(list_1(1)) ; bt_pt = x(list_2(1));
        end
        plot([bt_point, bt_point, 0], [0, top_pt, top_pt], 'k','LineWidth',2)
        plot([top_point, top_point, 0], [0, bt_pt, bt_pt],  'k','LineWidth',2)
    figure(3)
    subplot(3,1,1)
        imagesc(t(1:20/dt+1),flipud(x),Z2(:,1:20/dt+1))
        set(gca,'YDir','normal')
        xlabel('Time, [s]')
        ylabel('Position, x')
        title('[Ca^2^+]_{Cytosol} zero Diffusion, [\muM]')
        colormap jet
        hold on
        plot([0,t_end], [top_pt, top_pt], 'k','LineWidth',2)
        plot([0,t_end], [bt_pt, bt_pt],  'k','LineWidth',2)
        colorbar
    
    if strcmp(mystr, 'simple')
        return
    end
    
    load('SD_data.mat')
    figure(3); subplot(3,1,2)
        imagesc(t(1:60/dt+1),flipud(x),Z2b(:,1:60/dt+1))
        set(gca,'YDir','normal')
        xlabel('Time, [s]')
        ylabel('Position, x')
        title('[Ca^2^+]_{Cytosol} FD (6x10^-^6), [\muM]')
        colormap jet
        colorbar
        hold on
        plot([0,t_end], [top_pt, top_pt], 'k','LineWidth',2)
        plot([0,t_end], [bt_pt, bt_pt],  'k','LineWidth',2)

    if strcmp(mystr, 'SD')
        return
    end
    
    load('ED_data.mat')
    
    figure(3); subplot(3,1,3)
        imagesc(t(1:60/dt+1),flipud(x),Z3(:,1:60/dt+1))
        set(gca,'YDir','normal') 
        xlabel('Time, [s]')
        ylabel('Position, x')
        title('[Ca^2^+]_{Cytosol} ED (6x10^-^6), [\muM]')
        colorbar
        colormap jet
        hold on
        plot([0,t_end], [top_pt, top_pt], 'k','LineWidth',2)
        plot([0,t_end], [bt_pt, bt_pt],  'k','LineWidth',2)
        
end

