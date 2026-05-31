// src/app/tray_icon.h

#pragma once
#include <QPixmap>
#include <KStatusNotifierItem>

class TrayIcon {
public:
    TrayIcon() {
        item = new KStatusNotifierItem();

        item->setIconByPixmap(QPixmap(":/assets/coffee_dark_on.png"));
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