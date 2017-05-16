function [ r, g, b ] = col_rainbow( Num, outOf )
%col_rainbow Given which Number you are out of how many return 
%   a scale of the rainbow
%   outOf has a max of max 765

vector_scale = [255:-1:0];

Red_vec = [vector_scale, vector_scale*0, 255-vector_scale];
Blue_vec = [vector_scale*0, 255- vector_scale, vector_scale];
green_vec = [255-vector_scale, vector_scale, vector_scale*0];

point_col = round((Num-1)*length(Red_vec)/outOf)+1;

r = Red_vec(point_col);
g = green_vec(point_col);
b = Blue_vec(point_col);

end

