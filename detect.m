function bool = detect(mtx, x1, y1, x2, y2)
    % ========================== 参数说明 ==========================
    
    % 输入参数中，mtx为图像块的矩阵，类似这样的格式：
    % [ 1 2 3;
    %   0 2 1;
    %   3 0 0 ]
    % 相同的数字代表相同的图案，0代表此处没有块。
    % 可以用[m, n] = size(mtx)获取行数和列数。
    % (x1, y1)与（x2, y2）为需判断的两块的下标，即判断mtx(x1, y1)与mtx(x2, y2)
    % 是否可以消去。
    
    % 注意mtx矩阵与游戏区域的图像不是位置对应关系。下标(x1, y1)在连连看界面中
    % 代表的是以左下角为原点建立坐标系，x轴方向第x1个，y轴方向第y1个
    
    % 输出参数bool = 1表示可以消去，bool = 0表示不能消去。
    
    %% 在下面添加你的代码O(∩_∩)O
    
    [m, n] = size(mtx);
    
    bool = 0;
    
    %判断两块的索引是否相同，不同直接返回0
    if(mtx(x1,y1)~=mtx(x2,y2)||(x1==x2&&y1==y2))
        return;
    end
    
    %索引相同时
    %如果两块相邻，则返回1
    if(abs(x1-x2)+abs(y1-y2)==1)
        bool = 1;
        return;
    end
    
    %四周加一圈空白，值是0
    bigmtx=zeros(m+2,n+2);
    bigmtx(2:m+1,2:n+1)=mtx;
    x1_new=x1+1;
    y1_new=y1+1;
    x2_new=x2+1;
    y2_new=y2+1;
    
    bigmtx=mark(bigmtx,x1_new,y1_new,-1);
    [row,col]=find(bigmtx==-1);
    
    for i=1:length(row)
        bigmtx=mark(bigmtx,row(i),col(i),-1);
    end

    x=x2_new-1;
    while (x>0 && bigmtx(x,y2_new)==0)
        x=x-1;
    end
    if (x>0 && bigmtx(x,y2_new)==-1)
        bool=1;
        return;
    end
    
    x=x2_new+1;
    while (x<=(m+2) && bigmtx(x,y2_new)==0)
        x=x+1;
    end
    if (x<=(m+2) && bigmtx(x,y2_new)==-1)
        bool=1;
        return;
    end
    
    y=y2_new-1;
    while (y>0 && bigmtx(x2_new,y)==0)
        y=y-1;
    end
    if (y>0 && bigmtx(x2_new,y)==-1)
        bool=1;
        return;
    end

    y=y2_new+1;
    while (y<=n+2 && bigmtx(x2_new,y)==0)
        y=y+1;
    end
    if (y<=n+2 && bigmtx(x2_new,y)==-1)
        bool=1;
        return;
    end
   
end

