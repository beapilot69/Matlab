clear all; clc;
audio_info = audioinfo('sample.wav');
[m, Fs] = audioread('sample.wav');

t = (0:1/Fs:(audio_info.TotalSamples-1)/Fs).';
fc = 100*10^3;
Ts = 1/Fs;
Am = rms(m);
fm = 22.05*10^3;

beta1 = 0.1;
beta2 = 0.5;
kf1 = beta1*fm/Am;
kf2 = beta2*fm/Am;

%% 증분기 구현
m_ = zeros(5009768,1); %size(m)=5009768
m_(1) = 0;
for n=2:5009768
    m_(n) = m_(n-1)+ m(n-1)*Ts; %적분값 차 정의
end
%% FM변조신호
s1 = sqrt(2).*cos(2*pi*fc*t+2*pi*kf1*m_);
s2 = sqrt(2).*cos(2*pi*fc*t+2*pi*kf2*m_);
%% 주파수 성분
df = Fs / length(t);
f = -Fs/2:df:Fs/2 -df;  

%% 가우시안 잡음 더해진 변조신호
gaussian = randn(size(t));
 %S,N구하기
S1 = rms(s1)^2;   %s1에 대한 메세지 신호 전력
N_0dB1 = S1;      %SNR 0dB되기 위한 잡음 전력
N_15dB1 = S1/(10^(1.5));  %SNR 15dB되기 위한 잡음 전력

S2 = rms(s2)^2;   %s2에 대한 메세지 신호 전력
N_0dB2 = S2;
N_15dB2 = S2/(10^(1.5));

gaussian_noise_0dB1 = gaussian*sqrt(N_0dB1);
gaussian_noise_0dB2 = gaussian*sqrt(N_0dB2);
gaussian_noise_15dB1 = gaussian*sqrt(N_15dB1);
gaussian_noise_15dB2 = gaussian*sqrt(N_15dB2);

sn_0dB_beta1 = s1+gaussian_noise_0dB1;   % SNR 0dB,beta=0.1일 때 가우시안 잡음 더해진 변조신호
sn_15dB_beta1 = s1+gaussian_noise_15dB1; % SNR 15dB,beta=0.1일 때 가우시안 잡음 더해진 변조신호
sn_0dB_beta2 = s2+gaussian_noise_0dB2;   % SNR 0dB,beta=0.5일 때 가우시안 잡음 더해진 변조신호
sn_15dB_beta2 = s2+gaussian_noise_15dB2; % SNR 15dB,beta=0.5일 때 가우시안 잡음 더해진 변조신호

%% [a]조건에 대하여 ( Low-SNR WBFM )
%beta = 0.5 = beta2이므로 s2를 사용한다.
%SNR 0dB이므로 sn_0dB_beta2 를 사용한다.
fc_a = 100*10^3;    %반송파 주파수
phi_a = 0;           %반송파 위상
rx_signal_a = sn_0dB_beta2;
z_a = hilbert(rx_signal_a)./exp(1i*2*pi*fc_a*t + phi_a);
phase1 = unwrap(angle(z_a));
%% [b]조건에 대하여
%beta = 0.1 = beta1이므로 s1을 사용한다.
%SNR 15dB이므로 sn_15dB_beta1을 사용한다.
fc_b = 100*10^3;    %반송파 주파수
phi_b = 0;           %반송파 위상
rx_signal_b = sn_15dB_beta1;
z_b = hilbert(rx_signal_b)./exp(1i*2*pi*fc_b*t + phi_b);
phase2 = unwrap(angle(z_b));
%% [c]조건에 대하여
%beta = 0.5 = beta2이므로 s2을 사용한다.
%SNR 15dB이므로 sn_15dB_beta2을 사용한다.
fc_c = 100*10^3;    %반송파 주파수
phi_c = 0;           %반송파 위상
rx_signal_c = sn_15dB_beta2;
z_c = hilbert(rx_signal_c)./exp(1i*2*pi*fc_c*t + phi_c);
phase3 = unwrap(angle(z_c));
%% [d]조건에 대하여
%beta = 0.5 = beta2이므로 s2을 사용한다.
%SNR 15dB이므로 sn_15dB_beta2을 사용한다.
fc_d = 60*10^3;    %반송파 주파수
phi_d = 0;           %반송파 위상
rx_signal_d = sn_15dB_beta2;
z_d = hilbert(rx_signal_d)./exp(1i*2*pi*fc_d*t + phi_d);
phase4 = unwrap(angle(z_d));
%% [e]조건에 대하여
%beta = 0.5 = beta2이므로 s2을 사용한다.
%SNR 15dB이므로 sn_15dB_beta2을 사용한다.
fc_e = 100*10^3;    %반송파 주파수
phi_e = 89*pi/180;  %반송파 위상
rx_signal_e = sn_15dB_beta2;
z_e = hilbert(rx_signal_e)./exp(1i*2*pi*fc_e*t + phi_e);
phase5 = unwrap(angle(z_e));
%% 차분기 구현 
%p(n) = zeros(5009768,1); %size(p)=5009768
phase_a = zeros(5009768,1);
phase_b = zeros(5009768,1);
phase_c = zeros(5009768,1);
phase_d = zeros(5009768,1);
phase_e = zeros(5009768,1);
for n=1:5009767
    phase_a(n) = (phase1(n+1)- phase1(n))/Ts; %적분값 차 정의
    phase_b(n) = (phase2(n+1)- phase2(n))/Ts;
    phase_c(n) = (phase3(n+1)- phase3(n))/Ts;
    phase_d(n) = (phase4(n+1)- phase4(n))/Ts;
    phase_e(n) = (phase5(n+1)- phase5(n))/Ts;
end
phase_a = phase_a./(2*pi*kf2);    %phi(t)=2*pi*kf.*integral(m(t))이므로 2*pi*kf를 나누어준다.
phase_b = phase_b./(2*pi*kf1);
phase_c = phase_c./(2*pi*kf2);
phase_d = phase_d./(2*pi*kf2);
phase_e = phase_e./(2*pi*kf2);


%% 출력
%subplot(5,2,1);plot(t(19901:20000), m(19901:20000));
%subplot(5,2,3);plot(f, abs(fftshift(fft(m)))*Ts);
subplot(5,2,1);plot(t(19901:20000), phase_a(19901:20000));
subplot(5,2,2);plot(f, abs(fftshift(fft(phase_a)))*Ts);

subplot(5,2,3);plot(t(19901:20000), phase_b(19901:20000));
subplot(5,2,4);plot(f, abs(fftshift(fft(phase_b)))*Ts);

subplot(5,2,5);plot(t(19901:20000), phase_c(19901:20000));
subplot(5,2,6);plot(f, abs(fftshift(fft(phase_c)))*Ts);

subplot(5,2,7);plot(t(19901:20000), phase_d(19901:20000));
subplot(5,2,8);plot(f, abs(fftshift(fft(phase_d)))*Ts);

subplot(5,2,9);plot(t(19901:20000), phase_e(19901:20000));
subplot(5,2,10);plot(f, abs(fftshift(fft(phase_e)))*Ts);

%audiowrite('output_a.wav',phase_a, Fs);
%audiowrite('output_b.wav',phase_b, Fs);
%audiowrite('output_c.wav',phase_c, Fs);
%audiowrite('output_d.wav',phase_d, Fs);
%audiowrite('output_e.wav',phase_e, Fs);

