function [Startdistance] = calculate_Startdistance(Xstart,X)
%UNTITLED3 此处显示有关此函数的摘要
%   此处显示详细说明
n=size(X,1);
Startdistance=zeros(1,n);
for i=1:n
    Startdistance(i)=((Xstart(1,1)-X(i,1))^2+(Xstart(1,2)-X(i,2))^2)^0.5;
end
end

