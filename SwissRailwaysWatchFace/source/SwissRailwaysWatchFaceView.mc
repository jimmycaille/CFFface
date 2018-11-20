using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Lang;
using Toybox.Application;
using Toybox.Time.Gregorian;
using Toybox.Application.Storage;

class SwissRailwaysWatchFaceView extends WatchUi.WatchFace {
	// blk id : 0044e48fd7a84f1da38efcc5a18d9913 
	// white id : 84d8f63131b445398459b6b0fc7440d4
	// no img : 824920a6-ba4f-43ef-b29f-b0b8a8482025
	//clock design constants
	var c = 120;
	var hrCircle   = 76; //74
	var hrCircle2  = 30;
	var hrDeg      = 3;
	var hrDeg2     = 12;
	var minCircle  = 120; //112
	var minCircle2 = 30;
	var minDeg     = 2;
	var minDeg2    = 12;
	var secCircle  = 78; //72
	var secCircle2 = 38;
	var secWidth   = 3;
	var secRadius1 = 10;//9
	var secRadius2 = 4;
	//used to detect when going into sleep and hide seconds hand
	var sleeping=false;
    function initialize() {
        WatchFace.initialize();
        
        //https://developer.garmin.com/downloads/connect-iq/monkey-c/doc/Toybox/Application/Storage.html
        var int = 0;
        if(Storage has :number){
        	int = Storage.getValue(number);
       	}
        System.println("app launched:"+int);
        int += 1;
        Storage.setValue("number", int);
        
        
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
    	//get the current time
        var clockTime = System.getClockTime();
        
        /*
        //format time correctly
        var timeFormat = "$1$:$2$";
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
        */
        
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
        		
		var h = clockTime.hour;
		var m = clockTime.min;
		var s = clockTime.sec;
		var today = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
		var d     = today.day;
		
		//1min ticks
		for(var i=0;i<360;i+=6){
			var ticCircle1;
			var ticCircle2;
			var ticWidth1;
			var ticWidth2;
			if(i%30==0){
				//5min
				ticCircle1 = 120;
				ticCircle2 = 91;
				ticWidth1  = 1.7;
				ticWidth2  = 2;
				dc.setColor(Application.getApp().getProperty("BigTicksColor"),Application.getApp().getProperty("BigTicksColor"));
			}else{
				//1min
				ticCircle1 = 120;
				ticCircle2 = 112;
				ticWidth1  = 0.5;
				ticWidth2  = 0.5;
				dc.setColor(Application.getApp().getProperty("SmallTicksColor"),Application.getApp().getProperty("SmallTicksColor"));
			}
			var hx1 = c + ticCircle1 * Math.sin(Math.toRadians(i-ticWidth1));
			var hy1 = c + ticCircle1 * Math.cos(Math.toRadians(i-ticWidth1));
			var hx2 = c + ticCircle1 * Math.sin(Math.toRadians(i+ticWidth1));
			var hy2 = c + ticCircle1 * Math.cos(Math.toRadians(i+ticWidth1));
			var hx3 = c + ticCircle2 * Math.sin(Math.toRadians(i+ticWidth2));
			var hy3 = c + ticCircle2 * Math.cos(Math.toRadians(i+ticWidth2));
			var hx4 = c + ticCircle2 * Math.sin(Math.toRadians(i-ticWidth2));
			var hy4 = c + ticCircle2 * Math.cos(Math.toRadians(i-ticWidth2));
			var hpts = [[hx1,hy1],[hx2,hy2],[hx3,hy3],[hx4,hy4]];
			dc.fillPolygon(hpts);
		}
		
		//phone state
		//System.getDeviceSettings().connectionInfo[:bluetooth].state==2?"Connected":System.getDeviceSettings().connectionInfo[:bluetooth].state==1?"Not connected":"Not initialized")
		//System.println("phoneConnected   : " + System.getDeviceSettings().phoneConnected);
		if(true){
			var btState = System.getDeviceSettings().connectionInfo[:bluetooth].state;
			if(btState==0){//Not initialized
				dc.setColor(Graphics.COLOR_RED,Graphics.COLOR_TRANSPARENT);
			}else if(btState==1){//Disconnected
				dc.setColor(Graphics.COLOR_YELLOW,Graphics.COLOR_TRANSPARENT);
			}else if(btState==2){//Connected
				dc.setColor(Graphics.COLOR_GREEN,Graphics.COLOR_TRANSPARENT);
			}
			dc.setPenWidth(1);
			dc.fillRoundedRectangle(80,39,15,24,3);
			dc.setColor(Graphics.COLOR_WHITE,Graphics.COLOR_TRANSPARENT);
			dc.fillRectangle(82,41,11,15);
			dc.fillCircle(87,59,2);
			//dc.drawPoint(59,82);
		}
		
		//notifications
		var notCnt = System.getDeviceSettings().notificationCount;
		if(notCnt > 0){
			//TODO change color
			dc.setColor(Application.getApp().getProperty("CurrentDayColor"),Application.getApp().getProperty("BackgroundColor"));
			dc.drawText(120,52,Graphics.FONT_SYSTEM_XTINY,notCnt,Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);
			dc.setPenWidth(2);
			dc.drawRectangle(105,39,31,23);
			dc.drawLine(105,39,120,44);
			dc.drawLine(120,44,135,39);
		}
		
		//alarms
		var alarmCnt = System.getDeviceSettings().alarmCount;
		if(alarmCnt > 0){
			//TODO change color
			dc.setColor(Application.getApp().getProperty("CurrentDayColor"),Application.getApp().getProperty("BackgroundColor"));
			dc.drawText(158,52,Graphics.FONT_SYSTEM_XTINY,alarmCnt,Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);
			dc.setPenWidth(2);
			dc.drawCircle(158,52,9);
			dc.drawArc(158,52,13,Graphics.ARC_CLOCKWISE,25,-25);
			dc.drawArc(158,52,16,Graphics.ARC_CLOCKWISE,30,-30);
			dc.drawArc(158,52,13,Graphics.ARC_COUNTER_CLOCKWISE,155,205);
			dc.drawArc(158,52,16,Graphics.ARC_COUNTER_CLOCKWISE,150,210);
		}
		
		//altimeter
		var customFont = WatchUi.loadResource(Rez.Fonts.fixedsysSmall);
		if ((Toybox has :SensorHistory) && (Toybox.SensorHistory has :getElevationHistory)) {
	        var iter = Toybox.SensorHistory.getElevationHistory({});
	        var lastVal = iter.next().data.format("%.1f");
			//TODO change color
			dc.setColor(Application.getApp().getProperty("CurrentDayColor"),Application.getApp().getProperty("BackgroundColor"));
	        dc.drawText(35,105,customFont,lastVal+"m",Graphics.TEXT_JUSTIFY_LEFT|Graphics.TEXT_JUSTIFY_VCENTER);
	    }
	    
		//pressure
		if ((Toybox has :SensorHistory) && (Toybox.SensorHistory has :getPressureHistory)) {
	        var iter = Toybox.SensorHistory.getPressureHistory({});
	        var lastVal = (iter.next().data/100.0).format("%.2f");
			//TODO change color
			dc.setColor(Application.getApp().getProperty("CurrentDayColor"),Application.getApp().getProperty("BackgroundColor"));
	        dc.drawText(35,115,customFont,lastVal+"hPa",Graphics.TEXT_JUSTIFY_LEFT|Graphics.TEXT_JUSTIFY_VCENTER);
	    }
		
		//temperature
		if ((Toybox has :SensorHistory) && (Toybox.SensorHistory has :getTemperatureHistory)) {
	        var iter = Toybox.SensorHistory.getTemperatureHistory({});
	        var lastVal = iter.next().data.format("%.1f");
			//TODO change color
			dc.setColor(Application.getApp().getProperty("CurrentDayColor"),Application.getApp().getProperty("BackgroundColor"));
	        dc.drawText(35,125,customFont,lastVal+"°C",Graphics.TEXT_JUSTIFY_LEFT|Graphics.TEXT_JUSTIFY_VCENTER);
	    }
	    
		//heartrate
		if ((Toybox has :SensorHistory) && (Toybox.SensorHistory has :getHeartRateHistory)) {
	        var iter = Toybox.SensorHistory.getHeartRateHistory({});
	        var lastVal = iter.next().data;
			//TODO change color
			dc.setColor(Application.getApp().getProperty("CurrentDayColor"),Application.getApp().getProperty("BackgroundColor"));
	        dc.drawText(35,135,customFont,lastVal+"bpm",Graphics.TEXT_JUSTIFY_LEFT|Graphics.TEXT_JUSTIFY_VCENTER);
	    }
	    
		//day
		if(true){//(Application.getApp().getProperty("ShowCurrentDay")
			dc.setColor(Application.getApp().getProperty("CurrentDayColor"),Graphics.COLOR_TRANSPARENT);
			dc.drawText(192,120,Graphics.FONT_SYSTEM_XTINY,d,Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);
			dc.setPenWidth(2);
			dc.drawRectangle(180,111,25,20);
		}
		
		//battery
		if(true){//(Application.getApp().getProperty("ShowBatteryState")
			var bat = System.getSystemStats().battery;
			
			if(bat>Application.getApp().getProperty("BattLevel1")){
				dc.setColor(Graphics.COLOR_BLUE,Graphics.COLOR_TRANSPARENT);
			}else if(bat>Application.getApp().getProperty("BattLevel2")){
				dc.setColor(Graphics.COLOR_GREEN,Graphics.COLOR_TRANSPARENT);
			}else if(bat>Application.getApp().getProperty("BattLevel3")){
				dc.setColor(Graphics.COLOR_YELLOW,Graphics.COLOR_TRANSPARENT);
			}else if(bat>Application.getApp().getProperty("BattLevel4")){
				dc.setColor(Graphics.COLOR_ORANGE,Graphics.COLOR_TRANSPARENT);
			}else{
				dc.setColor(Graphics.COLOR_RED,Graphics.COLOR_TRANSPARENT);
			}
			dc.setPenWidth(1);
			dc.fillRectangle(99,187,42,18);
			dc.fillRectangle(142,190,3,11);
			
			dc.setColor(Application.getApp().getProperty("BackgroundColor"),Graphics.COLOR_TRANSPARENT);
			dc.drawText(120,195,Graphics.FONT_SYSTEM_XTINY,bat.format("%2d")+"%",Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);
			
		}
		
		//hours
		var hdeg =  -(h%12*360.0/12 + 30*m/60) - 180;
		var hx1 = c + hrCircle * Math.sin(Math.toRadians(hdeg-hrDeg));
		var hy1 = c + hrCircle * Math.cos(Math.toRadians(hdeg-hrDeg));
		var hx2 = c + hrCircle * Math.sin(Math.toRadians(hdeg+hrDeg));
		var hy2 = c + hrCircle * Math.cos(Math.toRadians(hdeg+hrDeg));
		var hx3 = c + hrCircle2 * Math.sin(Math.toRadians(hdeg+180-hrDeg2));
		var hy3 = c + hrCircle2 * Math.cos(Math.toRadians(hdeg+180-hrDeg2));
		var hx4 = c + hrCircle2 * Math.sin(Math.toRadians(hdeg+180+hrDeg2));
		var hy4 = c + hrCircle2 * Math.cos(Math.toRadians(hdeg+180+hrDeg2));
		var hpts = [[hx1,hy1],[hx2,hy2],[hx3,hy3],[hx4,hy4]];
		dc.setColor(Application.getApp().getProperty("HandsColor"),Application.getApp().getProperty("HandsColor"));
		dc.fillPolygon(hpts);
		
		//min
		var mdeg =  -(m*360.0/60) - 180 ;
		var mx1 = c + minCircle * Math.sin(Math.toRadians(mdeg-minDeg));
		var my1 = c + minCircle * Math.cos(Math.toRadians(mdeg-minDeg));
		var mx2 = c + minCircle * Math.sin(Math.toRadians(mdeg+minDeg));
		var my2 = c + minCircle * Math.cos(Math.toRadians(mdeg+minDeg));
		var mx3 = c + minCircle2 * Math.sin(Math.toRadians(mdeg+180-minDeg2));
		var my3 = c + minCircle2 * Math.cos(Math.toRadians(mdeg+180-minDeg2));
		var mx4 = c + minCircle2 * Math.sin(Math.toRadians(mdeg+180+minDeg2));
		var my4 = c + minCircle2 * Math.cos(Math.toRadians(mdeg+180+minDeg2));
		dc.setColor(Application.getApp().getProperty("HandsColor"),Application.getApp().getProperty("HandsColor"));
		var mpts = [[mx1,my1],[mx2,my2],[mx3,my3],[mx4,my4]];
		dc.fillPolygon(mpts);
		if(Application.getApp().getProperty("MinHandContour")){
			dc.setColor(Application.getApp().getProperty("BackgroundColor"),Application.getApp().getProperty("BackgroundColor"));
			dc.setPenWidth(1);
			dc.drawLine(mx1,my1,mx2,my2);
			dc.drawLine(mx2,my2,mx3,my3);
			dc.drawLine(mx3,my3,mx4,my4);
			dc.drawLine(mx4,my4,mx1,my1);
		}
		
		//sec
		if(!sleeping){
			var sdeg = -(s*360.0/60) - 180 ;
			var sx = c + secCircle * Math.sin(Math.toRadians(sdeg));
			var sy = c + secCircle * Math.cos(Math.toRadians(sdeg));
			var lx = c + secCircle2 * Math.sin(Math.toRadians(sdeg+180));
			var ly = c + secCircle2 * Math.cos(Math.toRadians(sdeg+180));
			dc.setColor(Application.getApp().getProperty("SecondsHandColor"),Application.getApp().getProperty("SecondsHandColor"));
			dc.fillCircle(sx, sy, secRadius1);
			dc.fillCircle(120,120,secRadius2);
			dc.setPenWidth(secWidth);
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
