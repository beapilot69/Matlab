clear all; clc;
audio_info = audioinfo('sample.wav');
[m, Fs] = audioread('sample.wav');

t = (0:1/Fs:(audio_info.TotalSamples-1)/Fs).';
dt = 1/Fs;
fc = 100000; %100kHz, PHI는 0이므로 생략
c = cos(2*pi*fc*t);    %문제에서 주어진 반송파. Phi는 0이므로 생략.
s = m.*c; %%%DSB-SC변조 신호
df = Fs / length(t);
f = -Fs/2:df:Fs/2 -df;  

gaussian = randn(size(t));
%S,N구하기
S = rms(s)^2;   %메세지 신호 전력
N_0dB = S;      %SNR 0dB되기 위한 잡음 전력
N_15dB = S/(10^(1.5));  %SNR 15dB되기 위한 잡음 전력

gaussian_noise_0dB = gaussian*sqrt(N_0dB);
gaussian_noise_15dB = gaussian*sqrt(N_15dB);

sn_0dB = s+gaussian_noise_0dB;
sn_15dB = s+gaussian_noise_15dB;

subplot(4,1,1);plot(t(19901:20000), sn_0dB(19901:20000),'-k');   %SNR이 0dB일 때 시간영역파형
subplot(4,1,2);plot(f, abs(fftshift(fft(sn_0dB)))*dt,'-k');      %SNR이 0dB일 때 진폭 스펙트럼
subplot(4,1,3);plot(t(19901:20000), sn_15dB(19901:20000),'-b');  %SNR이 15dB일 때 시간영역파형
subplot(4,1,4);plot(f, abs(fftshift(fft(sn_15dB)))*dt,'-b');     %SNR이 15dB일 때 진폭 스펙트럼