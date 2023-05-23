function [Localization_error,Unresolve_num]=calculate_localization_error(comm_r)
% ������λ�㷨�Ķ�λ����ͼ
% ê�ڵ㲻���ڶ�λ����,�ú�ɫ*��ʾ,
% δ֪�ڵ��е��ܱ���λ(��ɫO��ʾ��Щ�ڵ��Ĺ���λ��,��ɫ-��ʾ��Щ�ڵ��Ĺ���λ�õ���ʵλ�õ�����)
% δ֪�ڵ��еĲ��ܱ���λ(��ɫO��ʾ,��Щ�ڵ㲻���ڶ�λ����)
% Localization_error:ƽ����λ����--����λ�õ���ʵλ�õ�ŷʽ������ͨ�Ű뾶�ı�ֵ
% Unresolved_num:��������Щ������������Ϊ�ھӽ��ٲ��ܱ���λ����Щ������Ŀ
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    load result.mat;
    figure;
    hold on;
    box on;
    plot(all_nodes.true(1:all_nodes.anchors_n,1),all_nodes.true(1:all_nodes.anchors_n,2),'r*');%the anchors
    Unresolved_unknown_nodes_index=find(all_nodes.anc_flag==0);%the unresolved unknown nodes
    Unresolved_num=length(Unresolved_unknown_nodes_index);
    plot(all_nodes.true(Unresolved_unknown_nodes_index,1),all_nodes.true(Unresolved_unknown_nodes_index,2),'ko');
    resolved_unknown_nodes_index=find(all_nodes.anc_flag==2);%estimated locations of the resolved unkonwn nodes
    plot(all_nodes.estimated(resolved_unknown_nodes_index,1),all_nodes.estimated(resolved_unknown_nodes_index,2),'bo');
    plot(transpose([all_nodes.estimated(resolved_unknown_nodes_index,1),all_nodes.true(resolved_unknown_nodes_index,1)]),...
        transpose([all_nodes.estimated(resolved_unknown_nodes_index,2),all_nodes.true(resolved_unknown_nodes_index,2)]),'b-');
    axis auto;
    title('��λ����ͼ');    
    try %���������ֲ���������
        x=0:all_nodes.grid_L:all_nodes.square_L;
        set(gca,'XTick',x);
        set(gca,'XTickLabel',num2cell(x));
        set(gca,'YTick',x);
        set(gca,'YTickLabel',num2cell(x));
        grid on;
    catch
        %none
    end    
    %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    disp('~~~~~~~~~~~~~~~~~~~~~~~~��λ����ͼ~~~~~~~~~~~~~~~~~~~~~~~~~~');
    disp('��ɫ*��ʾê�ڵ�');
    disp('��ɫO��ʾδ֪�ڵ��Ĺ���λ��');
    disp('��ɫO��ʾ���ܱ���λ��δ֪�ڵ�');
    disp('��ɫ-��ʾδ֪�ڵ��Ķ�λ����(����δ֪�ڵ��Ĺ���λ�ú���ʵλ��)');
    disp(['һ��',num2str(all_nodes.nodes_n),'���ڵ�:',num2str(all_nodes.anchors_n),'��ê�ڵ�,',...
        num2str(all_nodes.nodes_n-all_nodes.anchors_n),'��δ֪�ڵ�,',num2str(Unresolved_num),'�����ܱ���λ��δ֪�ڵ�']);
    Localization_error=sum(sqrt(sum(transpose((all_nodes.estimated(resolved_unknown_nodes_index,:)-all_nodes.true(resolved_unknown_nodes_index,:)).^2))))/...
        (length(resolved_unknown_nodes_index)*comm_r);
    disp(['��λ����Ϊ',num2str(Localization_error)]);
end