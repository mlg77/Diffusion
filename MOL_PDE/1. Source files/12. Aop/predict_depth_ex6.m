function [ x_P, P ] = predict_depth_ex6( AoP_reordered, perts, x, start_x, f_1, dir )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
% To run use below commands
% a1a2a3a4 = [-0.025573737362939, -0.01278638174584, 0.063408766383566, 0.067664806911860];
% a = (a1a2a3a4(1)*log(6) + a1a2a3a4(2));
% b = (a1a2a3a4(3)*log(6) + a1a2a3a4(4));
% f_1 =  a*log(3) + b;
% [ x_P, P ] = predict_depth_ex6( Aop_reordered(:,:, 6), perts, [0:1e-3:1], 0.49, f_1, 1 );
% subplot(1,3,3); plot(P(2:end), x_P(2:end), 'r', 'linewidth', 2)

idx_start = find(x>=start_x, 1);
idx_0_per = find(perts >=0.02, 1);

x_P(1) = x(idx_start);
P(1) = perts(idx_0_per);

if dir == 1
    % act as normal
    for ii = 1:idx_start -1
       x_P(ii + 1) =  x(idx_start-ii);
       P(ii + 1) = (AoP_reordered(idx_start-ii, idx_0_per) + P(ii))*f_1;

       idx_0_per = find(perts >=P(ii + 1), 1); 
       if isempty(idx_0_per); return; end
    end
else
    for ii = 1:floor(length(x)/2)-idx_start-1
       x_P(ii + 1) =  x(idx_start+ii);
       P(ii + 1) = (AoP_reordered(idx_start+ii, idx_0_per) + P(ii))*f_1;

       idx_0_per = find(perts >=P(ii + 1), 1);
    end
end


end

%%
