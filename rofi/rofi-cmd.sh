# Prod command
rofi -combi-modi run,drun,ssh -show combi -modi combi -drun-show-actions \
	-font "Iosevka 10" -hide-scrollbar -bw 1 -padding 5 \
	-color-window "#282828, #b8bb26, #ebdbb2" \
	-color-normal "#242424, #ebdbb2, #3c3836, #2a2a2a, #E59C19" \
	-color-active "#b8bb26, #ffffff, #242424, #2a2a2a, #E59C19" \
	-color-urgent "#2a2a2a, #E59C19, #242424, #2a2a2a, #E59C19" \
	-display-combi "launch" -display-run "exec" -display-drun "xdg" \
	-line-margin 2 -width 600 -icon-theme "Papirus" -show-icons -kb-cancel Super_L,Escape

# Debugging command
rofi -combi-modi window,windowcd,run,drun,ssh -show combi -modi combi -drun-show-actions \
	-font "Iosevka 10" -hide-scrollbar -bw 1 -padding 5 \
	-color-window "#282828, #b8bb26, #ebdbb2" \
	-color-normal "#242424, #ebdbb2, #3c3836, #2a2a2a, #E59C19" \
	-color-active "#b8bb26, #ffffff, #242424, #2a2a2a, #E59C19" \
	-color-urgent "#2a2a2a, #E59C19, #242424, #2a2a2a, #E59C19" \
	-display-combi "launch" -display-run "exec" -display-drun "xdg" \
	-line-margin 2 -width 600 -icon-theme "Papirus" -show-icons -kb-cancel Super_L,Escape

rofi -combi-modi drun,ssh -show combi -modi combi -drun-show-actions \
	-font "GohuFont 11" -hide-scrollbar -bw 1 -padding 5 \
	-color-window "#282828, #b8bb26, #ebdbb2" \
	-color-normal "#242424, #ebdbb2, #3c3836, #2a2a2a, #E59C19" \
	-color-active "#b8bb26, #ffffff, #242424, #2a2a2a, #E59C19" \
	-color-urgent "#2a2a2a, #E59C19, #242424, #2a2a2a, #E59C19" \
	-display-combi "launch" -display-run "exec" -display-drun "xdg" \
	-line-margin 2 -width 600 -icon-theme "Papirus" -show-icons -kb-cancel Super_L,Escape


