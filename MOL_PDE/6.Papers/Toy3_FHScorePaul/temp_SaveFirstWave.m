close all

%% Move to correct directory

dir_source = 'C:\Temp\Diffusion\MOL_PDE\1. Source files\18. Pauls Toy';
dir_parent = 'C:\Temp\Diffusion\MOL_PDE\6.Papers\Toy3_FHScorePaul';
dir_save = 'C:\Temp\Diffusion\MOL_PDE\4. Output files\A. 1. Paper';

myXi_vector = [-0.2, 0, 0.2, 0.5]%0.1:0.05:1;
count = 0;
onewaveall = [];
D_Array = [0, 5e-6];

cd([dir_save])
savestuff = 1;
if savestuff
for ii = 1:length(myXi_vector)
    myXi = myXi_vector(ii);
    mybeta = (x*0.7+0.1)';
    for jj = 1
        D = D_Array(jj);
        load(['Data_', num2str(ii), '_', num2str(jj)])
        per_end = 0.5;
        BifuMax = max(Z(:, floor(N*per_end):end)')';
        BifuMin = min(Z(:, floor(N*per_end):end)')';
        
        cd(['C:\Temp\Diffusion\MOL_PDE\1. Source files\10. CLean Up Of Run\Analysis_functions']);
        [ pointsfound ] = Bifurcation_pointsToy( x,t,Z );
        cd([dir_save])
        
        idx_wave = pointsfound(1)+31;
        Zp = Z(idx_wave, floor(length(t)/2):end);
        tp = t(floor(length(t)/2):end);
        [Troughs,LOCS] = findpeaks(-Zp);
        Zp = Zp(LOCS(2):LOCS(3));
        tp = tp(LOCS(2):LOCS(3));
        
        figure()
        plot(tp, Zp, 'r', 'linewidth', 3)
        
        onewaveall(ii, 1:length(Zp)) = Zp;
        
    end
end
cd([dir_save]) 
save(['OneWave'], 'onewaveall')
end

cd([dir_save]) 
load('OneWave')
cd(dir_parent);


FH_sore_vect = nan(1,size(onewaveall, 1 ));
for ii = 1:size(onewaveall, 1 )
    Zp = onewaveall(ii, :);
    [ FH_sore ] = FH_SCORE_CALC( Zp );
    FH_sore_vect(ii) = FH_sore;
end

penetr(1) = 0;
penetr(2) = 0;
penetr(3) = 0;
penetr(4) = 0;
penetr(5) = 0;
penetr(6) = 0;
penetr(7) = 0;
penetr(8) = 0;
penetr(9) = 0;
penetr(10) = 0;
penetr(11) = 0.5;
penetr(12) = 1;
penetr(13) = 1;
penetr(14) = 1;
penetr(15) = 1;
penetr(16) = 1;
penetr(17) = 1;
penetr(18) = 1;
penetr(19) = 1;


figure(99); hold on
uncert = 0.05/2;
pt_acros = [myXi_vector(1), myXi_vector(10)+uncert, myXi_vector(12)-uncert, myXi_vector(end) ];
pt_updo = [floor(min(FH_sore_vect)), ceil(max(FH_sore_vect))];
h1 = patch([pt_acros(1), pt_acros(2),pt_acros(2),pt_acros(1)], [pt_updo(1), pt_updo(1), pt_updo(2), pt_updo(2)],'g');
h2 = patch([pt_acros(2), pt_acros(3),pt_acros(3),pt_acros(2)], [pt_updo(1), pt_updo(1), pt_updo(2), pt_updo(2)],'y');
h3 = patch([pt_acros(3), pt_acros(4),pt_acros(4),pt_acros(3)], [pt_updo(1), pt_updo(1), pt_updo(2), pt_updo(2)],'r');
h1.LineStyle = 'none'; h2.LineStyle = 'none'; h3.LineStyle = 'none';
h4 = plot(myXi_vector, FH_sore_vect, '.:k', 'linewidth', 1, 'MarkerSize', 20);
plot([pt_acros(1), pt_acros(end)], [0,0], 'k')
axis([pt_acros(1), pt_acros(end), pt_updo])
legend('No Excursions', 'Undetermined', 'Excursions')
xlabel('\xi'); ylabel('FH-Score')

return

cd([dir_save, '\Figs\Report\Images']) 
set(gcf,'PaperPositionMode','auto')
print('xi_vs_fh','-dpng', '-r300')
cd([dir_save, '\Figs\Report']) 
savefig(99, 'xi_vs_FH.fig')
