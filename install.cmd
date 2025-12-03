:: Set path to GAMS
set GAMSDIR=C:/GAMS/49
set python=%GAMSDIR%/GMSPython/python.exe
set pip=%GAMSDIR%/GMSPython/Scripts/pip

:: Install pip (as python that ships with GAMS does not have pip)
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
%python% get-pip.py

:: Install python modules
%pip% install ipykernel
%pip% install numpy scipy statsmodels
%pip% install gamsapi[all]==49.3.0 
%pip% install dream-tools==3.0.0 plotly 
%pip% install xlwings
%pip% install dataframe_image pyhtml2pdf PyPDF2
%pip% install kaleido==0.1.0.post1
%pip% install gdxpds
%pip% install matplotlib
%pip% install ipykernel

:: Installing svglib (needed for xhtml2pdf) fails as the installer looks for .pyd files in the wrong directory
:: Workaround: create a symlink to the correct directory
mklink /J "%GAMSDIR%\GMSPython\DLLs\." "%GAMSDIR%\GMSPython"
%pip% install svglib

%pip% install xhtml2pdf

