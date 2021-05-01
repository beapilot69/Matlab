t = -6:0.001:6;
x_t = 1 + 2*sinc(k./2).*cos(1*pi*k/2*t);

for k = 1:40
    x_t = x_t + 2*sinc(k./2).* cos(1*pi*k/2*t);
end
plot(t, x_t, 'b-')
xlabel('t')
xticks(-6:1:6)
ylabel('x(t)')
title('Frequency synthesis-Square pulse/ N=40')