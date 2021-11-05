function [Appointment,ActualTime] = UpdateAppointment(PeopNumb,Information)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
n=length(PeopNumb);
Appointment=zeros(n,1);
ActualTime=zeros(n,1);
for i=1:n
    A=Information(:,1)==i;
    Time=Information(A,:);
    Appointment(i)=max(Time(:,2));
    ActualTime(i)=max(Time(:,3));
end
end

