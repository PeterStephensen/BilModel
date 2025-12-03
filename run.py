# ======================================================================
# Setting up Python 
# ======================================================================
%load_ext autoreload
%autoreload 2

import os 
import sys
import subprocess
import dreamtools as dt
from dreamtools.gamY import run
root = dt.find_root()
sys.path.insert(0,root)
import paths

run("model.gms", s="Saved/model")

# ======================================================================
# Figurer 
# ======================================================================

# Indlæs GDX-filen
import gdxpds
df = gdxpds.to_dataframes("Output/model.gdx")
df0 = gdxpds.to_dataframes("Output/model0.gdx")

# Gemmer data
#for name, table in df.items():
#    print(f"{name}:\n{table.head()}\n")

#Laver figurer 
from figurer import *

 #Ændre blot variabel navn og tidsinterval for at plotte figur
#tmin = 2024
#tmax = 2074
tmin = 0
tmax = 50

lav_fig(df,  "p_L0", t_min=tmin, t_max=tmax)
lav_fig(df,  "p_L1", t_min=tmin, t_max=tmax)
lav_fig(df,  "p_L2", t_min=tmin, t_max=tmax)
lav_fig(df,  "p_L24", t_min=tmin, t_max=tmax)
lav_fig(df,  "p_L25", t_min=tmin, t_max=tmax)
lav_fig(df,  "p1", t_min=tmin, t_max=tmax)
lav_fig(df,  "p_L0", t_min=tmin, t_max=tmax)

lav_fig_rel(df0, df, "PH", t_min=tmin, t_max=tmax)
lav_fig_rel(df0, df, "Q_sum", t_min=tmin, t_max=tmax, main="Samlet antal biler, Q_sum")
lav_fig_rel(df0, df, "PQ_sum", t_min=tmin, t_max=tmax, main="Gennemsnitlig leasing-pris, PQ_sum")
lav_fig_rel(df0, df, "H", t_min=tmin, t_max=tmax)
lav_fig_rel(df0, df, "PH", t_min=tmin, t_max=tmax)


lav_fig_rel(df0, df, "PC", t_min=tmin, t_max=tmax)
lav_fig_rel(df0, df, "Z", t_min=tmin, t_max=tmax, main="Ikke-transport, Z")
lav_fig_rel(df0, df, "H", t_min=tmin, t_max=tmax)
lav_fig_rel(df0, df, "PH", t_min=tmin, t_max=tmax)
lav_fig_rel(df0, df, "Y_H", t_min=tmin, t_max=tmax)
lav_fig_rel(df0, df, "p25", t_min=tmin, t_max=tmax)
lav_fig_rel(df0, df, "p24", t_min=tmin, t_max=tmax)
lav_fig_rel(df0, df, "p10", t_min=tmin, t_max=tmax)
lav_fig_rel(df0, df, "p2", t_min=tmin, t_max=tmax)
lav_fig_rel(df0, df, "p1", t_min=tmin, t_max=tmax)
lav_fig_rel(df0, df, "p0", t_min=tmin, t_max=tmax)
lav_fig_rel(df0, df, "p_L25", t_min=tmin, t_max=tmax)
lav_fig_rel(df0, df, "p_L24", t_min=tmin, t_max=tmax)
lav_fig_rel(df0, df, "p_L10", t_min=tmin, t_max=tmax)
lav_fig_rel(df0, df, "p_L2", t_min=tmin, t_max=tmax)
lav_fig_rel(df0, df, "Q2", t_min=tmin, t_max=tmax)
lav_fig_rel(df0, df, "p_L1", t_min=tmin, t_max=tmax)
lav_fig_rel(df0, df, "Q1", t_min=tmin, t_max=tmax)
lav_fig_rel(df0, df, "p_L0", t_min=tmin, t_max=tmax)
lav_fig_rel(df0, df, "Q0", t_min=tmin, t_max=tmax)



