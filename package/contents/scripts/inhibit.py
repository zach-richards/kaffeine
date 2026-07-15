#!/usr/bin/env python3
import sys
print("starting", flush=True)
try:
    import dbus, time, signal
    print("imported dbus", flush=True)

    bus = dbus.SessionBus()
    print("got session bus", flush=True)
    agent = bus.get_object(
        "org.kde.Solid.PowerManagement.PolicyAgent",
        "/org/kde/Solid/PowerManagement/PolicyAgent"
    )
    iface = dbus.Interface(agent, "org.kde.Solid.PowerManagement.PolicyAgent")
    print("got interface", flush=True)

    reason = sys.argv[1] if len(sys.argv) > 1 else "Manual toggle"
    cookie = iface.AddInhibition(1, "kaffeine", reason)
    print(f"cookie:{cookie}", flush=True)

    def cleanup(signum, frame):
        try:
            iface.ReleaseInhibition(cookie)
        except Exception as e:
            print(f"release error: {e}", flush=True)
        sys.exit(0)

    signal.signal(signal.SIGTERM, cleanup)
    signal.signal(signal.SIGINT, cleanup)

    print("entering loop", flush=True)
    while True:
        time.sleep(3600)
except Exception as e:
    import traceback
    traceback.print_exc()
    sys.exit(1)