load '../Deploy Nodes/coordinates.mat';
load neighbor.mat;
figure;
hold on;
box on;
for i=1:all_nodes.nodes_n
    for j=i+1:all_nodes.nodes_n
        if neighbor_matrix(i,j)==1
            plot(all_nodes.true([i,j],1),all_nodes.true([i,j],2),'-b');
        end
    end
end
plot(all_nodes.true(all_nodes.anchors_n+1:all_nodes.nodes_n,1),all_nodes.true(all_nodes.anchors_n+1:all_nodes.nodes_n,2),'ro');
plot(all_nodes.true(1:all_nodes.anchors_n,1),all_nodes.true(1:all_nodes.anchors_n,2),'r*');
axis([0,all_nodes.square_L,0,all_nodes.square_L]);
title('�ھӹ�ϵͼ');
disp('~~~~~~~~~~~~~~~~~~~~~~~~�ھӹ�ϵͼ~~~~~~~~~~~~~~~~~~~~~~~~~~');
disp([num2str(all_nodes.nodes_n),'���ڵ�,','����',num2str(all_nodes.anchors_n),'��ê�ڵ�']);
disp('��ɫ*��ʾê�ڵ㣬��ɫO��ʾδ֪�ڵ�');
disp(['ͨ�Ű뾶:',num2str(comm_r),'m']);
disp(['ê�ڵ��ͨ�Ű뾶:',num2str(comm_r*anchor_comm_r),'m']);
disp(['ͨ��ģ��:',model]);
try
    disp(['DOI=',num2str(DOI)]);
catch
    %none
end
if anchor_comm_r==1
    disp(['�����ƽ����ͨ��Ϊ:',num2str(sum(sum(neighbor_matrix))/all_nodes.nodes_n)]);
    disp(['������ھ�ê�ڵ�ƽ����ĿΪ:',num2str(sum(sum(neighbor_matrix(1:all_nodes.nodes_n,1:all_nodes.anchors_n)))/all_nodes.nodes_n)]);
else
    disp(['δ֪�ڵ�����������ê�ڵ�ƽ����ĿΪ:',num2str(sum(sum(neighbor_matrix(all_nodes.anchors_n+1:all_nodes.nodes_n,1:all_nodes.anchors_n)))/(all_nodes.nodes_n-all_nodes.anchors_n))]);
    disp(['δ֪�ڵ�ͨ�������ڵ�δ֪�ڵ�ƽ����ĿΪ:',num2str(sum(sum(neighbor_matrix(all_nodes.anchors_n+1:all_nodes.nodes_n,all_nodes.anchors_n+1:all_nodes.nodes_n)))/(all_nodes.nodes_n-all_nodes.anchors_n))]); 
end

