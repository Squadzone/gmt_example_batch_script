REM               GMT ANIMATION 04
REM
REM Purpose:      Make custom 480p movie of NY to Miami flight
REM GMT modules:  set, grdgradient, grdimage, makecpt, project, plot, movie
REM DOS progs:   echo

REM 1. Create files needed in the loop
echo gmt begin > pre.bat
    echo. gmt project -C-73.8333/40.75 -E-80.133/25.75 -G10 -Q ^> flight_path.txt >> pre.bat
	echo. gmt grdcut @earth_relief_02m -R-100/-70/10/50 -GUSEast_Coast.nc >> pre.bat
	echo. gmt grdgradient USEast_Coast.nc -A90 -Nt1 -Gint_US.nc >> pre.bat
	echo. gmt makecpt -Cglobe -H ^> globe_US.cpt >> pre.bat
echo gmt end >> pre.bat

REM 2. Set up the main frame script
echo gmt begin > main.bat
    echo. gmt grdimage -JG%%MOVIE_COL0%%/%%MOVIE_COL1%%/160/210/55/0/36/34/%%MOVIE_WIDTH%%+du -Rg USEast_Coast.nc -Iint_US.nc -Cglobe_US.cpt -X0 -Y0 >> main.bat
	echo. gmt plot -W1p flight_path.txt >> main.bat
echo gmt end >> main.bat

REM 3. Run the movie
gmt movie main.bat -C7.2ix4.8ix100 -Nanim04 -Tflight_path.txt -Sbpre.bat -Zs -H2 -Lf+o0.1i+f14p,Helvetica-Bold -Fmp4 -A+l+s10
