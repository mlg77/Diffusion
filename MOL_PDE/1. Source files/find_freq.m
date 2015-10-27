function [f] = find_freq(Z, t)
%Find the frequency of a occolation
%   inputs: Z vector
%   output: f, average frequency

if abs(max(Z) -min(Z))/max(Z) < 0.001
    f = 0;
    return
end
up = 0;
down = 0;
for  i = 1:length(Z)-1
    if Z(i+1) - Z(i)  > 0
        up = 1;
    else
        down = 1;
    end
end
if up & down
    % we will continue
%     hold on
%     plot(t, Z)
else
    f = 0;
    return
end


diff = sign(Z(2:end) - Z(1:end-1));
maxxxes = [];
count = 1;
for i = 1:length(diff)-1
    if diff(i+1) ~= diff(i) && diff(i) > 0
        maxxxes(count,:) = [t(i+1), Z(i+1)];
        count = count +1;
    end
end
% plot(maxxxes(:,1), maxxxes(:,2))
% pause(0.5)
periodd =  maxxxes(2:end,1) - maxxxes(1:end-1,1);
f = mean(periodd);

end
