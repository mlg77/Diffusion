function [ FH_sore ] = FH_SCORE_CALC( Zp )
%FH_SCORE_CALC calculates the fhscore of a single wave front Zp
%   Note must be from min to min but can also contain extra zeros
if size(Zp, 1) == 1
    % Cool
elseif size(Zp, 2) == 1
    Zp = Zp';
else
    error('Problem; Zp not a vector')
end

% Remove extra zeros
if Zp(end) == 0
    for ii = length(Zp):-1:1
        if Zp(ii) == 0
            % keep going 
        else
            % hit end 
            Zp = Zp(1:ii);
            break
        end
    end
end


% Next find fhscore
Zp_loop = [Zp];
% Normalise wave
Zp_norm = (Zp_loop - min(Zp))/(max(Zp)-min(Zp));
% Normalised t
norm_t = linspace(0,100,length(Zp));
% find max and make wave max to max
[Y,Idx_max] = max(Zp_norm);
max_max = [Zp_norm(Idx_max:end), Zp_norm(1:Idx_max)];
% Reverse a wave
max_max_r = fliplr(max_max);
% Subtract two
dif_wave = max_max - max_max_r;
% find idx when front is reduced to half wave height 
Idx_half_H = find(max_max <= 0.5);
stop_pt = Idx_half_H;

% figure()
% subplot(1,2,1)
% plot(dif_wave(1:stop_pt))
% subplot(1,2,2); hold on
% plot(norm_t, max_max(1:end-1))
% plot(norm_t, max_max_r(1:end-1))

FH_sore = trapz(norm_t(1:stop_pt),dif_wave(1:stop_pt));


end

