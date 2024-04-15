function [xeArray,kappaFeas] = xearray(kappaArray,switchingfunc)
    k = 1;
    for i = 1:length(kappaArray)
        obsSysOut2 = switchingfunc(kappaArray(i));
        if obsSysOut2.params.feasible == 1
            kappaFeas(k) = kappaArray(i);
            xeArray(:,k) = obsSysOut2.xe;
            k = k+1;
        end
    end
end
    % for i = 1:length(kappaArray)
    %     obsSysOut2 = sampledswitchinglawalpha(obsControl,etaControl,Tmax,tscale,...
    % %                                             kappaArray(i),fbound,alphamin);
    %     obsSysOut2 = sampledswitchinglaw(obsControl,etaControl,Tmax,tscale,kappa,fbound);
    %     if obsSysOut2.params.feasible == 1
    %         kappaFeas(k) = kappaArray(i);
    %         xeArray(:,k) = obsSysOut2.xe;
    %         k = k+1;
    %     end
    % end