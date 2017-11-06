function [ wave_data ] = Follow_wave( Z, x, t, xstart_pt, wave_no, rough_t_1 )
%Follow_wave Follows the wave along and down to find the end based on
%criteria
%   Inputs:
%       Z, x, t    standard
%       start_pt   x coordinate to start at
%       wave_no    Which wave to deal with
%       rough_t_1  Rough time for one wave at point; length of wave
%   Outputs:
%       wave_data  [position, time, magnatude] of wave

% Convert points to inds
idx_xstart = find(x >= xstart_pt,1);

if length(rough_t_1) == 1;
    rough_t_1(2) = rough_t_1(1);
end
idx_rough_t = find(t >= rough_t_1(1), 1); 
buff = round(0.5*idx_rough_t);
idx_rough_t2 = find(t >= rough_t_1(2), 1);
buff2 = round(0.5*idx_rough_t2);

% Find the first rows peaks
First_row = Z(idx_xstart, buff:end);
[PKS,LOCS] = findpeaks(First_row);
LOCS = LOCS + buff-1;

% Check if first point is max
if LOCS - buff == 1
   error('Make rough t larger/smaller') 
end

% Save first set of data
wave_data.po(1) = xstart_pt;
wave_data.t(1) = t(LOCS(wave_no));
wave_data.mag(1) = PKS(wave_no);
wave_data.idx_t(1) = LOCS(wave_no);

% Forloop parameters
count = 1;
% tol = 0.5*max(max(Z)) + (-0.5 +1)*min(min(Z));
tol = 0.5*max(max(Z)) + (-0.5 +1)*min(min(Z)); % For Goldbeter
% Follow wave if for loop
for ii = idx_xstart-1: -1: 1
    % Find the next peaks
    Next_row = Z(ii,wave_data.idx_t(count)-:wave_data.idx_t(count)+buff2);
    [PKS2,LOCS2] = findpeaks(Next_row);
    LOCS2 = LOCS2 + wave_data.idx_t(count)-1;
    
    % Stop if peak is below tolerence or no maximum
    if length(LOCS2) < 1
        break
    elseif  PKS2(1) <= tol
        break
    end
    
    % Save next peak
    wave_data.po(count+1) = x(ii);
    wave_data.t(count+1) = t(LOCS2(1));
    wave_data.mag(count+1) = PKS2(1);
    wave_data.idx_t(count+1) = LOCS2(1);

    count = count + 1;
end
end

