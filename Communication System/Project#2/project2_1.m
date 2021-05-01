clear all; clc;

audio_info = audioinfo('sample.wav'); 
[m, Fs] = audioread('sample.wav'); %m은 오디오 신호의 시간영역 샘플들
                                    %Fs는 샘플링 주파수

t = (0:1/Fs:(audio_info.TotalSamples-1)/Fs).'; %audio_info 구조체의 멤버인 TotalSamples를 불러오며 이는 해당 오디오 파일의 총 (시간영역) 샘플의 수를 나타낸다.
fc = 100*10^3;               %100kHz, PHI=0이므로 생략
Ts = 1/Fs;
Am = rms(m);
fm = 22.05*10^3;

beta1 = 0.1;
beta2 = 0.5;
kf1 = beta1*fm/Am;
kf2 = beta2*fm/Am;

%% 증분기 구현
m_ = zeros(5009768,1); %size(m)=5009768
m_(1) = 0;  %적분된 신호의 첫 번째 샘플의 값을 0으로 가정
for n=2:5009768
    m_(n) = m_(n-1)+ m(n-1)*Ts; %적분값 차 정의
end
%% FM변조신호
s1 = sqrt(2).*cos(2*pi*fc*t+2*pi*kf1*m_);
s2 = sqrt(2).*cos(2*pi*fc*t+2*pi*kf2*m_);
%% 출력
subplot(3,2,1);plot(t(19901:20000),m(19901:20000));
subplot(3,2,3);plot(t(19901:20000),s1(19901:20000));
subplot(3,2,5);plot(t(19901:20000),s2(19901:20000));
df = Fs / length(t);
f = -Fs/2:df:Fs/2 -df;  
subplot(3,2,2);plot(f, abs(fftshift(fft(m)))*Ts, '-b'); %메세지 신호의 진폭스펙트럼
subplot(3,2,4);plot(f, abs(fftshift(fft(s1)))*Ts, '-b'); %beta1에 의해 FM변조된 신호의 진폭스펙트럼
subplot(3,2,6);plot(f, abs(fftshift(fft(s2)))*Ts, '-b'); %beta2에 의해 FM변조된 신호의 진폭스펙트럼