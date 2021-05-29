%% 이미지 파일 불러오기
[x, map] = imread('Lena.png');
%% 변수 선언
mask_len = 10;
row_size = size(x,1);
col_size = size(x,2);
%% 출력 값을 담을 변수의 자료형을 uint8로 지정
y = uint8(zeros(size(x)));
b = 20;
offset = [1,0,1,1;-1,0,1,-1;0,1,-1,1;0,-1,-1,-1];
%%

edge_finding = 3*x;



for m=1:256
    for n=1:256
        point = [m,n,m,n;m,n,m,n;m,n,m,n;m,n,m,n];
        point = point + offset;
        
        for i = 1:4
            if point(i,1)>0 && point(i,1)<256 && point(i,2)>0 && point(i,2)<256
                edge_finding(m,n) = edge_finding(m,n) - x(point(i,1),point(i,2));
            end
            if point(i,3)>0 && point(i,3)<256 && point(i,4)>0 && point(i,4)<256
                edge_finding(m,n) = edge_finding(m,n) + 0.25*x(point(i,3),point(i,4));
            end
        end
        y(m,n) = x(m,n)+b*edge_finding(m,n);
        
%         y(m,n) = 3.*x(m,n)-(x(m+1,n)+x(m-1,n)+x(m,n+1)+x(m,n-1))+1/4.*(x(m+1,n+1)+x(m+1,n+1)+x(m+1,n-1)+x(m-1,n+1)+x(m-1,n-1));
% 
% 
%         z(m,n) = x(m,n)+b.*y(m,n);


    end
end

%%
imwrite(y,map,'lena_hpf.jpg'); % lena.jpg로 변경
