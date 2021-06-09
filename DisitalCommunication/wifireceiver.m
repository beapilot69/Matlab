function [msg,len,start] = wifireceiver(txsignal, level)
%% Some constants
% We will split the data into a cluster of nfft bits
nfft = 64;
% m. nfft indicates the number of samples in FFT, when you do OFDM

% This is the Encoder/decoder trellis used by WiFi's turbo encoder
Trellis = poly2trellis(7,[133 171]);

% Every WiFi packet will start with this exact preamble
preamble = [1, 1, 1, 1,-1,-1, 1, 1,-1, 1,-1, 1, 1, 1, 1, 1, 1,-1,-1, 1, 1,-1, 1,-1, 1, 1, 1, 1, 1,-1,-1, 1, 1,-1, 1,-1, 1,-1,-1,-1,-1,-1, 1, 1,-1, -1, 1,-1, 1,-1, 1, 1, 1, 1,-1,-1, -1,-1,-1, 1, 1,-1, -1, 1];

% Every 64 bits are mixed up like below:
Interleave = reshape(reshape([1:nfft], 4, []).', [], 1);
%% Level 5
if (level == 5)
    len = length(txsignal);
end

%% Level 4 : OFDM
if (level >= 4)
    nsym = length(txsignal)/nfft;
    for ii = 1:nsym
        OFDM = txsignal((ii-1)*nfft+1:ii*nfft);
        txsignal((ii-1)*nfft+1:ii*nfft) = round(int32(real(fft(OFDM))));
    end                                                                     % 패킷별로 값을 푸리에변환 실시 이때 아주 작은 오차 발생해서 round를 사용해 제거
                                                                            
end
%% Level 3 : modulation - BPSK
if (level >= 3)
     for a = 1:length(preamble)                                             %preamble개수만큼
         txsignal(:,1) = [];    
     end
     
     txsignal = 0.5 * (txsignal + 1);
end

%% Level 2 : Interleaving - 자리 바꿈
if (level >= 2)
    codeword = zeros(1,length(txsignal)); 
    nsym = length(txsignal)/nfft;
    for ii = 1:nsym
        codeword(Interleave+(ii-1)*nfft)=txsignal((ii-1)*nfft+1:ii*nfft);
                                                                            % codeword내 64칸씩 이동하면서 주소 지정
    end
    txsignal = codeword;
end

%% Level 1 : turbo decoding
if (level >= 1)
    for a = 1:length(preamble)
        txsignal(:,1) = [];
    end
    
    txsignal = vitdec(txsignal, Trellis, 1, 'cont', 'hard');
    txsignal(:,1) = [];
    txsignal = [txsignal 0];
    txsignal = reshape(txsignal, 8,[]).';
    txsignal = join(string(txsignal));                                          % string의 텍스트를 결합시킴
    txsignal = bin2dec(txsignal).';                                             % 비트를 십진수로 변환
    
    msg = char(nonzeros(txsignal).');                                           % 십진수를 문자로 변환
end
