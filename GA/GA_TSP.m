clear
clc
dbstop if all error
global D Startdistance PeopNumb ServiceTime Information  Appointment ActualTime
NIND=300  ;       %��Ⱥ��С 
MAXGEN=850;
Pc=0.8 ;         %�������
Pm=0.55;        %�������
GGAP=0.9;      %����(Generation gap)
ServiceTime=15;  %�˿��ϳ�����ʱ�� 15s

PeopNumb=load('�ϳ�����.txt');
pos=find(PeopNumb~=0);
PeopNumb=PeopNumb(pos);
Information=load('�û�վ��ԤԼʵ����Ϣ.txt');
X1=load('����վ������.txt');
Xstart=load('���յ�����.txt');
X=X1(pos,:);
Startdistance = calculate_Startdistance(Xstart,X);
D=calculateD(X);
N=size(D,1);    %(18*18)
[Appointment,ActualTime] = UpdateAppointment(PeopNumb,Information);

%% ��ʼ����Ⱥ
Chrom=InitPop(NIND,N);

%% �Ż�
gen=0;

for i=1:NIND
    [ObjV(i),~]=PathLength(Chrom(i,:));  %����·�߳���
end
preObjV=min(ObjV);
Maxadaptfuncvalue=zeros(1,MAXGEN);
while gen<MAXGEN
    %% ������Ӧ��
    gen
    for i=1:NIND
        [ObjV(i),~]=PathLength(Chrom(i,:));  %����·�߳���
    end
    preObjV=min(ObjV);
    Maxadaptfuncvalue(1,gen+1)=preObjV;
    FitnV=Fitness(ObjV);
    %% ѡ��
    SelCh=Select(Chrom,FitnV,GGAP);
    %% �������
    SelCh=Recombin(SelCh,Pc);
    %% ����
    SelCh=Mutate(SelCh,Pm);
    %% ��ת����
    SelCh=Reverse(SelCh);
    %% �ز����Ӵ�������Ⱥ
    Chrom=Reins(Chrom,SelCh,ObjV);
    %% ���µ�������
    gen=gen+1 ;
end
%% �������Ž��·��ͼ
for i=1:NIND
    [ObjV(i),~]=PathLength(Chrom(i,:));  %����·�߳���
end
[~,minInd]=min(ObjV);

%% ������Ž��·�ߺ��ܾ���
disp('���Ž�:')
% p=OutputPath(Chrom(minInd(1),:));
gb=Chrom(minInd,:);
[~,Matrix]=PathLength(gb);
disp('�����¼��Matrix��')
plot(Maxadaptfuncvalue);
xlabel('��������')
ylabel('��Ӧ�Ⱥ���ֵ')

%% ��ͼ
% Startdistance = calculate_Startdistance(Xstart,X);
% D=calculateD(X);
Num=max(Matrix(2,:));
gbest=zeros(size(gb));
for i=1:length(gb)
    gbest(i)=pos(gb(i));
end
XX=gbest+1;
way=[1];
DDDD=cell(Num,1);
for i=1:Num
    A=find(Matrix(2,:)==i);
    way=[way  XX 1];
    %     DDDD{i,1}=[0 gb(A) 0];
    DDDD{i,1}=[1 XX(A) 1];
end

%-------------------
X=[Xstart;X];
LocateAAA=[Xstart;X1];
DrawPath(way,X,LocateAAA)
% pos=pos+1;
for i=1:Num
    p=OutputPath(DDDD{i,1});
end
