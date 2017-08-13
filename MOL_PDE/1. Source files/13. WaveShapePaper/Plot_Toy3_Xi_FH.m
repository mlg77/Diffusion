%% Does not plot each step
% must run CreateData_Toy3 first!
FH_score = [];
tol = 0.01;
% close all
%myXi_list = [0.4:0.1:1, 1.5:0.5:3];
for ii = 1:length(myXi_list)
    % Given Toy3.Z0D(:,:,ii) what is bifurcation point
    toy3b = Toy3.Z0D(:,end-100:end,ii);
    vect_diff = max(toy3b')' -min(toy3b')' ;
    Bi_Point = Toy3.x(find(vect_diff>tol,1));
    
    % Where does oscillations of Toy3.ZFD(:,:,ii) > tol
    toy3b = Toy3.ZFD(:,end-5000:end,ii);
    vect_diff = max(toy3b')' -min(toy3b')' ;
    End_Occ = Toy3.x(find(vect_diff>tol,1));
    
    % Does it acually penetrate
    if Bi_Point - End_Occ >= 0.01
        act_pene(ii) = 1;
    else
        act_pene(ii) = 0;
    end
    
    % What is FH score
    
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

figure();
area(myXi_list, FH_score.*act_pene); hold on;
plot(myXi_list, FH_score, 'k', 'linewidth', 2)
