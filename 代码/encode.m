clear;
msgfid=fopen('������Ϣ.txt','r');%�������ļ�,����������Ϣ
[msg,count]=fread(msgfid);
fclose(msgfid);
msg=str2bit(msg);
ends=[0,0,0,0,0,0,0,0];%��β���
msg=[msg,ends];
msg=msg';
[len col]=size(msg);

%��ȡ����ͼ�����DCT�任
io=imread('����ͼƬ.bmp');
io=double(io)/255;
output=io;
i1=io(:,:,2);%ȡͼ��ĵڶ���������
T=dctmtx(8);%��ͼ����зֿ�
DCTrgb=blkproc(i1,[8 8],'P1*x*P2',T,T');%��ͼ��ֿ����DCT�任
[row,col]=size(DCTrgb);
row=floor(row/8);
col=floor(col/8);

%˳����ϢǶ��
count=count*8+8;%��Ҫ���Ͻ�β��Ϣ����
alpha=0.03;%Alphaϵ�����ڿ��Ʋ�ֵ��С
temp=0;
for i=1:count;
    if msg(i,1)==0
        if DCTrgb(i+2,i+1)<DCTrgb(i+3,i+6) %ѡ��(3,2)��(4,7)��һ��ϵ��
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
        DCTrgb(i+2,i+1)=DCTrgb(i+2,i+1)-alpha;%��ԭ��С��ϵ��������С��ʹ��ϵ�������
    else
        DCTrgb(i+3,i+6)=DCTrgb(i+3,i+6)-alpha;
    end
end

%����Ϣд�ز�����
wi=blkproc(DCTrgb,[8 8],'P1*x*P2',T',T);%��DCTrgb������任
output=io;
output(:,:,2)=wi;
imwrite(output,'����ͼƬ_������Ϣ.bmp');

%��ʾ����Ա�
figure;
subplot(1,2,1);imshow('����ͼƬ.bmp');title('ԭʼͼ��');
subplot(1,2,2);imshow('����ͼƬ_������Ϣ.bmp');title('Ƕ����Ϣͼ��');