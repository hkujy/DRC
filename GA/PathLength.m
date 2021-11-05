function [Fitness,Matrix]=PathLength(x)

global D Startdistance PeopNumb ServiceTime Information  Appointment ActualTime

% global D Startdistance PeopNumb ServiceTime Information 

% �Ż�Ŀ�꣺���ͳɱ���С��
% �������������Ľ�ģ�����У��������¼���:
% ��1���˿������ԤԼֻҪ�ڷ���������ϵͳ���ᱻ��Ӧ���ҳ˿Ͳ���ȡ��ԤԼ����ĳ���ʱ�䡢�ص㼰����������
% ��2���ṩ����ĳ�������ͳһ����Ҫ����Ϊ�ؿ�������ͬ���������أ������гɱ����ͺ����ȣ�������ͬ��
% ��3�������ڷ����������������У���������ʵ�ʵ�·״������������״���Գ��ٵ�Ӱ�졣
% ��4�������ڳ˿�ԤԼ�����ͣ���������ã�������ÿ��ԤԼ����վ����ͣ����ʱ����ͬ�ұ����ȶ���ÿλ�˿���Ҫ���ϳ�ʱ����ͬ�ұ��ֺ㶨��
% ��5���˿͵�ԤԼ�����ֻ���Ͽͣ����г˿;����յ�վ�³���
% ��6����������ĳ������ͬһ����Ӫ;�в��پ�����վ�㣬����ʻ·�����������С�
% ��7���˿������ں��ύ��ԤԼʱ�̵�ʱ�䴰�ڵ���ԤԼ����վ�㡣
%-----=_=-----=_=-----=_=------=_=------=_=--------

% ���ϸ���顣�ֱ�洢����Ѱ�Ž��
% ��ƾ���Matrix�洢·����Ϣ  
% 16��8�С���һ�д洢Ŀ�ĵ�˳�򡣵ڶ��д洢���ͳ����������д洢Ŀǰ�ϳ������������г�������ʱ�䡣�����д洢����ʱ�䡣�����ж�Ӧ�˿�ԤԼʱ�䡣
% �����ж�Ӧ�˿͵���ʱ�䡣�ڰ˺��洢�洢����ʱ�䡣�ھ��д洢�����ȴ�ʱ�䡣��ʮ�д洢�����˵ȴ�ʱ�䡣��ʮһ�д洢��������·�̡���ʮ���д洢�������˶�ʱ�䡣
% �����������Ϊ1 2 3����n

%% ��Ϣ����Matrix
% Pn=sum(PeopNumb);
% for i=1:Pn
%     
% end
n=size(D,1);
v=0.42;%����Ϊ25km/h
DemandMax=7;%������������7
Matrix=zeros(12,n);
Matrix(1,:)=x;
% n=length(x);
for i=1:n
    Matrix(6,i)=Appointment(x(i));%�����ж�Ӧ�˿�ԤԼʱ�䡣
    Matrix(7,i)=ActualTime(x(i));%�����ж�Ӧ�˿͵���ʱ��
end
for i=1:n
    %��һ���ص��ɵ�һ��������Ȼ��ʼ��1�ų������������
    if i==1
        Matrix(2,i)=1;%�ڶ��д洢��ӦĿǰ���ͳ���
        Matrix(3,i)=PeopNumb(x(i));%�����д洢Ŀǰ�ϳ�����
        Matrix(4,i)=Matrix(6,i)-Startdistance(x(i))/v;%�����г�������ʱ��
        Matrix(5,i)=Matrix(6,i);%�����д洢����ʱ��
        Matrix(8,i)=Matrix(5,i)+ max(0,Matrix(7,i)-Matrix(5,i))+ServiceTime;%�ڰ��д洢����ʱ��
        Matrix(9,i)=Matrix(8,i)- Matrix(5,i);%�ھ��д洢�����ȴ�ʱ��
        Matrix(10,i)= Matrix(8,i)-Matrix(7,i);%��ʮ�д洢�����˵ȴ�ʱ��
        Matrix(11,i)=Startdistance(x(i));%��ʮһ�д洢��������·��
        Matrix(12,i)=Startdistance(x(i))/v;%��ʮ���д洢�������˶�ʱ��
    else
        if Matrix(3,i-1)+PeopNumb(x(i))<=DemandMax   %�ж�����
            %���㣬������ʹ�øó�������
            Matrix(2,i)=Matrix(2,i-1);%�ڶ��д洢��ӦĿǰ���ͳ���
            Matrix(3,i)=Matrix(3,i-1)+PeopNumb(x(i));%�����д洢Ŀǰ�ϳ�����
            Matrix(4,i)=Matrix(8,i-1);%�����г�������ʱ��
            Matrix(5,i)=Matrix(4,i)+D(x(i-1),x(i))/v;%�����д洢����ʱ��
            Matrix(8,i)=Matrix(5,i)+ max(0,Matrix(7,i)-Matrix(5,i))+ServiceTime;%�ڰ��д洢����ʱ��
            Matrix(9,i)=Matrix(8,i)- Matrix(5,i);%�ھ��д洢�����ȴ�ʱ��
            Matrix(10,i)= Matrix(8,i)-Matrix(7,i);%��ʮ�д洢�����˵ȴ�ʱ��
            Matrix(11,i)=D(x(i-1),x(i));%��ʮһ�д洢��������·��
            Matrix(12,i)=D(x(i-1),x(i))/v;%��ʮ���д洢�������˶�ʱ��
            
        else
            %�����㣬�����³�
            Matrix(2,i)=Matrix(2,i-1)+1;%�ڶ��д洢��ӦĿǰ���ͳ���
            Matrix(3,i)=PeopNumb(x(i));%�����д洢Ŀǰ�ϳ�����
            Matrix(4,i)=Matrix(6,i)-Startdistance(x(i))/v;%�����г�������ʱ��
            Matrix(5,i)=Matrix(6,i);%�����д洢����ʱ��
            Matrix(8,i)=Matrix(5,i)+ max(0,Matrix(7,i)-Matrix(5,i))+ServiceTime;%�ڰ��д洢����ʱ��
            Matrix(9,i)=Matrix(8,i)- Matrix(5,i);%�ھ��д洢�����ȴ�ʱ��
            Matrix(10,i)= Matrix(8,i)-Matrix(7,i);%��ʮ�д洢�����˵ȴ�ʱ��
            Matrix(11,i)=Startdistance(x(i));%��ʮһ�д洢��������·��
            Matrix(12,i)=Startdistance(x(i))/v;%��ʮ���д洢�������˶�ʱ��
        end
    end
end
%% Ŀ�꺯��
% ������������������Ӧʽ�����ľ�̬����ģ��Ŀ�꺯���Ǽ�С���ۺ���Ӫ�ɱ���ͬʱ���ǳ˿Ͷ��ڸôγ��е�����̶ȣ�
% ��Ҫ����Ϊ��Ϊ�����ӳٻ���ǰ��������վ���Լ��˿��ӳٵ�������վ��������ĳ˿͵ȴ�ʱ�䣬����ʱ����ʧ��ͨ����Ǯ
% ����ת��Ϊʵ�ʳɱ���
%% F1 ���������ɱ� 113Ԫ/��
C1=113;%113Ԫ/��
M=max(Matrix(2,:));
F1=M*C1;

%% F2 �������гɱ� R 6.7Ԫ/km
R=6.7;% 6.7Ԫ/km
distance=sum(Matrix(11,:))+Startdistance(x(end));
F2=distance*R;

%% F3 ���ڳ˿͵ȴ��ɱ�  0.5Ԫ/min
waitcost1=0.5/60;  %0.5Ԫ/min    =0.5/60 Ԫ/s
F3=waitcost1*sum((Matrix(3,:).*Matrix(9,:)));

%% F4 ����˿͵ȴ��ɱ� 0.75Ԫ/min
waitcost2=0.75/60;  %0.75Ԫ/min   =0.75/60    Ԫ/s

% F4=waitcost2*sum((Matrix(3,:).*Matrix(10,:)));
F4=0;
for i=1:n
    F4=F4+waitcost2*PeopNumb(x(i))*Matrix(10,i);
end

Fitness=F1+F2+F3+F4;

end


