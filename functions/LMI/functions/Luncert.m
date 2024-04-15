function [S,objective] =Luncert()
        %     Linfty restriction for uncertainty
        Restr = [Restr,gamma3>=tol];
        for j=1:M
            s11= P{1,j}*A{1,j} + A{1,j}'*P{1,j} + C{1,j}'*Wsigma{1,j} + Wsigma{1,j}'*C{1,j} + eta*P{1,j};
            s12 = P{1,j}*Mb{1,j};
            s21 = s12';
            s22 = -gamma3*Ie2;
            S = [s11,s12;s21,s22];
            Restr=[Restr, S <=-tol];
        end
        objective =  gamma3;
    end
    
      function [S,objective] =Luncert2()
        %     Linfty restriction for uncertainty
        Restr = [Restr,gamma3>=tol];
        for j=1:M
            s11= P{1,j}*A{1,j} + A{1,j}'*P{1,j} + C{1,j}'*Wsigma{1,j} + Wsigma{1,j}'*C{1,j} + eta*P{1,j} +  C{1,j}'*C{1,j};
            s12 = 500*P{1,j};
            s21 = s12';
            s22 = -gamma3*Ie2;
            S = [s11,s12;s21,s22];
            Restr=[Restr, S <=-tol];
        end
        objective =  gamma3;
      end