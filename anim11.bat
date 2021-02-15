REM Blending the NASA day and night views from the Blue and Black Marble mosaic
REM images using a day-night mask set for the summer solstice midnight in Hawaii
REM on June 20, 2020.  In addition, we adjust the colors using the intensities derived
REM from the slopes of the earth relief grid.  We spin around at 24 frames per second
REM where each frame advances the viewpoint 0.25 degrees of longitude.
REM
REM DEM:    @earth_relief_02m
REM Images: @earth_day_02m @earth_night_02m from the GMT data server
REM 
REM The finished movie is available in our YouTube channel as well:
REM https://youtu.be/nmxy9yb2cR8
REM The movie took ~2.75 hour to render on a 24-core MacPro 2013.

REM 1. Create background plot and data files needed in the loop
echo gmt begin > pre.bat
  REM Set view longitudes 0-360 with steps of 0.25 degree
  echo. gmt math -T-180/180/0.25 -o0 T = view.txt >> pre.bat
  REM Make global grid with a smooth 2-degree day/night transition for the 2020 solstice.
  echo. for /f "delims=*" %%%%a in ('gmt solar -C -o0:1 -I+d2020-06-20+z-10') do set sunsolar=%%%%a >> pre.bat
  echo. gmt grdmath -Rd -I2m -rp %%sunsolar%% 2 DAYNIGHT = daynight.grd >> pre.bat
  REM We will create an intensity grid based on a DEM so that we can see structures in the oceans
  echo. gmt grdgradient @earth_relief_02m -Nt0.75 -A45 -Gintens.grd >> pre.bat
  REM Make sure our remote files have been downloaded
  echo. gmt which -Ga @earth_day_02m @earth_night_02m >> pre.bat
echo gmt end >> pre.bat

REM 2. Set up main script
echo gmt begin > main.bat
  REM Let HSV minimum value go to zero and faint map border
  echo. gmt set COLOR_HSV_MIN_V 0 MAP_FRAME_PEN=faint >> main.bat
  REM Blend the day and night Earth images using the weights, so that when w is 1
  REM we get the daytime view, and then adjust colors based on the intensity.
  echo. gmt grdmix @earth_day_02m @earth_night_02m -Wdaynight.grd -Iintens.grd -Gview.tif >> main.bat
  REM Plot this image on an Earth with view from current longitude
  echo. gmt grdimage view.tif -JG%%MOVIE_COL0%%/30N/21.6c -Bafg -X0 -Y0 >> main.bat
echo gmt end >> main.bat

REM 3. Run the movie, requesting a fade in/out via white
gmt movie main.bat -Sbpre.bat -C21.6cx21.6cx50 -Tview.txt -Nanim11 -Lf -Ls"Midnight in Hawaii"+jBR -H8 -Pb+w1c -Fmp4 -V -W -Zs
