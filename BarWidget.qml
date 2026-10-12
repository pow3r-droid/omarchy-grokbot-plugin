import QtQuick
import Quickshell
import Quickshell.Hyprland
import qs.Commons
import qs.Ui

// Grok Bot badge for the Omarchy 4 bar (community plugin).
// Left click: toggle the special:grokbot panel, or launch Grok Bot if no
// window exists. Right click: always launch / bring up Grok Bot.
// Status comes from Quickshell's event-driven Hyprland toplevel list, so
// there is no polling and no extra daemon.
BarWidget {
  id: root
  moduleName: "pow3r-droid.grokbot"

  readonly property color accent: (typeof Color !== "undefined" && Color.accent) ? Color.accent : "#4fd1ff"
  readonly property bool showDot: setting("showStatusDot", true) !== false
  readonly property string launchCommand: String(setting("launchCommand", "grok-bot"))
  readonly property string iconPath: {
    var p = String(setting("iconPath", "") || "")
    if (p.indexOf("~/") === 0) p = Quickshell.env("HOME") + p.substring(1)
    return p
  }

  readonly property bool hasWindow: {
    var list = Hyprland.toplevels ? Hyprland.toplevels.values : []
    for (var i = 0; i < list.length; i++) {
      var t = list[i]
      var id = ""
      if (t && t.wayland && t.wayland.appId) id = t.wayland.appId
      else if (t && t.lastIpcObject && t.lastIpcObject["class"]) id = t.lastIpcObject["class"]
      if (id === "grok-bot") return true
    }
    return false
  }

  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  function launch() {
    if (root.bar) root.bar.run("setsid -f " + root.launchCommand + " >/dev/null 2>&1")
  }

  function toggle() {
    if (!root.bar) return
    if (root.hasWindow) root.bar.run("hyprctl dispatch 'hl.dsp.workspace.toggle_special(\"grokbot\")'")
    else root.launch()
  }

  BarIconButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    useActiveColor: false
    tooltipText: root.hasWindow ? "Grok Bot" : "Grok Bot (click to launch)"
    onPressed: function(b) {
      if (b === Qt.RightButton) root.launch()
      else root.toggle()
    }

    // Original mark: hexagonal mission-patch outline with an orbit dot.
    iconComponent: Component {
      Item {
        Image {
          visible: root.iconPath !== ""
          anchors.fill: parent
          source: root.iconPath !== "" ? ("file://" + root.iconPath) : ""
          sourceSize.width: width * 2
          sourceSize.height: height * 2
          fillMode: Image.PreserveAspectFit
          smooth: true
        }
        Canvas {
          id: patch
          visible: root.iconPath === ""
          anchors.fill: parent
          property color stroke: button.foreground
          onStrokeChanged: requestPaint()
          onPaint: {
            var c = getContext("2d")
            c.reset()
            var w = width, h = height, cx = w / 2, cy = h / 2
            var r = Math.min(w, h) * 0.46
            c.lineWidth = Math.max(1.2, r * 0.16)
            c.strokeStyle = stroke
            c.beginPath()
            for (var i = 0; i < 6; i++) {
              var a = Math.PI / 6 + i * Math.PI / 3
              var x = cx + r * Math.cos(a), y = cy + r * Math.sin(a)
              if (i === 0) c.moveTo(x, y); else c.lineTo(x, y)
            }
            c.closePath()
            c.stroke()
            // inner slash, an abstract trajectory
            c.beginPath()
            c.moveTo(cx - r * 0.45, cy + r * 0.45)
            c.lineTo(cx + r * 0.45, cy - r * 0.45)
            c.stroke()
          }
        }
        Rectangle {
          visible: root.showDot
          width: Math.max(3, parent.width * 0.26)
          height: width
          radius: width / 2
          anchors.right: parent.right
          anchors.bottom: parent.bottom
          color: root.hasWindow ? root.accent : "transparent"
          border.width: root.hasWindow ? 0 : 1
          border.color: button.foreground
          opacity: root.hasWindow ? 1 : 0.5
        }
      }
    }
  }
}
