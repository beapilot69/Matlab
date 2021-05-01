k = -9:1:9;
xk = -4./((k(n)*pi).^2);
for n = 1:length(k)
    if mod(k(n),2) == 1
        Xk(n) = xk;
    elseif k(n) == 0
        Xk(n) = 1;
    else
        Xk(n) = 0;
    end
    
    if k(n) < 0
        if Xk(n) < 0
            p(n) = pi;
        else
            p(n) = 0;
        end
    elseif k(n) > 0
        if Xk(n) < 0
            p(n) = -pi;
        else
            p(n) = 0;
        end
    else
        p(n) = 0;
    end

end

stem(k,p,'b-');

xlabel('w_o')
xticks(-9:2:9)
ylabel('phase(X_k)')
title('Triangular pulse-Phase Spectrum')