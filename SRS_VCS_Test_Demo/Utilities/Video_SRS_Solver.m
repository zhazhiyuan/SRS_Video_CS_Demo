function [ImgRec] = Video_SRS_Solver(ImgInput, x_ref1, x_ref2, Opts)

if ~isfield(Opts,'PatchSize')
    
    Opts.PatchSize        =       Opts.patch;
    
end

if ~isfield(Opts,'ArrayNo')
    
    Opts.ArrayNo         =      Opts.Sim;
    
end

if ~isfield(Opts,'ArrayNoRef1')
    
    Opts.ArrayNoRef1    =       Opts.Sim;
    
end
 

if ~isfield(Opts,'ArrayNoRef2')
    
    Opts.ArrayNoRef2    =     Opts.Sim;
    
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

ArrayNoRef1            =         Opts.ArrayNoRef1;

ArrayNoRef2            =         Opts.ArrayNoRef2;

AllArrayNo             =        ArrayNo + ArrayNoRef1 + ArrayNoRef2;


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

PatchSetRef1           =           zeros(PatchSize2, L, 'single');
%64*96945  
PatchSetRef2           =           zeros(PatchSize2, L, 'single');



Count                  =           0;

for i  = 1:PatchSize
    for j  = 1:PatchSize
        Count    =  Count+1;
        Patch    =  ImgInput(i:Hight-PatchSize+i,j:Width-PatchSize+j);
        Patch1   =  x_ref1(i:Hight-PatchSize+i,j:Width-PatchSize+j);
        Patch2   =  x_ref2(i:Hight-PatchSize+i,j:Width-PatchSize+j);        
        Patch    =  Patch(:);
        Patch1   =  Patch1(:);
        Patch2   =  Patch2(:);
        PatchSet(Count,:) =  Patch';
        PatchSetRef1(Count,:) =  Patch1';
        PatchSetRef2(Count,:) =  Patch2';
    end
end



PatchSetT              =          PatchSet';

PatchSetRef1T          =          PatchSetRef1'; 

PatchSetRef2T          =          PatchSetRef2'; %96945*64

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
        
        v             =               PatchSetT(Off, :); %1*64 
        
      CurPatchIndx    =               PatchSearchValue(PatchSetT, CurRow, CurCol, v, ArrayNo, SearchWin, I);
      
      CurPatchIndx(1) =               Off; %1
 
      Ref1PatchIndex  =               PatchSearchValue(PatchSetRef1T, CurRow, CurCol, v, ArrayNoRef1, SearchWin, I);
      
      Ref2PatchIndex  =               PatchSearchValue(PatchSetRef2T, CurRow, CurCol, v, ArrayNoRef2, SearchWin, I);
        
        CurArray      =               PatchSet(:, CurPatchIndx);
        
        Ref1Array     =               PatchSetRef1(:, Ref1PatchIndex); 
        
        Ref2Array     =               PatchSetRef2(:, Ref2PatchIndex); %64*5    

        Array         =              [CurArray Ref1Array Ref2Array];  
        
        U_i           =              getsvd(Array); % generate PCA basis

        DifArray      =               Array - repmat(v',1, AllArrayNo);
        
        Dis           =               sum(DifArray.^2)/(PatchSize2);
        
        wei           =              exp( -Dis./Opts.hp );
        
        Weight        =               wei./(sum(wei)+eps);  
        
        NLM_CurArray  =               sum(repmat(Weight,PatchSize2,1).* Array,2); %64*1      
                
        A0            =              U_i'*Array;
        
        B0            =              repmat(U_i'*NLM_CurArray,[1,AllArrayNo]);
            
        s0            =              A0 -    B0;

        s0            =              mean (s0.^2,2);

        s0            =              max  (0, s0-Opts.nSig^2);
        
        lam           =            repmat(((Opts.c*sqrt(2)*Opts.nSig^2)./(sqrt(s0) + Opts.eps)),[1,AllArrayNo]);

  %      lam                =              repmat ( Opts.lambda*Opts.nSig^2./(sqrt(s0)+eps),[1 ArrayNo]);
        
        tau           =              lam*Opts.Factor/Opts.mu; %   tau           =              lam*Opts.Factor/Opts.mu;

        Thre          =              sqrt(2*tau);

        Alpha         =              soft (A0-B0, Thre)+ B0; % Eq.(7)
         
        CurArray      =              U_i*Alpha;
        
       
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
return;

%toc;





