function [  ] = MyPlot(Goldbeter, Ernmentrout, Toy)
% Plot the things that were run 
%	Standard Plot for each then depending on what extras desired also plot
%	Standard plot is image Z for each Diffusion, my beta, wave shape and bifurcation 
NumberofFigs = 0;

if Goldbeter.On == 1
	NumberofFigs = NumberofFigs+1;
	
	% Pre calculations for standard plot 
	pos = 0.75*abs(Goldbeter.x(end) - Goldbeter.x(1));
	[ Waveone, backwardsWave, t_wave ] = OneWave( Goldbeter.Z0D, Goldbeter.t, Goldbeter.x, pos);
	bipoints = Bifurcation_points( Goldbeter.x,Goldbeter.t,Goldbeter.Z0D );  % Currently not used
	max_Z = max(Goldbeter.Z0D); %% Check around the right way may need a transpose
	min_Z = min(Goldbeter.Z0D);
	
	% Standard Plot
	figure(NumberofFigs)
	subplot(2,3,1); 	imagesc(Goldbeter.t,flipud(Goldbeter.x),Goldbeter.Z0D)
	subplot(2,3,2); 	imagesc(Goldbeter.t,flipud(Goldbeter.x),Goldbeter.ZFD)
	subplot(2,3,3); 	plot(Goldbeter.mybeta, Goldbeter.x)
	subplot(2,3,4:5); 	plot(Waveone, t_wave, backwardsWave, t_wave)
	subplot(2,3,6);		plot(max_Z, Goldbeter.x, 'b', min_Z, Goldbeter.x, 'b')
	suptitle('Goldbeter')

end
if Ernmentrout.On == 1
	NumberofFigs = NumberofFigs+1;

	% Pre calculations for standard plot 
	pos = 0.75*abs(Ernmentrout.x(end) - Ernmentrout.x(1));
	[ Waveone, backwardsWave, t_wave ] = OneWave( Ernmentrout.Z0D, Ernmentrout.t, Ernmentrout.x, pos);
	bipoints = Bifurcation_points( Ernmentrout.x,Ernmentrout.t,Ernmentrout.Z0D );  % Currently not used
	max_Z = max(Ernmentrout.Z0D); %% Check around the right way may need a transpose
	min_Z = min(Ernmentrout.Z0D);
	
	% Standard Plot
	figure(NumberofFigs)
	subplot(2,3,1); 	imagesc(Ernmentrout.t,flipud(Ernmentrout.x),Ernmentrout.Z0D)
	subplot(2,3,2); 	imagesc(Ernmentrout.t,flipud(Ernmentrout.x),Ernmentrout.ZFD)
	subplot(2,3,3); 	plot(Ernmentrout.mybeta, Ernmentrout.x)
	subplot(2,3,4:5); 	plot(Waveone, t_wave, backwardsWave, t_wave)
	subplot(2,3,6);		plot(max_Z, Ernmentrout.x, 'b', min_Z, Ernmentrout.x, 'b')
	suptitle('Ernmentrout')
	
end
if Toy.On == 1
	NumberofFigs = NumberofFigs+1;
	
	% Pre calculations for standard plot 
	pos = 0.75*abs(Toy.x(end) - Toy.x(1));
	[ Waveone, backwardsWave, t_wave ] = OneWave( Toy.Z0D, Toy.t, Toy.x, pos);
	bipoints = Bifurcation_points( Toy.x,Toy.t,Toy.Z0D );  % Currently not used
	max_Z = max(Toy.Z0D); %% Check around the right way may need a transpose
	min_Z = min(Toy.Z0D);
	
	% Standard Plot
	figure(NumberofFigs)
	subplot(2,3,1); 	imagesc(Toy.t,flipud(Toy.x),Toy.Z0D)
	subplot(2,3,2); 	imagesc(Toy.t,flipud(Toy.x),Toy.ZFD)
	subplot(2,3,3); 	plot(Toy.mybeta, Toy.x)
	subplot(2,3,4:5); 	plot(Waveone, t_wave, backwardsWave, t_wave)
	subplot(2,3,6);		plot(max_Z, Toy.x, 'b', min_Z, Toy.x, 'b')
	suptitle('ToyModel')

end

for ii = 1:NumberofFigs
	figure(NumberofFigs)
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

prompt = 'Would you like to plot any of the following?:\n Option 1, something vs something,\n Option 2, something vs something, \n Enter numbers (no space) or no: ';
furtherplotting = input(prompt, 's');
if isempty(strfind(furtherplotting,'1')) == 0 % CHeck this works
	figure()
	plot()
end
if isempty(strfind(furtherplotting,'2')) == 0 % CHeck this works
	figure()
	plot()
end

end

