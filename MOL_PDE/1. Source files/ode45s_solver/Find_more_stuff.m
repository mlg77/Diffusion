% Find actual t_lag
res_locs = []; res_pks = [];
bounds_x = length(x);% find(x>=0.29,1); 
bounds_t_st = 1; %find(t>26,1);
bounds_t_nd = find(t>26,1);% size(Z, 2);
for i = 1:bounds_x % length(x)% Go through all space
    [pks, locs] = findpeaks(Z(i,bounds_t_st:bounds_t_nd)); % 1:find(t>26,1)));
    count = 0; min_to_delete = [];
    for j = 1:length(locs)-1
        if locs(j+1)-locs(j)< find(t>0.5,1)
            count = count+1;
            min_to_delete(count) = find(min(pks(j+1), pks(j))==pks);
        end
    end
    if isempty(pks)
        pks = 1; locs = 1;
    end
    pks(:, min_to_delete) = [];
    locs(:, min_to_delete) = [];
    
    res_pks(i, 1:length(pks)) = pks;
    res_locs(i, 1:length(pks)) = locs;
end
res_locs(find(res_locs==0)) = 1;  
res_pks(find(res_locs==1)) = 0;  
% figure();
% plot(res_locs(:,1), res_pks(:,1))
i = 1:10:length(t);
i_test = 1:length(t);
i_test(i)=[];
Z_test = Z;             t_test = t;
Z_test(:,i_test)=[];    t_test(i_test) = [];


figure(2); hold on;
imagesc(Z_test)
% imagesc(t_test,flipud(x),Z_test)
% set(gca,'YDir','normal')
xlabel('Time, [s]')
ylabel('Position, x')
title(['Z, Calcium Concentration in the Cytosol ',num2str(D),' diffusion, [\muM]'])
colormap jet
plot((res_locs(:,1)-1)/10+bounds_t_st/10, x(1:size(res_locs, 1))*1000+1, 'k')

% res_locs(228,8) = 1; res_pks(228,8) = 0;
% res_locs(233:238,9) = 1; res_pks(233:238,9) = 0;
% res_locs(239:243,10) = 1; res_pks(239:243,10) = 0;
% res_locs(267:268,19) = 1; res_pks(267:268,19) = 0;
% res_locs(269:282,20) = 1; res_pks(269:282,20) = 0;

tlag = [];
for i = 1:size(res_pks, 2)
    for j = 1:500
        if res_locs(j,i)==1
            % Skip
        elseif res_pks(j,i)<1
            % Skip too small
        else
%             tlag(1, i) = mean(t(res_locs(j:j+5,i))-t(res_locs(j+1:j+6,i)));
            tlag(1, i) = t(res_locs(j,i))-t(res_locs(j+1,i));
            tlag(2, i) = j;
            break
        end
    end
end
% figure(4); plot(x(tlag(2, :)), tlag(1, :), 'xg')
% figure()
% hold on
% for i = [500, 238, [find(res_locs(:,2)>1,1)+4:-1:find(res_locs(:,2)>1,1)]]%250:-1: 230%find(res_locs>1,1)
%     plot(Z(i,res_locs(i,2)- b/2: res_locs(i,2) + b/2));
%     max(Z(i,res_locs(i,2)- b/2: res_locs(i,2) + b/2))
%     
%     title(num2str(i)); 
% %     axis([1100, 1150, 1.5, 1.52])
%     grid on
%     pause()
% %     delete(h)
% end


for i = 1:45
    figure(5); plot(res_pks(:,i))
    hold on
    title(num2str(i))
    % Plot max 
    max_begins = res_pks(:,i)==0;
    plot(max_begins.* Z(1:bounds_x, res_locs(find(res_locs(:, i)>1,1))))
    
    
    figure(2); 
    h = plot((res_locs(:,i)-1)/10+bounds_t_st/10, x(1:bounds_x)*1000+1, 'k');
    [Max_on_wave, Position_x] = max(res_pks(:,i));
    plot( round(res_locs(Position_x, i)/10)+bounds_t_st/10, Position_x,'xk')
    
    pause()
    delete(h)
end

