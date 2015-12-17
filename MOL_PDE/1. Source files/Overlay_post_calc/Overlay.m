
%% Overlay Images
% Example

clear
clc
close all

% load('C:\Temp\Diffusion\MOL_PDE\4. Output files\Docherty\Data_0_1.mat')
% 
% % Simple
% peek = Dotts( Z2 );
% % figure(1); plot(peek(:,2)*t(end)/length(t), peek(:,1)/length(x),'.b')
% plot(0,0,'-b',0,0,'-r', 0,0,'-k')
% dots2Lines( peek, 'b', x, t, 1);
% 
% %% SD
% peek = Dotts( Z2b );
% % figure(1); hold on; plot(peek(:,2)*t(end)/length(t), peek(:,1)/length(x),'.r')
% dots2Lines( peek, 'r', x, t, 1);
% 
% %% ED
% peek = Dotts( Z3 );
% % figure(1); hold on; plot(peek(:,2)*t(end)/length(t), peek(:,1)/length(x),'.k')
% dots2Lines( peek, 'k', x, t, 1);
% 
% %% Fix plots
% 
% figure(1)
% axis([0, t(end), 0,1])
% xlabel('Time, [s]')
% ylabel('Space, x')
% legend('Simple', 'SD', 'ED')
% 
% cd('C:\Temp\Diffusion\MOL_PDE\4. Output files\Docherty')
% set(gcf,'PaperPositionMode','auto')
% print('Combfig_0_3','-dpng', '-r300')
% 
% cd('C:\Temp\Diffusion\MOL_PDE\1. Source files\Overlay_post_calc')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Simple
figure(1); plot(0,0,'-b',0,0,'-r', 0,0,'-k')
figure(2); plot(0,0,'-b',0,0,'-r', 0,0,'-k')
figure(3); plot(0,0,'-b',0,0,'-r', 0,0,'-k')

load('C:\Temp\Diffusion\MOL_PDE\4. Output files\Docherty\Data_0_3.mat')


peek = Dotts( Z2 );
dots2Lines( peek, 'b', x, t, 1);

% SD
peek = Dotts( Z2b );
dots2Lines( peek, 'b', x, t, 2);

% ED
peek = Dotts( Z3 );
dots2Lines( peek, 'b', x, t, 3);

%% different base
load('C:\Temp\Diffusion\MOL_PDE\4. Output files\Docherty\Data_1_3.mat')

peek = Dotts( Z2 );
dots2Lines( peek, 'r', x, t, 1);

% SD
peek = Dotts( Z2b );
dots2Lines( peek, 'r', x, t, 2);

% ED
peek = Dotts( Z3 );
dots2Lines( peek, 'r', x, t, 3);

%% different base
load('C:\Temp\Diffusion\MOL_PDE\4. Output files\Docherty\Data_2_3.mat')

peek = Dotts( Z2 );
dots2Lines( peek, 'k', x, t, 1);

%% SD
peek = Dotts( Z2b );
dots2Lines( peek, 'k', x, t, 2);

%% ED
peek = Dotts( Z3 );
dots2Lines( peek, 'k', x, t, 3);

%% Fix plots

figure(1)
axis([0, t(end), 0,1])
xlabel('Time, [s]')
ylabel('Space, x')
title('Simple')
legend('0', '0.25', '0.275')

figure(2)
axis([0, t(end), 0,1])
xlabel('Time, [s]')
ylabel('Space, x')
title('SD')
legend('0', '0.25', '0.275')

figure(3)
axis([0, t(end), 0,1])
xlabel('Time, [s]')
ylabel('Space, x')
title('ED')
legend('0', '0.25', '0.275')

cd('C:\Temp\Diffusion\MOL_PDE\4. Output files\Docherty')
for i = 1:3
    figure(i)
    set(gcf,'PaperPositionMode','auto')
    print(['DiffBase_3_', num2str(i)],'-dpng', '-r300')
end

cd('C:\Temp\Diffusion\MOL_PDE\1. Source files\Overlay_post_calc')
    