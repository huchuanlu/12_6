
clear all;
clc;
addpath(genpath('./Trackers'));  

%%choose title to run the codes:
title = 'Occlusion1';
% title = 'Occlusion2';
% title = 'DavidIndoor';
% title = 'Car11';
% title = 'Jumping';
% title = 'DavidOutdoor';
% title = 'Caviar1';
% title = 'Caviar2';
trackparam;
%%  p = [px, py, sx, sy, theta];  
param0 = [p(1), p(2), p(3)/32, p(5), p(4)/p(3), 0];      
param0 = affparam2mat(param0);

% initialize variables
rand('state',0);  randn('state',0); 
%
temp = importdata([dataPath 'datainfo.txt']);
LoopNum = temp(3);
frame = imread([dataPath '1.png']);
%
if  size(frame,3) == 3
    framegray = double(rgb2gray(frame))/256;
else
    framegray = double(frame)/256;
end

%%*************************************************************************
if ~exist('opt','var')        opt = [];  end
if ~isfield(opt,'tmplsize')   opt.tmplsize = [32,32];  end                  
if ~isfield(opt,'numsample')  opt.numsample = 400;  end                     
if ~isfield(opt,'affsig')     opt.affsig = [4,4,.02,.02,.005,.001];  end   
if ~isfield(opt,'condenssig') opt.condenssig = 0.01;  end                   
if ~isfield(opt,'maxbasis')   opt.maxbasisL = 4;  end                       
if ~isfield(opt,'maxbasis')   opt.maxbasisR = 4;  end                       
if ~isfield(opt,'batchsize')  opt.batchsize = 5;  end                       
if ~isfield(opt,'ff')         opt.ff = 1.0;  end                          
if ~isfield(opt,'minopt')
    opt.minopt = optimset; opt.minopt.MaxIter = 25; opt.minopt.Display='off';
end
%The Parameters for Sloving 2DPCA and L1 Regularization Problem 
if ~isfield(opt,'srParam') 
    opt.srParam = [];
    opt.srParam.lambda = 0.05;
    opt.srParam.L0     = opt.srParam.lambda;
    opt.srParam.maxLoopNum = 20;
    opt.srParam.tol = 0.001;
end
%The Threshold for Model Update
if  ~isfield(opt,'threshold') 
    opt.threshold.high = 0.6;
    opt.threshold.low  = 0.1;
end
%%*************************************************************************
  
model.mean = warpimg(framegray, param0, opt.tmplsize);      
sz = size(model.mean);  
N = sz(1)*sz(2);                                           
param = [];
param.est = param0;                                        
%
if  size(frame,3) ~= 3
    frame = cat(3, [], framegray, framegray, framegray);
end
drawopt = drawtrackresult([], 0, frame, model, param);
disp('resize the window as necessary, then press any key..'); pause;

wimgs = [];
newTrainData = [];
result = [];
for f = 1:LoopNum
    %
    frame = imread([dataPath int2str(f) '.png']);
    if  size(frame,3) == 3
        framegray = double(rgb2gray(frame))/256;
    else
        framegray = double(frame)/256;
    end
    %
    if  (param.est(1)<0 || param.est(2)<0)
        param.est(1) = max(param.est(1),0);
        param.est(2) = max(param.est(2),0);      
    else
        param = estwarp_condens_2DPCAL1(framegray, param, opt, model);   
        result = [ result; param.est' ];
        %
        if  ~isempty(param.wimg)
            newTrainData = cat(3, newTrainData, param.wimg);
        end
        if  size(newTrainData,3) == opt.batchsize
            model = incremental_2DPCA_Train(newTrainData, model, opt.ff, ...
                                            [ opt.maxbasisL opt.maxbasisR ], 0);
            newTrainData = [];
        end
    end
    %Display Tracking Results:
    if  size(frame,3) ~= 3
        frame = cat(3, [], framegray, framegray, framegray);
    end
    drawopt = drawtrackresult(drawopt, f, frame, model, param);   
end