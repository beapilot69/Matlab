clear all; clc;

audio_info = audioinfo('sample.wav'); 
[m, Fs] = audioread('sample.wav'); %m은 오디오 신호의 시간영역 샘플들
                                    %Fs는 샘플링 주파수

t = (0:1/Fs:(audio_info.TotalSamples-1)/Fs).'; %audio_info 구조체의 멤버인 TotalSamples를 불러오며 이는 해당 오디오 파일의 총 (시간영역) 샘플의 수를 나타낸다.
fc = 100000; %100kHz, PHI=0이므로 생략
dt = 1/Fs;
c = cos(2*pi*fc*t);    %반송파
s = m.*c; %%%dsb-sc변조 완료
df = Fs / length(t);
f = -Fs/2:df:Fs/2 -df;  

subplot(2,2,1);plot(t(19901:20000), m(19901:20000), '-b'); %메세지 신호의 시간파형
subplot(2,2,2);plot(t(19901:20000), s(19901:20000), '-k'); %DSB-SC변조 신호의 시간파형
%fftshift(fft(m)).*dt를 수행하기 전에 f축에 대한 계산이 선행되어야함
subplot(2,2,3);plot(f, abs(fftshift(fft(m)))*dt, '-b'); %메세지 신호의 진폭스펙트럼
subplot(2,2,4);plot(f, abs(fftshift(fft(s)))*dt, '-k'); %변조된 신호의 진폭스펙트럼