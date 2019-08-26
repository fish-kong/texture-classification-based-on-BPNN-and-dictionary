%% 该代码利用神经网络工具箱进行图片分类
clc;clear;close all; format compact
%% 加载数据
%% 训练数据预测数据提取及归一化

load data_tz
input=input;
label=output';
%%
no_dim=15;
[PCALoadings,PCAScores,PCAVar] = pca(input);%利用PCA进行降维
input=PCAScores(:,1:no_dim);%利用pca进行降维至no_dims维
%%

%把输出从1维变成4维
output=zeros(size(label,1),4);
for i=1:size(label,1)
    output(i,label(i))=1;
end
%%
rand('seed',0)

[m n]=sort(rand(1,size(input,1)));
m=100;%随机提取m个样本为训练样本，剩下的为预测样本
P_train=input(n(1:m),:)';
T_train=output(n(1:m),:)';
P_test=input(n(m+1:end),:)';
T_test=output(n(m+1:end),:)';

%% 建立网络
s1=12;%隐含层节点
net_bp=newff(P_train,T_train,s1);
% 设置训练参数
net_bp.trainParam.epochs = 100;
net_bp.trainParam.goal = 0.0001;
net_bp.trainParam.lr = 0.01;
net_bp.trainParam.showwindow = 1;

%% 训练并测试BP网络
net_bp = train(net_bp,P_train,T_train);%训练
%%训练集准确率
bp_sim = sim(net_bp,P_train);%测试
[I J]=max(bp_sim',[],2);
[I1 J1]=max(T_train',[],2);
disp('展示BP的训练集分类')
bp_train_accuracy=sum(J==J1)/length(J)
figure
stem(J,'bo');
grid on
hold on 
plot(J1,'r*');
legend('网络训练输出','真实标签')
title('BP神经网络训练集')
xlabel('样本数')
ylabel('分类标签')
hold off
%% 测试集准确率
tn_bp_sim = sim(net_bp,P_test);%测试
[I J]=max(tn_bp_sim',[],2);
[I1 J1]=max(T_test',[],2);
disp('展示BP的测试集分类')
bp_test_accuracy=sum(J==J1)/length(J)
figure
stem(J,'bo');
grid on
hold on 
plot(J1,'r*');
legend('测试输出','真实标签')
title('BP神经网络测试集')
xlabel('样本数')
ylabel('分类标签')
hold off
save net_bp net_bp PCALoadings