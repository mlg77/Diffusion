
clear; clc; close all


AllDir.ParentDir = 'C:\Temp\Diffusion\MOL_PDE\';

AllDir.SourceDir = '1. Source files';
AllDir.InitalDataDir = '2. Inital Data';
AllDir.SaveDir = '4. Output files\Docherty';

diffusion = [0.5e-6:0.5e-6:10e-6];
BetaBase = 0.2:0.01:0.26;
Betalow = 0.3:0.05:0.7;
% BetaBase = 0.25;
% Betalow = 0.6;
BetaHigh = Betalow;

% Occ_Simple = zeros(length(BetaBase), length(Betalow));
% Occ_Diff = zeros(length(BetaBase), length(Betalow));
% total_num = size(Occ_Simple, 1)*size(Occ_Simple, 2);
count = 0;
tic
for k = 1:length(diffusion)
    for i = 1:length(BetaBase)
        for j = 1:length(Betalow)
            count = count + 1;
            %         cd ([AllDir.ParentDir, AllDir.SourceDir])
            [ Z2, Z2b, Z3, t, x, B ] = Docherty_Temp( BetaBase(i), Betalow(j), BetaHigh(j), diffusion(k) );
            %         cd ([AllDir.ParentDir, AllDir.SaveDir])
            %         save(['Data_', num2str(i-1),'_', num2str(j)])
            %         figure('units','normalized','outerposition',[0 0 1 1])
            %         subplot(1,3,1); plot(B,flipud(x))
            %         ylabel('Position, x');  xlabel('beta, [-]')
            %         title('Beta')
            %         axis([0,1,0,0.3])
            %         subplot(1,3,2); imagesc(t,flipud(x),Z2b)
            %         title('Z, Calcium Concentration in the Cytosol 6e-6 diffusion, [\muM]')
            %         subplot(1,3,3); imagesc(t,flipud(x),Z3)
            %         title('Z, Calcium Concentration in the Cytosol 6e-6 Electro diffusion, [\muM]')
            %         for k = 2:3
            %             subplot(1,3,k)
            %             set(gca,'YDir','normal')
            %             ylabel('Position, x');  xlabel('Time, [s]');
            %             colormap jet
            %             hold on
            %             plot([0,t(end)], [0.25, 0.25], 'k','LineWidth',2)
            %             colorbar
            %         end
            
            %         set(gcf,'PaperPositionMode','auto')
            %         print(['Fig_', num2str(i-1),'_', num2str(j)],'-dpng', '-r300')
            
            %% Is it occlatory
%             test_point = round(0.25*length(x));
%             test_range = round(0.5*length(t)):round(length(t));
%             if max(Z2b(test_point, test_range)) - min(Z2b(test_point, test_range)) > 0.4
%                 Occ_Simple(i,j) = 1;
%             end
%             if max(Z3(test_point, test_range)) - min(Z3(test_point, test_range)) > 0.4
%                 Occ_Diff(i,j) = 1;
%             end
%             toc
%             display([num2str(count), '/', num2str(total_num)])
            %% FFT stuff
            L = length(t)-1; Fs = 1/(t(2)-t(1));
            P_S = abs(fft(Z2(1,0.5*L:end))/L); P_SD = abs(fft(Z2b(1,0.5*L:end))/L); P_ED = abs(fft(Z3(1,0.5*L:end))/L);
            P_S = P_S(1:L/2+1); P_SD = P_SD(1:L/2+1); P_ED = P_ED(1:L/2+1);
            P_S(2:end-1) = 2*P_S(2:end-1); P_SD(2:end-1) = 2*P_SD(2:end-1); P_ED(2:end-1) = 2*P_ED(2:end-1);
            
            P_S2 = abs(fft(Z2(2,:))/L); P_SD2 = abs(fft(Z2b(2,:))/L); P_ED2 = abs(fft(Z3(2,:))/L);
            P_S2 = P_S2(1:L/2+1); P_SD2 = P_SD2(1:L/2+1); P_ED2 = P_ED2(1:L/2+1);
            P_S2(2:end-1) = 2*P_S2(2:end-1); P_SD2(2:end-1) = 2*P_SD2(2:end-1); P_ED2(2:end-1) = 2*P_ED2(2:end-1);
            
            f = Fs*(0:(L/2))/L;

            figure('units','normalized','outerposition',[0 0 1 1])
            suptitle(['D = ', num2str(diffusion(k))])
            subplot(1,4,1); plot(f, P_S, 'b', f, P_S2, 'r'); axis([0,5,0,0.35])
                legend(['. lower = ', num2str(BetaBase(i))],['. Upper = ', num2str(Betalow(j))])
                xlabel('f (Hz)'); ylabel('|P1(f)|'); title('Simple')
                max_f = find(max(P_S)==P_S); max_f2 = find(max(P_S2(2:end))==P_S2); Fgrid(count, 1:2) = [max_f, max_f2];
                text(f(max_f),P_S(max_f),['\leftarrow max f: ', num2str(f(max_f))])
                text(f(max_f2),P_S2(max_f2),['\leftarrow max f: ', num2str(f(max_f2))])
            subplot(1,4,2); plot(f, P_SD, 'b', f, P_SD2, 'r'); axis([0,5,0,0.35])
                xlabel('f (Hz)'); ylabel('|P1(f)|'); title('SimpleDiffusion')
                max_f = find(max(P_SD)==P_SD); max_f2 = find(max(P_SD2(2:end))==P_SD2); Fgrid(count, 3:4) = [max_f, max_f2];
                text(f(max_f),P_SD(max_f),['\leftarrow max f: ', num2str(f(max_f))])
                text(f(max_f2),P_SD2(max_f2),['\leftarrow max f: ', num2str(f(max_f2))])
            subplot(1,4,3); plot(f, P_ED, 'b', f, P_ED2, 'r'); axis([0,5,0,0.35])
                xlabel('f (Hz)'); ylabel('|P1(f)|'); title('Electro Diffusion')
                max_f = find(max(P_ED)==P_ED); max_f2 = find(max(P_ED2(2:end))==P_ED2); Fgrid(count, 5:6) = [max_f, max_f2];
                text(f(max_f),P_ED(max_f),['\leftarrow max f: ', num2str(f(max_f))])
                text(f(max_f2),P_ED2(max_f2),['\leftarrow max f: ', num2str(f(max_f2))])
            subplot(1,4,4); imagesc(t,flipud(x),Z2b); set(gca,'YDir','normal')
                xlabel('Time, [s]'); ylabel('Position, x'); colormap jet
                title('Z, Calcium Concentration in the Cytosol, [\muM]')
                    
        end
        toc
    end
end

% 
% figure()
% subplot(2,1,1); imagesc(Betalow, BetaBase, Occ_Simple)
% xlabel('Betahigh'); ylabel('Betabase'); title('Simple Diffusion'); set(gca,'YDir','normal')
% subplot(2,1,2); imagesc(Betalow, BetaBase, Occ_Diff)
% xlabel('Betahigh'); ylabel('Betabase'); title('Electro Diffusion'); set(gca,'YDir','normal')
% cd ([AllDir.ParentDir, AllDir.SaveDir])
% save('Grid_effect')

