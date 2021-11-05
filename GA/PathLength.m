function [Fitness,Matrix]=PathLength(x)

global D Startdistance PeopNumb ServiceTime Information  Appointment ActualTime

% global D Startdistance PeopNumb ServiceTime Information 

% 优化目标：配送成本最小化
% 在针对上述问题的建模过程中，做出如下假设:
% （1）乘客提出的预约只要在服务区域内系统均会被响应，且乘客不会取消预约或更改出行时间、地点及出行人数。
% （2）提供服务的车辆车型统一，主要体现为载客人数相同（不允许超载），运行成本（油耗量等）大致相同。
% （3）车辆在服务区域内匀速运行，即不考虑实际道路状况及车辆自身状况对车速的影响。
% （4）车辆在乘客预约需求点停车条件良好，车辆在每个预约需求站点起停附加时分相同且保持稳定，每位乘客需要的上车时间相同且保持恒定。
% （5）乘客的预约需求点只能上客，所有乘客均到终点站下车。
% （6）车辆经过某需求点后，同一次运营途中不再经过该站点，即行驶路径不允许逆行。
% （7）乘客允许在含提交的预约时刻的时间窗内到达预约需求站点。
%-----=_=-----=_=-----=_=------=_=------=_=--------

% 设计细胞组。分别存储当代寻优结果
% 设计矩阵Matrix存储路程信息  
% 16行8列。第一行存储目的地顺序。第二行存储配送车辆。第三行存储目前上车人数，第四行车辆出发时间。第五行存储到达时间。第六行对应乘客预约时间。
% 第七行对应乘客到达时间。第八航存储存储出发时间。第九行存储车辆等待时间。第十行存储车外人等待时间。第十一行存储车辆已走路程。第十二行存储车辆已运动时间。
% 车辆编号依次为1 2 3……n

%% 信息矩阵Matrix
% Pn=sum(PeopNumb);
% for i=1:Pn
%     
% end
n=size(D,1);
v=0.42;%车速为25km/h
DemandMax=7;%车辆载人上限7
Matrix=zeros(12,n);
Matrix(1,:)=x;
% n=length(x);
for i=1:n
    Matrix(6,i)=Appointment(x(i));%第六行对应乘客预约时间。
    Matrix(7,i)=ActualTime(x(i));%第七行对应乘客到达时间
end
for i=1:n
    %第一个地点由第一辆车负责，然后开始给1号车分配后续任务
    if i==1
        Matrix(2,i)=1;%第二行存储对应目前配送车辆
        Matrix(3,i)=PeopNumb(x(i));%第三行存储目前上车人数
        Matrix(4,i)=Matrix(6,i)-Startdistance(x(i))/v;%第四行车辆出发时间
        Matrix(5,i)=Matrix(6,i);%第五行存储到达时间
        Matrix(8,i)=Matrix(5,i)+ max(0,Matrix(7,i)-Matrix(5,i))+ServiceTime;%第八行存储出发时间
        Matrix(9,i)=Matrix(8,i)- Matrix(5,i);%第九行存储车辆等待时间
        Matrix(10,i)= Matrix(8,i)-Matrix(7,i);%第十行存储车外人等待时间
        Matrix(11,i)=Startdistance(x(i));%第十一行存储车辆已走路程
        Matrix(12,i)=Startdistance(x(i))/v;%第十二行存储车辆已运动时间
    else
        if Matrix(3,i-1)+PeopNumb(x(i))<=DemandMax   %判断载重
            %满足，则依旧使用该车辆运送
            Matrix(2,i)=Matrix(2,i-1);%第二行存储对应目前配送车辆
            Matrix(3,i)=Matrix(3,i-1)+PeopNumb(x(i));%第三行存储目前上车人数
            Matrix(4,i)=Matrix(8,i-1);%第四行车辆出发时间
            Matrix(5,i)=Matrix(4,i)+D(x(i-1),x(i))/v;%第五行存储到达时间
            Matrix(8,i)=Matrix(5,i)+ max(0,Matrix(7,i)-Matrix(5,i))+ServiceTime;%第八行存储出发时间
            Matrix(9,i)=Matrix(8,i)- Matrix(5,i);%第九行存储车辆等待时间
            Matrix(10,i)= Matrix(8,i)-Matrix(7,i);%第十行存储车外人等待时间
            Matrix(11,i)=D(x(i-1),x(i));%第十一行存储车辆已走路程
            Matrix(12,i)=D(x(i-1),x(i))/v;%第十二行存储车辆已运动时间
            
        else
            %不满足，则安排新车
            Matrix(2,i)=Matrix(2,i-1)+1;%第二行存储对应目前配送车辆
            Matrix(3,i)=PeopNumb(x(i));%第三行存储目前上车人数
            Matrix(4,i)=Matrix(6,i)-Startdistance(x(i))/v;%第四行车辆出发时间
            Matrix(5,i)=Matrix(6,i);%第五行存储到达时间
            Matrix(8,i)=Matrix(5,i)+ max(0,Matrix(7,i)-Matrix(5,i))+ServiceTime;%第八行存储出发时间
            Matrix(9,i)=Matrix(8,i)- Matrix(5,i);%第九行存储车辆等待时间
            Matrix(10,i)= Matrix(8,i)-Matrix(7,i);%第十行存储车外人等待时间
            Matrix(11,i)=Startdistance(x(i));%第十一行存储车辆已走路程
            Matrix(12,i)=Startdistance(x(i))/v;%第十二行存储车辆已运动时间
        end
    end
end
%% 目标函数
% 本文所构建的需求响应式公交的静态调度模型目标函数是极小化综合运营成本，同时考虑乘客对于该次出行的满意程度，
% 主要体现为因为车辆延迟或提前到达需求站点以及乘客延迟到达需求站点而产生的乘客等待时间，上述时间损失可通过金钱
% 衡量转化为实际成本。
%% F1 车辆发车成本 113元/辆
C1=113;%113元/辆
M=max(Matrix(2,:));
F1=M*C1;

%% F2 车辆运行成本 R 6.7元/km
R=6.7;% 6.7元/km
distance=sum(Matrix(11,:))+Startdistance(x(end));
F2=distance*R;

%% F3 车内乘客等待成本  0.5元/min
waitcost1=0.5/60;  %0.5元/min    =0.5/60 元/s
F3=waitcost1*sum((Matrix(3,:).*Matrix(9,:)));

%% F4 车外乘客等待成本 0.75元/min
waitcost2=0.75/60;  %0.75元/min   =0.75/60    元/s

% F4=waitcost2*sum((Matrix(3,:).*Matrix(10,:)));
F4=0;
for i=1:n
    F4=F4+waitcost2*PeopNumb(x(i))*Matrix(10,i);
end

Fitness=F1+F2+F3+F4;

end


