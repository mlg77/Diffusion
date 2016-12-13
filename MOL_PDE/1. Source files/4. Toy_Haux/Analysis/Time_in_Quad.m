function [ time_quad ] = Time_in_Quad(  Z,V, t, x, t_inQ, x_inQ )
% Time_in_quad Calculates time in each quadrant (not quaters)
% Inputs:
%   Z0D,V, t, x, : as per every script 
%   t_inQ: What time points
%   x_inQ: What descrete x points do you want
%   no_quad: Number of sections to devide in series {2, 4, 8 ...}
            % Not used yet only quads

mybeta = x;
% Set up regions you want
for ii = 1:length(x_inQ)
    point = round(find(x>x_inQ(ii),1)); 
    if isempty(point)
        point = length(x);
    end
    idx_inQ(ii) = point;
end
idx_time = round(find(t>t_inQ(1),1)):length(t);

% First find max and min of Z and V for each x_inQ
for ii = 1:length(x_inQ)
   % Max Z 
   [pks,locs] = findpeaks(Z(idx_inQ(ii),idx_time));
   maxminZV(1, :, ii) = locs(2:3);
   % Min Z
   [pks,locs] = findpeaks(-Z(idx_inQ(ii),idx_time));
   maxminZV(2, :, ii) = locs(2:3);
   % Max V 
   [pks,locs] = findpeaks(V(idx_inQ(ii),idx_time));
   maxminZV(3, :, ii) = locs(2:3);
   % Min V
   [pks,locs] = findpeaks(-V(idx_inQ(ii),idx_time));
   maxminZV(4, :, ii) = locs(2:3);
end


for ii = 1:length(x_inQ)
    % Start at the min loc
    [first_t_idx, starting_cir] = min(maxminZV(:,1,ii));
    % Get rid of it
    maxminZV(starting_cir,1,ii) = inf;
    if starting_cir == 1 || starting_cir == 4
        quad_nu = starting_cir;
    elseif starting_cir == 2
        quad_nu = 3;
    else
        quad_nu = 2;
    end
    for jj = 1:4
        temp_mmZV = maxminZV(:,:,ii);
        [sec_time_idx,Posi] = min(temp_mmZV(:));
        time_quad(ii, quad_nu) = t(sec_time_idx) - t(first_t_idx);
        maxminZV(Posi + (ii-1)*8) = inf;
        first_t_idx = sec_time_idx;
        quad_nu = mod(quad_nu,4)+1;
    end
    
end

end

