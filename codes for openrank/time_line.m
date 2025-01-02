jsonData = fileread('data.json');
data = jsondecode(jsonData);

keys = fieldnames(data); 
values = struct2cell(data); 

numericValues = NaN(size(values)); 

for i = 1:length(values)
    if isnumeric(values{i}) 
        numericValues(i) = values{i}; 
    else
        numericValues(i) = NaN; 
    end
end

formattedData.time = keys; 
formattedData.value = numericValues; 

formattedJson = jsonencode(formattedData);
fid = fopen('formatted_data.json', 'w');
fprintf(fid, '%s', formattedJson);
fclose(fid);

disp('数据已成功格式化并保存为 formatted_data.json');