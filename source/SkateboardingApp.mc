using Toybox.Application;
using Toybox.WatchUi;
using Toybox.ActivityRecording;
using Toybox.Position;
using Toybox.System;
using Toybox.Timer;
using Toybox.Graphics;

class SkateboardingApp extends Application.AppBase {

    var view;
    var session;
    var timer;
    var startTime;
    var speed = 0;

    function initialize() {
        AppBase.initialize();
    }

    function onStart(state) {

        session = ActivityRecording.createSession({
            :name => "Skateboarding",
            :sport => ActivityRecording.SPORT_GENERIC
        });

        session.start();

        startTime = System.getClockTime();

        view = new SkateView();
        WatchUi.pushView(view, WatchUi.SLIDE_IMMEDIATE);

        timer = new Timer.Timer();
        timer.start(method(:updateData), 1000, true);
    }

    function updateData() {

        var info = Position.getInfo();

        if (info != null && info.speed != null) {
            speed = info.speed * 3.6; // convert to km/h
        }

        var duration = (System.getClockTime() - startTime) / 1000;

        view.setData(speed, duration);
        WatchUi.requestUpdate();
    }

    function onStop(state) {
        timer.stop();
        session.stop();
        session.save();
    }
}

class SkateView extends WatchUi.View {

    var speed = 0;
    var duration = 0;

    function setData(s, t) {
        speed = s;
        duration = t;
    }

    function onUpdate(dc) {

        dc.clear();

        dc.drawText(dc.getWidth()/2, 30, Graphics.FONT_LARGE,
            speed.format("%.1f") + " km/h",
            Graphics.TEXT_JUSTIFY_CENTER);

        dc.drawText(dc.getWidth()/2, 80, Graphics.FONT_MEDIUM,
            "Time: " + duration.toString() + " s",
            Graphics.TEXT_JUSTIFY_CENTER);
    }
}
