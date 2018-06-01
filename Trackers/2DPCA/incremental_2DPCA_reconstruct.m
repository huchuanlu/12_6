function recData = incremental_2DPCA_reconstruct(features, model)

row = size(model.UR, 1);
col = size(model.UL, 1);
num = size(features, 3);
recData = zeros(row, col, num);
for i = 1:num
    recData(:,:,i) = model.UL * features(:,:,i) * model.UR';
end