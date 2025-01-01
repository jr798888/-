jsonData = fileread('data.json');
data = jsondecode(jsonData);

time = data.time;
values = data.value;

months = cellfun(@(x) str2double(x(6:7)), time);  
years = cellfun(@(x) str2double(x(1:4)), time);  

uniqueYears = unique(years);
uniqueMonths = unique(months);

heatmapData = nan(length(uniqueYears), length(uniqueMonths));

for i = 1:length(time)
    yearIdx = find(uniqueYears == years(i));
    monthIdx = find(uniqueMonths == months(i));
    heatmapData(yearIdx, monthIdx) = values(i);
end

figure;
heatmap(uniqueMonths, uniqueYears, heatmapData, 'Colormap', parula);
xlabel('月份');
ylabel('年份');
title('热力图');
colorbar;