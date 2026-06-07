// tray_icon.cpp
#include <KStatusNotifierItem>

class TrayIcon {
public:
    TrayIcon() {
        item = new KStatusNotifierItem();
        item->setStandardActionsEnabled(false); // disable default click behavior
        item->setAssociatedWindow(nullptr);      // no window to show/hide

        item->setIconByName("assets/coffee_dark_on.png");
        item->setToolTipTitle("Caffeine on");
        item->setToolTipSubTitle("Screen sleeping is disabled");
        item->setStatus(KStatusNotifierItem::Active);

        QObject::connect(item, &KStatusNotifierItem::activateRequested,
                         [this](bool active, const QPoint &pos) {
                             onClicked();
                         });
    }

    KStatusNotifierItem* getItem() const {
        return item;
    }

private:
    KStatusNotifierItem *item;
    bool isOn = true;

    void onClicked() {
        isOn = !isOn;  // toggle first

        if (isOn) {
            item->setIconByName("assets/coffee_dark_on.png");
            item->setToolTipTitle("Caffeine on");
            item->setToolTipSubTitle("Screen sleeping is disabled");
            item->setStatus(KStatusNotifierItem::Active);
        } else {
            item->setIconByName("assets/coffee_dark_off.png");
            item->setToolTipTitle("Caffeine off");
            item->setToolTipSubTitle("Screen sleeping is enabled");
            item->setStatus(KStatusNotifierItem::Passive);
        }
    }
};