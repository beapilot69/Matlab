%% 이미지 파일 불러오기
[x, map] = imread('Lena.png');

%% 변수 선언 
y = uint8(zeros(size(x))); % 입력 x에 대한 edge-finding filter의 결과물
row_size = size(y,1);
col_size = size(y,2);
z = uint8(zeros(size(x))); % edge-finding filter를 이용한 입력 x에 대한 sharpening 필터의 식
b=3;

x1 = zeros(1,256); % 1x256 영행렬 생성
x2 = zeros(258,1); % 258x1 영행렬 생성
x3= [x1; x; x1];   % x의 첫행과 마지막행에 1x256영행렬 추가
x3= [x2 x3 x2];    % x3의 첫열과 마지막열에 258x1영행렬 추가


%% 차분방정식 연산
for m =1:row_size 
    for n = 1:col_size
        y(m,n)=3*x3(m+1,n+1)-(x3(m+2,n+1)+x3(m,n+1)+x3(m+1,n+2)+x3(m+1,n))+(1/4)*(x3(m+2,n+2)+x3(m+2,n)+x3(m,n+2)+x3(m,n));
        z(m,n)=x3(m+1,n+1)+(b*y(m,n));
    end        
end

%% 출력
imwrite(y,map,'lena_HPF_y.jpg');
imwrite(z,map,'lena_HPF_3z.jpg');

%% 주파수축 관찰
n = length(z);                % 출력신호 길이만큼 샘플수 지정
fs = 250;
f =  (-n/2:n/2-1)*(fs/n);     % 주파수 범위 지정

% subplot(3,1,1); plot(f,fftshift(fft(x(100,1:end))))
% subplot(3,1,2); plot(f,fftshift(fft(y(100,1:end))))
% subplot(3,1,3); plot(f,fftshift(fft(x(100,1:end))))

%% 시간축 관찰
subplot(3,1,1); plot(1:length(x),x(100,1:end));
subplot(3,1,2); plot(1:length(x),y(100,1:end));
subplot(3,1,3); plot(1:length(x),z(100,1:end));