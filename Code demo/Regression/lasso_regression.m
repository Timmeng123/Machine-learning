%清空命令窗口
clc;
%清空工作区的变量和值
clear;
%关闭所有程序运行过程中打开的绘图窗口，此处为绘图窗口。
close all;
%% 读取数据
data = [1952	598	349	461	57482	20729	44	184
    1953	586	455	475	58796	21364	89	216
    1954	707	520	491	60266	21832	97	248
    1955	737	558	529	61465	22328	98	254
    1956	825	715	556	62828	23018	150	268
    1957	837	798	575	64653	23711	139	286
    1958	1028	1235	598	65994	26600	256	357
    1959	1114	1681	509	67207	26173	338	444
    1960	1079	1870	444	66207	25880	380	506
    1961	757	1156	434	65859	25590	138	271
    1962	677	964	461	67295	25110	66	230
    1963	779	1046	514	69172	26640	85	266
    1964	943	1250	584	70499	27736	129	323
    1965	1152	1581	632	72538	28670	175	393
    1966	1322	1911	687	74542	29805	212	466
    1967	1249	1647	697	76368	30814	156	352
    1968	1187	1565	680	78534	31915	127	303
    1969	1372	2101	688	80671	33225	207	447
    1970	1638	2747	767	82992	34432	312	564
    1971	1780	3156	790	85229	35620	355	638
    1972	1833	3365	789	87177	35854	354	658
    1973	1978	3684	855	89211	36652	374	691
    1974	1993	3696	891	90859	37369	393	655
    1975	2121	4254	932	92421	38168	462	692
    1976	2052	4309	955	93717	38834	443	657
    1977	2189	4925	971	94974	39377	454	723
    1978	2475	5590	1058	96259	39856	550	922
    1979	2702	6065	1150	97542	40581	564	890
    1980	2791	6592	1194	98705	41896	568	826
    1981	2927	6862	1273	100072	73280	496	810];
%% 数据处理
x = data(1:end-5,2:end-1);     % 留5个用于预测
y = data(1:end-5,end);  % 留5个用于预测
X = [ones(size(y)) x];  % 加上常数项
x1=X;
y1=y;
%调用lasso函数，其中参数为（自变量x，因变量y，使用交叉验证，10折交叉验证，α，α=0为岭回归，α=1为lasso回归）；返回值为（b：权重系数，fitinfo:模型信息）
[b,fitinfo] = lasso(x1,y1,'CV',10,'Alpha',1); 
%画图
axTrace = lassoPlot(b,fitinfo,'PlotType','Lambda','XScale','log');
%为图像添加图例，位置在图的右侧外面
legend('show','Location','EastOutside');
axCV = lassoPlot(b,fitinfo,'PlotType','CV');
%寻找最小误差对应的迭代次数
lam1SE = fitinfo.Index1SE;
%最小误差的值
mse_1=fitinfo.MSE(lam1SE);
%取最小误差对应的系数；b矩阵lam1SE列所有行
mat=b(:,lam1SE);
%寻找系数中的非零项（~=0为不等于0）
[row1SE, ] = find(b(:,lam1SE)~=0);
%计算原来的最小均方误差
rhat = x1\y1;
res = x1*rhat - y1;   
MSEmin_real= res'*res/325; 
%最小均方误差对应的迭代次数，上面误差是1se这里是mse
lamMinMSE = fitinfo.IndexMinMSE;
%主成分的系数
matMinMSE = b(:,lamMinMSE);  
%寻找非零自变量的下标（即主成分的下标）
[rowMinMSE, ] = find(b(:,lamMinMSE)~=0);
%两种计算误差方式使得所降成的维度不同，根据自己需求比较两个误差计算方式的差异选择留几个变量。
