function [optparams,vectors,obsSysOpt] = optimizeobserver(obsSys,omega,alpha,etatildemax,etatildesteps,nuinfty)
    %Algorithm 2: Obtaining best bounds for the thresholds. ObsSys is a
    %struct with all observers
    
    ktildemax = ceil((etatildemax-(1+etatildesteps))/etatildesteps+1);
    etatildeVec = linspace(1+etatildesteps,etatildemax,ktildemax);
    
    %Vectors
    nuVec = nuinfty*ones(1,ktildemax);
    GammaVec = nuinfty*ones(1,ktildemax);
    Theta_a_Vec = nuinfty*ones(1,ktildemax);
    Theta_x_Vec = nuinfty*ones(1,ktildemax);
    BetaVec = nuinfty^(-1)*ones(1,ktildemax);
    
    p = length(obsSys);
    nutildeOpt = nuinfty*ones(1,p);

    ktildeOpt = ones(1,p);
    obsSysOut{ktildemax} = [];
    obsSysOpt{p} = [];
    vectors{p} = [];
    optparams{p} = [];
    
    %Obtaining the gains for each instance
    for l = 1:p
        for k = 1:ktildemax
            obsSysOut{k} = uncertfdiocontinuos2(obsSys{l},etatildeVec(k),omega,alpha);
            nuVec(k) = obsSysOut{k}.params.nujth;
            GammaVec(k) = obsSysOut{k}.params.gamma;
            Theta_a_Vec(k) = obsSysOut{k}.params.theta_a_bar;
            Theta_x_Vec(k) = obsSysOut{k}.params.theta_x_bar;
            BetaVec(k) = obsSysOut{k}.params.betabar;
        end
        [nutildeOpt(l),ktildeOpt(l)] = min(nuVec);
        obsSysOpt{l} = obsSysOut{ktildeOpt(l)};
        
        %Return the vectors 
        vectors{l}.etatilde = etatildeVec;
        vectors{l}.nutilde = nuVec;
        vectors{l}.Gamma = GammaVec;
        vectors{l}.Theta_a = Theta_a_Vec;
        vectors{l}.Theta_x = Theta_x_Vec;
        vectors{l}.Beta = BetaVec;
        
        %Return the parameters
        optparams{l}.eta = etatildeVec(ktildeOpt(l));
        optparams{l}.nu = nuVec(ktildeOpt(l));
        optparams{l}.ktilde = ktildeOpt(l);
        optparams{l}.gammad = GammaVec(ktildeOpt(l));
        optparams{l}.theta_a_bar = Theta_a_Vec(ktildeOpt(l));
        optparams{l}.theta_x_bar = Theta_x_Vec(ktildeOpt(l));
        optparams{l}.theta_a_bar = Theta_a_Vec(ktildeOpt(l));
        optparams{l}.betabar = BetaVec(ktildeOpt(l));

    end
end