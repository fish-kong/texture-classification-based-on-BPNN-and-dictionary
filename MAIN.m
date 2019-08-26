%% 这个程序用于提取特征
clear
clc
close all
% 提取特征--分词
%% 加载数据
load data_nx
data1=[];
for i=1:length(data)
    
x=char(data{i});
data1(i,:)=fenci_tezheng(x);  
end


%%
load data_ty
 data2=[];
for i=1:length(data)
    
x=char(data{i});
data2(i,:)=fenci_tezheng(x);  
end
%%
load data_wx
data3=[];
for i=1:length(data)
    
x=char(data{i});
data3(i,:)=fenci_tezheng(x);  
end
%%
load data_xy
data4=[];
for i=1:length(data)
    
x=char(data{i});
data4(i,:)=fenci_tezheng(x);  
end

input=[data1;data2;data3;data4];
output=[ones(1,size(data1,1)) 2*ones(1,size(data2,1)) 3*ones(1,size(data3,1)) 4*ones(1,size(data4,1)) ];
save data_tz input output

