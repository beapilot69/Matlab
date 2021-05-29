%%% edge-finding filter 구현

%% 이미지 파일 불러오기
[x, map] = imread('lena.png');

%% 변수 선언 
y = uint8(zeros(size(x))); % 입력 x에 대한 edge-finding filter의 결과물
z = uint8(zeros(size(x))); % dege0finding filter를 이용한 입력 x에 대한 sharpening 필터의 식
b=30;

x1 = zeros(1,256); % 1x256 영행렬 생성
x2 = zeros(258,1); % 258x1 영행렬 생성
x3= [x1; x; x1];   % x의 첫행과 마지막행에 1x256영행렬 추가
x3= [x2 x3 x2];    % x3의 첫열과 마지막열에 258x1영행렬 추가


%%
for m =1:length(y) % 행 인터레이션
    for n = 1:length(y)

        y(m,n)=3*x3(m+1,n+1)-(x3(m+2,n+1)+x3(m,n+1)+x3(m+1,n+2)+x3(m+1,n))+(1/4)*(x3(m+2,n+2)+x3(m+2,n)+x3(m,n+2)+x3(m,n));
        z(m,n)=x3(m+1,n+1)+(b*y(m,n));
    end        
end

%% 출력
n = length(z);% number of samples
fs = 250;
f =  (-n/2:n/2-1)*(fs/n);     % frequency range

subplot(2,1,1);
% plot(f,fftshift(fft(y(100,1:end))))
plot(1:length(x),z(100,1:end));
subplot(2,1,2); 
% plot(f,fftshift(fft(x(100,1:end))))
plot(1:length(x),x(100,1:end));

imwrite(y,map,'lena_HPF_30y.jpg');
imwrite(z,map,'lena_HPF_30z.jpg');
