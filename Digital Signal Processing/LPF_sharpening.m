%% 이미지 파일 불러오기
[x, map] = imread('Lena.png');
%% 변수 선언
mask_len = 255; % 3포인트 평균기에 사용
row_size = size(x,1);
col_size = size(x,2);
%% 출력 값을 담을 변수의 자료형을 uint8로 지정
y = uint8(zeros(size(x))); 
%y = uint8(zeros(row_size, col_size+mask_len-1)); 

temp = double(0);   %임시저장 변수

%% LPF - smoothing. 이동평균기와 지연연산기를 이용  (결과가 충분히 다르도록 차수 두 개를 스스로 결정)
for row = 1:row_size
    for col = (mask_len-1)/2 + 1 : col_size + (mask_len-1)/2
        if col < mask_len                      % 열이 차수보다 작다면 -> 다음의 계산과정 필요
                                  %출력1번 = 입력1번 / 차수
                                  %출력2번 = (입력1번+입력2번) / 차수
                                  %출력n번 = (입력1번+입력2번+...+입력n번) / 차수          
            for z=1:col
                temp = temp + double(x(row,z));
                y(row,col-(mask_len-1)/2) = temp / mask_len;
            end
        else        % 열이 차수보다 크거나 같으면x
            if (col <= 256)
                for n = 1:mask_len    % 임시변수에 (열+1-n)값 덧셈을 차수만큼 반복. 즉 자신,이전값.전전값... 차수만큼 덧셈
                    temp = temp + double(x(row,col+1-n));
                end
                y(row,col-(mask_len-1)/2) = temp / mask_len;   % 계산이 끝났으면 임시변수 값 / 차수 값을 출력값에 저장하고
            else
                for k=1:mask_len-(col-length(x))
                    temp = temp + double(x(row,length(x)+1-k));
                end
                y(row,col-(mask_len-1)/2) = temp / mask_len;
            end
        end
        temp = 0;
    end
end

%% 최종 출력 y를 이미지로 변환
imwrite(y,map,'lena_LPF_255.jpg'); % lena.jpg로 변경

%% FFT
n= length(x);
f= (-n/2:n/2-1)*(100/n);

subplot(2,1,1);plot(f,abs(fftshift(fft(x(100,1:end)))));
subplot(2,1,2);plot(f,abs(fftshift(fft(y(100,1:end)))));