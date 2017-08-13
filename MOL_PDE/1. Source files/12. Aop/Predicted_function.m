function [ reordered_AoP, Predicted_x_pert_pert ] = Predicted_function( AoP,perts, NewBetastuff, betas_coll, a1a2a3a4, D, linenumbers  )
%Predicted_function Takes the AoP grid, new beta to x profile, a1a2a3a4 D 
%   and line numbers and creates the new reordered AoP and Predicted_D_lineno_Depth_

betas_coll = betas_coll(1:floor(length(betas_coll)/2+1));
NewBetastuff = NewBetastuff(1:length(betas_coll));
reordered_AoP = AoP*0;
for kk = 1:length(NewBetastuff)
    if isnan(NewBetastuff(kk) )
        reordered_AoP(kk,:) = AoP(1, :)*nan;
    elseif isempty(find(NewBetastuff(kk)<=betas_coll))
        reordered_AoP(kk,:) = AoP(1, :)*nan;
    else
        reordered_AoP(kk,:) = AoP(find(NewBetastuff(kk)<=betas_coll,1), :);
    end
end


for jj = 1:length(linenumbers)
    a = (a1a2a3a4(1)*log(D/(1e-3)^2) + a1a2a3a4(2));
    b = (a1a2a3a4(3)*log(D/(1e-3)^2) + a1a2a3a4(4));
    f_1 =  a*log(linenumbers(jj)) + b;
    [ Perts_dbdx, Plot_dbetadx, plotxer ] = ItterationDownBeta( perts, betas_coll, AoP, NewBetastuff, f_1, 0.2 );
    plotxer = [0.5:-1e-3:0];
    if jj == 1
        Predicted_x_pert_pert = zeros(length(plotxer), length(linenumbers)+1);
        Predicted_x_pert_pert(:,1) = plotxer;
    end
    Predicted_x_pert_pert(1:length(Perts_dbdx), jj+1) = [Perts_dbdx];
end




end

