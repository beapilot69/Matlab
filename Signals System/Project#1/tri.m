t = -4 : 0.01 : 4 ;
tx1 = (t+1>0); 
tx2 = (t>0);
tx3 = (t-1>0);
tri1 = (t+1) .* tx1;
tri2 = 2 .* t .* tx2;
tri3 = (t-1) .* tx3;
tri = tri1 - tri2 + tri3;
plot(t, tri);
ylim([-2 2])
title('tri(t) = (t+1)u(t+1)-2tu(t)+(t-1)u(t-1)')