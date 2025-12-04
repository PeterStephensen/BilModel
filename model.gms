$offsymxref offsymlist
option limcol =0, limrow=0;
option solprint=off;
option decimals=8;

#--------------------------------------------------
# BY=1 betyder By. BY=0 betyder Land 
#--------------------------------------------------
$setlocal BY 0;  

Sets 
  t         "Tidsperioder"                                  /0*50/
  t0[t]     "Første tidsperiode"
  t1[t]     "Første endogene tidsperiode (Basisår)" 
  tT[t]     "Sidste tidsperiode T"
  txT[t]    "Undtagen sidste tidsperiode T"
  txTT[t]   "Undtagen sidste og næstsidste tidsperiode T"
  tx0[t]    "Undtagen første tidsperiode"
  tx1[t]    "Undtagen første endogene tidsperiode"
  tx0T[t]   "Undtagen første og sidste tidsperiode"
  tx1T[t]   "Undtagen første endogene og sidste tidsperiode"
  
  a         "Bygningsaldre"                                 /0*25/
  a0[a]     "Alder for nye bygninger"                       
  ax0[a]    "Undtagen Alder for nye bygninger"                       
  aA[a]     "Højeste bygningsalder A"                         
  axA[a]    "Undtagen højeste bygningsalder A"
  ax0A[a]   "Undtagen 0 og højeste bygningsalder A"
;  


t0(t)     = yes$(ord(t) = 1);
t1(t)     = yes$(ord(t) = 2);
tT(t)     = yes$(ord(t) = card(t));
txT(t)    = yes$(ord(t) < card(t));
txTT(t)   = yes$(ord(t) < card(t)-1);
tx0(t)    = yes$(ord(t) > 1);
tx1(t)    = yes$(ord(t) > 2);
tx0T(t)   = yes$(ord(t) < card(t) and ord(t) > 1);
tx1T(t)   = yes$(ord(t) < card(t) and ord(t) > 2);

a0(a)     = yes$(ord(a) = 1);
ax0(a)    = yes$(ord(a) > 1);
aA(a)     = yes$(ord(a) = card(a));
axA(a)    = yes$(ord(a) < card(a));
ax0A(a)   = yes$(ord(a) > 1 and ord(a) < card(a));

alias(a,a2);

$Group ENDO
    p_L[a,t] "User cost for bygninger"
    Q[a,t]    "Antal biler"
    P[a,t]    "Markedspris for bygninger"
    
   
    H[t]      "Boligforbrug"
    Z[t]      "Ikke-boligforbrug"
    PH[t]     "Pris på boligforbrug"
    PC[t]     "Forbrugerprisindeks"
    omv[t]    "Omvurderinger"
    Y_H[t]    "Løbende indtægter"

    X(a,t)    "Eksport af biler"
    M(a,t)    "Import af biler"
    
 ;




$Group EXO 
    X_bar(a,t)    "Markedsstørrelse"
    M_bar(a,t)    "Markedsstørrelse"
    PX_bar(a,t)   "Eksportpris"
    PM_bar(a,t)   "Importpris"

    EX            "Eksportelasticitet"
    EM            "Importelasticitet"

    profit(t)  "Overskud"
    PZ[t]       "Pris på ikke-boligforbrug"

    gamma[a]     "Vægt"
    muH          "Vægt"
    muZ          "Vægt"

    s(a)         "Overlevelsessandsynlighed"
    S_tot(a)     "Store-S"


    E         "Substitution, nye bygninger"
    F         "Substitution, nye og gamle bygninger"
    
    r[t]         "Realrente"
    c[a,t]         "Løbende omkostninger"
    Y_H_bar(t)   "Husholdningernes indkomst"

    # Reporting
    p0(t)       "Prisen på nye boliger"
    p1(t)      "Prisen på 1 år gammel bil"
    p2(t)      "Prisen på 2 år gammel bil"
    p24(t)      "Prisen på 2 år gammel bil"
    p25(t)      "Prisen på 2 år gammel bil"
    p10(t)      "Prisen på 10 år gammel bil"
    Q0(t)       "Nye biler"
    Q1(t)       "Antal"
    Q2(t)       "Antal"
    Q24(t)       "Antal"
    Q25(t)       "Antal"
    H_alt(t)    "Antal"
    Q_sum(t)    "Antal"
    PQ_sum(t)   "Pris på Q_sum"
    M_sum(t)    "Antal"
    X_sum(t)    "Antal"
    p_L0(t)     "Leasing-pris på ny bil"
    p_L1(t)     "Leasing-pris på ny bil"
    p_L2(t)     "Leasing-pris på ny bil"
    p_L10(t)    "Leasing-pris på 10 år gammel bil"
    p_L24(t)    "Leasing-pris på 10 år gammel bil"
    p_L25(t)    "Leasing-pris på 10 år gammel bil"

;

$Group J_led
    J1(a,t)   "J-led"
    J2(a,t)   "J-led"
    J3(t)   "J-led"
    J4(t)   "J-led"
    J5(t)   "J-led"
    J6(a,t)   "J-led"
    J7(t)   "J-led"
    J8(t)   "J-led"
    J9(a,t)   "J-led"
    J10(a,t)   "J-led"
    J11(a,t)   "J-led"
;


$BLOCK Modelligninger


# Husholdning
#---------------------------
E_Q(a,t)$(ax0(a) and tx0(t))..       Q(a,t)     =E= J2(a,t) + s(a)*Q(a-1,t-1) + M(a,t) - X(a,t);

E_P(a,t)$(tx0T(t))..                  P(a+1,t+1) =E= J1(a,t) + (1+r(t+1))*(P(a,t) - (p_L(a,t) - c(a,t)) * S_tot(a));

E_Z(t)$(tx0(t))..                    Z(t)       =E= J3(t) + muZ*(PZ(t)/PC(t))**(-E)*Y_H(t)/PC(t);

E_H(t)$(tx0(t))..                    H(t)       =E= J4(t) + muH*(PH(t)/PC(t))**(-E)*Y_H(t)/PC(t);

E_PC(t)$(tx0(t))..                   Y_H(t)     =E= J5(t) + PZ(t)*Z(t) + PH(t)*H(t);

E_p_L(a,t)$(tx0(t))..                Q(a,t)     =E= J6(a,t) + gamma(a)*(p_L(a,t)/PH(t))**(-F) * H(t);

E_PH(t)$(tx0(t))..                   PH(t)*H(t) =E= J7(t) + sum(a, p_L(a,t) * Q(a,t));

E_Y_H(t)$(tx0(t))..                  Y_H(t)     =E= J8(t) + Y_H_bar(t) + omv(t);

E_X(a,t)$(tx0(t))..                  X(a,t)     =E= J10(a,t) + X_bar(a,t)*(P(a,t)/PX_bar(a,t))**(-EX);

E_M(a,t)$(tx0(t))..                  M(a,t)     =E= J11(a,t) + M_bar(a,t)*(P(a,t)/PM_bar(a,t))**(EM);

# Teminalbetingelser
#---------------------------
E_Q_term(a,t)$(tT(t))..   Q(a,t)                =E= J9(a,t) + Q(a,t-1);


$ENDBLOCK

#------------------- Antagelser:
r.l(t)        = 0.05;
c.l(a,t)      = 0.02 + 0.001*ord(a);
F.l           = 1.5;
E.l           = 0.7;
EX.l          = 5;
EM.l          = 2.5;

# "DATA"
Y_H.l(t)   = 1;
Z.l(t)     = 0.25;
P.l(a,t)     = 1 - 0.98*ord(a)/card(a); 
Q.l(a,t)     = 0.1;
X.l(a,t)     = 0;
M.l(a,t)     = 0;

Y_H_bar.l(t)   = Y_H.l(t);

* 1
s.l(a) = 1 - exp(-5 + 0.17*ord(a));
s.l('0') = 1;
#s.l(aA) = 0;

* 2
S_tot.l(a) = prod(a2$(a2.val<=a.val), s.l(a2));

* 3
Q.l(a,t) = S_tot.l(a)*Q.l('0',t);

* 4
p_L.l(a,t) = c.l(a,t) + (r.l(t)*P.l(a,t) + P.l(a,t) - P.l(a+1,t))/((1+r.l(t))*S_tot.l(a));

* 5 
PH.l(t) = 1;
H.l(t) = sum(a, p_L.l(a,t)*Q.l(a,t));

* 6
PZ.l(t) = 1;
PC.l(t) = 1;
Z.l(t) = Y_H.l(t) - H.l(t);
muZ.l = sum(t1, Z.l(t1)/Y_H.l(t1));
muH.l = sum(t1, H.l(t1)/Y_H.l(t1));

* 7
gamma.l(a) = sum(t1, (p_L.l(a,t1)/PH.l(t1))**(F.l)*Q.l(a,t1)/H.l(t1));

* Udenrigshandel 
PX_bar.l(a,t) = P.l(a,t);
X_bar.l(a,t) = X.l(a,t);

PM_bar.l(a,t) = P.l(a,t);
M_bar.l(a,t) = M.l(a,t);

display profit.l;
#$exit


display s.l, S_tot.l, Q.l, muZ.l, muH.l, P.l, p_L.l, S_tot.l, gamma.l;

parameter output_a;
output_a(a, "S_tot") = S_tot.l(a);
output_a(a, "s") = s.l(a);
output_a(a, "p_L") = p_l.l(a, '1');
output_a(a, "Q") = Q.l(a, '1');
output_a(a, "P") = P.l(a, '1');
display output_a;

parameter output_t;
output_t(t, "H") = H.l(t);
output_t(t, "Z") = Z.l(t);
display output_t;


$Model model1 
Modelligninger
;

$fix all;
$unfix ENDO;

#$unfix J_led;
#solve model1 using CNS;
#display J1.l,J2.l,J3.l,J4.l,J5.l,J6.l,J7.l,J8.l,J9.l; 
#$exit


# Initialisering
Q.fx(a, t0) = Q.l(a, t0);
P.fx(a, t0) = P.l(a, t0);

# Nypris er eksogen
p.fx('0',t) = p.l('0',t);

omv.fx(t) = 0;

# Her stødes eksport ind (M=X=0 i grundkalibrering)
X_bar.fx(a,t)$(t.val>5 and a.val >0 and a.val<6) = 0.001;


# Output macro
$macro output_vars \
p_L0.l(t) = p_L.l('0',t); \
p_L1.l(t) = p_L.l('1',t); \
p_L2.l(t) = p_L.l('2',t); \
p_L10.l(t) = p_L.l('10',t); \
p_L24.l(t) = p_L.l('24',t); \
p_L25.l(t) = p_L.l('25',t); \
p0.l(t) = p.l('0',t); \
p1.l(t) = p.l('1',t); \
p2.l(t) = p.l('2',t); \
p10.l(t) = p.l('10',t); \
p24.l(t) = p.l('24',t); \
p25.l(t) = p.l('25',t); \
Q_sum.l(t) = sum(a, Q.l(a,t)); \
PQ_sum.l(t) = sum(a, p_L.l(a,t)*Q.l(a,t)) / Q_sum.l(t); \
M_sum.l(t) = sum(a, M.l(a,t)); \
X_sum.l(t) = sum(a, X.l(a,t)); \
H_alt.l(t) = (sum(a$(a.val>10), gamma.l(a)**(1/F.l)*Q.l(a,t)**((F.l-1)/F.l)))**(F.l/(F.l-1)); \
Q0.l(t) = Q.l('0',t); \
Q1.l(t) = Q.l('1',t); \
Q2.l(t) = Q.l('2',t); \
Q24.l(t) = Q.l('24',t); \
Q25.l(t) = Q.l('25',t); 

# Base run
solve model1 using CNS;
output_vars
execute_unload 'output\model0.gdx';

#$exit

#-----------------------------------
# Stød
#-----------------------------------
#c.fx(a,t)$(t.val>0) = 1.01*c.l(a,t);
#P.fx('0', t)$(t.val>0) = 1.01*P.l('0', t);
#Y_H_bar.fx(t)$(t.val>0) = 1.01*Y_H_bar.l(t);
#Y_H_bar.fx(t)$(t.val>0) = 0.99*Y_H_bar.l(t);
X_bar.fx(a,t)$(t.val>0) = 1.1*X_bar.l(a,t);


#P.fx('0', t)$(t.val>5) = 1.01*P.l('0', t);
#Y_H_bar.fx(t)$(t.val>5) = 1.01*Y_H_bar.l(t);
#c.fx(a,t)$(t.val>5) = 1.01*c.l(a,t);

solve model1 using CNS;
output_vars
execute_unload 'output\model.gdx';

display omv.l;


