function [P]=edmonds2(W,b)
%
% Given a weight matrix W, this function runs unipartite Edmonds' algorithm
% b times, each time removing used edges to get a b-matching.
% ====================== TO DO FIRST =========================
%             DOWNLOAD KOLMOGOROV blossomV ALGORITHM
%                   running get_blossom.sh
% ============================================================
% Inputs:
%   W: n x n symetric matrix
%   b: The function returns a b-matching
%

zz = pwd;
n  = size(W,1);
W  = W-diag(diag(W));
W  = (max(max(W))-W)/(max(max(W))-min(min(W)));
W  = W-diag(diag(W));
W  = round(W*1000*n*n);
W1 = W;
P  = zeros(size(W));

for iter=1:b
  nedges=0;
  for i=1:n
    for j=(i+1):n
      if (P(i,j)==0)
        nedges = nedges+1;
      end
    end
  end
  fid = fopen('GRAPH.txt','w');
  fprintf(fid,'c graph in DIMACS format \n');
  fprintf(fid,'p edge %d %d\n',n,nedges);
  for i=1:n
    for j=(i+1):n
      if (P(i,j)==0)
        fprintf(fid,'e %d %d %d\n',i,j,W1(i,j));
      end
    end
  end
  fclose(fid);
  system('./blossom5 -V -e GRAPH.txt -w OUTPUT.txt');
  Ps = load('OUTPUT.txt');
  Ps = Ps + 1;
  P1 = zeros(size(W1));
  for i=2:size(Ps,1)
    P1(Ps(i,1),Ps(i,2)) = 1;
    P1(Ps(i,2),Ps(i,1)) = 1;
  end
  P = max(P,P1);
end

cd(zz)
