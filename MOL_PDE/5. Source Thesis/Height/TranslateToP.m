function [ C ] = TranslateToP( pathdataE, P, model, mybetanew, wavedatamag)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

if model == 1
    load('C:\Temp\Diffusion\MOL_PDE\4. Output files\1. ODE_Bifurcations\2. Goldbeter\DataBi.mat')
elseif model ==2
    load('C:\Temp\Diffusion\MOL_PDE\4. Output files\1. ODE_Bifurcations\1. Dupont\DataBi.mat')
elseif model == 3
    load('C:\Temp\Diffusion\MOL_PDE\4. Output files\4. ToyModel 1 and 2\Toy2_DataBi.mat')
end
min(length(pathdataE))

Z_SS = median(Z(:, floor(length(t)*0.75):end)')';
Z_SS_order=[];
for ii = length(mybetanew):-1:1
    vq = interp1(mybeta,Z_SS,mybetanew(ii));
    Z_SS_order(ii) = vq;
end

C = diag(diag(wavedatamag) - diag(Z_SS_order(1:length(wavedatamag)))- diag(pathdataE));



end

