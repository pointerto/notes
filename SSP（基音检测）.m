[a,Fs,bits]=wavread('ma.wav');                                    %��ȡ��Ƶ�ļ�

framelength=Fs*20/1000;                                           %ͨ����Ϊ������10-30ms������̬�ģ���ʵ��ѡȡ20ms���ټ���֡����48000*20/1000=960
                                                                                    %inc=framelength*30/100;
inc=framelength*25/100;                                            %�趨֡λ��Ϊ֡����%25
                                                                                             
                                                                                             
%����Ϊ֮ǰȡ��֡Դ���룬ע�ͻ�ȡ�������ã�����enframe������������
%begin=60000;                                                           %ѡȡ֡����ʼ��Ϊ60000
%final=begin+framelength-1;                                    %������ĵ�Ϊ ��ʼ��+֡��
%frame=a(begin:final);                                               %������ʼ��ͽ�����ȡ֡
%lframe=length(frame);                                             %��ȡȡ��֡�ĳ��ȸ�������lframe����ʵ��lframe=framelength

%fra=frame.*hamming(lframe);                                 %Ϊȡ��֡�Ӻ�����������Ϊȡ��֡�ĳ���
%lfra=length(fra);                                                       %��ȡ�Ӵ����֡�ĳ��ȣ���������lfra����ʵ��lfra=lframe=framelength

fra=enframe(a,hamming(framelength),inc);              %ͨ��enframe����������ʵ�������Ӵ�ȡ֡
lfra=length(fra);

rcp=rceps(fra);                                                            %����ʵ���׺���rceps()����ʵ���׷�����ʹ�ñ���rcpָ��������rceps����
lrcp=length(rcp);                                                         %��ȡ���е���������֡���ȸ�������lrcp��Ӧ��lrcp=lfra=lframe=framelength


lmin=fix(Fs/500);                                                      %��Ƶ�ʵ���ʽ�趨��С�����������ڵķ�ΧΪ70-500Hz
lmax=fix(Fs/70);
baseperiod=rcp(lmin:lmax);                                      %�ñ���baseperiod����ʾ��������

[maxvalue inpoint]=max(baseperiod);                       %����maxvalue���Ա�ʾ�������������ֵ������inpoint��ʾ�����еĴﵽ���ֵʱ�ı�ǵ�
if (maxvalue>0.08&&inpoint>lmin)                          %ʹ��ѡ��ṹ������жϻ��������ڵ����ֵ�Ƿ����0.08
    b=Fs/(lmin+inpoint);                                              %��maxvalue����0.08����˵����Ƶ֡����ʾ����������������������
else
    b=0;                                                                        %��maxvalue������0.08����˵����Ƶ֡����ʾ��������������������˵�������������û�������
end
pitch=b;

figure(1);
subplot(3,1,1);
time=1:length(a);
plot(time,a);
xlabel('������');
ylabel('����');
axis([0,230000,-0.1,0.1]);
title('��Ƶ�źŲ���');

subplot(3,1,2);
time1=1:960;
plot(time1,fra);
xlabel('������');
ylabel('����');
axis([0,959,-0.1,0.1]);
title('ȡ��֡');

subplot(3,1,3);
time2=[-482:1:-1,0:1:482];
plot(time2,rcp);
xlabel('������');
ylabel('����');
axis([-482,483,-0.1,0.1]);
title('ȡ��֡�ĵ���') ;