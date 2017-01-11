function [ Waveone, backwardsWave, t_wave ] = OneWave( Z, t, x, pos)
%Generates one wave to plot
%   Uses Z of zero Diffusion, t and x and an x position to use
% 	Passes out a forward and backward wave data corosponding to a t_wave

idx_q = find(x >= pos,1);
beg_sea = round(length(Z)/2); % Start halfway through the data on the line
[pks,locs] = findpeaks(Z(idx_q, beg_sea:end));
locs = locs + beg_sea;
if length(locs) <= 1 % If there isn't an oscillation here return zeros
    Waveone = 0;
    backwardsWave = 0;
    t_wave = 0;
else
    Waveone = Z(idx_q, locs(2):locs(3));
    backwardsWave = fliplr(Waveone);
    t_wave = t(locs(2):locs(3));
end


end