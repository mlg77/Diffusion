function [  ] = My_plot( mystr, AllDir )
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
    subplot(1,2,2)
        plot(mybeta,flipud(x))
        ylabel('Position, x')
        xlabel('beta, [-]')
        hold on
        list_1 = find(mybeta>bt_point); list_2 = find(mybeta>top_point);
        top_pt = x(list_1(1)) ; bt_pt = x(list_2(1));
        plot([bt_point, bt_point, 0], [0, top_pt, top_pt], 'k','LineWidth',2)
        plot([top_point, top_point, 0], [0, bt_pt, bt_pt],  'k','LineWidth',2)
    subplot(1,2,1)
        imagesc(t,flipud(x),Z2)
        set(gca,'YDir','normal')
        xlabel('Time, [s]')
        ylabel('Position, x')
        title('Z, Calcium Concentration in the Cytosol zero diffusion, [\muM]')
        colormap jet
        hold on
        plot([0,t_end], [top_pt, top_pt], 'k','LineWidth',2)
        plot([0,t_end], [bt_pt, bt_pt],  'k','LineWidth',2)
    
    if strcmp(mystr, 'simple')
        return
    end
    
    load('SD_data.mat')
    figure(3)
    subplot(1,2,2)
        plot(mybeta,x)
        ylabel('Position, x')
        xlabel('beta, [-]')
        hold on
        list_1 = find(mybeta>bt_point); list_2 = find(mybeta>top_point);
        top_pt = x(list_1(1)) ; bt_pt = x(list_2(1));
        plot([bt_point, bt_point, 0], [0, top_pt, top_pt], 'k','LineWidth',2)
        plot([top_point, top_point, 0], [0, bt_pt, bt_pt],  'k','LineWidth',2)
    subplot(1,2,1)
        imagesc(t,flipud(x),Z2b)
        set(gca,'YDir','normal')
        xlabel('Time, [s]')
        ylabel('Position, x')
        title('Z, Calcium Concentration in the Cytosol 6e-6 diffusion, [\muM]')
        colormap jet
        hold on
        plot([0,t_end], [top_pt, top_pt], 'k','LineWidth',2)
        plot([0,t_end], [bt_pt, bt_pt],  'k','LineWidth',2)

    if strcmp(mystr, 'SD')
        return
    end
    
    load('ED_data.mat')
    figure(4)
    subplot(1,2,2)
        plot(mybeta,x)
        ylabel('Position, x')
        xlabel('Beta, [-]')
        hold on
        plot([bt_point, bt_point, 0], [0, top_pt, top_pt], 'k','LineWidth',2)
        plot([top_point, top_point, 0], [0, bt_pt, bt_pt],  'k','LineWidth',2)
    subplot(1,2,1)
        imagesc(t,flipud(x),Z3)
        set(gca,'YDir','normal') 
        xlabel('Time, [s]')
        ylabel('Position, x')
        title('Z, Calcium Concentration in the Cytosol, [\muM]')
        colormap jet
        hold on
        plot([0,t_end], [top_pt, top_pt], 'k','LineWidth',2)
        plot([0,t_end], [bt_pt, bt_pt],  'k','LineWidth',2)

       %% View Grid
%     figure(5)
%     subplot(1,2,1)
%         imagesc(t,flipud(x),Z3)
%         set(gca,'YDir','normal')
%         xlabel('Time, [s]')
%         ylabel('Position, x')
%         title('Z, Calcium Concentration in the Cytosol, [\muM]')
%         colormap jet
%         hold on
%         plot([0,t_end], [top_pt, top_pt], 'k','LineWidth',2)
%         plot([0,t_end], [bt_pt, bt_pt],  'k','LineWidth',2)
%     subplot(1,2,2)
%         h = surf(t,x,Z3);
%         xlabel('Time, [s]')
%         ylabel('Position, x')
%         title('Z, Calcium Concentration in the Cytosol, [\muM]')
%         colormap jet
%         view(2)
%         figure_handle = figure(5);
%         all_ha = findobj( figure_handle, 'type', 'axes', 'tag', '' );
%         linkaxes( all_ha, 'xy');
%         set(h, 'edgecolor','k');
%         axis([4.5,7,0.38,0.43])

end

