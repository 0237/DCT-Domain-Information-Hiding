clear;
msgfid=fopen('隐藏信息.txt','r');%打开秘密文件,读入秘密信息
[msg,count]=fread(msgfid);
fclose(msgfid);
msg=str2bit(msg);
ends=[0,0,0,0,0,0,0,0];%结尾标记
msg=[msg,ends];
msg=msg';
[len col]=size(msg);

%读取载体图像进行DCT变换
io=imread('载体图片.bmp');
io=double(io)/255;
output=io;
i1=io(:,:,2);%取图像的第二层来隐藏
T=dctmtx(8);%对图像进行分块
DCTrgb=blkproc(i1,[8 8],'P1*x*P2',T,T');%对图像分块进行DCT变换
[row,col]=size(DCTrgb);
row=floor(row/8);
col=floor(col/8);

%顺序信息嵌入
count=count*8+8;%需要加上结尾信息长度
alpha=0.03;%Alpha系数用于控制差值大小
temp=0;
for i=1:count;
    if msg(i,1)==0
        if DCTrgb(i+2,i+1)<DCTrgb(i+3,i+6) %选择(3,2)和(4,7)这一对系数
            temp=DCTrgb(i+2,i+1);
            DCTrgb(i+2,i+1)=DCTrgb(i+3,i+6);
            DCTrgb(i+3,i+6)=temp;
        end
    else
        if  DCTrgb(i+2,i+1)>DCTrgb(i+3,i+6)
            temp=DCTrgb(i+2,i+1);
            DCTrgb(i+2,i+1)=DCTrgb(i+3,i+6);
            DCTrgb(i+3,i+6)=temp;
        end
    end
    if DCTrgb(i+2,i+1)<DCTrgb(i+3,i+6)
        DCTrgb(i+2,i+1)=DCTrgb(i+2,i+1)-alpha;%将原本小的系数调整更小，使得系数差别变大
    else
        DCTrgb(i+3,i+6)=DCTrgb(i+3,i+6)-alpha;
    end
end

%将信息写回并保存
wi=blkproc(DCTrgb,[8 8],'P1*x*P2',T',T);%对DCTrgb进行逆变换
output=io;
output(:,:,2)=wi;
imwrite(output,'载体图片_隐藏信息.bmp');

%显示结果对比
figure;
subplot(1,2,1);imshow('载体图片.bmp');title('原始图像');
subplot(1,2,2);imshow('载体图片_隐藏信息.bmp');title('嵌入信息图像');