t = -4 : 0.01 : 4;
tx1 = (t+1>0); 
tx2 = (t-1>0);
tx = tx1 - tx2;
plot(t, tx);
ylim([-2 2])
title('rect(t/2)=u(t+1)-u(t-1)')