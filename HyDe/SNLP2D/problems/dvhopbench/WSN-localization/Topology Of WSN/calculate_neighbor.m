function calculate_neighbor(comm_r,anchor_comm_r,model,DOI)
% comm_r:ͨ�Ű뾶
% anchor_comm_r:ê�ڵ���ͨ�Ű뾶��δ֪�ڵ�ͨ�Ű뾶�ı���
% model:ѡ����ͨ��ģ��
% DOI���������ȣ�modelΪ 'DOI Model','RIM Model'ʱ��Ч,������ȱʡ
    pwd
    load '../Deploy Nodes/coordinates.mat';
    load 'Transmission Model/Parameters_Of_Models.mat';
    pwd
    directory=pwd;
    if nargin==2
        model='Regular Model';
    end
    pwd
    cd(['Transmission Model/Regular Model']);
    pwd
    RSS_threshold=dist2rss(comm_r);
    SendingPower=RSS_threshold+Pl_d0+10*eta*log10(comm_r*anchor_comm_r/d0);
    cd(['../',model]);
    
    try
        for i=1:all_nodes.nodes_n
            dist=sqrt(sum(transpose((repmat(all_nodes.true(i,:),all_nodes.nodes_n-1,1)-all_nodes.true([1:i-1,i+1:all_nodes.nodes_n],:)).^2)));
            RSS=dist2rss(dist);
            if i<=all_nodes.anchors_n
                RSS(1:all_nodes.anchors_n-1)=RSS(1:all_nodes.anchors_n-1)+(SendingPower-Pt);
            else
                RSS(1:all_nodes.anchors_n)=RSS(1:all_nodes.anchors_n)+(SendingPower-Pt);
            end
            neighbor_i=RSS>RSS_threshold;
            neighbor_matrix(i,:)=[neighbor_i(1:i-1),0,neighbor_i(i:all_nodes.nodes_n-1)];
            neighbor_rss(i,:)=[RSS(1:i-1),SendingPower,RSS(i:all_nodes.nodes_n-1)];        
            neighbor_dist(i,:)=[dist(1:i-1),0,dist(i:all_nodes.nodes_n-1)];
        end
    catch
        for i=1:all_nodes.nodes_n
            dist=sqrt(sum(transpose((repmat(all_nodes.true(i,:),all_nodes.nodes_n-1,1)-all_nodes.true([1:i-1,i+1:all_nodes.nodes_n],:)).^2)));
            if DOI==0
                K_i=ones(1,all_nodes.nodes_n-1);
            else                
                K(1)=1;
                for k=2:360
                    doi=unifrnd(-DOI,DOI,1,1);
                    K(k)=K(k-1)+doi;
                end
                while abs(K(1)-K(360))>DOI
                    for k=2:360
                        doi=unifrnd(-DOI,DOI,1,1);
                        K(k)=K(k-1)+doi;
                    end
                end
                K_i=K(unidrnd(360,1,all_nodes.nodes_n-1)); 
            end
            RSS=dist2rss(dist,K_i);
            if i<=all_nodes.anchors_n
                RSS(1:all_nodes.anchors_n-1)=RSS(1:all_nodes.anchors_n-1)+(SendingPower-Pt);
            else
                RSS(1:all_nodes.anchors_n)=RSS(1:all_nodes.anchors_n)+(SendingPower-Pt);
            end
            neighbor_i=RSS>RSS_threshold;
            neighbor_matrix(i,:)=[neighbor_i(1:i-1),0,neighbor_i(i:all_nodes.nodes_n-1)];
            neighbor_rss(i,:)=[RSS(1:i-1),SendingPower,RSS(i:all_nodes.nodes_n-1)];
            neighbor_dist(i,:)=[dist(1:i-1),0,dist(i:all_nodes.nodes_n-1)];
        end
    end
    cd(directory);
    try
        save neighbor.mat neighbor_matrix neighbor_rss neighbor_dist comm_r anchor_comm_r model DOI;
    catch
        save neighbor.mat neighbor_matrix neighbor_rss neighbor_dist comm_r anchor_comm_r model;
    end
end