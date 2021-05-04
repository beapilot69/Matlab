function [message] = wifireceiver(txsignal,level)
%UNTITLED 이 함수의 요약 설명 위치
%   자세한 설명 위치
%%
message = txsignal;
Trellis = poly2trellis(7,[133 171]);
%% level.1 turbo decoding
if (level >= 1)
    %input = [bin2dec()-'0', output];
    bits = num2str(reshape(vitdec(message,Trellis,40,'cont','hard'),8,[]).');
    bits = nonzeros(bin2dec(bits)).';


end



end

