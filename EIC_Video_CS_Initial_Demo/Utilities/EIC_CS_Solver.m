function [ImgRec] = EIC_CS_Solver(ImgInput, Opts)

if ~isfield(Opts,'PatchSize')
    
    Opts.PatchSize       =       Opts.patch;
    
end

if ~isfield(Opts,'ArrayNo')
    
    Opts.ArrayNo         =      Opts.Sim;
    
end

if ~isfield(Opts,'hp')
    
    Opts.hp             =       Opts.hr;
    
end

if ~isfield(Opts,'SlidingDis')
    
    Opts.SlidingDis    =        Opts.step;
    
    Opts.Factor        =        Opts.SlidingDis*Opts.ArrayNo;
    
end

if ~isfield(Opts,'SearchWin')
    
    Opts.SearchWin    =         Opts.Region ;
    
end


[Hight Width]          =         size(ImgInput);

SearchWin              =         Opts.SearchWin;

PatchSize              =         Opts.PatchSize;

PatchSize2             =         PatchSize*PatchSize;

ArrayNo                =         Opts.ArrayNo;

SlidingDis             =         Opts.SlidingDis;

%tau =  Opts.lambda*Opts.Factor/Opts.mu;
%Threshold = sqrt(2*tau);

N                      =          Hight-PatchSize+1;

M                      =          Width-PatchSize+1;

L                      =          N*M;

Row                    =          [1:SlidingDis:N];

Row                    =          [Row Row(end)+1:N];

Col                    =          [1:SlidingDis:M];

Col                    =          [Col Col(end)+1:M];

PatchSet               =           zeros(PatchSize2, L, 'single');

%WeiSet       =  zeros(PatchSize2, L, 'single');

Count                  =           0;

for i  = 1:PatchSize
    for j  = 1:PatchSize
        Count    =  Count+1;
        Patch  =  ImgInput(i:Hight-PatchSize+i,j:Width-PatchSize+j);
        Patch  =  Patch(:);
        PatchSet(Count,:) =  Patch';
    end
end



PatchSetT              =          PatchSet';

I                      =          (1:L);

I                      =          reshape(I, N, M);

NN                     =          length(Row);

MM                     =          length(Col);

ImgTemp                =          zeros(Hight, Width);

ImgWeight              =          zeros(Hight, Width);

PatchArray             =          zeros(PatchSize, PatchSize, ArrayNo);

for  i      =         1 : NN
    
    for  j       =      1 : MM
        
        
        CurRow        =                Row(i);
        
        CurCol        =                Col(j);
        
        Off           =               (CurCol-1)*N + CurRow;
        
 [CurPatchIndx, Wei]  =               PatchSearch(PatchSetT, CurRow, CurCol, Off, ArrayNo, SearchWin, I, Opts.hp);
        
        CurArray      =               PatchSet(:, CurPatchIndx);
        
         wei          =               repmat(Wei',size(CurArray, 1), 1); %49*60
         
 NLM_CurArray         =               repmat(sum(wei.*CurArray, 2), 1, ArrayNo); %49*60
        
            
        U_i                =              getsvd(CurArray); % generate PCA basis
        
        A0                 =              U_i'*CurArray;
        
        B0                 =              U_i'*NLM_CurArray;
            
        s0                 =              A0 -    B0;

        s0                 =              mean (s0.^2,2);

        s0                 =              max  (0, s0-Opts.nSig^2);
        
        lam                 =            repmat(((Opts.c1*sqrt(2)*Opts.nSig^2)./(sqrt(s0) + Opts.eps)),[1,ArrayNo]);

  %      lam                =              repmat ( Opts.lambda*Opts.nSig^2./(sqrt(s0)+eps),[1 ArrayNo]);
        
        tau                =              lam*Opts.Factor/Opts.mu;

        Thre               =              sqrt(2*tau);

        Alpha              =              soft (A0-B0, Thre)+ B0; % Eq.(7)
         
        CurArray           =              U_i*Alpha;
        
       
        for k = 1:ArrayNo
            PatchArray(:,:,k) = reshape(CurArray(:,k),PatchSize,PatchSize);
        end
        
        for k = 1:length(CurPatchIndx)
            RowIndx  =  ComputeRowNo((CurPatchIndx(k)), N);
            ColIndx  =  ComputeColNo((CurPatchIndx(k)), N);
            ImgTemp(RowIndx:RowIndx+PatchSize-1, ColIndx:ColIndx+PatchSize-1)    =   ImgTemp(RowIndx:RowIndx+PatchSize-1, ColIndx:ColIndx+PatchSize-1) + PatchArray(:,:,k)';
            ImgWeight(RowIndx:RowIndx+PatchSize-1, ColIndx:ColIndx+PatchSize-1)  =   ImgWeight(RowIndx:RowIndx+PatchSize-1, ColIndx:ColIndx+PatchSize-1) + 1;
        end

    end
end

%save ('IndcMatrix.mat', 'IndcMatrix');
ImgRec = ImgTemp./(ImgWeight+eps);

%toc;

return;



