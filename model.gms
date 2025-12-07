$offsymxref offsymlist
option limcol =0, limrow=0;
option solprint=off;
option decimals=8;

Sets 
  t         "Tidsperioder"                                  /0*50/
  t0(t)     "Første tidsperiode"
  t1(t)     "Første endogene tidsperiode (Basisår)" 
  tT(t)     "Sidste tidsperiode T"
  txT(t)    "Undtagen sidste tidsperiode T"
  txTT(t)   "Undtagen sidste og næstsidste tidsperiode T"
  tx0(t)    "Undtagen første tidsperiode"
  tx1(t)    "Undtagen første endogene tidsperiode"
  tx0T(t)   "Undtagen første og sidste tidsperiode"
  tx1T(t)   "Undtagen første endogene og sidste tidsperiode"
  
  a         "Bygningsaldre"                                 /0*25/
  a0[a]     "Alder for nye bygninger"                       
  ax0[a]    "Undtagen Alder for nye bygninger"                       
  aA[a]     "Højeste bygningsalder A"                         
  axA[a]    "Undtagen højeste bygningsalder A"
  ax0A[a]   "Undtagen 0 og højeste bygningsalder A"

  d_Q(a,t)        "Styrer E_Q"
  d_Q_diff(a,t)   "Styrer E_Q_diff"
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

d_Q(a,t)      = yes$(ax0(a) and tx0(t));        
d_Q_diff(a,t) = yes$(tT(t));        

alias(a,a2);

$Group ENDO
    p_L(a,t) "User cost for bygninger"
    Q(a,t)    "Antal biler"
    P(a,t)    "Markedspris for bygninger"    
    H(t)      "Boligforbrug"
    Z(t)      "Ikke-boligforbrug"
    PH(t)     "Pris på boligforbrug"
    PC(t)     "Forbrugerprisindeks"
    X(a,t)    "Eksport af biler"
    M(a,t)    "Import af biler"   
 ;


$Group ENDO_CALIB 
    X_bar(a,t)    "Markedsstørrelse"
    M_bar(a,t)    "Markedsstørrelse"
    gamma(a,t)     "Vægt"
    muH(t)          "Vægt"
    muZ(t)          "Vægt"
    Z(t)          " "
    H(t)          " "
    p_L(a,t)      ""
    Q(a,t)        ""
;


$Group EXO 
    s(a)         "Overlevelsessandsynlighed"
    S_tot(a)     "Store-S"
    EX            "Eksportelasticitet"
    EM            "Importelasticitet"
    Y_H(t)    "Løbende indtægter"
    PZ(t)       "Pris på ikke-boligforbrug"
    PX_bar(a,t)   "Eksportpris"
    PM_bar(a,t)   "Importpris"
    E         "Substitution, nye bygninger"
    F         "Substitution, nye og gamle bygninger"
    r(t)         "Realrente"
    c(a,t)         "Løbende omkostninger"

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
    J3(a,t)   "J-led"
    J4(a,t)   "J-led"
    J5(a,t)   "J-led"
    J6(t)     "J-led"
    J7(t)     "J-led"
    J8(t)     "J-led"
    J9(a,t)   "J-led"
    J10(t)    "J-led"
    J11(a,t)  "J-led"
    J12(a,t)  "J-led"
;

$BLOCK Modelligninger

# d_Q(a,t)      = yes$(ax0(a) and tx0(t));        
# d_Q_diff(a,t) = yes$(tT(t));        


# Husholdning
#---------------------------
E_Q(a,t)$(d_Q(a,t))..           Q(a,t)     =E= J1(a,t)  + s(a)*Q(a-1,t-1) + M(a,t) - X(a,t);

E_Q_diff(a,t)$(d_Q_diff(a,t)).. Q(a,t)     =E= J2(a,t)  + Q(a,t-1);

# E_P(a,t)$(tx0T(t)).. P(a+1,t+1) =E= J3(a,t)  + (1+r(t+1))*(P(a,t) - (p_L(a,t) - c(a,t)) * S_tot(a));

E_P(a,t)$(axA(a) and tx0T(t)).. P(a+1,t+1) =E= J3(a,t)  + (1+r(t+1))*(P(a,t) - (p_L(a,t) - c(a,t)) * S_tot(a));

E_PA(a,t)$(aA(a) and tx0T(t)).. 0          =E= J4(a,t)  + (1+r(t+1))*(P(a,t) - (p_L(a,t) - c(a,t)) * S_tot(a));

E_p_L_term(a,t)$(tT(t))..       p_L(a,t)   =E= J5(a,t)  + p_L(a,t-1);

E_Z(t)$(tx0(t))..               Z(t)       =E= J6(t)    + muZ(t)*(PZ(t)/PC(t))**(-E)*Y_H(t)/PC(t);

E_H(t)$(tx0(t))..               H(t)       =E= J7(t)    + muH(t)*(PH(t)/PC(t))**(-E)*Y_H(t)/PC(t);

E_PC(t)$(tx0(t))..              Y_H(t)     =E= J8(t)    + PZ(t)*Z(t) + PH(t)*H(t);

E_p_L(a,t)$(tx0(t))..           Q(a,t)     =E= J9(a,t)  + gamma(a,t)*(p_L(a,t)/PH(t))**(-F) * H(t);

E_PH(t)$(tx0(t))..              PH(t)*H(t) =E= J10(t)   + sum(a, p_L(a,t) * Q(a,t));

E_X(a,t)$(tx0(t))..             X(a,t)     =E= J11(a,t) + X_bar(a,t)*(P(a,t)/PX_bar(a,t))**(-EX);

E_M(a,t)$(tx0(t))..             M(a,t)     =E= J12(a,t) + M_bar(a,t)*(P(a,t)/PM_bar(a,t))**(EM);

$ENDBLOCK

$Model model1 
Modelligninger
;


#------------------- Antagelser:
r.l(t)        = 0.05;
c.l(a,t)      = 0.02 + 0.001*ord(a);
F.l           = 1.5;
E.l           = 0.7;
EX.l          = 5;
EM.l          = 2.5;
s.l(a)        = 1 - exp(-5 + 0.17*ord(a));
S_tot.l(a)    = prod(a2$(a2.val<=a.val), s.l(a2));

# "DATA"
Y_H.l(t)   = 1;
P.l(a,t)     = 1 - 0.98*ord(a)/card(a); 
Q.l('0',t)     = 0.1;
X.l(a,t)     = 0;
M.l(a,t)     = 0;

# Initialisering af priser
PH.l(t) = 1;
PZ.l(t) = 1;
PC.l(t) = 1;
PX_bar.l(a,t) = P.l(a,t);
PM_bar.l(a,t) = P.l(a,t);


# For ikke at dividere med 0
p_L.l(a,t) = 1;

#-------------------------------------
# Kalibrering
#-------------------------------------
$fix all;
$unfix ENDO_CALIB;

d_Q(a,t)      = yes$(ord(t) >= ord(a) and ax0(a) and tx0(t));
d_Q_diff(a,t) = yes$(ord(t) <= ord(a) and ax0(a) and tx0(t));

# $group ENDO_test
#     Q(a,t)
#     H(t)
#     Z(t)
#     p_L(a,t)
#     muZ(t)
#     muH(t)
#     X_bar(t)
#     M_bar(t)
#     gamma(a,t)
# ;
# $fix all;
# $unfix ENDO_test;

# model model_test /E_Q, E_Q_diff, E_P, E_PA, E_p_L_term, E_PH, E_PC, E_Z, E_H, E_X, E_M, E_p_L/;
# #model model_test /E_Q, E_Q_diff/;


# Kalibrer til givet ny-køb
Q.fx(a0, t) = Q.l(a0, t);

solve model1 using CNS;
# solve model_test using CNS;

display X_bar.l, M_bar.l, gamma.l, muH.l, muZ.l, Z.l, H.l, p_L.l, Q.l;

# $exit

#-------------------------------------
# 0-stød
#-------------------------------------
d_Q(a,t)      = yes$(ax0(a) and tx0(t));        
d_Q_diff(a,t) = yes$(tT(t));        

$fix all;
$unfix ENDO;


# $group ENDO_test
#     P(a,t)
# ;
# $fix all;
# $unfix ENDO_test;

# # H.fx(t) = H.l(t);
# #PH.fx(t) = PH.l(t);
# p_L.fx(a, t) = p_L.l(a, t);
# P.fx(a, tT) = P.l(a, tT);

# Q.fx(a0, t) = Q.l(a0, t);


# model model_test /E_P, E_PA/;
# # model model_test /E_Q, E_p_L, E_PH, E_Z, E_H, E_PC/;
# # model model_test /E_Q, E_P, E_PA/;

# Initial køretøjsbestand
Q.fx(a, t0) = Q.l(a, t0);
P.fx(a, t0) = P.l(a, t0);

# Eksogen pris på nye biler
P.fx(a0,t) = P.l(a0,t);

solve model1 using CNS;
# solve model_test using CNS;

display d_Q, d_Q_diff, p_L.l;

$exit

#-------------------------------------
# Stød
#-------------------------------------



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

$exit

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


