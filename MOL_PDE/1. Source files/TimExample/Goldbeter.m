function fn = Goldbeter(beta)
%% Constants
vo = 1;
v1 = 7.3;
vm2 = 65;
vm3 = 500;

k = 10;
kf = 1;
%k2 = 1;
kr = 2;
ka = 0.9;

m = 2;
n = 2;
p = 4;
%% Indices
ind.z = 1;
ind.y = 2;
%% The system
fn = @DEsyst;
    function dfdt = DEsyst(t, state)
        dfdt = zeros(length(state),1);
        dfdt(ind.z) = vo + v1 * beta - vm2*state(ind.z)^n/(1 + state(ind.z)^n) ...
            + (vm3*state(ind.y)^m/(kr^m + state(ind.y)^m)) * (state(ind.z)^p/(ka^p + state(ind.z)^p)) ...
            + kf*state(ind.y) - k*state(ind.z);
        
        dfdt(ind.y) = vm2*state(ind.z)^n/(1 + state(ind.z)^n) - ...
            (vm3*state(ind.y)^m/(kr^m + state(ind.y)^m)) * (state(ind.z)^p/(ka^p + state(ind.z)^p)) ...
            - kf*state(ind.y);
    end
end