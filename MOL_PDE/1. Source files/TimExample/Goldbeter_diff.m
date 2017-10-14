function fn = Goldbeter_diff(beta)
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

% Alternate non-dimensionalisation
% alphao = 0.5;
% alpha1 = 3.65;
% alpha2 = 32.5;
% alpha4 = 250;
% 
% alpha6 = 10;
%  kf = 1;
% alpha3 = 0.5;
%  kr = 2;
% alpha5 = 0.45;

m = 2;
n = 2;
p = 4;
%% Indices
ind.z = 1;
ind.y = 2;
%% The system
fn = @DEsyst;
    function dfdt = DEsyst(t, x, state)
        dfdt = zeros(size(state));
        z = state(ind.z,:);
        y = state(ind.y,:);
        
        
        dfdt(ind.z,:) = vo + v1 * beta(x) - vm2*z.^n./(1 + z.^n) ...
            + (vm3*y.^m./(kr^m + y.^m)) .* (z.^p./(ka^p + z.^p)) ...
            + kf*y - k*z;
        
        dfdt(ind.y,:) = vm2*z.^n./(1 + z.^n) - ...
            (vm3*y.^m./(kr^m + y.^m)) .* (z.^p./(ka^p + z.^p)) ...
            - kf*y;
% Alternate non-dimensionalisation        
%          dfdt(ind.z,:) = alphao + alpha1 * beta(x) - alpha2*z.^n./(alpha3 + z.^n) ...
%             + (alpha4*y.^m./(1.0 + y.^m)) .* (z.^p./(alpha5^p + z.^p)) ...
%             + y - alpha6*z;
%         
%         dfdt(ind.y,:) = alpha2*z.^n./(alpha3 + z.^n) ...
%             - (alpha4*y.^m./(1.0 + y.^m)) .* (z.^p./(alpha5^p + z.^p)) ...
%             - y
    end
end