// tray_icon.cpp

#include <KStatusNotifierItem>

class TrayIcon : public KStatusNotifierItem {
    public:
        TrayIcon() {
            setIconByName("face-smile");
            setToolTipTitle("Hello World");
            setToolTipSubTitle("This is a tooltip from KStatusNotifierItem.");
            setStatus(KStatusNotifierItem::Active);
        }
};