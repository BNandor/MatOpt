load coordinates.mat;
figure;
hold on;
box on;
plot(all_nodes.true(1:all_nodes.anchors_n,1),all_nodes.true(1:all_nodes.anchors_n,2),'r*');
plot(all_nodes.true(all_nodes.anchors_n+1:all_nodes.nodes_n,1),all_nodes.true(all_nodes.anchors_n+1:all_nodes.nodes_n,2),'bo');
axis([0,all_nodes.square_L,0,all_nodes.square_L]);
title('�ڵ�ֲ�ͼ');
try %��������ֲ���������
    x=0:all_nodes.grid_L:all_nodes.square_L;
    set(gca,'XTick',x);
    set(gca,'XTickLabel',num2cell(x));
    set(gca,'YTick',x);
    set(gca,'YTickLabel',num2cell(x));
    grid on;
catch
    %none
end
try %����C������ı߽�
    square_L=all_nodes.square_L;
    area=all_nodes.area;
    plot([area(2) area(2)],[area(3) area(4)],'-k',[area(2) square_L],[area(3) area(3)],'-k',[area(2) square_L],[area(4) area(4)],'-k');    
catch
   %none 
end
disp('~~~~~~~~~~~~~~~~~~~~~~~~�ڵ�ֲ�ͼ~~~~~~~~~~~~~~~~~~~~~~~~~~');
disp([num2str(all_nodes.nodes_n),'���ڵ�,','����',num2str(all_nodes.anchors_n),'��ê�ڵ�']);
disp('��ɫ*��ʾê�ڵ㣬��ɫO��ʾδ֪�ڵ�');