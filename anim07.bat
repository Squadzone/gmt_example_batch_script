REM Animation of a spinning Earth showing the crustal ages from EarthByte for the oceans
REM and topographic relief on land, with shading given by the global relief and modified
REM by position relative to an artificial sun in the east.  A progress slice is added as well.
REM We add a 1 second fade in and a 1 second fade out for the animation
REM DEM:   @earth_relief_06m
REM Ages:  @earth_age_06m
REM A similar movie was presented at the Fall 2019 AGU meeting in an eLighting talk:
REM P. Wessel, 2019, GMT science animations for the masses, Abstract IN21B-11.
REM The finished movie is available in our YouTube channel as well (without fading):
REM https://youtu.be/KfBwQlyjz5w
REM The movie takes about ~20 minutes to render on a 24-core MacPro 2013.
REM The higher resolution movie on YouTube used the 02m data set resolution.

REM 1. Create background plot and data files needed in the loop
echo gmt begin > pre.bat
	REM Set view and sun longitudes
	echo. gmt math -T-12/372/0.5 -I T 5 SUB = longitudes.txt >> pre.bat
	REM Extract a topography CPT
	echo. gmt makecpt -Cdem2 -T0/6000 -H ^> z.cpt >> pre.bat
	REM Get gradients of the relief from N45E
	echo. gmt grdgradient @earth_relief_06m -Nt1.2 -A45 -Gintens.grd >> pre.bat
echo gmt end >> pre.bat

REM 2. Set up main script
echo gmt begin > main.bat
	REM Let HSV minimum value go to zero and faint map border
	echo. gmt set COLOR_HSV_MIN_V 0 MAP_FRAME_PEN=faint >> main.bat
	REM Fake simulation of sun illumination from east added to relief intensities
	echo. gmt grdmath intens.grd X %%MOVIE_COL1%% SUB SIND 0.8 MUL ADD 0.2 SUB = s.nc >> main.bat
	REM Plot age grid first using EarthByte age cpt
	echo. gmt grdimage @earth_age_06m -Is.nc -JG%%MOVIE_COL0%%/15/10.8c -X0 -Y0 >> main.bat
	REM Clip to expose land areas only
	echo. gmt coast -G -Di >> main.bat
	REM Overlay relief over land only using dem cpt
	echo. gmt grdimage @earth_relief_06m -Is.nc -Cz.cpt >> main.bat
	REM Undo clipping and overlay gridlines
	echo. gmt coast -Q -B30g30 >> main.bat
echo gmt end show >> main.bat

REM 3. Run the movie, requesting a fade in/out via white
gmt movie main.bat -Sbpre.bat -C10.8cx10.8cx100 -Tlongitudes.txt -Nanim07 -Lf -K+gwhite -H8 -Pa+w1c+Gwhite -Fmp4 -V -W -Zs
