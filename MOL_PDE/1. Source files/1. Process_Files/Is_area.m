%% Is it Area or total
area_hump2 = []; area_hump1 = [];
count = 0;
for i= (length(x)-1)*0.8:-1:60%(length(x)-1)/2:-1:60
    count = count + 1;
    count_x(count) = x(i);
%     figure(1)
%     plot(t, d2Zdx2(i,:));
    
    % is it in the range of zero? call it zero
    b_diff_simp = d2Zdx2(i,:)<5e-4 & d2Zdx2(i,:)> -5e-4;
    diff_simp = d2Zdx2(i,:);
    diff_simp(find(b_diff_simp>0)) = 0;
    % Find when it is negative
    bolian_negative = diff_simp<0;
    % Find Area Positive region
    diff_simp_p = diff_simp;
    diff_simp_p(find(bolian_negative>0))=0;
    area_d = (t(2:end) - t(1:end-1)).*0.5.*(diff_simp_p(2:end)+ diff_simp_p(1:end-1))';
    % Find significant minimum
    neg_data = diff_simp;
    neg_data(find(bolian_negative==0))=0;
    [pks, locs] = findpeaks(-neg_data);
    locs(pks<0.05) = [];
    pks(pks<0.05) = [];
    
    locs(end+1) = length(t);
    
    last_t_cut = 1;
%     if length(locs)<3 & x(i) <0.25
%        count 
%        hold on
%        plot(t(locs), 0*locs, 'rx');
%        plot([0,30], [5e-3,5e-3])
%        hold off
%     end
    for j = 1:length(locs)-1 % Loop through number of peeks
       area_hump1(count, j) = sum(area_d(last_t_cut:locs(j)));  
       last_t_cut = locs(j);
       mid_t_cut = round(0.25*(locs(j)+3*locs(j+1)))-1;
       area_hump2(count, j) = sum(area_d(last_t_cut:mid_t_cut));  
       last_t_cut = mid_t_cut;
    end
    
end

t_range_peek = [10, 11.5; 
    12, 13.5; 
    13,14.5; 
    14,15.5
    15, 16.5
    16.6, 17.4
    17.5, 18.5];
x_range_peek = [0.084,0.09; 
    0.111, 0.12; 
    0.132, 0.143;
    0.147, 0.161
    0.16, 0.172
    0.171, 0.177
    0.18, 0.19];
mcolours = 'gcmyk';

for i = 1:length(x_range_peek) % For all the peeks
    figure(i+1)
    suptitle(['Wave Number: ', num2str(i)])
    subplot(1,2,1)
    plot(count_x(1:size(area_hump1, 1)), area_hump1(:,i), '-b')
    hold on
    plot(count_x(1:size(area_hump1, 1)), area_hump2(:,i), '-r')
    grid on
    xlim(x_range_peek(i,:))
    
    for j = x_range_peek(i, 1)*1000+1:x_range_peek(i, 2)*1000 + 1
        subplot(1,2,1)
        indx_x = find(count_x < (j-1)/1000+0.0001, 1);
        plot(count_x(indx_x), area_hump1(indx_x,i), ['x',mcolours(mod(j,5)+1)])
        plot(count_x(indx_x), area_hump2(indx_x,i), ['x',mcolours(mod(j,5)+1)])
                
        subplot(2,2,2)
        hold on; grid on
        indx_t = find(t >= t_range_peek(i,1),1):find(t >= t_range_peek(i,2),1);
        plot(t(indx_t), Z(j,indx_t), mcolours(mod(j,5)+1))
        xlim(t_range_peek(i,:))
        title('Concentration vs time')
        
        subplot(2,2,4)
        hold on; grid on
        plot(t(indx_t), d2Zdx2(j,indx_t), mcolours(mod(j,5)+1))
        xlim(t_range_peek(i,:))
        title('Diffusion vs time')
    end
%     pause()
end