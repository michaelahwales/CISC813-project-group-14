(define (problem northeye1)

    (:domain northeye)
    
    (:objects
        g11 g12 g13 g14 g15 g16 g17 g18 g21 g22 g23 g24 g25 g26 g27 g28 g31 g32 g33 g34 g35 g36 g37 g38 g41 g42 g43 g44 g45 g46 g47 g48 g51 g52 g53 g54 g55 g56 g57 g58 g61 g62 g63 g64 g65 g66 g67 g68 g71 g72 g73 g74 g75 g76 g77 g78 g81 g82 g83 g84 g85 g86 g87 g88 - landseg
        r11 r12 r13 r14 r15 r16 r17 r18 r21 r22 r23 r24 r25 r26 r27 r28 r31 r32 r33 r34 r35 r36 r37 r38 r41 r42 r43 r44 r45 r46 r47 r48 r51 r52 r53 r54 r55 r56 r57 r58 r61 r62 r63 r64 r65 r66 r67 r68 r71 r72 r73 r74 r75 r76 r77 r78 r81 r82 r83 r84 r85 r86 r87 r88 - riverseg
        muise wallace - adult
        musieHouse whoseHouse - building
        muiseFarm whoseFarm - farm
        trevor - sheep
    )
    
    (:init

        ;
        ;   g11 <-> g12 <-> g13 <-> g14 <-> r15 <-> g16 <-> g17 <-> g18
        ;    |       |       |       |       |       |       |       |
        ;   g21 <-> g22 <-> g23 <-> g24 <-> r25 <-> r26 <-> g27 <-> g28
        ;    |       |       |       |       |       |       |       |
        ;   g31 <-> g32 <-> g33 <-> g34 <-> g35 <-> r36 <-> g37 <-> g38
        ;    |       |       |       |       |       |       |       |
        ;   g41 <-> g42 <-> g43 <-> g44 <-> g45 <-> r46 <-> g47 <-> g48
        ;    |       |       |       |       |       |       |       |
        ;   g51 <-> g52 <-> g53 <-> g54 <-> g55 <-> r56 <-> r57 <-> g58
        ;    |       |       |       |       |       |       |       |
        ;   g61 <-> g62 <-> g63 <-> g64 <-> g65 <-> g66 <-> r67 <-> g68
        ;    |       |       |       |       |       |       |       |
        ;   g71 <-> g72 <-> g73 <-> g74 <-> g75 <-> g76 <-> r77 <-> g78
        ;    |       |       |       |       |       |       |       |
        ;   g81 <-> g82 <-> g83 <-> g84 <-> g85 <-> 816 <-> r87 <-> r88
        ;

        ;connect across rows
        (adj g11 g12) (adj g12 g11)
        (adj g12 g13) (adj g13 g12)
        (adj g13 g14) (adj g14 g13)
        (adj g14 r15) (adj r15 g14)
        (adj r15 g16) (adj g16 r15)
        (adj g16 g17) (adj g17 g16)
        (adj g17 g18) (adj g18 g17)
        (adj g21 g22) (adj g22 g21)
        (adj g22 g23) (adj g23 g22)
        (adj g23 g24) (adj g24 g23)
        (adj g24 r25) (adj r25 g24)
        (adj r25 r26) (adj r26 r25)
        (adj r26 g27) (adj g27 r26)
        (adj g27 g28) (adj g28 g27)
        (adj g31 g32) (adj g32 g31)
        (adj g32 g33) (adj g33 g32)
        (adj g33 g34) (adj g34 g33)
        (adj g34 g35) (adj g35 g34)
        (adj g35 r36) (adj r36 g35)
        (adj r36 g37) (adj g37 r36)
        (adj g37 g38) (adj g38 g37)
        (adj g41 g42) (adj g42 g41)
        (adj g42 g43) (adj g43 g42)
        (adj g43 g44) (adj g44 g43)
        (adj g44 g45) (adj g45 g44)
        (adj g45 r46) (adj r46 g45)
        (adj r46 g47) (adj g47 r46)
        (adj g47 g48) (adj g48 g47)
        (adj g51 g52) (adj g52 g51)
        (adj g52 g53) (adj g53 g52)
        (adj g53 g54) (adj g54 g53)
        (adj g54 g55) (adj g55 g54)
        (adj g55 r46) (adj r46 g55)
        (adj r46 r57) (adj r57 r46)
        (adj r57 g58) (adj g58 r57)
        (adj g61 g62) (adj g62 g61)
        (adj g62 g63) (adj g63 g62)
        (adj g63 g64) (adj g64 g63)
        (adj g64 g65) (adj g65 g64)
        (adj g65 g66) (adj g66 g65)
        (adj g66 r67) (adj r67 g66)
        (adj r67 g68) (adj g68 r67)
        (adj g71 g72) (adj g72 g71)
        (adj g72 g73) (adj g73 g72)
        (adj g73 g74) (adj g74 g73)
        (adj g74 g75) (adj g75 g74)
        (adj g75 g76) (adj g76 g75)
        (adj g76 r77) (adj r77 g76)
        (adj r77 g78) (adj g78 r77)
        (adj g81 g82) (adj g82 g81)
        (adj g82 g83) (adj g83 g82)
        (adj g83 g84) (adj g84 g83)
        (adj g84 g85) (adj g85 g84)
        (adj g85 g86) (adj g86 g85)
        (adj g86 r87) (adj r87 g86)
        (adj r87 r88) (adj r88 r87)

        ;connect down columns
        (adj g11 g21) (adj g21 g11)
        (adj g21 g31) (adj g31 g21)
        (adj g31 g41) (adj g41 g31)
        (adj g41 g51) (adj g51 g41)
        (adj g51 g61) (adj g61 g51)
        (adj g61 g71) (adj g71 g61)
        (adj g71 g81) (adj g81 g71)
        (adj g12 g22) (adj g22 g12)
        (adj g22 g32) (adj g32 g22)
        (adj g32 g42) (adj g42 g32)
        (adj g42 g52) (adj g52 g42)
        (adj g52 g62) (adj g62 g52)
        (adj g62 g72) (adj g72 g62)
        (adj g72 g82) (adj g82 g72)
        (adj g13 g23) (adj g23 g13)
        (adj g23 g33) (adj g33 g23)
        (adj g33 g43) (adj g43 g33)
        (adj g43 g53) (adj g53 g43)
        (adj g53 g63) (adj g63 g53)
        (adj g63 g73) (adj g73 g63)
        (adj g73 g83) (adj g83 g73)
        (adj g14 g24) (adj g24 g14)
        (adj g24 g34) (adj g34 g24)
        (adj g34 g44) (adj g44 g34)
        (adj g44 g54) (adj g54 g44)
        (adj g54 g64) (adj g64 g54)
        (adj g64 g74) (adj g74 g64)
        (adj g74 g84) (adj g84 g74)
        (adj r15 r25) (adj r25 r15)
        (adj r25 g35) (adj g35 r25)
        (adj g35 g45) (adj g45 g35)
        (adj g45 g55) (adj g55 g45)
        (adj g55 g65) (adj g65 g55)
        (adj g65 g75) (adj g75 g65)
        (adj g75 g85) (adj g85 g75)
        (adj g16 r26) (adj r26 g16)
        (adj r26 r36) (adj r36 r26)
        (adj r36 r46) (adj r46 r36)
        (adj r46 r46) (adj r46 r46)
        (adj r46 g66) (adj g66 r46)
        (adj g66 g76) (adj g76 g66)
        (adj g76 g86) (adj g86 g76)
        (adj g17 g27) (adj g27 g17)
        (adj g27 g37) (adj g37 g27)
        (adj g37 g47) (adj g47 g37)
        (adj g47 r57) (adj r57 g47)
        (adj r57 r67) (adj r67 r57)
        (adj r67 r77) (adj r77 r67)
        (adj r77 r87) (adj r87 r77)
        (adj g18 g28) (adj g28 g18)
        (adj g28 g38) (adj g38 g28)
        (adj g38 g48) (adj g48 g38)
        (adj g48 g58) (adj g58 g48)
        (adj g58 g68) (adj g68 g58)
        (adj g68 g78) (adj g78 g68)
        (adj g78 r88) (adj r88 g78)
        

        ;locations of buildings
        (location musieHouse g63)
        (location whoseHouse g43)
        
        ;locations of farms
        (location muiseFarm g83)
        (location whoseFarm g75)
        
        ;locations of villagers
        (location muise g81)
        (location wallace g11)

        ;location of livestock
        (location trevor g75)

        ;villager related fluents
        (tired muise)
        (tired wallace)
        (owns muise musieHouse)
        (owns muise muiseFarm)
        (owns wallace whoseHouse)
        (owns wallace whoseFarm)

        
    )
    
    (:goal
        (and
            (location trevor g83)       ; the sheep known as 'trevor' should be in muiseFarm
            (tended trevor)             ; trevor the sheep should be tended to
        )
    )
    
)