n=10;                         %n为产生的随机序列长度
os=rand(1,n)>0.5              %产生一个长度为10的随机序列 
os1=os.*2-1                   %将单极性序列转换为双极性序列
j=10000;i=10;                 %j为抽样点数，i为语句参数，通过循环以及条件语句，实现双极性随机序列转换为双极性数字基带信号
t=linspace(0,10,j)            %产生0到10之间的j点行矢量，并赋给变量t
for n=1:10
    if os1(n)<1;
        for m=j/i*(n-1)+1:j/i*n
            st1(m)=-1;
        end
    else
        for m=j/i*(n-1)+1:j/i*n
            st1(m)=1;
        end
    end
end
 
subplot(5,2,1);                  % 将图形窗口分割为五行两列，下面将要绘制的波形图位于该布局的第一个位置
plot(t,st1);                     %绘制出双极性数字基带信号的时域波形,以变量t为横坐标，st1为纵坐标
axis([0,10,-2,2]);               %设置坐标的范围，横坐标0到10，纵坐标-2到2
title('基带信号时域波形')        %设置波形图标题
M=fft(st1);                      %对双极性数字基带信号进行频域变换
magM=abs(M);                     %对频域幅值求绝对值并将其赋给变量magM（Margin 幅度，幅值）
subplot(5,2,2);                  %将图形窗口分割为五行两列，下面将要绘制的波形图位于该布局的第二个位置
plot(magM);                      %绘制双极性数字基带信号频谱图
title('基带信号频域波形')        %设置波形图标题
fc=2;                            %fc为载波信号频率
t=linspace(0,10,j) %产生0到10之间的j点行矢量，并赋给变量t
sc=sin(2*pi*fc*t);               %将载波信号赋给变量sc
subplot(5,2,3);                  %将图形窗口分割为五行两列，下面将要绘制的波形图位于该布局的第三个位置
plot(t,sc);                      %绘制出载波信号的时域波形,以 
变量t为横坐标，sc为纵坐标
title('载波波形');              %设置波形图标题
J=fft(sc);                      %对载波信号进行频域变换
magJ=abs(J);                    %对频域幅值求绝对值并将其赋给变量magJ（Margin 幅度，幅值）
subplot(5,2,4);                 %将图形窗口分割为五行两列，下面将要绘制的波形图位于该布局的第四个位置
plot(magJ);                     %绘制载波信号频谱图
title('载波频域波形')           %设置波形图标题
s=st1.*sc;                      %使用载波信号对双极性数字基带信号进行调制
subplot(5,2,5);                 %将图形窗口分割为五行两列，下面将要绘制的波形图位于该布局的第五个位置
plot(t,s);                      %绘制出已调信号的时域波形,以变量t为横坐标，s为纵坐标
title('已调信号');              %设置波形图标题
F=fft(s);                       %对已调信号进行频域变换
magF=abs(F);                    %对频域幅值求绝对值并将其赋给变量magJ（Margin 幅度，幅值）
subplot(5,2,6);                 %将图形窗口分割为五行两列，下面将要绘制的波形图位于该布局的第六个位置
plot(magF);                     %绘制已调信号频谱图
 
title('已调信号频域波形')       %设置波形图标题
2.已调信号的解调
信道会产生高斯白噪声，已调信号通过信道则会被加上高斯白噪声，之后通过带通滤波器，噪声将被滤除一部分。然后通过解调器进行解调。
t=linspace(0,10,j)              %产生0到10之间的j点行矢量，并赋给变量t
noise=wgn(1,j,0);               %wgn函数用以产生高斯白噪声，即产生1行j列的噪声序列，输出强度为0dBW
subplot(5,2,7);                %将图形窗口分割为五行两列，下面将要绘制的波形图位于该布局的第七个位置
plot(t,noise);                 %绘制出高斯白噪声的时域波形,以变量t为横坐标，noise为纵坐标
title('高斯白噪声波形')        %设置波形图标题
L=fft(noise);                  %对噪声信号进行频域变换
magL=abs(L);                   %对频域幅值求绝对值并将其赋给变量magL（Margin 幅度，幅值）
subplot(5,2,8);                %将图形窗口分割为五行两列，下面将要绘制的波形图位于该布局的第八个位置
plot(magL);                    %绘制高斯白噪声频谱图
title('高斯白噪声频域波形')    %设置波形图标题
t=linspace(0,10,j)             %产生0到10之间的j点行矢量，并赋给变量t
 
sn=s+noise;                     %将已调信号加上高斯白噪声
subplot(5,2,9);                 %将图形窗口分割为五行两列，下面将要绘制的波形图位于该布局的第九个位置
plot(t,sn);                     %绘制出加噪后已调信号的时域波形,以变量t为横坐标，sn为纵坐标
title('通过噪声信道后调制信号时域波形') %设置波形图标题
Q=fft(sn);                      %对加噪后已调信号进行频域变换
magQ=abs(Q);                    %对频域幅值求绝对值并将其赋给变量magQ（Margin 幅度，幅值）
subplot(5,2,10);                %将图形窗口分割为五行两列，下面将要绘制的波形图位于该布局的第十个位置
plot(magQ);                     %绘制加噪后已调信号频谱图
title('通过噪声信道后调制信号频域波形') %设置波形图标题
Fp=15;Fs=40;                   %设置带通滤波器的参数，尽管滤波器阶数越高越接近理想波形，但越难以实现，于是阶数不宜取高
Rp=3;Rs=5;
Wp=2*pi*Fp/400;
Ws=2*pi*Fs/400;
[N,Wp]=buttord(Wp,Ws,Rp,Rs);     %利用buttord函数生成巴特沃斯带通滤波器
[b,a]=butter(N,Wp);
figure(2)                        %将以下波形图在第二个窗口展示
t=linspace(0,10,j)               %产生0到10之间的j点行矢量，并赋给变量t
X=filter(b,a,sn);                %使用filter函数将加噪已调信号通过带通滤波器
subplot(4,2,1);                  %将图形窗口分割为四行两列，下面将要绘制的波形图位于该布局的第一个位置
plot(t,X);                       %绘制出加噪已调信号通过BPF后的时域波形,以变量t为横坐标，X为纵坐标
title('调制信号通过BPF后时域波形')%设置波形图标题
P=fft(X);                        %对加噪已调信号通过BPF后的波形进行频域变换
magP=abs(P);                     %对频域幅值求绝对值并将其赋给变量magP（Margin 幅度，幅值）
subplot(4,2,2);                 %将图形窗口分割为四行两列，下面将要绘制的波形图位于该布局的第二个位置
plot(magP);                     %绘制加噪已调信号通过BPF后的频谱图
title('调制信号通过BPF后频域波形') %设置波形图标题
t=linspace(0,10,j)              %产生0到10之间的j点行矢量，并赋给变量t
slcj=X.*sc;                     %将经过BPF滤波后的加噪已调信 
号进行解调
subplot(4,2,3);                %将图形窗口分割为四行两列，下面将要绘制的波形图位于该布局的第三个位置
plot(t,slcj);                  %绘制出解调信号的时域波形,以变量t为横坐标，slcj为纵坐标
title('解调后时域波形')       %设置波形图标题
V=fft(slcj);                  %对解调信号进行频域变换
magV=abs(V);                  %对频域幅值求绝对值并将其赋给变量magV（Margin 幅度，幅值）
subplot(4,2,4);               %将图形窗口分割为四行两列，下面将要绘制的波形图位于该布局的第四个位置
plot(magV);                   %绘制解调信号频谱图
title('解调后频域波形')       %设置波形图标题
t=linspace(0,10,j)            %产生0到10之间的j点行矢量，并赋给变量t
fp=400;fs=500;rp=3;rs=20;fn=15000;%设置低通滤波器参数，通带截止频率400Hz，阻带截止频率为500Hz，通带最大衰减为3dB，阻带最小衰减为20 dB，阶数为11
ws=fs/(fn/2);wp=fp/(fn/2);
[n,wn]=buttord(wp,ws,rp,rs);  %利用buttord函数生成巴特沃斯低通滤波器
[b,a]=butter(n,wn);
 
[H,w]=freqz(b,a);
t=linspace(0,10,j)              %产生0到10之间的j点行矢量，并赋给变量t
O=filter(b,a,slcj);            %使用filter函数将解调信号通过低通滤波器
subplot(4,2,5);                %将图形窗口分割为四行两列，下面将要绘制的波形图位于该布局的第五个位置
plot(t,O);                     %绘制出解调信号通过LPF后的时域波形,以变量t为横坐标，O为纵坐标
title('解调信号通过LPF后时域波形') %设置波形图标题
Y=fft(O);                     %对通过LPF的解调信号进行频域变换
magY=abs(Y);                 %对频域幅值求绝对值并将其赋给变量magY（Margin 幅度，幅值）
subplot(4,2,6);              %将图形窗口分割为四行两列，下面将要绘制的波形图位于该布局的第六个位置
plot(magY);                  %绘制解调信号通过LPF后的频谱图
title('解调信号通过LPF后频域波形') %设置波形图标题
3.基带信号的恢复
解调后的信号还要经过抽样、判决和码元再生恢复为二进制数字基带信号。
for m=0:i-1;                 %利用循环以及条件语句，将解调信 
号恢复为二进制数字基带信号
    if O(1,m*1000+200)<0;
        for j=m*1000+1:(m+1)*1000;
            O(1,j)=-1;
        end
    else
        for j=m*1000+1:(m+1)*1000;
            O(1,j)=1;
        end
    end
end
t=linspace(0,10,j)            %产生0到10之间的j点行矢量，并赋给变量t
subplot(4,2,7);               %将图形窗口分割为四行两列，下面将要绘制的波形图位于该布局的第七个位置
plot(t,O);                    %绘制出经恢复的二进制数字基带信号时域波形,以变量t为横坐标，O为纵坐标
axis([0,10,-2,2]);            %设置坐标的范围，横坐标0到10，纵坐标-2到2
title('抽样判决再生所得时域波形') %设置波形图标题
K=fft(O);                     %对经恢复得到的二进制数字基带信号进行频域变换
 
magK=abs(K);                   %对频域幅值求绝对值并将其赋给变量magK（Margin 幅度，幅值）
subplot(4,2,8);                %将图形窗口分割为五行两列，下面将要绘制的波形图位于该布局的第八个位置
plot(magK);                    %绘制经恢复得到的二进制数字基带信号频谱图
title('抽样判决再生所得频域波形') %设置波形图标题