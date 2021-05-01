clear all; clc;
audio_info = audioinfo('sample.wav'); 
[m, Fs] = audioread('sample.wav'); %m은 오디오 신호의 시간영역 샘플들
                                    %Fs는 샘플링 주파수
t = (0:1/Fs:(audio_info.TotalSamples-1)/Fs).'; %audio_info 구조체의 멤버인 TotalSamples를 불러오며 이는 해당 오디오 파일의 총 (시간영역) 샘플의 수를 나타낸다.
fc = 100000;            %fc=100kHz
dt = 1/Fs;
c = cos(2*pi*fc*t);     %반송파. Phi=0이므로 생략
s = m.*c;               %dsb-sc변조 완료
df = Fs / length(t);
f = -Fs/2:df:Fs/2 -df;
f = f.';                %행과 열을 바꾸어줌(전치). 아래에서 LPF 사용하기 위함

c_a = 2 * cos(2*pi*100000*t);
c_b = 2 * cos(2*pi*100000*t);
c_c = 2 * cos(2*pi*99999*t);
c_d = 2 * cos(2*pi*100000*t+ (89*pi)/180);

gaussian = randn(size(t));
S = rms(s)^2;
N_0dB = S;              %SNR=0dB일 때 잡음전력
N_15dB = S/(10^(1.5));  %SNR=15dB일 때  잡음전력
gaussian_noise_0dB = gaussian*sqrt(N_0dB);
gaussian_noise_15dB = gaussian*sqrt(N_15dB);
sn_0dB = s+gaussian_noise_0dB;      %SNR=0dB일 때 수신신호
sn_15dB = s+gaussian_noise_15dB;    %SNR=15dB일 때 수신신호
v_a = sn_0dB.*c_a;          %[a]조건에 따른 복조신호
v_b = sn_15dB.*c_b;         %[b]조건에 따른 복조신호
v_c = sn_15dB.*c_c;         %[c]조건에 따른 복조신호
v_d = sn_15dB.*c_d;         %[d]조건에 따른 복조신호
   
subplot(3,4,1);plot(f, abs(fftshift(fft(v_a)))*dt); %LPF 씌우기 직전의 진폭 스펙트럼
subplot(3,4,2);plot(f, abs(fftshift(fft(v_b)))*dt);
subplot(3,4,3);plot(f, abs(fftshift(fft(v_c)))*dt);
subplot(3,4,4);plot(f, abs(fftshift(fft(v_d)))*dt);

%이제 여기에 LPF씌운 후 원래 신호 검출
l = zeros(length(t),1);
%-2.3만~2.3만까지만 통과시키는 이상적인 LPF
for i=1:length(t)
	if abs(f(i)) <= 23000   %주파수 대역폭 23000Hz이하만 필터링.
        l(i) = 1;
	end
end
V_a = fftshift(fft(v_a)).*l;        %복조신호 진폭 스펙트럼
V_b = fftshift(fft(v_b)).*l;
V_c = fftshift(fft(v_c)).*l;
V_d = fftshift(fft(v_d)).*l;

V_a_time = ifft(ifftshift(V_a));    %복조신호 시간영역파형
V_b_time = ifft(ifftshift(V_b));
V_c_time = ifft(ifftshift(V_c));
V_d_time = ifft(ifftshift(V_d));

subplot(3,4,5);plot(f, abs(V_a)*dt);    %복조신호 진폭 스펙트럼 출력
subplot(3,4,6);plot(f, abs(V_b)*dt);
subplot(3,4,7);plot(f, abs(V_c)*dt);
subplot(3,4,8);plot(f, abs(V_d)*dt);

subplot(3,4,9);plot(t(19901:20000), V_a_time(19901:20000));    %복조신호 시간영역 파형 출력
subplot(3,4,10);plot(t(19901:20000), V_b_time(19901:20000));
subplot(3,4,11);plot(t(19901:20000), V_c_time(19901:20000));
subplot(3,4,12);plot(t(19901:20000), V_d_time(19901:20000));

audiowrite('output_a.wav',V_a_time, Fs);
audiowrite('output_b.wav',V_b_time, Fs);
audiowrite('output_c.wav',V_c_time, Fs);
audiowrite('output_d.wav',V_d_time, Fs);