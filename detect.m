function bool = detect(mtx, x1, y1, x2, y2)
    % ========================== ����˵�� ==========================
    
    % ��������У�mtxΪͼ���ľ������������ĸ�ʽ��
    % [ 1 2 3;
    %   0 2 1;
    %   3 0 0 ]
    % ��ͬ�����ִ�����ͬ��ͼ����0����˴�û�п顣
    % ������[m, n] = size(mtx)��ȡ������������
    % (x1, y1)�루x2, y2��Ϊ���жϵ�������±꣬���ж�mtx(x1, y1)��mtx(x2, y2)
    % �Ƿ������ȥ��
    
    % ע��mtx��������Ϸ�����ͼ����λ�ö�Ӧ��ϵ���±�(x1, y1)��������������
    % ������������½�Ϊԭ�㽨������ϵ��x�᷽���x1����y�᷽���y1��
    
    % �������bool = 1��ʾ������ȥ��bool = 0��ʾ������ȥ��
    
    %% �����������Ĵ���O(��_��)O
    
    [m, n] = size(mtx);
    
    bool = 0;
    
    %�ж�����������Ƿ���ͬ����ֱͬ�ӷ���0
    if(mtx(x1,y1)~=mtx(x2,y2)||(x1==x2&&y1==y2))
        return;
    end
    
    %������ͬʱ
    %����������ڣ��򷵻�1
    if(abs(x1-x2)+abs(y1-y2)==1)
        bool = 1;
        return;
    end
    
    %���ܼ�һȦ�հף�ֵ��0
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

