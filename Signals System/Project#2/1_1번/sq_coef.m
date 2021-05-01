k = -7:1:7;
stem(k, sinc(k/2), 'b-');

xlim([-8 8])
xlabel('w_o')
xticks(-8:1:8)
ylim([-0.4 1.2])
ylabel('X_k')
title('Square pulse-Furier coefficient')