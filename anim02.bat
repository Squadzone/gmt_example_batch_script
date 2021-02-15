REM               GMT ANIMATION 02
REM
REM Purpose:      Make simple animated GIF of an illuminated DEM grid
REM GMT modules:  math, basemap, text, plot, movie
REM DOS progs:   echo

REM 1. Create files needed in the loop
echo gmt begin > pre.bat
    echo. gmt math -T0/360/10 T 180 ADD = angles.txt >> pre.bat
	echo. gmt makecpt -Crainbow -T500/4500 -H ^> main.cpt >> pre.bat
	echo. gmt grdcut @earth_relief_30s -R-108/-103/35/40 -Gtopo.nc >> pre.bat
echo gmt end >> pre.bat

REM 2. Set up the main frame script
echo gmt begin > main.bat
    echo. gmt math -Q %%MOVIE_WIDTH%% 0.5i SUB = widths  >> main.bat
	echo. set /P width= ^< widths  >> main.bat
	echo. gmt grdimage topo.nc -I+a%%MOVIE_COL0%%+nt2 -JM%%width%% -Cmain.cpt -BWSne -B1 -X0.35i -Y0.3i --FONT_ANNOT_PRIMARY=9p >> main.bat
	echo. echo 256.25 35.6 ^| gmt plot -Sc0.8i -Gwhite -Wthin >> main.bat
	echo. echo 256.25 35.6 %%MOVIE_COL1%% 0.37i ^| gmt plot -Sv0.1i+e -Gred -Wthick >> main.bat
echo gmt end >> main.bat

REM 3. Run the movie
gmt movie main.bat -Sbpre.bat -C3.5ix4.167ix72 -Nanim02 -Tangles.txt -Zs -D6 -A+l
