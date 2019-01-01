[a,Fs,bits]=wavread('ma.wav');

framelength=Fs*20/1000;                                        %通常认为语音在10-30ms内是稳态的，此实验选取20ms，再计算帧长：48000*20/1000=960
                                                                                                                                                                                                 
begin=60000;                                                             %选取帧的起始点为60000
final=begin+framelength-1;                                       %则结束的点为 起始点+帧长
frame=a(begin:final);                                                  %依照起始点和结束点取帧
lframe=length(frame);                                                %提取取出帧的长度赋给变量lframe，事实上lframe=framelength

fra=frame.*hamming(lframe);                                    %为取出帧加汉明窗，窗长为取出帧的长度
lfra=length(fra);                                                          %提取加窗后的帧的长度，赋给变量lfra，事实上lfra=lframe=framelength

ffra=log(abs(fft(fra)));

rcp=rceps(fra);                                                            %利用实倒谱函数rceps()进行实倒谱分析，使用变量rcp指向函数运算rceps（）
lrcp=length(rcp);                                                         %提取进行倒谱运算后的帧长度赋给变量lrcp，应有lrcp=lfra=lframe=framelength
cepcaculate=rcp(1:lrcp);

lmin=fix(Fs/500);                                                        %设定最小和最大基音周期的范围为70-500
lmax=fix(Fs/70);
baseperiod=cepcaculate(lmin:lmax);                          %用变量baseperiod来表示基音周期
[maxvalue inpoint]=max(baseperiod);                        %变量maxvalue用以表示基音周期中最大值，变量inpoint表示倒谱中的达到最大值时的标记点

outpoint=inpoint+lmin;
cep=cepcaculate(1:outpoint).*hamming(outpoint);

ftrans1=log(abs(fft(cep)));
ftrans=ftrans1;

for t=3:outpoint                                                           %中值滤波（平滑处理）
    z=ftrans1(t-2:t);  
    b=median(z);                                                            %median函数用来取中间值，如有奇数个元素则取中间的元素，如有偶数个元素则取中间两数的平均值
    ftrans2(t)=b;
end


for t=1:outpoint-1                                                        %选择结构在outpoint区间上进行平滑处理
   if t<=2
        ftrans(t)=ftrans1(t);
    else
        ftrans(t)=ftrans2(t-1)*0.25+ftrans2(t)*0.5+ftrans2(t+1)*0.25;  
    end
end

subplot(5,1,1);
time=1:length(a);
plot(time,a);
xlabel('样点数');
ylabel('幅度');
axis([0,240000,-0.1,0.1]);
title('音频信号波形');

subplot(5,1,2);
time=1:lfra;
plot(time,fra);
xlabel('样点数');
ylabel('幅度');
axis([0,959,-0.1,0.1]);
title('音频信号波形');

subplot(5,1,3);
time2=[-480:1:-1,0:1:479];
plot(time2,cepcaculate);
xlabel('样点数');
ylabel('幅度');
axis([-479,480,-0.12,0.12]);
title('取出帧的倒谱') ;


subplot(5,1,4);
xj=(1:length(ffra)/2)*Fs/length(ffra);
plot(xj,ffra(1:length(ffra)/2));
xlabel('频率');
ylabel('幅度');
title('频谱');

subplot(5,1,5);
xi=(1:outpoint/2)*Fs/outpoint;
plot(xi,ftrans(1:outpoint/2));
xlabel('频率');
ylabel('幅度');
%axis([0,25000,-10,10]);
title('平滑对数谱');