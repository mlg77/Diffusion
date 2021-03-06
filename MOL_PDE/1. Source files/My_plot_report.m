function [  ] = My_plot_report( AllDir )
% My plot Report for 18mo 


cd([AllDir.ParentDir ,AllDir.SaveDir])
load('All_data_ode')
cd([AllDir.ParentDir, AllDir.SourceDir])


top_pt = 0.8470;  bt_pt = 0.2640;
% top_pt = 0.8;  bt_pt = 0.28;
% bt_pt = 0.5;
t_end = t(end);
figure(1)
% subplot(3,1,1)
        imagesc(t(1:20/dt+1),flipud(x),Z0D(:, 1:20/dt+1))
        set(gca,'YDir','normal')
        xlabel('Time, [s]')
        ylabel('Position, x')
        title(['[Ca^2^+] Concentration in the Cytosol [\muM]'])
        colormap jet
        colorbar
        hold on
        plot([0,t_end], [top_pt, top_pt], 'k','LineWidth',2)
        plot([0,t_end], [bt_pt, bt_pt],  'k','LineWidth',2)
figure(2)
% subplot(3,1,2)
        imagesc(t,flipud(x),ZFD)
        set(gca,'YDir','normal')
        xlabel('Time, [s]')
        ylabel('Position, x')
        title(['[Ca^2^+]_{Cytosol} Fickian Diffusion (6x10^{-6}), [\muM]'])
        colormap jet
        colorbar
        hold on
        plot([0,t_end], [top_pt, top_pt], 'k','LineWidth',2)
        plot([0,t_end], [bt_pt, bt_pt],  'k','LineWidth',2)

figure(3)
% subplot(3,1,3)
        imagesc(t,flipud(x),ZED)
        set(gca,'YDir','normal')
        xlabel('Time, [s]')
        ylabel('Position, x')
        title(['[Ca^2^+]_{Cytosol} Electro Diffusion (6x10^{-6}), [\muM]'])
        colormap jet
        colorbar
        hold on
        plot([0,t_end], [top_pt, top_pt], 'k','LineWidth',2)
        plot([0,t_end], [bt_pt, bt_pt],  'k','LineWidth',2)

        
figure(4)
    plot(mybeta , x , 'Linewidth', 2)
    xlabel('Beta (\beta)')
    ylabel('Position (x)')
    hold on
    int_tp = mybeta(find(x>=top_pt, 1));
    int_bt = mybeta(find(x>=bt_pt, 1));
    plot([0,int_tp, int_tp], [top_pt, top_pt, 0], 'k', 'Linewidth', 2)
    plot([0,int_bt, int_bt], [bt_pt, bt_pt, 0], 'k', 'Linewidth', 2)
end
