using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Lang;
using Toybox.Application;

class CFFfaceView extends WatchUi.WatchFace {
	//used to detect when going into sleep and hide seconds hand
	var sleeping=false;
    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }

    // Update the view
    function onUpdate(dc) {
        // Get the current time and format it correctly
        var timeFormat = "$1$:$2$";
        var clockTime = System.getClockTime();
        var hours = clockTime.hour;
        if (!System.getDeviceSettings().is24Hour) {
            if (hours > 12) {
                hours = hours - 12;
            }
        } else {
            if (Application.getApp().getProperty("UseMilitaryFormat")) {
                timeFormat = "$1$$2$";
                hours = hours.format("%02d");
            }
        }
        var timeString = Lang.format(timeFormat, [hours, clockTime.min.format("%02d")]);

        // Update the view
        var view = View.findDrawableById("TimeLabel");
        view.setColor(Application.getApp().getProperty("ForegroundColor"));
        view.setText(timeString);

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
        
        
        
        
        
        
        
        
        
        		
		var h = clockTime.hour;
		var m = clockTime.min;
		var s = clockTime.sec;
		var c = 120;
		
		
		//for CFF WATCH
		
		//min
		var minCircle = 112;
		var minCircle2 = 30;
		var mdeg =  -(m*360.0/60) - 180 ;
		var mx1 = c + minCircle * Math.sin(Math.toRadians(mdeg-2));
		var my1 = c + minCircle * Math.cos(Math.toRadians(mdeg-2));
		var mx2 = c + minCircle * Math.sin(Math.toRadians(mdeg+2));
		var my2 = c + minCircle * Math.cos(Math.toRadians(mdeg+2));
		var mx3 = c + minCircle2 * Math.sin(Math.toRadians(mdeg+180-12));
		var my3 = c + minCircle2 * Math.cos(Math.toRadians(mdeg+180-12));
		var mx4 = c + minCircle2 * Math.sin(Math.toRadians(mdeg+180+12));
		var my4 = c + minCircle2 * Math.cos(Math.toRadians(mdeg+180+12));
		dc.setColor(Graphics.COLOR_BLACK,Graphics.COLOR_BLACK);
		var mpts = [[mx1,my1],[mx2,my2],[mx3,my3],[mx4,my4]];
		dc.fillPolygon(mpts);
		
		//hours
		
		
		var hrCircle = 74;
		var hrCircle2 = 30;
		var hdeg =  -(h%12*360.0/12 + 30*m/60) - 180;
		var hx1 = c + hrCircle * Math.sin(Math.toRadians(hdeg-3));
		var hy1 = c + hrCircle * Math.cos(Math.toRadians(hdeg-3));
		var hx2 = c + hrCircle * Math.sin(Math.toRadians(hdeg+3));
		var hy2 = c + hrCircle * Math.cos(Math.toRadians(hdeg+3));
		var hx3 = c + hrCircle2 * Math.sin(Math.toRadians(hdeg+180-12));
		var hy3 = c + hrCircle2 * Math.cos(Math.toRadians(hdeg+180-12));
		var hx4 = c + hrCircle2 * Math.sin(Math.toRadians(hdeg+180+12));
		var hy4 = c + hrCircle2 * Math.cos(Math.toRadians(hdeg+180+12));
		dc.setColor(Graphics.COLOR_BLACK,Graphics.COLOR_BLACK);
		var hpts = [[hx1,hy1],[hx2,hy2],[hx3,hy3],[hx4,hy4]];
		dc.fillPolygon(hpts);
		
		
		//sec
		if(!sleeping){
			var secCircle = 72;
			var secCircle2 = 38;
			var sdeg = -(s*360.0/60) - 180 ;
			var sx = c + secCircle * Math.sin(Math.toRadians(sdeg));
			var sy = c + secCircle * Math.cos(Math.toRadians(sdeg));
			var lx = c + secCircle2 * Math.sin(Math.toRadians(sdeg+180));
			var ly = c + secCircle2 * Math.cos(Math.toRadians(sdeg+180));
			dc.setColor(Graphics.COLOR_RED,Graphics.COLOR_RED);
			dc.fillCircle(sx, sy, 9);
			dc.fillCircle(120,120,4);
			dc.setPenWidth(3);
			dc.drawLine(sx,sy,lx,ly);
		}
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    
    
    
    
    
    
    
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {
    
    
    
    
    
    
    
    	sleeping=false;
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
    
    
    
    
    
    
    
    
    
    	sleeping=true;
    }

}
