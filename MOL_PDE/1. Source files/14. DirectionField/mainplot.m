%% For the Dupont model  find the direction field which is point away from 
%   the Steady state solution.

clear; clc; close all

mybeta = 0.3;
%% Step one find the steady state solution for the given beta
Z0 = 0.5; Y0 = 0.5; fact = 0.01;
Zvect(1) = Z0;
for ii = 1:10000
    [Z0i, Y0i, v_2, v_3] = calc_Dupont(Z0,  Y0, mybeta);
    Z0 = Z0 + fact*Z0i;
    Y0 = Y0 + fact*Y0i;
    Zvect(ii+1) = Z0;
    
    if abs(Zvect(ii) - Zvect(ii+1)) <1e-6
        break
    end
    
end

plot(Zvect)

Z_SS = Z0 
Y_SS = Y0 

%% Step two create a direction field plot of Z and Y
Z0_vect = 0:0.001:2;
Y0_vect = 0:0.001:6;

DirY = zeros(length(Z0_vect), length(Y0_vect));
DirZ = zeros(length(Z0_vect), length(Y0_vect));
region_po = zeros(length(Z0_vect), length(Y0_vect));
region_dir = zeros(length(Z0_vect), length(Y0_vect));
for ii = 1:length(Z0_vect)
    for jj = 1:length(Y0_vect)
        [Z, Y, v_2, v_3] = calc_Dupont(Z0_vect(ii),  Y0_vect(jj), mybeta);
        DirY(ii, jj) = Y;
        DirZ(ii, jj) = Z;
        
        % Also want to decide direction area to ss
        if (Z0_vect(ii) - Z_SS) >= 0 && (Y0_vect(ii) - Y_SS) >= 0
            region_dir(ii,jj) = 1;
        elseif (Z0_vect(ii) - Z_SS) >= 0
            region_dir(ii,jj) = 4;
        elseif (Y0_vect(ii) - Y_SS) >= 0
            region_dir(ii,jj) = 2;
        else
            region_dir(ii,jj) = 3;
        end
        
        if Z >= 0 && Y >= 0
            region_dir(ii,jj) = 1;
        elseif Z >= 0
            region_dir(ii,jj) = 4;
        elseif Y >= 0
            region_dir(ii,jj) = 2;
        else
            region_dir(ii,jj) = 3;
        end
        
    end
end

pointTowards = (region_po == region_dir);

figure();
subplot(1,2,1); contourf(Z0_vect, Y0_vect, DirY')
xlabel('Z'); ylabel('Y'); title('Dir Y')
hold on; plot(Z_SS, Y_SS, 'bx')
colorbar
subplot(1,2,2); contourf(Z0_vect, Y0_vect, DirY')
xlabel('Z'); ylabel('Y'); title('Dir Z')
colorbar
hold on; plot(Z_SS, Y_SS, 'bx')


figure();
imagesc(pointTowards)
