function [top_points_index, Period, Periodmap, Period_over_x] = find_freq(x, t, M, N, Z);
%Find the period of an oculatory system 
%   where x is space (length M) 
%   and t is the time (length N) which the Z values occulate over
%   Not all x points have an oscullation


% First find top points
top_points_index = sparse(M,N);
for i = 1:M % Length of x
    gradient_prev = sign(Z(i, 2) - Z(i, 1));
    for j = 3:N
        gradient_current = sign(Z(i, j) - Z(i, j-1));
        if gradient_prev ~= gradient_current && gradient_current < 0
            % max point at Z(i,j)
            top_points_index(i,j) = Z(i, j);
        end
        gradient_prev = gradient_current;
    end
end

% Now find period
Period = sparse(M,N);

[the_i,the_j,the_v] = find(top_points_index);
AA = sortrows([the_i,the_j,the_v]);
the_i = AA(:,1); the_j = AA(:,2); the_v = AA(:,3);
%% Find the period
begg = 0;
% loop through the x coordinates where there is a top point 
for i = 1:length(the_i)
    if begg == 0 % If its the first row initalise pt to 0
        Period(the_i(i),the_j(i)) =  0;
        begg = 1;
    elseif the_i(i) ~=  the_i(i-1) % If you start a new row
        Period(the_i(i),the_j(i)) =  0;
    else % Otherwise the period is the difference in time points of the top points 
        if t(the_j(i)) - t(the_j(i-1)) >0
            Period(the_i(i),the_j(i)) = t(the_j(i)) - t(the_j(i-1));
        end
    end
end
% Now create a plot friendly period where the averages are found
[the_i,the_j,the_v] = find(Period);
AA = sortrows([the_i,the_j,the_v]);
the_i = AA(:,1); the_j = AA(:,2); the_v = AA(:,3);
begg = 0;
tally_rows = zeros(M,1);
% Loop through the period x coordinates
for i = 1:length(the_i)
    tally_rows(the_i(i)) = tally_rows(the_i(i)) + 1;
    if begg == 0
        Periodmap(1,1:the_j(i)) =  the_v(i)*ones(1, the_j(i));
        begg = 1;
    elseif the_i(i) ~=  the_i(i-1)
        Periodmap(the_i(i),1:the_j(i)) =  the_v(i)*ones(1, the_j(i));
    else
        Periodmap(the_i(i),the_j(i-1)+1:the_j(i)) = linspace(the_v(i-1), the_v(i), length(the_j(i-1)+1:the_j(i)));
    end
end
tally_rows(find(tally_rows==0)) = 1;

% Period_over_x = 
Period_over_x =  sum(Period')'./tally_rows;

end

