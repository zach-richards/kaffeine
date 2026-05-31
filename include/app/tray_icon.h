// src/app/tray_icon.h

#pragma once
#include <KStatusNotifierItem>

class TrayIcon {
public:
    TrayIcon() {
        item = new KStatusNotifierItem();
        item->setIconByName("face-smile");
        item->setToolTipTitle("Hello World");
        item->setToolTipSubTitle("This is a tooltip from KStatusNotifierItem.");
        item->setStatus(KStatusNotifierItem::Active);
    }

    KStatusNotifierItem* getItem() const {
        return item;
    }

private:
    KStatusNotifierItem *item;
};