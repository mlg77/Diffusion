%% Plotting only

% Load

M = length(x1);

figure(1); 
subplot(1,2,1); hold on; xlabel('x1'); ylabel('x2'); title('Concentration');
colormap jet
pause();
for ii = 1:5:length(t)
    Z_Grid = zeros(length(x1), length(x1));
    for jj = 1:length(x2)
        Z_Grid(jj, :) = Z((jj-1)*M + 1:jj*M, ii);
    end
    imagesc(x1, x2, Z_Grid)
    axis([0,1,0,1])
    colorbar
    pause(dt*5)
end