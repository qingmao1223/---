clc; clear;

addpath('C:\Users\¸µÇìÎì\Desktop\Ö¸±ê\image')
% % % % % % % % % 
imag = double(imread('MRI-011.jpg')); imag1 = (imag(:,:,1)+imag(:,:,2) +imag(:,:,3))./3; 
imag= double(imread('PET-011.jpg'));  imag2 = (imag(:,:,1)+imag(:,:,2) +imag(:,:,3))./3; 


% % % 
% % % 
Input =  double(imread('PRO-011.jpg'));
input =( Input(:,:,1) + Input(:,:,2) +Input(:,:,3))./3;
vifvec1 = vifvec(imag1, input);
vifvec2 = vifvec(imag2, input);
q1 = (vifvec1+vifvec2)./2;

fprintf('VIF: %f\n', y1);



