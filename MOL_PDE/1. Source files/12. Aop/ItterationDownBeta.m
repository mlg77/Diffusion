function [ Perts, PlotBetaVctor, xvec ] = ItterationDownBeta( Peribtations, Betas, AoPGrid, newBetaVector, f_1, IP )
%Itteration Down Beta
%   Gives back a vector to follow down the grid until wave termination.
%   Imputs:
%       Peribtations    = vector length n  
%       Betas           = vector length m
%       AoPGrid         = matrix size m x n relating to P and beta
%       newBetaVector   = Follow different beta vector vector length c
%       Rate            = Rate multiplication
%       IP              = Inital Pertibation must be less than max(Pertibations)
%   Outputs:
%       Perts           = vertor length d
%       PlotBetaVctor   = vertor length d 
%   Author: Michelle Goodman
%   Date: 23/3/2017


idx_0_per = find(Peribtations >=IP, 1);
beta_x = find(Betas >= newBetaVector(end), 1); % Relate the x value to the beta value
AoP = AoPGrid(beta_x, idx_0_per);
x = 0:1e-3:0.5;

%%

% Pertibation Applied | AoP | x value | beta value
to_plot = zeros(length(Betas)-1, 4);
to_plot(1,1:5) = [Peribtations(idx_0_per), AoP, Betas(beta_x), newBetaVector(end), x(end)];
P_x_min_1 = (AoP+ Peribtations(idx_0_per))*f_1;

for ii = 1:length(newBetaVector)-1
    
    idx_0_per = find(Peribtations >=P_x_min_1, 1); % Finds index of pert
    Pert_x = Peribtations(idx_0_per); % Finds P value of x*
    beta_x = find(Betas >= newBetaVector(end-ii), 1); % Relate the x value to the beta value
    AoP = AoPGrid(beta_x, idx_0_per); % Finds aop value of x*
    
    if isnan(newBetaVector(end-ii)) || isempty(beta_x) || isempty(idx_0_per)
        if ii ~= 1
            break
        end
        Perts = IP;
        PlotBetaVctor = newBetaVector(end);
        xvec = newBetaVector(end);
        return
    end
   
    % Save data
    to_plot(ii+1,1:5) = [Pert_x, AoP, Betas(beta_x), newBetaVector(end-ii), x(end-ii)];
    % Update AoP
%     P_x_min_1 = (AoP)*f_1;
    P_x_min_1 = (AoP+ Pert_x)*f_1;
    
    if to_plot(ii+1,2)<=1e-3
        break
    end
    
end

end_depth = find(to_plot(:,2)<=1e-3, 1);
if isempty(end_depth)
    end_depth = size(to_plot, 1);
elseif end_depth == 1
    end_depth = 2;
end

Perts = to_plot(1:end_depth-1, 1);
PlotBetaVctor = to_plot(1:end_depth-1, 4);
xvec = to_plot(1:end_depth-1, 5);

end

