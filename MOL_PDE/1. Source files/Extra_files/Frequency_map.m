%% Produce a map of period over space and time. Save as a sparse matrix
% Use Flux data 

clear; clc; close all; 
%% Where am I
AllDir.ParentDir = 'C:\Temp\Diffusion\MOL_PDE\';

AllDir.SourceDir = '1. Source files';
AllDir.InitalDataDir = '2. Inital Data';
AllDir.SaveDir = '4. Output files';
%% Plot raw flux data
cd([AllDir.ParentDir ,AllDir.SaveDir])
figure(1)
load('ED_data_Fluxes');
imagesc(t,flipud(x(2:end-1)),dX_dx(2:end-1,:))
set(gca,'YDir','normal')
xlabel('Time, [s]')
ylabel('Position, x')
title('dZ\_dx, Flux of Calcium Concentration in the Cytosol, [\muM m^{-1}]')
colormap jet
colorbar

figure(2)
imagesc(t,flipud(x(11:end-30)),gZdV_dx(11:end-30,:) )
set(gca,'YDir','normal')
xlabel('Time, [s]')
ylabel('Position, x')
title('gZdV\_dx, Calcium Concentration in the Cytosol, [\muM m^{-1}]')
colorbar
colormap jet

tic
%% Create for loop to cucle through space
myrecordV.f = sparse([]);     
myrecordZ.f = sparse([]); 
for nno = 1: length(x)-2
    % Find first gradient for both fluxes at specific x point
    grad_gZdV_dx = gZdV_dx(nno,2)-gZdV_dx(nno,1);
    grad_dX_dx = dX_dx(nno,2)- dX_dx(nno,1);
    % initalise save data matrices / vectors.  
        lastV.nno = 2; lastZ.nno = 2;
    lastV.i = 2; lastZ.i = 2;
    lastV.f = 0; lastZ.f = 0;
    
    % Loop through time and find when the gradient changes from 1 to -1 or
    % vice versa
    for i = 2:length(t)-1
        % second gradient
        grad_gZdV_dx1 = gZdV_dx(nno,i+1)-gZdV_dx(nno,i);
        grad_dX_dx1 = dX_dx(nno,i+1) -dX_dx(nno,i);
        % Record if dv gradient changes so all max and min inc local
        if (sign(grad_gZdV_dx1)~= sign(grad_gZdV_dx)) 
            % if this is a min and the last one was a big difference
            if  sign(grad_gZdV_dx) < 0 & abs(gZdV_dx(nno,i)- lastV.f)> 15
                % Save the last one as it was a max
                myrecordV.f(lastV.nno, lastV.i) = lastV.f; 
            end
            % Otherwise save as the last one
            lastV.nno = nno;
            lastV.i = i;
            lastV.f = gZdV_dx(nno,i);
        end
        % Do the same for the Z
        if sign(grad_dX_dx1)~= sign(grad_dX_dx)
            if  sign(grad_dX_dx) < 0 & abs(dX_dx(nno,i)- lastZ.f)> 200
                myrecordZ.f(lastZ.nno, lastZ.i) = lastZ.f;
            end
            lastZ.nno = nno;
            lastZ.i = i;
            lastZ.f = dX_dx(nno,i);
        end 
        % Update the first gradient
        grad_gZdV_dx = grad_gZdV_dx1;
        grad_dX_dx = grad_dX_dx1;
    end
end
toc
%% reduce and sort the sparse matrix
myrecordV.f2 = [];
myrecordV.period = sparse([]);

[the_i,the_j,the_v] = find(myrecordV.f);
AA = sortrows([the_i,the_j,the_v]);
the_i = AA(:,1); the_j = AA(:,2); the_v = AA(:,3);
%% Find the period
begg = 0;
for i = 1:length(the_i)
    if begg == 0
        myrecordV.period(the_i(i),the_j(i)) =  0;
        begg = 1;
    elseif the_i(i) ~=  the_i(i-1)
        myrecordV.period(the_i(i),the_j(i)) =  0;
    else
        if t(the_j(i)) - t(the_j(i-1)) < 3
            myrecordV.period(the_i(i),the_j(i)) = t(the_j(i)) - t(the_j(i-1));
        else
            myrecordV.period(the_i(i),the_j(i)) =  -1;
        end
    end
end
myrecordV.period = sparse(myrecordV.period);
[the_i,the_j,the_v] = find(myrecordV.period);
AA = sortrows([the_i,the_j,the_v]);
the_i = AA(:,1); the_j = AA(:,2); the_v = AA(:,3);

begg = 0;
for i = 1:length(the_i)
    if begg == 0
        myrecordV.f2(the_i(i),1:the_j(i)) =  0;
        begg = 1;
    elseif the_i(i) ~=  the_i(i-1)
        myrecordV.f2(the_i(i),1:the_j(i)) =  0;
    else
        No_points = length(the_j(i-1):the_j(i));
        if the_v(i-1) == -1 | the_v(i) == -1
            myrecordV.f2(the_i(i),the_j(i-1):the_j(i)) = linspace(0,0, No_points);
        else
            myrecordV.f2(the_i(i),the_j(i-1):the_j(i)) = linspace(the_v(i-1),the_v(i), No_points);
        end
    end
end
[rr, cc] =size(myrecordV.f2);

myrecordV.f2 = [myrecordV.f2; zeros(length(x)-rr, cc)];
figure(2)
h = imagesc(t(1:49963),flipud(x(2:end-1)), myrecordV.f2);     
set(gca,'YDir','normal') 
xlabel('Time, [s]')
ylabel('Position, x')
cmap = jet(256);
colormap(cmap);
caxis(gca,[0.1-2/256, 3]);
cmap(1,:)=[1,1,1];
colormap(cmap)
colorbar
