def lav_fig(df, variabel_navn, t_min=2024, t_max=2124):
    import matplotlib.pyplot as plt
    #from matplotlib.backends.backend_pdf import PdfPages

    import pandas as pd
    import numpy as np

    # Ordbog med labels
    variabel_labels = {
        "K": "Bygninger",
        "sK0": "Skyggepriser på initiale bygninger",
        "K_new": "Nyere bygninger",
        "K_old": "Husholdningernes beholdning af ældre bygninger",
        "sOld0": "Skyggepriser på initiale ældre bygninger",
        "p_uc": "User cost for bygninger",
        "p": "Markedspris for bygninger",
        "p_old": "User-cost for ældre bygninger",
        "p_new": "User-cost for nyeere bygninger",
        "p_U": "CES-prisindeks for nyeere og ældre bygninger",
        "W_hat": "Samlet formue",
        "u": "Nytte",
        "N_old": "Nedrivning af ældre bygninger",
        "Q_old": "Samlet antal ældre bygninger"
    }

    if variabel_navn not in df:
        raise ValueError(f"Symbol '{variabel_navn}' findes ikke i GDX-filen.")
    
    data = df[variabel_navn].copy()  

    #label = variabel_labels.get(variabel_navn, variabel_navn)
    label = variabel_navn

    # Konvertér 't' til numerisk kolonne (ny kolonne)
    data["t_num"] = pd.to_numeric(data["t"], errors="coerce")

    # Filtrér på t
    data = data[(data["t_num"] >= t_min) & (data["t_num"] <= t_max)]

    # Find værdikolonne
    value_col = "Level" if "Level" in data.columns else "Value"

    # Start figur
    plt.figure(figsize=(8, 5))

    # Hvis der er kolonnen 'a', så lav en linje per a
    if "a" in data.columns:
        for a_val, gruppe in data.groupby("a"):
            plt.plot(gruppe["t_num"], gruppe[value_col], marker="o", label=f"a = {a_val}")
        plt.legend(title="Bygningsalder (a)")
    else:
        plt.plot(data["t_num"], data[value_col], marker="o")

    plt.xlabel("Tid (t)")
    plt.ylabel(label)
    #plt.title(f"Udvikling i {label} over tid ({t_min}-{t_max})")
    plt.title(f"Udvikling i {label}")
    plt.xticks(np.arange(t_min, t_max + 1, 1))
    plt.grid(True)
    plt.tight_layout()
    plt.show()
    #plt.savefig("Output/" + variabel_navn + ".png")

def lav_fig_rel(df0, df, variabel_navn, t_min=2024, t_max=2124, main=""):
    
    import matplotlib.pyplot as plt
    import pandas as pd
    import numpy as np

    # Ordbog med labels
    variabel_labels = {
        "K": "Bygninger",
        "sK0": "Skyggepriser på initiale bygninger",
        "K_new": "Nyere bygninger",
        "K_old": "Husholdningernes beholdning af ældre bygninger",
        "sOld0": "Skyggepriser på initiale ældre bygninger",
        "p_uc": "User cost for bygninger",
        "p": "Markedspris for bygninger",
        "p_old": "User-cost for ældre bygninger",
        "p_new": "User-cost for nyeere bygninger",
        "p_U": "CES-prisindeks for nyeere og ældre bygninger",
        "W_hat": "Samlet formue",
        "u": "Nytte",
        "N_old": "Nedrivning af ældre bygninger",
        "Q_old": "Samlet antal ældre bygninger"
    }

    if variabel_navn not in df or variabel_navn not in df0:
        raise ValueError(f"Symbol '{variabel_navn}' findes ikke i GDX-filen.")

    # Kopier data fra df og df0
    data = df[variabel_navn].copy()
    data0 = df0[variabel_navn].copy()

    #label = variabel_labels.get(variabel_navn, variabel_navn)
    if main=="":
        label = variabel_navn
    else:
        label = main
        

    # Konvertér 't' til numerisk kolonne
    data["t_num"] = pd.to_numeric(data["t"], errors="coerce")
    data0["t_num"] = pd.to_numeric(data0["t"], errors="coerce")

    # Filtrér data på t
    data = data[(data["t_num"] >= t_min) & (data["t_num"] <= t_max)]
    data0 = data0[(data0["t_num"] >= t_min) & (data0["t_num"] <= t_max)]

    # Sammenflet dataframes på 't_num'
    merged_data = pd.merge(data, data0, on="t_num", suffixes=('', '_0'))

    # Beregn den relative forskel
    merged_data['relative_difference'] = merged_data["Level"] / merged_data["Level_0"] - 1.0

    # Start figur
    plt.figure(figsize=(8, 5))

    # Hvis der er kolonnen 'a', så lav en linje per a
    if "a" in merged_data.columns:
        for a_val, gruppe in merged_data.groupby("a"):
            plt.plot(gruppe["t_num"], gruppe['relative_difference'], marker="o", label=f"a = {a_val}")
        plt.legend(title="Bygningsalder (a)")
    else:
        plt.plot(merged_data["t_num"], merged_data['relative_difference'], marker="o")

    plt.xlabel("Tid (t)")
    plt.ylabel("Relativ forskel")
    #plt.title(f"Relativ forskel i {label} over tid ({t_min}-{t_max})")
    plt.title(f"{label}")
    plt.xticks(np.arange(t_min, t_max + 1, 5))
    plt.grid(True)
    plt.tight_layout()
    plt.show()
    #plt.savefig("Output/" + variabel_navn + ".png")

    

def lav_fig_diff(df0, df, variabel_navn, t_min=2024, t_max=2124):
    
    import matplotlib.pyplot as plt
    import pandas as pd
    import numpy as np

    # Ordbog med labels
    variabel_labels = {
        "K": "Bygninger",
        "sK0": "Skyggepriser på initiale bygninger",
        "K_new": "Nyere bygninger",
        "K_old": "Husholdningernes beholdning af ældre bygninger",
        "sOld0": "Skyggepriser på initiale ældre bygninger",
        "p_uc": "User cost for bygninger",
        "p": "Markedspris for bygninger",
        "p_old": "User-cost for ældre bygninger",
        "p_new": "User-cost for nyeere bygninger",
        "p_U": "CES-prisindeks for nyeere og ældre bygninger",
        "W_hat": "Samlet formue",
        "u": "Nytte",
        "N_old": "Nedrivning af ældre bygninger",
        "Q_old": "Samlet antal ældre bygninger"
    }

    if variabel_navn not in df or variabel_navn not in df0:
        raise ValueError(f"Symbol '{variabel_navn}' findes ikke i GDX-filen.")

    # Kopier data fra df og df0
    data = df[variabel_navn].copy()
    data0 = df0[variabel_navn].copy()

    #label = variabel_labels.get(variabel_navn, variabel_navn)
    label = variabel_navn

    # Konvertér 't' til numerisk kolonne
    data["t_num"] = pd.to_numeric(data["t"], errors="coerce")
    data0["t_num"] = pd.to_numeric(data0["t"], errors="coerce")

    # Filtrér data på t
    data = data[(data["t_num"] >= t_min) & (data["t_num"] <= t_max)]
    data0 = data0[(data0["t_num"] >= t_min) & (data0["t_num"] <= t_max)]

    # Sammenflet dataframes på 't_num'
    merged_data = pd.merge(data, data0, on="t_num", suffixes=('', '_0'))

    # Beregn forskel
    merged_data['difference'] = merged_data["Level"] - merged_data["Level_0"]

    # Start figur
    plt.figure(figsize=(8, 5))

    # Hvis der er kolonnen 'a', så lav en linje per a
    if "a" in merged_data.columns:
        for a_val, gruppe in merged_data.groupby("a"):
            plt.plot(gruppe["t_num"], gruppe['difference'], marker="o", label=f"a = {a_val}")
        plt.legend(title="Bygningsalder (a)")
    else:
        plt.plot(merged_data["t_num"], merged_data['difference'], marker="o")

    plt.xlabel("Tid (t)")
    plt.ylabel("Ændring")
    #plt.title(f"Relativ forskel i {label} over tid ({t_min}-{t_max})")
    plt.title(f"Ændring i {label}")
    plt.xticks(np.arange(t_min, t_max + 1, 5))
    plt.grid(True)
    plt.tight_layout()
    plt.show()
    #plt.savefig("Output/" + variabel_navn + ".png")

        