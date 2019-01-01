[a,Fs,bits]=wavread('ma.wav');                                    %读取音频文件

framelength=Fs*20/1000;                                           %通常认为语音在10-30ms内是稳态的，此实验选取20ms，再计算帧长：48000*20/1000=960
                                                                                    %inc=framelength*30/100;
inc=framelength*25/100;                                            %设定帧位移为帧长的%25
                                                                                             
                                                                                             
%以下为之前取单帧源代码，注释化取消其作用，换用enframe（）函数方案
%begin=60000;                                                           %选取帧的起始点为60000
%final=begin+framelength-1;                                    %则结束的点为 起始点+帧长
%frame=a(begin:final);                                               %依照起始点和结束点取帧
%lframe=length(frame);                                             %提取取出帧的长度赋给变量lframe，事实上lframe=framelength

%fra=frame.*hamming(lframe);                                 %为取出帧加汉明窗，窗长为取出帧的长度
%lfra=length(fra);                                                       %提取加窗后的帧的长度，赋给变量lfra，事实上lfra=lframe=framelength

fra=enframe(a,hamming(framelength),inc);              %通过enframe（）函数来实现批量加窗取帧
lfra=length(fra);

rcp=rceps(fra);                                                            %利用实倒谱函数rceps()进行实倒谱分析，使用变量rcp指向函数运算rceps（）
lrcp=length(rcp);                                                         %提取进行倒谱运算后的帧长度赋给变量lrcp，应有lrcp=lfra=lframe=framelength


lmin=fix(Fs/500);                                                      %用频率的形式设定最小和最大基音周期的范围为70-500Hz
lmax=fix(Fs/70);
baseperiod=rcp(lmin:lmax);                                      %用变量baseperiod来表示基音周期

[maxvalue inpoint]=max(baseperiod);                       %变量maxvalue用以表示基音周期中最大值，变量inpoint表示倒谱中的达到最大值时的标记点
if (maxvalue>0.08&&inpoint>lmin)                          %使用选择结构语句来判断基音周期内的最大值是否大于0.08
    b=Fs/(lmin+inpoint);                                              %若maxvalue大于0.08，则说明音频帧所表示的是浊音，则计算基音周期
else
    b=0;                                                                        %若maxvalue不大于0.08，则说明音频帧所表示的是清音，对于清音来说计算基音周期是没有意义的
end
pitch=b;

figure(1);
subplot(3,1,1);
time=1:length(a);
plot(time,a);
xlabel('样点数');
ylabel('幅度');
axis([0,230000,-0.1,0.1]);
title('音频信号波形');

subplot(3,1,2);
time1=1:960;
plot(time1,fra);
xlabel('样点数');
ylabel('幅度');
axis([0,959,-0.1,0.1]);
title('取出帧');

subplot(3,1,3);
time2=[-482:1:-1,0:1:482];
plot(time2,rcp);
xlabel('样点数');
ylabel('幅度');
axis([-482,483,-0.1,0.1]);
title('取出帧的倒谱') ;