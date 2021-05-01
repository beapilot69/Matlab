t = -6:0.001:6;

for k1 = 1:3  
    p1=p1-(4)./((k1.^2).*(pi.^2)).*exp(sqrt(-1)*k1*(pi/2)*t); 
end
for k2 = 1:10 
    p2=p2-(4)./((k2.^2).*(pi.^2)).*exp(sqrt(-1)*k2*(pi/2)*t);
end
for k3 = 1:20 
    p3=p3-(4)./((k3.^2).*(pi.^2)).*exp(sqrt(-1)*k3*(pi/2)*t);
end
for k4 = 1:40 
    p4=p4-(4)./((k4.^2).*(pi.^2)).*exp(sqrt(-1)*k4*(pi/2)*t);
end

subplot(2,2,1)				
plot(t,p1);
xlabel('t')
xticks(-6:2:6)
ylabel('x(t)')
title('Frequency synthesis/N=3');

subplot(2,2,2)
plot(t,p2);
xlabel('t')
xticks(-6:2:6)				
ylabel('x(t)')
title('N=10');

subplot(2,2,3)			
plot(t,p3);
xlabel('t')
xticks(-6:2:6)
ylabel('x(t)')
title('N=20');

subplot(2,2,4)				
plot(t,p4);
xlabel('t')
xticks(-6:2:6)
ylabel('x(t)')
title('N=40');
