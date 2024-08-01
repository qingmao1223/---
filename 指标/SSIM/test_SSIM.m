
clc; clear;
addpath('C:\Users\93785\Desktop\指标\image');

% % % % % % % % % % % % 
K = [0.01 0.03]; window = fspecial('gaussian', 11, 1.5);L=5;
% % % % % % % % % % % % % 
img=imread('MRI-011.jpg');IM = im2double(img); IM = imresize(IM, [256,256]); IM1 = (IM(:,:,1) + IM(:,:,2) +IM(:,:,3))./3;
img=imread('PET-011.jpg');IM = im2double(img); IM = imresize(IM, [256,256]); IM2 =(IM(:,:,1) + IM(:,:,2) +IM(:,:,3))./3;
% % % % % 
 img=imread('PRO-011.jpg');F1 = im2double(img);F1 = imresize(F1, [256,256]); F =(F1(:,:,1) + F1(:,:,2) +F1(:,:,3))./3;
 mssim_1f=ssim_index( IM1, F, K, window, L);
 mssim_2f=ssim_index(IM2, F, K, window, L);
 y1 = 0.5*(mssim_1f + mssim_2f);

% 显示SSIM结果
fprintf('SSIM: %f\n', y1);





