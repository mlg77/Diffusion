function [  ] = MyPlot(Goldbeter, Ernmentrout, Toy1, Toy2, FitzHugh,KathiEdit,Dupont, D)
% Plot the things that were run 
%	Standard Plot for each then depending on what extras desired also plot
%	Standard plot is image Z for each Diffusion, my beta, wave shape and bifurcation 

close all
NumberofFigs = 0;
wave_point = 0.4;

if Goldbeter.On == 1
	NumberofFigs = NumberofFigs+1;
	
	% Pre calculations for standard plot 
	pos = wave_point*abs(Goldbeter.x(end) - Goldbeter.x(1));
	[ Waveone, backwardsWave, t_wave ] = OneWave( Goldbeter.Z0D, Goldbeter.t, Goldbeter.x, pos);
    [ Per_f_heavy ] = Percentage_forward_heavy( Waveone, backwardsWave, t_wave )
    [ FH_score ] = FH_scoreCalc( Goldbeter.Z0D(round(pos*length(Goldbeter.x)), :) )
	bipoints = Bifurcation_points( Goldbeter.x,Goldbeter.t,Goldbeter.Z0D );  % Currently not used
	max_Z = max(Goldbeter.Z0D(:, round(length(Goldbeter.t)/2):end)'); 
	min_Z = min(Goldbeter.Z0D(:, round(length(Goldbeter.t)/2):end)');
    B_b = find(abs(max_Z-min_Z)>0.1*max(max_Z), 1);	
    
	% Standard Plot
	figure(NumberofFigs)
	subplot(2,3,1); 	imagesc(Goldbeter.t,flipud(Goldbeter.x),Goldbeter.Z0D)
    hold on;            plot([Goldbeter.t(1), Goldbeter.t(end)],[Goldbeter.x(B_b), Goldbeter.x(B_b)], 'k', 'linewidth', 2)
	subplot(2,3,2); 	imagesc(Goldbeter.t,flipud(Goldbeter.x),Goldbeter.ZFD)
    hold on;            plot([Goldbeter.t(1), Goldbeter.t(end)],[Goldbeter.x(B_b), Goldbeter.x(B_b)], 'k', 'linewidth', 2)
	subplot(2,3,3); 	plot(Goldbeter.mybeta, Goldbeter.x)
	subplot(2,3,4:5); 	plot(t_wave, Waveone, t_wave, backwardsWave)
	subplot(2,3,6);		plot(Goldbeter.x, max_Z, 'b', Goldbeter.x, min_Z, 'b')
% 	suptitle('Goldbeter')
    
    figure(2)
    max_Z = max(Goldbeter.Z0D(:, round(length(Goldbeter.t)/2):end)'); 
	min_Z = min(Goldbeter.Z0D(:, round(length(Goldbeter.t)/2):end)');
    subplot(1,2,1);	hold on;	plot(Goldbeter.x, max_Z, 'r', Goldbeter.x, min_Z, 'r')
     max_Z = max(Goldbeter.Y0D(:, round(length(Goldbeter.t)/2):end)'); 
	min_Z = min(Goldbeter.Y0D(:, round(length(Goldbeter.t)/2):end)');
    subplot(1,2,2);	hold on;	plot(Goldbeter.x, max_Z, 'r', Goldbeter.x, min_Z, 'r')
        
    subplot(1,2,1); xlabel('\beta'); ylabel('Cytosolic Calcium [\muM]')
    subplot(1,2,2); xlabel('\beta'); ylabel('Intracellular Store Calcium [\muM]')

end
if Ernmentrout.On == 1
	NumberofFigs = NumberofFigs+1;

	% Pre calculations for standard plot 
	pos = wave_point*abs(Ernmentrout.x(end) - Ernmentrout.x(1));
	[ Waveone, backwardsWave, t_wave ] = OneWave( Ernmentrout.Z0D, Ernmentrout.t, Ernmentrout.x, pos);
%     [ Per_f_heavy ] = Percentage_forward_heavy( Waveone, backwardsWave, t_wave )
    [ FH_score ] = FH_scoreCalc( Ernmentrout.Z0D(round(pos*length(Ernmentrout.x)), :) )
	bipoints = Bifurcation_points( Ernmentrout.x,Ernmentrout.t,Ernmentrout.Z0D );  % Currently not used
	max_Z = max(Ernmentrout.Z0D(:, round(length(Ernmentrout.t)/2):end)'); 
	min_Z = min(Ernmentrout.Z0D(:, round(length(Ernmentrout.t)/2):end)');
	B_b = find(abs(max_Z-min_Z)>0.1*max(max_Z), 1);
    
	% Standard Plot
	figure(NumberofFigs)
	subplot(2,3,1); 	imagesc(Ernmentrout.t,flipud(Ernmentrout.x),Ernmentrout.Z0D)
    hold on;            plot([Ernmentrout.t(1), Ernmentrout.t(end)],[Ernmentrout.x(B_b), Ernmentrout.x(B_b)], 'k', 'linewidth', 2)
	subplot(2,3,2); 	imagesc(Ernmentrout.t,flipud(Ernmentrout.x),Ernmentrout.ZFD)
	hold on;            plot([Ernmentrout.t(1), Ernmentrout.t(end)],[Ernmentrout.x(B_b), Ernmentrout.x(B_b)], 'k', 'linewidth', 2)
    subplot(2,3,3); 	plot(Ernmentrout.mybeta, Ernmentrout.x)
	subplot(2,3,4:5); 	plot(t_wave, Waveone, t_wave, backwardsWave)
	subplot(2,3,6);		plot(Ernmentrout.x, max_Z, 'b', Ernmentrout.x, min_Z, 'b')
% 	suptitle('Ernmentrout')
	
end
if Toy1.On == 1
	NumberofFigs = NumberofFigs+1;
	
	% Pre calculations for standard plot 
	pos = wave_point*abs(Toy1.x(end) - Toy1.x(1));
	[ Waveone, backwardsWave, t_wave ] = OneWave( Toy1.Z0D, Toy1.t, Toy1.x, pos);
%     [ Per_f_heavy ] = Percentage_forward_heavy( Waveone, backwardsWave, t_wave )
    [ FH_score ] = FH_scoreCalc( Toy1.Z0D(round(pos*length(Toy1.x)), :) )
	bipoints = Bifurcation_points( Toy1.x,Toy1.t,Toy1.Z0D );  % Currently not used
	max_Z = max(Toy1.Z0D(:, round(length(Toy1.t)*3/4):end)'); 
	min_Z = min(Toy1.Z0D(:, round(length(Toy1.t)*3/4):end)');
	B_b = find(abs(max_Z-min_Z)>0.1*max(max_Z), 1);
    
	% Standard Plot
	figure(NumberofFigs)
	subplot(2,3,1); 	imagesc(Toy1.t,flipud(Toy1.x),Toy1.Z0D)
    hold on;            plot([Toy1.t(1), Toy1.t(end)],[Toy1.x(B_b), Toy1.x(B_b)], 'k', 'linewidth', 2)
	subplot(2,3,2); 	imagesc(Toy1.t,flipud(Toy1.x),Toy1.ZFD)
    hold on;            plot([Toy1.t(1), Toy1.t(end)],[Toy1.x(B_b), Toy1.x(B_b)], 'k', 'linewidth', 2)
	subplot(2,3,3); 	plot(Toy1.mybeta, Toy1.x)
    subplot(2,3,4:5); 	plot(t_wave, Waveone, t_wave, backwardsWave)
	subplot(2,3,6);		plot(Toy1.x, max_Z, 'b', Toy1.x, min_Z, 'b')
% 	suptitle('ToyModel')

end

if Toy2.On == 1
	NumberofFigs = NumberofFigs+1;
	
	% Pre calculations for standard plot 
	pos = wave_point*abs(Toy2.x(end) - Toy2.x(1));
	[ Waveone, backwardsWave, t_wave ] = OneWave( Toy2.Z0D, Toy2.t, Toy2.x, pos);
%     [ Per_f_heavy ] = Percentage_forward_heavy( Waveone, backwardsWave, t_wave )
    [ FH_score ] = FH_scoreCalc( Toy2.Z0D(round(pos*length(Toy2.x)), :) )
	bipoints = Bifurcation_points( Toy2.x,Toy2.t,Toy2.Z0D );  % Currently not used
	max_Z = max(Toy2.Z0D(:, round(length(Toy2.t)*3/4):end)'); 
	min_Z = min(Toy2.Z0D(:, round(length(Toy2.t)*3/4):end)');
	B_b = find(abs(max_Z-min_Z)>0.1*max(max_Z), 1);
    
	% Standard Plot
	figure(NumberofFigs)
	subplot(2,3,1); 	imagesc(Toy2.t,flipud(Toy2.x),Toy2.Z0D)
    hold on;            plot([Toy2.t(1), Toy2.t(end)],[Toy2.x(B_b), Toy2.x(B_b)], 'k', 'linewidth', 2)
	subplot(2,3,2); 	imagesc(Toy2.t,flipud(Toy2.x),Toy2.ZFD)
    hold on;            plot([Toy2.t(1), Toy2.t(end)],[Toy2.x(B_b), Toy2.x(B_b)], 'k', 'linewidth', 2)
	subplot(2,3,3); 	plot(Toy2.mybeta, Toy2.x)
	subplot(2,3,4:5); 	plot(t_wave, Waveone, t_wave, backwardsWave)
	subplot(2,3,6);		plot(Toy2.x, max_Z, 'b', Toy2.x, min_Z, 'b')
% 	suptitle('ToyModel')

end

if FitzHugh.On == 1
    NumberofFigs = NumberofFigs+1;
    % Pre calculations for standard plot 
	pos = wave_point*abs(FitzHugh.x(end) - FitzHugh.x(1));
	[ Waveone, backwardsWave, t_wave ] = OneWave( FitzHugh.Z0D, FitzHugh.t, FitzHugh.x, pos);
%     [ Per_f_heavy ] = Percentage_forward_heavy( Waveone, backwardsWave, t_wave )
    [ FH_score ] = FH_scoreCalc( FitzHugh.Z0D(round(pos*length(FitzHugh.x)), :) )
	bipoints = Bifurcation_points( FitzHugh.x,FitzHugh.t,FitzHugh.Z0D );  % Currently not used
	max_Z = max(FitzHugh.Z0D(:, round(length(FitzHugh.t)*3/4):end)'); 
	min_Z = min(FitzHugh.Z0D(:, round(length(FitzHugh.t)*3/4):end)');
	B_b = find(abs(max_Z-min_Z)>0.1*max(max_Z), 1);
    
	% Standard Plot
	figure(NumberofFigs)
	subplot(2,3,1); 	imagesc(FitzHugh.t,flipud(FitzHugh.x),FitzHugh.Z0D)
    hold on;            plot([FitzHugh.t(1), FitzHugh.t(end)],[FitzHugh.x(B_b), FitzHugh.x(B_b)], 'k', 'linewidth', 2)
	subplot(2,3,2); 	imagesc(FitzHugh.t,flipud(FitzHugh.x),FitzHugh.ZFD)
    hold on;            plot([FitzHugh.t(1), FitzHugh.t(end)],[FitzHugh.x(B_b), FitzHugh.x(B_b)], 'k', 'linewidth', 2)
	subplot(2,3,3); 	plot(FitzHugh.mybeta, FitzHugh.x)
	subplot(2,3,4:5); 	plot(t_wave, Waveone, t_wave, backwardsWave)
	subplot(2,3,6);		plot(FitzHugh.x, max_Z, 'b', FitzHugh.x, min_Z, 'b')
end
if KathiEdit.On == 1
	NumberofFigs = NumberofFigs+1;
	
% 	Pre calculations for standard plot 
% 	pos = (1-wave_point)*abs(KathiEdit.x(end) - KathiEdit.x(1));
% 	[ Waveone, backwardsWave, t_wave ] = OneWave( KathiEdit.Z0D, KathiEdit.t, KathiEdit.x, pos);
%     [ Per_f_heavy ] = Percentage_forward_heavy( Waveone, backwardsWave, t_wave )
%     [ FH_score ] = FH_scoreCalc( KathiEdit.Z0D(round(pos*length(KathiEdit.x)), :) )
% 	bipoints = Bifurcation_points( KathiEdit.x,KathiEdit.t,KathiEdit.Z0D );  % Currently not used
% 	max_Z = max(KathiEdit.Z0D(:, round(length(KathiEdit.t)/2):end)'); 
% 	min_Z = min(KathiEdit.Z0D(:, round(length(KathiEdit.t)/2):end)');
%     B_b = find(abs(max_Z-min_Z)>0.1*max(max_Z), 1);	
    
	% Standard Plot
	figure(NumberofFigs)
	subplot(2,3,1); 	imagesc(KathiEdit.t,flipud(KathiEdit.x),KathiEdit.Z0D)
%     hold on;            plot([KathiEdit.t(1), KathiEdit.t(end)],[KathiEdit.x(B_b), KathiEdit.x(B_b)], 'k', 'linewidth', 2)
% 	subplot(2,3,2); 	imagesc(KathiEdit.t,flipud(KathiEdit.x),KathiEdit.ZFD)
%     hold on;            plot([KathiEdit.t(1), KathiEdit.t(end)],[KathiEdit.x(B_b), KathiEdit.x(B_b)], 'k', 'linewidth', 2)
	subplot(2,3,3); 	plot(KathiEdit.mybeta, KathiEdit.x)
% 	subplot(2,3,4:5); 	plot(t_wave, Waveone, t_wave, backwardsWave)
% 	subplot(2,3,6);		plot(KathiEdit.x, max_Z, 'b', KathiEdit.x, min_Z, 'b')
% 	suptitle('Kathi Edit')
    
    Z = [KathiEdit.Z0D(1,end) , KathiEdit.Z0D(end,end)]
    Y = [KathiEdit.Y0D(1,end) , KathiEdit.Y0D(end,end)]
    V = [KathiEdit.V0D(1,end) , KathiEdit.V0D(end,end)]

end
if Dupont.On == 1
	NumberofFigs = NumberofFigs+1;
	
	% Pre calculations for standard plot 
	pos = wave_point*abs(Dupont.x(end) - Dupont.x(1));
	[ Waveone, backwardsWave, t_wave ] = OneWave( Dupont.Z0D, Dupont.t, Dupont.x, pos);
%     [ Per_f_heavy ] = Percentage_forward_heavy( Waveone, backwardsWave, t_wave )
    [ FH_score ] = FH_scoreCalc( Dupont.Z0D(round(pos*length(Dupont.x)), :) )
	bipoints = Bifurcation_points( Dupont.x,Dupont.t,Dupont.Z0D );  % Currently not used
	max_Z = max(Dupont.Z0D(:, round(length(Dupont.t)/2):end)'); 
	min_Z = min(Dupont.Z0D(:, round(length(Dupont.t)/2):end)');
    B_b = find(abs(max_Z-min_Z)>0.1*max(max_Z), 1);	
    
	% Standard Plot
	figure(NumberofFigs)
	subplot(2,3,1); 	imagesc(Dupont.t,flipud(Dupont.x),Dupont.Z0D)
    hold on;            plot([Dupont.t(1), Dupont.t(end)],[Dupont.x(B_b), Dupont.x(B_b)], 'k', 'linewidth', 2)
	subplot(2,3,2); 	imagesc(Dupont.t,flipud(Dupont.x),Dupont.ZFD)
    hold on;            plot([Dupont.t(1), Dupont.t(end)],[Dupont.x(B_b), Dupont.x(B_b)], 'k', 'linewidth', 2)
	subplot(2,3,3); 	plot(Dupont.mybeta, Dupont.x)
	subplot(2,3,4:5); 	plot(t_wave, Waveone, t_wave, backwardsWave)
	subplot(2,3,6);		plot(Dupont.x, max_Z, 'b', Dupont.x, min_Z, 'b')
% 	suptitle('Goldbeter')

    figure()
    max_Z = max(Dupont.Z0D(:, round(length(Dupont.t)/2):end)'); 
	min_Z = min(Dupont.Z0D(:, round(length(Dupont.t)/2):end)');
    subplot(1,2,1);	hold on;	plot(Dupont.x, max_Z, 'r', Dupont.x, min_Z, 'r')
     max_Z = max(Dupont.Y0D(:, round(length(Dupont.t)/2):end)'); 
	min_Z = min(Dupont.Y0D(:, round(length(Dupont.t)/2):end)');
    subplot(1,2,2);	hold on;	plot(Dupont.x, max_Z, 'r', Dupont.x, min_Z, 'r')
        
    subplot(1,2,1); xlabel('\beta'); ylabel('Cytosolic Calcium [\muM]')
    subplot(1,2,2); xlabel('\beta'); ylabel('Intracellular Store Calcium [\muM]')
    
end


for ii = 1:NumberofFigs
	figure(ii)
	subplot(2,3,1)
		set(gca,'YDir','normal')
		xlabel('Time, [s]')
		ylabel('Position, x')
		title('Zero diffusion')
		colormap jet
		hold on
	subplot(2,3,2)
		set(gca,'YDir','normal')
		xlabel('Time, [s]')
		ylabel('Position, x')
		title('Diffusion')
		colormap jet
		hold on
	subplot(2,3,3)
		xlabel('Beta, \beta ')
		ylabel('Position, x')
	subplot(2,3,4:5)
		xlabel('Time, [s] ')
		ylabel('Concentration')
		legend('Forwards', 'Backwards')
	subplot(2,3,6)
		xlabel('Position, x ')
		ylabel('Concentration')
		title('Bifurcation Diagram')
end

prompt = 'Would you like to plot any of the following?:\n Option 1, Percentage Effect,\n Option 2, Fluxes for Kathi, \n Enter numbers (no space) or no: ';
furtherplotting = input(prompt, 's');
if isempty(strfind(furtherplotting,'1')) == 0 % CHeck this works
    
    % Temp To Run Percentage effect
    if Goldbeter.On
        Z_inQ = Goldbeter.Z0D;
        FZ_inQ = Goldbeter.ZFD;
        dx = Goldbeter.x(2)-Goldbeter.x(1);
        dt = Goldbeter.t(2)-Goldbeter.t(1);
        t = Goldbeter.t;
        x = Goldbeter.x;
    elseif Ernmentrout.On
        Z_inQ = Ernmentrout.Z0D;
        FZ_inQ = Ernmentrout.ZFD;
        dx = Ernmentrout.x(2)-Ernmentrout.x(1);
        dt = Ernmentrout.t(2)-Ernmentrout.t(1);
        t = Ernmentrout.t;
        x = Ernmentrout.x;
    elseif FitzHugh.On
        Z_inQ = FitzHugh.Z0D;
        FZ_inQ = FitzHugh.ZFD;
        dx = FitzHugh.x(2)-FitzHugh.x(1);
        dt = FitzHugh.t(2)-FitzHugh.t(1);
        t = FitzHugh.t;
        x = FitzHugh.x;
    elseif Toy2.On
        Z_inQ = Toy2.Z0D;
        FZ_inQ = Toy2.ZFD;
        dx = Toy2.x(2)-Toy2.x(1);
        dt = Toy2.t(2)-Toy2.t(1);
        t = Toy2.t;
        x = Toy2.x;
    elseif Toy1.On
        Z_inQ = Toy1.Z0D;
        FZ_inQ = Toy1.ZFD;
        dx = Toy1.x(2)-Toy1.x(1);
        dt = Toy1.t(2)-Toy1.t(1);
        t = Toy1.t;
        x = Toy1.x;
    end
    % Find the Bifurcation point
%     max_Z = max(Z_inQ(:, round(length(Vtime)/2):end)');
%     min_Z = min(Z_inQ(:, round(length(Vtime)/2):end)');
%     B_b = find(abs(max_Z-min_Z)>0.1*max(max_Z), 1);
    
    max_Z = max(Z_inQ(:, round(length(t)*3/4):end)'); 
	min_Z = min(Z_inQ(:, round(length(t)*3/4):end)');
	B_b = find(abs(max_Z-min_Z)>0.1*max(max_Z), 1);
    % Go a little above
    xstar = x(B_b)+0.05-dx/2;
    xstar_idx = find(x>= xstar, 1);
    % figure(); plot( t, Z_inQ(xstar_idx,:))
    % Run Per Effect
    offsetby = 0.999:-0.0001:0.75;
    [ PercentageEffect ] = Percentage_Effect( Z_inQ(xstar_idx,:), dt, dx, D , offsetby );
    drop = find(PercentageEffect<=0,1);
    if drop == 1
        abovedrop = find(PercentageEffect>=0,1);
        newdrop = find(PercentageEffect(abovedrop:end)<=0, 1);
        drop = newdrop + abovedrop;
    end
    figure();
    plot(100*(1-offsetby), PercentageEffect, 'linewidth', 2)
    grid on
    xlabel('Phase Lag Percentage of Period')
    ylabel('Percentage Effect')
    
    offsetby(drop)
    
    figure(); subplot(3,1,1)
    hold on;
    plot(t, Z_inQ(xstar_idx,:));     plot(t, Z_inQ(xstar_idx+1,:))
    xlabel('Time [s]'); ylabel('\Phi')
    legend('x*', 'x*+dx')
    % phase lag over time
    [pks, locs] = findpeaks(Z_inQ(xstar_idx,:));
    [pks2, locs2] = findpeaks(Z_inQ(xstar_idx+1,:));
    phaselag_over_time = t(locs) - t(locs2);
    subplot(3,1,2); hold on;
    T_xstar = t(locs(3))- t(locs(2));
    plot(t(locs), phaselag_over_time/T_xstar, 'gx-', 'linewidth', 2)
    plot([t(locs(1)),t(locs(end))], (1-offsetby([drop,drop])),'k', 'linewidth', 2)
    xlabel('Time [s]'); ylabel('Phase Lag between x* and x*+dx')
    legend('Actual Phase Lag', 'Threshold phase lag According to %Effect')
    subplot(3,1,3); hold on;
    imagesc(t,flipud(x),FZ_inQ)
    plot([t(1), t(end)],[x(B_b), x(B_b)], 'k', 'linewidth', 2)
    set(gca,'YDir','normal'); 		
    xlabel('Time, [s]'); ylabel('Position, x'); title('Diffusion')
    colormap jet
    axis([t(1), t(end), 0, 1])
end
if isempty(strfind(furtherplotting,'2')) == 0 % CHeck this works
	% Plot Fluxes
    % Order  [J_ext, J_ip3r,J_cicr,J_serca,J_vocc,J_srleak,J_NaCa, J_NaK, J_Cl]

    Fluxes_Names = [{'J ext'}, {'J ip3r'},{'J cicr'},{'J serca'},{'J vocc'},{'J srleak'},{'J NaCa'}, {'J NaK'}, {'J Cl'}];
    save_fluxes = zeros(length(KathiEdit.x), length(KathiEdit.t), length(Fluxes_Names));
    for ii = 1:length(KathiEdit.t)
        [ dydt , L_Z, L_Y, d2Zdx2, Fluxes] = odefun_Kathiedit( KathiEdit.t(ii), KathiEdit.y0D(ii, :)' , KathiEdit.mybeta, 1, 0);
        for jj = 1:length(Fluxes_Names)
            save_fluxes(:, ii, jj) = Fluxes(:, jj);
        end
    end

    figure()
    for ii = 1:length(Fluxes_Names)
        subplot(3,3,ii)
        imagesc(KathiEdit.t,flipud(KathiEdit.x),save_fluxes(:, :, ii))
        title(Fluxes_Names{ii})
        
        set(gca,'YDir','normal')
        xlabel('Time, [s]'); 	ylabel('Position, x')
        colormap jet;    colorbar
    end


    figure()
    subplot(1,3,1)
    imagesc(KathiEdit.t,flipud(KathiEdit.x),KathiEdit.Z0D)
    title('Z')
    set(gca,'YDir','normal')
	xlabel('Time, [s]'); 	ylabel('Position, x')
	colormap jet;     colorbar
    
    subplot(1,3,2)
    imagesc(KathiEdit.t,flipud(KathiEdit.x),KathiEdit.V0D)
    title('V')
    set(gca,'YDir','normal')
	xlabel('Time, [s]'); 	ylabel('Position, x')
	colormap jet;     colorbar
    
    subplot(1,3,3)
    imagesc(KathiEdit.t,flipud(KathiEdit.x),KathiEdit.Y0D)
    title('Y')
    set(gca,'YDir','normal')
	xlabel('Time, [s]'); 	ylabel('Position, x')
	colormap jet;     colorbar
    end

end

