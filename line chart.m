jsonData = fileread('data.json');
data = jsondecode(jsonData);

time = data.time;
values = data.value;

numPoints = length(values);
x = 1:numPoints;

figure;
h = animatedline('Color', 'b', 'LineWidth', 2);
grid on;
xlabel('时间点索引');
ylabel('值');
title('实时动态数据更新');

for i = 1:numPoints
    addpoints(h, x(i), values(i));
    drawnow; 
    pause(0.1); 
end

futureX = numPoints+1:numPoints+10; 
futureY = values(end) + (1:10) * (values(end) - values(end-1)); 

hold on;
plot(futureX, futureY, 'r--', 'LineWidth', 2);
legend('实时数据', '预测结果');