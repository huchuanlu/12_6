function [X E] = tdpca_L1(data, UL, UR, srParam)

X = zeros(size(UL,2),size(UR,2));
E = zeros(size(data));

objValue = zeros(1,srParam.maxLoopNum);

for num = 1:srParam.maxLoopNum
    X = UL'*(data-E)*UR;
    Y = data-UL*X*UR';
    E = max(abs(Y)-srParam.lambda, 0).*sign(Y);
    %
    objValue(num) = (norm(Y-E,'fro')).^2 + srParam.lambda*sum(sum(abs(E)));
    if num == 1
       continue;
    end
    %
    if abs(objValue(num)-objValue(num-1)) < srParam.tol
       break;
    end
end
