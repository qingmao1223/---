from sklearn.metrics.cluster import  mutual_info_score
import numpy as np
from PIL import Image

path1='C:/Users/傅庆戊/Desktop/指标/image/PRO-011.jpg'  # 融合后的图像
path2='C:/Users/傅庆戊/Desktop/指标/image/MRI-011.jpg'  # 原始图像
# 确保路径正确
img1 = Image.open(path1)
img2 = Image.open(path2)

img_ref = np.array(img1, dtype=np.int32)   
img_sen = np.array(img2, dtype=np.int32)     
img_ref=img_ref .reshape(-1)
img_sen_roi=img_sen .reshape(-1)
MIValue=mutual_info_score(img_ref, img_sen_roi)
print('MI=',MIValue)
