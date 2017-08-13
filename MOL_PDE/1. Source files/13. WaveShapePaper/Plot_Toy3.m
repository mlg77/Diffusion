%% Plot Toy3 all types of info
% must run CreateData_Toy3 first!
% plots three graphs for each Xi from myXi list
% Zero difusion
% Diffusion
% 
FH_score = [];
tol = 0.01;
close all
%myXi_list = [0.4:0.1:1, 1.5:0.5:3];
for ii = 1:length(myXi_list)
    toy3b = Toy3.Z0D(:,end-100:end,ii);
    vect_diff = max(toy3b')' -min(toy3b')' ;
    Bi_Point = Toy3.x(find(vect_diff>tol,1));
    
    figure(3*ii-2) % Zero Diffusion
    imagesc(Toy3.t,flipud(Toy3.x),Toy3.Z0D(:,:,ii)); hold on
    plot([Toy3.t(1), Toy3.t(end)],[Bi_Point, Bi_Point], 'k', 'linewidth', 2)
    set(gca,'YDir','normal')
    xlabel('Time, [s]')
    ylabel('Position, x')
    title('Zero diffusion')
    colormap jet
    hold on
    colorbar

    figure(3*ii-1) % Fickian Diffusion
    imagesc(Toy3.t,flipud(Toy3.x),Toy3.ZFD(:,:,ii)); hold on
    plot([Toy3.t(1), Toy3.t(end)],[Bi_Point, Bi_Point], 'k', 'linewidth', 2)
    set(gca,'YDir','normal')
    xlabel('Time, [s]')
    ylabel('Position, x, [cm]')
    title('Fickian diffusion')
    colormap jet
    hold on
    colorbar
    
    x_idx = 900;
    figure(3*ii) % Wave Shape
    [PKS,LOCS] = findpeaks(-1*Toy3.Z0D(x_idx, :, ii)); % find mins
    plot(Toy3.t(LOCS(end-2): LOCS(end-1)),Toy3.Z0D(x_idx, LOCS(end-2): LOCS(end-1),ii), 'k', 'linewidth', 2); hold on
    [Ymax,Imax] = max(Toy3.Z0D(x_idx, LOCS(end-2): LOCS(end-1),ii));
    [Ymin,Imin] = min(Toy3.Z0D(x_idx, LOCS(end-2): LOCS(end-1),ii));
    tims_cycle = Toy3.t(LOCS(end-2): LOCS(end-1));
    plot(tims_cycle(Imax)*[1,1],[Ymax, Ymin], ':k', 'linewidth', 2)
    xlabel('Time, [s]')
    ylabel('Concentration \Phi')
    
    
    [PKS,LOCS] = findpeaks(-1*Toy3.Z0D(x_idx, :, ii));
    one_wave = Toy3.Z0D(x_idx, LOCS(end-2): LOCS(end-1), ii);
    tims_cycle = t(LOCS(end-2): LOCS(end-1));
    [Ymax,Imax] = max(one_wave);
    Ymin = min(one_wave);
    T_period = tims_cycle(end) - tims_cycle(1);
    
    two_wave = [one_wave, one_wave];
    fh_vector2 = [];
    for jj = 1:floor(length(tims_cycle)/2)
        fh_vector = two_wave(Imax+jj) - two_wave(Imax-jj);
        fh_vector2(jj) = (fh_vector)/(Ymax - Ymin);       
    end
    
    [max_abs_fh, idx] = max(abs(fh_vector2));
    FH_score(ii) = fh_vector2(idx);
    
    
end

FH_score

