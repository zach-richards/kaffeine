// src/app/tray_icon.cpp
#include "../../include/app/trayIcon.h"
#include <QPixmap>

TrayIcon::TrayIcon() {
    item = new KStatusNotifierItem();
    item->setStandardActionsEnabled(false);
    item->setAssociatedWindow(nullptr);
    item->setIconByPixmap(QPixmap(":/assets/coffee_dark_on.png"));
    item->setToolTipTitle("Caffeine on");
    item->setToolTipSubTitle("Screen sleeping is disabled");
    item->setStatus(KStatusNotifierItem::Active);

    QObject::connect(item, &KStatusNotifierItem::activateRequested,
                     [this](bool active, const QPoint &pos) {
                         onClicked();
                     });
}

KStatusNotifierItem* TrayIcon::getItem() const {
    return item;
}

void TrayIcon::onClicked() {
    isOn = !isOn;

    if (isOn) {
        item->setIconByPixmap(QPixmap(":/assets/coffee_dark_on.png"));
        item->setToolTipTitle("Caffeine on");
        item->setToolTipSubTitle("Screen sleeping is disabled");
        item->setStatus(KStatusNotifierItem::Active);
    } else {
        item->setIconByPixmap(QPixmap(":/assets/coffee_dark_off.png"));
        item->setToolTipTitle("Caffeine off");
        item->setToolTipSubTitle("Screen sleeping is enabled");
        item->setStatus(KStatusNotifierItem::Passive);
    }
}