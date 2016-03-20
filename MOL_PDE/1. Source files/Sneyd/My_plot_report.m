function [  ] = My_plot_report( mystr, AllDir )
%Plots the results saved from the previous
%   Plots up to the section specified as input
%   No outputs only plots
%   Author Michelle Goodman
%   Date 11/8/15
    close all
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
%     plot([top_point, top_point], [0, x_top_pt],  'k','LineWidth',2)
    
    if strcmp(mystr, 'bounds')
        return
    end
%     
    load('simple_data.mat')
    
    figure(2)
        plot(mybeta,flipud(x))
        ylabel('Position, x')
        xlabel('beta, [-]')
        title('Changing Beta Ploted over Space Showing Unstable Region')
        hold on
        if exist('top_point', 'var') == 0
            top_point = 1;
            list_2 = [];
        else
            list_2 = find(mybeta>top_point);
        end
        list_1 = find(mybeta>bt_point); 
        if  isempty(list_1) & isempty(list_2)
            top_pt = x(1) ; 
            bt_pt = x(end);
        elseif isempty(list_1)
            top_pt = x(end);          bt_pt = x(list_2(1));
        elseif isempty(list_2)
            bt_pt = x(1) ;            top_pt = x(list_1(1)) ;
        else
            top_pt = x(list_1(1)) ; 
            bt_pt = x(list_2(1));
        end
        plot([bt_point, bt_point, 0], [0, top_pt, top_pt], 'k','LineWidth',2)
        plot([top_point, top_point, 0], [0, bt_pt, bt_pt],  'k','LineWidth',2)
    figure(3)
        imagesc(t,flipud(x),C.simple)
        set(gca,'YDir','normal')
        xlabel('Time, [s]')
        ylabel('Position, x')
        title('Calcium [Ca^2^+] Concentration in the Cytosol zero diffusion, [\muM]')
        colormap jet
        hold on
        plot([0,t_end], [top_pt, top_pt], 'k','LineWidth',2)
        plot([0,t_end], [bt_pt, bt_pt],  'k','LineWidth',2)
        colorbar
    
    if strcmp(mystr, 'simple')
        return
    end
    
    load('SD_data.mat')
    figure(4)
        imagesc(t,flipud(x),C.SD)
        set(gca,'YDir','normal')
        xlabel('Time, [s]')
        ylabel('Position, x')
        title(['Calcium [Ca^2^+] Concentration in the Cytosol with Simple Diffusion (',num2str(D), '), [\muM]'])
        colormap jet
        colorbar
        hold on
        plot([0,t_end], [top_pt, top_pt], 'k','LineWidth',2)
        plot([0,t_end], [bt_pt, bt_pt],  'k','LineWidth',2)

    if strcmp(mystr, 'SD')
        return
    end
    
    load('ED_data.mat')
    
    figure(5)
        imagesc(t,flipud(x),C.ED)
        set(gca,'YDir','normal') 
        xlabel('Time, [s]')
        ylabel('Position, x')
        title('Calcium [Ca^2^+] Concentration in the Cytosol with Electro-Diffusion (6x10^-^6), [\muM]')
        colorbar
        colormap jet
        hold on
        plot([0,t_end], [top_pt, top_pt], 'k','LineWidth',2)
        plot([0,t_end], [bt_pt, bt_pt],  'k','LineWidth',2)
        
end

