

dir_save = 'C:\Temp\Diffusion\MOL_PDE\4. Output files\1. ODE_Bifurcations';
dir_parent = 'C:\Temp\Diffusion\MOL_PDE\5. Source Thesis';
cd(dir_save);

IfSave_Load_DataLoad = 3; 
NumberOfFig = 2;
SpecificFig = 1;


if IfSave_Load_DataLoad == 1
    %% Save Figures 
    for ii = 1:NumberOfFig
        savefig(ii, [num2str(ii), 'TestFile.fig'])
    end
elseif IfSave_Load_DataLoad == 2
    %% Load Figures previously saved
    for ii = 1:NumberOfFig
        openfig([num2str(ii), 'TestFile.fig'])
    end
    
elseif IfSave_Load_DataLoad == 3
    %% Load a specific figure and collect the data - if not easy check 
    % Only use if there is no .mat file
    s = load([num2str(SpecificFig), 'TestFile.fig'],'-mat');
    XData = s.hgS_070000.children.children(1).properties.XData;
    YData = s.hgS_070000.children.children(1).properties.YData;
    
end


cd(dir_parent)