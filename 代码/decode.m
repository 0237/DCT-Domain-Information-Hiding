clear;
wi=imread('载体图片_隐藏信息.bmp');%读取携密图像
wi=double(wi)/255;
wi=wi(:,:,2);%取图像的第二层来提取
T=dctmtx(8);%对图像进行分块
DCTcheck=blkproc(wi,[8 8],'P1*x*P2',T,T');%对图像分块进行DCT变换

%提取信息
for i=1:256 %256为隐藏的秘密信息的比特数
     if  DCTcheck(i+2,i+1)<=DCTcheck(i+3,i+6)        
         message(i)=1;
     else
         message(i)=0;
     end
end

%对信息进行处理，过滤掉其他信息
ends=[0,0,0,0,0,0,0,0];%结尾标记
l=0;
for i=1:8:256 %因为每个字符编码为8位，所以间隔为8
     if  message(i:i+7)==ends
         l=i-1;
     end
end
message0=message(1:l);

%将提取信息写入文件保存
out=bit2str(message0');
fid=fopen('提取信息.txt', 'wt');
fwrite(fid, out);
fclose(fid);