function DV_hop()
    load '../Deploy Nodes/coordinates.mat';
    load '../Topology Of WSN/neighbor.mat'; 
    if all_nodes.anchors_n<3
        disp('ê�ڵ�����3��,DV-hop�㷨�޷�ִ��');
        return;
    end
    %~~~~~~~~~~~~~~~~~~~~~~~~~���·���㷨����ڵ������~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    shortest_path=neighbor_matrix;
    shortest_path=shortest_path+eye(all_nodes.nodes_n)*2;
    shortest_path(shortest_path==0)=inf;
    shortest_path(shortest_path==2)=0;
    for k=1:all_nodes.nodes_n
        for i=1:all_nodes.nodes_n
            for j=1:all_nodes.nodes_n
                if shortest_path(i,k)+shortest_path(k,j)<shortest_path(i,j)%min(h(i,j),h(i,k)+h(k,j))
                    shortest_path(i,j)=shortest_path(i,k)+shortest_path(k,j);
                end
            end
        end
    end
    if length(find(shortest_path==inf))~=0
        disp('���粻��ͨ...��Ҫ������ͨ��ͼ...����û�п����������');
        return;
    end
    %~~~~~~~~~~~~~~~~~~~~~~~~~��ÿ���ű�ڵ��У��ֵ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    anchor_to_anchor=shortest_path(1:all_nodes.anchors_n,1:all_nodes.anchors_n);
    for i=1:all_nodes.anchors_n
        hopsize(i)=sum(sqrt(sum(transpose((repmat(all_nodes.true(i,:),all_nodes.anchors_n,1)-all_nodes.true(1:all_nodes.anchors_n,:)).^2))))/sum(anchor_to_anchor(i,:));
    end
    %~~~~~~~~~~~~~~~~~~~~~~~ÿ��δ֪�ڵ㿪ʼ�����Լ���λ��~~~~~~~~~~~~~~~~~~~~
    for i=all_nodes.anchors_n+1:all_nodes.nodes_n
        obtained_hopsize=hopsize(find(shortest_path(i,1:all_nodes.anchors_n)==min(shortest_path(i,1:all_nodes.anchors_n))));%δ֪�ڵ��������ű���У��ֵ,���ܵ�����ê�ڵ��������ͬ�����
        unknown_to_anchors_dist=transpose(obtained_hopsize(1)*shortest_path(i,1:all_nodes.anchors_n));%���㵽ê�ڵ�ľ���=����*У��ֵ
        %~~~~~~~~~~��С���˷�~~~~~~~~~~~~~~~`
        A=2*(all_nodes.estimated(1:all_nodes.anchors_n-1,:)-repmat(all_nodes.estimated(all_nodes.anchors_n,:),all_nodes.anchors_n-1,1));
        anchors_location_square=transpose(sum(transpose(all_nodes.estimated(1:all_nodes.anchors_n,:).^2)));
        dist_square=unknown_to_anchors_dist.^2;
        b=anchors_location_square(1:all_nodes.anchors_n-1)-anchors_location_square(all_nodes.anchors_n)-dist_square(1:all_nodes.anchors_n-1)+dist_square(all_nodes.anchors_n);
        all_nodes.estimated(i,:)=transpose(A\b);
        all_nodes.anc_flag(i)=2;
    end
    %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    save '../Localization Error/result.mat' all_nodes comm_r;
end