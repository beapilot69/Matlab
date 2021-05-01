t = -1 : 0.01 : 3;

xt1 = cos(2*pi*t)
xt2 = cos(2*pi*t + pi/2)
xt3 = cos(2*pi*t - pi/2)

subplot(3,1,1); plot(t, xt1);
subplot(3,1,2); plot(t, xt2);
subplot(3,1,3); plot(t, xt3);