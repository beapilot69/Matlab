N = 1024;
f0 = 100;
ts1 = 1/75; 
ts2 = 1/100;
ts3 = 1/125;
ts4 = 1/400;

%1번 그래프
subplot(4,1,1);
t = 0:ts1:(N-1)*ts1;
x = cos(2*pi*f0*t);
fs1 = 75;
df = fs1 / N;
X = fft(x);
X_shift = fftshift(X);
f = (-N/2)*df:df:(N/2-1)*df;
plot(f,abs(X_shift)/max(abs(X_shift)));

%2번 그래프
subplot(4,1,2);
t = 0:ts2:(N-1)*ts2;
x = cos(2*pi*f0*t);
fs2 = 100;
df = fs2 / N;
X = fft(x);
X_shift = fftshift(X);
f = (-N/2)*df:df:(N/2-1)*df;
plot(f,abs(X_shift)/max(abs(X_shift)));
xticks(-50:10:50)

%3번 그래프
subplot(4,1,3);
t = 0:ts3:(N-1)*ts3;
x = cos(2*pi*f0*t);
fs3 = 125;
df = fs3 / N;
X = fft(x);
X_shift = fftshift(X);
f = (-N/2)*df:df:(N/2-1)*df;
plot(f,abs(X_shift)/max(abs(X_shift)));

%4번 그래프
subplot(4,1,4);
t = 0:ts4:(N-1)*ts4;
x = cos(2*pi*f0*t);
fs4 = 400;
df = fs4 / N;
X = fft(x);
X_shift = fftshift(X);
f = (-N/2)*df:df:(N/2-1)*df;
plot(f,abs(X_shift)/max(abs(X_shift)));