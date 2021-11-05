%% ������ת����
%����
%SelCh ��ѡ��ĸ���
%D     �����еľ������
%���
%SelCh  ������ת��ĸ���
function SelCh=Reverse(SelCh)
[row,col]=size(SelCh);
for i=1:row
    ObjV(i,1)=PathLength(SelCh(i,:));  %����·������
end
SelCh1=SelCh;
for i=1:row
    r1=randsrc(1,1,[1:col]);
    r2=randsrc(1,1,[1:col]);
    mininverse=min([r1 r2]);
    maxinverse=max([r1 r2]);
    SelCh1(i,mininverse:maxinverse)=SelCh1(i,maxinverse:-1:mininverse);
end
for i=1:row
    ObjV1(i,1)=PathLength(SelCh1(i,:));  %����·������
end
index=ObjV1<ObjV;
SelCh(index,:)=SelCh1(index,:);