clear
clc
dbstop if all error
global D Startdistance PeopNumb ServiceTime Information  Appointment ActualTime
NIND=300  ;       %种群大小 
MAXGEN=850;
Pc=0.8 ;         %交叉概率
Pm=0.55;        %变异概率
GGAP=0.9;      %代沟(Generation gap)
ServiceTime=15;  %乘客上车花费时间 15s

PeopNumb=load('上车人数.txt');
pos=find(PeopNumb~=0);
PeopNumb=PeopNumb(pos);
Information=load('用户站点预约实际信息.txt');
X1=load('需求站点坐标.txt');
Xstart=load('起终点坐标.txt');
X=X1(pos,:);
Startdistance = calculate_Startdistance(Xstart,X);
D=calculateD(X);
N=size(D,1);    %(18*18)
[Appointment,ActualTime] = UpdateAppointment(PeopNumb,Information);

%% 初始化种群
Chrom=InitPop(NIND,N);

%% 优化
gen=0;

for i=1:NIND
    [ObjV(i),~]=PathLength(Chrom(i,:));  %计算路线长度
end
preObjV=min(ObjV);
Maxadaptfuncvalue=zeros(1,MAXGEN);
while gen<MAXGEN
    %% 计算适应度
    gen
    for i=1:NIND
        [ObjV(i),~]=PathLength(Chrom(i,:));  %计算路线长度
    end
    preObjV=min(ObjV);
    Maxadaptfuncvalue(1,gen+1)=preObjV;
    FitnV=Fitness(ObjV);
    %% 选择
    SelCh=Select(Chrom,FitnV,GGAP);
    %% 交叉操作
    SelCh=Recombin(SelCh,Pc);
    %% 变异
    SelCh=Mutate(SelCh,Pm);
    %% 逆转操作
    SelCh=Reverse(SelCh);
    %% 重插入子代的新种群
    Chrom=Reins(Chrom,SelCh,ObjV);
    %% 更新迭代次数
    gen=gen+1 ;
end
%% 画出最优解的路线图
for i=1:NIND
    [ObjV(i),~]=PathLength(Chrom(i,:));  %计算路线长度
end
[~,minInd]=min(ObjV);

%% 输出最优解的路线和总距离
disp('最优解:')
% p=OutputPath(Chrom(minInd(1),:));
gb=Chrom(minInd,:);
[~,Matrix]=PathLength(gb);
disp('结果记录在Matrix中')
plot(Maxadaptfuncvalue);
xlabel('迭代次数')
ylabel('适应度函数值')

%% 绘图
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
