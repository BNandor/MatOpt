cd 'Topology Of WSN'
##comm_r=200;%����ͨ�Ű뾶
%~~~~~~~~~~~~~~~~~~ѡ��ͨ��ģ��~~~~~~~~~~~~~~~~~ 
model='Regular Model'
%model='Logarithmic Attenuation Model';
%disp('ʱ�����ܽϳ�...');model='DOI Model';DOI=0.015;
%disp('ʱ�����ܽϳ�...');model='RIM Model';DOI=0.01;
%~~~~~~~~~~~~~~~~~~�����ھӹ�ϵ~~~~~~~~~~~~~~~~~
anchor_comm_r=1
%anchor_comm_r����ֻ��APIT�и��ģ��������㷨ͳһ����Ϊ1��
%����ʾê�ڵ�ͨ�Ű뾶��δ֪�ڵ�ͨ�Ű����ı�����
%APIT���Ե�WSN���칹�ģ�ê�ڵ�ͨ�Ű뾶��δ֪�ڵ��Ĵ���
try
    calculate_neighbor(comm_r,anchor_comm_r,model,DOI)
catch
    calculate_neighbor(comm_r,anchor_comm_r,model)
end
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
##Topology_Of_WSN;%���ھӹ�ϵͼ
cd ..;
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ѡ����λ�㷨~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%cd Centroid;Centroid(20,0.9);%Centroid_second(20,0.9);%Centroid_third(...
%cd 'Bounding Box';Bounding_Box;%Bounding_Box_second;%Bounding_Box_third;
%cd 'Grid Scan';Grid_Scan(0.1*comm_r);%Grid_scan_second(...
%cd RSSI;RSSI;%RSSI_second;%RSSI_third;
%~~~~~~~~~~~~~~~~~~~~~~~~\

cd 'DV-hop';DV_hop
cd ..