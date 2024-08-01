clear;

image1 = imread('C:\Users\93785\Desktop\指标\image\MRI-011.jpg');
image2 = imread('C:\Users\93785\Desktop\指标\image\PET-011.jpg');
I=imread('C:\Users\93785\Desktop\指标\image\PRO-011.jpg');
% 璁＄畻 MSE
mse1 = MSE(I, image1);
mse2 = MSE(I, image2);

% 显示结果
fprintf('Image I 与 Image1 的 MSE: %f\n', mse1);
fprintf('Image I 与 Image2 的 MSE: %f\n', mse2);
