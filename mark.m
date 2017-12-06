function mtx_new=mark(mtx,x,y,flag)
    mtx_new = mtx;
    [m,n] = size(mtx);

    x1=x-1;
    while (x1>0 && mtx(x1,y)<=0)
        mtx_new(x1,y)=flag;
        x1 = x1-1;
    end

    x2=x+1;
    while (x2<=m && mtx(x2,y)<=0)
        mtx_new(x2,y)=flag;
        x2 = x2+1;
    end

    y1=y-1;
    while (y1>0 && mtx(x,y1)<=0)
        mtx_new(x,y1)=flag;
        y1=y1-1;
    end

    y2=y+1;
    while (y2<=n && mtx(x,y2)<=0)
        mtx_new(x,y2)=flag;
        y2=y2+1;
    end
    return;
end
