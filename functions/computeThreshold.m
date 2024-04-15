function JthSt = computeThreshold(optDeltaResults)
    % computeThreshold Computes the threshold value
    %
    %   JthSt = computeThreshold(optDeltaResults) Returns a threshold
    %   struct with all elements necessary to compute the threshold
    %   including the threshold itself.
    %
    %   JthSt has the following new field:
    %       'Jth'       Represents the threshold calculation using alpha given
    %       'JthMax'    Representes the threshold calculation for alpha = 1
    %
    % See also computeMaxDelta
    
    JthSt.alpha = optDeltaResults.alpha;
    JthSt.omega0 = optDeltaResults.optResults.omega0;
    JthSt.epsilonx = optDeltaResults.optResults.epsilonx;
    JthSt.dfmax = optDeltaResults.optResults.dfmax;
    JthSt.gamma = optDeltaResults.optResults.gamma;
    JthSt.delta = optDeltaResults.delta;
    JthMax =  sqrt(JthSt.gamma*JthSt.dfmax^2 +JthSt.epsilonx*JthSt.omega0^2);
    Jth = sqrt(JthSt.gamma*JthSt.dfmax^2 + JthSt.alpha*(JthSt.epsilonx*JthSt.omega0^2));
    
    JthSt.Jth = Jth;
    JthSt.JthMax = JthMax;
end