function sigma = get_sigma(K,x,xe)
    if K'*(x-xe)<= 0
        sigma = 1;
    else 
        sigma = 2;
    end 
end