function [ J5 ] = Butterworth( graph )
%二阶巴特沃夫高通滤波器
%   此处参考了百度文库
f=double(graph);
g=fft2(f);
g=fftshift(g);
[M,N]=size(g);
nn=2;% 二阶巴特沃斯
d0=5;
m=fix(M/2);
n=fix(N/2);
for x=1:M
    for y=1:N
        d=sqrt((x-m)^2+(y-n)^2);
        if (d==0)
           h2=0;
        else
           h2=1/(1+0.414*(d0/d)^(2*nn));% 高通滤波传递函数
        end
        result2(x,y)=h2*g(x,y);
     end
end
result3=ifftshift(result2);
J4=ifft2(result3);
J5=uint8(real(J4));%补足直流分量便于显示

end