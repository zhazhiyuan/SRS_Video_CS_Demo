
function [reconstructed_image, PSN_Result,FSIM_Result,SSIM_Result,All_PSNR,j, dif] = Video_SRS_Main(Opts,i, cur_no,ref1,ref2)

row                                  =                              Opts.row;

col                                  =                              Opts.col;

Phi                                  =                              Opts.Phi;

x_org                                =                              Opts.org {cur_no};

IterNum                              =                              Opts.IterNum;


x_initial                            =                              Opts.initial{i,cur_no};

block_size                           =                              Opts.block_size;

Inloop                               =                              Opts.Inloop;

mu                                   =                              Opts.mu;

x_ref1                               =                              Opts.initial{i, ref1};

x_ref2                               =                              Opts.initial{i, ref2};

x                                    =                              im2col(x_initial, [block_size block_size], 'distinct');

 
c                                    =                              zeros(size(x));

ATA                                  =                              Phi'*Phi;

ATy                                  =                              Phi'*Opts.y{cur_no};

IM                                   =                              eye(size(ATA));

All_PSNR                             =                              zeros(1,IterNum);

 GSR_NLS_Results                     =                             cell (1,IterNum);   
    

for j = 1:IterNum
    
    x_hat            =                  x;
    
    g                =                  col2im(x-c, [block_size block_size],[row col], 'distinct');  
    
    w                =                  Video_SRS_Solver (g, x_ref1, x_ref2, Opts );
    
    w_bar            =                  im2col(w, [block_size block_size], 'distinct');
    
    f                =                  w_bar; 
    

    for kk = 1:Inloop
         
        
         d = ATA*x_hat - ATy +  mu*(x_hat - f - c);
        
        dTd = d'*d;
        
        G = d'*(ATA + mu*IM)*d;
        
        Step_Matrix = abs(dTd./G); 
        
        Step_length = diag(diag(Step_Matrix));
        
        x = x_hat - d*Step_length;
        
        x_hat = x;  
        
    end
    
    c                       =                   c - (x -  f);
   
    x_img                   =                   col2im(x, [block_size block_size],[row col], 'distinct');

    All_PSNR(j)             =                   csnr( x_img, x_org, 0, 0);
    
    GSR_NLS_Results{j}      =                      x_img;
    
    fprintf('SRS Video CS ALgorithm: IterNum = %d, PSNR = %f\n', j, csnr(x_img,x_org,0,0));
    
    
    
    
     if j>1
         
              dif      =  norm(abs(GSR_NLS_Results{j}) - abs(GSR_NLS_Results{j-1}),'fro')/norm(abs(GSR_NLS_Results{j-1}), 'fro');
    
        if  All_PSNR(j) -All_PSNR(j-1) <0% <= Opts.err
            break;
        end
        
     end

end

reconstructed_image                      =                   x_img;

PSN_Result                               =                   csnr(reconstructed_image,x_org,0,0);

FSIM_Result                              =                   FeatureSIM(reconstructed_image,x_org);

SSIM_Result                              =                   cal_ssim(reconstructed_image,x_org,0,0);

end

