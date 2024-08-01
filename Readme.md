大创-医学图像融合

点击右上角绿色的Code里的Download Zip就可以下载

train_img文件夹：是10张CT图像和10张MRT图像，数字相同表示是对应的图像，这些都是灰度图像，目前我们就用这些数据集进行实验。

harris-sift算法文件夹：harris.m只有harris算法，sift.m只有sift算法，harris_sift.m是我将前面两个代码结合在一起跑通的代码。“结果”文件夹包含了用train_img中的10张CT图像测试的结果，目前不知如何评估这个算法的效果如何。

评估指标文件夹：一共有四个指标，即互信息MI、均方差MSE、结构相似性SSIM、视觉信息保真度VIF。使用时分别运行MI.py、test_MSE.m、test_SSIM.m、test_VIF.m。image文件夹里是一组测试图像。
请注意：1、MI.py为python代码，其余三个是matlab代码；2、使用时请更改输入图片的路径为自己图像的实际路径；
