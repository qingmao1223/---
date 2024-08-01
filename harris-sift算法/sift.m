% 特征描述符的生成
sigama0 = 1.6;
count = 0;
description = []; % 用来存储描述子
index = 0; % 用来索引描述子
description_1 = cell(size(location)); % 用来存储索引，通过索引找到description中对应的描述子
d = []; % 存储邻域内每个像素梯度方向
l = []; % 存储邻域内每个像素梯度幅值
f = zeros(1, 8); % 用来存放4*4邻域内8维描述子
description_2 = []; % 用来存放128维描述子
aaa = [];

for i = 1:O+1
    [M, N] = size(gauss_pyr_img{i}{1});
    for j = 2:S+1
        description_1{i}{j-1} = zeros(M, N);
        count = count + 1;
        sigama = sigama0 * k^count;
        % r=floor((3*sigama*sqrt(2)*5+1)/2);%确定描述子所需要的图像区域半径
        r = 8; % 设描述子所需要的图像区域半径
        
        for ii = r+2:M-r-1
            for jj = r+2:N-r-1
                if length{i}{j-1}(ii, jj) ~= 0
                    theta_1 = direction{i}{j-1}(ii, jj); % 该邻域的主方向
                    index = index + 1;
                    description_2 = [];
                    d = [];
                    l = [];
                    
                    for iii = [ii-r:1:ii-1, ii+1:1:ii+r]
                        for jjj = [jj-r:1:jj-1, jj+1:1:jj+r]
                            m = sqrt((gauss_pyr_img{i}{j}(iii+1, jjj) - gauss_pyr_img{i}{j}(iii-1, jjj))^2 + (gauss_pyr_img{i}{j}(iii, jjj+1) - gauss_pyr_img{i}{j}(iii, jjj-1))^2);
                            theta = atan((gauss_pyr_img{i}{j}(iii, jjj+1) - gauss_pyr_img{i}{j}(iii, jjj-1)) / (gauss_pyr_img{i}{j}(iii+1, jjj) - gauss_pyr_img{i}{j}(iii-1, jjj)));
                            theta = theta / pi * 180; % 将弧度化为角度
                            
                            if theta < 0
                                theta = theta + 360;
                            end
                            
                            w = exp(-(iii^2 + jjj^2) / (2 * (1.5 * sigama)^2)); % 生成邻域各像元的高斯权重
                            
                            if isnan(theta)
                                if gauss_pyr_img{i}{j}(iii, jjj+1) - gauss_pyr_img{i}{j}(iii, jjj-1) >= 0
                                    theta = 90;
                                else
                                    theta = 270;
                                end
                            end
                            
                            theta = theta + 360 - theta_1; % 逆时针旋转至主方向
                            theta = mod(theta, 360); % 取余
                            d = [d, theta];
                            l = [l, m * w];
                        end
                    end
                    
                    d = reshape(d, 16, 16);
                    l = reshape(l, 16, 16); % 将一维数组变为二维矩阵
                    
                    for r1 = 1:4
                        for c1 = 1:4
                            for iiii = 1+(r1-1)*4 : 4*r1
                                for jjjj = 1+(c1-1)*4 : 4*c1
                                    t = floor(d(iiii, jjjj) / 45 + 1); % 方向
                                    f(t) = f(t) + l(iiii, jjjj);
                                end
                            end
                            description_2 = [description_2, f(:)]; % 得到一个128维的描述子
                        end
                    end
                    
                    description_2 = description_2 ./ sqrt(sum(description_2(:))); % 归一化处理
                    description = [description; description_2(:)];
                    description_1{i}{j-1}(ii, jj) = index;
                    aaa = [aaa; ii, jj];
                end
            end
        end
    end
end
