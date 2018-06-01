function features = incremental_2DPCA_Features(data, model)

row = size(model.UR, 2);
col = size(model.UL, 2);
num = size(data, 3);
features = zeros(row, col, num);
for i = 1:num
    features(:,:,i) = model.UL' * data(:,:,i) * model.UR;
end
