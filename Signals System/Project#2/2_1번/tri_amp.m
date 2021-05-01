k = -9:1:9;

xk= -4./(k.^2)./(pi.^2);

for n = 1:length(k)
    if mod(k(n),2) == 1
        xk(n) = -4./(k(n).^2)./(pi.^2);
       
    elseif k(n) == 0
        xk(n) = 1;
        
    else
        xk(n) = 0;
    end
end

stem(k, abs(xk), 'b-')

xlabel('w_o')
xticks(-9:1:9)
ylabel('|X_k|')

title('Triangular pulse-Amplitude Spectrum')