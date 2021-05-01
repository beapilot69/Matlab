k = -7:2:7;
k1 = -7:2:-1;
k2 = 1:2:7;

p = -7:2:7;
p(k<0)=angle(sinc(k1/2));
p(k>0)=-angle(sinc(k2/2));

stem(k, p, 'b-')

xlim([-9 9])
xlabel('w_o')
xticks(-9:2:9)
ylim([-4 4])
ylabel('phase(X_k)')
title('Square pulse-Phase Spectrum')