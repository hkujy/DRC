%% ?????
%??
% Chrom  ????   
% X      ???????
function DrawPath(Chrom,X,LocateAAA)
posi=find(Chrom==1);
if posi~=1
    Chrom=[Chrom(posi:end) Chrom(1:(posi-1))];
end
R=[Chrom(1,:) Chrom(1,1)]; %?????(??)
% R=[LocateAAA(1,:) LocateAAA(1,1)]; %?????(??)
figure;
hold on
plot(LocateAAA(:,1),LocateAAA(:,2),'o','color',[0.5,0.5,0.5])
% plot(X(:,1),X(:,2),'o','color',[0.5,0.5,0.5])%Yuabna
plot(X(Chrom(1,1),1),X(Chrom(1,1),2),'rv','MarkerSize',20)
for i=1:size(LocateAAA,1)
    text(LocateAAA(i,1)+0.05,LocateAAA(i,2)+0.05,num2str(i),'color',[1,0,0]);
end
% for i=1:size(X,1)%Yuabna
%     text(X(i,1)+0.05,X(i,2)+0.05,num2str(i),'color',[1,0,0]);
% end
% A=X(R,:);
A=LocateAAA(R,:);
row=size(A,1);
for i=2:row
    [arrowx,arrowy] = dsxy2figxy(gca,A(i-1:i,1),A(i-1:i,2));%????
    annotation('textarrow',arrowx,arrowy,'HeadWidth',8,'color',[0,0,1]);
end
hold off
xlabel('???')
ylabel('???')
title('???')
box on