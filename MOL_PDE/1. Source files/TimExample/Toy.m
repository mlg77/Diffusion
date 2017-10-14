function fn = Toy(beta)
%% Constants
myalpha = 0.2;
%% Indices
ind.z = 1;
ind.y = 2;
%% The system
fn = @DEsyst;
    function dfdt = DEsyst(t,x, state)
        dfdt = zeros(size(state));
        dfdt(ind.z, :) = beta(x).*state(ind.y,:) - state(ind.z,:).^3/3 + state(ind.z,:);
        dfdt(ind.y, :) = -(beta(x).* state(ind.z,:) + myalpha);
    end
end