function mCombination = mkconvcombination(simplex, matrices)
    %%%Make convex combination of a set (cell) of matrices 
    % Simplex is an array
    mCombination = 0;
    for i = 1:length(simplex)
        mCombination = mCombination + simplex(i)*matrices{i};
    end
end