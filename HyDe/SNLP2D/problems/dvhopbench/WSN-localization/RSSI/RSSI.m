function RSSI()
% δ֪�ڵ������ھ�ê�ڵ����ж�λ��û���ھ�ê�ڵ���δ֪�ڵ��޷���λ
% ���ݽ����ź�ǿ��ת��Ϊ���롣���򴫲�ģ���µõ��ľ�����ʵ�ʾ���û������
% ������ͨ��ģ���£����򴫲�ģ���µõ��ľ�����ʵ�ʾ�����������
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    load '../Deploy Nodes/coordinates.mat';
    load '../Topology Of WSN/neighbor.mat';    
    directory=cd('../Topology Of WSN/Transmission Model/');
    disp(directory)
    cd(model);
    unknown_node_index=all_nodes.anchors_n+1:all_nodes.nodes_n;
    for i=unknown_node_index
        neighboring_anchor_index=intersect(find(neighbor_matrix(i,:)==1),find(all_nodes.anc_flag==1));%ֻ�����ھ�ê�ڵ����ж�λ
        neighboring_anchor_n=length(neighboring_anchor_index);
        if neighboring_anchor_n>=3
            try
                dist=rss2dist(neighbor_rss(neighboring_anchor_index,i),1);
            catch
                dist=rss2dist(neighbor_rss(neighboring_anchor_index,i));
            end
            neighboring_anchor_location=all_nodes.estimated(neighboring_anchor_index,:);
            %~~~~~~~~~~~~~~~~~~~~~~~~~���߲���������С���˷���
            A=2*(neighboring_anchor_location(1:neighboring_anchor_n-1,:)-repmat(neighboring_anchor_location(neighboring_anchor_n,:),neighboring_anchor_n-1,1));
            neighboring_anchor_location_square=transpose(sum(transpose(neighboring_anchor_location.^2)));
            dist_square=dist.^2;
            b=neighboring_anchor_location_square(1:neighboring_anchor_n-1)-neighboring_anchor_location_square(neighboring_anchor_n)-dist_square(1:neighboring_anchor_n-1)+dist_square(neighboring_anchor_n);
            all_nodes.estimated(i,:)=transpose(A\b);
            all_nodes.anc_flag(i)=2;
        end
    end
    %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    cd(directory);
    save '../Localization Error/result.mat' all_nodes comm_r;
end