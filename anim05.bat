REM               GMT ANIMATION 05
REM
REM Purpose:      Make web page with simple animated GIF of gridding
REM GMT modules:  grdcontour, greenspline, plot, text, movie
REM DOS progs:   echo

REM 1. Create files needed in the loop
echo gmt begin > pre.bat
    echo. gmt makecpt -Cpolar -T-25/25 -H ^> t.cpt >> pre.bat
echo gmt end >> pre.bat

REM 2. Set up the main frame script
echo gmt begin > main.bat
    echo. set /a k=%%MOVIE_FRAME%%+1 >> main.bat
    echo. gmt greenspline @Table_5_11.txt -R0/6.5/0/6.5 -I0.05 -Sc -Gt.nc -D1 -Cn%%k%% -Emisfit.txt >> main.bat
	echo. gmt grdcontour t.nc -C25 -A50 -Baf -BWsNE -JX4i -Gl3.6/6.5/4.05/0.75 -X0.25i -Y0.4i >> main.bat
	echo. gmt plot misfit.txt -Ct.cpt -Sc0.15c -Wfaint -i0,1,4 >> main.bat
	echo. echo %%k%% ^| gmt text -F+cTR+jTR+f18p -Dj0.1i -Gwhite -W0.25p >> main.bat
	echo. gmt colorbar -Ct.cpt -DJBC+e -Bxaf -By+l"misfit" >> main.bat
echo gmt end >> main.bat

REM 3. Run the movie
gmt movie main.bat -C4.5ix5.0ix100 -Nanim05 -T@Table_5_11.txt -Sbpre.bat -D10 -Zs -A+l
