% Labels = szy_cluster_dp(dist, k, isPlot) 或 Labels = szy_cluster_dp(dist, k)
% 基于密度峰值的聚类算法，dist是所有数据点的距离矩阵，k是要聚类的目标数，
% isPlot==true表示需要画图，isPlot==false表示不要画图，默认值是false.
% Labels是一个2xSize(dist, 1)大小的矩阵，每一列对应一个数据点，
% 第一行表示没有halo控制的聚类结果，第二行表示有halo控制的聚类结果。
function Labels = szy_cluster_dp(dist, k, isPlot)
% disp('The only input needed is a distance matrix file')
% disp('The format of this file should be: ')
% disp('Column 1: id of element i')
% disp('Column 2: id of element j')
% disp('Column 3: dist(i,j)')
% mdist=input('name of the distance matrix file\n','s');
% disp('Reading input distance matrix')
% xx=load(mdist);
% xx = load('example_distances.dat');
% ND=max(xx(:,2));
% NL=max(xx(:,1));
% if (NL>ND)
%   ND=NL;
% end
% N=size(xx,1);
% for i=1:ND
%   for j=1:ND
%     dist(i,j)=0;
%   end
% end
% for i=1:N
%   ii=xx(i,1);
%   jj=xx(i,2);
%   dist(ii,jj)=xx(i,3);
%   dist(jj,ii)=xx(i,3);
% end
if nargin == 2
    isPlot = false;
end
%t = zeros(1000, 1);
N = size(dist, 1) * (size(dist, 2) - 1) / 2;
ND = size(dist, 1);
percent=2.0;
% fprintf('average percentage of neighbours (hard coded): %5.6f\n', percent);

position=round(N*percent/100);
% sda=sort(xx(:,3));
sda = sort(squareform(dist));
dc=sda(position);

% fprintf('Computing Rho with gaussian kernel of radius: %12.6f\n', dc);

rho = [];
for i=1:ND
    rho(i)=0.;
end
%
% Gaussian kernel
%
for i=1:ND-1
    for j=i+1:ND
        rho(i)=rho(i)+exp(-(dist(i,j)/dc)*(dist(i,j)/dc));
        rho(j)=rho(j)+exp(-(dist(i,j)/dc)*(dist(i,j)/dc));
    end
end
%
% "Cut off" kernel
%
%for i=1:ND-1
%  for j=i+1:ND
%    if (dist(i,j)<dc)
%       rho(i)=rho(i)+1.;
%       rho(j)=rho(j)+1.;
%    end
%  end
%end

maxd=max(max(dist));

[rho_sorted,ordrho]=sort(rho,'descend');
delta(ordrho(1))=-1.;
nneigh(ordrho(1))=0;

for ii=2:ND
    delta(ordrho(ii))=maxd;
    for jj=1:ii-1
        if(dist(ordrho(ii),ordrho(jj))<delta(ordrho(ii)))
            delta(ordrho(ii))=dist(ordrho(ii),ordrho(jj));
            nneigh(ordrho(ii))=ordrho(jj);
        end
    end
end
delta(ordrho(1))=max(delta(:));
% disp('Generated file:DECISION GRAPH')
% disp('column 1:Density')
% disp('column 2:Delta')

% fid = fopen('DECISION_GRAPH', 'w');
% for i=1:ND
%     fprintf(fid, '%6.2f %6.2f\n', rho(i),delta(i));
% end

% disp('Select a rectangle enclosing cluster centers')
% scrsz = get(0,'ScreenSize');
% figure('Position',[6 72 scrsz(3)/4. scrsz(4)/1.3]);
for i=1:ND
    ind(i)=i;
    gamma(i)=rho(i)*delta(i);
end
if isPlot
    subplot(2,1,1)
    tt=plot(rho(:),delta(:),'o','MarkerSize',5,'MarkerFaceColor','k','MarkerEdgeColor','k');
    title ('Decision Graph','FontSize',15.0)
    xlabel ('\rho')
    ylabel ('\delta')
end


% subplot(2,1,1)
% rect = getrect(1);
% rhomin=rect(1);
% deltamin=rect(2);
% NCLUST=0;
NCLUST = k;
for i=1:ND
    cl(i)=-1;
end
[B, Index] = sort(gamma, 'descend');
% cl是每个数据点的所属类别号
% icl是所有聚类中心的序号
icl = Index(1:k);
cl(Index(1:k)) = 1:k;
% for i=1:ND
%   if ( (rho(i)>rhomin) && (delta(i)>deltamin))
%       % 修改上面的判断条件，根据降序排列后gamma的前几个点变化情况来决定类别。
%      NCLUST=NCLUST+1;
%      cl(i)=NCLUST;
%      icl(NCLUST)=i;
%   end
% end
% fprintf('NUMBER OF CLUSTERS: %i \n', NCLUST);
% disp('Performing assignation')

%assignation
for i=1:ND
    if (cl(ordrho(i))==-1)
        cl(ordrho(i))=cl(nneigh(ordrho(i)));
    end
end
%halo
for i=1:ND
    halo(i)=cl(i);
end
if (NCLUST>1)
    for i=1:NCLUST
        bord_rho(i)=0.;
    end
    for i=1:ND-1
        for j=i+1:ND
            if ((cl(i)~=cl(j))&& (dist(i,j)<=dc))
                rho_aver=(rho(i)+rho(j))/2.;
                if (rho_aver>bord_rho(cl(i)))
                    bord_rho(cl(i))=rho_aver;
                end
                if (rho_aver>bord_rho(cl(j)))
                    bord_rho(cl(j))=rho_aver;
                end
            end
        end
    end
    for i=1:ND
        if (rho(i)<bord_rho(cl(i)))
            halo(i)=0;
        end
    end
end
for i=1:NCLUST
    nc=0;
    nh=0;
    for j=1:ND
        if (cl(j)==i)
            nc=nc+1;
        end
        if (halo(j)==i)
            nh=nh+1;
        end
    end
    %     fprintf('CLUSTER: %i CENTER: %i ELEMENTS: %i CORE: %i HALO: %i \n', i,icl(i),nc,nh,nc-nh);
end

if isPlot
    cmap=colormap;
    for i=1:NCLUST
        ic=int8((i*64.)/(NCLUST*1.));
        subplot(2,1,1)
        hold on
        plot(rho(icl(i)),delta(icl(i)),'o','MarkerSize',8,'MarkerFaceColor',cmap(ic,:),'MarkerEdgeColor',cmap(ic,:));
    end
    subplot(2,1,2)
    disp('Performing 2D nonclassical multidimensional scaling')
    Y1 = mdscale(dist, 2, 'criterion','metricstress');
    plot(Y1(:,1),Y1(:,2),'o','MarkerSize',2,'MarkerFaceColor','k','MarkerEdgeColor','k');
    title ('2D Nonclassical multidimensional scaling','FontSize',15.0)
    xlabel ('X')
    ylabel ('Y')
    for i=1:ND
        A(i,1)=0.;
        A(i,2)=0.;
    end
    for i=1:NCLUST
        nn=0;
        ic=int8((i*64.)/(NCLUST*1.));
        for j=1:ND
            if (halo(j)==i)
                nn=nn+1;
                A(nn,1)=Y1(j,1);
                A(nn,2)=Y1(j,2);
            end
        end
        hold on
        plot(A(1:nn,1),A(1:nn,2),'o','MarkerSize',2,'MarkerFaceColor',cmap(ic,:),'MarkerEdgeColor',cmap(ic,:));
    end
end

%for i=1:ND
%   if (halo(i)>0)
%      ic=int8((halo(i)*64.)/(NCLUST*1.));
%      hold on
%      plot(Y1(i,1),Y1(i,2),'o','MarkerSize',2,'MarkerFaceColor',cmap(ic,:),'MarkerEdgeColor',cmap(ic,:));
%   end
%end
% faa = fopen('CLUSTER_ASSIGNATION', 'w');
% disp('Generated file:CLUSTER_ASSIGNATION')
% disp('column 1:element id')
% disp('column 2:cluster assignation without halo control')
% disp('column 3:cluster assignation with halo control')
for i=1:ND
    %     fprintf(faa, '%i %i %i\n',i,cl(i),halo(i));
    Labels(:, i) = [cl(i) halo(i)]';
end
end
