clear;
wi=imread('����ͼƬ_������Ϣ.bmp');%��ȡЯ��ͼ��
wi=double(wi)/255;
wi=wi(:,:,2);%ȡͼ��ĵڶ�������ȡ
T=dctmtx(8);%��ͼ����зֿ�
DCTcheck=blkproc(wi,[8 8],'P1*x*P2',T,T');%��ͼ��ֿ����DCT�任

%��ȡ��Ϣ
for i=1:256 %256Ϊ���ص�������Ϣ�ı�����
     if  DCTcheck(i+2,i+1)<=DCTcheck(i+3,i+6)        
         message(i)=1;
     else
         message(i)=0;
     end
end

%����Ϣ���д������˵�������Ϣ
ends=[0,0,0,0,0,0,0,0];%��β���
l=0;
for i=1:8:256 %��Ϊÿ���ַ�����Ϊ8λ�����Լ��Ϊ8
     if  message(i:i+7)==ends
         l=i-1;
     end
end
message0=message(1:l);

%����ȡ��Ϣд���ļ�����
out=bit2str(message0');
fid=fopen('��ȡ��Ϣ.txt', 'wt');
fwrite(fid, out);
fclose(fid);