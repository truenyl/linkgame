clear all;
% graph=imread('graygroundtruth.jpg');
graph=imread('graycapture.jpg');
[r c]=size(graph);
N=2000;%��������

%% ��������
row=sum(graph)./r-sum(sum(graph)./r)./c;%ƽ��ֵ
n1=1:length(row);
omg1=[0:N]*pi/N;
L1=abs(row*exp(-j*n1.'*omg1));%����Ҷ�任����÷�����
pos1=find(max(L1)==L1);%������Ƶ��
row_T=round(2*N/pos1);%�������

col=sum(graph')./c-sum(sum(graph')./c)./r;
n2=1:length(col);
omg2=[0:N]*pi/N;
L2=abs(col*exp(-j*n2.'*omg2));
pos2=find(max(L2)==L2);
col_T=round(2*N/pos2);

dr(1)=find(max(abs(row(1:row_T)))==abs(row(1:row_T)));%�ҵ���߰ױߵ�λ�ã�Ҳ�ǵ�һ����Ŀ�ʼλ��
num1=0;
for j=dr(1)+row_T:row_T:length(row)
    num1=num1+1;%��¼����Ļ��ָ���
    dr(num1+1)=j;%��¼ÿ����Ŀ�ʼλ��
end

dc(1)=find(max(abs(col(1:col_T)))==abs(col(1:col_T)));%�ҵ��Ϸ��ױߵ�λ�ã�Ҳ�ǵ�һ����Ŀ�ʼλ��
num2=0;
for i=dc(1)+col_T:col_T:length(col)
    num2=num2+1;%��¼����Ļ��ָ���
    dc(num2+1)=i;%��¼ÿ����Ŀ�ʼλ��
end

%% ����ÿ��ͼ�񣬲����и�ͨ�˲�
store=graph;%�洢��ͨ�˲����ͼ��
for i=1:num2;
    for j=1:num1;
        subplot(num2,num1,(i-1)*num1+j);
        imshow(graph(dc(i):dc(i+1)-1,dr(j):dr(j+1)-1));%��ʾÿ��ͼ��
        piece=graph(dc(i):dc(i+1)-1,dr(j):dr(j+1)-1);
        pie_fil=Butterworth(piece);%��ÿ����и�ͨ�˲�
        store(dc(i):dc(i+1)-1,dr(j):dr(j+1)-1)=pie_fil;
    end
end

%% ������ͨ�˲����ͼ��
figure;
count=0;
for i=1:num2;
    for j=1:num1
        subplot(num2,num1,(i-1)*num1+j);
        imshow(store(dc(i):dc(i+1)-1,dr(j):dr(j+1)-1));
        count=count+1;
    end
end


%% ��һ�������ϵ��
total=num1*num2;%����������
Cor=zeros(total,total);%�洢���ϵ��
%�������еĿ飬���ͺ���Ŀ�������ϵ��
for i=1:total-1;
    %ͨ����ı�ŵõ���������ֵ
    y1=fix((i-1)/num1)+1;
    x1=i-(y1-1)*num1;
    graph1=store(dc(y1):dc(y1+1)-1,dr(x1):dr(x1+1)-1);
    %������ÿһ����������ϵ��
    for j=i+1:total;
        y2=fix((j-1)/num1)+1;
        x2=j-(y2-1)*num1;
        graph2=store(dc(y2):dc(y2+1)-1,dr(x2):dr(x2+1)-1);
        Cor(i,j)=max(max(normxcorr2(graph1,graph2)));%�������ϵ�����洢
    end
end

%% �ҳ������Ƶ�ʮ��ͼƬ
temp=Cor;
figure;
for k=1:10
    [i,j]=find(temp==max(max(temp)));%Ѱ�����ϵ������Ԫ��
    y1=fix((i-1)/num1)+1;
    x1=i-(y1-1)*num1;
    y2=fix((j-1)/num1)+1;
    x2=j-(y2-1)*num1;
    %�õ���Ӧ������ͼ��
    graph1=store(dc(y1):dc(y1+1)-1,dr(x1):dr(x1+1)-1);
    graph2=store(dc(y2):dc(y2+1)-1,dr(x2):dr(x2+1)-1);
    %��ʾͼ������ϵ��
    subplot(5,4,2*k-1);
    imshow(graph1);
    title(Cor(i,j));
    subplot(5,4,2*k);
    imshow(graph2);
    %������ͼ����������ͼ������ϵ������Ϊ0�������������
    for j1=1:total
        temp(i,j1)=0;
    end
    for i1=1:total
        temp(i1,j)=0;
    end
end

%% �����ǰʮ����ͬ��
%����������ͼƬ�Լ��۲죬ӳ��Ϊ����
lianliankan=[1,2,1,3,4,5,6,7,8,9,9,10;...
    11,3,10,12,10,13,8,14,9,15,16,8;...
    17,18,9,15,12,11,6,12,2,6,17,11;...
    12,18,8,12,2,8,6,3,6,11,12,17;...
    16,2,14,4,18,9,18,9,13,7,12,3;...
    17,8,19,17,1,19,17,7,4,13,7,8;...
    13,8,6,9,4,5,10,1,13,9,12,13];
save lianliankan;

%�ж�10�������ƵĲ�ͬͼ��
temp=Cor;
figure;
count=0;
while count<10
    [i,j]=find(temp==max(max(temp)));
    y1=fix((i-1)/num1)+1;
    x1=i-(y1-1)*num1;
    y2=fix((j-1)/num1)+1;
    x2=j-(y2-1)*num1;
    %����ֵ��ͬ�ſ�
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

%% ����
temp=Cor;
lianliankan_auto=zeros(7,12);
count=1;
for i=1:total-1
    y1=fix((i-1)/num1)+1;
    x1=i-(y1-1)*num1;
    if lianliankan_auto(y1,x1)==0
        lianliankan_auto(y1,x1)=count;
        for j=i+1:total
            if temp(i,j)>0.51168%��Ϊ��ͬ��������ϵ����0.51168
                y2=fix((j-1)/num1)+1;
                x2=j-(y2-1)*num1;
                lianliankan_auto(y2,x2)=count;%������Ϊ��ͬ������ֵ
            end
        end
        count=count+1;
    end
end
save lianliankan_auto;

%% ģ������
lianliankan_auto(7,8)=1;%���������ֵ
steps=omg(lianliankan_auto);%����omg.m�õ������Ĳ���
count=0;
figure;
for i=1:steps(1)
    %����step�еļ�¼�ҵ���Ӧ�Ŀ�
    x1=steps(4*count+2);
    y1=steps(4*count+3);
    x2=steps(4*count+4);
    y2=steps(4*count+5);
    count=count+1;
    %����Ӧ�Ŀ���Ϊ��ɫ
    graph(dc(x1):dc(x1+1),dr(y1):dr(y1+1))=255;
    graph(dc(x2):dc(x2+1),dr(y2):dr(y2+1))=255;
    subplot(1,1,1);
    imshow(graph);
    pause(2);%ÿ��ͣ�����룬���Կ��������Ĺ���
end
