% Toy Model 2 changing percentage front heavy attempt
% Author: Michelle Goodman
% Date: 2/01/2017

clear; clc; close all; 
tic

%% File Location
AllDir.ParentDir = 'C:\Temp\Diffusion\MOL_PDE\';
AllDir.SourceDir = '1. Source files\10. CLean Up Of Run\';
AllDir.SaveDir = '4. Output files\NewFormat';
AllDir.Analysis = 'Analysis_functions';

addpath(AllDir.Analysis)


	t0 = 0;   t1 = 5000; dt = 0.05;
	dx = 1e-3;  
	x = (0:dx:1);    M = length(x); 
% 	mybeta = 0.2*(1+tanh((x-0.5)/0.4))'; % HomoPaper Front heavy
    mybeta = x'*(0.4-0.15) + 0.15; 
	X_0 = -0.5; Y_0 = 0.5; 
	y0 = [x*0+X_0, x*0+Y_0];
    factor_front_heavy = [0.5:0.02:0.66];
%     factor_front_heavy = [0.55:0.01:0.73];
    
    WaveConsidered.Waveone = [];
    WaveConsidered.backwardsWave = [];
    WaveConsidered.t_wave = [];
    
    % Wave two
%     xConsidered.WavexstarF = [];
%     xConsidered.xstarplus = [];
%     xConsidered.xstarminus = [];
%     xConsidered.thet = [];
%     xConsidered.belowBi = [];
    xConsidered = [];
    
    M = length(x); 
    mtol = 1e-6;
    odeoptions = odeset('RelTol',mtol, 'AbsTol', mtol );
    tspan = [t0:dt: t1];
    
    Data_each_round = [];
    count = 0;
    tic

for ii = factor_front_heavy
        count = count + 1;
        display([num2str(count), '/', num2str(length(factor_front_heavy))]);
		Toy2.On = 1;
        toymodelNo = [2, ii];
		
		Diff_type = 1; D =0;
		display(['Diffusion = ', num2str(D)])
		[t, y0D] = ode45(@(t,y) odefun_ToyH(t,y,mybeta,Diff_type, D, toymodelNo), tspan, y0, odeoptions);
		Toy2.Z0D = y0D(:, 1:M)';
		Toy2.V0D = y0D(:, M+1:2*M)';

		Diff_type = 1; D =6e-6;
		display(['Diffusion = ', num2str(D)])
		[t, yFD] = ode45(@(t,y) odefun_ToyH(t,y,mybeta,Diff_type, D, toymodelNo), tspan, y0, odeoptions);
		Toy2.ZFD = yFD(:, 1:M)';
		Toy2.VFD = yFD(:, M+1:2*M)';
		
		Toy2.t = t;
		Toy2.mybeta = mybeta;
		Toy2.x = x;
        
        
        %
        
        max_Z = max(Toy2.Z0D(:, round(length(Toy2.t)*3/4):end)'); 
        min_Z = min(Toy2.Z0D(:, round(length(Toy2.t)*3/4):end)');
        B_b = find(abs(max_Z-min_Z)>0.1*abs(max(max_Z)- min(min_Z)), 1);	
        if B_b == 1 
            backto = find(abs(max_Z-min_Z)<0.1*max(max_Z), 1);	
            B_b = find(abs(max_Z(backto:end)-min_Z(backto:end))>0.1*abs(max(max_Z)- min(min_Z)), 1)+backto;	
        end
        
        
%         wave_point = 0.9;
%         pos = wave_point*abs(Toy2.x(end) - Toy2.x(1));     
        pos = Toy2.x(B_b)+0.04-dx/2;
        [ Waveone, backwardsWave, t_wave ] = OneWave( Toy2.Z0D, Toy2.t, Toy2.x, pos);
        WaveConsidered.Waveone(count, 1:length(Waveone)) = Waveone;
        WaveConsidered.backwardsWave(count, 1:length(Waveone)) = backwardsWave;
        WaveConsidered.t_wave(count, 1:length(Waveone)) = t_wave;
        
        % Profile FD
        idx_q = find(x >= pos,1);
%         xConsidered.WavexstarF(count, 1:length(t)) = Toy2.ZFD(idx_q,:);
%         xConsidered.xstarplusF(count, 1:length(t)) = Toy2.ZFD(idx_q+1,:);
%         xConsidered.xstarminusF(count, 1:length(t)) = Toy2.ZFD(idx_q-1,:);
%         xConsidered.thet(count, 1:length(t)) = t;
%         
        pos2 = Toy2.x(B_b)-0.04-dx/2;
        idx_q2 = find(x >= pos2,1);
%         xConsidered.belowBi(count, 1:length(t)) = Toy2.ZFD(idx_q2,:);
        xConsidered(1:length(idx_q2:idx_q+1), 1:length(t), count) = Toy2.ZFD(idx_q2:idx_q+1,:);


        [ Per_f_heavy ] = Percentage_forward_heavy( Waveone, backwardsWave, t_wave );
        
        
        max_Z = max(Toy2.ZFD(:, round(length(Toy2.t)*1/4):end)'); 
        min_Z = min(Toy2.ZFD(:, round(length(Toy2.t)*1/4):end)');
        pene = find(abs(max_Z-min_Z)>0.1*abs(max(max_Z)- min(min_Z)), 1);
        if pene == 1 
            backto = find(abs(max_Z-min_Z)<0.1*max(max_Z), 1);	
            pene = find(abs(max_Z(backto:end)-min_Z(backto:end))>0.1*abs(max(max_Z)- min(min_Z)), 1)+backto;	
        end
        
        
        Data_each_round(end+1, :) = [ii, Per_f_heavy, B_b, pene];
%         figure(1)
%         subplot(3,4,count); imagesc(Toy2.t,flipud(Toy2.x),Toy2.Z0D)
%         hold on;            plot([Toy2.t(1), Toy2.t(end)],[Toy2.x(B_b), Toy2.x(B_b)], 'k', 'linewidth', 2)
%         title(num2str(Per_f_heavy))
%         set(gca,'YDir','normal')
% 		xlabel('Time, [s]')
% 		ylabel('Position, x')
% 		colormap jet
% 		hold on
%         
        figure(2)
        subplot(3,3,count); imagesc(Toy2.t,flipud(Toy2.x),Toy2.ZFD)
        hold on;            
        plot([Toy2.t(1), Toy2.t(end)],[Toy2.x(B_b), Toy2.x(B_b)], 'k', 'linewidth', 2)
        plot([Toy2.t(1), Toy2.t(end)],[Toy2.x(idx_q2), Toy2.x(idx_q2)], 'k', 'linewidth', 1)
        plot([Toy2.t(1), Toy2.t(end)],[Toy2.x(idx_q+1), Toy2.x(idx_q+1)], 'k', 'linewidth', 1)
        title(num2str(Per_f_heavy))
        set(gca,'YDir','normal')
		xlabel('Time, [s]')
		ylabel('Position, x')
		colormap jet
		hold on
        
        figure(4)
        subplot(3,3,count); imagesc(Toy2.t,flipud(Toy2.x(idx_q2:idx_q+1)),xConsidered(:,:,count))
        hold on;            
        plot([Toy2.t(1), Toy2.t(end)],[Toy2.x(B_b), Toy2.x(B_b)], 'k', 'linewidth', 2)
        title(num2str(Per_f_heavy))
        set(gca,'YDir','normal')
		xlabel('Time, [s]')
		ylabel('Position, x')
		colormap jet
		hold on
%         
%         figure(3)
%         subplot(3,4,count); plot(t_wave, Waveone, t_wave, backwardsWave)
%         title(num2str(Per_f_heavy))
        
end


Data_each_round(:,5) = x(Data_each_round(:,3));
Data_each_round(:,6) = x(Data_each_round(:,4));
Data_each_round(:,7) = Data_each_round(:,5)-Data_each_round(:,6);
% 
% figure(); 
% subplot(1,3,1); plot(Data_each_round(:,2), Data_each_round(:,1))
% xlabel('Front heavy clasifation'); ylabel('\xi')
% 
% subplot(1,3,2); plot(Data_each_round(:,2), Data_each_round(:,7))
% xlabel('Front heavy clasifation'); ylabel('Difference')

load handel
sound(y,Fs)
toc
