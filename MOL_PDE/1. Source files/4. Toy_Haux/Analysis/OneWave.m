function [ Waveone, backwardsWave, t_wave ] = OneWave( Z, t, x, pos)
%Generates one wave
%   Detailed explanation goes here
idx_q = find(x == pos);
beg_sea = round(length(Z)/2);
[pks,locs] = findpeaks(Z(idx_q, beg_sea:end));
locs = locs + beg_sea;
if length(locs) <= 1
    Waveone = 0;
    backwardsWave = 0;
    t_wave = 0;
else
    Waveone = Z(idx_q, locs(2):locs(3));
    backwardsWave = fliplr(Waveone);
    t_wave = t(locs(2):locs(3));
end


end