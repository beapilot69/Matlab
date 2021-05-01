t = -4 : 0.01 : 4;
a = pi*t; 
sinct = sin(a) ./ a;
plot(t, sinct);
ylim([-0.5 1.2])
title('sinc(t)')