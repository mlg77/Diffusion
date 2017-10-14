function [ x, mybetagrid, mybeta, MeshM ] = Create2D( x1, x2, linear_beta )
%Create2D Takes two linear coordinates and a linear beta and produces a
%   grid of values and a vector and how they relate to each other
% Want to create circular boundary conditions for x1 = x2 = 0 corner First
% row and first collumn

M = length(x1);
N = length(x2);

% Initalise the grid for beta
mybetagrid = zeros(M, M);

% Initalise the 2 vectors
x = zeros(numel(mybetagrid), 2);
mybeta = zeros(numel(mybetagrid),1);

% Initalise Mesh Grid
MeshM = zeros(length(mybeta), length(mybeta));

for ii = 1:M
    for jj = 1:N
        if sqrt(x1(ii)^2 + x2(jj)^2) > 1
            % Do nothing
        else
            idx_x = find(x1 >= sqrt(x1(ii)^2 + x2(jj)^2), 1);
            mybetagrid(ii, jj) = linear_beta(idx_x);
            mybeta((ii-1)*M + jj, 1) = linear_beta(idx_x);
        end
        entN = (ii-1)*M + jj;
        
        x(entN, 1) = x1(ii);
        x(entN, 2) = x2(jj);
        
        MeshM(entN, entN) = -4;
        if ii == 1 &&  jj == 1
            % First Corner
            MeshM(1, 2) = 2;
            MeshM(1, M + 1) = 2;
        elseif ii == 1 &&  jj == N
            % Second Corner
            MeshM(M, M-1) = 2;
            MeshM(M, 2*M) = 2;
        elseif ii == M &&  jj == 1
            % Third corner
            MeshM(entN, entN + 1) = 2;
            MeshM(entN, entN - M ) = 2;
        elseif ii == M &&  jj == N
            % Fourth corner
            MeshM(entN, entN - 1) = 2;
            MeshM(entN, entN - M) = 2;
        elseif ii == 1 
            % First Row
            MeshM(entN, entN+1) = 1;
            MeshM(entN, entN-1) = 1;
            MeshM(entN, entN+M) = 1;
            MeshM(entN, (entN-1)*M+1) = 1; % Wrap around
        elseif ii == M
            % Last Row
            MeshM(entN, entN+1) = 1;
            MeshM(entN, entN-1) = 1;
            MeshM(entN, entN-M) = 2;
        elseif jj == 1 
            % First Col
            MeshM(entN, entN+1) = 1;
            MeshM(entN, entN-M) = 1;
            MeshM(entN, entN+M) = 1;
            MeshM(entN, ii) = 1; % Wrap around
        elseif jj == length(x2)
            % Last Col
            MeshM(entN, entN-1) = 2;
            MeshM(entN, entN-M) = 1;
            MeshM(entN, entN+M) = 1;
        else
            % Center points
            MeshM(entN, entN-1) = 1;
            MeshM(entN, entN+1) = 1;
            MeshM(entN, entN-M) = 1;
            MeshM(entN, entN+M) = 1;
        end
        
    end
end


end

