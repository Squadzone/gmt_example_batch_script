REM               GMT ANIMATION 03
REM
REM Purpose:      Make web page with simple animated GIF of Iceland topo
REM GMT modules:  grdclip, grdgradient, makecpt, grdview, movie
REM DOS progs:   echo

REM 1. Create files needed in the loop
echo gmt begin > pre.bat
    echo. gmt math -T0/355/5 -o1 T = angles.txt >> pre.bat
	echo. gmt makecpt -Crelief -T-2000/2000/20 -H ^> iceland.cpt >> pre.bat
	echo. gmt grdclip @earth_relief_02m -R-26/-12/63/67 -Sb0/-1 -Gabove.nc >> pre.bat
echo gmt end >> pre.bat

REM 2. Set up the main frame script
echo gmt begin > main.bat
    echo. gmt grdview above.nc -R-26/-12/63/67 -JM2.5i -Ciceland.cpt -Qi100 -Bafg -X0.5i -Y0.5i -p%%MOVIE_COL0%%/35+w20W/65N+v1.5i/0.75i >> main.bat
echo gmt end >> main.bat

REM 3. Run the movie
gmt movie main.bat -C4ix2.5ix100 -Nanim03 -Tangles.txt -Sbpre.bat -D10 -Pb -Zs -A+l
