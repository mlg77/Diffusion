function [  ] = My_plot_report( AllDir )
% My plot Report for 18mo 


cd([AllDir.ParentDir ,AllDir.SaveDir])
load('All_data_ode')
cd([AllDir.ParentDir, AllDir.SourceDir])

prompt = 'What image? All/Zoom1: ';
mystr = input(prompt,'s');

acceptable = [{'All'}, {'Zoom1'}];
while ismember(mystr,acceptable) == 0
    display('Choose again! Check correct captles')
    mystr = input(prompt,'s');
end

if strcmp(mystr, 'All')
    t_want = 1:length(t);
    x_want = 1:length(x);
elseif strcmp(mystr, 'Zoom1')
    t_want = 1:length(t);
    x_want = find(x>=0.15,1):find(x>=0.4,1);
end
    

top_pt = 0.750;  bt_pt = 0.2850;
% top_pt = 0.8;  bt_pt = 0.28;
% bt_pt = 0.5;
t_end = t(end);
for ii = 1:2
    figure(1)
    subplot(1,2,ii)
    if ii == 1
        imagesc(t(t_want),flipud(x(x_want)),Z0D(x_want, t_want))
        title(['[Ca^2^+] Concentration in the Cytosol [nM]'])
    else
        imagesc(t(t_want),flipud(x(x_want)),V0D(x_want, t_want))
        title(['[V] Membrane potential [mV]'])
    end
    set(gca,'YDir','normal')
    xlabel('Time, [s]')
    ylabel('Position, x')
    colormap jet
    colorbar
    hold on
    plot([0,t_end], [top_pt, top_pt], 'k','LineWidth',2)
    plot([0,t_end], [bt_pt, bt_pt],  'k','LineWidth',2)
end
    
for ii = 1:2
    figure(2)
    subplot(1,2,ii)
    if ii == 1
        imagesc(t(t_want),flipud(x(x_want)),ZFD(x_want, t_want))
        title(['[Ca^2^+] Concentration in the Cytosol [nM]'])
    else
        imagesc(t(t_want),flipud(x(x_want)),VFD(x_want, t_want))
        title(['[V] Membrane potential [mV]'])
    end
    set(gca,'YDir','normal')
    xlabel('Time, [s]')
    ylabel('Position, x')
    colormap jet
    colorbar
    hold on
    plot([0,t_end], [top_pt, top_pt], 'k','LineWidth',2)
    plot([0,t_end], [bt_pt, bt_pt],  'k','LineWidth',2)
    
end
 
for ii = 1:2
    figure(3)
    subplot(1,2,ii)
    if ii == 1
        imagesc(t(t_want),flipud(x(x_want)),ZED(x_want, t_want))
        title(['[Ca^2^+] Concentration in the Cytosol [nM]'])
    else
        imagesc(t(t_want),flipud(x(x_want)),VED(x_want, t_want))
        title(['[V] Membrane potential [mV]'])
    end
    set(gca,'YDir','normal')
    xlabel('Time, [s]')
    ylabel('Position, x')
    colormap jet
    colorbar
    hold on
    plot([0,t_end], [top_pt, top_pt], 'k','LineWidth',2)
    plot([0,t_end], [bt_pt, bt_pt],  'k','LineWidth',2)
    
end

figure(1); suptitle('0 Diffusion')
figure(2); suptitle('Fickian Diffusion')
figure(3); suptitle('Electro Diffusion')
        
figure(4)
    v1_bounds = [-20, -27];
    v1_bounds = [-13, -36];
    v_1 = mybeta*(v1_bounds(2)- v1_bounds(1)) + v1_bounds(1);
    plot(v_1 , x , 'Linewidth', 2)
    xlabel('v_1 [mV]')
    ylabel('Position (x)')
    hold on
    int_tp = mybeta(find(x>=top_pt, 1));
    int_bt = mybeta(find(x>=bt_pt, 1));
    int_tp = int_tp*(v1_bounds(2)- v1_bounds(1)) + v1_bounds(1);
    int_bt = int_bt*(v1_bounds(2)- v1_bounds(1)) + v1_bounds(1);
    plot([-14,int_tp, int_tp], [top_pt, top_pt, 0], 'k', 'Linewidth', 2)
    plot([-14,int_bt, int_bt], [bt_pt, bt_pt, 0], 'k', 'Linewidth', 2)
    
end
