%% 该代码为bp网络

%% 清空环境变量
clc;clear;close all; format compact
%% 加载数据
%% 训练数据预测数据提取及归一化

load data_tz
input=input;
label=output';
%%
no_dim=13;
[PCALoadings,PCAScores,PCAVar] = pca(input);%利用PCA进行降维
input=PCAScores(:,1:no_dim);%利用pca进行降维至no_dims维
%%

%把输出从1维变成4维
output=zeros(size(label,1),4);
for i=1:size(label,1)
    output(i,label(i))=1;
end

%随机提取150个样本为训练样本，48个样本为预测样本
rand('seed',0)
[m n]=sort(rand(1,156));
m=100;
input_train=input(n(1:m),:)';
output_train=output(n(1:m),:)';
input_test=input(n(m+1:end),:)';
output_test=output(n(m+1:end),:)';




%% 网络结构初始化

innum=size(input_train,1);%输入层节点数
midnum=12;%隐含层节点
outnum=size(output_train,1);%输出层节点
 
%权值初始化
w1=rands(midnum,innum);
b1=rands(midnum,1);
w2=rands(midnum,outnum);
b2=rands(outnum,1);

w2_1=w2;w2_2=w2_1;
w1_1=w1;w1_2=w1_1;
b1_1=b1;b1_2=b1_1;
b2_1=b2;b2_2=b2_1;


xite=0.01;%学习率
alfa=0.1;%动量项
loopNumber=100;%训练次数
I=zeros(1,midnum);
Iout=zeros(1,midnum);
FI=zeros(1,midnum);
dw1=zeros(innum,midnum);
db1=zeros(1,midnum);

%% 网络训练
inputn=input_train;
E=zeros(1,loopNumber);
for ii=1:loopNumber
    E(ii)=0;
    for i=1:1:size(inputn,2)%ce
       %% 
        x=inputn(:,i);
        % 隐含层输出
        for j=1:1:midnum
            I(j)=inputn(:,i)'*w1(j,:)'+b1(j);
            Iout(j)=1/(1+exp(-I(j)));
        end
        % 输出层输出
        yn=w2'*Iout'+b2;
        
       %% 权值阀值修正
        %计算误差
        e=output_train(:,i)-yn;     
        E(ii)=E(ii)+sum(abs(e));
        
        %计算权值变化率
        dw2=e*Iout;
        db2=e';
        
        for j=1:1:midnum
            S=1/(1+exp(-I(j)));
            FI(j)=S*(1-S);
        end      
        for k=1:1:innum
            for j=1:1:midnum
                dw1(k,j)=FI(j)*x(k)*(e(1)*w2(j,1)+e(2)*w2(j,2)+e(3)*w2(j,3)+e(4)*w2(j,4));
                db1(j)=FI(j)*(e(1)*w2(j,1)+e(2)*w2(j,2)+e(3)*w2(j,3)+e(4)*w2(j,4));
            end
        end
           
        w1=w1_1+xite*dw1'+alfa*(w1_1-w1_2);
        b1=b1_1+xite*db1'+alfa*(b1_1-b1_2);
        w2=w2_1+xite*dw2'+alfa*(w2_1-w2_2);
        b2=b2_1+xite*db2'+alfa*(b2_1-b2_2);
        
        w1_2=w1_1;w1_1=w1;
        w2_2=w2_1;w2_1=w2;
        b1_2=b1_1;b1_1=b1;
        b2_2=b2_1;b2_1=b2;
    end
end
figure
plot(E)
title('训练误差')
xlabel('迭代次数')
ylabel('误差')

%% 训练阶段
inputn_test=input_train;
fore=zeros(size(output_train));
for i=1:size(inputn_test,2)%56个样本
    %隐含层输出
    for j=1:1:midnum
        I(j)=inputn_test(:,i)'*w1(j,:)'+b1(j);
        Iout(j)=1/(1+exp(-I(j)));
    end
    fore(:,i)=w2'*Iout'+b2;
end
[I J1]=max(fore',[],2);
[I1 J2]=max(output_train',[],2);
test_accuracy=sum(J1==J2)/length(J1)
figure
stem(J1,'bo');
grid on
hold on 
plot(J2,'r*');
legend('测试输出','真实标签')
title('BP神经网络训练集')
xlabel('样本数')
ylabel('分类标签')
hold off
%% 测试阶段
inputn_test=input_test;
fore=zeros(size(output_test));
for i=1:size(inputn_test,2)%56个样本
    %隐含层输出
    for j=1:1:midnum
        I(j)=inputn_test(:,i)'*w1(j,:)'+b1(j);
        Iout(j)=1/(1+exp(-I(j)));
    end
    fore(:,i)=w2'*Iout'+b2;
end
% 结果分析
%根据网络输出找出数据属于哪类
[I J3]=max(fore',[],2);
[I1 J4]=max(output_test',[],2);
test_accuracy=sum(J3==J4)/length(J3)

figure
stem(J3,'bo');
grid on
hold on 
plot(J4,'r*');
legend('测试输出','真实标签')
title('BP神经网络测试集')
xlabel('样本数')
ylabel('分类标签')
hold off