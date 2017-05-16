function [ pks1, loc1, pks2, loc2, pks3, loc3 ] = SameLengthPeeks( tol_time, pks1, loc1, pks2, loc2, pks3, loc3 )
%Make sure they are the same length


   
   if length(loc1) ~= length(loc2) || length(loc1) ~= length(loc3)
       % Find which loc doesnt match
       lon_len = max([length(loc1), length(loc2), length(loc3)]);
       idx_remove_star = [];
       idx_remove_plus = [];
       idx_remove_minus = []; 
%        if lon_len == length(loc1)
           for jj = 1:length(loc1) % lon_len
                plus_close = abs(loc2 - loc1(jj)) < tol_time;
                minus_close = abs(loc3 - loc1(jj)) < tol_time;
                if sum(plus_close)==0 || sum(minus_close) == 0
                    % There is not one close
                    idx_remove_star(end+1) = jj;
                    % Is there one closer in the other?
                    if sum(plus_close)>0
                        idx_remove_plus(end+1) = find(plus_close==1);
                    elseif sum(minus_close) > 0
                        idx_remove_minus(end+1) = find(minus_close==1);
                    end
                end
           end
%        elseif lon_len == length(loc2)
           for jj = 1:length(loc2) %lon_len
                star_close = abs(loc1 - loc2(jj)) < tol_time;
                minus_close = abs(loc3 - loc2(jj)) < tol_time;
                if sum(star_close)==0 || sum(minus_close) == 0
                    % There is not one close
                    idx_remove_plus(end+1) = jj;
                    % Is there one closer in the other?
                    if sum(star_close)>0
                        idx_remove_star(end+1) = find(star_close==1);
                    elseif sum(minus_close) > 0
                        idx_remove_minus(end+1) = find(minus_close==1);
                    end
                end
           end
%        else
           for jj = 1:length(loc3) %lon_len
                plus_close = abs(loc2 - loc3(jj)) < tol_time;
                star_close = abs(loc1 - loc3(jj)) < tol_time;
                if sum(plus_close)==0 || sum(star_close) == 0
                    % There is not one close
                    idx_remove_minus(end+1) = jj;
                    % Is there one closer in the other?
                    if sum(plus_close)>0
                        idx_remove_plus(end+1) = find(plus_close==1);
                    elseif sum(star_close) > 0
                        idx_remove_star(end+1) = find(star_close==1);
                    end
                end
           end
       
       
       pks1(idx_remove_star) = [];
       loc1(idx_remove_star) = [];
       pks2(idx_remove_plus) = [];
       loc2(idx_remove_plus) = [];
       pks3(idx_remove_minus) = [];
       loc3(idx_remove_minus) = [];
   end
   if length(loc1) ~= length(loc2) || length(loc1) ~= length(loc3)
       idx_remove_star = [];
       idx_remove_plus = [];
       idx_remove_minus = []; 
           for jj = 1:length(loc1) % lon_len
                star_close = abs(loc1 - loc1(jj)) < tol_time;
                if sum(star_close)>1
                    idx_remove_star(end+1) = find(star_close==1,1);
                end
           end
           for jj = 1:length(loc2) % lon_len
                plus_close = abs(loc2 - loc2(jj)) < tol_time;
                if sum(plus_close)>1
                    idx_remove_plus(end+1) = find(plus_close==1,1);
                end
           end
           for jj = 1:length(loc3) % lon_len
                minus_close = abs(loc3 - loc3(jj)) < tol_time;
                if sum(minus_close)>1
                    idx_remove_minus(end+1) = find(minus_close==1,1);
                end
           end
       pks1(idx_remove_star) = [];
       loc1(idx_remove_star) = [];
       pks2(idx_remove_plus) = [];
       loc2(idx_remove_plus) = [];
       pks3(idx_remove_minus) = [];
       loc3(idx_remove_minus) = [];
   end

end

