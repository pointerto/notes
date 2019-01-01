[a,Fs,bits]=wavread('ma.wav');

framelength=Fs*20/1000;                                        %ͨ����Ϊ������10-30ms������̬�ģ���ʵ��ѡȡ20ms���ټ���֡����48000*20/1000=960
                                                                                                                                                                                                 
begin=60000;                                                             %ѡȡ֡����ʼ��Ϊ60000
final=begin+framelength-1;                                       %������ĵ�Ϊ ��ʼ��+֡��
frame=a(begin:final);                                                  %������ʼ��ͽ�����ȡ֡
lframe=length(frame);                                                %��ȡȡ��֡�ĳ��ȸ�������lframe����ʵ��lframe=framelength

fra=frame.*hamming(lframe);                                    %Ϊȡ��֡�Ӻ�����������Ϊȡ��֡�ĳ���
lfra=length(fra);                                                          %��ȡ�Ӵ����֡�ĳ��ȣ���������lfra����ʵ��lfra=lframe=framelength

ffra=log(abs(fft(fra)));

rcp=rceps(fra);                                                            %����ʵ���׺���rceps()����ʵ���׷�����ʹ�ñ���rcpָ��������rceps����
lrcp=length(rcp);                                                         %��ȡ���е���������֡���ȸ�������lrcp��Ӧ��lrcp=lfra=lframe=framelength
cepcaculate=rcp(1:lrcp);

lmin=fix(Fs/500);                                                        %�趨��С�����������ڵķ�ΧΪ70-500
lmax=fix(Fs/70);
baseperiod=cepcaculate(lmin:lmax);                          %�ñ���baseperiod����ʾ��������
[maxvalue inpoint]=max(baseperiod);                        %����maxvalue���Ա�ʾ�������������ֵ������inpoint��ʾ�����еĴﵽ���ֵʱ�ı�ǵ�

outpoint=inpoint+lmin;
cep=cepcaculate(1:outpoint).*hamming(outpoint);

ftrans1=log(abs(fft(cep)));
ftrans=ftrans1;

for t=3:outpoint                                                           %��ֵ�˲���ƽ������
    z=ftrans1(t-2:t);  
    b=median(z);                                                            %median��������ȡ�м�ֵ������������Ԫ����ȡ�м��Ԫ�أ�����ż����Ԫ����ȡ�м�������ƽ��ֵ
    ftrans2(t)=b;
end


for t=1:outpoint-1                                                        %ѡ��ṹ��outpoint�����Ͻ���ƽ������
   if t<=2
        ftrans(t)=ftrans1(t);
    else
        ftrans(t)=ftrans2(t-1)*0.25+ftrans2(t)*0.5+ftrans2(t+1)*0.25;  
    end
end

subplot(5,1,1);
time=1:length(a);
plot(time,a);
xlabel('������');
ylabel('����');
axis([0,240000,-0.1,0.1]);
title('��Ƶ�źŲ���');

subplot(5,1,2);
time=1:lfra;
plot(time,fra);
xlabel('������');
ylabel('����');
axis([0,959,-0.1,0.1]);
title('��Ƶ�źŲ���');

subplot(5,1,3);
time2=[-480:1:-1,0:1:479];
plot(time2,cepcaculate);
xlabel('������');
ylabel('����');
axis([-479,480,-0.12,0.12]);
title('ȡ��֡�ĵ���') ;


subplot(5,1,4);
xj=(1:length(ffra)/2)*Fs/length(ffra);
plot(xj,ffra(1:length(ffra)/2));
xlabel('Ƶ��');
ylabel('����');
title('Ƶ��');

subplot(5,1,5);
xi=(1:outpoint/2)*Fs/outpoint;
plot(xi,ftrans(1:outpoint/2));
xlabel('Ƶ��');
ylabel('����');
%axis([0,25000,-10,10]);
title('ƽ��������');