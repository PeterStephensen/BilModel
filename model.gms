$offsymxref offsymlist
option limcol =0, limrow=0;
option solprint=off;
option decimals=8;


Sets 
  t         "Tidsperioder"                                  /0*50/
  t0[t]     "Første tidsperiode"
  t1[t]     "Første endogene tidsperiode (Basisår)" 
  tT[t]     "Sidste tidsperiode T"
  txT[t]    "Undtagen sidste tidsperiode T"
  tx0[t]    "Undtagen første tidsperiode"
  tx1[t]    "Undtagen første endogene tidsperiode"
  tx0T[t]   "Undtagen første og sidste tidsperiode"
  
  a         "Bils alder"                                 /0*25/
  a0[a]     "Alder 0 (ny bil)"                       
  ax0[a]    "Brugte biler"                       
  aA[a]     "Højeste alder A"                         
  axA[a]    "Undtagen højeste alder A"
  ax0A[a]   "Undtagen 0 og højeste alder A"

  d_Q(a,t)        "Styrer E_Q. Bruges i kalibrering"
  d_Q_diff(a,t)   "Styrer E_Q_diff. Bruges i kalibrering"
;  

t0(t)     = yes$(ord(t) = 1);
t1(t)     = yes$(ord(t) = 2);
tT(t)     = yes$(ord(t) = card(t));
txT(t)    = yes$(ord(t) < card(t));
tx0(t)    = yes$(ord(t) > 1);
tx1(t)    = yes$(ord(t) > 2);
tx0T(t)   = yes$(ord(t) < card(t) and ord(t) > 1);

a0(a)     = yes$(ord(a) = 1);
ax0(a)    = yes$(ord(a) > 1);
aA(a)     = yes$(ord(a) = card(a));
axA(a)    = yes$(ord(a) < card(a));
ax0A(a)   = yes$(ord(a) > 1 and ord(a) < card(a));

$macro RESET_Q_DOMAINS \
d_Q(a,t)      = yes$(ax0(a) and tx0(t));\        
d_Q_diff(a,t) = yes$(tT(t)); 
RESET_Q_DOMAINS

alias(a,a2);

$Group ENDO
    p_L[a,t]  "Leasing-pris på biler"
    Q[a,t]    "Antal biler"
    P[a,t]    "Pris på bil"
    H[t]      "Bil-aggregat"
    Z[t]      "Ikke-bil-aggregat"
    PH[t]     "Pris på bil-aggregat"
    PC[t]     "Forbrugerprisindeks"
    Y_H[t]    "Løbende indkomst"
    X(a,t)    "Eksport af biler"
    M(a,t)    "Import af biler"
 ;


$Group EXO 
    X_bar(a,t)    "Markedsstørrelse"
    M_bar(a,t)    "Markedsstørrelse"
    PX_bar(a,t)   "Eksportkonkurrende pris"
    PM_bar(a,t)   "Importkonkurrende pris"

    EX            "Eksportelasticitet"
    EM            "Importelasticitet"

    PZ[t]         "Pris på ikke-boligforbrug"

    gamma(a,t)    "Vægt"
    muH(t)        "Vægt"
    muZ(t)        "Vægt"


    s(a)          "Overlevelsessandsynlighed"
    S_tot(a)      "Store-S"

    E             "Substitutionselasticitet"
    F             "Substitutionselasticitet"
    
    r[t]          "Rente"
    c[a,t]        "Løbende omkostninger for en bil"
    Y_H_bar(t)    "Husholdningernes indkomst"

    # Reporting
    p0(t)         "Prisen på nye boliger"
    p1(t)         "Prisen på 1 år gammel bil"
    p2(t)         "Prisen på 2 år gammel bil"
    p24(t)        "Prisen på 2 år gammel bil"
    p25(t)        "Prisen på 2 år gammel bil"
    p10(t)        "Prisen på 10 år gammel bil"
    Q0(t)         "Nye biler"
    Q1(t)         "Antal"
    Q2(t)         "Antal"
    Q24(t)        "Antal"
    Q25(t)        "Antal"
    Q_sum(t)      "Antal"
    PQ_sum(t)     "Pris på Q_sum"
    M_sum(t)      "Samlet import af biler"
    X_sum(t)      "Samlet eksport af biler"
    p_L0(t)       "Leasing-pris på ny bil"
    p_L1(t)       "Leasing-pris på ny bil"
    p_L2(t)       "Leasing-pris på ny bil"
    p_L10(t)      "Leasing-pris på 10 år gammel bil"
    p_L24(t)      "Leasing-pris på 10 år gammel bil"
    p_L25(t)      "Leasing-pris på 10 år gammel bil"
;

$Group J_led
    J1(a,t)   "J-led"
    J2(a,t)   "J-led"
    J3(a,t)   "J-led"
    J4(a,t)   "J-led"
    J5(t)     "J-led"
    J6(t)     "J-led"
    J7(t)     "J-led"
    J8(a,t)   "J-led"
    J9(t)     "J-led"
    J10(t)    "J-led"
    J11(a,t)  "J-led"
    J12(a,t)  "J-led"
    J13(a,t)  "J-led"
;

$BLOCK Ligninger

E_Q(a,t)$(d_Q(a,t))..                Q(a,t)     =E= J1(a,t) + s(a)*Q(a-1,t-1) + M(a,t) - X(a,t);

E_Q_diff(a,t)$(d_Q_diff(a,t))..      Q(a,t)     =E= J2(a,t) + Q(a,t-1);

E_P(a,t)$(axA(a) and tx0T(t))..      P(a+1,t+1) =E= J3(a,t) + (1+r(t+1))*(P(a,t) - (p_L(a,t) - c(a,t)) * S_tot(a));
E_PA(a,t)$(aA(a) and tx0T(t))..      0          =E= J4(a,t) + (1+r(t+1))*(P(a,t) - (p_L(a,t) - c(a,t)) * S_tot(a));

E_Z(t)$(tx0(t))..                    Z(t)       =E= J5(t) + muZ(t)*(PZ(t)/PC(t))**(-E)*Y_H(t)/PC(t);

E_H(t)$(tx0(t))..                    H(t)       =E= J6(t) + muH(t)*(PH(t)/PC(t))**(-E)*Y_H(t)/PC(t);

E_PC(t)$(tx0(t))..                   Y_H(t)     =E= J7(t) + PZ(t)*Z(t) + PH(t)*H(t);

E_p_L(a,t)$(tx0(t))..                Q(a,t)     =E= J8(a,t) + gamma(a,t)*(p_L(a,t)/PH(t))**(-F) * H(t);

E_PH(t)$(tx0(t))..                   PH(t)*H(t) =E= J9(t) + sum(a, p_L(a,t) * Q(a,t));

E_Y_H(t)$(tx0(t))..                  Y_H(t)     =E= J10(t) + Y_H_bar(t);

E_X(a,t)$(tx0(t))..                  X(a,t)     =E= J11(a,t) + X_bar(a,t)*(P(a,t)/PX_bar(a,t))**(-EX);

E_M(a,t)$(tx0(t))..                  M(a,t)     =E= J12(a,t) + M_bar(a,t)*(P(a,t)/PM_bar(a,t))**(EM);

E_p_L_calib(a,t)$(tT(t))..           p_L(a,t)   =E= J13(a,t) + p_L(a,t-1);

$ENDBLOCK

$Model model_all Ligninger;
model model_sim /model_all -E_p_L_calib/;  

#------------------------------
# Parametre:
#------------------------------
r.l(t)        = 0.05;
c.l(a,t)      = 0.02 + 0.001*ord(a);
F.l           = 1.5;
E.l           = 0.7;
EX.l          = 5;
EM.l          = 2.5;

#------------------------------
# Data
#------------------------------
Y_H.l(t)    = 1;
P.l(a,t)    = 1 - 0.98*ord(a)/card(a); # P(A)>0
Q.l('0',t)  = 0.1;
M.l(a,t)    = 0.01*(1 - ord(a)/card(a));
X.l(a,t)    = 0.01*(1 - ord(a)/card(a));

# Skrot-sandsynligheder
s.l(a)     = 1 - exp(-5 + 0.17*ord(a));  # Gompertz lov (dør som mennesker)
s.l('0')   = 1;
S_tot.l(a) = prod(a2$(a2.val<=a.val), s.l(a2));

# Initialisering af priser
PH.l(t) = 1;
PZ.l(t) = 1;
PC.l(t) = 1;
PX_bar.l(a,t) = P.l(a,t);
PM_bar.l(a,t) = P.l(a,t);

#------------------------------
# Kalibrering
#------------------------------
d_Q(a,t)      = yes$(ord(t) >= ord(a) and ax0(a) and tx0(t));
d_Q_diff(a,t) = yes$(ord(t) <= ord(a) and ax0(a) and tx0(t));

model m_calib1 /E_Q, E_Q_diff/;
$fix all
$unfix Q;
Q.fx(a0,t) = Q.l(a0,t);
solve m_calib1 using CNS;

RESET_Q_DOMAINS

# Denne kalibrering er kun "halv-automatisk". Kalibreringen af p_L giver numeriske problemer. 
# Derfor bliver resten af parametrene og variablene hånd-kalibreret 
p_L.l(a,t)   = c.l(a,t) + (r.l(t)*P.l(a,t) + P.l(a,t) - P.l(a+1,t))/((1+r.l(t))*S_tot.l(a));
H.l(t)       = sum(a, p_L.l(a,t)*Q.l(a,t));
Z.l(t)       = Y_H.l(t) - H.l(t);
muZ.l(t)     = Z.l(t)/Y_H.l(t);
muH.l(t)     = H.l(t)/Y_H.l(t);
gamma.l(a,t) = (p_L.l(a,t)/PH.l(t))**(F.l)*Q.l(a,t)/H.l(t);
X_bar.l(a,t) = X.l(a,t);
M_bar.l(a,t) = M.l(a,t);
Y_H_bar.l(t) = Y_H.l(t);

#------------------------------
# Output macro
#------------------------------
$macro OUTPUT_VARS \
p_L0.l(t)   = p_L.l('0',t); \
p_L1.l(t)   = p_L.l('1',t); \
p_L2.l(t)   = p_L.l('2',t); \
p_L10.l(t)  = p_L.l('10',t); \
p_L24.l(t)  = p_L.l('24',t); \
p_L25.l(t)  = p_L.l('25',t); \
p0.l(t)     = p.l('0',t); \
p1.l(t)     = p.l('1',t); \
p2.l(t)     = p.l('2',t); \
p10.l(t)    = p.l('10',t); \
p24.l(t)    = p.l('24',t); \
p25.l(t)    = p.l('25',t); \
Q_sum.l(t)  = sum(a, Q.l(a,t)); \
PQ_sum.l(t) = sum(a, p_L.l(a,t)*Q.l(a,t)) / Q_sum.l(t); \
M_sum.l(t)  = sum(a, M.l(a,t)); \
X_sum.l(t)  = sum(a, X.l(a,t)); \
Q0.l(t)     = Q.l('0',t); \
Q1.l(t)     = Q.l('1',t); \
Q2.l(t)     = Q.l('2',t); \
Q24.l(t)    = Q.l('24',t); \
Q25.l(t)    = Q.l('25',t); 

#------------------------------
# 0-stød
#------------------------------
$fix all;
$unfix ENDO;

# Initialisering
Q.fx(a, t0) = Q.l(a, t0);

# Nypris er eksogen
p.fx('0',t) = p.l('0',t);

solve model_sim using CNS;
OUTPUT_VARS
execute_unload 'output\model0.gdx';

# $exit

#------------------------------
# Stød
#------------------------------
# c.fx(a,t)$(t.val>0) = 1.01*c.l(a,t);
# P.fx('0', t)$(t.val>0) = 1.01*P.l('0', t);
#Y_H_bar.fx(t)$(t.val>0) = 1.01*Y_H_bar.l(t);
#Y_H_bar.fx(t)$(t.val>0) = 0.99*Y_H_bar.l(t);
# X_bar.fx(a,t)$(t.val>0) = 1.01*X_bar.l(a,t);
PX_bar.fx(a,t)$(t.val>0) = 1.01*PX_bar.l(a,t);

#P.fx('0', t)$(t.val>5) = 1.01*P.l('0', t);
# Y_H_bar.fx(t)$(t.val>5) = 1.01*Y_H_bar.l(t);
#c.fx(a,t)$(t.val>5) = 1.01*c.l(a,t);

solve model_sim using CNS;
OUTPUT_VARS
execute_unload 'output\model.gdx';



