needsPackage("Desingularization");

prunedMapOfRings = method();
prunedMapOfRings(RingMap) := (F) -> (
    R := F.source;
    S := F.target;

    PRtoR := prunedringMapInv(R);
    StoPS := prunedringMap(S);
    PR := PRtoR.source;
    PS := StoPS.target;
    PF := StoPS * F * PRtoR;

    return PF;
);

baseChangeRingMap = method();
baseChangeRingMap(RingMap, Ring) := (F, L) -> (
    PF := F; -- prunedMapOfRings(F);
    PR := PF.source;
    PS := PF.target;

    -- step 2: make the corresponding polynomial rings over which to define LR, LS
    LpolyR := L[PR.gens];
    LpolyS := L[PS.gens];

    -- step 3: base change the defining ideals
    LpolyR;
    LRideal := ideal(sub(0, LpolyR));
    if isQuotientRing(PR) then (
        LRideal = sub(PR.ideal,LpolyR);
    );
    LpolyS;
    LSideal := ideal(sub(0, LpolyS));
    if isQuotientRing(PS) then (
        LSideal = sub(PS.ideal,LpolyS);
    );

    -- step 4: write the quotients
    LR := LpolyR/LRideal;
    LS := LpolyS/LSideal;

    originalEntries := flatten(entries(PF.matrix));
    Lentries := {};
    for i from 0 to #(originalEntries)-1 do (
        Lentries = append(Lentries, sub((originalEntries#i), LS));
    );

    LF := map(LS,LR,Lentries);

    return LF;
);