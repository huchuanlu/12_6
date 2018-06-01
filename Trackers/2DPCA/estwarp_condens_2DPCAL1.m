function param = estwarp_condens_2DPCAL1(frm, param, opt, model)

%%Parameters for Sparse Representation
srParam = opt.srParam;
%%Sampling Number
n = opt.numsample;
%%Data Dimension
sz = size(model.mean);
%%Affine Parameter Sampling
param.param = repmat(affparam2geom(param.est(:)), [1,n]);
randMatrix = randn(6,n);
param.param = param.param + randMatrix.*repmat(opt.affsig(:),[1,n]);
%%Extract or Warp Samples which are related to above affine parameters
wimgs = warpimg(frm, affparam2mat(param.param), sz);


X = zeros(opt.maxbasisL, opt.maxbasisR, n);
E = zeros(sz(1), sz(2), n);

diff = zeros(1,n);
if  ~isfield(model,'num') 
    for i = 1:n
        temp = wimgs(:,:,i) - model.mean;                           
        diff(i) = norm(temp,'fro');
    end
else
    for i = 1:n
        temp = wimgs(:,:,i) - model.mean;
        [XTemp ETemp] = tdpca_L1(temp, model.UL, model.UR, opt.srParam);
        X(:,:,i) = XTemp;
        E(:,:,i) = ETemp;
        temp = temp - model.UL*XTemp*model.UR' - ETemp;
        temp = temp .* (abs(ETemp)<srParam.L0);  
        diff(i) = norm(temp,'fro') + srParam.L0*sum(sum(abs(ETemp)>=srParam.L0));
    end
end

[maxprob,maxidx] = min(diff);                           
param.est = affparam2mat(param.param(:,maxidx));                    
param.wimg = wimgs(:,:,maxidx);                                     

if  isfield(model,'num')
    err = abs(E(:,:,maxidx));
    errRatio = sum(err(:)>srParam.L0)/length(err(:));
    
    %%Original Data
    wimg = wimgs(:,:,maxidx);
    
    if  (errRatio < opt.threshold.low)
        param.wimg = wimg;
        return;
    end
    
    if  (errRatio > opt.threshold.high)
        param.wimg = [];
        return;
    end
    
    if  ((errRatio>opt.threshold.low) && (errRatio<opt.threshold.high))
        param.wimg = (1-(err>srParam.L0)).*wimg + (err>srParam.L0).*model.mean;
        return;
    end  
else
    param.wimg = wimgs(:,:,maxidx);
end


