// tray_icon.cpp

#include <KStatusNotifierItem>

class TrayIcon {
public:
    TrayIcon() {
        item = new KStatusNotifierItem();

        item->setIconByName("assets/coffee_dark_on.png");
        item->setToolTipTitle("Kaffeine on");
        item->setToolTipSubTitle("Screen sleeping is disabled");
        item->setStatus(KStatusNotifierItem::Active);
    }

    KStatusNotifierItem* getItem() const {
        return item;
    }

private:
    KStatusNotifierItem *item;
};