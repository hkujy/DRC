function [Fitness,Matrix]=PathLength(x)

global D Startdistance PeopNumb ServiceTime Information  Appointment ActualTime

% global D Startdistance PeopNumb ServiceTime Information 

% ????????????
% ????????????????????:
% ?1?????????????????????????????????????????????????
% ?2???????????????????????????????????????????????
% ?3??????????????????????????????????????
% ?4??????????????????????????????????????????????????????????????
% ?5??????????????????????????
% ?6?????????????????????????????????????
% ?7????????????????????????????
%-----=_=-----=_=-----=_=------=_=------=_=--------

% ????????????????
% ????Matrix??????  
% 16?8???????????????????????????????????????????????????????????????????
% ????????????????????????????????????????????????????????????????????????????
% ???????1 2 3??n

%% ????Matrix
% Pn=sum(PeopNumb);
% for i=1:Pn
%     
% end
n=size(D,1);
v=0.42;%???25km/h
DemandMax=7;%??????7
Matrix=zeros(12,n);
Matrix(1,:)=x;
% n=length(x);
for i=1:n
    Matrix(6,i)=Appointment(x(i));%????????????
    Matrix(7,i)=ActualTime(x(i));%???????????
end
for i=1:n
    %??????????????????1????????
    if i==1
        Matrix(2,i)=1;%?????????????
        Matrix(3,i)=PeopNumb(x(i));%???????????
        Matrix(4,i)=Matrix(6,i)-Startdistance(x(i))/v;%?????????
        Matrix(5,i)=Matrix(6,i);%?????????
        Matrix(8,i)=Matrix(5,i)+ max(0,Matrix(7,i)-Matrix(5,i))+ServiceTime;%?????????
        Matrix(9,i)=Matrix(8,i)- Matrix(5,i);%???????????
        Matrix(10,i)= Matrix(8,i)-Matrix(7,i);%????????????
        Matrix(11,i)=Startdistance(x(i));%????????????
        Matrix(12,i)=Startdistance(x(i))/v;%?????????????
    else
        if Matrix(3,i-1)+PeopNumb(x(i))<=DemandMax   %????
            %?????????????
            Matrix(2,i)=Matrix(2,i-1);%?????????????
            Matrix(3,i)=Matrix(3,i-1)+PeopNumb(x(i));%???????????
            Matrix(4,i)=Matrix(8,i-1);%?????????
            Matrix(5,i)=Matrix(4,i)+D(x(i-1),x(i))/v;%?????????
            Matrix(8,i)=Matrix(5,i)+ max(0,Matrix(7,i)-Matrix(5,i))+ServiceTime;%?????????
            Matrix(9,i)=Matrix(8,i)- Matrix(5,i);%???????????
            Matrix(10,i)= Matrix(8,i)-Matrix(7,i);%????????????
            Matrix(11,i)=D(x(i-1),x(i));%????????????
            Matrix(12,i)=D(x(i-1),x(i))/v;%?????????????
            
        else
            %?????????
            Matrix(2,i)=Matrix(2,i-1)+1;%?????????????
            Matrix(3,i)=PeopNumb(x(i));%???????????
            Matrix(4,i)=Matrix(6,i)-Startdistance(x(i))/v;%?????????
            Matrix(5,i)=Matrix(6,i);%?????????
            Matrix(8,i)=Matrix(5,i)+ max(0,Matrix(7,i)-Matrix(5,i))+ServiceTime;%?????????
            Matrix(9,i)=Matrix(8,i)- Matrix(5,i);%???????????
            Matrix(10,i)= Matrix(8,i)-Matrix(7,i);%????????????
            Matrix(11,i)=Startdistance(x(i));%????????????
            Matrix(12,i)=Startdistance(x(i))/v;%?????????????
        end
    end
end
%% ????
% ?????????????????????????????????????????????????????
% ??????????????????????????????????????????????????????
% ??????????
%% F1 ?????? 113?/?
C1=113;%113?/?
M=max(Matrix(2,:));
F1=M*C1;

%% F2 ?????? R 6.7?/km
R=6.7;% 6.7?/km
distance=sum(Matrix(11,:))+Startdistance(x(end));
F2=distance*R;

%% F3 ????????  0.5?/min
waitcost1=0.5/60;  %0.5?/min    =0.5/60 ?/s
F3=waitcost1*sum((Matrix(3,:).*Matrix(9,:)));

%% F4 ???????? 0.75?/min
waitcost2=0.75/60;  %0.75?/min   =0.75/60    ?/s

% F4=waitcost2*sum((Matrix(3,:).*Matrix(10,:)));
F4=0;
for i=1:n
    F4=F4+waitcost2*PeopNumb(x(i))*Matrix(10,i);
end

Fitness=F1+F2+F3+F4;

end


