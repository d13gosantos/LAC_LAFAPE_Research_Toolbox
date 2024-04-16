function [MX,NX] = fun_full_rank (GXo)
    
    % Using the full rank factorization based on
    % R. Piziak and P. Odell, Full rank factorization of matrices,
    % Mathemat-ics Magazine, vol. 72, p. 11, 06 1999.
    
    % Use elementary row operations to reduce GXo to row reduced echelon form
    GX = rref(GXo);
    % Number of rows and columns of GX
    nL = size(GX,1);
    nC = size(GX,2);
    % Construct a matrix MX from the nonzero rows of GX,
    % placing them in MX in the same order as they appear in GX.
    MX = [];
    for j=1:nC
        test=0;
        test=sum(abs(GX(:,j)));
        if test==1
            MX = [MX, GXo(:,j)];
        end
    end
    % Number of columns of MX
    nCMX = size(MX,2);
    
    % Construct a matrix NX from the columns of GXo that correspond to the columns
    % with the leading ones in GX, placing them in NX in the same order as they appear in GXo.
    NX = [];
    for i=1:nL
        test=0;
        test=sum(abs(GX(i,:)));
        if test>0
            NX = [NX;GX(i,:)];
        end
    end
    if size(NX,1)<nCMX
        NX = [NX;zeros(nCMX-size(NX,1),size(NX,2))];
    end
    
    
end