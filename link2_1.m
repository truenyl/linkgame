clear all;
% graph=imread('graygroundtruth.jpg');
graph=imread('graycapture.jpg');
[r c]=size(graph);
N=2000;%抽样点数

%% 划分行列
row=sum(graph)./r-sum(sum(graph)./r)./c;%平均值
n1=1:length(row);
omg1=[0:N]*pi/N;
L1=abs(row*exp(-j*n1.'*omg1));%傅里叶变换以求得幅度谱
pos1=find(max(L1)==L1);%找最大的频率
row_T=round(2*N/pos1);%算出周期

col=sum(graph')./c-sum(sum(graph')./c)./r;
n2=1:length(col);
omg2=[0:N]*pi/N;
L2=abs(col*exp(-j*n2.'*omg2));
pos2=find(max(L2)==L2);
col_T=round(2*N/pos2);

dr(1)=find(max(abs(row(1:row_T)))==abs(row(1:row_T)));%找到左边白边的位置，也是第一个块的开始位置
num1=0;
for j=dr(1)+row_T:row_T:length(row)
    num1=num1+1;%记录横向的划分个数
    dr(num1+1)=j;%记录每个块的开始位置
end

dc(1)=find(max(abs(col(1:col_T)))==abs(col(1:col_T)));%找到上方白边的位置，也是第一个块的开始位置
num2=0;
for i=dc(1)+col_T:col_T:length(col)
    num2=num2+1;%记录纵向的划分个数
    dc(num2+1)=i;%记录每个块的开始位置
end

%% 画出每个图像，并进行高通滤波
store=graph;%存储高通滤波后的图像
for i=1:num2;
    for j=1:num1;
        subplot(num2,num1,(i-1)*num1+j);
        imshow(graph(dc(i):dc(i+1)-1,dr(j):dr(j+1)-1));%显示每块图像
        piece=graph(dc(i):dc(i+1)-1,dr(j):dr(j+1)-1);
        pie_fil=Butterworth(piece);%对每块进行高通滤波
        store(dc(i):dc(i+1)-1,dr(j):dr(j+1)-1)=pie_fil;
    end
end

%% 画出高通滤波后的图像
figure;
count=0;
for i=1:num2;
    for j=1:num1
        subplot(num2,num1,(i-1)*num1+j);
        imshow(store(dc(i):dc(i+1)-1,dr(j):dr(j+1)-1));
        count=count+1;
    end
end


%% 逐一计算相关系数
total=num1*num2;%计算块的总数
Cor=zeros(total,total);%存储相关系数
%遍历所有的块，并和后面的块计算相关系数
for i=1:total-1;
    %通过块的编号得到横纵坐标值
    y1=fix((i-1)/num1)+1;
    x1=i-(y1-1)*num1;
    graph1=store(dc(y1):dc(y1+1)-1,dr(x1):dr(x1+1)-1);
    %与后面的每一个块计算相关系数
    for j=i+1:total;
        y2=fix((j-1)/num1)+1;
        x2=j-(y2-1)*num1;
        graph2=store(dc(y2):dc(y2+1)-1,dr(x2):dr(x2+1)-1);
        Cor(i,j)=max(max(normxcorr2(graph1,graph2)));%计算相关系数并存储
    end
end

%% 找出最相似的十对图片
temp=Cor;
figure;
for k=1:10
    [i,j]=find(temp==max(max(temp)));%寻找相关系数最大的元素
    y1=fix((i-1)/num1)+1;
    x1=i-(y1-1)*num1;
    y2=fix((j-1)/num1)+1;
    x2=j-(y2-1)*num1;
    %得到对应的两个图像
    graph1=store(dc(y1):dc(y1+1)-1,dr(x1):dr(x1+1)-1);
    graph2=store(dc(y2):dc(y2+1)-1,dr(x2):dr(x2+1)-1);
    %显示图像和相关系数
    subplot(5,4,2*k-1);
    imshow(graph1);
    title(Cor(i,j));
    subplot(5,4,2*k);
    imshow(graph2);
    %将其他图像与这两个图像的相关系数都置为0，避免产生干扰
    for j1=1:total
        temp(i,j1)=0;
    end
    for i1=1:total
        temp(i1,j)=0;
    end
end

%% 最像的前十个不同的
%将连连看的图片自己观察，映射为矩阵
lianliankan=[1,2,1,3,4,5,6,7,8,9,9,10;...
    11,3,10,12,10,13,8,14,9,15,16,8;...
    17,18,9,15,12,11,6,12,2,6,17,11;...
    12,18,8,12,2,8,6,3,6,11,12,17;...
    16,2,14,4,18,9,18,9,13,7,12,3;...
    17,8,19,17,1,19,17,7,4,13,7,8;...
    13,8,6,9,4,5,10,1,13,9,12,13];
save lianliankan;

%判断10对最相似的不同图形
temp=Cor;
figure;
count=0;
while count<10
    [i,j]=find(temp==max(max(temp)));
    y1=fix((i-1)/num1)+1;
    x1=i-(y1-1)*num1;
    y2=fix((j-1)/num1)+1;
    x2=j-(y2-1)*num1;
    %索引值不同才可
    if lianliankan(y1,x1)~=lianliankan(y2,x2)
        count=count+1;
        graph1=store(dc(y1):dc(y1+1)-1,dr(x1):dr(x1+1)-1);
        graph2=store(dc(y2):dc(y2+1)-1,dr(x2):dr(x2+1)-1);
        subplot(5,4,2*count-1);
        imshow(graph1);
        title(Cor(i,j));
        subplot(5,4,2*count);
        imshow(graph2);
        for j1=1:total
            temp(i,j1)=0;
        end
        for i1=1:total
            temp(i1,j)=0;
        end
    else
        temp(i,j)=0;
    end
end

%% 聚类
temp=Cor;
lianliankan_auto=zeros(7,12);
count=1;
for i=1:total-1
    y1=fix((i-1)/num1)+1;
    x1=i-(y1-1)*num1;
    if lianliankan_auto(y1,x1)==0
        lianliankan_auto(y1,x1)=count;
        for j=i+1:total
            if temp(i,j)>0.51168%因为不同的最大相关系数是0.51168
                y2=fix((j-1)/num1)+1;
                x2=j-(y2-1)*num1;
                lianliankan_auto(y2,x2)=count;%相关则标为相同的索引值
            end
        end
        count=count+1;
    end
end
save lianliankan_auto;

%% 模拟消除
lianliankan_auto(7,8)=1;%修正错误的值
steps=omg(lianliankan_auto);%调用omg.m得到消除的步骤
count=0;
figure;
for i=1:steps(1)
    %按照step中的记录找到对应的块
    x1=steps(4*count+2);
    y1=steps(4*count+3);
    x2=steps(4*count+4);
    y2=steps(4*count+5);
    count=count+1;
    %将相应的块标记为白色
    graph(dc(x1):dc(x1+1),dr(y1):dr(y1+1))=255;
    graph(dc(x2):dc(x2+1),dr(y2):dr(y2+1))=255;
    subplot(1,1,1);
    imshow(graph);
    pause(2);%每次停顿两秒，可以看到消除的过程
end
