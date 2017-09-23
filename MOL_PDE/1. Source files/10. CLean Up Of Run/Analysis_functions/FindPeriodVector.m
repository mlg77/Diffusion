function [ TVector ] = FindPeriodVector( Z, dt )
%FindPeriodVector Find the period of the matrix Z
%   if greater than 10 make zero
M = size(Z, 1);
N = size(Z, 2);

for ii = 1:M
    [PKS,LOCS]= findpeaks(Z(ii,floor(N*0.5):end));
    [Trof,L]= findpeaks(-Z(ii,floor(N*0.5):end));
    if length(LOCS) < 6
        TVector(ii) = 0;
    elseif max(PKS) - min(-Trof) < 0.01*max(max(Z))
        TVector(ii) = 0;
    else
        TZ = median( LOCS(3:end-1) - LOCS(2:end-2));
%         if TZ>15/dt
%             TZ = 0;
%         end
        TVector(ii) = TZ*dt;
    end
end

end

