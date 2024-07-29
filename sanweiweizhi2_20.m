
clear all;
close all;
clc;

% 设置默认字体为Arial
% set(groot, 'defaultAxesFontName', 'Arial');
% set(groot, 'defaultTextFontName', 'Arial');

% 读取Excel文件
filename = 'weizhi.xlsx';
data = xlsread(filename);

% 提取时间和角速度数据
time = data(:, 3);
angular_velocity_x = data(:, 10);
angular_velocity_y = data(:, 12);
angular_velocity_z = data(:, 14);
angular_velocity_x(isinf(angular_velocity_x) | isnan(angular_velocity_x)) = 0;
angular_velocity_y(isinf(angular_velocity_y) | isnan(angular_velocity_y)) = 0;
angular_velocity_z(isinf(angular_velocity_z) | isnan(angular_velocity_z)) = 0;

% 设置高通滤波器参数
cutoff_frequency = 10; 
sampling_rate = 1 / (time(2) - time(1)); 

% 设计高通滤波器
[b, a] = butter(1, cutoff_frequency / (0.5 * sampling_rate), 'high');

% 对角速度数据进行高通滤波
filtered_angular_velocity_x = filtfilt(b, a, angular_velocity_x);
filtered_angular_velocity_y = filtfilt(b, a, angular_velocity_y);
filtered_angular_velocity_z = filtfilt(b, a, angular_velocity_z);

% 将角速度积分得到角度变化
angle_x = cumtrapz(time, filtered_angular_velocity_x);
angle_y = cumtrapz(time, filtered_angular_velocity_y);
angle_z = cumtrapz(time, filtered_angular_velocity_z);

% 将角度变化从弧度转换为度
angle_x_deg = rad2deg(angle_x);
angle_y_deg = rad2deg(angle_y);
angle_z_deg = rad2deg(angle_z);
% 绘制角度变化曲线
figure;
subplot(3, 1, 1);
plot(time, angle_x_deg);
xlabel('时间 (秒)');
ylabel('角度 (度)');
title('X轴角度变化');

subplot(3, 1, 2);
plot(time, angle_y_deg);
xlabel('时间 (秒)');
ylabel('角度 (度)');
title('Y轴角度变化');

subplot(3, 1, 3);
plot(time, angle_z_deg);
xlabel('时间 (秒)');
ylabel('角度 (度)');
title('Z轴角度变化');

sgtitle('角度变化');

% 显示图形
figure;
plot3(angle_x_deg, angle_y_deg, angle_z_deg);
xlabel('X轴角度 (度)');
ylabel('Y轴角度 (度)');
zlabel('Z轴角度 (度)');
title('三轴角度变化');
grid on;


% 创建三轴角度变化图
figure;
scatter3(angle_x_deg, angle_y_deg, angle_z_deg, 20, time, 'filled');
xlabel('X Angle (°)', 'FontSize', 20);
ylabel('Y Angle (°)', 'FontSize', 20);
zlabel('Z Angle (°)', 'FontSize', 20);
% % %title('三轴角度变化', 'FontSize', 20);
% % % colormap(jet);
% % % colorbar;
% % % grid on;

% % 设置图像的字号大小
% ax = gca;
% ax.FontSize = 20;

% 保存图片为PNG格式
saveas(gcf, '2-20ngle_change_plot.png');

% 将角度数据保存到Excel文件
angle_data = [time, angle_x_deg, angle_y_deg, angle_z_deg];
angle_headers = {'Time', 'X  Angle', 'Y  Angle', 'Z  Angle'};
xlswrite('angle_data.xlsx', angle_headers, 'Sheet1', 'A1');
xlswrite('angle_data.xlsx', angle_data, 'Sheet1', 'A2');

disp('数据已保存为Excel文件和PNG图片。');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 自定义颜色映射
custom_color_map = [
    0.4667 0.8745 0.7608; % 浅绿色
    0.9765 0.6353 0.6431; % 浅红色
    0.6118 0.5804 0.8784; % 浅紫色
    0.9765 0.9098 0.3647  % 浅黄色
];

% 创建三轴角度变化图
figure;
scatter3(angle_x_deg, angle_y_deg, angle_z_deg, 20, time, 'filled');
xlabel('X Axis Angle (degrees)', 'FontSize', 20);
ylabel('Y Axis Angle (degrees)', 'FontSize', 20);
zlabel('Z Axis Angle (degrees)', 'FontSize', 20);
title('三轴角度变化', 'FontSize', 20);
colormap(custom_color_map); % 使用自定义颜色映射
colorbar;
grid on;

% 设置图像的字号大小
ax = gca;
ax.FontSize = 20;

% 定义时间段并进行着色
color_map_indices = discretize(time, [30, 60, 90, 105, 140]); % 定义时间段
colored_points = custom_color_map(color_map_indices, :);
colormap(ax, 'manual');
scatter3(angle_x_deg, angle_y_deg, angle_z_deg, 20, colored_points, 'filled');
