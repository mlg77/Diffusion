%% Temp for 2D run the main_Aop first 
clc; close all
dx1 = 0.5e-2;   x1 = 0:dx1:0.5;
Pertibation = 0.2;
waveno = 2;
a2 = a1_a2_b1_b2(3)*log(6) + a1_a2_b1_b2(4);
a1 = a1_a2_b1_b2(1)*log(6) + a1_a2_b1_b2(2);
R = a1*log(waveno) + a2;

Rate_v_depth = R;
    
for jj = 1:length(x1)
    Pertibation_idx = find( perts >= Pertibation, 1);
    if isempty(Pertibation_idx)
        break
    end
    radus = x1(jj)+0.5;
    Factor2D = radus^2/((radus+dx1)^2);
    idx_aop = find(position_x>=x1(jj),1);
    Pertibation = (Aop(end - idx_aop + 1,Pertibation_idx)+ Pertibation)*Rate_v_depth*Factor2D;
    if Aop(end-jj + 1,Pertibation_idx) <= 1e-4
        x_end_2D = 1-x1(end-jj);
        break
    end
end
x_end_2D_list(waveno) = x_end_2D