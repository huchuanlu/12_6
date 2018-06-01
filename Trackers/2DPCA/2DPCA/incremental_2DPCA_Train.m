function newModel = incremental_2DPCA_Train(newTrainData, oldModel, forgetFactor, keepNum, modelFlag)

ff = forgetFactor;
[row col newNum] = size(newTrainData);

%%  newMean
newMean = zeros(row,col);
for i = 1:newNum
    newMean = newMean + newTrainData(:,:,i);
end
newMean = newMean/newNum;

if ~isfield(oldModel,'num')
   clear oldModel;
   oldModel.mean = zeros(row,col);
   oldModel.num  = 0;
   oldModel.covMR = zeros(col,col);
   oldModel.covML = zeros(row,row);
   oldModel.UR = [];
   oldModel.UL = [];
end

%%  model.num
newModel.num  = ff*oldModel.num + newNum;

%%  model.mean
newModel.mean = (ff*oldModel.num*oldModel.mean+newNum*newMean)/newModel.num;

%%  model.covML
newCovML = zeros(row,row);
for i = 1:newNum
    newCovML = newCovML + (newTrainData(:,:,i)-newMean)*(newTrainData(:,:,i)-newMean)';
end
newCovML = newCovML/newNum;
newModel.covML = (ff*oldModel.num*oldModel.covML+newNum*newCovML...
                  +ff*oldModel.num*newNum*(oldModel.mean-newMean)*(oldModel.mean-newMean)')/newModel.num;
              
%%  model.covMR
newCovMR = zeros(col,col);
for i = 1:newNum
    newCovMR = newCovMR + (newTrainData(:,:,i)-newMean)'*(newTrainData(:,:,i)-newMean);
end
newCovMR = newCovMR/newNum;
newModel.covMR = (ff*oldModel.num*oldModel.covMR+newNum*newCovMR... 
                  +ff*oldModel.num*newNum*(oldModel.mean-newMean)'*(oldModel.mean-newMean))./newModel.num;
              
if  modelFlag == 0 || modelFlag == 2              
    %%  model.UL
    [eigVector eigValue] = eig(newModel.covML);
    eigValue = diag(eigValue);
    [junk index] = sort(eigValue,'descend');
    eigVector = eigVector(:,index);
    newModel.UL = eigVector(:,1:keepNum(1));
    if  modelFlag == 2
        newModel.UR = eye(col);
    end
end

if  modelFlag == 0 || modelFlag == 1            
    %%  model.UR
    [eigVector eigValue] = eig(newModel.covMR);
    eigValue = diag(eigValue);
    [junk index] = sort(eigValue,'descend');
    eigVector = eigVector(:,index);
    newModel.UR = eigVector(:,1:keepNum(2));
    if  modelFlag == 1
        newModel.UL = eye(row);
    end
end


