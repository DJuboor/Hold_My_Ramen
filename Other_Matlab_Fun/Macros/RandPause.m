function RandPause( time, E_p )
%This function pauses for a random amount of time between the given
%variables a and b
%   a and b must be single integers
p_time = Humanize(time,E_p);

pause(p_time);

end

