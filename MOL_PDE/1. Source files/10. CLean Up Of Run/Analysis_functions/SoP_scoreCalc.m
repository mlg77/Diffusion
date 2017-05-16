function [ SoP_scoreVector ] = SoP_scoreCalc( model_run, beta_value, Perts )
%Find the percentage forward heavy
%   Given the data for the steady state solution
%   size(Z) = [n , 1]
% Note perts must be of length2 or greater in which Perts(1) = 0;

%% Convert names
mystr2 = model_run;
mybeta = beta_value;


%% First set up inital conditions
mtol = 1e-6;
odeoptions = odeset('RelTol',mtol, 'AbsTol', mtol );
Diff_type = 1; D =0;
if strcmp(mystr2, 'G')
    Z_0 = 0.5; V_0 = -40; Y_0 = 0.5;
    y0 = [Z_0, V_0, Y_0];
elseif strcmp(mystr2, 'E')
    Z_0 = 300; V_0 = -40; N_0 = 0.5;
    y0 = [Z_0, V_0, N_0];
elseif strcmp(mystr2, 'T1')
    X_0 = -1; Y_0 = -1;
    y0 = [X_0, Y_0];
elseif strcmp(mystr2, 'T2')
    X_0 = -2; Y_0 = 2;
    y0 = [X_0, Y_0];
elseif strcmp(mystr2, 'F')
    X_0 = -1; Y_0 = 1;
    y0 = [X_0, Y_0];
elseif strcmp(mystr2, 'K')
    error('not ready')
else
    error('Wrong model run')
end


SoP_scoreVector = zeros(length(Perts), 1);

for ii = 1:length(Perts)
    if ii == 1
        % Running for steady state
        tspan = [0:0.01:50];
    else
        tspan = [0:0.002:20];
        y0(1) = y00(1) + Perts(ii);
    end
    
    % Run simulation
    if strcmp(mystr2, 'G')
        [t, y0D] = ode45(@(t,y) odefun_Goldbeter(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions);
    elseif strcmp(mystr2, 'E')
        [t, y0D] = ode45(@(t,y) odefun_Erm(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions);
    elseif strcmp(mystr2, 'T1')
        [t, y0D] = ode45(@(t,y) odefun_ToyH(t,y,mybeta,Diff_type, D, toymodelNo), tspan, y0, odeoptions);
    elseif strcmp(mystr2, 'T2')
        [t, y0D] = ode45(@(t,y) odefun_ToyH(t,y,mybeta,Diff_type, D, toymodelNo), tspan, y0, odeoptions);
    elseif strcmp(mystr2, 'F')
        [t, y0D] = ode45(@(t,y) odefun_Fitz(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions);
    elseif strcmp(mystr2, 'K')
        [t, y0D] = ode45(@(t,y) odefun_Kathiedit(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions);
    end
    
    Z0D = y0D(:, 1)';
    if ii == 1
        % Running for steady state
        SoP_scoreVector(1) = Z0D(end);
        y0 = y0D(end, :);
        y00 = y0D(end, :);
        % Does it oscillate?
        if abs(max(Z0D(floor(length(tspan)/2):end)) - min(Z0D(floor(length(tspan)/2):end))) > 0.1*abs(max(Z0D))
            plot(Z0D)
            error('oscillates; this is for non ocsillatory betas')
        end
    else
%         if abs(y0D(end, :) - y00) < 0.05*abs(y00)
            SoP_scoreVector(ii,1) = max(Z0D);
%         end
    end   
end

SoP_scoreVector = SoP_scoreVector - SoP_scoreVector(1) - Perts';


end

