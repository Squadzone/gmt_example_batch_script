REM               GMT ANIMATION 01
REM
REM Purpose:      Make web page with simple animated GIF of sine function
REM GMT modules:  math, basemap, text, plot, movie
REM DOS progs:   echo

REM 1. Create files needed in the loop
echo gmt math -T0/360/20 T SIND = sin_point.txt > pre.bat
echo gmt math -T0/360/2 T SIND = sin_curve.txt >> pre.bat
echo gmt begin >> pre.bat
	echo. gmt basemap -R0/360/-1.2/1.6 -JX3.5i/1.65i -X0.35i -Y0.25i -BWSne+glightgreen -Bxa90g90f30+u@. -Bya0.5f0.1g1 --FONT_ANNOT_PRIMARY=9p >> pre.bat
echo gmt end >> pre.bat

REM 2. Set up the main frame script
echo gmt begin > main.bat
REM	Plot smooth blue curve and dark red dots at all angle steps so far
    echo. gmt math -Q %%MOVIE_FRAME%% 10 MUL = lasts  >> main.bat
	echo. set /P last= ^< lasts  >> main.bat
	echo. gmt convert sin_curve.txt -Z0:%%last%% ^| gmt plot -W1p,blue -R0/360/-1.2/1.6 -JX3.5i/1.65i -X0.35i -Y0.25i >> main.bat
	echo. gmt convert sin_point.txt -Z0:%%MOVIE_FRAME%% ^| gmt plot -Sc0.1i -Gdarkred >> main.bat
REM	Plot bright red dot at current angle and annotate
	echo. echo %%MOVIE_COL0%% %%MOVIE_COL1%% ^| gmt plot -Sc0.1i -Gred >> main.bat
	echo. echo 0 1.6 a = %%MOVIE_COL0%% ^| gmt text -F+f14p,Helvetica-Bold+jTL -N -Dj0.1i/0.05i >> main.bat
echo gmt end >> main.bat

REM 3. Run the movie
gmt movie main.bat -Sbpre.bat -C4ix2ix125 -Tsin_point.txt -Zs -Nanim01 -D5 -A+l
