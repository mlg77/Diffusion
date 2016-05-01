%% Does the wave change shape with x?


%Start at time 10 ~ Steady state
x_positions = 0.3:0.001:0.6;

figure(2)
leg = {}; count = 0;
% Find 3 osculations after 10 seconds and plot them
for i = find(x >= x_positions(1),1):find(x >= 0.005,1):find(x >= x_positions(end),1)
    count = count+1;
    start_t = find(t>=10,1); % Start at 10 seconds
    Z_inQ = Z(i, start_t:end); % Make first cut of Z
    res = Z_inQ(2:end)< Z_inQ(1); % when does Z go below the first value
    if res(1) == 1
        a = find(res== 0,1); 
        b = find(res(a:end)==1,1)+a; % one oscullation
        if isempty(b) | isempty(a)
            [pks,locs] = findpeaks(1./Z_inQ);
            if length(locs)<2
                b = 1;
            else
                b = locs(2)-locs(1);
            end
        end 
    else
        a = find(res== 1,1); 
        b = find(res(a:end)==0,1)+a; % one oscullation
        if isempty(b) | isempty(a)
            [pks,locs] = findpeaks(1./Z_inQ);
            if length(locs)<2
                b = 1;
            else
                b = locs(2)-locs(1);
            end
        end 
    end
    Z_inQ= Z_inQ(1:3*b); % Make second cut
    t_inQ = t(start_t+[1:3*b]-1);
    % Now just find one wave split by a minimum
    start_min = find(min(Z_inQ)==Z_inQ);
    if start_min + b > length(Z_inQ)
        start_min= start_min-b;
    end
    Z_inQ = Z_inQ(start_min:start_min+b);
    t_inQ = t_inQ(start_min:start_min+b);
    
    
%     subplot(2,3, count)
    hold off
    plot([t_inQ(find(max(Z_inQ)==Z_inQ)), t_inQ(find(max(Z_inQ)==Z_inQ))], [0.2, max(Z_inQ)],'r', 'linewidth', 4)
    hold on
    plot(t_inQ, Z_inQ,'b', 'linewidth', 4)
    title(num2str(x(i)))
    xlabel('Time [s]')
    ylabel('Concentration')
%     grid on
    
    
    
    %% Try PDF_Skewed

%     mphi = @(p) (1/sqrt(2*pi))*exp(-p.^2/2);
%     mPHI = @(p) 0.5*(1+erf(p/sqrt(2)));
%     % Where the parameters are x0, mscale, maplha
%     funct = @(x0_s_a, p)  (2/x0_s_a(2))*mphi((p-x0_s_a(1))/x0_s_a(2)).*mPHI(x0_s_a(3)*(p-x0_s_a(1))/x0_s_a(2))+min(Z_inQ);
% %     x0_s_a = lsqcurvefit(funct,[12.7,0.3,1],t_inQ',Z_inQ)
% %     ToFit = funct(x0_s_a,t_inQ);
% %     plot(t_inQ, ToFit)
%     
%     %%Try third time splitting by peek
    t_inQFirst = t_inQ(1:find(max(Z_inQ)== Z_inQ));
    Z_inQFirst = Z_inQ(1:length(t_inQFirst));
    t_inQSecond = t_inQ(length(t_inQFirst)+1:end);
    Z_inQSecond = Z_inQ(length(t_inQFirst)+1:end);
%     
%     x0_s_a = lsqcurvefit(funct,[12.7,0.3,1],t_inQSecond',Z_inQSecond)
%     ToFit = funct(x0_s_a,t_inQ);
%     plot(t_inQ, ToFit)
    %% Try just find the rough 3 gradients
    gradientf = diff(Z_inQ)'./(diff(t_inQ));
%     plotyy(t_inQ(2:end), gradientf, t_inQ, Z_inQ)
    % Point of interest: slow increase, fast increase, max, fast decrease 
    point_interest = [mean(gradientf(1:find(diff(gradientf) > 0.2,1))), x(i); 
        max(gradientf), find(max(gradientf)==gradientf)/length(gradientf);
        max(Z_inQ), find(max(Z_inQ)==Z_inQ)/length(Z_inQ);
        min(gradientf), find(min(gradientf)==gradientf)/length(gradientf)]; 
    point_int_num(count, 1:4) = point_interest(:,1);
    point_int_pos(count, 1:4) = point_interest(:,2);
    
    fp_first = flip(Z_inQFirst);
    min_len = min([length(fp_first), length(Z_inQSecond)]);
    cross_over = find(fp_first(30:min_len) >= Z_inQSecond(30:min_len), 1)+30;
    if isempty(cross_over)
        cross_over = 1;
    end
%     subplot(1,2,1);     plot([0:length(Z_inQ)-1]/length(Z_inQ), Z_inQ)
%     axis([0,1,0,1.4])
%     subplot(1,2,2);   
%     hold on
%     plot(Z_inQSecond, 'r')
%     plot(flip(Z_inQFirst), 'b')
%     plot(cross_over, Z_inQSecond(cross_over), 'xg')
    cross_overs(count) = t(cross_over);
    
%     pause()
end 
figure(3)
for i = 1:4
    subplot(2,4,i); plot(point_int_pos(:,1), point_int_num(:,i))
end
subplot(2,4,1); ylabel('rate of slow increase') ; xlabel('Position, x')
subplot(2,4,2); ylabel('rate of fast increase'); xlabel('Position, x')
subplot(2,4,3); ylabel('max'); xlabel('Position, x')
subplot(2,4,4); ylabel('fast decrease'); xlabel('Position, x')
for i = 2:4
    subplot(2,4,i+4); plot(point_int_pos(:,1), point_int_pos(:,i))
end
subplot(2,4,6); ylabel('fast increase, position'); xlabel('Position, x')
subplot(2,4,7); ylabel('max position '); xlabel('Position, x')
subplot(2,4,8); ylabel('fast decrease, position'); xlabel('Position, x')

figure(5)
% if the max is the zero mark what is the |distance| of the fast and slow
% from the max
hold on
X_fst = point_int_pos(:,1); 
Y_de = point_int_pos(:,4)-point_int_pos(:,3);
Y_in = point_int_pos(:,3)-point_int_pos(:,2);
plot(X_fst, Y_de, 'bx'); plot(X_fst, Y_in, 'rx')

funct = @(x0_s_a, p) x0_s_a(1)*exp(x0_s_a(2)*p)+ x0_s_a(3);
x0_de = lsqcurvefit(funct,[1,1,1],[X_fst;zeros(10,1)],[Y_de;zeros(10,1)]);
x0_in = lsqcurvefit(funct,[1,1,1],[X_fst;0],[Y_in;0]);
plot(x, funct(x0_de,x)); plot(x, funct(x0_in,x)); 

% line_de = polyfit(X_fst,Y_de./X_fst,1);
% line_in = polyfit(X_fst,Y_in./X_fst,1);
% plot(x, x.*(line_de(1)*x + line_de(2)), 'b')
% plot(x, x.*(line_in(1)*x + line_in(2)), 'r')
legend('Fast decrease', 'Fast increase', 'Mean decrease', 'Mean increase')
axis([0,0.6, 0, 0.06])
xlabel('Position, Beta'); ylabel('Percentage Difference from max')

figure(4)
hold on
plot(point_int_pos(:,1), cross_overs, 'xr')
% axis([0.2, 0.6, 0.4, 0.6])
% funct = @(x0_s_a, p) x0_s_a(1) + x0_s_a(2)*p;
% x0_s_a = lsqcurvefit(funct,[0.55,0.1],point_int_pos(1:35,1)',cross_overs(1:35))
% t_lag = funct(x0_s_a,0.1:0.0001:0.55);
% plot(0.1:0.0001:0.55, t_lag)

