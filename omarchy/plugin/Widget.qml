import QtQuick
import Quickshell
import Quickshell.Io
import qs.Commons
import qs.Ui

BarWidget {
  id: root
  moduleName: "jangar.llm-journey"

  readonly property string lj: Quickshell.env("HOME") + "/.local/bin/lj"
  property var stats: ({ streak: 0, due: 0, cards: 0, loggedToday: false })

  function refresh() {
    if (!statusProc.running) statusProc.running = true
  }

  function open(cmd) {
    if (root.bar) root.bar.run("omarchy-launch-floating-terminal-with-presentation " + root.lj + " " + cmd)
  }

  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  // `lj` calls `omarchy-shell jangar.llm-journey refresh` after edits/reviews.
  IpcHandler {
    target: "jangar.llm-journey"
    function refresh(): void { root.broadcast("refresh") }
  }

  Process {
    id: statusProc
    command: [root.lj, "status", "--json"]
    stdout: StdioCollector {
      onStreamFinished: {
        try { root.stats = JSON.parse(this.text) } catch (e) {}
      }
    }
  }

  Timer {
    interval: 600000
    running: true
    repeat: true
    triggeredOnStart: true
    onTriggered: root.refresh()
  }

  WidgetButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    // nf-md-brain, then streak, then due cards when any
    text: "󰧑 " + root.stats.streak + (root.stats.due > 0 ? " · " + root.stats.due : "")
    fontSize: Style.font.caption
    horizontalMargin: 6
    active: !root.stats.loggedToday
    tooltipText: "LLM journey — " + root.stats.streak + "-day streak\n"
      + root.stats.due + "/" + root.stats.cards + " cards due\n"
      + (root.stats.loggedToday ? "Today logged ✓" : "Today not logged yet")
      + "\n\nLeft: today · Right: review · Middle: recall"
    onPressed: function(btn) {
      if (btn === Qt.RightButton) root.open("review")
      else if (btn === Qt.MiddleButton) root.open("recall")
      else root.open("today")
    }
  }
}
